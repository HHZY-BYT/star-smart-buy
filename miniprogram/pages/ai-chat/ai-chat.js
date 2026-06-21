// pages/ai-chat/ai-chat.js
const { chat, recommend } = require('../../api/ai')
const { getProductList } = require('../../api/product')
const { formatPrice } = require('../../utils/util')

Page({
  data: {
    messages: [],
    inputText: '',
    sessionId: '',
    loading: false,
    recommendedProducts: [],
    quickQuestions: [
      { icon: '📱', text: '推荐一款性价比高的手机' },
      { icon: '💻', text: '5000元预算买什么笔记本' },
      { icon: '🎮', text: '游戏本和商务本的区别' }
    ]
  },

  onLoad() {
    // 初始化会话
    this.setData({
      sessionId: 'session_' + Date.now()
    })
    
    // 添加欢迎消息
    this.addMessage('ai', '您好！我是星智购AI智能助手，可以帮您：\n\n• 推荐合适的数码产品\n• 解答购物相关问题\n• 提供产品对比建议\n\n例如："推荐一款5000元左右的游戏本"')
  },

  // 添加消息
  addMessage(type, content, products = null) {
    const messages = this.data.messages
    messages.push({
      id: Date.now(),
      type,
      content,
      products,
      time: new Date().toLocaleTimeString()
    })
    this.setData({ messages })
    this.scrollToBottom()
  },

  // 滚动到底部
  scrollToBottom() {
    setTimeout(() => {
      const messages = this.data.messages
      if (messages.length === 0) return
      const lastId = `msg-${messages[messages.length - 1].id}`
      this.setData({ scrollToView: lastId })
    }, 100)
  },

  // 输入消息
  onInput(e) {
    this.setData({ inputText: e.detail.value })
  },

  // 发送消息
  async onSend() {
    const { inputText, sessionId, messages } = this.data
    
    if (!inputText.trim()) {
      wx.showToast({ title: '请输入内容', icon: 'none' })
      return
    }
    
    // 添加用户消息
    this.addMessage('user', inputText)
    this.setData({ inputText: '', loading: true })
    
    // 构建历史消息用于上下文记忆
    const recentMessages = messages.slice(-10).map(m => ({
      role: m.type === 'user' ? 'user' : 'assistant',
      content: m.content
    }))
    
    try {
      // 检测是否是推荐请求（更精确的正则，避免"就要""想要"等误判）
      const isRecommendRequest = /^推荐|^帮我推荐|推荐.*[手机笔记本平板耳机]|预算.*[买选]|.*以内.*推荐|.*以下.*推荐|.*左右.*(买|选|推荐)|我想买|想买个|有什么.*推荐|哪个.*好/.test(inputText)
      
      if (isRecommendRequest) {
        // 获取推荐 - 传入历史消息保持上下文
        const reply = await recommend({ 
          requirement: inputText,
          history: recentMessages,
          sessionId 
        })
        
        // 从AI回复中提取提到的商品名称，再搜索展示
        let products = []
        try {
          const extractedNames = this.extractProductNamesFromReply(reply)
          console.log('提取到的商品名:', extractedNames)
          
          if (extractedNames.length > 0) {
            // 并行搜索所有商品
            const searchResults = await Promise.allSettled(
              extractedNames.map(name => getProductList({ page: 1, size: 3, keyword: name }))
            )
            
            for (const result of searchResults) {
              if (result.status === 'fulfilled' && result.value.records && result.value.records.length > 0) {
                products.push({
                  ...result.value.records[0],
                  priceText: formatPrice(result.value.records[0].price)
                })
              }
            }
          }
          
          // 如果搜到的商品不足3个，用关键词补充搜索
          if (products.length < 3) {
            const keyword = this.extractKeyword(inputText)
            if (keyword && !products.some(p => p.name.includes(keyword))) {
              try {
                const res = await getProductList({ page: 1, size: 3, keyword })
                for (const item of res.records || []) {
                  if (!products.find(p => p.id === item.id)) {
                    products.push({ ...item, priceText: formatPrice(item.price) })
                    if (products.length >= 3) break
                  }
                }
              } catch (e) { /* ignore */ }
            }
          }
        } catch (e) {
          console.log('获取商品失败:', e)
        }
        
        // 去重并限制最多3个
        products = products.filter((item, index, self) => index === self.findIndex(p => p.id === item.id)).slice(0, 3)
        this.addMessage('ai', reply, products)
      } else {
        // 普通聊天 - 传入历史消息保持上下文
        const res = await chat({ message: inputText, sessionId, history: recentMessages })
        this.addMessage('ai', res.reply)
      }
      
      this.setData({ loading: false })
    } catch (error) {
      console.error('AI对话失败:', error)
      this.setData({ loading: false })
      this.addMessage('ai', '抱歉，我暂时无法回答这个问题，请稍后再试。')
    }
  },

  // 提取关键词
  extractKeyword(text) {
    const keywords = [
      '手机', '笔记本', '游戏本', '平板', '耳机', '键盘', '鼠标', '显示器', '台式机',
      'iPhone', 'vivo', '华为', '小米', 'iPad', 'MacBook', '索尼'
    ]
    for (const keyword of keywords) {
      if (text.includes(keyword)) {
        return keyword
      }
    }
    return ''
  },

  // 从AI回复中提取商品名称（用于精确搜索展示商品卡片）
  extractProductNamesFromReply(reply) {
    if (!reply) return []
    const names = []
    // 更全面的商品名匹配模式
    const patterns = [
      /小米\d+\s*[\w]*(?:Ultra|Pro|Max|Plus)?(?:\s*\d+\s*(?:GB|G))?/gi,
      /(vivo\s+[\w]+)/gi,
      /(iPhone\s+[\d\w\s]+?)(?:[，。！？]|$|价格)/gi,
      /(华为[\s\S]*?Mate\s*[\d\w]*)/gi,
      /(华为[\s\S]*?(?:Pro|Max)[\s\w]*)/gi,
      /iPad\s*[\w\s]*/gi,
      /MacBook\s*[\w\s]*/gi,
      /(索尼[\s\w]+)/gi,
      /(小米[\s\S]*?(?:路由器|平板|耳机|手表|显示器|电视)[\s\w]*)/gi,
      /(小米[\s\S]*?\d+\s*(?:GB|G))/gi
    ]
    for (const pattern of patterns) {
      const matches = reply.match(pattern)
      if (matches) {
        matches.forEach(m => {
          const cleaned = m.trim()
            .replace(/^[**""]|[**""]$/g, '')
            .replace(/[**]/g, '')
            .trim()
          if (cleaned.length > 3 && !names.includes(cleaned)) {
            names.push(cleaned)
          }
        })
      }
    }
    console.log('提取到的原始商品名:', names)
    return [...new Set(names)].slice(0, 5)
  },

  // 点击推荐商品
  onProductTap(e) {
    const { id } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/product/product?id=${id}`
    })
  },

  // 快捷提问
  onQuickQuestion(e) {
    const { question } = e.currentTarget.dataset
    this.setData({ inputText: question })
    this.onSend()
  }
})