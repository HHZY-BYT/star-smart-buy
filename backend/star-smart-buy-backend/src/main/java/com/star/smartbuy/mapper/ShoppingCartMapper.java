package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.ShoppingCart;
import org.apache.ibatis.annotations.Mapper;

/**
 * 购物车数据访问接口
 */
@Mapper
public interface ShoppingCartMapper extends BaseMapper<ShoppingCart> {
}
