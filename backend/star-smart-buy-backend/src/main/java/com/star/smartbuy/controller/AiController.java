package com.star.smartbuy.controller;

import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.dto.AiChatDTO;
import com.star.smartbuy.entity.AiConfigEntity;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.mapper.AiConfigMapper;
import com.star.smartbuy.service.ProductService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import jakarta.annotation.Resource;
import java.util.*;

/**
 * AI 智能助手控制器
 * <p>
 * 提供 AI 聊天和商品推荐功能，通过 OpenAI 兼容协议接入 DeepSeek / OpenAI / 智谱 /
 * 通义千问 / 月之暗面 / 讯飞星火等大模型。AI 配置在管理后台实时管理，无需重启服务。
 * </p>
 *
 * @author StarSmart Buy Team
 * @since 1.0
 */
@Slf4j
@RestController
@RequestMapping("/ai")
public class AiController {

    @Resource
    private AiConfigMapper aiConfigMapper;

    @Resource
    private ProductService productService;

    private final RestTemplate restTemplate = new RestTemplate();

    /**
     * 获取当前启用的AI配置
     */
    private AiConfigEntity getActiveConfig() {
        AiConfigEntity config = aiConfigMapper.selectOne(
            new LambdaQueryWrapper<AiConfigEntity>().eq(AiConfigEntity::getIsActive, 1).last("LIMIT 1")
        );
        if (config == null) {
            throw new BusinessException("未配置AI服务，请在管理后台配置");
        }
        return config;
    }

