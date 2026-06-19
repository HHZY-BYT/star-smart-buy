// api/home.js - 首页数据API（轮播图、公告等）
const { get } = require('../utils/request')

/**
 * 获取首页数据（轮播图 + 公告）
 * @returns {Promise}
 */
const getHomeData = () => {
  return get('/home')
}

/**
 * 获取轮播图列表
 * @returns {Promise}
 */
const getBanners = () => {
  return get('/home/banners')
}

/**
 * 获取公告列表
 * @returns {Promise}
 */
const getNotices = () => {
  return get('/home/notices')
}

module.exports = {
  getHomeData,
  getBanners,
  getNotices
}
