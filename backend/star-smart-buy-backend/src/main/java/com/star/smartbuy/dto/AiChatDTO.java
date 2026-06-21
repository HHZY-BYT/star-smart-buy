package com.star.smartbuy.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * AI 聊天请求
 */
@Data
public class AiChatDTO {

    /** 用户消息 */
    @NotNull(message = "消息数据不能为空")
    private String message;

    /** 会话 ID，用于保持上下文 */
    private String sessionId;

    /** 历史消息列表，用于上下文记忆，每项形如 {role, content} */
    private List<Map<String, String>> history;
}