package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 轮播图实体
 */
@Data
@TableName("banner")
public class Banner {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 图片URL */
    private String image;

    /** 标题 */
    private String title;

    /** 跳转链接 */
    private String link;

    /** 排序（越小越靠前） */
    private Integer sort;

    /** 状态: 1-显示, 0-隐藏 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
