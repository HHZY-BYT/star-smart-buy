<template>
  <div class="overview-container">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="12" :sm="12" :md="6">
        <div class="stat-card stat-orders">
          <div class="stat-bg-icon">
            <el-icon><List /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.orders }}</div>
            <div class="stat-label">今日订单</div>
            <div class="stat-trend up">
              <el-icon><Top /></el-icon>
              <span>12.5%</span>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :md="6">
        <div class="stat-card stat-sales">
          <div class="stat-bg-icon">
            <el-icon><Money /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">¥{{ stats.sales }}</div>
            <div class="stat-label">今日销售额</div>
            <div class="stat-trend up">
              <el-icon><Top /></el-icon>
              <span>8.2%</span>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :md="6">
        <div class="stat-card stat-products">
          <div class="stat-bg-icon">
            <el-icon><Goods /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.products }}</div>
            <div class="stat-label">商品总数</div>
            <div class="stat-trend neutral">
              <span>持平</span>
            </div>
          </div>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :md="6">
        <div class="stat-card stat-users">
          <div class="stat-bg-icon">
            <el-icon><User /></el-icon>
          </div>
          <div class="stat-content">
            <div class="stat-value">{{ stats.users }}</div>
            <div class="stat-label">用户总数</div>
            <div class="stat-trend up">
              <el-icon><Top /></el-icon>
              <span>5.3%</span>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :span="16">
        <el-card class="chart-card">
          <template #header>
            <div class="card-header">
              <span>销售趋势</span>
              <el-radio-group v-model="salesPeriod" size="small">
                <el-radio-button value="week">本周</el-radio-button>
                <el-radio-button value="month">本月</el-radio-button>
                <el-radio-button value="year">本年</el-radio-button>
              </el-radio-group>
            </div>
          </template>
          <div ref="salesChartRef" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="chart-card">
          <template #header>
            <div class="card-header">
              <span>订单状态分布</span>
            </div>
          </template>
          <div ref="pieChartRef" class="chart-container pie-chart"></div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 快捷入口 -->
    <el-card class="quick-actions">
      <template #header>
        <div class="card-header">
          <span>快捷操作</span>
        </div>
      </template>
      <el-row :gutter="20">
        <el-col :span="6">
          <div class="quick-action-item" @click="$router.push('/admin/products')">
            <div class="action-icon bg-blue">
              <el-icon><Plus /></el-icon>
            </div>
            <span>添加商品</span>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="quick-action-item" @click="$router.push('/admin/orders')">
            <div class="action-icon bg-green">
              <el-icon><List /></el-icon>
            </div>
            <span>处理订单</span>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="quick-action-item" @click="$router.push('/admin/users')">
            <div class="action-icon bg-orange">
              <el-icon><User /></el-icon>
            </div>
            <span>用户管理</span>
          </div>
        </el-col>
        <el-col :span="6">
          <div class="quick-action-item" @click="$router.push('/admin/settings')">
            <div class="action-icon bg-purple">
              <el-icon><Setting /></el-icon>
            </div>
            <span>系统设置</span>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 最新订单 -->
    <el-card class="recent-orders">
      <template #header>
        <div class="card-header">
          <span>最新订单</span>
          <el-button type="primary" link @click="$router.push('/admin/orders')">
            查看全部
            <el-icon><ArrowRight /></el-icon>
          </el-button>
        </div>
      </template>
      <el-table :data="recentOrders" stripe>
        <el-table-column prop="orderNo" label="订单编号" width="200" />
        <el-table-column prop="userId" label="用户" width="100" />
        <el-table-column prop="totalAmount" label="金额" width="120">
          <template #default="{ row }">
            <span class="amount-text">¥{{ row.totalAmount }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)" size="small">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="时间" />
      </el-table>
    </el-card>
  </div>
</template>

<script setup>
/**
 * 数据概览页面
 *
 * 展示核心业务指标（今日订单/销售额/商品数/用户数）、
 * 销售趋势折线图（支持周/月切换）、订单状态饼图及最新订单列表。
 */
