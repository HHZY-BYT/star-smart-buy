package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.entity.ProductCategory;
import com.star.smartbuy.entity.ProductSpec;
import com.star.smartbuy.mapper.ProductCategoryMapper;
import com.star.smartbuy.mapper.ProductMapper;
import com.star.smartbuy.mapper.ProductSpecMapper;
import com.star.smartbuy.service.ProductService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 商品服务实现
 * <p>
 * 核心优化：将三个分页查询方法合并为统一的 queryProducts 方法，
 * 使用批量查询（selectBatchIds）替代逐条 N+1 查询分类名称。
 * 返回类型从 HashMap 统一为类型安全的 PageResult。
 * </p>
 */
@Slf4j
@Service
public class ProductServiceImpl extends ServiceImpl<ProductMapper, Product> implements ProductService {

    @Resource private ProductCategoryMapper categoryMapper;
    @Resource private ProductSpecMapper specMapper;

    /** 分页查询商品列表（修复 N+1：批量查询分类名） */
    @Override
    public PageResult<Product> getProductList(int page, int size, Long categoryId, String keyword) {
        return queryProducts(page, size, categoryId, keyword, 1);
    }

    /** 获取商品详情 */
    @Override
    public Product getProductDetail(Long id) {
        Product product = this.getById(id);
        if (product == null) throw new BusinessException("商品不存在");

        // 设置分类名称
        ProductCategory category = categoryMapper.selectById(product.getCategoryId());
        if (category != null) product.setCategoryName(category.getName());

        // 查询规格
        List<ProductSpec> specs = specMapper.selectList(
                new LambdaQueryWrapper<ProductSpec>().eq(ProductSpec::getProductId, id));
        product.setSpecs(specs);

        return product;
    }

    /** 搜索商品 */
    @Override
    public PageResult<Product> searchProducts(String keyword, int page, int size) {
        return queryProducts(page, size, null, keyword, 1);
    }

    /** 保存商品 */
    @Override
    @Transactional
    public void saveProduct(Product product) {
        product.setStatus(1);
        this.save(product);

        if (product.getSpecs() != null) {
            for (ProductSpec spec : product.getSpecs()) {
                spec.setProductId(product.getId());
                specMapper.insert(spec);
            }
        }
        log.info("商品创建成功: {}", product.getName());
    }

    /** 更新商品 */
    @Override
    @Transactional
    public void updateProduct(Product product) {
        this.updateById(product);
        if (product.getSpecs() != null) {
            specMapper.delete(new LambdaQueryWrapper<ProductSpec>().eq(ProductSpec::getProductId, product.getId()));
            for (ProductSpec spec : product.getSpecs()) {
                spec.setId(null);
                spec.setProductId(product.getId());
                specMapper.insert(spec);
            }
        }
        log.info("商品更新成功: {}", product.getName());
    }

    /** 删除商品 */
    @Override
    @Transactional
    public void deleteProduct(Long id) {
        specMapper.delete(new LambdaQueryWrapper<ProductSpec>().eq(ProductSpec::getProductId, id));
        this.removeById(id);
        log.info("商品删除成功: id={}", id);
    }

    /** 商品上下架 */
    @Override
    public void toggleProductStatus(Long id, Integer status) {
        Product product = this.getById(id);
        if (product == null) throw new BusinessException("商品不存在");
        product.setStatus(status);
        this.updateById(product);
    }

    /** 管理端商品列表 */
    @Override
    public PageResult<Product> getAdminProductList(int page, int size, Long categoryId, String keyword, Integer status) {
        Integer statusFilter = status != null ? status : null;
        return queryProducts(page, size, categoryId, keyword, statusFilter);
    }

    // ======== 核心查询：统一处理分页 + 关键词 + 分类筛选 + 批量查分类名（消除 N+1） ========

    /**
     * 统一商品查询方法
     * <p>
     * 合并了 getProductList / searchProducts / getAdminProductList 三个方法的公共逻辑，
     * 关键词搜索同时匹配分类名（用户搜"手机"时也能找到"智能手机"分类下的商品）。
     * 最关键的性能优化：分页查询后批量加载 categoryName，避免 N 次逐条 SQL 查询。
     * </p>
     */
    private PageResult<Product> queryProducts(int page, int size, Long categoryId, String keyword, Integer status) {
        LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();

        // 状态筛选
        if (status != null) {
            wrapper.eq(Product::getStatus, status);
        }

        // 分类筛选（含子分类）
        if (categoryId != null) {
            List<Long> categoryIds = new ArrayList<>();
            categoryIds.add(categoryId);
            collectChildCategoryIds(categoryId, categoryIds);
            wrapper.in(Product::getCategoryId, categoryIds);
        }

        // 关键词搜索
        if (keyword != null && !keyword.isEmpty()) {
            LambdaQueryWrapper<ProductCategory> catWrapper = new LambdaQueryWrapper<>();
            catWrapper.like(ProductCategory::getName, keyword);
            List<ProductCategory> matchedCategories = categoryMapper.selectList(catWrapper);
            List<Long> matchedCategoryIds = matchedCategories.stream()
                    .map(ProductCategory::getId).collect(Collectors.toList());

            wrapper.and(w -> {
                w.like(Product::getName, keyword)
                 .or().like(Product::getDescription, keyword);
                if (!matchedCategoryIds.isEmpty()) {
                    w.or().in(Product::getCategoryId, matchedCategoryIds);
                }
            });
        }
        wrapper.orderByDesc(Product::getCreatedAt);

        Page<Product> pageResult = this.page(new Page<>(page, size), wrapper);

        // 批量查询分类名（消除 N+1）
        if (!pageResult.getRecords().isEmpty()) {
            Set<Long> catIds = pageResult.getRecords().stream()
                    .map(Product::getCategoryId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            if (!catIds.isEmpty()) {
                Map<Long, String> nameMap = categoryMapper.selectBatchIds(catIds).stream()
                        .collect(Collectors.toMap(ProductCategory::getId, ProductCategory::getName, (a, b) -> a));
                pageResult.getRecords().forEach(p -> {
                    String name = nameMap.get(p.getCategoryId());
                    if (name != null) p.setCategoryName(name);
                });
            }
        }

        return PageResult.of(pageResult);
    }

    /** 递归收集子分类ID */
    private void collectChildCategoryIds(Long parentId, List<Long> ids) {
        LambdaQueryWrapper<ProductCategory> catWrapper = new LambdaQueryWrapper<>();
        catWrapper.eq(ProductCategory::getParentId, parentId);
        List<ProductCategory> children = categoryMapper.selectList(catWrapper);
        for (ProductCategory child : children) {
            ids.add(child.getId());
            collectChildCategoryIds(child.getId(), ids);
        }
    }
}