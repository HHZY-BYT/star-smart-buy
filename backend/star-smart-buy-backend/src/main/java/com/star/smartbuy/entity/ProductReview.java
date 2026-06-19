package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 商品评价实体
 */
@Data
@TableName("product_review")
public class ProductReview {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商品ID */
    private Long productId;

    /** 用户ID */
    private Long userId;

    /** 用户名 */
    private String userName;

    /** 评分 1-5 */
    private Integer rating;

    /** 评价内容 */
    private String content;

    /** 评价图片（多个用逗号分隔） */
    private String images;

    /** 管理员回复 */
    private String reply;

    /** 回复时间 */
    private LocalDateTime replyTime;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 商品名称，非数据库字段 */
    @TableField(exist = false)
    private String productName;
}