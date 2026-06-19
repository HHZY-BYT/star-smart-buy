// utils/util.js - 工具函数

/**
 * 格式化时间
 * @param {string|Date} date 时间
 * @param {string} format 格式
 * @returns {string} 格式化后的时间字符串
 */
const formatTime = (date, format = 'YYYY-MM-DD HH:mm:ss') => {
  if (!date) return ''
  
  const d = new Date(date)
  const year = d.getFullYear()
  const month = d.getMonth() + 1
  const day = d.getDate()
  const hour = d.getHours()
  const minute = d.getMinutes()
  const second = d.getSeconds()
  
  const pad = (n) => n.toString().padStart(2, '0')
  
  return format
    .replace('YYYY', year)
    .replace('MM', pad(month))
    .replace('DD', pad(day))
    .replace('HH', pad(hour))
    .replace('mm', pad(minute))
    .replace('ss', pad(second))
}

/**
 * 格式化价格
 * @param {number} price 价格
 * @returns {string} 格式化后的价格
 */
const formatPrice = (price) => {
  if (price === null || price === undefined) return '0.00'
  return parseFloat(price).toFixed(2)
}

/**
 * 防抖函数
 * @param {Function} fn 要执行的函数
 * @param {number} delay 延迟时间
 * @returns {Function} 防抖后的函数
 */
const debounce = (fn, delay = 300) => {
  let timer = null
  return function(...args) {
    if (timer) clearTimeout(timer)
    timer = setTimeout(() => {
      fn.apply(this, args)
    }, delay)
  }
}

/**
 * 节流函数
 * @param {Function} fn 要执行的函数
 * @param {number} delay 延迟时间
 * @returns {Function} 节流后的函数
 */
const throttle = (fn, delay = 300) => {
  let lastTime = 0
  return function(...args) {
    const now = Date.now()
    if (now - lastTime >= delay) {
      fn.apply(this, args)
      lastTime = now
    }
  }
}

/**
 * 显示加载
 * @param {string} title 提示文字
 */
const showLoading = (title = '加载中...') => {
  wx.showLoading({
    title,
    mask: true
  })
}

/**
 * 隐藏加载
 */
const hideLoading = () => {
  wx.hideLoading()
}

/**
 * 显示提示
 * @param {string} title 提示文字
 * @param {string} icon 图标类型
 */
const showToast = (title, icon = 'none') => {
  wx.showToast({
    title,
    icon,
    duration: 2000
  })
}

/**
 * 显示确认弹窗
 * @param {string} title 标题
 * @param {string} content 内容
 * @returns {Promise} 返回Promise对象
 */
const showConfirm = (title, content) => {
  return new Promise((resolve, reject) => {
    wx.showModal({
      title,
      content,
      success(res) {
        if (res.confirm) {
          resolve(true)
        } else {
          resolve(false)
        }
      },
      fail: reject
    })
  })
}

/**
 * 获取订单状态文字
 * @param {number} status 状态码
 * @returns {string} 状态文字
 */
const getOrderStatusText = (status) => {
  const statusMap = {
    0: '待付款',
    1: '已付款',
    2: '已发货',
    3: '已完成',
    4: '已取消',
    5: '已退款'
  }
  return statusMap[status] || '未知状态'
}

/**
 * 获取订单状态样式类名
 * @param {number} status 状态码
 * @returns {string} 样式类名
 */
const getOrderStatusClass = (status) => {
  const classMap = {
    0: 'status-pending',
    1: 'status-paid',
    2: 'status-shipped',
    3: 'status-completed',
    4: 'status-cancelled',
    5: 'status-cancelled'
  }
  return classMap[status] || ''
}

/**
 * 检查登录状态
 * @returns {boolean} 是否已登录
 */
const checkLogin = () => {
  const app = getApp()
  return app.isLoggedIn()
}

/**
 * 跳转到登录页
 */
const goToLogin = () => {
  wx.navigateTo({
    url: '/pages/user/user'
  })
}

/**
 * 需要登录的操作
 * @param {Function} callback 回调函数
 */
const requireLogin = (callback) => {
  if (checkLogin()) {
    callback && callback()
  } else {
    wx.showToast({
      title: '请先登录',
      icon: 'none'
    })
    setTimeout(() => {
      goToLogin()
    }, 1500)
  }
}

module.exports = {
  formatTime,
  formatPrice,
  debounce,
  throttle,
  showLoading,
  hideLoading,
  showToast,
  showConfirm,
  getOrderStatusText,
  getOrderStatusClass,
  checkLogin,
  goToLogin,
  requireLogin
}