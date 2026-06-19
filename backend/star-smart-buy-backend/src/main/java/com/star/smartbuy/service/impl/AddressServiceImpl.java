package com.star.smartbuy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.star.smartbuy.entity.Address;
import com.star.smartbuy.mapper.AddressMapper;
import com.star.smartbuy.service.AddressService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.List;

/**
 * 收货地址服务实现
 */
@Service
public class AddressServiceImpl extends ServiceImpl<AddressMapper, Address> implements AddressService {

    /** 获取用户的所有地址 */
    @Override
    public List<Address> getUserAddresses(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.orderByDesc(Address::getIsDefault)
                .orderByDesc(Address::getCreatedAt);
        return this.list(wrapper);
    }

    /** 获取用户默认地址 */
    @Override
    public Address getDefaultAddress(Long userId) {
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        wrapper.eq(Address::getIsDefault, 1);
        return this.getOne(wrapper);
    }

    /** 设置默认地址 */
    @Override
    @Transactional
    public void setDefaultAddress(Long userId, Long addressId) {
        // 先将用户所有地址设为非默认
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, userId);
        List<Address> addresses = this.list(wrapper);
        for (Address address : addresses) {
            address.setIsDefault(0);
        }
        this.updateBatchById(addresses);

        // 设置新的默认地址
        Address defaultAddress = this.getById(addressId);
        if (defaultAddress != null && defaultAddress.getUserId().equals(userId)) {
            defaultAddress.setIsDefault(1);
            this.updateById(defaultAddress);
        }
    }

    /** 保存或更新地址 */
    @Override
    @Transactional
    public void saveAddress(Address address) {
        // 如果是第一个地址，自动设为默认
        LambdaQueryWrapper<Address> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Address::getUserId, address.getUserId());
        long count = this.count(wrapper);
        if (count == 0) {
            address.setIsDefault(1);
        }
        this.save(address);
    }

    /** 删除地址 */
    @Override
    @Transactional
    public void deleteAddress(Long userId, Long addressId) {
        Address address = this.getById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            throw new RuntimeException("地址不存在");
        }
        this.removeById(addressId);
    }
}