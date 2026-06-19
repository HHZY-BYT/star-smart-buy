// api/address.js - 地址相关API
const { get, post, put, del } = require('../utils/request')

/**
 * 获取地址列表
 * @returns {Promise}
 */
const getAddressList = () => {
  return get('/address')
}

/**
 * 获取地址详情
 * @param {number} id 地址ID
 * @returns {Promise}
 */
const getAddressDetail = (id) => {
  return get(`/address/${id}`)
}

/**
 * 添加地址
 * @param {Object} data 地址数据
 * @returns {Promise}
 */
const addAddress = (data) => {
  return post('/address', data)
}

/**
 * 更新地址
 * @param {Object} data 地址数据
 * @returns {Promise}
 */
const updateAddress = (data) => {
  return put('/address', data)
}

/**
 * 删除地址
 * @param {number} id 地址ID
 * @returns {Promise}
 */
const deleteAddress = (id) => {
  return del(`/address/${id}`)
}

/**
 * 设置默认地址
 * @param {number} id 地址ID
 * @returns {Promise}
 */
const setDefaultAddress = (id) => {
  return put(`/address/${id}/default`)
}

/**
 * 获取默认地址
 * @returns {Promise}
 */
const getDefaultAddress = () => {
  return get('/address/default')
}

module.exports = {
  getAddressList,
  getAddressDetail,
  addAddress,
  updateAddress,
  deleteAddress,
  setDefaultAddress,
  getDefaultAddress
}