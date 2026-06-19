package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.Notice;
import org.apache.ibatis.annotations.Mapper;

/**
 * 公告数据访问接口
 */
@Mapper
public interface NoticeMapper extends BaseMapper<Notice> {
}
