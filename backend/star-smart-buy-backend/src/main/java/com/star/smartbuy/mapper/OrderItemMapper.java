package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.OrderItem;
import org.apache.ibatis.annotations.Mapper;

/**
 * 订单项数据访问接口
 */
@Mapper
public interface OrderItemMapper extends BaseMapper<OrderItem> {
}
