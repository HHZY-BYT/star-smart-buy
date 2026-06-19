package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.Refund;
import org.apache.ibatis.annotations.Mapper;

/**
 * 退款数据访问接口
 */
@Mapper
public interface RefundMapper extends BaseMapper<Refund> {
}
