<template>
  <div class="page-container">
    <!-- 页面标题区 -->
    <div class="page-header">
      <div class="header-content">
        <div class="page-title">
          <h2>评价管理</h2>
          <p class="page-desc">查看和管理用户商品评价</p>
        </div>
      </div>
    </div>

    <!-- 筛选区域 -->
    <el-card class="filter-card" shadow="never">
      <div class="filter-row">
        <div class="filter-item">
          <label class="filter-label">商品ID</label>
          <el-input v-model="searchForm.productId" placeholder="输入商品ID" clearable size="large" class="filter-input" />
        </div>
        <div class="filter-item">
          <label class="filter-label">评分</label>
          <el-select v-model="searchForm.rating" placeholder="全部评分" clearable size="large" class="filter-select">
            <el-option label="1星" :value="1" />
            <el-option label="2星" :value="2" />
            <el-option label="3星" :value="3" />
            <el-option label="4星" :value="4" />
            <el-option label="5星" :value="5" />
          </el-select>
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
          <span class="table-title">评价列表</span>
          <span class="table-count">共 {{ pagination.total }} 条评价</span>
        </div>
      </template>

      <el-table :data="tableData" v-loading="loading" stripe
        :header-cell-style="{ background: '#fafafa', color: '#666', fontWeight: '600', fontSize: '14px' }">
        <el-table-column prop="id" label="ID" width="70" align="center" />

        <el-table-column label="商品" min-width="160">
          <template #default="{ row }">
            <span class="product-name">{{ row.productName || '商品#' + row.productId }}</span>
          </template>
        </el-table-column>

        <el-table-column label="用户" width="120" align="center">
          <template #default="{ row }">
            <span>{{ row.userName || '用户#' + row.userId }}</span>
          </template>
        </el-table-column>

        <el-table-column label="评分" width="140" align="center">
          <template #default="{ row }">
            <div class="rating-wrapper">
              <el-icon v-for="i in 5" :key="i" :class="i <= row.rating ? 'star-filled' : 'star-empty'">
                <StarFilled v-if="i <= row.rating" />
                <Star v-else />
              </el-icon>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="评价内容" min-width="240">
          <template #default="{ row }">
            <div class="review-content">{{ row.content || '暂无文字评价' }}</div>
            <div v-if="row.reply" class="admin-reply">
              <span class="reply-tag">商家回复：</span>{{ row.reply }}
            </div>
          </template>
        </el-table-column>

        <el-table-column label="图片" width="120" align="center">
          <template #default="{ row }">
            <div v-if="row.images" class="review-images">
              <el-image
                v-for="(img, idx) in row.images.split(',').slice(0, 3)"
                :key="idx"
                :src="img"
                :preview-src-list="row.images.split(',')"
                :initial-index="idx"
                fit="cover"
                class="review-img"
              >
                <template #error><div class="img-error"><el-icon><Picture /></el-icon></div></template>
              </el-image>
              <span v-if="row.images.split(',').length > 3" class="more-images">+{{ row.images.split(',').length - 3 }}</span>
            </div>
            <span v-else class="no-images">无</span>
          </template>
        </el-table-column>

        <el-table-column label="评价时间" width="170" align="center">
          <template #default="{ row }">
            <span class="time-text">{{ row.createdAt }}</span>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="160" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" text size="small" @click="openReplyDialog(row)">
              {{ row.reply ? '修改回复' : '回复' }}
            </el-button>
            <el-divider direction="vertical" />
            <el-popconfirm title="确定删除该评价？删除后不可恢复！" @confirm="handleDelete(row.id)">
              <template #reference>
                <el-button type="danger" text size="small">删除</el-button>
              </template>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <div class="pagination-info">
          <span class="info-text">共</span>
          <span class="info-highlight">{{ pagination.total }}</span>
          <span class="info-text">条评价</span>
        </div>
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50]"
          layout="sizes, prev, pager, next"
          background
          @change="loadData"
          class="custom-pagination"
        />
      </div>
    </el-card>

    <!-- 回复对话框 -->
    <el-dialog v-model="replyDialogVisible" :title="replyForm.id && replyForm.existingReply ? '修改回复' : '回复评价'" width="520px" destroy-on-close>
      <div class="reply-review-info" v-if="replyForm.reviewContent">
        <div class="reply-review-label">用户评价：</div>
        <div class="reply-review-content">{{ replyForm.reviewContent }}</div>
      </div>
      <el-form label-width="80px" style="margin-top: 16px;">
        <el-form-item label="回复内容">
          <el-input v-model="replyForm.reply" type="textarea" :rows="4" placeholder="请输入回复内容" maxlength="500" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="replyDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleReply" :loading="replyLoading">提交回复</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 评价管理页面
 *
 * 提供用户评价列表查询、按商品ID/评分筛选、评价回复、删除等功能。
 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { getReviewList, deleteReview, replyReview } from '@/api/admin'

