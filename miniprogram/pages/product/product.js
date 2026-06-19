// pages/product/product.js
const { getProductDetail, getProductReviews } = require('../../api/product')
const { addToCart } = require('../../api/cart')
const { formatPrice, requireLogin, showToast } = require('../../utils/util')

Page({
  data: {
    product: null,
    specs: [],
    specGroups: [],        // 按 specName 分组后的规格 [{groupName: "颜色", options: [{id, specValue, selected}]}]
    reviews: [],
    currentSpec: {},       // 改为对象: { "颜色": {id, specValue}, "内存": {id, specValue} }
    quantity: 1,
    loading: true,
    showSpecPopup: false,
    buyType: 'cart' // cart or buy
  },

  onLoad(options) {
    const productId = options.id
    if (productId) {
      this.loadProductDetail(productId)
    }
  },

  // 加载商品详情
  async loadProductDetail(productId) {
    try {
      this.setData({ loading: true })
      
      const product = await getProductDetail(productId)
      
      // 处理图片
      if (product.images) {
        product.imageList = product.images.split(',').map(img => img.trim())
      } else {
        product.imageList = ['https://neeko-copilot.bytedance.net/api/text_to_image?prompt=product%20placeholder%20image%20gray%20background&image_size=square']
      }
      
      product.priceText = formatPrice(product.price)
      product.originalPriceText = formatPrice(product.originalPrice || product.price * 1.2)
      
      // 处理规格：按 specName 分组 (颜色/内存 等)
      const specs = product.specs || []
      const specGroups = []
      if (specs.length > 0) {
        // 按 specName 分组
        const groupMap = {}
        specs.forEach(spec => {
          if (!groupMap[spec.specName]) {
            groupMap[spec.specName] = { groupName: spec.specName, options: [] }
          }
          groupMap[spec.specName].options.push({
            ...spec,
            selected: false
          })
        })
        // 转为数组
        for (const key in groupMap) {
          specGroups.push(groupMap[key])
        }
      }

      this.setData({
        product,
        specs,
        specGroups,
        loading: false
      })
      
      // 加载评价
      this.loadReviews(productId)
    } catch (error) {
      console.error('加载商品详情失败:', error)
      this.setData({ loading: false })
      wx.showToast({
        title: '加载失败',
        icon: 'none'
      })
    }
  },

  // 加载评价
  async loadReviews(productId) {
    try {
      const reviews = await getProductReviews(productId, { page: 1, size: 5 })
      const records = (reviews.records || []).map(review => {
        // 处理评价图片
        if (review.images) {
          review.imageList = review.images.split(',').map(img => img.trim()).filter(img => img)
        } else {
          review.imageList = []
        }
        return review
      })
      this.setData({
        reviews: records
      })
    } catch (error) {
      console.error('加载评价失败:', error)
    }
  },

  // 预览图片
  onPreviewImage(e) {
    const { src } = e.currentTarget.dataset
    const urls = this.data.product.imageList
    
    wx.previewImage({
      current: src,
      urls
    })
  },

  // 预览评价图片
  onPreviewReviewImage(e) {
    const { src, urls } = e.currentTarget.dataset
    wx.previewImage({
      current: src,
      urls
    })
  },

  // 选择规格（支持多组：颜色 + 内存 各自独立选择）
  onSelectSpec(e) {
    const { groupIndex, optionIndex } = e.currentTarget.dataset
    const { specGroups, currentSpec } = this.data

    const group = specGroups[groupIndex]
    const selectedOption = group.options[optionIndex]

    // 同一组内单选：取消该组其他选项
    group.options.forEach((opt, i) => {
      opt.selected = i === optionIndex
    })

    // 更新 currentSpec 中该组的选中值
    currentSpec[group.groupName] = {
      id: selectedOption.id,
      specName: selectedOption.specName,
      specValue: selectedOption.specValue
    }

    this.setData({
      specGroups,
      currentSpec
    })
  },

  // 增加数量
  onIncrease() {
    const { product, quantity } = this.data
    if (quantity < product.stock) {
      this.setData({ quantity: quantity + 1 })
    } else {
      showToast('库存不足')
    }
  },

  // 减少数量
  onDecrease() {
    if (this.data.quantity > 1) {
      this.setData({ quantity: this.data.quantity - 1 })
    }
  },

  // 打开规格弹窗
  openSpecPopup(e) {
    const { type } = e.currentTarget.dataset
    this.setData({
      showSpecPopup: true,
      buyType: type || 'cart'
    })
  },

  // 关闭规格弹窗
  closeSpecPopup() {
    this.setData({ showSpecPopup: false })
  },

  // 加入购物车
  async onAddToCart() {
    requireLogin(async () => {
      const { product, currentSpec, quantity, specGroups } = this.data

      // 如果有规格组，检查每组是否都已选择
      if (specGroups.length > 0) {
        const unselected = specGroups.find(g => !currentSpec[g.groupName])
        if (unselected) {
          showToast('请选择' + unselected.groupName)
          return
        }
      }

      try {
        wx.showLoading({ title: '添加中...' })

        const cartData = {
          productId: product.id,
          quantity
        }
        // 传递多规格信息
        if (specGroups.length > 0) {
          cartData.specIds = Object.values(currentSpec).map(s => s.id).join(',')
          cartData.specName = Object.values(currentSpec).map(s => s.specName).join(';')
          cartData.specValue = Object.values(currentSpec).map(s => s.specValue).join(';')
        }

        await addToCart(cartData)

        wx.hideLoading()
        showToast('已加入购物车')
        this.closeSpecPopup()

        // 更新购物车图标数量
        this.updateCartBadge()
      } catch (error) {
        wx.hideLoading()
        console.error('添加购物车失败:', error)
      }
    })
  },

  // 立即购买
  async onBuyNow() {
    requireLogin(async () => {
      const { product, currentSpec, quantity, specGroups } = this.data

      // 如果有规格组，检查每组是否都已选择
      if (specGroups.length > 0) {
        const unselected = specGroups.find(g => !currentSpec[g.groupName])
        if (unselected) {
          showToast('请选择' + unselected.groupName)
          return
        }
      }

      // 跳转到创建订单页
      const itemData = {
        productId: product.id,
        productName: product.name,
        price: product.price,
        quantity,
        image: product.imageList[0]
      }
      if (specGroups.length > 0) {
        const selectedSpecs = Object.values(currentSpec)
        itemData.specIds = selectedSpecs.map(s => s.id).join(',')
        itemData.specName = selectedSpecs.map(s => s.specName).join(';')
        itemData.specValue = selectedSpecs.map(s => s.specValue).join(';')
      }

      wx.navigateTo({
        url: `/pages/create-order/create-order?items=${JSON.stringify([itemData])}`
      })

      this.closeSpecPopup()
    })
  },

  // 确认操作
  onConfirm() {
    if (this.data.buyType === 'cart') {
      this.onAddToCart()
    } else {
      this.onBuyNow()
    }
  },

  // 更新购物车角标
  updateCartBadge() {
    // 可以调用API获取购物车数量
    // wx.setTabBarBadge({ index: 2, text: '1' })
  },

  // 分享
  onShareAppMessage() {
    const { product } = this.data
    return {
      title: product.name,
      path: `/pages/product/product?id=${product.id}`,
      imageUrl: product.imageList[0]
    }
  },

  // 跳转首页
  onGoHome() {
    wx.switchTab({
      url: '/pages/index/index'
    })
  },

  // 跳转购物车
  onGoCart() {
    wx.switchTab({
      url: '/pages/cart/cart'
    })
  }
})