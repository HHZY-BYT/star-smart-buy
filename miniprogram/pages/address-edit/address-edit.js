// pages/address-edit/address-edit.js
const { getAddressDetail, addAddress, updateAddress } = require('../../api/address')

Page({
  data: {
    id: null,
    receiver: '',
    phone: '',
    province: '',
    city: '',
    district: '',
    detail: '',
    isDefault: false,
    loading: false
  },

  onLoad(options) {
    if (options.id) {
      this.setData({ id: options.id })
      this.loadAddressDetail(options.id)
    }
  },

  // 加载地址详情
  async loadAddressDetail(id) {
    try {
      this.setData({ loading: true })
      
      const address = await getAddressDetail(id)
      
      this.setData({
        receiver: address.receiver,
        phone: address.phone,
        province: address.province,
        city: address.city,
        district: address.district,
        detail: address.detail,
        isDefault: address.isDefault === 1,
        loading: false
      })
    } catch (error) {
      console.error('加载地址详情失败:', error)
      this.setData({ loading: false })
    }
  },

  // 输入收货人
  onReceiverInput(e) {
    this.setData({ receiver: e.detail.value })
  },

  // 输入手机号
  onPhoneInput(e) {
    this.setData({ phone: e.detail.value })
  },

  // 选择地区
  onRegionChange(e) {
    const region = e.detail.value
    this.setData({
      province: region[0],
      city: region[1],
      district: region[2]
    })
  },

  // 输入详细地址
  onDetailInput(e) {
    this.setData({ detail: e.detail.value })
  },

  // 切换默认地址
  onDefaultChange(e) {
    this.setData({ isDefault: e.detail.value })
  },

  // 保存地址
  async onSave() {
    const { id, receiver, phone, province, city, district, detail, isDefault } = this.data
    
    // 验证
    if (!receiver) {
      wx.showToast({ title: '请输入收货人', icon: 'none' })
      return
    }
    if (!phone) {
      wx.showToast({ title: '请输入手机号', icon: 'none' })
      return
    }
    if (!/^1[3-9]\d{9}$/.test(phone)) {
      wx.showToast({ title: '手机号格式不正确', icon: 'none' })
      return
    }
    if (!province || !city || !district) {
      wx.showToast({ title: '请选择地区', icon: 'none' })
      return
    }
    if (!detail) {
      wx.showToast({ title: '请输入详细地址', icon: 'none' })
      return
    }
    
    try {
      this.setData({ loading: true })
      wx.showLoading({ title: '保存中...' })
      
      const addressData = {
        receiver,
        phone,
        province,
        city,
        district,
        detail,
        isDefault: isDefault ? 1 : 0
      }
      
      if (id) {
        addressData.id = id
        await updateAddress(addressData)
      } else {
        await addAddress(addressData)
      }
      
      wx.hideLoading()
      this.setData({ loading: false })
      
      wx.showToast({
        title: '保存成功',
        icon: 'success'
      })
      
      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      wx.hideLoading()
      this.setData({ loading: false })
      console.error('保存地址失败:', error)
    }
  }
})