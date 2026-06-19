// pages/create-order/create-order.js
const { createOrder } = require('../../api/order')
const { getDefaultAddress, getAddressList } = require('../../api/address')
const { formatPrice, requireLogin } = require('../../utils/util')

Page({
  data: {
    items: [],
    address: null,
    totalPrice: 0,
    totalCount: 0,
    remark: '',
    loading: false
  },

  onLoad(options) {
    requireLogin(() => {
      if (options.items) {
        try {
          const items = JSON.parse(options.items)
          this.processItems(items)
        } catch (e) {
          console.error('解析商品数据失败:', e)
        }
      }
      this.loadDefaultAddress()
    })
  },

  // 处理商品数据
  processItems(items) {
    let totalPrice = 0
    let totalCount = 0
    
    items.forEach(item => {
      item.priceText = formatPrice(item.price)
      totalPrice += item.price * item.quantity
      totalCount += item.quantity
    })
    
    this.setData({
      items,
      totalPrice: formatPrice(totalPrice),
      totalCount
    })
  },

  // 加载默认地址
  async loadDefaultAddress() {
    try {
      const address = await getDefaultAddress()
      this.setData({ address })
    } catch (error) {
      console.error('加载地址失败:', error)
    }
  },

  // 选择地址
  onSelectAddress() {
    wx.navigateTo({
      url: '/pages/address/address?select=1'
    })
  },

  // 输入备注
  onRemarkInput(e) {
    this.setData({ remark: e.detail.value })
  },

  // 提交订单
  async onSubmit() {
    if (!this.data.address) {
      wx.showToast({
        title: '请选择收货地址',
        icon: 'none'
      })
      return
    }
    
    try {
      this.setData({ loading: true })
      wx.showLoading({ title: '提交中...' })
      
      // 构建订单数据
      const orderData = {
        addressId: this.data.address.id,
        items: this.data.items.map(item => ({
          productId: item.productId,
          quantity: item.quantity,
          specIds: item.specIds || (item.specId ? String(item.specId) : null),
          productImage: item.image || null
        })),
        cartIds: this.data.items
          .filter(item => item.cartId)
          .map(item => item.cartId),
        remark: this.data.remark
      }
      
      const order = await createOrder(orderData)
      
      wx.hideLoading()
      this.setData({ loading: false })
      
      wx.showToast({
        title: '订单创建成功',
        icon: 'success'
      })
      
      // 跳转到订单详情或支付
      setTimeout(() => {
        wx.redirectTo({
          url: `/pages/order-detail/order-detail?id=${order.id}`
        })
      }, 1500)
    } catch (error) {
      wx.hideLoading()
      this.setData({ loading: false })
      console.error('创建订单失败:', error)
    }
  }
})