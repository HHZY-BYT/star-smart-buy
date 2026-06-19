// pages/my-reviews/my-reviews.js
const { getMyReviews } = require('../../api/product')
const { formatTime, requireLogin } = require('../../utils/util')

Page({
  data: {
    reviews: [],
    loading: true,
    page: 1,
    size: 10,
    hasMore: true
  },

  onLoad() {
    this.loadReviews()
  },

  onShow() {
    if (this.data.reviews.length > 0) {
      this.setData({ page: 1, hasMore: true })
      this.loadReviews()
    }
  },

  onPullDownRefresh() {
    this.setData({ page: 1, hasMore: true })
    this.loadReviews().then(() => {
      wx.stopPullDownRefresh()
    })
  },

  onReachBottom() {
    if (this.data.hasMore && !this.data.loading) {
      this.loadMore()
    }
  },

  async loadReviews() {
    try {
      this.setData({ loading: true })
      const res = await getMyReviews({ page: this.data.page, size: this.data.size })
      const reviews = (res.records || []).map(review => ({
        ...review,
        createdAtText: formatTime(review.createdAt, 'YYYY-MM-DD HH:mm'),
        imageList: review.images ? review.images.split(',').filter(Boolean) : [],
        stars: this.getStars(review.rating)
      }))
      this.setData({
        reviews,
        hasMore: res.records && res.records.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('加载评价失败:', error)
      this.setData({ loading: false })
    }
  },

  async loadMore() {
    if (!this.data.hasMore) return
    try {
      this.setData({ loading: true })
      const res = await getMyReviews({ page: this.data.page + 1, size: this.data.size })
      const newReviews = (res.records || []).map(review => ({
        ...review,
        createdAtText: formatTime(review.createdAt, 'YYYY-MM-DD HH:mm'),
        imageList: review.images ? review.images.split(',').filter(Boolean) : [],
        stars: this.getStars(review.rating)
      }))
      this.setData({
        reviews: [...this.data.reviews, ...newReviews],
        page: this.data.page + 1,
        hasMore: res.records && res.records.length >= this.data.size,
        loading: false
      })
    } catch (error) {
      console.error('加载更多失败:', error)
      this.setData({ loading: false })
    }
  },

  getStars(rating) {
    const stars = []
    for (let i = 1; i <= 5; i++) {
      stars.push(i <= rating)
    }
    return stars
  },

  onPreviewImage(e) {
    const { url, index } = e.currentTarget.dataset
    const review = this.data.reviews[index]
    wx.previewImage({
      current: url,
      urls: review.imageList
    })
  },

  onProductTap(e) {
    const { id } = e.currentTarget.dataset
    if (id) {
      wx.navigateTo({
        url: `/pages/product/product?id=${id}`
      })
    }
  }
})
