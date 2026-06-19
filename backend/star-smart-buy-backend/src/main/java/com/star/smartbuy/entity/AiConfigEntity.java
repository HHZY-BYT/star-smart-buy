package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * AI配置实体
 */
@Data
@TableName("ai_config")
public class AiConfigEntity {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** AI服务提供商: deepseek/openai/zhipu/qwen/moonshot/spark */
    private String provider;

    /** API Key */
    private String apiKey;

    /** API Base URL */
    private String baseUrl;

    /** 模型名称 */
    private String model;

    /** 温度参数 */
    private Double temperature;

    /** 最大token数 */
    private Integer maxTokens;

    /** 系统提示词 */
    private String systemPrompt;

    /** 是否启用: 0-禁用 1-启用 */
    private Integer isActive;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
