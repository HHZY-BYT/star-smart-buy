package com.star.smartbuy.interceptor;

import com.star.smartbuy.config.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;

/**
 * JWT 工具类
 * <p>
 * 用于生成和解析 JWT Token，密钥和过期时间从 application.yml 的 JwtProperties 注入，
 * 避免硬编码到源码中。采用 HMAC-SHA384 签名算法（基于密钥长度自动选择）。
 * </p>
 */
@Component
public class JwtUtil {

    /** JWT 配置属性（从 application.yml 读取，支持多环境切换） */
    @Resource
    private JwtProperties jwtProperties;

    /**
     * 生成 JWT Token
     *
     * @param userId 用户ID
     * @param role   角色标识（user / admin）
     * @return 签名的 JWT Token 字符串
     */
    public String generateToken(Long userId, String role) {
        return Jwts.builder()
                .subject(userId.toString())
                .claim("role", role)
                .issuedAt(new java.util.Date())
                // 过期时间从配置文件读取，不再硬编码
                .expiration(new java.util.Date(System.currentTimeMillis() + jwtProperties.getExpiration()))
                .signWith(getSecretKey())
                .compact();
    }

    /**
     * 解析并验证 JWT Token
     *
     * @param token JWT Token 字符串
     * @return 解析后的 Claims 负载
     */
    public Claims parseToken(String token) {
        return Jwts.parser()
                .verifyWith(getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    /** 从 Claims 中提取用户 ID */
    public Long getUserId(Claims claims) {
        return Long.parseLong(claims.getSubject());
    }

    /** 从 Claims 中提取角色 */
    public String getRole(Claims claims) {
        return claims.get("role", String.class);
    }

    /** 获取 HMAC 签名密钥（密钥从配置文件注入，不再硬编码） */
    private SecretKey getSecretKey() {
        byte[] bytes = jwtProperties.getSecret().getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(bytes);
    }
}