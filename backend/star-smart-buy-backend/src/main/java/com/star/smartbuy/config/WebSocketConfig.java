package com.star.smartbuy.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * WebSocket 配置类
 */
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {

    /** 通知WebSocket处理器 */
    @Autowired
    private NotificationWebSocketHandler notificationWebSocketHandler;

    /** 注册WebSocket处理器 */
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // 使用 Spring 注入的 Handler 实例，而非 new，确保依赖注入生效
        registry.addHandler(notificationWebSocketHandler, "/ws/notifications")
                .setAllowedOrigins("*");
    }
}
