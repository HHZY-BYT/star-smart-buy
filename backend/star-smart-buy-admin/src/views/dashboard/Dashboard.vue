<template>
  <el-container class="layout-container">
    <!-- 侧边栏 -->
    <el-aside class="sidebar" width="220px">
      <!-- Logo 区域 -->
      <div class="sidebar-header">
        <div class="logo-wrapper">
          <div class="logo-icon">
            <el-icon><Shop /></el-icon>
          </div>
          <span class="logo-text">星智购</span>
        </div>
      </div>

      <!-- 导航菜单 -->
      <el-menu
        :default-active="route.path"
        router
        :unique-opened="true"
        class="sidebar-menu"
        background-color="#1a1f36"
        text-color="#8b919e"
        active-text-color="#ffffff"
      >
        <el-menu-item index="/admin/dashboard/overview">
          <el-icon><DataAnalysis /></el-icon>
          <template #title>数据概览</template>
        </el-menu-item>

        <el-sub-menu index="product">
          <template #title>
            <el-icon><Goods /></el-icon>
            <span>商品管理</span>
          </template>
          <el-menu-item index="/admin/products">商品列表</el-menu-item>
          <el-menu-item index="/admin/categories">分类管理</el-menu-item>
          <el-menu-item index="/admin/reviews">评价管理</el-menu-item>
        </el-sub-menu>

        <el-sub-menu index="order">
          <template #title>
            <el-icon><List /></el-icon>
            <span>订单管理</span>
          </template>
          <el-menu-item index="/admin/orders">全部订单</el-menu-item>
          <el-menu-item index="/admin/refunds">退款售后</el-menu-item>
        </el-sub-menu>

        <el-menu-item index="/admin/users">
          <el-icon><User /></el-icon>
          <template #title>用户管理</template>
        </el-menu-item>

        <el-menu-item index="/admin/logs">
          <el-icon><Notebook /></el-icon>
          <template #title>日志管理</template>
        </el-menu-item>

        <el-menu-item index="/admin/settings">
          <el-icon><Setting /></el-icon>
          <template #title>系统设置</template>
        </el-menu-item>
      </el-menu>
    </el-aside>

    <!-- 右侧主内容区 -->
    <el-container class="main-wrapper">
      <!-- 顶部导航栏 -->
      <el-header class="main-header">
        <div class="header-left">
          <!-- 面包屑 -->
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/admin/dashboard/overview' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item v-if="route.path !== '/admin/dashboard/overview'">
              {{ route.meta.title }}
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>

        <div class="header-right">
          <!-- 搜索框 -->
          <div class="header-search" v-click-outside="closeSearch">
            <el-input
              ref="searchInputRef"
              v-model="searchQuery"
              placeholder="搜索商品、订单、用户..."
              prefix-icon="Search"
              size="default"
              clearable
              class="search-input"
              @input="onSearchInput"
              @keyup.enter="doGlobalSearch"
              @focus="showSearchDropdown = true"
            />
            <!-- 搜索下拉面板 -->
            <div class="search-dropdown" v-if="showSearchDropdown && (searchResults.length > 0 || searchQuery.length > 1)">
              <template v-if="searchLoading">
                <div class="search-loading"><el-icon class="is-loading"><Loading /></el-icon> 搜索中...</div>
              </template>
              <template v-else-if="searchResults.length > 0">
                <div class="search-section" v-for="(group, key) in groupedResults" :key="key">
                  <div class="search-group-title">{{ group.label }}</div>
                  <div
                    class="search-result-item"
                    v-for="item in group.items.slice(0, 5)"
                    :key="item.id || item.orderNo"
                    @click="navigateToResult(item, key)"
                  >
                    <span class="result-icon">{{ getSearchIcon(key) }}</span>
                    <div class="result-content">
                      <span class="result-title">{{ item.name || item.title || item.username || item.orderNo || item.nickname }}</span>
                      <span class="result-sub">{{ getSearchSub(item, key) }}</span>
                    </div>
                    <span class="result-arrow">→</span>
                  </div>
                </div>
                <div class="search-footer" @click="goToFullSearch">
                  查看全部搜索结果 →
                </div>
              </template>
              <template v-else-if="!searchLoading && searchQuery.trim().length > 1">
                <div class="search-empty">未找到相关结果</div>
              </template>
            </div>
          </div>

          <!-- 消息通知 -->
          <el-badge :value="unreadCount > 0 ? unreadCount : undefined" :max="99" class="header-badge" @click.native="showNotifications">
            <el-icon class="header-icon notification-icon"><Bell /></el-icon>
          </el-badge>

          <!-- 全屏 -->
          <el-tooltip content="全屏" placement="bottom">
            <el-icon class="header-icon" @click="toggleFullScreen">
              <FullScreen />
            </el-icon>
          </el-tooltip>

          <!-- 用户信息 -->
          <el-dropdown @command="handleCommand" trigger="click">
            <div class="user-info">
              <div class="user-avatar">
                <el-icon><Avatar /></el-icon>
              </div>
              <div class="user-details">
                <span class="user-name">{{ adminStore.username }}</span>
                <span class="user-role">超级管理员</span>
              </div>
              <el-icon class="user-arrow"><ArrowDown /></el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="settings">
                  <el-icon><Setting /></el-icon>账号设置
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <el-icon><SwitchButton /></el-icon>退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </el-header>

      <!-- 主内容区 -->
      <el-main class="main-content">
        <router-view />
      </el-main>

      <!-- 底部版权 -->
      <el-footer class="main-footer">
        <span>© 2026 星智购</span>
      </el-footer>
    </el-container>

    <!-- 通知抽屉 -->
    <el-drawer v-model="notificationDrawer" title="消息通知" size="380px" :append-to-body="true">
      <div class="notification-drawer">
        <div class="drawer-header">
          <el-button type="primary" link size="small" @click="markAllRead" :disabled="unreadCount === 0">全部已读</el-button>
        </div>
        <div class="notification-list" v-if="notifications.length > 0">
          <div class="notification-item" v-for="item in notifications" :key="item.id" :class="{ unread: item.readStatus === 0 }" @click="markRead(item)">
            <div class="notification-type-icon">
              <span v-if="item.type === 'order'">📦</span>
              <span v-else-if="item.type === 'refund'">💰</span>
              <span v-else>🔔</span>
            </div>
            <div class="notification-content">
              <div class="notification-title">{{ item.title }}</div>
              <div class="notification-desc">{{ item.content }}</div>
              <div class="notification-time">{{ formatTime(item.createdAt) }}</div>
            </div>
            <el-button type="danger" link size="small" @click.stop="removeNotification(item.id)">
              <el-icon><Delete /></el-icon>
            </el-button>
          </div>
        </div>
        <div class="no-notifications" v-else>
          <span>📭</span>
          <p>暂无通知</p>
        </div>
      </div>
    </el-drawer>
  </el-container>
