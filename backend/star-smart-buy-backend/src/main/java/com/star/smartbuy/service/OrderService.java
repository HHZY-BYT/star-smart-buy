package com.star.smartbuy.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.star.smartbuy.dto.AiChatDTO;
import com.star.smartbuy.dto.CreateOrderDTO;
import com.star.smartbuy.entity.Order;
import com.star.smartbuy.entity.OrderItem;
import com.star.smartbuy.entity.ShoppingCart;

import java.util.List;
import java.util.Map;

/**
 * 订单服务接口
 */
public interface OrderService {

    /** 创建订单 */
    Order createOrder(Long userId, CreateOrderDTO dto);

    /** 获取我的订单列表 */
    Map<String, Object> getUserOrders(Long userId, int page, int size, Integer status);

    /** 获取订单详情 */
    Map<String, Object> getOrderDetail(Long orderId);

    /** 取消订单 */
    void cancelOrder(Long orderId, Long userId);

    /** 模拟支付 */
    void payOrder(Long orderId, Long userId);

    /** 确认收货 */
    void confirmOrder(Long orderId, Long userId);

    /** 管理员查看所有订单 */
    Map<String, Object> getAllOrders(int page, int size, Integer status, String keyword);

    /** 管理员发货 */
    void shipOrder(Long orderId);

    /** 获取用户各状态订单数量 */
    Map<String, Object> getOrderCounts(Long userId);

    /** 用户删除订单（已取消/已完成的订单） */
    void deleteOrder(Long orderId, Long userId);

    /** 用户申请退款 */
    Map<String, Object> applyRefund(Long orderId, Long userId, String reason, String description);
}