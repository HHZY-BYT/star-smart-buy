package com.star.smartbuy.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.star.smartbuy.interceptor.JwtInterceptor;
import jakarta.annotation.Resource;

/**
 * Web MVC 配置
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    /** JWT拦截器 */
    @Resource
    private JwtInterceptor jwtInterceptor;

    /** 文件上传目录 */
    @Value("${file.upload-dir:uploads}")
    private String uploadDir;


    /** 跨域过滤器 */
    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration config = new CorsConfiguration();
        config.addAllowedOriginPattern("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        config.setAllowCredentials(true);
        config.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }

    /** 静态资源映射 - 上传文件访问 */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadDir + "/");
    }

    /** 添加拦截器 */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/user/login",
                        "/user/login-by-phone",
                        "/user/send-verify-code",
                        "/admin/login",
                        "/products",
                        "/products/search",
                        "/products/**",
                        "/categories",
                        "/categories/**",
                        "/home",
                        "/home/**",
                        "/review/*",
                        "/ai/chat",
                        "/ai/recommend",
                        "/ws/**",
                        "/uploads/**",
                        "/upload/**"
                );
    }
}