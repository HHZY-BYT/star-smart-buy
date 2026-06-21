// pages/index/index.js
const { getProductList } = require('../../api/product')
const { getHomeData } = require('../../api/home')
const { formatPrice } = require('../../utils/util')

Page({
  data: {
    banners: [],
    notices: [],
    categories: [
      { id: 1, name: '手机', icon: '📱' },
      { id: 2, name: '笔记本', icon: '💻' },
      { id: 3, name: '台式机', icon: '🖥️' },
      { id: 4, name: '平板', icon: '📲' },
      { id: 5, name: '配件', icon: '🎧' }
    ],
    hotProducts: [],
    recommendProducts: [],
    loading: true,
    page: 1,
    size: 4,
    hasMore: true
  },

  onLoad() {
    this.loadHomeData()
    this.loadProducts()
  },

  onShow() {
    if (typeof this.getTabBar === 'function' && this.getTabBar()) {
      this.getTabBar().setData({ selected: 0 })
    }
  },

  onPullDownRefresh() {
    this.setData({ page: 1, hasMore: true })
    Promise.all([this.loadHomeData(), this.loadProducts()]).then(() => {
      wx.stopPullDownRefresh()
    })
  },

  onReachBottom() {
    if (this.data.hasMore && !this.data.loading) {
      this.loadMore()
    }
  },

  // 加载首页数据（轮播图 + 公告）
  async loadHomeData() {
    try {
      const res = await getHomeData()
      console.log('首页数据返回:', JSON.stringify(res))
      this.setData({
        banners: res.banners || [],
        notices: res.notices || []
      })
    } catch (error) {
      console.error('加载首页数据失败:', error)
      wx.showToast({ title: '首页数据加载失败', icon: 'none' })
    }
  },

  // 加载商品
  async loadProducts() {
    try {
      this.setData({ loading: true })
      
      // 首次加载：请求足够多的商品用于热门推荐 + 为你推荐首屏
      const res = await getProductList({
        page: 1,
        size: 20
      })
      
      const products = (res.records || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))
      
      // 热门推荐取前4个，为你推荐取剩下的
      this.setData({
        hotProducts: products.slice(0, 4),
        recommendProducts: products.slice(4),
        page: 1,
        hasMore: res.total > 20,
        loading: false
      })
    } catch (error) {
      console.error('加载商品失败:', error)
      this.setData({ loading: false })
    }
  },

  // 加载更多
  async loadMore() {
    if (!this.data.hasMore) return
    
    try {
      this.setData({ loading: true })
      
      const nextPage = this.data.page + 1
      const res = await getProductList({
        page: nextPage,
        size: this.data.size
      })
      
      const newProducts = (res.records || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))
      
      this.setData({
        recommendProducts: [...this.data.recommendProducts, ...newProducts],
        page: nextPage,
        hasMore: newProducts.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('加载更多失败:', error)
      this.setData({ loading: false })
    }
  },

  // 搜索
  onSearch() {
    wx.navigateTo({
      url: '/pages/search/search'
    })
  },

  // 点击分类
  onCategoryTap(e) {
    const { id } = e.currentTarget.dataset
    const app = getApp()
    app.globalData.selectCategoryId = id
    wx.switchTab({
      url: '/pages/category/category'
    })
  },

  // 点击商品
  onProductTap(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/product/product?id=${id}`
    })
  },

  // AI助手
  onAiChat() {
    wx.navigateTo({
      url: '/pages/ai-chat/ai-chat'
    })
  },

  // 轮播图点击
  onBannerTap(e) {
    const { link } = e.currentTarget.dataset
    if (link) {
      wx.navigateTo({ url: link })
    }
  },

  // 查看公告详情
  onNoticeTap(e) {
    const { index } = e.currentTarget.dataset
    const notice = this.data.notices[index]
    if (notice) {
      wx.showModal({
        title: notice.title,
        content: notice.content,
        showCancel: false,
        confirmText: '知道了'
      })
    }
  }
})