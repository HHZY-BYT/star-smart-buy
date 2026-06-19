// pages/address/address.js
const { getAddressList, deleteAddress, setDefaultAddress } = require('../../api/address')
const { requireLogin } = require('../../utils/util')

Page({
  data: {
    addresses: [],
    loading: true,
    selectMode: false // 选择地址模式
  },

  onLoad(options) {
    this.setData({
      selectMode: options.select === '1'
    })
    this.loadAddresses()
  },

  onShow() {
    this.loadAddresses()
  },

  // 加载地址列表
  async loadAddresses() {
    try {
      this.setData({ loading: true })
      
      const addresses = await getAddressList()
      
      this.setData({
        addresses: addresses || [],
        loading: false
      })
    } catch (error) {
      console.error('加载地址失败:', error)
      this.setData({ loading: false })
    }
  },

  // 选择地址
  onSelectAddress(e) {
    if (!this.data.selectMode) return
    
    const { address } = e.currentTarget.dataset
    
    // 返回上一页并传递地址
    const pages = getCurrentPages()
    const prevPage = pages[pages.length - 2]
    
    if (prevPage) {
      prevPage.setData({ address })
      wx.navigateBack()
    }
  },

  // 设置默认地址
  async onSetDefault(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      
      try {
        await setDefaultAddress(id)
        wx.showToast({
          title: '已设为默认',
          icon: 'success'
        })
        this.loadAddresses()
      } catch (error) {
        console.error('设置默认地址失败:', error)
      }
    })
  },

  // 编辑地址
  onEditAddress(e) {
    requireLogin(() => {
      const { id } = e.currentTarget.dataset
      wx.navigateTo({
        url: `/pages/address-edit/address-edit?id=${id}`
      })
    })
  },

  // 新增地址
  onAddAddress() {
    requireLogin(() => {
      wx.navigateTo({
        url: '/pages/address-edit/address-edit'
      })
    })
  },

  // 删除地址
  async onDeleteAddress(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      
      wx.showModal({
        title: '提示',
        content: '确定要删除该地址吗？',
        success: async (res) => {
          if (res.confirm) {
            try {
              await deleteAddress(id)
              wx.showToast({
                title: '删除成功',
                icon: 'success'
              })
              this.loadAddresses()
            } catch (error) {
              console.error('删除地址失败:', error)
            }
          }
        }
      })
    })
  }
})