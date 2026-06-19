// pages/review/review.js
const { getOrderDetail } = require('../../api/order')
const { postReview } = require('../../api/product')
const { formatPrice, requireLogin } = require('../../utils/util')

const app = getApp()

Page({
  data: {
    orderId: null,
    order: null,
    items: [],
    rating: 5,
    content: '',
    images: [],
    maxImages: 6,
    submitting: false
  },

  onLoad(options) {
    if (options.orderId) {
      this.setData({ orderId: options.orderId })
      this.loadOrder(options.orderId)
    }
  },

  async loadOrder(orderId) {
    try {
      const order = await getOrderDetail(orderId)
      const items = (order.items || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price)
      }))
      this.setData({ order, items })
    } catch (error) {
      console.error('加载订单失败:', error)
    }
  },

  onRatingChange(e) {
    this.setData({ rating: e.currentTarget.dataset.rating })
  },

  onContentInput(e) {
    this.setData({ content: e.detail.value })
  },

  // 选择图片
  onChooseImage() {
    const remaining = this.data.maxImages - this.data.images.length
    if (remaining <= 0) {
      wx.showToast({ title: `最多上传${this.data.maxImages}张图片`, icon: 'none' })
      return
    }
    wx.chooseMedia({
      count: remaining,
      mediaType: ['image'],
      sourceType: ['album', 'camera'],
      success: (res) => {
        const newImages = res.tempFiles.map(file => file.tempFilePath)
        this.setData({
          images: [...this.data.images, ...newImages]
        })
      }
    })
  },

  // 预览图片
  onPreviewImage(e) {
    const { url } = e.currentTarget.dataset
    wx.previewImage({
      current: url,
      urls: this.data.images
    })
  },

  // 删除图片
  onDeleteImage(e) {
    const { index } = e.currentTarget.dataset
    const images = [...this.data.images]
    images.splice(index, 1)
    this.setData({ images })
  },

  // 上传单张图片
  uploadImage(filePath) {
    const token = app.globalData.token || wx.getStorageSync('token')
    return new Promise((resolve, reject) => {
      wx.uploadFile({
        url: `${app.globalData.baseUrl}/upload/image`,
        filePath,
        name: 'file',
        header: token ? { 'Authorization': 'Bearer ' + token } : {},
        success: (res) => {
          if (res.statusCode === 200) {
            try {
              const data = JSON.parse(res.data)
              if (data.code === 200 && data.data) {
                resolve(data.data)
              } else {
                reject(new Error(data.message || '上传失败'))
              }
            } catch (e) {
              reject(new Error('解析响应失败'))
            }
          } else {
            reject(new Error('上传失败'))
          }
        },
        fail: reject
      })
    })
  },

  async onSubmit() {
    if (this.data.submitting) return

    const { content, rating, items, orderId, images } = this.data

    if (!content.trim()) {
      wx.showToast({ title: '请输入评价内容', icon: 'none' })
      return
    }

    this.setData({ submitting: true })
    wx.showLoading({ title: '提交中...' })

    try {
      // 上传图片
      let imageUrls = []
      if (images.length > 0) {
        wx.showLoading({ title: '上传图片中...' })
        const uploadResults = await Promise.all(images.map(img => this.uploadImage(img)))
        imageUrls = uploadResults
      }

      // 为每个商品提交评价
      for (const item of items) {
        await postReview({
          productId: item.productId,
          rating: rating,
          content: content.trim(),
          images: imageUrls.join(',')
        })
      }

      wx.hideLoading()
      wx.showToast({ title: '评价成功', icon: 'success' })

      setTimeout(() => {
        wx.navigateBack()
      }, 1500)
    } catch (error) {
      wx.hideLoading()
      this.setData({ submitting: false })
      console.error('评价失败:', error)
    }
  }
})
