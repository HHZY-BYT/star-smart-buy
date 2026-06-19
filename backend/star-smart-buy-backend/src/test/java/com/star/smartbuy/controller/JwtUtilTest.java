package com.star.smartbuy.controller;

import com.star.smartbuy.config.JwtProperties;
import com.star.smartbuy.interceptor.JwtUtil;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.junit.jupiter.api.Assertions.*;

/**
 * JWT 工具类单元测试 — 手动注入 JwtProperties，不依赖 Spring 容器
 */
class JwtUtilTest {

    private JwtUtil jwtUtil;

    @BeforeEach
    void setUp() {
        jwtUtil = new JwtUtil();
        // 手动创建 JwtProperties 并通过反射注入，避免依赖 Spring 容器
        JwtProperties props = new JwtProperties();
        props.setSecret("test-secret-key-for-unit-tests-only-test");
        props.setExpiration(86400000L);
        ReflectionTestUtils.setField(jwtUtil, "jwtProperties", props);
    }

    @Test
    void testGenerateToken_ReturnsNonEmptyString() {
        String token = jwtUtil.generateToken(1L, "user");
        assertNotNull(token);
        assertFalse(token.isEmpty());
    }

    @Test
    void testParseToken_ValidToken_ReturnsCorrectClaims() {
        String token = jwtUtil.generateToken(100L, "admin");
        var claims = jwtUtil.parseToken(token);
        assertEquals(100L, jwtUtil.getUserId(claims));
        assertEquals("admin", jwtUtil.getRole(claims));
    }

    @Test
    void testParseToken_InvalidToken_ThrowsException() {
        assertThrows(Exception.class, () ->
                jwtUtil.parseToken("invalid.token.here"));
    }
}
