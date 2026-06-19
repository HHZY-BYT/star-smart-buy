package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.ProductSpec;
import org.apache.ibatis.annotations.Mapper;

/**
 * 商品规格数据访问接口
 */
@Mapper
public interface ProductSpecMapper extends BaseMapper<ProductSpec> {
}
