// api/order.js - 订单相关API
const { get, post, put, del } = require('../utils/request')

/**
 * 创建订单
 * @param {Object} data 订单数据
 * @returns {Promise}
 */
const createOrder = (data) => {
  return post('/orders', data)
}

/**
 * 获取订单列表
 * @param {Object} params 查询参数
 * @returns {Promise}
 */
const getOrderList = (params = {}) => {
  return get('/orders', params)
}

/**
 * 获取订单详情
 * @param {number} id 订单ID
 * @returns {Promise}
 */
const getOrderDetail = (id) => {
  return get(`/orders/${id}`)
}

/**
 * 取消订单
 * @param {number} id 订单ID
 * @returns {Promise}
 */
const cancelOrder = (id) => {
  return put(`/orders/${id}/cancel`)
}

/**
 * 支付订单（模拟）
 * @param {number} id 订单ID
 * @returns {Promise}
 */
const payOrder = (id) => {
  return put(`/orders/${id}/pay`)
}

/**
 * 确认收货
 * @param {number} id 订单ID
 * @returns {Promise}
 */
const confirmOrder = (id) => {
  return put(`/orders/${id}/confirm`)
}

/**
 * 删除订单（已取消/已完成的订单可删除）
 * @param {number} id 订单ID
 * @returns {Promise}
 */
const deleteOrder = (id) => {
  return del(`/orders/${id}`)
}

/**
 * 获取各状态订单数量
 * @returns {Promise}
 */
const getOrderCounts = () => {
  return get('/orders/counts')
}

/**
 * 申请退款
 * @param {number} id 订单ID
 * @param {Object} data 退款数据 {reason, description}
 * @returns {Promise}
 */
const applyRefund = (id, data) => {
  return post(`/orders/${id}/refund`, data)
}

module.exports = {
  createOrder,
  getOrderList,
  getOrderDetail,
  cancelOrder,
  payOrder,
  confirmOrder,
  deleteOrder,
  getOrderCounts,
  applyRefund
}