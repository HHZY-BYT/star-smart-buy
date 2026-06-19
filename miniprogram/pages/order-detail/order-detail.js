// pages/order-detail/order-detail.js
const { getOrderDetail, cancelOrder, payOrder, confirmOrder, deleteOrder, applyRefund } = require('../../api/order')
const { formatPrice, formatTime, getOrderStatusText, getOrderStatusClass } = require('../../utils/util')

Page({
  data: {
    order: null,
    loading: true
  },

  onLoad(options) {
    const orderId = options.id
    if (orderId) {
      this.orderId = orderId
      this.loadOrderDetail(orderId)
    }
  },

  onShow() {
    // 每次页面显示时刷新数据，确保状态同步
    if (this.orderId) {
      this.loadOrderDetail(this.orderId)
    }
  },

  // 加载订单详情
  async loadOrderDetail(orderId) {
    try {
      this.setData({ loading: true })
      
      const order = await getOrderDetail(orderId)
      
      order.statusText = getOrderStatusText(order.status)
      order.statusClass = getOrderStatusClass(order.status)
      order.totalAmountText = formatPrice(order.totalAmount)
      order.createdAtText = formatTime(order.createdAt, 'YYYY-MM-DD HH:mm:ss')
      
      // 处理商品列表
      order.items = (order.items || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price),
        subtotalText: formatPrice(item.subtotal)
      }))
      
      // 构建收货信息
      order.addressInfo = {
        receiver: order.consignee || '',
        phone: order.phone || '',
        detail: order.address || ''
      }
      
      this.setData({
        order,
        loading: false
      })
    } catch (error) {
      console.error('加载订单详情失败:', error)
      this.setData({ loading: false })
    }
  },

  // 取消订单
  async onCancelOrder() {
    wx.showModal({
      title: '提示',
      content: '确定要取消该订单吗？',
      success: async (res) => {
        if (res.confirm) {
          try {
            await cancelOrder(this.data.order.id)
            wx.showToast({
              title: '订单已取消',
              icon: 'success'
            })
            this.loadOrderDetail(this.data.order.id)
          } catch (error) {
            console.error('取消订单失败:', error)
          }
        }
      }
    })
  },

  // 确认收货
  async onConfirmOrder() {
    wx.showModal({
      title: '提示',
      content: '确定已收到货物吗？',
      success: async (res) => {
        if (res.confirm) {
          try {
            await confirmOrder(this.data.order.id)
            wx.showToast({
              title: '已确认收货',
              icon: 'success'
            })
            this.loadOrderDetail(this.data.order.id)
          } catch (error) {
            console.error('确认收货失败:', error)
          }
        }
      }
    })
  },

  // 去支付（模拟）
  onPayOrder() {
    wx.showModal({
      title: '模拟支付',
      content: `需支付 ¥${this.data.order.totalAmountText}，确认支付？`,
      success: async (res) => {
        if (res.confirm) {
          try {
            wx.showLoading({ title: '支付中...' })
            await payOrder(this.data.order.id)
            wx.hideLoading()
            wx.showToast({
              title: '支付成功',
              icon: 'success'
            })
            this.loadOrderDetail(this.data.order.id)
          } catch (error) {
            wx.hideLoading()
            console.error('支付失败:', error)
          }
        }
      }
    })
  },

  // 删除订单
  onDeleteOrder() {
    wx.showModal({
      title: '提示',
      content: '确定要删除该订单吗？删除后不可恢复',
      success: async (res) => {
        if (res.confirm) {
          try {
            await deleteOrder(this.data.order.id)
            wx.showToast({
              title: '订单已删除',
              icon: 'success'
            })
            setTimeout(() => wx.navigateBack(), 1500)
          } catch (error) {
            console.error('删除订单失败:', error)
          }
        }
      }
    })
  },

  // 评价订单
  onReviewOrder() {
    wx.navigateTo({
      url: `/pages/review/review?orderId=${this.data.order.id}`
    })
  },

  // 申请退款
  onApplyRefund() {
    wx.navigateTo({
      url: `/pages/refund/refund?orderId=${this.data.order.id}`
    })
  },

  // 复制订单号
  onCopyOrderNo() {
    wx.setClipboardData({
      data: this.data.order.orderNo,
      success: () => {
        wx.showToast({
          title: '已复制',
          icon: 'success'
        })
      }
    })
  },

  // 查看商品
  onProductTap(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/product/product?id=${id}`
    })
  }
})