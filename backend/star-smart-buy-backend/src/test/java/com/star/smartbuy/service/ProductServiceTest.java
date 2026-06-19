package com.star.smartbuy.service;

import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.entity.Product;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import jakarta.annotation.Resource;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 商品服务测试
 */
@SpringBootTest
@ActiveProfiles("test")
class ProductServiceTest {

    @Resource
    private ProductService productService;

    @Test
    void testGetProductList_ReturnsPageResult() {
        PageResult<Product> result = productService.getProductList(1, 10, null, null);
        assertNotNull(result);
        assertTrue(result.getTotal() >= 0);
        assertEquals(1, result.getPage());
        assertEquals(10, result.getSize());
        assertNotNull(result.getRecords());
    }

    @Test
    void testGetProductDetail_NotFound() {
        assertThrows(BusinessException.class, () ->
                productService.getProductDetail(-1L));
    }

    @Test
    void testSearchProducts_ReturnsPageResult() {
        PageResult<Product> result = productService.searchProducts("手机", 1, 10);
        assertNotNull(result);
        assertNotNull(result.getRecords());
    }

    @Test
    void testToggleProductStatus_NotFound() {
        assertThrows(BusinessException.class, () ->
                productService.toggleProductStatus(-1L, 1));
    }
}
