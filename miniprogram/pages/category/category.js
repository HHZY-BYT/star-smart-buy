// pages/category/category.js
const { getCategoryList, getProductList } = require('../../api/product')
const { formatPrice } = require('../../utils/util')

Page({
  data: {
    categories: [],
    currentCategory: null,
    subCategories: [],
    currentSubCategory: null,
    products: [],
    loading: true,
    page: 1,
    size: 10,
    hasMore: true
  },

  onLoad(options) {
    const app = getApp()
    const categoryId = (options.categoryId ? parseInt(options.categoryId) : null) || app.globalData.selectCategoryId || null
    app.globalData.selectCategoryId = null
    this.loadCategories(categoryId)
  },

  onShow() {
    if (typeof this.getTabBar === 'function' && this.getTabBar()) {
      this.getTabBar().setData({ selected: 1 })
    }
    // 处理从首页点击分类跳转过来的情况
    const app = getApp()
    const categoryId = app.globalData.selectCategoryId
    if (categoryId) {
      app.globalData.selectCategoryId = null
      this.loadCategories(parseInt(categoryId))
    }
  },

  onPullDownRefresh() {
    this.setData({ page: 1, hasMore: true })
    this.loadProducts().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  onReachBottom() {
    if (this.data.hasMore && !this.data.loading) {
      this.loadMore()
    }
  },

  // 加载分类
  async loadCategories(defaultCategoryId) {
    try {
      const categories = await getCategoryList()
      
      let currentCategory = null
      if (defaultCategoryId) {
        currentCategory = categories.find(c => c.id === defaultCategoryId)
        if (!currentCategory) {
          for (const cat of categories) {
            if (cat.children) {
              const found = cat.children.find(c => c.id === defaultCategoryId)
              if (found) {
                currentCategory = cat
                break
              }
            }
          }
        }
      }
      if (!currentCategory) currentCategory = categories[0]
      
      const subCategories = currentCategory && currentCategory.children 
        ? currentCategory.children : []
      
      this.setData({ 
        categories: categories || [],
        currentCategory,
        subCategories,
        currentSubCategory: null
      })
      
      this.loadProducts()
    } catch (error) {
      console.error('加载分类失败:', error)
      this.setData({ loading: false })
    }
  },

  // 加载商品
  async loadProducts() {
    try {
      this.setData({ loading: true })
      
      const params = {
        page: this.data.page,
        size: this.data.size
      }
      if (this.data.currentSubCategory) {
        params.categoryId = this.data.currentSubCategory.id
      } else if (this.data.currentCategory) {
        params.categoryId = this.data.currentCategory.id
      }
      
      const res = await getProductList(params)
      
      const products = (res.records || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))
      
      this.setData({
        products,
        hasMore: res.records && res.records.length >= this.data.size,
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
      
      const params = {
        page: this.data.page + 1,
        size: this.data.size
      }
      if (this.data.currentSubCategory) {
        params.categoryId = this.data.currentSubCategory.id
      } else if (this.data.currentCategory) {
        params.categoryId = this.data.currentCategory.id
      }
      
      const res = await getProductList(params)
      
      const newProducts = (res.records || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))
      
      this.setData({
        products: [...this.data.products, ...newProducts],
        page: this.data.page + 1,
        hasMore: res.records && res.records.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('加载更多失败:', error)
      this.setData({ loading: false })
    }
  },

  // 选择一级分类
  onCategorySelect(e) {
    const { category } = e.currentTarget.dataset
    const subCategories = category.children || []
    this.setData({
      currentCategory: category,
      subCategories,
      currentSubCategory: null,
      page: 1,
      hasMore: true,
      products: []
    })
    this.loadProducts()
  },

  // 选择子分类
  onSubCategorySelect(e) {
    const { category } = e.currentTarget.dataset
    this.setData({
      currentSubCategory: category,
      page: 1,
      hasMore: true,
      products: []
    })
    this.loadProducts()
  },

  // 查看全部（取消子分类筛选）
  onSubCategoryAll() {
    this.setData({
      currentSubCategory: null,
      page: 1,
      hasMore: true,
      products: []
    })
    this.loadProducts()
  },

  // 点击商品
  onProductTap(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/product/product?id=${id}`
    })
  }
})
