package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 商品分类实体
 */
@Data
@TableName("product_category")
public class ProductCategory {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 分类名称 */
    private String name;

    /** 父分类ID */
    private Long parentId;

    /** 排序（越小越靠前） */
    private Integer sort;

    /**
     * 状态: 1-显示, 0-隐藏
     */
    private Integer status;

    /**
     * 图标
     */
    private String icon;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /**
     * 子分类列表（非数据库字段）
     */
    @TableField(exist = false)
    private List<ProductCategory> children;
}