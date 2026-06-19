package com.star.smartbuy.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

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
}