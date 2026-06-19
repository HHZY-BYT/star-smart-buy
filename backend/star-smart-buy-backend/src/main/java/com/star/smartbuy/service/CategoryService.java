package com.star.smartbuy.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.star.smartbuy.entity.ProductCategory;

import java.util.List;

/**
 * 商品分类服务接口
 */
public interface CategoryService extends IService<ProductCategory> {

    /**
     * 获取所有分类（树形结构）
     */
    List<ProductCategory> getCategoryTree();

    /**
     * 获取一级分类
     */
    List<ProductCategory> getParentCategories();

    /**
     * 获取子分类
     */
    List<ProductCategory> getChildCategories(Long parentId);

    /**
     * 获取分类路径（面包屑）
     */
    List<ProductCategory> getCategoryPath(Long categoryId);
}