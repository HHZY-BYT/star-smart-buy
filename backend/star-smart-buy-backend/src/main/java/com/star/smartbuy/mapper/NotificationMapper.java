package com.star.smartbuy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.star.smartbuy.entity.Notification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 通知数据访问接口
 */
@Mapper
public interface NotificationMapper extends BaseMapper<Notification> {

    /**
     * 统计未读通知数量
     */
    @Select("SELECT COUNT(*) FROM notification WHERE receiver_id = #{receiverId} AND read_status = 0")
    Long countUnread(@Param("receiverId") Long receiverId);
}
