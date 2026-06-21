// api/ai.js - AI助手相关API
const { get, post } = require('../utils/request')

/**
 * AI聊天
 * @param {Object} data 聊天数据 { message, sessionId, history? }
 * @returns {Promise}
 */
const chat = (data) => {
  return post('/ai/chat', data)
}

/**
 * AI推荐商品
 * @param {Object} data 推荐数据 { requirement, history?, sessionId? }
 * @returns {Promise}
 */
const recommend = (data) => {
  if (typeof data === 'string') {
    data = { requirement: data }
  }
  return post('/ai/recommend', data)
}

module.exports = {
  chat,
  recommend
}