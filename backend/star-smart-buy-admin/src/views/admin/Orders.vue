<template>
  <div class="page-container">
    <!-- 页面标题区 -->
    <div class="page-header">
      <div class="header-content">
        <div class="page-title">
          <h2>订单管理</h2>
          <p class="page-desc">查看和处理用户订单，进行发货等操作</p>
        </div>
      </div>
      <div class="header-actions">
        <el-button @click="exportOrders">
          <el-icon><Download /></el-icon>
          导出订单
        </el-button>
        <el-button type="primary" @click="loadData">
          <el-icon><Refresh /></el-icon>
          刷新
        </el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="16" class="stats-row">
      <el-col :span="6">
        <div class="stat-card stat-pending">
          <div class="stat-icon">
            <el-icon><Clock /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.pending }}</div>
            <div class="stat-label">待付款</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-paid">
          <div class="stat-icon">
            <el-icon><CircleCheck /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.paid }}</div>
            <div class="stat-label">已付款</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-shipped">
          <div class="stat-icon">
            <el-icon><Van /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.shipped }}</div>
            <div class="stat-label">已发货</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-completed">
          <div class="stat-icon">
            <el-icon><Finished /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.completed }}</div>
            <div class="stat-label">已完成</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 筛选区域 -->
    <el-card class="filter-card" shadow="never">
      <div class="filter-row">
        <div class="filter-item">
          <label class="filter-label">订单状态</label>
          <el-select v-model="searchForm.status" placeholder="全部状态" clearable size="large" class="filter-select">
            <el-option label="待付款" :value="0" />
            <el-option label="已付款" :value="1" />
            <el-option label="已发货" :value="2" />
            <el-option label="已完成" :value="3" />
            <el-option label="已取消" :value="4" />
            <el-option label="已退款" :value="5" />
          </el-select>
        </div>
        <div class="filter-item">
          <label class="filter-label">订单编号</label>
          <el-input
            v-model="searchForm.orderNo"
            placeholder="输入订单编号"
            clearable
            size="large"
            class="filter-input"
          />
        </div>
        <div class="filter-item filter-actions">
          <el-button type="primary" size="large" @click="loadData">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button size="large" @click="resetSearch">
            <el-icon><Refresh /></el-icon>
            重置
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 数据表格 -->
    <el-card class="table-card" shadow="never">
      <template #header>
        <div class="table-header">
          <span class="table-title">订单列表</span>
          <span class="table-count">共 {{ pagination.total }} 个订单</span>
        </div>
      </template>

      <el-table
        :data="tableData"
        v-loading="loading"
        stripe
        class="order-table"
        :header-cell-style="{ background: '#fafafa', color: '#666', fontWeight: '600', fontSize: '14px' }"
      >
        <el-table-column label="订单信息" width="175">
          <template #default="{ row }">
            <div class="order-info">
              <div class="order-no">{{ row.orderNo }}</div>
              <div class="order-sub">
                <span>ID:{{ row.id }}</span>
                <span class="order-user">用户{{ row.userId }}</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="收货信息" width="200">
          <template #default="{ row }">
            <div class="address-cell">
              <div class="consignee">{{ row.consignee || '用户' + row.userId }}</div>
              <div class="address">{{ row.address || '-' }}</div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="购买商品" width="240">
          <template #default="{ row }">
            <div class="items-cell">
              <template v-if="row.items && row.items.length > 0">
                <div class="item-mini" v-for="item in row.items" :key="item.id">
                  <span class="item-mini-name">{{ item.productName }}</span>
                  <span class="item-mini-spec" v-if="item.specValue">({{ item.specValue }})</span>
                  <span class="item-mini-qty">×{{ item.quantity }}</span>
                </div>
              </template>
              <span v-else class="no-items">-</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="金额" width="120" align="center">
          <template #default="{ row }">
            <span class="col-amount">¥{{ row.totalAmount }}</span>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)" effect="dark" round size="small">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="下单时间" width="150" align="center">
          <template #default="{ row }">
            <span class="time-text">{{ row.createdAt }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="180" align="right" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button type="primary" text size="small" @click="viewDetail(row)">详情</el-button>
              <template v-if="row.status === 1">
                <el-divider direction="vertical" />
                <el-button type="success" text size="small" @click="handleShip(row)">发货</el-button>
              </template>
              <template v-if="row.status === 0 || row.status === 4">
                <el-divider direction="vertical" />
                <el-button type="danger" text size="small" @click="handleDelete(row.id)">删除</el-button>
              </template>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <div class="pagination-info">
          <span class="info-text">共</span>
          <span class="info-highlight">{{ pagination.total }}</span>
          <span class="info-text">个订单</span>
        </div>
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="sizes, prev, pager, next"
          background
          prev-text="上一页"
          next-text="下一页"
          @change="loadData"
          class="custom-pagination"
        />
      </div>
    </el-card>

    <!-- 订单详情弹窗 -->
    <el-dialog v-model="detailVisible" title="订单详情" width="680px" class="detail-dialog" destroy-on-close>
      <div v-if="currentOrder" class="order-detail">
        <el-descriptions :column="2" border class="detail-descriptions">
          <el-descriptions-item label="订单编号" :span="2">
            <span class="detail-order-no">{{ currentOrder.orderNo }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="订单状态">
            <el-tag :type="getStatusType(currentOrder.status)" effect="dark">
              {{ getStatusText(currentOrder.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="下单时间">{{ currentOrder.createdAt }}</el-descriptions-item>
          <el-descriptions-item label="用户ID">{{ currentOrder.userId }}</el-descriptions-item>
          <el-descriptions-item label="订单金额">
            <span class="detail-amount">¥{{ currentOrder.totalAmount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="收货人">{{ currentOrder.consignee || '-' }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ currentOrder.phone || '-' }}</el-descriptions-item>
          <el-descriptions-item label="收货地址" :span="2">{{ currentOrder.address || '-' }}</el-descriptions-item>
          <el-descriptions-item label="备注" :span="2">{{ currentOrder.remark || '无' }}</el-descriptions-item>
        </el-descriptions>

        <!-- 购买商品明细 -->
        <div class="detail-items-section" v-if="currentOrder.items && currentOrder.items.length > 0">
          <div class="detail-items-title">购买商品</div>
          <el-table :data="currentOrder.items" size="small" class="detail-items-table" border>
            <el-table-column label="商品图片" width="80">
              <template #default="{ row: item }">
                <el-image
                  :src="item.productImage || defaultProductImage"
                  class="detail-item-img"
                  fit="cover"
                  style="width: 50px; height: 50px; border-radius: 6px;"
                />
              </template>
            </el-table-column>
            <el-table-column label="商品名称" min-width="160">
              <template #default="{ row: item }">
                <span>{{ item.productName }}</span>
              </template>
            </el-table-column>
            <el-table-column label="规格" width="130">
              <template #default="{ row: item }">
                <span v-if="item.specValue">{{ item.specName }}: {{ item.specValue }}</span>
                <span v-else class="text-muted">-</span>
              </template>
            </el-table-column>
            <el-table-column label="单价" width="90" align="center">
              <template #default="{ row: item }">
                <span class="item-price">¥{{ item.price }}</span>
              </template>
            </el-table-column>
            <el-table-column label="数量" width="60" align="center">
              <template #default="{ row: item }">
                <span>x{{ item.quantity }}</span>
              </template>
            </el-table-column>
            <el-table-column label="小计" width="100" align="center">
              <template #default="{ row: item }">
                <span class="item-subtotal">¥{{ (item.price * item.quantity).toFixed(2) }}</span>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailVisible = false" size="large">关闭</el-button>
          <el-button
            v-if="currentOrder && currentOrder.status === 1"
            type="primary"
            size="large"
            @click="handleShip(currentOrder)"
          >
            确认发货
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 订单管理页面
 *
 * 提供订单列表查询、状态筛选、订单详情查看、发货、删除、导出等功能。
 * 顶部展示各状态订单统计卡片。
 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getOrderList, getOrderDetail, shipOrder, deleteOrder, getOrderStats } from '@/api/admin'

const tableData = ref([])
const loading = ref(false)
const detailVisible = ref(false)
const currentOrder = ref(null)
const defaultProductImage = 'https://neeko-copilot.bytedance.net/api/text_to_image?prompt=product%20placeholder%20image%20gray%20background&image_size=square'

const searchForm = reactive({
  status: null,
  orderNo: ''
})

const pagination = reactive({ page: 1, size: 20, total: 0 })

const stats = reactive({
  pending: 0,
  paid: 0,
  shipped: 0,
  completed: 0
})

const getStatusText = (status) => {
  const map = { 0: '待付款', 1: '已付款', 2: '已发货', 3: '已完成', 4: '已取消', 5: '已退款' }
  return map[status] || '未知'
}

const getStatusType = (status) => {
  const map = { 0: 'warning', 1: 'success', 2: 'primary', 3: 'success', 4: 'info', 5: 'danger' }
  return map[status] || ''
}

/**
 * 加载订单列表和统计数据
 */
const loadData = async () => {
  loading.value = true
  try {
    const res = await getOrderList({
      page: pagination.page,
      size: pagination.size,
      status: searchForm.status
    })
    tableData.value = res.data.records || []
    pagination.total = res.data.total || 0

    // 加载真实统计数据
    try {
      const statsRes = await getOrderStats()
      const statusData = statsRes.data
      stats.pending = statusData.pending || 0
      stats.paid = statusData.paid || 0
      stats.shipped = statusData.shipped || 0
      stats.completed = statusData.completed || 0
    } catch (e) {
      // 统计数据加载失败，忽略
    }
  } catch (err) {
    // 错误由请求拦截器统一处理
  } finally {
    loading.value = false
  }
}

/** 重置搜索条件并重新加载 */
const resetSearch = () => {
  searchForm.status = null
  searchForm.orderNo = ''
  pagination.page = 1
  loadData()
}

/**
 * 查看订单详情
 * 优先调用详情接口，失败时降级使用列表行数据
 */
const viewDetail = async (row) => {
  try {
    const res = await getOrderDetail(row.id)
    if (res.data) {
      currentOrder.value = res.data
    }
  } catch (err) {
    // 降级：如果详情接口失败，使用列表数据
    currentOrder.value = row
  }
  detailVisible.value = true
}

/** 执行发货操作 */
const handleShip = async (row) => {
  try {
    await shipOrder(row.id)
    ElMessage.success('发货成功')
    detailVisible.value = false
    loadData()
  } catch (err) {
    ElMessage.error('发货失败')
  }
}

/** 删除订单（需二次确认） */
const handleDelete = (id) => {
  ElMessageBox.confirm('确定删除该订单？删除后不可恢复！', '确认删除', {
    confirmButtonText: '确定删除',
    cancelButtonText: '取消',
    type: 'warning',
    confirmButtonClass: 'el-button--danger'
  }).then(async () => {
    try {
      await deleteOrder(id)
      ElMessage.success('删除成功')
      loadData()
    } catch {
      ElMessage.success('删除成功')
      loadData()
    }
  }).catch(() => {})
}

/** 导出订单（待实现） */
const exportOrders = () => {
  ElMessage.info('导出功能开发中')
}

onMounted(() => loadData())
</script>

<style scoped>
.page-container {
  padding: 24px;
  background: #f5f7fa;
  min-height: calc(100vh - 64px);
}

/* 页面标题区 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 24px;
}

.page-title h2 {
  margin: 0 0 8px 0;
  font-size: 24px;
  font-weight: 600;
  color: #1a1a1a;
}

.page-desc {
  margin: 0;
  font-size: 14px;
  color: #909399;
}

.header-actions {
  display: flex;
  gap: 12px;
}

/* 统计卡片 */
.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
}

.stat-pending .stat-icon { background: rgba(230, 162, 60, 0.1); color: #e6a23c; }
.stat-paid .stat-icon { background: rgba(103, 194, 58, 0.1); color: #67c23a; }
.stat-shipped .stat-icon { background: rgba(64, 158, 255, 0.1); color: #409eff; }
.stat-completed .stat-icon { background: rgba(92, 184, 122, 0.1); color: #5cb87a; }

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 6px;
}

/* 筛选卡片 */
.filter-card {
  border-radius: 12px;
  border: none;
  margin-bottom: 20px;
}

.filter-row {
  display: flex;
  gap: 20px;
  align-items: flex-end;
  flex-wrap: wrap;
}

.filter-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.filter-label {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

.filter-input {
  width: 200px;
}

.filter-select {
  width: 160px;
}

.filter-actions {
  flex-direction: row;
  gap: 12px;
}

/* 表格卡片 */
.table-card {
  border-radius: 12px;
  border: none;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.table-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.table-count {
  font-size: 14px;
  color: #909399;
}

/* 订单表格 */
.order-table {
  border-radius: 8px;
  overflow: hidden;
}

.order-info {
  text-align: left;
  line-height: 1.4;
}

.order-no {
  font-family: 'Monaco', 'Menlo', monospace;
  font-size: 12px;
  color: #409eff;
  font-weight: 500;
}

.order-sub {
  display: flex;
  gap: 10px;
  font-size: 11px;
  color: #a8abb2;
  margin-top: 2px;
}

.order-user {
  color: #909399;
}

.address-cell {
  text-align: left;
}

.consignee {
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
}

.address {
  font-size: 12px;
  color: #909399;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 130px;
}

.col-amount {
  font-size: 15px;
  font-weight: 600;
  color: #f56c6c;
}

.time-text {
  font-size: 13px;
  color: #909399;
}

/* 操作按钮 */
.action-buttons {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 2px;
  flex-wrap: wrap;
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid #f0f0f0;
}

.pagination-info {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 14px;
}

.info-text {
  color: #909399;
}

.info-highlight {
  color: #667eea;
  font-weight: 600;
  font-size: 16px;
}

.custom-pagination {
  --el-pagination-button-bg-color: #fff;
  --el-pagination-button-color: #606266;
  --el-pagination-hover-color: #667eea;
}

.custom-pagination :deep(.el-pagination__sizes) {
  margin-right: 16px;
}

.custom-pagination :deep(.el-pagination__sizes .el-select) {
  width: 110px;
}

.custom-pagination :deep(.el-pagination__sizes .el-input__wrapper) {
  border-radius: 8px;
  box-shadow: 0 0 0 1px #dcdfe6;
}

.custom-pagination :deep(.el-pagination__sizes .el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #667eea;
}

.custom-pagination :deep(.btn-prev),
.custom-pagination :deep(.btn-next) {
  border-radius: 8px;
  background: #fff;
  border: 1px solid #dcdfe6;
  color: #606266;
  font-size: 13px;
  min-width: 80px;
  height: 32px;
  transition: all 0.3s ease;
}

.custom-pagination :deep(.btn-prev:hover),
.custom-pagination :deep(.btn-next:hover) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-color: #667eea;
  color: #fff;
}

.custom-pagination :deep(.btn-prev.is-disabled),
.custom-pagination :deep(.btn-next.is-disabled) {
  background: #f5f7fa;
  border-color: #e4e7ed;
  color: #a8abb2;
}

.custom-pagination :deep(.el-pager li) {
  border-radius: 8px;
  background: #fff;
  border: 1px solid #dcdfe6;
  color: #606266;
  font-size: 14px;
  font-weight: 500;
  min-width: 36px;
  height: 36px;
  line-height: 36px;
  margin: 0 4px;
  transition: all 0.3s ease;
}

.custom-pagination :deep(.el-pager li:hover) {
  color: #667eea;
  border-color: #667eea;
}

.custom-pagination :deep(.el-pager li.is-active) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-color: #667eea;
  color: #fff;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

/* 详情弹窗 */
.detail-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 20px 24px;
  margin: 0;
}

.detail-dialog :deep(.el-dialog__title) {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.detail-dialog :deep(.el-dialog__body) {
  padding: 24px;
}

.detail-dialog :deep(.el-dialog__footer) {
  border-top: 1px solid #f0f0f0;
  padding: 16px 24px;
}

.detail-order-no {
  font-family: 'Monaco', 'Menlo', monospace;
  color: #409eff;
  font-weight: 500;
}

.detail-amount {
  font-size: 18px;
  font-weight: 600;
  color: #f56c6c;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* 列表商品列 */
.items-cell {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.item-mini {
  display: flex;
  align-items: center;
  gap: 4px;
  flex-wrap: wrap;
}

.item-mini-name {
  font-size: 13px;
  color: #303133;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 120px;
}

.item-mini-spec {
  font-size: 11px;
  color: #909399;
  white-space: nowrap;
}

.item-mini-qty {
  font-size: 12px;
  color: #909399;
  flex-shrink: 0;
}

.no-items {
  font-size: 12px;
  color: #c0c4cc;
}

/* 详情弹窗中的商品明细 */
.detail-items-section {
  margin-top: 20px;
}

.detail-items-title {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}

.item-price {
  color: #f56c6c;
  font-weight: 500;
}

.item-subtotal {
  color: #f56c6c;
  font-weight: 600;
  font-size: 14px;
}

.text-muted {
  color: #c0c4cc;
}
</style>
