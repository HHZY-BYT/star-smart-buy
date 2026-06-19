package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.star.smartbuy.common.BusinessException;
import com.star.smartbuy.entity.Product;
import com.star.smartbuy.entity.ProductSpec;
import com.star.smartbuy.entity.ShoppingCart;
import com.star.smartbuy.mapper.ProductMapper;
import com.star.smartbuy.mapper.ProductSpecMapper;
import com.star.smartbuy.mapper.ShoppingCartMapper;
import com.star.smartbuy.service.ShoppingCartService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 购物车服务实现
 * <p>
 * 性能优化：getUserCart 方法使用 selectBatchIds 批量查询商品和规格信息，
 * 将原来每个购物车项触发 1-2 次独立 SQL 的 N+1 模式优化为固定 3 次 SQL。
 * </p>
 */
@Slf4j
@Service
public class ShoppingCartServiceImpl extends ServiceImpl<ShoppingCartMapper, ShoppingCart> implements ShoppingCartService {

    @Resource private ProductMapper productMapper;
    @Resource private ProductSpecMapper productSpecMapper;

    /** 获取用户购物车（修复 N+1：批量查询商品和规格） */
    @Override
    public List<Map<String, Object>> getUserCart(Long userId) {
        LambdaQueryWrapper<ShoppingCart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShoppingCart::getUserId, userId);
        List<ShoppingCart> carts = this.list(wrapper);

        if (carts.isEmpty()) return List.of();

        // 批量查商品
        Set<Long> productIds = carts.stream()
                .map(ShoppingCart::getProductId).collect(Collectors.toSet());
        Map<Long, Product> productMap = productMapper.selectBatchIds(productIds).stream()
                .collect(Collectors.toMap(Product::getId, p -> p, (a, b) -> a));

        // 收集所有规格ID（从 specIds 字段解析）
        Set<Long> allSpecIds = new HashSet<>();
        for (ShoppingCart cart : carts) {
            if (cart.getSpecIds() != null && !cart.getSpecIds().isEmpty()) {
                for (String idStr : cart.getSpecIds().split(",")) {
                    try { allSpecIds.add(Long.parseLong(idStr.trim())); } catch (NumberFormatException ignored) {}
                }
            } else if (cart.getSpecId() != null) {
                allSpecIds.add(cart.getSpecId());
            }
        }
        Map<Long, ProductSpec> specMap = allSpecIds.isEmpty() ? Map.of()
                : productSpecMapper.selectBatchIds(allSpecIds).stream()
                .collect(Collectors.toMap(ProductSpec::getId, s -> s, (a, b) -> a));

        List<Map<String, Object>> result = new ArrayList<>();
        for (ShoppingCart cart : carts) {
            Product product = productMap.get(cart.getProductId());
            if (product != null && product.getStatus() == 1) {
                Map<String, Object> item = new HashMap<>();
                item.put("id", cart.getId());
                item.put("productId", product.getId());
                item.put("name", product.getName());
                item.put("productName", product.getName());
                item.put("price", product.getPrice());

                // 图片处理：取第一张
                String img = product.getImages();
                if (img != null && img.contains(",")) {
                    img = img.split(",")[0].trim();
                }
                item.put("image", img);

                item.put("quantity", cart.getQuantity());
                item.put("subtotal", product.getPrice() * cart.getQuantity());
                item.put("stock", product.getStock());

                // 多规格处理
                StringBuilder nameBuilder = new StringBuilder();
                StringBuilder valueBuilder = new StringBuilder();
                if (cart.getSpecIds() != null && !cart.getSpecIds().isEmpty()) {
                    item.put("specIds", cart.getSpecIds());
                    for (String idStr : cart.getSpecIds().split(",")) {
                        try {
                            ProductSpec spec = specMap.get(Long.parseLong(idStr.trim()));
                            if (spec != null) {
                                if (nameBuilder.length() > 0) nameBuilder.append(";");
                                nameBuilder.append(spec.getSpecName());
                                if (valueBuilder.length() > 0) valueBuilder.append(";");
                                valueBuilder.append(spec.getSpecValue());
                            }
                        } catch (NumberFormatException ignored) {}
                    }
                } else if (cart.getSpecId() != null) {
                    ProductSpec spec = specMap.get(cart.getSpecId());
                    if (spec != null) {
                        nameBuilder.append(spec.getSpecName());
                        valueBuilder.append(spec.getSpecValue());
                        item.put("specId", spec.getId());
                    }
                }
                if (nameBuilder.length() > 0) {
                    item.put("specName", nameBuilder.toString());
                    item.put("specValue", valueBuilder.toString());
                }

                result.add(item);
            }
        }
        return result;
    }

    @Override
    @Transactional
    public void addToCart(Long userId, Long productId, Integer quantity, Long specId, String specIds) {
        Product product = productMapper.selectById(productId);
        if (product == null || product.getStatus() != 1) {
            throw new BusinessException("商品不存在或已下架");
        }
        if (product.getStock() < quantity) {
            throw new BusinessException("库存不足");
        }

        LambdaQueryWrapper<ShoppingCart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShoppingCart::getUserId, userId);
        wrapper.eq(ShoppingCart::getProductId, productId);

        // 用 specIds 匹配（新逻辑），兼容旧的 specId
        if (specIds != null && !specIds.isEmpty()) {
            wrapper.eq(ShoppingCart::getSpecIds, specIds);
        } else if (specId != null) {
            wrapper.eq(ShoppingCart::getSpecId, specId);
        } else {
            wrapper.isNull(ShoppingCart::getSpecIds).isNull(ShoppingCart::getSpecId);
        }

        ShoppingCart cart = this.getOne(wrapper);

        if (cart != null) {
            cart.setQuantity(cart.getQuantity() + quantity);
            this.updateById(cart);
        } else {
            cart = new ShoppingCart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setSpecId(specId);
            cart.setSpecIds(specIds);
            cart.setQuantity(quantity);
            this.save(cart);
        }
    }

    @Override
    @Transactional
    public void updateQuantity(Long userId, Long cartId, Integer quantity) {
        ShoppingCart cart = this.getById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw new BusinessException("购物车商品不存在");
        }

        Product product = productMapper.selectById(cart.getProductId());
        if (product.getStock() < quantity) {
            throw new BusinessException("库存不足");
        }

        cart.setQuantity(quantity);
        this.updateById(cart);
    }

    @Override
    @Transactional
    public void removeFromCart(Long userId, Long cartId) {
        ShoppingCart cart = this.getById(cartId);
        if (cart == null || !cart.getUserId().equals(userId)) {
            throw new BusinessException("购物车商品不存在");
        }
        this.removeById(cartId);
    }

    @Override
    @Transactional
    public void clearCart(Long userId) {
        LambdaQueryWrapper<ShoppingCart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShoppingCart::getUserId, userId);
        this.remove(wrapper);
    }

    @Override
    public int getCartCount(Long userId) {
        LambdaQueryWrapper<ShoppingCart> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ShoppingCart::getUserId, userId);
        return (int) this.count(wrapper);
    }
}
