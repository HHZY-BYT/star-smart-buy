package com.star.smartbuy.controller;

import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

/**
 * 商品控制器
 * <p>
 * 提供商品列表、详情、搜索等公开接口，无需登录即可访问。
 * </p>
 *
 * @author StarSmart Buy Team
 * @since 1.0
 */
@Slf4j
@RestController
@RequestMapping("/products")
public class ProductController {

    @Resource private ProductService productService;

    /**
     * 商品分页列表
     *
     * @param page       页码（默认 1）
     * @param size       每页数量（默认 10）
     * @param categoryId 分类 ID（可选）
     * @param keyword    搜索关键词（可选）
     * @return 商品分页结果
     */
    @GetMapping
    public Result<PageResult<Product>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String keyword) {
        return Result.success(productService.getProductList(page, size, categoryId, keyword));
    }

    /**
     * 商品详情
     *
     * @param id 商品 ID
     * @return 包含商品信息和规格列表的详情
     */
    @GetMapping("/{id}")
    public Result<Product> detail(@PathVariable Long id) {
        return Result.success(productService.getProductDetail(id));
    }

    /**
     * 搜索商品
     *
     * @param keyword 搜索关键词（必填）
     * @param page    页码（默认 1）
     * @param size    每页数量（默认 10）
     * @return 搜索结果分页
     */
    @GetMapping("/search")
    public Result<PageResult<Product>> search(
            @RequestParam String keyword,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(productService.searchProducts(keyword, page, size));
    }
}
