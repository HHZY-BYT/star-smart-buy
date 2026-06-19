package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 订单实体
 */
@Data
@TableName("orders")
public class Order {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 订单编号 */
    private String orderNo;

    /** 用户ID */
    private Long userId;

    /** 订单总金额 */
    private Double totalAmount;

    /** 0-待付款 1-已付款 2-已发货 3-已完成 4-已取消 5-已退货 */
    private Integer status;

    private String address;

    /** 收货人 */
    private String consignee;

    /** 联系电话 */
    private String phone;

    /** 备注 */
    private String remark;

    /** 支付时间 */
    private LocalDateTime payTime;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 更新时间 */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}