const tableData = ref([])
const loading = ref(false)
const replyDialogVisible = ref(false)
const replyLoading = ref(false)
const replyForm = reactive({
  id: null,
  reviewContent: '',
  existingReply: '',
  reply: ''
})

const searchForm = reactive({
  productId: '',
  rating: null
})

const pagination = reactive({ page: 1, size: 10, total: 0 })

/** 加载评价列表 */
const loadData = async () => {
  loading.value = true
  try {
    const params = {
      page: pagination.page,
      size: pagination.size
    }
    if (searchForm.productId) {
      params.productId = searchForm.productId
    }
    if (searchForm.rating) {
      params.rating = searchForm.rating
    }
    const res = await getReviewList(params)
    const data = res.data || res
    tableData.value = data.records || []
    pagination.total = data.total || 0
  } catch (err) {
    console.error('加载评价失败:', err)
  } finally {
    loading.value = false
  }
}

/** 重置搜索 */
const resetSearch = () => {
  searchForm.productId = ''
  searchForm.rating = null
  pagination.page = 1
  loadData()
}

/** 删除评价 */
const handleDelete = async (id) => {
  try {
    await deleteReview(id)
    ElMessage.success('删除成功')
    loadData()
  } catch (err) {
    console.error('删除评价失败:', err)
  }
}

/** 打开评价回复弹窗 */
const openReplyDialog = (row) => {
  replyForm.id = row.id
  replyForm.reviewContent = row.content || '暂无文字评价'
  replyForm.existingReply = row.reply || ''
  replyForm.reply = row.reply || ''
  replyDialogVisible.value = true
}

/** 提交评价回复 */
const handleReply = async () => {
  if (!replyForm.reply.trim()) {
    ElMessage.warning('请输入回复内容')
    return
  }
  replyLoading.value = true
  try {
    await replyReview(replyForm.id, replyForm.reply.trim())
    ElMessage.success('回复成功')
    replyDialogVisible.value = false
    loadData()
  } catch (err) {
    console.error('回复失败:', err)
  } finally {
    replyLoading.value = false
  }
}

onMounted(() => loadData())
</script>

<style scoped>
.page-container {
  padding: 24px;
  background: #f5f7fa;
  min-height: calc(100vh - 64px);
}

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

.filter-input { width: 200px; }
.filter-select { width: 140px; }

.filter-actions {
  flex-direction: row;
  gap: 12px;
}

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

.product-name {
  font-weight: 500;
  color: #303133;
}

.rating-wrapper {
  display: flex;
  gap: 2px;
  justify-content: center;
}

.star-filled {
  color: #f7ba2a;
  font-size: 16px;
}

.star-empty {
  color: #dcdfe6;
  font-size: 16px;
}

.review-content {
  font-size: 13px;
  color: #606266;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.review-images {
  display: flex;
  gap: 4px;
  align-items: center;
  justify-content: center;
}

.review-img {
  width: 36px;
  height: 36px;
  border-radius: 4px;
}

.img-error {
  width: 36px;
  height: 36px;
  background: #f5f7fa;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
}

.more-images {
  font-size: 12px;
  color: #909399;
}

.no-images {
  color: #c0c4cc;
  font-size: 13px;
}

.time-text {
  font-size: 13px;
  color: #909399;
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

.info-text { color: #909399; }
.info-highlight {
  color: #667eea;
  font-weight: 600;
  font-size: 16px;
}

.admin-reply {
  margin-top: 8px;
  padding: 8px 12px;
  background: #f0f9eb;
  border-radius: 6px;
  font-size: 13px;
  color: #67c23a;
  line-height: 1.5;
}

.reply-tag {
  font-weight: 600;
  color: #409eff;
}

.reply-review-info {
  padding: 12px;
  background: #f5f7fa;
  border-radius: 8px;
}

.reply-review-label {
  font-size: 13px;
  color: #909399;
  margin-bottom: 6px;
}

.reply-review-content {
  font-size: 14px;
  color: #303133;
  line-height: 1.5;
}
</style>
