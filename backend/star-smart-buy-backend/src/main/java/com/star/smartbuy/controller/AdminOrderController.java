package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.service.OrderService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

/**
 * 订单管理控制器（后台管理）
 */
@RestController
@RequestMapping("/admin/orders")
public class AdminOrderController {

    @Resource private OrderService orderService;

    /** 订单列表 */
    @GetMapping
    public Result<Map<String, Object>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword) {
        return Result.success(orderService.getAllOrders(page, size, status, keyword));
    }

    /** 发货 */
    @PutMapping("/{id}/ship")
    @OperLog(module = "ORDER", type = "UPDATE", description = "订单发货")
    public Result<Void> ship(@PathVariable Long id) {
        orderService.shipOrder(id);
        return Result.success();
    }
}