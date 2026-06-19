package com.star.smartbuy.controller;

import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.dto.CreateOrderDTO;
import com.star.smartbuy.entity.Order;
import com.star.smartbuy.service.OrderService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

/**
 * 订单控制器
 */
@RestController
@RequestMapping("/orders")
public class OrderController {

    @Resource private OrderService orderService;

    /** 创建订单 */
    @PostMapping
    public Result<Order> create(@RequestAttribute("userId") Long userId,
                                 @RequestBody CreateOrderDTO dto) {
        return Result.success(orderService.createOrder(userId, dto));
    }

    /** 我的订单列表 */
    @GetMapping
    public Result<?> list(@RequestAttribute(value = "userId", required = false) Long userId,
                          @RequestParam(defaultValue = "1") int page,
                          @RequestParam(defaultValue = "10") int size,
                          @RequestParam(required = false) Integer status) {
        if (userId == null) {
            return Result.success(PageResult.of(0L, page, size, java.util.List.of()));
        }
        return Result.success(orderService.getUserOrders(userId, page, size, status));
    }

    /** 订单详情 */
    @GetMapping("/{id}")
    public Result<Map<String, Object>> detail(@PathVariable Long id) {
        return Result.success(orderService.getOrderDetail(id));
    }

    /** 取消订单 */
    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@RequestAttribute("userId") Long userId,
                                @PathVariable Long id) {
        orderService.cancelOrder(id, userId);
        return Result.success();
    }

    /** 模拟支付 */
    @PutMapping("/{id}/pay")
    public Result<Void> pay(@RequestAttribute("userId") Long userId,
                             @PathVariable Long id) {
        orderService.payOrder(id, userId);
        return Result.success();
    }

    /** 确认收货 */
    @PutMapping("/{id}/confirm")
    public Result<Void> confirm(@RequestAttribute("userId") Long userId,
                                 @PathVariable Long id) {
        orderService.confirmOrder(id, userId);
        return Result.success();
    }

    /** 用户各状态订单数量 */
    @GetMapping("/counts")
    public Result<Map<String, Object>> counts(@RequestAttribute("userId") Long userId) {
        return Result.success(orderService.getOrderCounts(userId));
    }

    /** 用户删除订单 */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@RequestAttribute("userId") Long userId,
                                @PathVariable Long id) {
        orderService.deleteOrder(id, userId);
        return Result.success();
    }

    /** 用户申请退款 */
    @PostMapping("/{id}/refund")
    public Result<Map<String, Object>> applyRefund(@RequestAttribute("userId") Long userId,
                                                     @PathVariable Long id,
                                                     @RequestBody Map<String, String> data) {
        String reason = data.getOrDefault("reason", "");
        String description = data.getOrDefault("description", "");
        return Result.success(orderService.applyRefund(id, userId, reason, description));
    }
}