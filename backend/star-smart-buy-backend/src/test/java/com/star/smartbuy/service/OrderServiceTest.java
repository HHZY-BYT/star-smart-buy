package com.star.smartbuy.service;

import com.star.smartbuy.common.BusinessException;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import jakarta.annotation.Resource;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 订单服务测试
 */
@SpringBootTest
@ActiveProfiles("test")
class OrderServiceTest {

    @Resource
    private OrderService orderService;

    @Test
    void testGetOrderDetail_NotFound() {
        assertThrows(BusinessException.class, () ->
                orderService.getOrderDetail(-1L));
    }

    @Test
    void testGetUserOrders_ReturnsPagination() {
        var result = orderService.getUserOrders(1L, 1, 10, null);
        assertNotNull(result);
        assertTrue(result.containsKey("total"));
        assertTrue(result.containsKey("records"));
    }

    @Test
    void testCancelOrder_NotFound() {
        assertThrows(BusinessException.class, () ->
                orderService.cancelOrder(-1L, 1L));
    }

    @Test
    void testPayOrder_NotFound() {
        assertThrows(BusinessException.class, () ->
                orderService.payOrder(-1L, 1L));
    }

    @Test
    void testGetOrderCounts() {
        var counts = orderService.getOrderCounts(1L);
        assertNotNull(counts);
        assertTrue(counts.containsKey("pending"));
        assertTrue(counts.containsKey("paid"));
        assertTrue(counts.containsKey("shipped"));
        assertTrue(counts.containsKey("completed"));
    }
}
