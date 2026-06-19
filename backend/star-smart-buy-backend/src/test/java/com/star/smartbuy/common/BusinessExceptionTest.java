package com.star.smartbuy.common;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * BusinessException 业务异常测试
 */
class BusinessExceptionTest {

    @Test
    void testDefaultCode() {
        BusinessException e = new BusinessException("商品不存在");
        assertEquals(500, e.getCode());
        assertEquals("商品不存在", e.getMessage());
    }

    @Test
    void testCustomCode() {
        BusinessException e = new BusinessException(401, "登录已过期");
        assertEquals(401, e.getCode());
        assertEquals("登录已过期", e.getMessage());
    }

    @Test
    void testInheritance() {
        BusinessException e = new BusinessException("test");
        assertTrue(e instanceof RuntimeException);
    }
}