</template>

<script setup>
/**
 * 管理后台布局框架
 *
 * 提供侧边栏导航、全局搜索（商品/订单/用户并行查询）、
 * WebSocket 实时通知、通知抽屉、全屏切换等功能。
 */
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useAdminStore } from '@/store/modules/admin'
import { getNotificationList, markAsRead, markAllAsRead, deleteNotification } from '@/api/admin'

const route = useRoute()
const router = useRouter()
const adminStore = useAdminStore()

// ========== 全局搜索 ==========
const searchQuery = ref('')
const searchInputRef = ref(null)
const showSearchDropdown = ref(false)
const searchLoading = ref(false)
const searchResults = ref([])
let searchTimer = null

/** 搜索输入防抖（400ms） */
const onSearchInput = () => {
  clearTimeout(searchTimer)
  if (!searchQuery.value || searchQuery.value.trim().length < 2) {
    searchResults.value = []
    return
  }
  searchTimer = setTimeout(() => doGlobalSearch(), 400)
}

/**
 * 并行搜索商品、订单、用户
 * 使用 Promise.allSettled 确保一个失败不影响其他搜索
 */
const doGlobalSearch = async () => {
  if (!searchQuery.value || !searchQuery.value.trim()) return
  const keyword = searchQuery.value.trim()

  searchLoading.value = true
  try {
    // 动态导入避免循环依赖
    const [productsRes, ordersRes, usersRes] = await Promise.allSettled([
      import('@/api/admin').then(m => m.getProductList({ page: 1, size: 5, keyword })),
      import('@/api/admin').then(m => m.getOrderList({ page: 1, size: 5, keyword })),
      import('@/api/admin').then(m => m.getUserList({ page: 1, size: 5, keyword }))
    ])

    const results = []
    if (productsRes.status === 'fulfilled') {
      const data = productsRes.value.data?.data || productsRes.value.data || {}
      ;(data.records || []).forEach(item => { item._type = 'product'; results.push(item) })
    }
    if (ordersRes.status === 'fulfilled') {
      const data = ordersRes.value.data?.data || ordersRes.value.data || {}
      ;(data.records || []).forEach(item => { item._type = 'order'; results.push(item) })
    }
    if (usersRes.status === 'fulfilled') {
      const data = usersRes.value.data?.data || usersRes.value.data || {}
      ;(data.records || []).forEach(item => { item._type = 'user'; results.push(item) })
    }

    searchResults.value = results
    showSearchDropdown.value = true
  } catch (e) {
    console.error('搜索失败:', e)
    searchResults.value = []
  } finally {
    searchLoading.value = false
  }
}

