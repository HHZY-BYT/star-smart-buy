package com.star.smartbuy.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.star.smartbuy.entity.ShoppingCart;

import java.util.List;
import java.util.Map;

/**
 * 购物车服务接口
 */
public interface ShoppingCartService extends IService<ShoppingCart> {

    /**
     * 获取用户购物车列表
     */
    List<Map<String, Object>> getUserCart(Long userId);

    /**
     * 添加商品到购物车
     */
    void addToCart(Long userId, Long productId, Integer quantity, Long specId, String specIds);

    /**
     * 更新购物车商品数量
     */
    void updateQuantity(Long userId, Long cartId, Integer quantity);

    /**
     * 删除购物车商品
     */
    void removeFromCart(Long userId, Long cartId);

    /**
     * 清空用户购物车
     */
    void clearCart(Long userId);

    /**
     * 获取购物车商品数量
     */
    int getCartCount(Long userId);
}