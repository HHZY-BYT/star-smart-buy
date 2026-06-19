// api/product.js - 商品相关API
const { get } = require('../utils/request')

/**
 * 获取商品列表
 * @param {Object} params 查询参数
 * @returns {Promise}
 */
const getProductList = (params = {}) => {
  return get('/products', params)
}

/**
 * 获取商品详情
 * @param {number} id 商品ID
 * @returns {Promise}
 */
const getProductDetail = (id) => {
  return get(`/products/${id}`)
}

/**
 * 搜索商品
 * @param {Object} params 搜索参数
 * @returns {Promise}
 */
const searchProducts = (params = {}) => {
  return get('/products/search', params)
}

/**
 * 获取商品分类列表
 * @returns {Promise}
 */
const getCategoryList = () => {
  return get('/categories')
}

/**
 * 获取商品评价列表
 * @param {number} productId 商品ID
 * @param {Object} params 分页参数
 * @returns {Promise}
 */
const getProductReviews = (productId, params = {}) => {
  return get(`/review/${productId}`, params)
}

/**
 * 发布商品评价
 * @param {Object} data 评价数据
 * @returns {Promise}
 */
const postReview = (data) => {
  const { post } = require('../utils/request')
  return post('/review', data)
}

/**
 * 获取我的评价列表
 * @param {Object} params 分页参数
 * @returns {Promise}
 */
const getMyReviews = (params = {}) => {
  return get('/review/my', params)
}

module.exports = {
  getProductList,
  getProductDetail,
  searchProducts,
  getCategoryList,
  getProductReviews,
  postReview,
  getMyReviews
}