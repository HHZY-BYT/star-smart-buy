// pages/refund/refund.js
const { getOrderDetail, applyRefund } = require('../../api/order')
const { formatPrice, formatTime, requireLogin } = require('../../utils/util')

Page({
  data: {
    orderId: null,
    order: null,
    items: [],
    refundType: '', // 'quick' 或 'apply'
    refundTypeText: '',
    refundTypeDesc: '',
    reasonOptions: ['不想要了', '商品与描述不符', '商品质量问题', '收到商品损坏', '其他原因'],
    selectedReason: '',
    customReason: '',
    description: '',
    submitting: false,
    canQuickRefund: false,
    remainingHours: 0
  },

  onLoad(options) {
    if (options.orderId) {
      this.setData({ orderId: options.orderId })
      this.loadOrder(options.orderId)
    }
  },

  async loadOrder(orderId) {
    try {
      wx.showLoading({ title: '加载中...' })
      const order = await getOrderDetail(orderId)
      wx.hideLoading()

      const items = (order.items || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))

      // 判断退款类型
      let refundType = 'apply'
      let refundTypeText = '申请退款'
      let refundTypeDesc = '您的退款申请将提交给管理员审核'
      let canQuickRefund = false
      let remainingHours = 0

      if (order.status === 1 && order.payTime) {
        const payTime = new Date(order.payTime)
        const now = new Date()
        const diffMs = now - payTime
        const diffHours = diffMs / (1000 * 60 * 60)
        remainingHours = Math.max(0, Math.floor(24 - diffHours))

        if (diffHours < 24) {
          refundType = 'quick'
          refundTypeText = '快速退款'
          refundTypeDesc = '付款24小时内，系统将自动审核通过退款'
          canQuickRefund = true
        } else {
          refundTypeDesc = '付款已超过24小时，需管理员审核退款申请'
        }
      } else if (order.status === 2) {
        refundTypeDesc = '订单已发货，退款申请需管理员审核'
      }

      this.setData({
        order,
        items,
        refundType,
        refundTypeText,
        refundTypeDesc,
        canQuickRefund,
        remainingHours
      })
    } catch (error) {
      wx.hideLoading()
      console.error('加载订单失败:', error)
      wx.showToast({ title: '加载失败', icon: 'none' })
    }
  },

  onReasonSelect(e) {
    const reason = e.currentTarget.dataset.reason
    this.setData({ selectedReason: reason, customReason: '' })
  },

  onCustomReasonInput(e) {
    this.setData({ customReason: e.detail.value, selectedReason: '' })
  },

  onDescriptionInput(e) {
    this.setData({ description: e.detail.value })
  },

  async onSubmit() {
    if (this.data.submitting) return

    const { orderId, selectedReason, customReason, description, refundType } = this.data
    const reason = customReason || selectedReason

    if (!reason) {
      wx.showToast({ title: '请选择退款原因', icon: 'none' })
      return
    }

    this.setData({ submitting: true })
    wx.showLoading({ title: '提交中...' })

    try {
      const res = await applyRefund(orderId, { reason, description })
      wx.hideLoading()

      if (res.type === 'quick') {
        wx.showModal({
          title: '退款成功',
          content: '您的退款已自动审核通过，款项将在1-3个工作日内退回',
          showCancel: false,
          success: () => {
            wx.navigateBack()
          }
        })
      } else {
        wx.showModal({
          title: '申请已提交',
          content: '您的退款申请已提交，请等待管理员审核',
          showCancel: false,
          success: () => {
            wx.navigateBack()
          }
        })
      }
    } catch (error) {
      wx.hideLoading()
      this.setData({ submitting: false })
      wx.showToast({
        title: error.message || '提交失败',
        icon: 'none'
      })
    }
  }
})
