package com.star.smartbuy.controller;

import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Address;
import com.star.smartbuy.service.AddressService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 收货地址控制器
 */
@RestController
@RequestMapping("/address")
public class AddressController {

    @Resource
    private AddressService addressService;

    /** 获取用户地址列表 */
    @GetMapping
    public Result<List<Address>> getAddressList(@RequestAttribute("userId") Long userId) {
        List<Address> addresses = addressService.getUserAddresses(userId);
        return Result.success(addresses);
    }

    /** 获取地址详情 */
    @GetMapping("/{id}")
    public Result<Address> getAddressDetail(@RequestAttribute("userId") Long userId,
                                            @PathVariable Long id) {
        Address address = addressService.getById(id);
        if (address == null || !address.getUserId().equals(userId)) {
            return Result.error("地址不存在");
        }
        return Result.success(address);
    }

    /** 获取默认地址 */
    @GetMapping("/default")
    public Result<Address> getDefaultAddress(@RequestAttribute("userId") Long userId) {
        Address address = addressService.getDefaultAddress(userId);
        return Result.success(address);
    }

    /** 新增地址 */
    @PostMapping
    public Result<Void> addAddress(@RequestAttribute("userId") Long userId,
                                   @RequestBody Address address) {
        address.setUserId(userId);
        addressService.saveAddress(address);
        return Result.success();
    }

    /** 更新地址 */
    @PutMapping
    public Result<Void> updateAddress(@RequestAttribute("userId") Long userId,
                                      @RequestBody Address address) {
        if (address.getId() == null) {
            return Result.error("地址ID不能为空");
        }
        Address existing = addressService.getById(address.getId());
        if (existing == null || !existing.getUserId().equals(userId)) {
            return Result.error("地址不存在");
        }
        address.setUserId(userId);
        addressService.updateById(address);
        return Result.success();
    }

    /** 设置默认地址 */
    @PutMapping("/{id}/default")
    public Result<Void> setDefaultAddress(@RequestAttribute("userId") Long userId,
                                          @PathVariable Long id) {
        addressService.setDefaultAddress(userId, id);
        return Result.success();
    }

    /** 删除地址 */
    @DeleteMapping("/{id}")
    public Result<Void> deleteAddress(@RequestAttribute("userId") Long userId,
                                      @PathVariable Long id) {
        addressService.deleteAddress(userId, id);
        return Result.success();
    }
}
