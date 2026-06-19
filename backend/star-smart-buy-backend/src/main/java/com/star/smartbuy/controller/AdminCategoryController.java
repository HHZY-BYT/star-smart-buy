package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.ProductCategory;
import com.star.smartbuy.mapper.ProductCategoryMapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

/**
 * 管理员 - 分类管理控制器
 */
@RestController
@RequestMapping("/admin/categories")
public class AdminCategoryController {

    @Resource
    private ProductCategoryMapper categoryMapper;

    /**
     * 分类列表（树形结构）
     */
    @GetMapping
    public Result<List<ProductCategory>> list() {
        List<ProductCategory> allCategories = categoryMapper.selectList(null);

        // 构建树形结构
        List<ProductCategory> tree = buildTree(allCategories);
        return Result.success(tree);
    }

    /**
     * 新增分类
     */
    @PostMapping
    @OperLog(module = "CATEGORY", type = "CREATE", description = "新增分类")
    public Result<Void> save(@RequestBody ProductCategory category) {
        category.setCreatedAt(LocalDateTime.now());
        categoryMapper.insert(category);
        return Result.success();
    }

    /**
     * 更新分类
     */
    @PutMapping
    @OperLog(module = "CATEGORY", type = "UPDATE", description = "更新分类")
    public Result<Void> update(@RequestBody ProductCategory category) {
        categoryMapper.updateById(category);
        return Result.success();
    }

    /**
     * 删除分类
     */
    @DeleteMapping("/{id}")
    @OperLog(module = "CATEGORY", type = "DELETE", description = "删除分类")
    public Result<Void> delete(@PathVariable Long id) {
        // 检查是否有子分类
        List<ProductCategory> children = categoryMapper.selectList(
            new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<ProductCategory>()
                .eq(ProductCategory::getParentId, id)
        );
        if (!children.isEmpty()) {
            return Result.error("该分类下存在子分类，请先删除子分类");
        }
        categoryMapper.deleteById(id);
        return Result.success();
    }

    /**
     * 构建树形结构
     */
    private List<ProductCategory> buildTree(List<ProductCategory> categories) {
        // 先按 sort 排序
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

    private List<ProductCategory> getChildren(Long parentId, List<ProductCategory> all) {
        return all.stream()
            .filter(c -> parentId.equals(c.getParentId()))
            .peek(c -> c.setChildren(getChildren(c.getId(), all)))
            .toList();
    }
}
