package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.star.smartbuy.entity.ProductCategory;
import com.star.smartbuy.mapper.ProductCategoryMapper;
import com.star.smartbuy.service.CategoryService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * 商品分类服务实现
 */
@Service
public class CategoryServiceImpl extends ServiceImpl<ProductCategoryMapper, ProductCategory> implements CategoryService {

    /** 获取所有分类（树形结构） */
    @Override
    public List<ProductCategory> getCategoryTree() {
        List<ProductCategory> allCategories = this.list();
        return buildTree(allCategories, 0L);
    }

    /** 递归构建分类树 */
    private List<ProductCategory> buildTree(List<ProductCategory> all, Long parentId) {
        List<ProductCategory> tree = new ArrayList<>();
        for (ProductCategory category : all) {
            if (category.getParentId().equals(parentId)) {
                tree.add(category);
            }
        }
        return tree;
    }

    /** 获取一级分类 */
    @Override
    public List<ProductCategory> getParentCategories() {
        LambdaQueryWrapper<ProductCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductCategory::getParentId, 0);
        wrapper.orderByAsc(ProductCategory::getSort);
        return this.list(wrapper);
    }

    /** 获取子分类 */
    @Override
    public List<ProductCategory> getChildCategories(Long parentId) {
        LambdaQueryWrapper<ProductCategory> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ProductCategory::getParentId, parentId);
        wrapper.orderByAsc(ProductCategory::getSort);
        return this.list(wrapper);
    }

    /** 获取分类路径（面包屑） */
    @Override
    public List<ProductCategory> getCategoryPath(Long categoryId) {
        List<ProductCategory> path = new ArrayList<>();
        ProductCategory current = this.getById(categoryId);
        while (current != null) {
            path.add(0, current);
            if (current.getParentId() != 0) {
                current = this.getById(current.getParentId());
            } else {
                break;
            }
        }
        return path;
    }
}