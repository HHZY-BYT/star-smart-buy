package com.star.smartbuy.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.star.smartbuy.entity.Address;

import java.util.List;

/**
 * 收货地址服务接口
 */
public interface AddressService extends IService<Address> {

    /**
     * 获取用户的所有地址
     */
    List<Address> getUserAddresses(Long userId);

    /**
     * 获取用户默认地址
     */
    Address getDefaultAddress(Long userId);

    /**
     * 设置默认地址
     */
    void setDefaultAddress(Long userId, Long addressId);

    /**
     * 保存或更新地址
     */
    void saveAddress(Address address);

    /**
     * 删除地址
     */
    void deleteAddress(Long userId, Long addressId);
}