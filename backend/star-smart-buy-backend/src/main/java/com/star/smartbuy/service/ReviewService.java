package com.star.smartbuy.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.entity.ProductReview;

import java.util.List;
import java.util.Map;

/**
 * 商品评价服务接口
 */
public interface ReviewService extends IService<ProductReview> {

    /** 获取商品评价列表 */
    PageResult<Map<String, Object>> getProductReviews(Long productId, int page, int size);

    /** 获取商品评价统计 */
    Map<String, Object> getReviewStats(Long productId);

    /** 添加评价 */
    void addReview(Long userId, ProductReview review);

    /** 获取用户评价列表 */
    List<ProductReview> getUserReviews(Long userId);

    /** 获取用户评价列表（分页） */
    PageResult<Map<String, Object>> getUserReviewsPaged(Long userId, int page, int size);
}
