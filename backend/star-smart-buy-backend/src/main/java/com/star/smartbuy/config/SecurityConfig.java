package com.star.smartbuy.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * 安全配置
 * <p>
 * 提供 BCrypt 密码编码器 Bean，用于管理员密码的加密存储和比对验证。
 * BCrypt 自带盐值，有效抵御彩虹表攻击。
 * </p>
 */
@Configuration
public class SecurityConfig {

    /** 注册 BCryptPasswordEncoder，强度因子为默认的 10 */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
