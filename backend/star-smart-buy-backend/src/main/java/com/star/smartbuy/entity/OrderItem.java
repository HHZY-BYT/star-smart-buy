package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

/**
 * 订单明细实体
 */
@Data
@TableName("order_item")
public class OrderItem {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 订单ID */
    private Long orderId;

    /** 商品ID */
    private Long productId;

    /** 商品名称 */
    private String productName;

    /** 规格名称 */
    private String specName;

    /** 规格值 */
    private String specValue;

    /** 多规格ID（逗号分隔，如 "33,37"） */
    private String specIds;

    /** 商品单价 */
    private Double price;

    /** 购买数量 */
    private Integer quantity;

    /** 小计金额 */
    private Double subtotal;

    /** 商品图片 */
    private String productImage;
}