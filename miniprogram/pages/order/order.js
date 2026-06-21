// pages/order/order.js
const { getOrderList, cancelOrder, payOrder, confirmOrder, deleteOrder, applyRefund } = require('../../api/order')
const { formatPrice, formatTime, getOrderStatusText, getOrderStatusClass, requireLogin } = require('../../utils/util')

Page({
  data: {
    tabs: [
      { key: '', name: '全部' },
      { key: '0', name: '待付款' },
      { key: '1', name: '待发货' },
      { key: '2', name: '待收货' },
      { key: '3', name: '已完成' }
    ],
    currentTab: '',
    orders: [],
    loading: true,
    page: 1,
    size: 10,
    hasMore: true
  },

  onLoad(options) {
    const status = options.status || ''
    const tabIndex = this.data.tabs.findIndex(tab => tab.key === status)
    
    this.setData({
      currentTab: status,
      currentTabIndex: tabIndex >= 0 ? tabIndex : 0
    })
  },

  onShow() {
    this.setData({ page: 1, hasMore: true })
    this.loadOrders()
  },

  onPullDownRefresh() {
    this.setData({ page: 1, hasMore: true })
    this.loadOrders().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  // scroll-view 滚动到底部触发加载更多
  onScrollToLower() {
    if (this.data.hasMore && !this.data.loading) {
      this.loadMore()
    }
  },

  // 加载订单
  async loadOrders() {
    try {
      this.setData({ loading: true })
      
      const params = {
        page: this.data.page,
        size: this.data.size
      }
      if (this.data.currentTab !== '') {
        params.status = this.data.currentTab
      }
      const res = await getOrderList(params)
      
      const orders = (res.records || []).map(order => ({
        ...order,
        statusText: getOrderStatusText(order.status),
        statusClass: getOrderStatusClass(order.status),
        totalAmountText: formatPrice(order.totalAmount),
        createdAtText: formatTime(order.createdAt, 'YYYY-MM-DD HH:mm'),
        items: order.items || []
      }))
      
      this.setData({
        orders,
        hasMore: res.records && res.records.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('加载订单失败:', error)
      this.setData({ loading: false })
    }
  },

  // 加载更多
  async loadMore() {
    if (!this.data.hasMore) return
    
    try {
      this.setData({ loading: true })
      
      const params = {
        page: this.data.page + 1,
        size: this.data.size
      }
      if (this.data.currentTab !== '') {
        params.status = this.data.currentTab
      }
      const res = await getOrderList(params)
      
      const newOrders = (res.records || []).map(order => ({
        ...order,
        statusText: getOrderStatusText(order.status),
        statusClass: getOrderStatusClass(order.status),
        totalAmountText: formatPrice(order.totalAmount),
        createdAtText: formatTime(order.createdAt, 'YYYY-MM-DD HH:mm'),
        items: order.items || []
      }))
      
      this.setData({
        orders: [...this.data.orders, ...newOrders],
        page: this.data.page + 1,
        hasMore: res.records && res.records.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('加载更多失败:', error)
      this.setData({ loading: false })
    }
  },

  // 切换标签
  onTabChange(e) {
    const { key } = e.currentTarget.dataset
    this.setData({
      currentTab: key,
      page: 1,
      hasMore: true,
      orders: []
    })
    this.loadOrders()
  },

  // 查看订单详情
  onOrderTap(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/order-detail/order-detail?id=${id}`
    })
  },

  // 取消订单
  async onCancelOrder(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      
      wx.showModal({
        title: '提示',
        content: '确定要取消该订单吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await cancelOrder(id)
              wx.showToast({
                title: '订单已取消',
                icon: 'success'
              })
              this.loadOrders()
            } catch (error) {
              console.error('取消订单失败:', error)
            }
          }
        }
      })
    })
  },

  // 确认收货
  async onConfirmOrder(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      
      wx.showModal({
        title: '提示',
        content: '确定已收到货物吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await confirmOrder(id)
              wx.showToast({
                title: '已确认收货',
                icon: 'success'
              })
              this.loadOrders()
            } catch (error) {
              console.error('确认收货失败:', error)
            }
          }
        }
      })
    })
  },

  // 去支付（模拟）
  onPayOrder(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      wx.showModal({
        title: '模拟支付',
        content: '确认支付该订单？',
        success: async (res) => {
          if (res.confirm) {
            try {
              wx.showLoading({ title: '支付中...' })
              await payOrder(id)
              wx.hideLoading()
              wx.showToast({
                title: '支付成功',
                icon: 'success'
              })
              this.loadOrders()
            } catch (error) {
              wx.hideLoading()
              console.error('支付失败:', error)
            }
          }
        }
      })
    })
  },

  // 删除订单
  onDeleteOrder(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      wx.showModal({
        title: '提示',
        content: '确定要删除该订单吗？删除后不可恢复',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteOrder(id)
              wx.showToast({
                title: '订单已删除',
                icon: 'success'
              })
              this.loadOrders()
            } catch (error) {
              console.error('删除订单失败:', error)
            }
          }
        }
      })
    })
  },

  // 评价订单
  onReviewOrder(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/review/review?orderId=${id}`
    })
  },

  // 申请退款
  onApplyRefund(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/refund/refund?orderId=${id}`
    })
  }
})