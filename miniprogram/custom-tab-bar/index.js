Component({
  data: {
    selected: 0,
    list: [
      { pagePath: '/pages/index/index', text: '首页', icon: '🏠' },
      { pagePath: '/pages/category/category', text: '分类', icon: '🏷️' },
      { pagePath: '/pages/cart/cart', text: '购物车', icon: '🛒' },
      { pagePath: '/pages/user/user', text: '我的', icon: '👤' }
    ]
  },

  methods: {
    switchTab(e) {
      const { path, index } = e.currentTarget.dataset
      this.setData({ selected: index })
      wx.switchTab({ url: path })
    }
  }
})
