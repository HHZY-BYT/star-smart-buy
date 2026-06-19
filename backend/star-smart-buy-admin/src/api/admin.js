import request from './request'

/** 管理员登录 */
export function adminLogin(data) {
  return request.post('/admin/login', data)
}

/** ========== 商品管理 ========== */
/** 商品列表 */
export function getProductList(params) {
  return request.get('/admin/products', { params })
}

/** 新增商品 */
export function saveProduct(data) {
  return request.post('/admin/products', data)
}

/** 更新商品 */
export function updateProduct(data) {
  return request.put('/admin/products', data)
}

/** 删除商品 */
export function deleteProduct(id) {
  return request.delete(`/admin/products/${id}`)
}

/** 获取商品详情（含规格） */
export function getProductDetail(id) {
  return request.get(`/products/${id}`)
}

/** ========== 订单管理 ========== */
/** 订单列表 */
export function getOrderList(params) {
  return request.get('/admin/orders', { params })
}

/** 订单详情（含商品明细） */
export function getOrderDetail(id) {
  return request.get(`/orders/${id}`)
}

/** 订单状态统计 */
export function getOrderStats() {
  return request.get('/admin/stats/order-status')
}

/** 发货 */
export function shipOrder(id) {
  return request.put(`/admin/orders/${id}/ship`)
}

/** 删除订单 */
export function deleteOrder(id) {
  return request.delete(`/admin/orders/${id}`)
}

/** ========== 退款/售后管理 ========== */
/** 退款列表 */
export function getRefundList(params) {
  return request.get('/admin/refunds', { params })
}

/** 退款详情 */
export function getRefundDetail(id) {
  return request.get(`/admin/refunds/${id}`)
}

/** 处理退款 */
export function processRefund(id, status, reason) {
  return request.put(`/admin/refunds/${id}/process`, { status, reason })
}

/** 拒绝退款 */
export function rejectRefund(id, reason) {
  return request.put(`/admin/refunds/${id}/reject`, { reason })
}

/** 退款统计 */
export function getRefundStats() {
  return request.get('/admin/refunds/stats')
}

/** ========== 用户管理 ========== */
/** 用户列表 */
export function getUserList(params) {
  return request.get('/admin/users', { params })
}

/** 用户详情 */
export function getUserDetail(id) {
  return request.get(`/admin/users/${id}`)
}

/** 用户统计 */
export function getUserStats() {
  return request.get('/admin/users/stats')
}

/** 禁用/启用用户 */
export function toggleUserStatus(id, status) {
  return request.put(`/admin/users/${id}/status`, { status })
}

/** 删除用户 */
export function deleteUser(id) {
  return request.delete(`/admin/users/${id}`)
}

/** ========== 分类管理 ========== */
/** 分类列表 */
export function getCategoryList(params) {
  return request.get('/admin/categories', { params })
}

/** 新增分类 */
export function saveCategory(data) {
  return request.post('/admin/categories', data)
}

/** 更新分类 */
export function updateCategory(data) {
  return request.put('/admin/categories', data)
}

/** 删除分类 */
export function deleteCategory(id) {
  return request.delete(`/admin/categories/${id}`)
}

/** ========== 数据统计 ========== */
/** 销售统计 */
export function getSalesStats(params) {
  return request.get('/admin/stats/sales', { params })
}

/** 概览统计 */
export function getOverviewStats() {
  return request.get('/admin/stats/overview')
}

/** ========== 系统设置 ========== */
/** 获取 AI 配置 */
export function getAiConfig() {
  return request.get('/admin/ai/config')
}

/** 保存 AI 配置 */
export function saveAiConfig(data) {
  return request.put('/admin/ai/config', data)
}

/** 测试 AI 连接 */
export function testAiConfig(data) {
  return request.post('/admin/ai/config/test', data)
}

/** ========== 轮播图管理 ========== */
/** 获取轮播图列表 */
export function getBannerList() {
  return request.get('/admin/banner')
}

/** 新增轮播图 */
export function addBanner(data) {
  return request.post('/admin/banner', data)
}

/** 更新轮播图 */
export function updateBanner(data) {
  return request.put('/admin/banner', data)
}

/** 删除轮播图 */
export function deleteBanner(id) {
  return request.delete(`/admin/banner/${id}`)
}

/** ========== 公告管理 ========== */
/** 获取公告列表 */
export function getNoticeList() {
  return request.get('/admin/notice')
}

/** 新增公告 */
export function addNotice(data) {
  return request.post('/admin/notice', data)
}

/** 更新公告 */
export function updateNotice(data) {
  return request.put('/admin/notice', data)
}

/** 删除公告 */
export function deleteNotice(id) {
  return request.delete(`/admin/notice/${id}`)
}

/** ========== 通知管理 ========== */
/** 上传图片 */
export function uploadImage(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/upload/image', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/** ========== 通知管理 ========== */
/** 获取未读通知数量 */
export function getUnreadCount(receiverId) {
  return request.get('/admin/notifications/unread-count', { params: { receiverId } })
}

/** 获取通知列表 */
export function getNotificationList(params) {
  return request.get('/admin/notifications', { params })
}

/** 标记为已读 */
export function markAsRead(id) {
  return request.put(`/admin/notifications/${id}/read`)
}

/** 全部标记为已读 */
export function markAllAsRead(receiverId) {
  return request.put('/admin/notifications/read-all', null, { params: { receiverId } })
}

/** 删除通知 */
export function deleteNotification(id) {
  return request.delete(`/admin/notifications/${id}`)
}

/** ========== 评价管理 ========== */
/** 评价列表 */
export function getReviewList(params) {
  return request.get('/admin/reviews', { params })
}

/** 删除评价 */
export function deleteReview(id) {
  return request.delete(`/admin/reviews/${id}`)
}

/** 回复评价 */
export function replyReview(id, reply) {
  return request.put(`/admin/reviews/${id}/reply`, { reply })
}

/** ========== 商品上下架 ========== */
/** 商品上架 */
export function onProduct(id) {
  return request.put(`/admin/products/${id}/on`)
}

/** 商品下架 */
export function offProduct(id) {
  return request.put(`/admin/products/${id}/off`)
}

/** ========== 日志管理 ========== */
/** 日志列表 */
export function getLogList(params) {
  return request.get('/admin/logs', { params })
}

/** 日志详情 */
export function getLogDetail(id) {
  return request.get(`/admin/logs/${id}`)
}

/** 删除日志 */
export function deleteLog(id) {
  return request.delete(`/admin/logs/${id}`)
}

/** 批量删除日志 */
export function batchDeleteLog(ids) {
  return request.delete('/admin/logs/batch', { data: ids })
}

/** 清空日志 */
export function cleanLog(keepDays = 30) {
  return request.delete('/admin/logs/clean', { params: { keepDays } })
}

/** 日志统计 */
export function getLogStats() {
  return request.get('/admin/logs/stats')
}

/** ========== 账号管理 ========== */
/** 修改密码 */
export function updateAdminPassword(data) {
  return request.put('/admin/password', data)
}
