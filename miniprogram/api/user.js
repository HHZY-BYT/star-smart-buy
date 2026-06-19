// api/user.js - 用户相关API
const { get, post, del } = require('../utils/request')

/**
 * 微信登录
 * @param {Object} data 登录数据
 * @returns {Promise}
 */
const login = (data) => {
  return post('/user/login', data)
}

/**
 * 发送验证码
 * @param {Object} data 手机号数据
 * @returns {Promise}
 */
const sendVerifyCode = (data) => {
  return post('/user/send-verify-code', data)
}

/**
 * 手机号登录
 * @param {Object} data 登录数据（手机号+验证码）
 * @returns {Promise}
 */
const loginByPhone = (data) => {
  return post('/user/login-by-phone', data)
}

/**
 * 获取用户信息
 * @returns {Promise}
 */
const getUserInfo = () => {
  return get('/user/info')
}

/**
 * 更新用户信息
 * @param {Object} data 用户数据
 * @returns {Promise}
 */
const updateUserInfo = (data) => {
  return post('/user/update', data)
}

/**
 * 绑定手机号
 * @param {Object} data 手机号数据
 * @returns {Promise}
 */
const bindPhone = (data) => {
  return post('/user/bind-phone', data)
}

/**
 * 用户注销（删除账户）
 * @returns {Promise}
 */
const deleteAccount = () => {
  return del('/user/delete')
}

module.exports = {
  login,
  sendVerifyCode,
  loginByPhone,
  getUserInfo,
  updateUserInfo,
  bindPhone,
  deleteAccount
}