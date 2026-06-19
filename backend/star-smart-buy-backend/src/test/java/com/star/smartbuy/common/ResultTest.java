package com.star.smartbuy.common;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Result 统一响应测试
 */
class ResultTest {

    @Test
    void testSuccess_WithData() {
        Result<String> result = Result.success("hello");
        assertEquals(200, result.getCode());
        assertEquals("success", result.getMessage());
        assertEquals("hello", result.getData());
    }

    @Test
    void testSuccess_NoData() {
        Result<Void> result = Result.success();
        assertEquals(200, result.getCode());
        assertNull(result.getData());
    }

    @Test
    void testError_WithMessage() {
        Result<Void> result = Result.error("操作失败");
        assertEquals(500, result.getCode());
        assertEquals("操作失败", result.getMessage());
    }

    @Test
    void testError_WithCode() {
        Result<Void> result = Result.error(401, "未授权");
        assertEquals(401, result.getCode());
        assertEquals("未授权", result.getMessage());
    }
}
