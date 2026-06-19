package com.star.smartbuy.config;

import com.star.smartbuy.entity.Notification;
import com.star.smartbuy.mapper.NotificationMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 通知 WebSocket 处理器
 * 使用 @Component 由 Spring 管理，解决依赖注入问题
 */
@Component
public class NotificationWebSocketHandler extends TextWebSocketHandler {

    /** 通知Mapper（静态，供静态方法使用） */
    private static NotificationMapper notificationMapper;
    /** JSON序列化工具 */
    private static ObjectMapper objectMapper;

    /** 注入通知Mapper */
    @Autowired
    public void setNotificationMapper(NotificationMapper notificationMapper) {
        NotificationWebSocketHandler.notificationMapper = notificationMapper;
    }

    /** 注入ObjectMapper */
    @Autowired
    public void setObjectMapper(ObjectMapper objectMapper) {
        NotificationWebSocketHandler.objectMapper = objectMapper;
    }

    /**
     * 存储在线连接: adminId -> session
     */
    private static final Map<Long, WebSocketSession> sessions = new ConcurrentHashMap<>();

    /** WebSocket连接建立后的处理 */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        Long adminId = getAdminIdFromSession(session);
        if (adminId != null) {
            sessions.put(adminId, session);
            // 连接成功后主动推送未读数量
            sendUnreadCount(adminId);
        }
    }

    /** 处理客户端发送的文本消息 */
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        Long adminId = getAdminIdFromSession(session);
        if (adminId != null) {
            String payload = message.getPayload();
            if ("getUnreadCount".equals(payload)) {
                sendUnreadCount(adminId);
            }
        }
    }

    /** WebSocket连接关闭后的处理 */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        Long adminId = getAdminIdFromSession(session);
        if (adminId != null) {
            sessions.remove(adminId);
        }
    }

    /**
     * 获取未读数量并发送给客户端
     */
    private static void sendUnreadCount(Long adminId) throws IOException {
        WebSocketSession session = sessions.get(adminId);
        if (session != null && session.isOpen()) {
            Long count = notificationMapper.countUnread(adminId);
            Map<String, Object> data = new HashMap<>();
            data.put("type", "unreadCount");
            data.put("count", count);
            session.sendMessage(new TextMessage(objectMapper.writeValueAsString(data)));
        }
    }

    /**
     * 发送新通知给指定管理员（供业务代码调用）
     * 同时写入数据库并推送 WebSocket
     */
    public static void sendNotification(Long adminId, Notification notification) throws IOException {
        // 1. 先保存到数据库
        if (notification.getReadStatus() == null) {
            notification.setReadStatus(0);
        }
        if (notification.getCreatedAt() == null) {
            notification.setCreatedAt(java.time.LocalDateTime.now());
        }
        notification.setReceiverId(adminId);
        notificationMapper.insert(notification);

        // 2. 通过 WebSocket 实时推送
        WebSocketSession session = sessions.get(adminId);
        if (session != null && session.isOpen()) {
            Map<String, Object> data = new HashMap<>();
            data.put("type", "newNotification");
            data.put("notification", notification);
            session.sendMessage(new TextMessage(objectMapper.writeValueAsString(data)));
        }
    }

    /**
     * 从 session 获取 adminId
     */
    private Long getAdminIdFromSession(WebSocketSession session) {
        try {
            String query = session.getUri().getQuery();
            if (query != null) {
                for (String param : query.split("&")) {
                    String[] kv = param.split("=");
                    if (kv.length == 2 && "adminId".equals(kv[0])) {
                        return Long.parseLong(kv[1]);
                    }
                }
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 获取在线管理员数量
     */
    public static int getOnlineCount() {
        return sessions.size();
    }
}
