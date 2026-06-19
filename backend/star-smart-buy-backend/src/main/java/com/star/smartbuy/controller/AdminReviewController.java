package com.star.smartbuy.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.entity.ProductReview;
import com.star.smartbuy.entity.User;
import com.star.smartbuy.mapper.ProductMapper;
import com.star.smartbuy.mapper.ProductReviewMapper;
import com.star.smartbuy.mapper.UserMapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 评价管理控制器（后台管理）
 */
@RestController
@RequestMapping("/admin/reviews")
public class AdminReviewController {

    @Resource private ProductReviewMapper reviewMapper;
    @Resource private UserMapper userMapper;
    @Resource private ProductMapper productMapper;

    /** 评价列表（分页 + 筛选，批量填充用户名和商品名） */
    @GetMapping
    public Result<PageResult<ProductReview>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long productId,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) Integer rating) {

        LambdaQueryWrapper<ProductReview> wrapper = new LambdaQueryWrapper<>();
        if (productId != null) {
            wrapper.eq(ProductReview::getProductId, productId);
        }
        if (userId != null) {
            wrapper.eq(ProductReview::getUserId, userId);
        }
        if (rating != null) {
            wrapper.eq(ProductReview::getRating, rating);
        }
        wrapper.orderByDesc(ProductReview::getCreatedAt);

        Page<ProductReview> pageResult = reviewMapper.selectPage(new Page<>(page, size), wrapper);

        // 批量填充用户名和商品名（消除 N+1）
        if (!pageResult.getRecords().isEmpty()) {
            Set<Long> userIds = pageResult.getRecords().stream()
                    .map(ProductReview::getUserId).collect(Collectors.toSet());
            Set<Long> productIds = pageResult.getRecords().stream()
                    .map(ProductReview::getProductId).collect(Collectors.toSet());

            Map<Long, String> userMap = userMapper.selectBatchIds(userIds).stream()
                    .collect(Collectors.toMap(User::getId, User::getNickname, (a, b) -> a));
            Map<Long, String> productMap = productMapper.selectBatchIds(productIds).stream()
                    .collect(Collectors.toMap(Product::getId, Product::getName, (a, b) -> a));

            pageResult.getRecords().forEach(r -> {
                r.setUserName(userMap.getOrDefault(r.getUserId(), r.getUserName()));
                r.setProductName(productMap.getOrDefault(r.getProductId(), ""));
            });
        }

        return Result.success(PageResult.of(pageResult));
    }

    /** 删除评价 */
    @DeleteMapping("/{id}")
    @OperLog(module = "REVIEW", type = "DELETE", description = "删除评价")
    public Result<Void> delete(@PathVariable Long id) {
        reviewMapper.deleteById(id);
        return Result.success();
    }

    /** 回复评价 */
    @PutMapping("/{id}/reply")
    @OperLog(module = "REVIEW", type = "UPDATE", description = "回复评价")
    public Result<Void> reply(@PathVariable Long id, @RequestBody Map<String, String> data) {
        String replyContent = data.get("reply");
        if (replyContent == null || replyContent.trim().isEmpty()) {
            return Result.error("回复内容不能为空");
        }
        ProductReview review = reviewMapper.selectById(id);
        if (review == null) {
            return Result.error("评价不存在");
        }
        review.setReply(replyContent.trim());
        review.setReplyTime(LocalDateTime.now());
        reviewMapper.updateById(review);
        return Result.success();
    }
}
