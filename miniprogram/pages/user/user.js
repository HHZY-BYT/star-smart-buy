// pages/user/user.js
const app = getApp()
const { login, getUserInfo, updateUserInfo, bindPhone, loginByPhone, sendVerifyCode, deleteAccount } = require('../../api/user')
const { getOrderCounts } = require('../../api/order')

Page({
  data: {
    isLoggedIn: false,
    userInfo: null,
    orderCounts: {
      pending: 0,
      paid: 0,
      shipped: 0,
      completed: 0
    },
    showPhoneModal: false,
    phone: '',
    showNicknameModal: false,
    nickname: '',
    defaultAvatar: '/images/default-avatar.png',
    showLoginModal: false,
    loginPhone: '',
    loginVerifyCode: '',
    verifyCodeSent: false,
    countdown: 0,
    loginType: 'wechat'
  },

  onLoad() {
    this.checkLoginStatus()
  },

  onShow() {
    if (typeof this.getTabBar === 'function' && this.getTabBar()) {
      this.getTabBar().setData({ selected: 3 })
    }
    this.checkLoginStatus()
  },

  checkLoginStatus() {
    const isLoggedIn = app.isLoggedIn()
    const userInfo = app.globalData.userInfo
    
    this.setData({
      isLoggedIn,
      userInfo
    })
    
    if (isLoggedIn) {
      this.loadOrderCounts()
      this.loadUserInfo()
    }
  },

  async loadUserInfo() {
    try {
      const result = await getUserInfo()
      this.setData({
        userInfo: {
          ...this.data.userInfo,
          nickname: result.nickname || this.data.userInfo.nickname,
          avatar: result.avatar || this.data.defaultAvatar,
          phone: result.phone || this.data.userInfo.phone
        }
      })
      app.globalData.userInfo = this.data.userInfo
    } catch (error) {
      console.error('获取用户信息失败:', error)
    }
  },

  async loadOrderCounts() {
    try {
      const counts = await getOrderCounts()
      this.setData({
        orderCounts: {
          pending: counts.pending || 0,
          paid: counts.paid || 0,
          shipped: counts.shipped || 0,
          completed: counts.completed || 0
        }
      })
    } catch (error) {
      console.error('获取订单数量失败:', error)
      this.setData({
        orderCounts: {
          pending: 0,
          paid: 0,
          shipped: 0,
          completed: 0
        }
      })
    }
  },

  async onLogin() {
    wx.showActionSheet({
      itemList: ['微信登录', '手机号登录'],
      success: (res) => {
        if (res.tapIndex === 0) {
          this.wechatLogin()
        } else {
          this.setData({ 
            showLoginModal: true,
            loginType: 'phone',
            loginPhone: '',
            loginVerifyCode: '',
            verifyCodeSent: false,
            countdown: 0
          })
        }
      }
    })
  },

  async wechatLogin() {
    try {
      wx.showLoading({ title: '登录中...' })
      
      const loginRes = await wx.login()
      
      let openid = wx.getStorageSync('openid')
      
      if (!openid) {
        openid = 'wx_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9)
        wx.setStorageSync('openid', openid)
      }
      
      const result = await login({
        code: loginRes.code,
        openid: openid,
        phone: ''
      })
      
      app.setUserInfo({
        userId: result.userId,
        nickname: result.nickname,
        avatar: result.avatar || this.data.defaultAvatar,
        phone: result.phone,
        openid: openid
      }, result.token)
      
      this.setData({
        isLoggedIn: true,
        userInfo: {
          userId: result.userId,
          nickname: result.nickname,
          avatar: result.avatar || this.data.defaultAvatar,
          phone: result.phone,
          openid: openid
        }
      })
      
      wx.hideLoading()
      wx.showToast({
        title: '登录成功',
        icon: 'success'
      })
      
      this.loadOrderCounts()
    } catch (error) {
      wx.hideLoading()
      console.error('登录失败:', error)
      wx.showToast({
        title: '登录失败',
        icon: 'none'
      })
    }
  },

  onLoginPhoneInput(e) {
    this.setData({
      loginPhone: e.detail.value
    })
  },

  onVerifyCodeInput(e) {
    this.setData({
      loginVerifyCode: e.detail.value
    })
  },

  async sendVerifyCode() {
    const phone = this.data.loginPhone.trim()
    
    if (!/^1[3-9]\d{9}$/.test(phone)) {
      wx.showToast({
        title: '请输入正确的手机号',
        icon: 'none'
      })
      return
    }

    try {
      wx.showLoading({ title: '发送中...' })
      
      await sendVerifyCode({ phone })
      
      wx.hideLoading()
      
      this.setData({
        verifyCodeSent: true,
        countdown: 60
      })
      
      this.startCountdown()
      
      wx.showToast({
        title: '验证码已发送(模拟:123456)',
        icon: 'none',
        duration: 3000
      })
    } catch (error) {
      wx.hideLoading()
      console.error('发送验证码失败:', error)
      wx.showToast({
        title: error.message || '发送失败',
        icon: 'none'
      })
    }
  },

  startCountdown() {
    if (this.data.countdown > 0) {
      this.setData({
        countdown: this.data.countdown - 1
      })
      setTimeout(() => {
        this.startCountdown()
      }, 1000)
    } else {
      this.setData({
        verifyCodeSent: false
      })
    }
  },

  async onPhoneLogin() {
    const phone = this.data.loginPhone.trim()
    const verifyCode = this.data.loginVerifyCode.trim()
    
    if (!/^1[3-9]\d{9}$/.test(phone)) {
      wx.showToast({
        title: '请输入正确的手机号',
        icon: 'none'
      })
      return
    }

    if (!verifyCode || verifyCode.length !== 6) {
      wx.showToast({
        title: '请输入6位验证码',
        icon: 'none'
      })
      return
    }

    try {
      wx.showLoading({ title: '登录中...' })
      
      const result = await loginByPhone({ phone, verifyCode })
      
      wx.hideLoading()
      
      app.setUserInfo({
        userId: result.userId,
        nickname: result.nickname,
        avatar: result.avatar || this.data.defaultAvatar,
        phone: result.phone
      }, result.token)
      
      this.setData({
        isLoggedIn: true,
        userInfo: {
          userId: result.userId,
          nickname: result.nickname,
          avatar: result.avatar || this.data.defaultAvatar,
          phone: result.phone
        },
        showLoginModal: false,
        loginPhone: '',
        loginVerifyCode: '',
        verifyCodeSent: false,
        countdown: 0
      })
      
      wx.showToast({
        title: '登录成功',
        icon: 'success'
      })
      
      this.loadOrderCounts()
    } catch (error) {
      wx.hideLoading()
      console.error('登录失败:', error)
      wx.showToast({
        title: error.message || '登录失败',
        icon: 'none'
      })
    }
  },

  closeLoginModal() {
    this.setData({
      showLoginModal: false,
      loginPhone: '',
      loginVerifyCode: '',
      verifyCodeSent: false,
      countdown: 0
    })
  },

  onGetUserInfo(e) {
    if (e.detail.userInfo) {
      const userInfo = e.detail.userInfo
      this.setData({
        userInfo: {
          ...this.data.userInfo,
          nickname: userInfo.nickName,
          avatar: userInfo.avatarUrl
        }
      })
    }
  },

  onLogout() {
    wx.showModal({
      title: '提示',
      content: '确定要退出登录吗？',
      success: (res) => {
        if (res.confirm) {
          app.clearUserInfo()
          this.setData({
            isLoggedIn: false,
            userInfo: null,
            orderCounts: {
              pending: 0,
              paid: 0,
              shipped: 0,
              completed: 0
            }
          })
          wx.showToast({
            title: '已退出登录',
            icon: 'success'
          })
        }
      }
    })
  },

  onOrderTap(e) {
    const { status } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/order/order?status=${status || ''}`
    })
  },

  onMyReviewsTap() {
    wx.navigateTo({
      url: '/pages/my-reviews/my-reviews'
    })
  },

  onAddressTap() {
    wx.navigateTo({
      url: '/pages/address/address'
    })
  },

  onAiChatTap() {
    wx.navigateTo({
      url: '/pages/ai-chat/ai-chat'
    })
  },

  onSettingsTap() {
    wx.showToast({
      title: '功能开发中',
      icon: 'none'
    })
  },

  showDeleteConfirm() {
    wx.showModal({
      title: '确认注销',
      content: '注销后将删除您的所有数据，此操作不可恢复！',
      confirmColor: '#f56c6c',
      success: (res) => {
        if (res.confirm) {
          this.deleteAccount()
        }
      }
    })
  },

  async deleteAccount() {
    try {
      wx.showLoading({ title: '处理中...' })
      
      await deleteAccount()
      
      wx.removeStorageSync('openid')
      app.clearUserInfo()
      
      wx.hideLoading()
      wx.showToast({
        title: '注销成功',
        icon: 'success'
      })
      
      this.setData({
        isLoggedIn: false,
        userInfo: null,
        orderCounts: {
          pending: 0,
          paid: 0,
          shipped: 0,
          completed: 0
        }
      })
    } catch (error) {
      wx.hideLoading()
      console.error('注销失败:', error)
      wx.showToast({
        title: '注销失败',
        icon: 'none'
      })
    }
  },

  chooseAvatar() {
    wx.chooseMedia({
      count: 1,
      mediaType: ['image'],
      sourceType: ['album', 'camera'],
      success: async (res) => {
        const tempFilePath = res.tempFiles[0].tempFilePath
        
        try {
          wx.showLoading({ title: '上传中...' })
          
          const token = app.getToken()
          const uploadRes = await new Promise((resolve, reject) => {
            wx.uploadFile({
              url: `${app.globalData.baseUrl}/upload/image`,
              filePath: tempFilePath,
              name: 'file',
              header: token ? {
                'Authorization': 'Bearer ' + token
              } : {},
              success: resolve,
              fail: reject
            })
          })
          
          console.log('上传响应:', uploadRes.statusCode, uploadRes.data)
          
          if (uploadRes.statusCode !== 200) {
            wx.hideLoading()
            wx.showToast({ title: '上传失败(' + uploadRes.statusCode + ')', icon: 'none' })
            return
          }
          
          let result
          try {
            result = JSON.parse(uploadRes.data)
          } catch (e) {
            wx.hideLoading()
            console.error('解析响应失败, 原始数据:', uploadRes.data)
            wx.showToast({ title: '服务器响应异常', icon: 'none' })
            return
          }
          
          if (result.code === 200) {
            const avatarUrl = result.data
            await updateUserInfo({ avatar: avatarUrl })
            
            this.setData({
              userInfo: {
                ...this.data.userInfo,
                avatar: avatarUrl
              }
            })
            app.globalData.userInfo = this.data.userInfo
            
            wx.hideLoading()
            wx.showToast({
              title: '头像更新成功',
              icon: 'success'
            })
          } else {
            wx.hideLoading()
            wx.showToast({
              title: result.message || '上传失败',
              icon: 'none'
            })
          }
        } catch (error) {
          wx.hideLoading()
          console.error('上传头像失败:', error)
          wx.showToast({
            title: '上传失败',
            icon: 'none'
          })
        }
      }
    })
  },

  onAvatarTap() {
    wx.showActionSheet({
      itemList: ['更换头像'],
      success: (res) => {
        if (res.tapIndex === 0) {
          this.chooseAvatar()
        }
      }
    })
  },

  showPhoneInput() {
    this.setData({
      showPhoneModal: true,
      phone: this.data.userInfo?.phone || ''
    })
  },

  hidePhoneModal() {
    this.setData({
      showPhoneModal: false
    })
  },

  onPhoneInput(e) {
    this.setData({
      phone: e.detail.value
    })
  },

  async savePhone() {
    const phone = this.data.phone.trim()
    
    if (!/^1[3-9]\d{9}$/.test(phone)) {
      wx.showToast({
        title: '请输入正确的手机号',
        icon: 'none'
      })
      return
    }

    try {
      wx.showLoading({ title: '保存中...' })
      
      await bindPhone({ phone })
      
      this.setData({
        userInfo: {
          ...this.data.userInfo,
          phone
        },
        showPhoneModal: false
      })
      app.globalData.userInfo = this.data.userInfo
      
      wx.hideLoading()
      wx.showToast({
        title: '保存成功',
        icon: 'success'
      })
    } catch (error) {
      wx.hideLoading()
      console.error('保存手机号失败:', error)
      wx.showToast({
        title: '保存失败',
        icon: 'none'
      })
    }
  },

  showNicknameInput() {
    this.setData({
      showNicknameModal: true,
      nickname: this.data.userInfo?.nickname || ''
    })
  },

  hideNicknameModal() {
    this.setData({
      showNicknameModal: false
    })
  },

  onNicknameInput(e) {
    this.setData({
      nickname: e.detail.value
    })
  },

  async saveNickname() {
    const nickname = this.data.nickname.trim()
    
    if (!nickname || nickname.length < 2) {
      wx.showToast({
        title: '昵称至少2个字符',
        icon: 'none'
      })
      return
    }

    try {
      wx.showLoading({ title: '保存中...' })
      
      await updateUserInfo({ nickname })
      
      this.setData({
        userInfo: {
          ...this.data.userInfo,
          nickname
        },
        showNicknameModal: false
      })
      app.globalData.userInfo = this.data.userInfo
      
      wx.hideLoading()
      wx.showToast({
        title: '保存成功',
        icon: 'success'
      })
    } catch (error) {
      wx.hideLoading()
      console.error('保存昵称失败:', error)
      wx.showToast({
        title: '保存失败',
        icon: 'none'
      })
    }
  },

  stopPropagation() {
  }
})