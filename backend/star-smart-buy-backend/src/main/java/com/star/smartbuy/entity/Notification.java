package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 通知实体
 */
@Data
@TableName("notification")
public class Notification {

    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 接收者ID（管理员ID）
     */
    private Long receiverId;

    /**
     * 通知标题
     */
    private String title;

    /**
     * 通知内容
     */
    private String content;

    /**
     * 是否已读: 0-未读, 1-已读
     */
    private Integer readStatus;

    /**
     * 通知类型: order-订单通知, refund-退款通知, system-系统通知
     */
    private String type;

    /**
     * 关联数据ID
     */
    private Long relatedId;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
