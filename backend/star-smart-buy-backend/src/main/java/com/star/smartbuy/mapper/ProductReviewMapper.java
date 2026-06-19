package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.ProductReview;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品评价数据访问接口
 */
@Mapper
public interface ProductReviewMapper extends BaseMapper<ProductReview> {
}
