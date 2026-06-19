package com.star.smartbuy.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

/**
 * 创建订单请求
 */
@Data
public class CreateOrderDTO {

    /** 收货地址 ID */
    @NotNull(message = "地址ID不能为空")
    private Long addressId;

    /** 订单商品列表 */
    private List<OrderItemDTO> items;

    /** 购物车项 ID 列表（可选，用于下单后清除购物车） */
    private List<Long> cartIds;

    /** 备注 */
    private String remark;

    /**
     * 订单商品项
     */
    @Data
    public static class OrderItemDTO {
        /** 商品ID */
        private Long productId;
        /** 单规格ID（兼容旧逻辑） */
        private Long specId;
        /** 多规格ID（逗号分隔，如 "33,37"） */
        private String specIds;
        /** 购买数量 */
        @Min(value = 1, message = "数量至少为1")
        private Integer quantity;
        /** 商品图片（下单时快照保存） */
        private String productImage;
    }
}