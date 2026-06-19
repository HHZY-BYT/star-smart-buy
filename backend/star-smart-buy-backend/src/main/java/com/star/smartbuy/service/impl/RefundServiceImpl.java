package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.entity.*;
import com.star.smartbuy.mapper.*;
import com.star.smartbuy.service.RefundService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 退款服务实现
 * <p>
 * 从 AdminRefundController 中抽取出来的独立 Service 层，
 * 将退款处理、库存恢复、订单状态更新放在同一个 @Transactional 中保证数据一致性。
 * </p>
 */
@Slf4j
@Service
public class RefundServiceImpl implements RefundService {

    @Resource private RefundMapper refundMapper;
    @Resource private OrderMapper orderMapper;
    @Resource private OrderItemMapper orderItemMapper;
    @Resource private ProductMapper productMapper;

    /** 同意退款：更新退款状态 + 订单状态 + 恢复库存（事务性） */
    @Override
    @Transactional
    public void processRefund(Long refundId, String reason) {
        Refund refund = refundMapper.selectById(refundId);
        if (refund == null) {
            throw new BusinessException("退款记录不存在");
        }

        refund.setStatus(1);
        refund.setProcessTime(LocalDateTime.now());
        if (reason != null) {
            refund.setProcessNote(reason);
        }
        refundMapper.updateById(refund);

        // 更新订单状态为已退货
        Order order = orderMapper.selectById(refund.getOrderId());
        if (order != null) {
            order.setStatus(5);
            order.setUpdatedAt(LocalDateTime.now());
            orderMapper.updateById(order);

            // 恢复库存
            LambdaQueryWrapper<OrderItem> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(OrderItem::getOrderId, order.getId());
            List<OrderItem> items = orderItemMapper.selectList(wrapper);
            for (OrderItem item : items) {
                Product product = productMapper.selectById(item.getProductId());
                if (product != null) {
                    product.setStock(product.getStock() + item.getQuantity());
                    productMapper.updateById(product);
                }
            }
        }

        log.info("退款处理完成: refundId={}, orderId={}", refundId, refund.getOrderId());
    }

    /** 拒绝退款 */
    @Override
    @Transactional
    public void rejectRefund(Long refundId, String reason) {
        Refund refund = refundMapper.selectById(refundId);
        if (refund == null) {
            throw new BusinessException("退款记录不存在");
        }

        refund.setStatus(2);
        refund.setProcessNote(reason);
        refund.setProcessTime(LocalDateTime.now());
        refundMapper.updateById(refund);

        log.info("退款已拒绝: refundId={}", refundId);
    }

    /** 退款统计 */
    @Override
    public Map<String, Object> getRefundStats() {
        Long total = refundMapper.selectCount(null);
        Long pending = refundMapper.selectCount(
                new LambdaQueryWrapper<Refund>().eq(Refund::getStatus, 0));
        Long approved = refundMapper.selectCount(
                new LambdaQueryWrapper<Refund>().eq(Refund::getStatus, 1));
        Long rejected = refundMapper.selectCount(
                new LambdaQueryWrapper<Refund>().eq(Refund::getStatus, 2));

        Map<String, Object> stats = new HashMap<>();
        stats.put("total", total);
        stats.put("pending", pending);
        stats.put("approved", approved);
        stats.put("rejected", rejected);
        return stats;
    }
}