import { ref, reactive, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import * as echarts from 'echarts'
import request from '@/api/request'

const router = useRouter()
const salesChartRef = ref(null)
const pieChartRef = ref(null)
const salesPeriod = ref('week')

let salesChart = null
let pieChart = null

/** 概览统计 */
const stats = reactive({
  orders: 0,
  sales: 0,
  products: 0,
  users: 0
})

const recentOrders = ref([])
/** 销售趋势数据 */
const salesData = reactive({
  labels: [],
  orders: [],
  sales: []
})
/** 订单状态分布数据 */
const pieData = reactive({
  pending: 0,
  paid: 0,
  shipped: 0,
  completed: 0,
  cancelled: 0
})

const getStatusText = (status) => {
  const map = { 0: '待付款', 1: '已付款', 2: '已发货', 3: '已完成', 4: '已取消', 5: '已退款' }
  return map[status] || '未知'
}

const getStatusType = (status) => {
  const map = { 0: 'warning', 1: 'success', 2: 'primary', 3: 'success', 4: 'info', 5: 'danger' }
  return map[status] || ''
}

/** 加载概览统计（订单/销售额/商品/用户） */
const loadOverviewStats = async () => {
  try {
    const data = await request.get('/admin/stats/overview')
    stats.orders = data.data.orders || 0
    stats.sales = data.data.sales || 0
    stats.products = data.data.products || 0
    stats.users = data.data.users || 0
  } catch (err) {
    console.error('加载概览数据失败:', err)
  }
}

/** 加载销售趋势并初始化图表 */
const loadSalesTrend = async () => {
  try {
    const data = await request.get('/admin/stats/sales', { params: { period: salesPeriod.value } })
    salesData.labels = data.data.labels || []
    salesData.orders = data.data.orders || []
    salesData.sales = data.data.sales || []
    initSalesChart()
  } catch (err) {
    console.error('加载销售趋势失败:', err)
  }
}

/** 加载订单状态分布并初始化饼图 */
const loadOrderStatus = async () => {
  try {
    const data = await request.get('/admin/stats/order-status')
    pieData.pending = data.data.pending || 0
    pieData.paid = data.data.paid || 0
    pieData.shipped = data.data.shipped || 0
    pieData.completed = data.data.completed || 0
    pieData.cancelled = data.data.cancelled || 0
    initPieChart()
  } catch (err) {
    console.error('加载订单状态失败:', err)
  }
}

/** 加载最新订单 */
const loadRecentOrders = async () => {
  try {
    const data = await request.get('/admin/stats/recent-orders', { params: { limit: 4 } })
    recentOrders.value = data.data.records || []
  } catch (err) {
    console.error('加载最新订单失败:', err)
  }
}

/** 初始化销售趋势折线图（ECharts） */
const initSalesChart = () => {
  if (!salesChartRef.value) return
  salesChart = echarts.init(salesChartRef.value)
  salesChart.setOption({
    tooltip: { trigger: 'axis' },
    legend: { data: ['销售额', '订单量'], bottom: 0 },
    grid: { left: '3%', right: '4%', bottom: '15%', top: '10%', containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: salesData.labels.length > 0 ? salesData.labels : ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    },
    yAxis: [
      { type: 'value', name: '销售额', axisLabel: { formatter: '¥{value}' } },
      { type: 'value', name: '订单量', axisLabel: { formatter: '{value}单' } }
    ],
    series: [
      {
        name: '销售额',
        type: 'line',
        smooth: true,
        data: salesData.sales.length > 0 ? salesData.sales : [12000, 15800, 13500, 18200, 22000, 19500, 25680],
        areaStyle: { opacity: 0.2 },
        lineStyle: { width: 3 },
        itemStyle: { color: '#667eea' }
      },
      {
        name: '订单量',
        type: 'line',
        smooth: true,
        yAxisIndex: 1,
        data: salesData.orders.length > 0 ? salesData.orders : [45, 62, 58, 78, 95, 88, 128],
        areaStyle: { opacity: 0.2 },
        lineStyle: { width: 3 },
        itemStyle: { color: '#67c23a' }
      }
    ]
  })
}

/** 初始化订单状态饼图（ECharts） */
const initPieChart = () => {
  if (!pieChartRef.value) return
  pieChart = echarts.init(pieChartRef.value)
  pieChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c} ({d}%)' },
    legend: { orient: 'vertical', right: '5%', top: 'center' },
    series: [
      {
        type: 'pie',
        radius: ['45%', '70%'],
        center: ['35%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: { borderRadius: 8, borderColor: '#fff', borderWidth: 2 },
        label: { show: false },
        emphasis: {
          label: { show: true, fontSize: 14, fontWeight: 'bold' }
        },
        data: [
          { value: pieData.pending || 45, name: '待付款', itemStyle: { color: '#e6a23c' } },
          { value: pieData.paid || 120, name: '已付款', itemStyle: { color: '#67c23a' } },
          { value: pieData.shipped || 35, name: '已发货', itemStyle: { color: '#409eff' } },
          { value: pieData.completed || 280, name: '已完成', itemStyle: { color: '#5cb87a' } },
          { value: pieData.cancelled || 15, name: '已取消', itemStyle: { color: '#909399' } }
        ]
      }
    ]
  })
}

