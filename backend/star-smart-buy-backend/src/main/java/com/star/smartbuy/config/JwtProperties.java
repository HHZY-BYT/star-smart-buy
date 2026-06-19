package com.star.smartbuy.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * JWT 配置属性
 * <p>
 * 从 application.yml 的 jwt 前缀下读取 secret 和 expiration，
 * 支持通过配置文件切换密钥和环境，避免硬编码。
 * </p>
 */
@Data
@Component
@ConfigurationProperties(prefix = "jwt")
public class JwtProperties {

    /** JWT 签名密钥（HS384 要求至少 384 bits） */
    private String secret;

    /** Token 过期时间（毫秒），默认 86400000 = 24小时 */
    private long expiration;
}