/** 按类型分组搜索结果 */
const groupedResults = computed(() => {
  const groups = {}
  for (const item of searchResults.value) {
    const type = item._type
    if (!groups[type]) groups[type] = { items: [], label: '' }
    groups[type].items.push(item)
  }
  if (groups.product) groups.product.label = '商品'
  if (groups.order) groups.order.label = '订单'
  if (groups.user) groups.user.label = '用户'
  return groups
})

const getSearchIcon = (type) => ({ product: '📦', order: '🧾', user: '👤' }[type] || '📄')

const getSearchSub = (item, type) => {
  switch (type) {
    case 'product': return `¥${item.price} | ${item.categoryName || ''}`
    case 'order': return `状态: ${['待付款','已付款','已发货','已完成'][item.status] || ''} | ¥${item.totalAmount}`
    case 'user': return `${item.phone || ''}`
    default: return ''
  }
}

/** 导航到搜索结果详情页 */
const navigateToResult = (item, type) => {
  closeSearch()
  switch (type) {
    case 'product': router.push(`/admin/products?id=${item.id}`); break
    case 'order': router.push(`/admin/orders?orderNo=${item.orderNo}`); break
    case 'user': router.push(`/admin/users?id=${item.id}`); break
  }
}

const goToFullSearch = () => {
  closeSearch()
  const types = Object.keys(groupedResults.value)
  if (types.length > 0) {
    navigateToResult({ orderNo: searchQuery.value }, types[0] === 'order' ? 'order' : types[0])
  }
}

const closeSearch = () => {
  showSearchDropdown.value = false
}

/** 自定义指令：点击外部关闭 */
const vClickOutside = {
  mounted(el, binding) {
    el.clickOutsideEvent = (event) => {
      if (!(el === event.target || el.contains(event.target))) {
        binding.value(event)
      }
    }
    document.addEventListener('click', el.clickOutsideEvent)
  },
  unmounted(el) {
    document.removeEventListener('click', el.clickOutsideEvent)
  }
}

// ========== WebSocket 通知 ==========
const unreadCount = ref(0)
let ws = null
let reconnectTimer = null
const notificationDrawer = ref(false)
const notifications = ref([])

