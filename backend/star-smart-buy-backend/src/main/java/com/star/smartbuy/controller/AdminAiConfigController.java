package com.star.smartbuy.controller;

import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.AiConfigEntity;
import com.star.smartbuy.mapper.AiConfigMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员 - AI配置控制器
 */
@RestController
@RequestMapping("/admin/ai")
public class AdminAiConfigController {

    @Resource
    private AiConfigMapper aiConfigMapper;

    /** AI服务提供商预设配置 */
    private static final Map<String, Map<String, String>> PROVIDER_PRESETS = new HashMap<>();
    static {
        PROVIDER_PRESETS.put("deepseek", Map.of(
            "baseUrl", "https://api.deepseek.com",
            "model", "deepseek-v4-pro",
            "name", "DeepSeek"
        ));
        PROVIDER_PRESETS.put("openai", Map.of(
            "baseUrl", "https://api.openai.com",
            "model", "gpt-3.5-turbo",
            "name", "OpenAI"
        ));
        PROVIDER_PRESETS.put("zhipu", Map.of(
            "baseUrl", "https://open.bigmodel.cn/api/paas/v4",
            "model", "glm-4",
            "name", "智谱AI"
        ));
        PROVIDER_PRESETS.put("qwen", Map.of(
            "baseUrl", "https://dashscope.aliyuncs.com/compatible-mode/v1",
            "model", "qwen-turbo",
            "name", "通义千问"
        ));
        PROVIDER_PRESETS.put("moonshot", Map.of(
            "baseUrl", "https://api.moonshot.cn/v1",
            "model", "moonshot-v1-8k",
            "name", "Moonshot (Kimi)"
        ));
        PROVIDER_PRESETS.put("spark", Map.of(
            "baseUrl", "https://spark-api-open.xf-yun.com/v1",
            "model", "generalv3.5",
            "name", "讯飞星火"
        ));
    }

    /**
     * 获取AI配置
     */
    @GetMapping("/config")
    public Result<Map<String, Object>> getConfig() {
        // 获取当前启用的配置
        AiConfigEntity activeConfig = aiConfigMapper.selectOne(
            new LambdaQueryWrapper<AiConfigEntity>().eq(AiConfigEntity::getIsActive, 1).last("LIMIT 1")
        );

        // 获取所有配置列表
        List<AiConfigEntity> allConfigs = aiConfigMapper.selectList(
            new LambdaQueryWrapper<AiConfigEntity>().orderByDesc(AiConfigEntity::getIsActive).orderByDesc(AiConfigEntity::getUpdatedAt)
        );

        Map<String, Object> data = new HashMap<>();
        data.put("active", activeConfig);
        data.put("configs", allConfigs);
        data.put("providers", PROVIDER_PRESETS);

        return Result.success(data);
    }

    /**
     * 保存AI配置
     */
    @PutMapping("/config")
    public Result<Void> saveConfig(@RequestBody AiConfigEntity config) {
        if (config.getProvider() == null || config.getProvider().isEmpty()) {
            return Result.error("请选择AI服务提供商");
        }
        if (config.getApiKey() == null || config.getApiKey().isEmpty()) {
            return Result.error("请输入API Key");
        }
        if (config.getBaseUrl() == null || config.getBaseUrl().isEmpty()) {
            return Result.error("请输入Base URL");
        }
        if (config.getModel() == null || config.getModel().isEmpty()) {
            return Result.error("请输入模型名称");
        }

        if (config.getId() != null) {
            // 更新
            config.setUpdatedAt(LocalDateTime.now());
            aiConfigMapper.updateById(config);
        } else {
            // 新增
            config.setIsActive(1);
            config.setCreatedAt(LocalDateTime.now());
            config.setUpdatedAt(LocalDateTime.now());

            // 将其他配置设为非启用
            AiConfigEntity update = new AiConfigEntity();
            update.setIsActive(0);
            aiConfigMapper.update(update, new LambdaQueryWrapper<AiConfigEntity>().eq(AiConfigEntity::getIsActive, 1));

            aiConfigMapper.insert(config);
        }

        return Result.success();
    }

    /**
     * 切换AI配置
     */
    @PutMapping("/config/{id}/activate")
    public Result<Void> activateConfig(@PathVariable Long id) {
        // 将所有配置设为非启用
        AiConfigEntity update = new AiConfigEntity();
        update.setIsActive(0);
        aiConfigMapper.update(update, new LambdaQueryWrapper<>());

        // 启用指定配置
        AiConfigEntity config = aiConfigMapper.selectById(id);
        if (config == null) {
            return Result.error("配置不存在");
        }
        config.setIsActive(1);
        config.setUpdatedAt(LocalDateTime.now());
        aiConfigMapper.updateById(config);

        return Result.success();
    }

    /**
     * 删除AI配置
     */
    @DeleteMapping("/config/{id}")
    public Result<Void> deleteConfig(@PathVariable Long id) {
        AiConfigEntity config = aiConfigMapper.selectById(id);
        if (config == null) {
            return Result.error("配置不存在");
        }
        if (config.getIsActive() == 1) {
            return Result.error("不能删除当前启用的配置");
        }
        aiConfigMapper.deleteById(id);
        return Result.success();
    }

    /**
     * 测试AI连接
     */
    @PostMapping("/config/test")
    public Result<Map<String, Object>> testConfig(@RequestBody AiConfigEntity config) {
        try {
            // 使用RestTemplate直接调用OpenAI兼容API测试连接
            org.springframework.web.client.RestTemplate restTemplate = new org.springframework.web.client.RestTemplate();

            org.springframework.http.HttpHeaders headers = new org.springframework.http.HttpHeaders();
            headers.setContentType(org.springframework.http.MediaType.APPLICATION_JSON);
            headers.setBearerAuth(config.getApiKey());

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", config.getModel());
            requestBody.put("messages", List.of(
                Map.of("role", "user", "content", "你好，请回复'连接成功'")
            ));
            requestBody.put("max_tokens", 50);
            requestBody.put("temperature", 0.1);

            org.springframework.http.HttpEntity<Map<String, Object>> entity =
                new org.springframework.http.HttpEntity<>(requestBody, headers);

            String url = config.getBaseUrl().replaceAll("/+$", "") + "/chat/completions";

            @SuppressWarnings("unchecked")
            Map<String, Object> response = restTemplate.postForObject(url, entity, Map.class);

            Map<String, Object> result = new HashMap<>();
            if (response != null && response.containsKey("choices")) {
                result.put("success", true);
                result.put("message", "连接成功");
            } else {
                result.put("success", false);
                result.put("message", "连接失败：未收到有效响应");
            }
            return Result.success(result);
        } catch (Exception e) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "连接失败：" + e.getMessage());
            return Result.success(result);
        }
    }
}