    /**
     * 调用OpenAI兼容API
     */
    private String callAiApi(List<Map<String, String>> messages, Double temperature, Integer maxTokens) {
        AiConfigEntity config = getActiveConfig();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(config.getApiKey());

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", config.getModel());
        requestBody.put("messages", messages);
        requestBody.put("max_tokens", maxTokens != null ? maxTokens : config.getMaxTokens());
        requestBody.put("temperature", temperature != null ? temperature : config.getTemperature());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        String url = config.getBaseUrl().replaceAll("/+$", "") + "/chat/completions";

        @SuppressWarnings("unchecked")
        Map<String, Object> response = restTemplate.postForObject(url, entity, Map.class);

        if (response != null && response.containsKey("choices")) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
            if (!choices.isEmpty()) {
                @SuppressWarnings("unchecked")
                Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
                if (message != null) {
                    return (String) message.get("content");
                }
            }
        }
        throw new BusinessException("AI服务返回异常");
    }

    /**
     * AI 聊天
     * <p>
     * 使用当前激活的 AI 配置与用户进行对话。系统提示词由管理后台配置，
     * 对话不保存历史（无状态模式）。
     * </p>
     *
     * @param dto 包含 message 和可选 sessionId 的聊天请求
     * @return AI 回复内容
     */
    @PostMapping("/chat")
    public Result<Map<String, String>> chat(@RequestBody AiChatDTO dto) {
        String message = dto.getMessage();
        String sessionId = dto.getSessionId();

        try {
            AiConfigEntity config = getActiveConfig();

            List<Map<String, String>> messages = new ArrayList<>();
            // 添加系统提示词
            if (config.getSystemPrompt() != null && !config.getSystemPrompt().isEmpty()) {
                messages.add(Map.of("role", "system", "content", config.getSystemPrompt()));
            }
            messages.add(Map.of("role", "user", "content", message));

            String reply = callAiApi(messages, null, null);

            Map<String, String> data = Map.of(
                "reply", reply != null ? reply : "",
                "sessionId", sessionId != null ? sessionId : ""
            );
            return Result.success(data);
        } catch (Exception e) {
            return Result.error(500, "AI服务调用失败: " + e.getMessage());
        }
    }

    /**
     * AI 推荐商品
     * <p>
     * 根据用户需求描述，从当前上架商品中智能筛选推荐。自动解析预算约束
     * （如"5000以内"），使用较低 temperature 保证推荐的严谨性。
     * </p>
     *
     * @param requirement 用户需求描述（如"预算3000，想要拍照好的手机"）
     * @return AI 生成的推荐文本
     */
    @GetMapping("/recommend")
    public Result<String> recommend(@RequestParam String requirement) {
        try {
            AiConfigEntity config = getActiveConfig();

            // 解析用户输入中的预算上限
            Double maxBudget = parseBudget(requirement);

            String systemPrompt = "你是一个专业的电商购物助手，根据用户需求推荐合适的商品。\n" +
                "【重要规则，必须严格遵守】\n" +
                "1. 只能从下方「可推荐的商品」列表中选择商品进行推荐，绝对不能编造列表中不存在的商品名称或价格！\n" +
                "2. 如果用户指定了预算（如5000元以内），必须严格只推荐价格不超过预算的商品，超预算的一律不要推荐。\n" +
                "3. 如果预算范围内没有合适的商品，请如实告知用户，不要强行推荐超预算的商品。\n" +
                "4. 推荐格式：简要说明推荐理由（结合预算和需求）+ 商品名称 + 价格。\n" +
                "5. 每次最多推荐3个最匹配的商品。";

            // 获取所有上架商品
            var productData = productService.getProductList(1, 50, null, null);
            var products = productData.getRecords();

            StringBuilder productInfo = new StringBuilder();
            if (products != null && !products.isEmpty()) {
                // 按预算过滤商品
                List<Product> filteredProducts = products;
                if (maxBudget != null && maxBudget > 0) {
                    filteredProducts = products.stream()
                        .filter(p -> p.getPrice() <= maxBudget)
                        .toList();
                    // 如果过滤后为空，提示LLM预算内无商品
                    if (filteredProducts.isEmpty()) {
                        productInfo.append("（注意：当前所有商品均超出用户预算 ¥").append(String.format("%.0f", maxBudget)).append("）\n");
                        // 仍然展示所有商品让AI参考，但标注超出预算
                        for (Product p : products) {
                            productInfo.append(String.format("- %s: ¥%.2f (库存:%d) 【超出预算】%n",
                                p.getName(), p.getPrice(), p.getStock()));
                        }
                    } else {
                        for (Product p : filteredProducts) {
                            productInfo.append(String.format("- %s: ¥%.2f (库存:%d)%n",
                                p.getName(), p.getPrice(), p.getStock()));
                        }
                    }
                } else {
                    for (Product p : products) {
                        productInfo.append(String.format("- %s: ¥%.2f (库存:%d)%n",
                            p.getName(), p.getPrice(), p.getStock()));
                    }
                }
            }

            String userPrompt = String.format("用户需求：%s%n%n可推荐的商品（仅从此列表中推荐）：%n%s",
                requirement, productInfo.toString());

            List<Map<String, String>> messages = new ArrayList<>();
            messages.add(Map.of("role", "system", "content", systemPrompt));
            messages.add(Map.of("role", "user", "content", userPrompt));

            // 推荐场景使用较低temperature保证严谨性
            String reply = callAiApi(messages, 0.3, null);

            return Result.success(reply != null ? reply : "抱歉，暂时无法获取推荐结果");
        } catch (Exception e) {
            return Result.error(500, "AI推荐失败: " + e.getMessage());
        }
    }

    /**
     * 从用户输入中解析预算金额
     * 支持格式：5000以内、5000以下、5000左右、5000块、5000元、5000预算、不超过5000等
     */
    private Double parseBudget(String input) {
        if (input == null) return null;
        
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(
            "(\\d+(?:\\.\\d+)?)\\s*(?:元|块|圆)?\\s*(?:以[下内]|左右|预算|以内|不超过|不超过|低于)"
        );
        java.util.regex.Matcher matcher = pattern.matcher(input);
        if (matcher.find()) {
            return Double.parseDouble(matcher.group(1));
        }

        // 也匹配 "预算5000" / "5000预算" 格式
        java.util.regex.Pattern pattern2 = java.util.regex.Pattern.compile(
            "(?:预算)?\\s*(\\d+(?:\\.\\d+)?)\\s*(?:元|块|圆)?\\s*(?:预算)?"
        );
        java.util.regex.Matcher matcher2 = pattern2.matcher(input);
        if (matcher2.find()) {
            return Double.parseDouble(matcher2.group(1));
        }

        return null;
    }
}
