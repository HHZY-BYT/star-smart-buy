package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.Admin;
import org.apache.ibatis.annotations.Mapper;

/**
 * 管理员数据访问接口
 */
@Mapper
public interface AdminMapper extends BaseMapper<Admin> {
}
