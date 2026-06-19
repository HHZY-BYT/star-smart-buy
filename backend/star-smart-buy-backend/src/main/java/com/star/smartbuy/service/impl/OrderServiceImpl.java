package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.dto.CreateOrderDTO;
import com.star.smartbuy.entity.*;
import com.star.smartbuy.mapper.*;
import com.star.smartbuy.config.NotificationWebSocketHandler;
import com.star.smartbuy.service.OrderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 订单服务实现
 * <p>
 * 核心改进：
 * 1. 使用 BusinessException 替换 RuntimeException，提供精确的业务错误码
 * 2. 使用 @Slf4j 结构化日志替换 System.err.println
 * 3. 提取 sendNotify 公共方法消除 7 处重复的 WebSocket 通知代码
 * 4. getUserOrders 批量查询 orderItem（消除 N+1）
 * 5. 提取 buildOrderMap 公共方法统一订单 Map 构造
 * </p>
 */
@Slf4j
@Service
public class OrderServiceImpl extends ServiceImpl<OrderMapper, Order> implements OrderService {

    @Resource private OrderItemMapper orderItemMapper;
    @Resource private ShoppingCartMapper cartMapper;
    @Resource private AddressMapper addressMapper;
    @Resource private ProductMapper productMapper;
    @Resource private RefundMapper refundMapper;
    @Resource private ProductSpecMapper specMapper;

    /** 创建订单 */
    @Transactional
    @Override
    public Order createOrder(Long userId, CreateOrderDTO dto) {
        Address address = addressMapper.selectById(dto.getAddressId());
        if (address == null) {
            throw new BusinessException("收货地址不存在");
        }

        if (dto.getItems() == null || dto.getItems().isEmpty()) {
            throw new BusinessException("订单商品不能为空");
        }

        String orderNo = "ORD" + System.currentTimeMillis();

        Order order = new Order();
        order.setOrderNo(orderNo);
        order.setUserId(userId);
        order.setTotalAmount(0.0);
        order.setStatus(0);
        order.setAddress(address.getProvince() + address.getCity() + address.getDistrict() + address.getDetail());
        order.setConsignee(address.getReceiver());
        order.setPhone(address.getPhone());
        order.setRemark(dto.getRemark());
        order.setCreatedAt(LocalDateTime.now());
        order.setUpdatedAt(LocalDateTime.now());
        this.save(order);

        double total = 0;
        for (CreateOrderDTO.OrderItemDTO itemDTO : dto.getItems()) {
            Product product = productMapper.selectById(itemDTO.getProductId());
            if (product == null || product.getStatus() != 1) {
                throw new BusinessException("商品[ID=" + itemDTO.getProductId() + "]不存在或已下架");
            }
            if (product.getStock() < itemDTO.getQuantity()) {
                throw new BusinessException("商品[" + product.getName() + "]库存不足");
            }

            product.setStock(product.getStock() - itemDTO.getQuantity());
            productMapper.updateById(product);

            OrderItem item = new OrderItem();
            item.setOrderId(order.getId());
            item.setProductId(product.getId());
            item.setProductName(product.getName());
            item.setPrice(product.getPrice());
            item.setQuantity(itemDTO.getQuantity());
            item.setSubtotal(product.getPrice() * itemDTO.getQuantity());

            // 保存商品图片（优先用前端传入的，否则从商品表取第一张）
            String img = itemDTO.getProductImage();
            if (img == null || img.isEmpty()) {
                img = product.getImages();
                if (img != null && img.contains(",")) {
                    img = img.split(",")[0].trim();
                }
            }
            item.setProductImage(img);

            // 处理多规格
            String specIdsStr = itemDTO.getSpecIds();
            if (specIdsStr != null && !specIdsStr.isEmpty()) {
                item.setSpecIds(specIdsStr);
                StringBuilder nameBuilder = new StringBuilder();
                StringBuilder valueBuilder = new StringBuilder();
                for (String idStr : specIdsStr.split(",")) {
                    try {
                        ProductSpec spec = specMapper.selectById(Long.parseLong(idStr.trim()));
                        if (spec != null) {
                            if (nameBuilder.length() > 0) nameBuilder.append(";");
                            nameBuilder.append(spec.getSpecName());
                            if (valueBuilder.length() > 0) valueBuilder.append(";");
                            valueBuilder.append(spec.getSpecValue());
                        }
                    } catch (NumberFormatException ignored) {}
                }
                item.setSpecName(nameBuilder.toString());
                item.setSpecValue(valueBuilder.toString());
            } else if (itemDTO.getSpecId() != null) {
                // 兼容旧的单规格逻辑
                ProductSpec spec = specMapper.selectById(itemDTO.getSpecId());
                if (spec != null) {
                    item.setSpecIds(String.valueOf(spec.getId()));
                    item.setSpecName(spec.getSpecName());
                    item.setSpecValue(spec.getSpecValue());
                }
            }

            orderItemMapper.insert(item);
            total += item.getSubtotal();
        }

        if (dto.getCartIds() != null && !dto.getCartIds().isEmpty()) {
            for (Long cartId : dto.getCartIds()) {
                cartMapper.deleteById(cartId);
            }
        }

        order.setTotalAmount(total);
        this.updateById(order);

        sendNotify("新订单通知", "用户下单，订单号：" + order.getOrderNo() + "，金额：¥" + total, "order", order.getId());

        log.info("订单创建成功: orderNo={}, userId={}, amount={}", orderNo, userId, total);
        return order;
    }

