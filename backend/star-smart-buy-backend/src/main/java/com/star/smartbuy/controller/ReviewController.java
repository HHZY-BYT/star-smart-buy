package com.star.smartbuy.controller;

import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Notification;
import com.star.smartbuy.entity.ProductReview;
import com.star.smartbuy.config.NotificationWebSocketHandler;
import com.star.smartbuy.service.ReviewService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

/**
 * 评价控制器
 */
@Slf4j
@RestController
@RequestMapping("/review")
public class ReviewController {

    @Resource private ReviewService reviewService;

    /** 获取商品评价列表 */
    @GetMapping("/{productId}")
    public Result<PageResult<Map<String, Object>>> list(@PathVariable Long productId,
                                                         @RequestParam(defaultValue = "1") int page,
                                                         @RequestParam(defaultValue = "10") int size) {
        return Result.success(reviewService.getProductReviews(productId, page, size));
    }

    /** 获取我的评价列表 */
    @GetMapping("/my")
    public Result<PageResult<Map<String, Object>>> myReviews(@RequestAttribute("userId") Long userId,
                                                               @RequestParam(defaultValue = "1") int page,
                                                               @RequestParam(defaultValue = "10") int size) {
        return Result.success(reviewService.getUserReviewsPaged(userId, page, size));
    }

    /** 发布评价 */
    @PostMapping
    public Result<Void> add(@RequestAttribute("userId") Long userId,
                             @RequestBody ProductReview review) {
        reviewService.addReview(userId, review);

        try {
            Notification notification = new Notification();
            notification.setTitle("新评价通知");
            notification.setContent("用户对商品发表了评价，评分：" + review.getRating() + "星");
            notification.setType("system");
            notification.setRelatedId(review.getProductId());
            NotificationWebSocketHandler.sendNotification(1L, notification);
        } catch (Exception e) {
            log.warn("通知推送失败: {}", e.getMessage());
        }

        return Result.success();
    }
}
