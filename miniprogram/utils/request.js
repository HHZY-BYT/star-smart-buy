// utils/request.js - 网络请求封装

/**
 * 封装请求方法
 * @param {Object} options 请求配置
 * @returns {Promise} 返回Promise对象
 */
const request = (options) => {
  return new Promise((resolve, reject) => {
    const { url, method = 'GET', data = {}, header = {} } = options
    
    // 过滤掉 undefined 和 null 的参数，防止序列化为 "undefined" 字符串
    const filteredData = {}
    for (const key in data) {
      if (data[key] !== undefined && data[key] !== null && data[key] !== '') {
        filteredData[key] = data[key]
      }
    }
    
    const app = getApp()
    // 获取token
    const token = (app && app.globalData && app.globalData.token) || wx.getStorageSync('token')
    
    // 设置请求头
    const headers = {
      'Content-Type': 'application/json',
      ...header
    }
    
    // 如果有token，添加到请求头
    if (token) {
      headers['Authorization'] = `Bearer ${token}`
    }
    
    wx.request({
      url: `${(app && app.globalData && app.globalData.baseUrl) || 'http://localhost:8080/api'}${url}`,
      method,
      data: filteredData,
      header: headers,
      success(res) {
        if (res.statusCode === 200) {
          const result = res.data
          if (result.code === 200) {
            resolve(result.data)
          } else if (result.code === 401) {
            // token过期，清除登录状态
            if (app && app.clearUserInfo) {
              app.clearUserInfo()
            }
            wx.showToast({
              title: '请重新登录',
              icon: 'none'
            })
            // 跳转到登录页
            wx.navigateTo({
              url: '/pages/user/user'
            })
            reject(new Error(result.message || '未授权'))
          } else {
            wx.showToast({
              title: result.message || '请求失败',
              icon: 'none'
            })
            reject(new Error(result.message || '请求失败'))
          }
        } else {
          console.error('请求异常:', method, url, '状态码:', res.statusCode, '响应:', res.data)
          wx.showToast({
            title: `请求失败(${res.statusCode})`,
            icon: 'none'
          })
          reject(new Error(`HTTP ${res.statusCode}: ${JSON.stringify(res.data)}`))
        }
      },
      fail(err) {
        wx.showToast({
          title: '网络连接失败',
          icon: 'none'
        })
        reject(err)
      }
    })
  })
}

// GET请求
const get = (url, data = {}) => {
  return request({ url, method: 'GET', data })
}

// POST请求
const post = (url, data = {}) => {
  return request({ url, method: 'POST', data })
}

// PUT请求
const put = (url, data = {}) => {
  return request({ url, method: 'PUT', data })
}

// DELETE请求
const del = (url, data = {}) => {
  return request({ url, method: 'DELETE', data })
}

module.exports = {
  request,
  get,
  post,
  put,
  del
}