package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.entity.ProductReview;
import com.star.smartbuy.entity.User;
import com.star.smartbuy.mapper.ProductMapper;
import com.star.smartbuy.mapper.ProductReviewMapper;
import com.star.smartbuy.mapper.UserMapper;
import com.star.smartbuy.service.ReviewService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 商品评价服务实现
 */
@Slf4j
@Service
public class ReviewServiceImpl extends ServiceImpl<ProductReviewMapper, ProductReview> implements ReviewService {

    @Resource private UserMapper userMapper;
    @Resource private ProductMapper productMapper;

    /** 获取商品评价列表（修复 N+1：批量查用户名） */
    @Override
    public PageResult<Map<String, Object>> getProductReviews(Long productId, int page, int size) {
        LambdaQueryWrapper<ProductReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductReview::getProductId, productId);
        wrapper.orderByDesc(ProductReview::getCreatedAt);

        Page<ProductReview> pageResult = this.page(new Page<>(page, size), wrapper);

        // 批量查用户名
        List<Map<String, Object>> records = fillUserNames(pageResult.getRecords());

        return PageResult.of(pageResult.getTotal(), page, size, records);
    }

    /** 获取商品评价统计 */
    @Override
    public Map<String, Object> getReviewStats(Long productId) {
        LambdaQueryWrapper<ProductReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductReview::getProductId, productId);
        List<ProductReview> reviews = this.list(wrapper);

        int totalCount = reviews.size();
        double averageRating = 0;
        Map<Integer, Integer> ratingCount = new HashMap<>();
        ratingCount.put(1, 0);
        ratingCount.put(2, 0);
        ratingCount.put(3, 0);
        ratingCount.put(4, 0);
        ratingCount.put(5, 0);

        if (totalCount > 0) {
            int totalRating = 0;
            for (ProductReview review : reviews) {
                totalRating += review.getRating();
                ratingCount.merge(review.getRating(), 1, Integer::sum);
            }
            averageRating = (double) totalRating / totalCount;
        }

        Map<String, Object> stats = new HashMap<>();
        stats.put("totalCount", totalCount);
        stats.put("averageRating", Math.round(averageRating * 10) / 10.0);
        stats.put("ratingCount", ratingCount);
        return stats;
    }

    /** 添加评价 */
    @Override
    public void addReview(Long userId, ProductReview review) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        review.setUserId(userId);
        review.setUserName(user.getNickname());
        this.save(review);
    }

    /** 获取用户评价列表 */
    @Override
    public List<ProductReview> getUserReviews(Long userId) {
        LambdaQueryWrapper<ProductReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductReview::getUserId, userId);
        wrapper.orderByDesc(ProductReview::getCreatedAt);
        return this.list(wrapper);
    }

    /** 获取用户评价列表（分页，修复 N+1：批量查商品名） */
    @Override
    public PageResult<Map<String, Object>> getUserReviewsPaged(Long userId, int page, int size) {
        LambdaQueryWrapper<ProductReview> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductReview::getUserId, userId);
        wrapper.orderByDesc(ProductReview::getCreatedAt);

        Page<ProductReview> pageResult = this.page(new Page<>(page, size), wrapper);

        // 批量查商品名
        List<Map<String, Object>> records = fillProductNames(pageResult.getRecords());

        return PageResult.of(pageResult.getTotal(), page, size, records);
    }

    // ======== 公共方法：批量填充 ========

    private List<Map<String, Object>> fillUserNames(List<ProductReview> reviews) {
        if (reviews.isEmpty()) return List.of();

        Set<Long> userIds = reviews.stream()
                .map(ProductReview::getUserId).collect(Collectors.toSet());
        Map<Long, String> nameMap = userMapper.selectBatchIds(userIds).stream()
                .collect(Collectors.toMap(User::getId, User::getNickname, (a, b) -> a));

        return reviews.stream().map(r -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("productId", r.getProductId());
            map.put("userId", r.getUserId());
            map.put("userName", nameMap.getOrDefault(r.getUserId(), r.getUserName()));
            map.put("rating", r.getRating());
            map.put("content", r.getContent());
            map.put("images", r.getImages());
            map.put("reply", r.getReply());
            map.put("replyTime", r.getReplyTime());
            map.put("createdAt", r.getCreatedAt());
            return map;
        }).collect(Collectors.toList());
    }

    private List<Map<String, Object>> fillProductNames(List<ProductReview> reviews) {
        if (reviews.isEmpty()) return List.of();

        Set<Long> productIds = reviews.stream()
                .map(ProductReview::getProductId).collect(Collectors.toSet());
        Map<Long, String> nameMap = productMapper.selectBatchIds(productIds).stream()
                .collect(Collectors.toMap(Product::getId, Product::getName, (a, b) -> a));

        return reviews.stream().map(r -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("productId", r.getProductId());
            map.put("productName", nameMap.getOrDefault(r.getProductId(), ""));
            map.put("userId", r.getUserId());
            map.put("userName", r.getUserName());
            map.put("rating", r.getRating());
            map.put("content", r.getContent());
            map.put("images", r.getImages());
            map.put("createdAt", r.getCreatedAt());
            return map;
        }).collect(Collectors.toList());
    }
}