/** 窗口缩放时自适应图表 */
const handleResize = () => {
  salesChart?.resize()
  pieChart?.resize()
}

// 切换统计周期时重新加载
watch(salesPeriod, () => {
  loadSalesTrend()
})

onMounted(() => {
  loadOverviewStats()
  loadSalesTrend()
  loadOrderStatus()
  loadRecentOrders()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  salesChart?.dispose()
  pieChart?.dispose()
})
</script>

<style scoped>
.overview-container {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

/* 统计卡片 */
.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
}

.stat-bg-icon {
  position: absolute;
  right: -10px;
  bottom: -10px;
  font-size: 80px;
  opacity: 0.08;
  color: #667eea;
}

.stat-orders .stat-bg-icon { color: #667eea; }
.stat-sales .stat-bg-icon { color: #67c23a; }
.stat-products .stat-bg-icon { color: #e6a23c; }
.stat-users .stat-bg-icon { color: #409eff; }

.stat-content {
  position: relative;
  z-index: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #303133;
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: #909399;
  margin-top: 8px;
}

.stat-trend {
  display: flex;
  align-items: center;
  gap: 4px;
  margin-top: 8px;
  font-size: 13px;
}

.stat-trend.up {
  color: #67c23a;
}

.stat-trend.down {
  color: #f56c6c;
}

.stat-trend.neutral {
  color: #909399;
}

/* 图表区域 */
.chart-row {
  margin-bottom: 20px;
}

.chart-card {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: none;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  color: #303133;
}

.chart-container {
  height: 320px;
}

.pie-chart {
  height: 320px;
}

/* 快捷操作 */
.quick-actions {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: none;
  margin-bottom: 20px;
}

.quick-action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  padding: 24px 16px;
  background: #f5f7fa;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.quick-action-item:hover {
  background: #eef1f5;
  transform: translateY(-2px);
}

.action-icon {
  width: 56px;
  height: 56px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: #fff;
}

.bg-blue { background: linear-gradient(135deg, #667eea, #764ba2); }
.bg-green { background: linear-gradient(135deg, #67c23a, #5cb87a); }
.bg-orange { background: linear-gradient(135deg, #e6a23c, #f78966); }
.bg-purple { background: linear-gradient(135deg, #9c27b0, #673ab7); }

.quick-action-item span {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

/* 最新订单 */
.recent-orders {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: none;
}

.amount-text {
  color: #f56c6c;
  font-weight: 600;
}
</style>
