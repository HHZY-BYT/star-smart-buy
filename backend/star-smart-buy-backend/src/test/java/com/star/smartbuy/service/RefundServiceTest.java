package com.star.smartbuy.service;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import jakarta.annotation.Resource;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 退款服务测试
 */
@SpringBootTest
@ActiveProfiles("test")
class RefundServiceTest {

    @Resource
    private RefundService refundService;

    @Test
    void testGetRefundStats() {
        var stats = refundService.getRefundStats();
        assertNotNull(stats);
        assertTrue(stats.containsKey("total"));
        assertTrue(stats.containsKey("pending"));
        assertTrue(stats.containsKey("approved"));
        assertTrue(stats.containsKey("rejected"));
    }
}