/**
 * 播放通知提示音（Web Audio API 生成三连音）
 * 播放失败不影响主流程
 */
const playNotificationSound = () => {
  try {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)()
    const oscillator = audioContext.createOscillator()
    const gainNode = audioContext.createGain()
    oscillator.connect(gainNode)
    gainNode.connect(audioContext.destination)
    oscillator.frequency.setValueAtTime(800, audioContext.currentTime)
    oscillator.frequency.setValueAtTime(600, audioContext.currentTime + 0.1)
    oscillator.frequency.setValueAtTime(800, audioContext.currentTime + 0.2)
    gainNode.gain.setValueAtTime(0.3, audioContext.currentTime)
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5)
    oscillator.start(audioContext.currentTime)
    oscillator.stop(audioContext.currentTime + 0.5)
  } catch (e) {
    console.warn('播放提示音失败:', e)
  }
}

/** 全屏切换 */
const toggleFullScreen = () => {
  if (!document.fullscreenElement) {
    document.documentElement.requestFullscreen()
  } else {
    document.exitFullscreen()
  }
}

/** 打开通知抽屉并加载数据 */
const showNotifications = async () => {
  notificationDrawer.value = true
  await loadNotifications()
}

/** 加载通知列表 */
const loadNotifications = async () => {
  try {
    const adminId = adminStore.adminId
    const res = await getNotificationList({ receiverId: adminId, page: 1, size: 50 })
    const data = res.data || res
    notifications.value = data.records || (Array.isArray(data) ? data : [])
  } catch (e) {
    console.error('加载通知失败:', e)
    notifications.value = []
  }
}

/** 标记单条已读 */
const markRead = async (item) => {
  if (item.readStatus === 0) {
    try {
      await markAsRead(item.id)
      item.readStatus = 1
      unreadCount.value = Math.max(0, unreadCount.value - 1)
    } catch (e) {
      console.error('标记已读失败:', e)
    }
  }
}

/** 全部标记已读 */
const markAllRead = async () => {
  try {
    await markAllAsRead(adminStore.adminId)
    notifications.value.forEach(n => n.readStatus = 1)
    unreadCount.value = 0
    ElMessage.success('已全部标记为已读')
  } catch (e) {
    console.error('全部已读失败:', e)
  }
}

/** 删除通知（同步更新未读数） */
const removeNotification = async (id) => {
  try {
    await deleteNotification(id)
    const idx = notifications.value.findIndex(n => n.id === id)
    if (idx !== -1) {
      if (notifications.value[idx].readStatus === 0) {
        unreadCount.value = Math.max(0, unreadCount.value - 1)
      }
      notifications.value.splice(idx, 1)
    }
  } catch (e) {
    console.error('删除通知失败:', e)
  }
}

/** 格式化相对时间（刚刚/X分钟前/X小时前/X天前） */
const formatTime = (time) => {
  if (!time) return ''
  const d = new Date(time)
  const now = new Date()
  const diff = now - d
  if (diff < 60000) return '刚刚'
  if (diff < 3600000) return Math.floor(diff / 60000) + '分钟前'
  if (diff < 86400000) return Math.floor(diff / 3600000) + '小时前'
  if (diff < 604800000) return Math.floor(diff / 86400000) + '天前'
  return d.toLocaleDateString()
}

/** 处理用户下拉菜单命令 */
const handleCommand = (command) => {
  if (command === 'logout') {
    disconnectWebSocket()
    adminStore.logout()
    ElMessage.success('已退出登录')
    router.push('/admin/login')
  } else if (command === 'settings') {
    router.push('/admin/settings')
  }
}

/**
 * 建立 WebSocket 连接
 * 用于接收新订单、退款申请等实时通知推送
 */
