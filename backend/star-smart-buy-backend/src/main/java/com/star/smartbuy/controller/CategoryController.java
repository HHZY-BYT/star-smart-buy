package com.star.smartbuy.controller;

import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.ProductCategory;
import com.star.smartbuy.mapper.ProductCategoryMapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 分类控制器（用户端）
 */
@RestController
@RequestMapping("/categories")
public class CategoryController {

    @Resource
    private ProductCategoryMapper categoryMapper;

    /** 获取分类列表 */
    @GetMapping
    public Result<List<ProductCategory>> list() {
        List<ProductCategory> allCategories = categoryMapper.selectList(null);
        List<ProductCategory> tree = buildTree(allCategories);
        return Result.success(tree);
    }

    /** 获取一级分类 */
    @GetMapping("/parent")
    public Result<List<ProductCategory>> getParentCategories() {
        List<ProductCategory> categories = categoryMapper.selectList(
            new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ProductCategory>()
                .eq(ProductCategory::getParentId, 0)
                .orderByAsc(ProductCategory::getSort)
        );
        return Result.success(categories);
    }

    /** 获取子分类 */
    @GetMapping("/children/{parentId}")
    public Result<List<ProductCategory>> getChildren(@PathVariable Long parentId) {
        List<ProductCategory> categories = categoryMapper.selectList(
            new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ProductCategory>()
                .eq(ProductCategory::getParentId, parentId)
                .orderByAsc(ProductCategory::getSort)
        );
        return Result.success(categories);
    }

    /** 构建树形结构 */
    private List<ProductCategory> buildTree(List<ProductCategory> categories) {
        categories.sort((a, b) -> {
            if (a.getSort() == null) a.setSort(0);
            if (b.getSort() == null) b.setSort(0);
            return a.getSort().compareTo(b.getSort());
        });

        return categories.stream()
            .filter(c -> c.getParentId() == null || c.getParentId() == 0)
            .peek(c -> c.setChildren(getChildren(c.getId(), categories)))
            .toList();
    }

    /** 递归获取子分类列表 */
    private List<ProductCategory> getChildren(Long parentId, List<ProductCategory> all) {
        return all.stream()
            .filter(c -> parentId.equals(c.getParentId()))
            .peek(c -> c.setChildren(getChildren(c.getId(), all)))
            .toList();
    }
}
