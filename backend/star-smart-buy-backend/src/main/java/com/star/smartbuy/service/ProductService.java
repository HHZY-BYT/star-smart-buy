package com.star.smartbuy.service;

import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.entity.Product;

/**
 * 商品服务接口
 */
public interface ProductService {

    /** 分页查询商品列表 */
    PageResult<Product> getProductList(int page, int size, Long categoryId, String keyword);

    /** 获取商品详情 */
    Product getProductDetail(Long id);

    /** 搜索商品 */
    PageResult<Product> searchProducts(String keyword, int page, int size);

    /** 商品 CRUD 操作（后台管理） */
    void saveProduct(Product product);
    void updateProduct(Product product);
    void deleteProduct(Long id);

    /** 商品上下架 */
    void toggleProductStatus(Long id, Integer status);

    /** 管理端商品列表（不限制状态） */
    PageResult<Product> getAdminProductList(int page, int size, Long categoryId, String keyword, Integer status);
}
