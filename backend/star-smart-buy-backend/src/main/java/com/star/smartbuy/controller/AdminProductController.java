package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.service.ProductService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

/**
 * 商品管理控制器（后台管理）
 */
@RestController
@RequestMapping("/admin/products")
public class AdminProductController {

    @Resource private ProductService productService;

    /** 商品列表 */
    @GetMapping
    public Result<PageResult<Product>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {
        return Result.success(productService.getAdminProductList(page, size, categoryId, keyword, status));
    }

    /** 添加商品 */
    @PostMapping
    @OperLog(module = "PRODUCT", type = "CREATE", description = "添加商品")
    public Result<Void> save(@RequestBody Product product) {
        productService.saveProduct(product);
        return Result.success();
    }

    /** 更新商品 */
    @PutMapping
    @OperLog(module = "PRODUCT", type = "UPDATE", description = "更新商品")
    public Result<Void> update(@RequestBody Product product) {
        productService.updateProduct(product);
        return Result.success();
    }

    /** 删除商品 */
    @DeleteMapping("/{id}")
    @OperLog(module = "PRODUCT", type = "DELETE", description = "删除商品")
    public Result<Void> delete(@PathVariable Long id) {
        productService.deleteProduct(id);
        return Result.success();
    }

    /** 商品上架 */
    @PutMapping("/{id}/on")
    @OperLog(module = "PRODUCT", type = "UPDATE", description = "商品上架")
    public Result<Void> onShelf(@PathVariable Long id) {
        productService.toggleProductStatus(id, 1);
        return Result.success();
    }

    /** 商品下架 */
    @PutMapping("/{id}/off")
    @OperLog(module = "PRODUCT", type = "UPDATE", description = "商品下架")
    public Result<Void> offShelf(@PathVariable Long id) {
        productService.toggleProductStatus(id, 0);
        return Result.success();
    }
}