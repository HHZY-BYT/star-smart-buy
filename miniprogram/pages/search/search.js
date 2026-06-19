// pages/search/search.js
const { searchProducts } = require('../../api/product')
const { formatPrice, debounce } = require('../../utils/util')

Page({
  data: {
    keyword: '',
    products: [],
    historyKeywords: [],
    hotKeywords: ['手机', '笔记本', '游戏本', '平板', '耳机', '键盘'],
    loading: false,
    page: 1,
    size: 10,
    hasMore: true,
    searched: false
  },

  onLoad() {
    this.loadHistory()
  },

  // 加载搜索历史
  loadHistory() {
    const history = wx.getStorageSync('searchHistory') || []
    this.setData({ historyKeywords: history })
  },

  // 保存搜索历史
  saveHistory(keyword) {
    let history = wx.getStorageSync('searchHistory') || []
    history = history.filter(item => item !== keyword)
    history.unshift(keyword)
    if (history.length > 10) {
      history = history.slice(0, 10)
    }
    wx.setStorageSync('searchHistory', history)
    this.setData({ historyKeywords: history })
  },

  // 清空历史
  onClearHistory() {
    wx.removeStorageSync('searchHistory')
    this.setData({ historyKeywords: [] })
  },

  // 输入关键词
  onInput: debounce(function(e) {
    const keyword = e.detail.value.trim()
    this.setData({ keyword })
  }, 300),

  // 搜索
  async onSearch() {
    const { keyword } = this.data
    if (!keyword) {
      wx.showToast({
        title: '请输入搜索关键词',
        icon: 'none'
      })
      return
    }
    
    this.saveHistory(keyword)
    this.setData({
      searched: true,
      page: 1,
      hasMore: true,
      products: []
    })
    this.searchProducts()
  },

  // 搜索商品
  async searchProducts() {
    try {
      this.setData({ loading: true })
      
      const res = await searchProducts({
        keyword: this.data.keyword,
        page: this.data.page,
        size: this.data.size
      })
      
      const products = (res.records || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))
      
      this.setData({
        products: this.data.page === 1 ? products : [...this.data.products, ...products],
        hasMore: res.records && res.records.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('搜索失败:', error)
      this.setData({ loading: false })
    }
  },

  // 加载更多
  onReachBottom() {
    if (this.data.hasMore && !this.data.loading) {
      this.setData({ page: this.data.page + 1 })
      this.searchProducts()
    }
  },

  // 点击历史关键词
  onHistoryTap(e) {
    const { keyword } = e.currentTarget.dataset
    this.setData({ keyword })
    this.onSearch()
  },

  // 点击热门关键词
  onHotTap(e) {
    const { keyword } = e.currentTarget.dataset
    this.setData({ keyword })
    this.onSearch()
  },

  // 点击商品
  onProductTap(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/product/product?id=${id}`
    })
  },

  // 清空输入
  onClearInput() {
    this.setData({
      keyword: '',
      searched: false,
      products: []
    })
  }
})