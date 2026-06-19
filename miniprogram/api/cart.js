// api/cart.js - 购物车相关API
const { get, post, put, del } = require('../utils/request')

/**
 * 获取购物车列表
 * @returns {Promise}
 */
const getCartList = () => {
  return get('/cart')
}

/**
 * 添加商品到购物车
 * @param {Object} data 商品数据 { productId, quantity }
 * @returns {Promise}
 */
const addToCart = (data) => {
  return post('/cart/add', data)
}

/**
 * 更新购物车商品数量
 * @param {Object} data 更新数据 { id, quantity }
 * @returns {Promise}
 */
const updateCartQuantity = (data) => {
  return put('/cart/update', data)
}

/**
 * 删除购物车商品
 * @param {number} id 购物车项ID
 * @returns {Promise}
 */
const removeFromCart = (id) => {
  return del(`/cart/${id}`)
}

/**
 * 清空购物车
 * @returns {Promise}
 */
const clearCart = () => {
  return del('/cart/clear')
}

/**
 * 获取购物车商品数量
 * @returns {Promise}
 */
const getCartCount = () => {
  return get('/cart/count')
}

module.exports = {
  getCartList,
  addToCart,
  updateCartQuantity,
  removeFromCart,
  clearCart,
  getCartCount
}