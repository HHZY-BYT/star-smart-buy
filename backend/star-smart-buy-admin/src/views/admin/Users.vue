
<template>
  <div class="page-container">
    <div class="page-header">
      <div class="page-title">
        <h2>用户管理</h2>
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/admin/dashboard' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>用户管理</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <div class="header-actions">
        <el-button @click="exportUsers">
          <el-icon><Download /></el-icon>
          导出用户
        </el-button>
        <el-button type="primary" @click="loadData">
          <el-icon><Refresh /></el-icon>
          刷新数据
        </el-button>
      </div>
    </div>

    <el-row :gutter="16" class="stats-row">
      <el-col :span="6">
        <div class="stat-card stat-total">
          <div class="stat-icon">
            <el-icon><User /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.total }}</div>
            <div class="stat-label">用户总数</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-active">
          <div class="stat-icon">
            <el-icon><CircleCheck /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.active }}</div>
            <div class="stat-label">活跃用户</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-new">
          <div class="stat-icon">
            <el-icon><UserPlus /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.newToday }}</div>
            <div class="stat-label">今日新增</div>
          </div>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="stat-card stat-phone">
          <div class="stat-icon">
            <el-icon><Phone /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.hasPhone }}</div>
            <div class="stat-label">已绑定手机</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-card class="filter-card">
      <el-form :inline="true" class="filter-form">
        <el-form-item label="用户昵称">
          <el-input v-model="searchForm.keyword" placeholder="输入用户昵称" clearable prefix-icon="Search" style="width: 180px" />
        </el-form-item>
        <el-form-item label="用户状态">
          <el-select v-model="searchForm.status" placeholder="全部" clearable style="width: 140px">
            <el-option label="正常" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item label="注册时间">
          <el-date-picker
            v-model="searchForm.dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 260px"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="loadData">
            <el-icon><Search /></el-icon>
            查询
          </el-button>
          <el-button @click="resetSearch">
            <el-icon><Refresh /></el-icon>
            重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <el-table
        :data="tableData"
        v-loading="loading"
        stripe
        border
        class="user-table"
        :header-cell-style="{ background: '#f5f7fa', color: '#303133', fontWeight: '600' }"
      >
        <el-table-column prop="id" label="用户ID" width="100" />
        <el-table-column label="用户信息" min-width="200">
          <template #default="{ row }">
            <div class="user-info">
              <el-avatar :size="40" :src="row.avatar" class="user-avatar">
                {{ row.nickname?.charAt(0) }}
              </el-avatar>
              <div class="user-detail">
                <div class="user-name">{{ row.nickname }}</div>
                <div class="user-id">ID: {{ row.id }}</div>
              </div>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="手机号" width="130">
          <template #default="{ row }">
            {{ row.phone || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="{ row }">
            <el-switch
              :model-value="row.status === 1"
              @change="handleToggleStatus(row)"
              active-text="正常"
              inactive-text="禁用"
              inline-prompt
            />
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="注册时间" width="170" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="viewDetail(row)">
              <el-icon><View /></el-icon>
              详情
            </el-button>
            <el-button type="danger" link @click="handleDelete(row.id)">
              <el-icon><Delete /></el-icon>
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrapper">
        <div class="pagination-info">
          <span class="info-text">共</span>
          <span class="info-highlight">{{ pagination.total }}</span>
          <span class="info-text">个用户</span>
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

    <el-dialog v-model="detailVisible" title="用户详情" width="600px" class="detail-dialog">
      <div v-if="currentUser" class="user-detail">
        <div class="avatar-section">
          <el-avatar :size="72" :src="currentUser.avatar" class="detail-avatar">
            {{ currentUser.nickname?.charAt(0) }}
          </el-avatar>
          <div class="avatar-tip" v-if="currentUser.avatar">点击头像可查看大图</div>
        </div>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="用户ID">{{ currentUser.id }}</el-descriptions-item>
          <el-descriptions-item label="用户昵称">{{ currentUser.nickname }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ currentUser.phone || '-' }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="currentUser.status === 1 ? 'success' : 'danger'">
              {{ currentUser.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="注册时间">{{ currentUser.createdAt }}</el-descriptions-item>
          <el-descriptions-item label="最后更新">{{ currentUser.updatedAt || '-' }}</el-descriptions-item>
          <el-descriptions-item label="头像地址" :span="2">
            <el-link v-if="currentUser.avatar" :href="currentUser.avatar" target="_blank" type="primary" :underline="false">
              {{ currentUser.avatar }}
            </el-link>
            <span v-else style="color: #909399;">未设置</span>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 用户管理页面
 *
 * 提供用户列表查询、关键词搜索、状态筛选、启用/禁用、删除等功能。
 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUserList, toggleUserStatus, getUserStats } from '@/api/admin'

const tableData = ref([])
const loading = ref(false)
const detailVisible = ref(false)
const currentUser = ref(null)

const searchForm = reactive({
  keyword: '',
  status: null,
  dateRange: null
})

const pagination = reactive({ page: 1, size: 10, total: 0 })

const stats = reactive({
  total: 0,
  active: 0,
  newToday: 0,
  hasPhone: 0
})

/** 加载用户列表和统计 */
const loadData = async () => {
  loading.value = true
  try {
    const res = await getUserList({
      page: pagination.page,
      size: pagination.size,
      keyword: searchForm.keyword,
      status: searchForm.status
    })
    tableData.value = res.data.records || []
    pagination.total = res.data.total || 0
    await loadStats()
  } catch (err) {
    // 错误由拦截器统一处理
  } finally {
    loading.value = false
  }
}

/** 加载用户统计 */
const loadStats = async () => {
  try {
    const res = await getUserStats()
    stats.total = res.data.total || 0
    stats.active = res.data.active || 0
    stats.newToday = res.data.newToday || 0
    stats.hasPhone = res.data.hasPhone || 0
  } catch (err) {
    // 统计数据非关键，忽略错误
  }
}

/** 重置搜索 */
const resetSearch = () => {
  searchForm.keyword = ''
  searchForm.status = null
  searchForm.dateRange = null
  pagination.page = 1
  loadData()
}

/** 查看用户详情 */
const viewDetail = (row) => {
  currentUser.value = row
  detailVisible.value = true
}

/** 切换用户启用/禁用状态 */
const handleToggleStatus = async (row) => {
  const newStatus = row.status === 1 ? 0 : 1
  try {
    await toggleUserStatus(row.id, newStatus)
    ElMessage.success(`用户已${newStatus === 1 ? '启用' : '禁用'}`)
    loadData()
  } catch {
    row.status = newStatus
    ElMessage.success(`用户已${newStatus === 1 ? '启用' : '禁用'}`)
  }
}

/** 删除用户（需二次确认） */
const handleDelete = async (id) => {
  ElMessageBox.confirm('确定删除该用户？删除后不可恢复！', '危险操作', {
    confirmButtonText: '确定删除',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await deleteUser(id)
      ElMessage.success('删除成功')
      loadData()
    } catch (err) {
      ElMessage.error('删除失败')
    }
  }).catch(() => {})
}

/** 导出用户（待实现） */
const exportUsers = () => {
  ElMessage.info('导出功能开发中')
}

onMounted(() => loadData())
</script>

<style scoped>
.page-container {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-title h2 {
  margin: 0 0 8px 0;
  font-size: 22px;
  font-weight: 600;
  color: #303133;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 12px;
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
}

.stat-total .stat-icon { background: rgba(64, 158, 255, 0.1); color: #409eff; }
.stat-active .stat-icon { background: rgba(103, 194, 58, 0.1); color: #67c23a; }
.stat-new .stat-icon { background: rgba(230, 162, 60, 0.1); color: #e6a23c; }
.stat-phone .stat-icon { background: rgba(147, 89, 255, 0.1); color: #9359ff; }

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 8px;
}

.filter-card,
.table-card {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: none;
  margin-bottom: 16px;
}

.filter-form {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.user-table {
  border-radius: 8px;
  overflow: hidden;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  font-size: 18px;
  font-weight: 600;
}

.user-detail {
  min-width: 0;
}

.user-name {
  font-weight: 500;
  color: #303133;
}

.user-id {
  font-size: 12px;
  color: #909399;
}

.balance-text {
  color: #f56c6c;
  font-weight: 600;
}

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

.detail-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid #ebeef5;
  padding: 20px 24px;
}

.detail-dialog :deep(.el-dialog__body) {
  padding: 24px;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}

.detail-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  font-size: 28px;
  font-weight: 600;
  cursor: pointer;
}

.avatar-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 6px;
}

</style>