const connectWebSocket = () => {
  const adminId = adminStore.adminId
  if (!adminId) return

  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  const host = window.location.host
  const url = `${protocol}//${host}/ws/notifications?adminId=${adminId}`

  ws = new WebSocket(url)

  ws.onopen = () => {
    console.log('WebSocket 已连接')
    ws.send('getUnreadCount')
  }

  ws.onmessage = (event) => {
    try {
      const data = JSON.parse(event.data)
      if (data.type === 'unreadCount') {
        unreadCount.value = data.count || 0
      } else if (data.type === 'newNotification') {
        unreadCount.value++
        playNotificationSound()
        const notification = data.notification || {}
        ElMessage({
          type: 'warning',
          message: notification.title || '您有新的通知',
          description: notification.content || '',
          duration: 5000,
          showClose: true
        })
      }
    } catch (e) {
      console.error('WebSocket message parse error:', e)
    }
  }

  ws.onerror = (error) => {
    console.error('WebSocket error:', error)
  }

  // 断开后 5 秒自动重连
  ws.onclose = () => {
    console.log('WebSocket 已断开，5秒后重连...')
    reconnectTimer = setTimeout(() => connectWebSocket(), 5000)
  }
}

/** 断开 WebSocket 连接，清除重连定时器 */
const disconnectWebSocket = () => {
  if (reconnectTimer) {
    clearTimeout(reconnectTimer)
    reconnectTimer = null
  }
  if (ws) {
    ws.onclose = null
    ws.close()
    ws = null
  }
}

onMounted(() => {
  connectWebSocket()
})

onUnmounted(() => {
  disconnectWebSocket()
})
</script>

<style scoped>
.layout-container {
  min-height: 100vh;
  background: #f5f7fa;
}

/* 侧边栏样式 */
.sidebar {
  background: linear-gradient(180deg, #1a1f36 0%, #0d1117 100%);
  color: #fff;
  display: flex;
  flex-direction: column;
  box-shadow: 4px 0 20px rgba(0, 0, 0, 0.15);
  position: relative;
  z-index: 100;
  overflow-y: auto;
  overflow-x: hidden;
}

.sidebar-header {
  padding: 20px 16px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
}

.logo-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  width: 36px;
  height: 36px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  color: #fff;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
  flex-shrink: 0;
}

.logo-text {
  font-size: 18px;
  font-weight: 700;
  color: #fff;
  letter-spacing: 1px;
  white-space: nowrap;
}

/* 菜单样式 */
.sidebar-menu {
  background: transparent !important;
  border-right: none;
  flex: 1;
  padding: 12px 8px;
}

.sidebar-menu:not(.el-menu--collapse) {
  width: 100%;
}

.sidebar-menu .el-menu-item,
.sidebar-menu .el-sub-menu__title {
  height: 48px;
  line-height: 48px;
  margin: 4px 0;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.sidebar-menu .el-menu-item:hover,
.sidebar-menu .el-sub-menu__title:hover {
  background: rgba(255, 255, 255, 0.08) !important;
}

.sidebar-menu .el-menu-item.is-active {
  background: linear-gradient(90deg, rgba(102, 126, 234, 0.2) 0%, rgba(118, 75, 162, 0.1) 100%) !important;
  border-left: 3px solid #667eea;
}

.sidebar-menu .el-menu-item.is-active::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 24px;
  background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
  border-radius: 0 4px 4px 0;
}

.sidebar-menu .el-icon {
  font-size: 18px;
}

/* 子菜单 */
.el-sub-menu .el-menu-item {
  height: 42px;
  line-height: 42px;
  padding-left: 52px !important;
  font-size: 13px;
}

/* 主内容区 */
.main-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

/* 顶部导航 */
.main-header {
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  height: 64px;
  position: sticky;
  top: 0;
  z-index: 99;
}

