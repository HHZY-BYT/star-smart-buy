<template>
  <div class="page-container">
    <!-- 页面标题区 -->
    <div class="page-header">
      <div class="header-content">
        <div class="page-title">
          <h2>退款售后</h2>
          <p class="page-desc">处理用户的退款申请和售后请求</p>
        </div>
      </div>
      <div class="header-actions">
        <el-button type="primary" @click="loadData">
          <el-icon><Refresh /></el-icon>
          刷新
        </el-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="16" class="stats-row">
      <el-col :span="6">
        <div class="stat-card stat-total" :class="{ active: searchForm.status === null }" @click="onStatClick(null)">
          <div class="stat-icon">
            <el-icon><Document /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.total }}</div>
            <div class="stat-label">退款总数</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-pending" :class="{ active: searchForm.status === 0 }" @click="onStatClick(0)">
          <div class="stat-icon">
            <el-icon><Clock /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.pending }}</div>
            <div class="stat-label">待处理</div>
          </div>
          <el-badge v-if="stats.pending > 0" :value="stats.pending" class="stat-badge" />
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-approved" :class="{ active: searchForm.status === 1 }" @click="onStatClick(1)">
          <div class="stat-icon">
            <el-icon><CircleCheck /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.approved }}</div>
            <div class="stat-label">已同意</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-rejected" :class="{ active: searchForm.status === 2 }" @click="onStatClick(2)">
          <div class="stat-icon">
            <el-icon><CircleClose /></el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ stats.rejected }}</div>
            <div class="stat-label">已拒绝</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 筛选区域 -->
    <el-card class="filter-card" shadow="never">
      <div class="filter-row">
        <div class="filter-item">
          <label class="filter-label">处理状态</label>
          <el-select v-model="searchForm.status" placeholder="全部" clearable size="large" class="filter-select">
            <el-option label="待处理" :value="0" />
            <el-option label="已同意" :value="1" />
            <el-option label="已拒绝" :value="2" />
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
          <span class="table-title">退款申请列表</span>
          <span class="table-count">共 {{ pagination.total }} 条记录</span>
        </div>
      </template>

      <el-table
        :data="tableData"
        v-loading="loading"
        stripe
        class="refund-table"
        :header-cell-style="{ background: '#fafafa', color: '#666', fontWeight: '600', fontSize: '14px' }"
      >
        <el-table-column label="订单信息" min-width="200">
          <template #default="{ row }">
            <div class="order-info">
              <div class="order-no">{{ row.orderNo }}</div>
              <div class="order-id">ID: {{ row.id }}</div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="用户" width="100" align="center">
          <template #default="{ row }">
            <div class="user-cell">
              <el-icon><User /></el-icon>
              <span>{{ row.userId }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="退款金额" width="130" align="center">
          <template #default="{ row }">
            <div class="amount-wrapper">
              <span class="amount-symbol">¥</span>
              <span class="amount-value">{{ row.amount }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="退款原因" min-width="160">
          <template #default="{ row }">
            <div class="reason-cell">
              <span class="reason-text">{{ row.reason || '其他原因' }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="160" align="center">
          <template #default="{ row }">
            <div class="status-cell">
              <el-tag :type="getStatusType(row.status)" effect="dark" round size="large">
                {{ getStatusText(row.status) }}
              </el-tag>
              <div v-if="row.status !== 0 && row.processTime" class="status-detail">
                <span class="process-time">{{ row.processTime }}</span>
              </div>
              <div v-if="row.status !== 0 && row.processNote" class="status-detail">
                <span class="process-note">{{ row.processNote }}</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="申请时间" width="170" align="center">
          <template #default="{ row }">
            <span class="time-text">{{ row.createdAt }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="200" align="center" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button type="primary" text size="small" @click="viewDetail(row)">
                详情
              </el-button>
              <template v-if="row.status === 0">
                <el-divider direction="vertical" />
                <el-button type="success" text size="small" @click="handleApprove(row)">
                  同意
                </el-button>
                <el-divider direction="vertical" />
                <el-button type="danger" text size="small" @click="handleReject(row)">
                  拒绝
                </el-button>
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
          <span class="info-text">条记录</span>
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

    <!-- 退款详情弹窗 -->
    <el-dialog v-model="detailVisible" title="退款详情" width="600px" class="detail-dialog" destroy-on-close>
      <div v-if="currentRefund" class="refund-detail">
        <el-descriptions :column="2" border class="detail-descriptions">
          <el-descriptions-item label="退款ID">{{ currentRefund.id }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="getStatusType(currentRefund.status)" effect="dark">
              {{ getStatusText(currentRefund.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="订单编号" :span="2">
            <span class="detail-order-no">{{ currentRefund.orderNo }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="用户ID">{{ currentRefund.userId }}</el-descriptions-item>
          <el-descriptions-item label="退款金额">
            <span class="detail-amount">¥{{ currentRefund.amount }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="退款原因" :span="2">{{ currentRefund.reason || '其他原因' }}</el-descriptions-item>
          <el-descriptions-item label="退款说明" :span="2">{{ currentRefund.description || '无' }}</el-descriptions-item>
          <el-descriptions-item label="申请时间">{{ currentRefund.createdAt }}</el-descriptions-item>
          <el-descriptions-item label="处理时间">{{ currentRefund.processTime || '待处理' }}</el-descriptions-item>
          <el-descriptions-item label="处理备注" :span="2">{{ currentRefund.processNote || '无' }}</el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <div class="dialog-footer" v-if="currentRefund && currentRefund.status === 0">
          <el-button @click="detailVisible = false" size="large">关闭</el-button>
          <el-button type="danger" size="large" @click="handleReject(currentRefund)">
            拒绝退款
          </el-button>
          <el-button type="success" size="large" @click="handleApprove(currentRefund)">
            同意退款
          </el-button>
        </div>
        <div class="dialog-footer" v-else>
          <el-button @click="detailVisible = false" size="large">关闭</el-button>
        </div>
      </template>
    </el-dialog>

    <!-- 拒绝原因弹窗 -->
    <el-dialog v-model="rejectVisible" title="拒绝退款" width="480px" class="reject-dialog" destroy-on-close>
      <el-form :model="rejectForm" label-position="top">
        <el-form-item label="拒绝原因">
          <el-input
            v-model="rejectForm.reason"
            type="textarea"
            :rows="4"
            placeholder="请输入拒绝原因"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rejectVisible = false" size="large">取消</el-button>
        <el-button type="danger" size="large" @click="confirmReject" :loading="submitLoading">
          确认拒绝
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 退款售后管理页面
 *
 * 提供退款申请列表查看、审核（同意/拒绝）、统计筛选等功能。
 * 同意退款后自动更新订单状态并恢复库存。
 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getRefundList, processRefund, rejectRefund, getRefundStats, getRefundDetail } from '@/api/admin'

const tableData = ref([])
const loading = ref(false)
const detailVisible = ref(false)
const rejectVisible = ref(false)
const submitLoading = ref(false)
const currentRefund = ref(null)

const searchForm = reactive({
  status: null,
  orderNo: ''
})

const pagination = reactive({ page: 1, size: 10, total: 0 })

const stats = reactive({
  total: 0,
  pending: 0,
  approved: 0,
  rejected: 0
})

const rejectForm = reactive({
  reason: ''
})

const getStatusText = (status) => {
  const map = { 0: '待处理', 1: '已同意', 2: '已拒绝' }
  return map[status] || '未知'
}

const getStatusType = (status) => {
  const map = { 0: 'warning', 1: 'success', 2: 'danger' }
  return map[status] || ''
}

/** 加载退款列表 */
const loadData = async () => {
  loading.value = true
  try {
    const res = await getRefundList({
      page: pagination.page,
      size: pagination.size,
      status: searchForm.status,
      orderNo: searchForm.orderNo || undefined
    })
    tableData.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (err) {
    // 错误由拦截器统一处理
  } finally {
    loading.value = false
  }
}

/** 加载退款统计数据 */
const loadStats = async () => {
  try {
    const res = await getRefundStats()
    const data = res.data || res
    stats.total = data.total || 0
    stats.pending = data.pending || 0
    stats.approved = data.approved || 0
    stats.rejected = data.rejected || 0
  } catch (err) {
    console.error('加载统计失败:', err)
  }
}

/** 重置搜索 */
const resetSearch = () => {
  searchForm.status = null
  searchForm.orderNo = ''
  pagination.page = 1
  loadData()
  loadStats()
}

/** 点击统计卡片筛选 */
const onStatClick = (status) => {
  searchForm.status = status
  searchForm.orderNo = ''
  pagination.page = 1
  loadData()
}

/** 查看退款详情 */
const viewDetail = async (row) => {
  try {
    const res = await getRefundDetail(row.id)
    currentRefund.value = res.data || res
  } catch {
    currentRefund.value = row
  }
  detailVisible.value = true
}

/** 同意退款（需二次确认） */
const handleApprove = async (row) => {
  try {
    await ElMessageBox.confirm('确定同意该退款申请吗？同意后将自动退款并恢复库存', '确认同意', {
      confirmButtonText: '确定同意',
      cancelButtonText: '取消',
      type: 'warning'
    })
  } catch {
    return
  }

  try {
    await processRefund(row.id, 1, '同意退款')
    ElMessage.success('已同意退款，订单状态已更新')
    detailVisible.value = false
    loadData()
    loadStats()
  } catch {
    ElMessage.error('操作失败，请重试')
  }
}

/** 打开拒绝退款弹窗 */
const handleReject = (row) => {
  currentRefund.value = row
  rejectForm.reason = ''
  rejectVisible.value = true
  detailVisible.value = false
}

/** 确认拒绝退款 */
const confirmReject = async () => {
  if (!rejectForm.reason) {
    ElMessage.warning('请输入拒绝原因')
    return
  }

  submitLoading.value = true
  try {
    await rejectRefund(currentRefund.value.id, rejectForm.reason)
    ElMessage.success('已拒绝退款')
    rejectVisible.value = false
    loadData()
    loadStats()
  } catch {
    ElMessage.error('操作失败，请重试')
  } finally {
    submitLoading.value = false
  }
}

onMounted(() => {
  loadData()
  loadStats()
})
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
  cursor: pointer;
  position: relative;
  border: 2px solid transparent;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.stat-card.active {
  border-color: #667eea;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.2);
}

.stat-card.active .stat-value {
  color: #667eea;
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

.stat-total .stat-icon { background: rgba(64, 158, 255, 0.1); color: #409eff; }
.stat-pending .stat-icon { background: rgba(230, 162, 60, 0.1); color: #e6a23c; }
.stat-approved .stat-icon { background: rgba(103, 194, 58, 0.1); color: #67c23a; }
.stat-rejected .stat-icon { background: rgba(245, 108, 108, 0.1); color: #f56c6c; }

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

.stat-badge {
  position: absolute;
  top: 12px;
  right: 12px;
}

/* 状态单元格 */
.status-cell {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.status-detail {
  font-size: 11px;
  color: #909399;
  line-height: 1.4;
}

.process-time {
  white-space: nowrap;
}

.process-note {
  max-width: 140px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
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

/* 退款表格 */
.refund-table {
  border-radius: 8px;
  overflow: hidden;
}

.order-info {
  text-align: left;
}

.order-no {
  font-family: 'Monaco', 'Menlo', monospace;
  font-size: 13px;
  color: #409eff;
  font-weight: 500;
}

.order-id {
  font-size: 12px;
  color: #c0c4cc;
  margin-top: 4px;
}

.user-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  color: #606266;
}

.reason-cell {
  text-align: left;
}

.reason-text {
  font-size: 13px;
  color: #606266;
}

.amount-wrapper {
  display: flex;
  align-items: baseline;
  justify-content: center;
}

.amount-symbol {
  font-size: 14px;
  color: #f56c6c;
}

.amount-value {
  font-size: 18px;
  font-weight: 600;
  color: #f56c6c;
}

.time-text {
  font-size: 13px;
  color: #909399;
}

.action-buttons {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
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

/* 拒绝弹窗 */
.reject-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 20px 24px;
  margin: 0;
}

.reject-dialog :deep(.el-dialog__body) {
  padding: 24px;
}
</style>
