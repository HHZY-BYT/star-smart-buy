package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.Address;
import org.apache.ibatis.annotations.Mapper;

/**
 * 收货地址数据访问接口
 */
@Mapper
public interface AddressMapper extends BaseMapper<Address> {
}