.header-left {
  display: flex;
  align-items: center;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-search .search-input {
  width: 240px;
  transition: width 0.3s ease;
}

.header-search .search-input:focus-within {
  width: 320px;
}

/* 搜索下拉面板 */
.header-search {
  position: relative;
}

.search-dropdown {
  position: absolute;
  top: calc(100% + 8px);
  left: 0;
  right: -40px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  border: 1px solid #e4e7ed;
  z-index: 1000;
  overflow: hidden;
}

.search-loading,
.search-empty,
.search-footer {
  padding: 16px 20px;
  text-align: center;
  color: #909399;
  font-size: 14px;
}

.search-footer {
  color: #667eea;
  cursor: pointer;
  font-weight: 500;
  border-top: 1px solid #f0f0f0;
  transition: background 0.2s;
}

.search-footer:hover {
  background: #f5f7fa;
}

.search-section {
  padding: 8px 0;
  border-bottom: 1px solid #f5f5f5;
}

.search-group-title {
  padding: 6px 20px;
  font-size: 12px;
  font-weight: 600;
  color: #909399;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.search-result-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 20px;
  cursor: pointer;
  transition: background 0.15s ease;
}

.search-result-item:hover {
  background: #f5f7ff;
}

.result-icon {
  font-size: 18px;
  flex-shrink: 0;
}

.result-content {
  flex: 1;
  min-width: 0;
}

.result-title {
  display: block;
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.result-sub {
  display: block;
  font-size: 12px;
  color: #909399;
  margin-top: 2px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.result-arrow {
  color: #c0c4cc;
  font-size: 14px;
  flex-shrink: 0;
  opacity: 0;
  transition: all 0.2s;
}

.search-result-item:hover .result-arrow {
  opacity: 1;
  color: #667eea;
  transform: translateX(2px);
}

.header-badge {
  cursor: pointer;
}

.header-icon {
  font-size: 20px;
  color: #606266;
  cursor: pointer;
  padding: 8px;
  border-radius: 6px;
  transition: all 0.3s ease;
}

.header-icon:hover {
  background: #f5f7fa;
  color: #409eff;
}

.notification-icon {
  font-size: 24px;
  padding: 10px;
}

/* 用户信息 */
.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.user-info:hover {
  background: #f5f7fa;
}

.user-avatar {
  width: 36px;
  height: 36px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
}

.user-details {
  display: flex;
  flex-direction: column;
}

.user-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  line-height: 1.3;
}

.user-role {
  font-size: 12px;
  color: #909399;
  line-height: 1.3;
}

.user-arrow {
  color: #909399;
  font-size: 12px;
}

/* 主内容 */
.main-content {
  padding: 24px;
  background: #f5f7fa;
  min-height: calc(100vh - 64px - 48px);
}

/* 底部版权 */
.main-footer {
  background: #fff;
  border-top: 1px solid #ebeef5;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 48px;
  color: #909399;
  font-size: 13px;
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 响应式 */
@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    left: 0;
    height: 100vh;
    z-index: 1000;
  }

  .header-search {
    display: none;
  }
}

/* 通知抽屉 */
.notification-drawer {
  padding: 0;
}

.drawer-header {
  display: flex;
  justify-content: flex-end;
  padding: 0 0 16px 0;
  border-bottom: 1px solid #f0f0f0;
  margin-bottom: 12px;
}

.notification-list {
  max-height: calc(100vh - 200px);
  overflow-y: auto;
}

.notification-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 14px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s;
}

.notification-item:hover {
  background: #f5f7fa;
}

.notification-item.unread {
  background: #ecf5ff;
}

.notification-item.unread:hover {
  background: #d9ecff;
}

.notification-type-icon {
  font-size: 24px;
  flex-shrink: 0;
  margin-top: 2px;
}

.notification-content {
  flex: 1;
  min-width: 0;
}

.notification-title {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
}

.notification-desc {
  font-size: 13px;
  color: #606266;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.notification-time {
  font-size: 12px;
  color: #909399;
  margin-top: 6px;
}

.no-notifications {
  text-align: center;
  padding: 60px 0;
  color: #909399;
}

.no-notifications span {
  font-size: 48px;
  display: block;
  margin-bottom: 16px;
}

.no-notifications p {
  font-size: 14px;
}
</style>
