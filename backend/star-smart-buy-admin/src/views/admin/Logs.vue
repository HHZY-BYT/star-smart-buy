<template>
  <div class="page-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="page-title">
        <h2>日志管理</h2>
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/admin/dashboard' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>日志管理</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="16" class="stats-row">
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-item">
            <div class="stat-icon total">
              <el-icon><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.total || 0 }}</div>
              <div class="stat-label">日志总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-item">
            <div class="stat-icon today">
              <el-icon><Clock /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.today || 0 }}</div>
              <div class="stat-label">今日操作</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-item">
            <div class="stat-icon fail">
              <el-icon><WarningFilled /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.todayFail || 0 }}</div>
              <div class="stat-label">今日异常</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-item">
            <div class="stat-icon success">
              <el-icon><CircleCheckFilled /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ todaySuccessRate }}</div>
              <div class="stat-label">今日成功率</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 筛选区域 -->
    <el-card class="filter-card">
      <el-form :inline="true" :model="queryForm" class="filter-form">
        <el-form-item label="操作模块">
          <el-select v-model="queryForm.module" placeholder="全部模块" clearable style="width: 140px;">
            <el-option v-for="m in moduleOptions" :key="m.value" :label="m.label" :value="m.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="queryForm.operationType" placeholder="全部类型" clearable style="width: 130px;">
            <el-option v-for="t in typeOptions" :key="t.value" :label="t.label" :value="t.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作状态">
          <el-select v-model="queryForm.status" placeholder="全部状态" clearable style="width: 120px;">
            <el-option label="成功" :value="1" />
            <el-option label="失败" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作人">
          <el-input v-model="queryForm.operatorName" placeholder="操作人名称" clearable style="width: 140px;" />
        </el-form-item>
        <el-form-item label="操作时间">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
            style="width: 260px;"
            @change="onDateChange"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>搜索
          </el-button>
          <el-button @click="handleReset">
            <el-icon><Refresh /></el-icon>重置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 操作栏 -->
    <el-card class="table-card">
      <div class="table-toolbar">
        <div class="toolbar-left">
          <el-button type="danger" plain :disabled="selectedIds.length === 0" @click="handleBatchDelete">
            <el-icon><Delete /></el-icon>批量删除
          </el-button>
          <el-button type="warning" plain @click="handleClean">
            <el-icon><Brush /></el-icon>清空日志
          </el-button>
        </div>
        <div class="toolbar-right">
          <el-button @click="loadLogs">
            <el-icon><Refresh /></el-icon>刷新
          </el-button>
        </div>
      </div>

      <!-- 数据表格 -->
      <el-table
        :data="logs"
        v-loading="loading"
        stripe
        border
        @selection-change="handleSelectionChange"
        style="width: 100%;"
      >
        <el-table-column type="selection" width="50" align="center" />
        <el-table-column prop="id" label="ID" width="70" align="center" />
        <el-table-column label="操作模块" width="110" align="center">
          <template #default="{ row }">
            <el-tag :type="getModuleTagType(row.module)" size="small" effect="plain">
              {{ getModuleLabel(row.module) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作类型" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="getTypeTagType(row.operationType)" size="small">
              {{ getTypeLabel(row.operationType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="description" label="操作描述" min-width="180" show-overflow-tooltip />
        <el-table-column prop="operatorName" label="操作人" width="110" align="center" show-overflow-tooltip>
          <template #default="{ row }">
            <span class="operator-name">{{ row.operatorName || '-' }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作人类型" width="100" align="center">
          <template #default="{ row }">
            <el-tag v-if="row.operatorType === 'ADMIN'" type="danger" size="small" effect="plain">管理员</el-tag>
            <el-tag v-else-if="row.operatorType === 'USER'" type="success" size="small" effect="plain">用户</el-tag>
            <el-tag v-else type="info" size="small" effect="plain">{{ row.operatorType }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="ip" label="IP地址" width="130" show-overflow-tooltip />
        <el-table-column label="耗时" width="90" align="center">
          <template #default="{ row }">
            <span :class="{ 'slow-query': row.costTime > 1000 }">
              {{ row.costTime }}ms
            </span>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="80" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
              {{ row.status === 1 ? '成功' : '失败' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="操作时间" width="170" align="center" />
        <el-table-column label="操作" width="120" fixed="right" align="center">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleDetail(row)">
              <el-icon><View /></el-icon>详情
            </el-button>
            <el-button type="danger" link size="small" @click="handleDelete(row)">
              <el-icon><Delete /></el-icon>删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination
          v-model:current-page="queryForm.page"
          v-model:page-size="queryForm.size"
          :page-sizes="[20, 50, 100, 200]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="loadLogs"
          @current-change="loadLogs"
        />
      </div>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailVisible" title="日志详情" width="700px" destroy-on-close>
      <el-descriptions :column="2" border size="default" v-if="detailData">
        <el-descriptions-item label="日志ID">{{ detailData.id }}</el-descriptions-item>
        <el-descriptions-item label="操作状态">
          <el-tag :type="detailData.status === 1 ? 'success' : 'danger'" size="small">
            {{ detailData.status === 1 ? '成功' : '失败' }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作模块">
          <el-tag :type="getModuleTagType(detailData.module)" size="small" effect="plain">
            {{ getModuleLabel(detailData.module) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作类型">
          <el-tag :type="getTypeTagType(detailData.operationType)" size="small">
            {{ getTypeLabel(detailData.operationType) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="操作描述" :span="2">{{ detailData.description }}</el-descriptions-item>
        <el-descriptions-item label="操作人">{{ detailData.operatorName }}</el-descriptions-item>
        <el-descriptions-item label="操作人类型">
          <el-tag v-if="detailData.operatorType === 'ADMIN'" type="danger" size="small" effect="plain">管理员</el-tag>
          <el-tag v-else type="success" size="small" effect="plain">{{ detailData.operatorType }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="IP地址">{{ detailData.ip }}</el-descriptions-item>
        <el-descriptions-item label="耗时">{{ detailData.costTime }}ms</el-descriptions-item>
        <el-descriptions-item label="请求URL" :span="2">{{ detailData.requestUrl }}</el-descriptions-item>
        <el-descriptions-item label="HTTP方法">{{ detailData.requestMethod }}</el-descriptions-item>
        <el-descriptions-item label="Java方法" :span="2">{{ detailData.method }}</el-descriptions-item>
        <el-descriptions-item label="操作时间" :span="2">{{ detailData.createdAt }}</el-descriptions-item>
        <el-descriptions-item label="User-Agent" :span="2">
          <span class="ua-text">{{ detailData.userAgent }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="请求参数" :span="2">
          <div class="json-viewer">
            <pre>{{ formatJson(detailData.requestParams) }}</pre>
          </div>
        </el-descriptions-item>
        <el-descriptions-item label="返回结果" :span="2">
          <div class="json-viewer">
            <pre>{{ formatJson(detailData.responseResult) }}</pre>
          </div>
        </el-descriptions-item>
        <el-descriptions-item v-if="detailData.errorMsg" label="错误信息" :span="2">
          <div class="error-msg">{{ detailData.errorMsg }}</div>
        </el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="detailVisible = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 清空日志对话框 -->
    <el-dialog v-model="cleanVisible" title="清空日志" width="450px">
      <el-alert type="warning" :closable="false" style="margin-bottom: 16px;">
        此操作将删除指定天数之前的日志，请谨慎操作！
      </el-alert>
      <el-form label-width="100px">
        <el-form-item label="保留天数">
          <el-input-number v-model="keepDays" :min="1" :max="365" />
          <span style="margin-left: 12px; color: #909399; font-size: 13px;">保留最近{{ keepDays }}天的日志</span>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="cleanVisible = false">取消</el-button>
        <el-button type="danger" @click="confirmClean" :loading="cleanLoading">确认清空</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 操作日志页面
 *
 * 提供操作日志查询（按模块/操作类型/操作人/时间/状态筛选）、详情查看、
 * 单条删除、批量删除、按天数清空等功能。
 */
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getLogList, getLogDetail, deleteLog, batchDeleteLog, cleanLog, getLogStats } from '@/api/admin'

// ========== 数据定义 ==========
const loading = ref(false)
const logs = ref([])
const total = ref(0)
const selectedIds = ref([])
const detailVisible = ref(false)
const detailData = ref(null)
const cleanVisible = ref(false)
const cleanLoading = ref(false)
const keepDays = ref(30)
const dateRange = ref(null)
const stats = ref({ total: 0, today: 0, todayFail: 0 })

const queryForm = reactive({
  page: 1,
  size: 20,
  module: '',
  operationType: '',
  operatorName: '',
  status: null,
  startDate: '',
  endDate: ''
})

// ========== 选项配置 ==========
const moduleOptions = [
  { value: 'PRODUCT', label: '商品管理' },
  { value: 'ORDER', label: '订单管理' },
  { value: 'USER', label: '用户管理' },
  { value: 'CATEGORY', label: '分类管理' },
  { value: 'BANNER', label: '轮播图管理' },
  { value: 'NOTICE', label: '公告管理' },
  { value: 'REVIEW', label: '评价管理' },
  { value: 'REFUND', label: '退款管理' },
  { value: 'SETTING', label: '系统设置' },
  { value: 'AI', label: 'AI配置' },
  { value: 'OTHER', label: '其他' }
]

const typeOptions = [
  { value: 'CREATE', label: '新增' },
  { value: 'UPDATE', label: '修改' },
  { value: 'DELETE', label: '删除' },
  { value: 'LOGIN', label: '登录' },
  { value: 'EXPORT', label: '导出' },
  { value: 'IMPORT', label: '导入' },
  { value: 'OTHER', label: '其他' }
]

// ========== 计算属性 ==========
const todaySuccessRate = computed(() => {
  if (!stats.value.today) return '100%'
  const fail = stats.value.todayFail || 0
  const rate = ((stats.value.today - fail) / stats.value.today * 100).toFixed(1)
  return rate + '%'
})

// ========== 方法 ==========
const getModuleLabel = (val) => moduleOptions.find(m => m.value === val)?.label || val
const getTypeLabel = (val) => typeOptions.find(t => t.value === val)?.label || val

const getModuleTagType = (val) => {
  const map = {
    PRODUCT: '', ORDER: 'warning', USER: 'success', CATEGORY: 'info',
    BANNER: 'danger', NOTICE: '', REVIEW: 'success', REFUND: 'danger',
    SETTING: 'info', AI: 'warning', OTHER: 'info'
  }
  return map[val] || 'info'
}

const getTypeTagType = (val) => {
  const map = { CREATE: 'success', UPDATE: 'warning', DELETE: 'danger', LOGIN: '', EXPORT: 'info', IMPORT: 'info', OTHER: 'info' }
  return map[val] || 'info'
}

const formatJson = (str) => {
  if (!str) return '-'
  try {
    return JSON.stringify(JSON.parse(str), null, 2)
  } catch {
    return str
  }
}

const onDateChange = (val) => {
  if (val) {
    queryForm.startDate = val[0]
    queryForm.endDate = val[1]
  } else {
    queryForm.startDate = ''
    queryForm.endDate = ''
  }
}

/**
 * 加载日志列表
 * 根据筛选条件分页查询，自动过滤空值参数
 */
const loadLogs = async () => {
  loading.value = true
  try {
    const params = { ...queryForm }
    // 清除空值
    Object.keys(params).forEach(key => {
      if (params[key] === '' || params[key] === null || params[key] === undefined) {
        delete params[key]
      }
    })
    const res = await getLogList(params)
    const data = res.data || res
    logs.value = data.records || []
    total.value = data.total || 0
  } catch (error) {
    console.error('加载日志失败:', error)
    ElMessage.error('加载日志失败')
  } finally {
    loading.value = false
  }
}

/** 加载操作日志统计（总量/今日/失败数/成功率） */
const loadStats = async () => {
  try {
    const res = await getLogStats()
    stats.value = res.data || res
  } catch (error) {
    console.error('加载统计失败:', error)
  }
}

// 搜索
const handleSearch = () => {
  queryForm.page = 1
  loadLogs()
}

// 重置
const handleReset = () => {
  Object.assign(queryForm, {
    page: 1, size: 20, module: '', operationType: '',
    operatorName: '', status: null, startDate: '', endDate: ''
  })
  dateRange.value = null
  loadLogs()
}

// 选择变更
const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.id)
}

// 查看详情
const handleDetail = async (row) => {
  try {
    const res = await getLogDetail(row.id)
    detailData.value = res.data || res || row
    detailVisible.value = true
  } catch (error) {
    detailData.value = row
    detailVisible.value = true
  }
}

// 删除单条
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该日志吗？', '提示', { type: 'warning' })
    await deleteLog(row.id)
    ElMessage.success('删除成功')
    loadLogs()
    loadStats()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 批量删除
const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(`确定要删除选中的 ${selectedIds.value.length} 条日志吗？`, '提示', { type: 'warning' })
    await batchDeleteLog(selectedIds.value)
    ElMessage.success('批量删除成功')
    selectedIds.value = []
    loadLogs()
    loadStats()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

// 清空日志
const handleClean = () => {
  cleanVisible.value = true
}

const confirmClean = async () => {
  cleanLoading.value = true
  try {
    const res = await cleanLog(keepDays.value)
    const data = res.data || res
    ElMessage.success(`已清空 ${data.deleted || 0} 条日志`)
    cleanVisible.value = false
    loadLogs()
    loadStats()
  } catch (error) {
    ElMessage.error('清空失败')
  } finally {
    cleanLoading.value = false
  }
}

onMounted(() => {
  loadLogs()
  loadStats()
})
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
  margin-bottom: 20px;
}

.page-title h2 {
  margin: 0 0 8px 0;
  font-size: 22px;
  font-weight: 600;
  color: #303133;
}

/* 统计卡片 */
.stats-row {
  margin-bottom: 16px;
}

.stat-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.stat-item {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 52px;
  height: 52px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  flex-shrink: 0;
}

.stat-icon.total {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
}

.stat-icon.today {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: #fff;
}

.stat-icon.fail {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: #fff;
}

.stat-icon.success {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: #fff;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #303133;
  line-height: 1.2;
}

.stat-label {
  font-size: 13px;
  color: #909399;
  margin-top: 4px;
}

/* 筛选卡片 */
.filter-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  margin-bottom: 16px;
}

.filter-form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
}

/* 表格卡片 */
.table-card {
  border-radius: 12px;
  border: none;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
}

.table-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.toolbar-left, .toolbar-right {
  display: flex;
  gap: 8px;
}

.operator-name {
  color: #409eff;
  font-weight: 500;
}

.slow-query {
  color: #f56c6c;
  font-weight: 600;
}

/* 分页 */
.pagination-wrapper {
  display: flex;
  justify-content: flex-end;
  margin-top: 16px;
}

/* JSON展示 */
.json-viewer {
  max-height: 300px;
  overflow: auto;
  background: #f5f7fa;
  border-radius: 6px;
  padding: 12px;
}

.json-viewer pre {
  margin: 0;
  font-size: 12px;
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-all;
  color: #303133;
}

.ua-text {
  font-size: 12px;
  color: #606266;
  word-break: break-all;
}

.error-msg {
  color: #f56c6c;
  font-size: 13px;
  line-height: 1.6;
  background: #fef0f0;
  padding: 8px 12px;
  border-radius: 6px;
  word-break: break-all;
}

:deep(.el-descriptions__label) {
  width: 100px;
  font-weight: 500;
}

:deep(.el-table) {
  font-size: 13px;
}

:deep(.el-table th) {
  background: #f5f7fa;
  font-weight: 600;
  color: #303133;
}
</style>
