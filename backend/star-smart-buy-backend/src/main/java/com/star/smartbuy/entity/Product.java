package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 商品实体
 */
@Data
@TableName("product")
public class Product {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 商品名称 */
    private String name;

    /** 分类ID */
    private Long categoryId;

    /** 价格 */
    private Double price;

    /** 库存 */
    private Integer stock;

    /** 图片（多个用逗号分隔） */
    private String images;

    /** 商品描述 */
    private String description;

    /** 0-下架 1-上架 */
    private Integer status;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;

    /** 分类名称，非数据库字段 */
    @TableField(exist = false)
    private String categoryName;

    /** 规格列表，非数据库字段 */
    @TableField(exist = false)
    private List<ProductSpec> specs;
}