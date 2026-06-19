package com.star.smartbuy.controller;

import com.star.smartbuy.common.Result;
import com.star.smartbuy.service.ShoppingCartService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;
import java.util.Map;

/**
 * 购物车控制器
 * <p>
 * 提供购物车 CRUD 操作，所有接口需要用户登录。
 * 支持多规格商品（specIds）和旧版单规格（specId）兼容。
 * </p>
 *
 * @author StarSmart Buy Team
 * @since 1.0
 */
@RestController
@RequestMapping("/cart")
public class CartController {

    @Resource
    private ShoppingCartService shoppingCartService;

    /**
     * 获取当前用户的购物车列表
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @return 购物车商品列表（含商品名、价格、规格、数量）
     */
    @GetMapping
    public Result<List<Map<String, Object>>> list(@RequestAttribute("userId") Long userId) {
        return Result.success(shoppingCartService.getUserCart(userId));
    }

    /**
     * 添加商品到购物车
     * <p>
     * 支持多规格（specIds，逗号分隔）和单规格（specId）两种传参方式。
     * </p>
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @param data  包含 productId、quantity（可选，默认1）、specIds 或 specId 的请求体
     * @return 空数据表示成功
     */
    @PostMapping("/add")
    public Result<Void> add(@RequestAttribute("userId") Long userId,
                           @RequestBody Map<String, Object> data) {
        Long productId = Long.parseLong(data.get("productId").toString());
        Integer quantity = data.get("quantity") != null ? Integer.parseInt(data.get("quantity").toString()) : 1;
        String specIds = data.get("specIds") != null ? data.get("specIds").toString() : null;
        // 兼容旧的单 specId 字段
        Long specId = null;
        if ((specIds == null || specIds.isEmpty()) && data.get("specId") != null) {
            specId = Long.parseLong(data.get("specId").toString());
            specIds = specId != null ? String.valueOf(specId) : null;
        }
        shoppingCartService.addToCart(userId, productId, quantity, specId, specIds);
        return Result.success();
    }

    /**
     * 更新购物车商品数量
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @param data  包含 id（购物车项 ID）和 quantity（新数量）的请求体
     * @return 空数据表示成功
     */
    @PutMapping("/update")
    public Result<Void> update(@RequestAttribute("userId") Long userId,
                               @RequestBody Map<String, Object> data) {
        Long id = Long.parseLong(data.get("id").toString());
        Integer quantity = data.get("quantity") != null ? Integer.parseInt(data.get("quantity").toString()) : 1;
        shoppingCartService.updateQuantity(userId, id, quantity);
        return Result.success();
    }

    /**
     * 删除购物车中的指定商品
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @param id    购物车项 ID
     * @return 空数据表示成功
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@RequestAttribute("userId") Long userId,
                               @PathVariable Long id) {
        shoppingCartService.removeFromCart(userId, id);
        return Result.success();
    }

    /**
     * 清空购物车
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @return 空数据表示成功
     */
    @DeleteMapping("/clear")
    public Result<Void> clear(@RequestAttribute("userId") Long userId) {
        shoppingCartService.clearCart(userId);
        return Result.success();
    }

    /**
     * 获取购物车商品数量
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @return 购物车中商品项数量
     */
    @GetMapping("/count")
    public Result<Integer> count(@RequestAttribute("userId") Long userId) {
        return Result.success(shoppingCartService.getCartCount(userId));
    }
}
