package com.star.smartbuy.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;
import java.util.Map;

/**
 * AI 推荐请求
 */
@Data
public class AiRecommendDTO {

    /** 用户需求描述 */
    @NotNull(message = "需求不能为空")
    private String requirement;

    /** 会话 ID */
    private String sessionId;

    /** 历史消息列表，用于上下文记忆 */
    private List<Map<String, String>> history;
}
