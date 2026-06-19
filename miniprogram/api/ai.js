// api/ai.js - AI助手相关API
const { get, post } = require('../utils/request')

/**
 * AI聊天
 * @param {Object} data 聊天数据 { message, sessionId }
 * @returns {Promise}
 */
const chat = (data) => {
  return post('/ai/chat', data)
}

/**
 * AI推荐商品
 * @param {string} requirement 用户需求
 * @returns {Promise}
 */
const recommend = (requirement) => {
  return get('/ai/recommend', { requirement })
}

module.exports = {
  chat,
  recommend
}