    /**
     * 获取我的订单列表
     * <p>
     * 性能优化：先用一个 IN 查询批量加载所有订单的明细项，
     * 然后用 Java groupingBy 分组匹配，将 N 次 SQL 减少为 1 次。
     * </p>
     */
    @Override
    public Map<String, Object> getUserOrders(Long userId, int page, int size, Integer status) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        if (status != null) wrapper.eq(Order::getStatus, status);
        wrapper.orderByDesc(Order::getCreatedAt);

        Page<Order> pageResult = this.page(new Page<>(page, size), wrapper);

        // 批量查 orderItem (消除 N+1)，并补全缺失的商品图片
        Map<Long, List<OrderItem>> itemMap = Map.of();
        if (!pageResult.getRecords().isEmpty()) {
            Set<Long> orderIds = pageResult.getRecords().stream()
                    .map(Order::getId).collect(Collectors.toSet());
            List<OrderItem> allItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds));
            // 补全缺失的图片
            fillMissingImages(allItems);
            itemMap = allItems.stream().collect(Collectors.groupingBy(OrderItem::getOrderId));
        }

        List<Map<String, Object>> records = new ArrayList<>();
        for (Order order : pageResult.getRecords()) {
            Map<String, Object> map = buildOrderMap(order);
            map.put("items", itemMap.getOrDefault(order.getId(), List.of()));
            records.add(map);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("total", pageResult.getTotal());
        result.put("page", page);
        result.put("size", size);
        result.put("records", records);
        return result;
    }

    /** 获取订单详情 */
    @Override
    public Map<String, Object> getOrderDetail(Long orderId) {
        Order order = this.getById(orderId);
        if (order == null) throw new BusinessException("订单不存在");

        Map<String, Object> result = buildOrderMap(order);

        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(wrapper);
        fillMissingImages(items);
        result.put("items", items);

        LambdaQueryWrapper<Refund> refundWrapper = new LambdaQueryWrapper<>();
        refundWrapper.eq(Refund::getOrderId, orderId).orderByDesc(Refund::getCreatedAt).last("LIMIT 1");
        Refund refund = refundMapper.selectOne(refundWrapper);
        if (refund != null) {
            result.put("refundStatus", refund.getStatus());
            result.put("refundId", refund.getId());
            result.put("refundReason", refund.getReason());
        }

        return result;
    }

    /** 取消订单 */
    @Override
    @Transactional
    public void cancelOrder(Long orderId, Long userId) {
        Order order = this.getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getStatus() != 0) {
            throw new BusinessException("只有待付款订单可以取消");
        }
        order.setStatus(4);
        order.setUpdatedAt(LocalDateTime.now());
        this.updateById(order);

        sendNotify("订单取消通知", "订单号：" + order.getOrderNo() + " 已被用户取消", "order", order.getId());
    }

    /** 模拟支付 */
    @Override
    @Transactional
    public void payOrder(Long orderId, Long userId) {
        Order order = this.getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getStatus() != 0) {
            throw new BusinessException("只有待付款订单可以支付");
        }
        order.setStatus(1);
        order.setPayTime(LocalDateTime.now());
        order.setUpdatedAt(LocalDateTime.now());
        this.updateById(order);

        sendNotify("订单支付通知", "订单号：" + order.getOrderNo() + " 已支付，金额：¥" + order.getTotalAmount(), "order", order.getId());
    }

    /** 确认收货 */
    @Override
    @Transactional
    public void confirmOrder(Long orderId, Long userId) {
        Order order = this.getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        if (order.getStatus() != 2) {
            throw new BusinessException("只有已发货订单可以确认收货");
        }
        order.setStatus(3);
        order.setUpdatedAt(LocalDateTime.now());
        this.updateById(order);

        sendNotify("确认收货通知", "订单号：" + order.getOrderNo() + " 用户已确认收货", "order", order.getId());
    }

    /** 管理员查看所有订单（含订单商品明细） */
    @Override
    public Map<String, Object> getAllOrders(int page, int size, Integer status, String keyword) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        if (status != null) wrapper.eq(Order::getStatus, status);
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(Order::getOrderNo, keyword)
                    .or()
                    .like(Order::getConsignee, keyword)
                    .or()
                    .like(Order::getPhone, keyword));
        }
        wrapper.orderByDesc(Order::getCreatedAt);

        Page<Order> pageResult = this.page(new Page<>(page, size), wrapper);

        // 批量查询订单商品项（消除 N+1，与 getUserOrders 一致）
        Map<Long, List<OrderItem>> itemMap = Map.of();
        if (!pageResult.getRecords().isEmpty()) {
            Set<Long> orderIds = pageResult.getRecords().stream()
                    .map(Order::getId).collect(Collectors.toSet());
            List<OrderItem> allItems = orderItemMapper.selectList(
                    new LambdaQueryWrapper<OrderItem>().in(OrderItem::getOrderId, orderIds));
            fillMissingImages(allItems);
            itemMap = allItems.stream().collect(Collectors.groupingBy(OrderItem::getOrderId));
        }

        List<Map<String, Object>> records = new ArrayList<>();
        for (Order order : pageResult.getRecords()) {
            Map<String, Object> map = buildOrderMap(order);
            map.put("items", itemMap.getOrDefault(order.getId(), List.of()));
            records.add(map);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("total", pageResult.getTotal());
        result.put("page", page);
        result.put("size", size);
        result.put("records", records);
        return result;
    }

    /** 管理员发货 */
    @Override
    @Transactional
    public void shipOrder(Long orderId) {
        Order order = this.getById(orderId);
        if (order == null) throw new BusinessException("订单不存在");
        order.setStatus(2);
        order.setUpdatedAt(LocalDateTime.now());
        this.updateById(order);

        sendNotify("订单发货通知", "订单号：" + order.getOrderNo() + " 已发货", "order", order.getId());
    }

    /** 获取用户各状态订单数量 */
    @Override
    public Map<String, Object> getOrderCounts(Long userId) {
        Map<String, Object> counts = new HashMap<>();
        counts.put("pending", this.count(new LambdaQueryWrapper<Order>().eq(Order::getUserId, userId).eq(Order::getStatus, 0)));
        counts.put("paid", this.count(new LambdaQueryWrapper<Order>().eq(Order::getUserId, userId).eq(Order::getStatus, 1)));
        counts.put("shipped", this.count(new LambdaQueryWrapper<Order>().eq(Order::getUserId, userId).eq(Order::getStatus, 2)));
        counts.put("completed", this.count(new LambdaQueryWrapper<Order>().eq(Order::getUserId, userId).eq(Order::getStatus, 3)));
        return counts;
    }

    /** 用户删除订单 */
    @Override
    @Transactional
    public void deleteOrder(Long orderId, Long userId) {
        Order order = this.getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }
        Integer status = order.getStatus();
        if (status == null || (status != 3 && status != 4 && status != 5)) {
            throw new BusinessException("只有已完成、已取消或已退货的订单可以删除");
        }
        refundMapper.delete(new LambdaQueryWrapper<Refund>().eq(Refund::getOrderId, orderId));
        orderItemMapper.delete(new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, orderId));
        this.removeById(orderId);

        sendNotify("订单删除通知", "订单号：" + order.getOrderNo() + " 已被用户删除", "order", orderId);
    }

    /** 用户申请退款 */
    @Override
    @Transactional
    public Map<String, Object> applyRefund(Long orderId, Long userId, String reason, String description) {
        Order order = this.getById(orderId);
        if (order == null || !order.getUserId().equals(userId)) {
            throw new BusinessException("订单不存在");
        }

        if (order.getStatus() != 1 && order.getStatus() != 2) {
            throw new BusinessException("当前订单状态不支持退款申请");
        }

        Long existingCount = refundMapper.selectCount(
            new LambdaQueryWrapper<Refund>()
                .eq(Refund::getOrderId, orderId)
                .ne(Refund::getStatus, 2)
        );
        if (existingCount > 0) {
            throw new BusinessException("该订单已有退款申请，请勿重复提交");
        }

        Map<String, Object> result = new HashMap<>();

        boolean isQuickRefund = false;
        if (order.getStatus() == 1 && order.getPayTime() != null) {
            long hoursDiff = Duration.between(order.getPayTime(), LocalDateTime.now()).toHours();
            if (hoursDiff < 24) {
                isQuickRefund = true;
            }
        }

        Refund refund = new Refund();
        refund.setOrderId(orderId);
        refund.setOrderNo(order.getOrderNo());
        refund.setUserId(userId);
        refund.setAmount(BigDecimal.valueOf(order.getTotalAmount()));
        refund.setReason(reason);
        refund.setDescription(description);

        if (isQuickRefund) {
            refund.setStatus(1);
            refund.setProcessTime(LocalDateTime.now());
            refund.setProcessNote("系统自动同意：付款24小时内快速退款");

            order.setStatus(5);
            order.setUpdatedAt(LocalDateTime.now());
            this.updateById(order);

            restoreStock(orderId);

            result.put("type", "quick");
            result.put("message", "退款申请已自动通过，款项将在1-3个工作日内退回");
        } else {
            refund.setStatus(0);

            sendNotify("退款申请通知", "用户申请退款，订单号：" + order.getOrderNo() + "，金额：¥" + order.getTotalAmount(), "refund", orderId);

            result.put("type", "apply");
            result.put("message", "退款申请已提交，请等待管理员审核");
        }

        refundMapper.insert(refund);
        result.put("refundId", refund.getId());

        return result;
    }

    /** 恢复商品库存 */
    private void restoreStock(Long orderId) {
        LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(OrderItem::getOrderId, orderId);
        List<OrderItem> items = orderItemMapper.selectList(wrapper);

        for (OrderItem item : items) {
            Product product = productMapper.selectById(item.getProductId());
            if (product != null) {
                product.setStock(product.getStock() + item.getQuantity());
                productMapper.updateById(product);
            }
        }
    }

    /**
     * 补全订单项中缺失的商品图片（从商品表查询）
     */
    private void fillMissingImages(List<OrderItem> items) {
        if (items == null) return;
        for (OrderItem item : items) {
            if (item.getProductImage() == null || item.getProductImage().isEmpty()) {
                Product product = productMapper.selectById(item.getProductId());
                if (product != null && product.getImages() != null && !product.getImages().isEmpty()) {
                    String img = product.getImages();
                    if (img.contains(",")) {
                        img = img.split(",")[0].trim();
                    }
                    item.setProductImage(img);
                }
            }
        }
    }

    // ======== 提取的公共方法 ========

    /**
     * 构建订单 Map（统一 Order → Map 转换，消除重复代码）
     */
    private Map<String, Object> buildOrderMap(Order order) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", order.getId());
        map.put("orderNo", order.getOrderNo());
        map.put("userId", order.getUserId());
        map.put("totalAmount", order.getTotalAmount());
        map.put("status", order.getStatus());
        map.put("address", order.getAddress());
        map.put("consignee", order.getConsignee());
        map.put("phone", order.getPhone());
        map.put("remark", order.getRemark());
        map.put("payTime", order.getPayTime());
        map.put("createdAt", order.getCreatedAt());
        return map;
    }

    /**
     * 发送 WebSocket 通知（失败不影响主流程）
     * <p>
     * 统一了原来散落在 7 个方法中的 try-catch-System.err 通知代码。
     * 通知推送失败仅记录 warn 日志，不抛出异常影响业务操作。
     * </p>
     */
    private void sendNotify(String title, String content, String type, Long relatedId) {
        try {
            Notification notification = new Notification();
            notification.setTitle(title);
            notification.setContent(content);
            notification.setType(type);
            notification.setRelatedId(relatedId);
            NotificationWebSocketHandler.sendNotification(1L, notification);
        } catch (Exception e) {
            log.warn("通知推送失败: {}", e.getMessage());
        }
    }
}