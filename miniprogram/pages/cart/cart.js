// pages/cart/cart.js
const { getCartList, updateCartQuantity, removeFromCart } = require('../../api/cart')
const { formatPrice, showConfirm, requireLogin, showToast } = require('../../utils/util')

Page({
  data: {
    cartList: [],
    selectedItems: [],
    totalPrice: 0,
    totalCount: 0,
    loading: true,
    isEdit: false,
    allSelected: false
  },

  onLoad() {
    this.loadCart()
  },

  onShow() {
    if (typeof this.getTabBar === 'function' && this.getTabBar()) {
      this.getTabBar().setData({ selected: 2 })
    }
    this.loadCart()
  },

  // 加载购物车
  async loadCart() {
    try {
      this.setData({ loading: true })
      
      const cartList = await getCartList()
      
      const processedList = (cartList || []).map(item => ({
        ...item,
        priceText: formatPrice(item.price),
        selected: this.data.selectedItems.includes(item.id)
      }))
      
      this.setData({
        cartList: processedList,
        loading: false
      })
      
      this.calculateTotal()
    } catch (error) {
      console.error('加载购物车失败:', error)
      this.setData({ loading: false })
    }
  },

  // 计算总价
  calculateTotal() {
    const { cartList } = this.data
    let totalPrice = 0
    let totalCount = 0
    
    cartList.forEach(item => {
      if (item.selected) {
        totalPrice += item.price * item.quantity
        totalCount += item.quantity
      }
    })
    
    // 计算全选状态
    const allSelected = cartList.length > 0 && cartList.every(item => item.selected)
    
    this.setData({
      totalPrice: formatPrice(totalPrice),
      totalCount,
      allSelected
    })
  },

  // 选择商品
  onSelectItem(e) {
    requireLogin(() => {
      const { id } = e.currentTarget.dataset
      const { cartList } = this.data
      
      const index = cartList.findIndex(item => item.id === id)
      if (index !== -1) {
        cartList[index].selected = !cartList[index].selected
      }
      
      this.setData({ cartList })
      this.calculateTotal()
    })
  },

  // 全选
  onSelectAll() {
    requireLogin(() => {
      const { cartList } = this.data
      const allSelected = cartList.every(item => item.selected)
      
      cartList.forEach(item => {
        item.selected = !allSelected
      })
      
      this.setData({ cartList })
      this.calculateTotal()
    })
  },

  // 增加数量
  async onIncrease(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      const { cartList } = this.data
      
      const index = cartList.findIndex(item => item.id === id)
      if (index !== -1) {
        const newQuantity = cartList[index].quantity + 1
        
        try {
          await updateCartQuantity({ id, quantity: newQuantity })
          cartList[index].quantity = newQuantity
          this.setData({ cartList })
          this.calculateTotal()
        } catch (error) {
          console.error('更新数量失败:', error)
        }
      }
    })
  },

  // 减少数量
  async onDecrease(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      const { cartList } = this.data
      
      const index = cartList.findIndex(item => item.id === id)
      if (index !== -1 && cartList[index].quantity > 1) {
        const newQuantity = cartList[index].quantity - 1
        
        try {
          await updateCartQuantity({ id, quantity: newQuantity })
          cartList[index].quantity = newQuantity
          this.setData({ cartList })
          this.calculateTotal()
        } catch (error) {
          console.error('更新数量失败:', error)
        }
      }
    })
  },

  // 删除商品
  async onDelete(e) {
    requireLogin(async () => {
      const { id } = e.currentTarget.dataset
      
      const confirmed = await showConfirm('确认删除', '确定要删除该商品吗？')
      if (!confirmed) return
      
      try {
        await removeFromCart(id)
        this.loadCart()
      } catch (error) {
        console.error('删除失败:', error)
      }
    })
  },

  // 编辑模式
  onEdit() {
    requireLogin(() => {
      this.setData({ isEdit: !this.data.isEdit })
    })
  },

  // 结算
  onCheckout() {
    requireLogin(() => {
      const { cartList } = this.data
      const selectedItems = cartList.filter(item => item.selected)
      
      if (selectedItems.length === 0) {
        wx.showToast({
          title: '请选择商品',
          icon: 'none'
        })
        return
      }
      
      // 跳转到创建订单页
      wx.navigateTo({
        url: `/pages/create-order/create-order?items=${JSON.stringify(selectedItems.map(item => ({
          cartId: item.id,
          productId: item.productId,
          productName: item.productName || item.name,
          price: item.price,
          quantity: item.quantity,
          image: item.image,
          specIds: item.specIds || (item.specId ? String(item.specId) : ''),
          specName: item.specName || '',
          specValue: item.specValue || ''
        })))}`
      })
    })
  },

  // 点击商品
  onProductTap(e) {
    const { productId } = e.currentTarget.dataset
    wx.navigateTo({
      url: `/pages/product/product?id=${productId}`
    })
  },

  // 去逛逛（跳转首页）
  onGoShopping() {
    wx.switchTab({
      url: '/pages/index/index'
    })
  }
})