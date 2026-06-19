<template>
  <div class="page-container">
    <!-- 页面标题区 -->
    <div class="page-header">
      <div class="header-content">
        <div class="page-title">
          <h2>商品管理</h2>
          <p class="page-desc">管理商城商品，添加、编辑、上下架商品</p>
        </div>
      </div>
      <div class="header-actions">
        <el-button type="primary" size="large" @click="handleAdd">
          <el-icon><Plus /></el-icon>
          添加商品
        </el-button>
      </div>
    </div>

    <!-- 筛选区域 -->
    <el-card class="filter-card" shadow="never">
      <div class="filter-row">
        <div class="filter-item">
          <label class="filter-label">商品名称</label>
          <el-input
            v-model="searchForm.keyword"
            placeholder="搜索商品名称"
            clearable
            size="large"
            class="filter-input"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </div>
        <div class="filter-item">
          <label class="filter-label">商品状态</label>
          <el-select v-model="searchForm.status" placeholder="全部状态" clearable size="large" class="filter-select">
            <el-option label="上架" :value="1" />
            <el-option label="下架" :value="0" />
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
          <span class="table-title">商品列表</span>
          <span class="table-count">共 {{ pagination.total }} 件商品</span>
        </div>
      </template>

      <el-table
        :data="tableData"
        v-loading="loading"
        stripe
        class="product-table"
        :header-cell-style="{ background: '#fafafa', color: '#666', fontWeight: '600', fontSize: '14px' }"
        :row-style="{ height: '80px' }"
      >
        <el-table-column label="商品信息" min-width="320">
          <template #default="{ row }">
            <div class="product-cell">
              <div class="product-image-wrapper">
                <el-image
                  v-if="row.images"
                  :src="row.images.split(',')[0]"
                  fit="cover"
                  class="product-image"
                >
                  <template #error>
                    <div class="image-placeholder">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
                <div v-else class="image-placeholder">
                  <el-icon><Picture /></el-icon>
                </div>
              </div>
              <div class="product-info">
                <div class="product-name">{{ row.name }}</div>
                <div class="product-id">ID: {{ row.id }}</div>
                <div class="product-desc">{{ row.description || '暂无描述' }}</div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="分类" width="120" align="center">
          <template #default="{ row }">
            <el-tag type="info" effect="plain" round>
              分类{{ row.categoryId }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="价格" width="140" align="center">
          <template #default="{ row }">
            <div class="price-wrapper">
              <span class="price-symbol">¥</span>
              <span class="price-value">{{ row.price }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="库存" width="120" align="center">
          <template #default="{ row }">
            <div class="stock-wrapper">
              <span :class="['stock-value', { 'low': row.stock < 10 }]">{{ row.stock }}</span>
              <el-tooltip v-if="row.stock < 10" content="库存不足" placement="top">
                <el-icon class="warning-icon"><WarningFilled /></el-icon>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'danger'" effect="dark" round>
              {{ row.status === 1 ? '上架' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="220" align="center" fixed="right">
          <template #default="{ row }">
            <div class="action-buttons">
              <el-button
                :type="row.status === 1 ? 'warning' : 'success'"
                text
                size="small"
                @click="handleToggleStatus(row)"
              >
                {{ row.status === 1 ? '下架' : '上架' }}
              </el-button>
              <el-divider direction="vertical" />
              <el-button type="primary" text size="small" @click="handleEdit(row)">
                编辑
              </el-button>
              <el-divider direction="vertical" />
              <el-button type="danger" text size="small" @click="handleDelete(row.id)">
                删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <div class="pagination-info">
          <span class="info-text">共</span>
          <span class="info-highlight">{{ pagination.total }}</span>
          <span class="info-text">件商品</span>
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

    <!-- 新增/编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑商品' : '新增商品'"
      width="720px"
      :close-on-click-modal="false"
      class="product-dialog"
      destroy-on-close
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="商品名称" prop="name">
              <el-input v-model="form.name" placeholder="请输入商品名称" size="large" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="商品分类" prop="categoryId">
              <el-input-number v-model="form.categoryId" :min="1" size="large" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="24">
          <el-col :span="12">
            <el-form-item label="商品价格（元）" prop="price">
              <el-input-number
                v-model="form.price"
                :min="0"
                :precision="2"
                :step="100"
                size="large"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="商品库存" prop="stock">
              <el-input-number v-model="form.stock" :min="0" :step="10" size="large" style="width: 100%" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="商品图片">
          <el-radio-group v-model="imageMode" style="margin-bottom: 12px;">
            <el-radio value="url">URL链接</el-radio>
            <el-radio value="upload">本地上传</el-radio>
          </el-radio-group>
          <!-- URL输入模式 -->
          <div v-if="imageMode === 'url'">
            <el-input v-model="form.images" placeholder="输入图片URL，多个用逗号分隔" />
            <div class="form-tip">支持输入多个图片URL，用英文逗号分隔</div>
          </div>
          <!-- 本地上传模式 -->
          <div v-else>
            <el-upload
              :auto-upload="false"
              :file-list="uploadFileList"
              :on-change="onProductFileChange"
              :on-remove="onProductFileRemove"
              accept="image/*"
              list-type="picture-card"
              :limit="5"
              multiple
            >
              <el-icon><Plus /></el-icon>
            </el-upload>
            <div class="form-tip">支持上传多张图片，最多5张，单张不超过5MB</div>
          </div>
          <!-- 图片预览 -->
          <div v-if="form.images" class="image-preview-list">
            <div class="image-preview-label">当前图片：</div>
            <div class="image-preview-items">
              <el-image
                v-for="(url, idx) in form.images.split(',')"
                :key="idx"
                :src="url"
                fit="cover"
                style="width: 60px; height: 60px; border-radius: 6px; margin-right: 8px;"
              >
                <template #error>
                  <div class="image-placeholder-small"><el-icon><Picture /></el-icon></div>
                </template>
              </el-image>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入商品描述" />
        </el-form-item>

        <!-- 商品规格 -->
        <el-form-item label="商品规格">
          <div class="spec-list">
            <div v-for="(spec, index) in form.specs" :key="index" class="spec-row">
              <el-input v-model="spec.specName" placeholder="规格名（如颜色）" style="width: 160px" />
              <el-input v-model="spec.specValue" placeholder="规格值（如黑色）" style="flex: 1" />
              <el-button type="danger" text @click="removeSpec(index)">
                <el-icon><Delete /></el-icon>
              </el-button>
            </div>
          </div>
          <el-button type="primary" text @click="addSpec">
            <el-icon><Plus /></el-icon> 添加规格
          </el-button>
          <div class="form-tip">如：规格名填"颜色"，规格值填"黑色"。同一规格名可以有多个规格值</div>
        </el-form-item>

        <el-form-item label="商品状态">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">上架</el-radio>
            <el-radio :value="0">下架</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="dialogVisible = false" size="large">取消</el-button>
          <el-button type="primary" @click="handleSubmit" size="large" :loading="submitLoading">
            确定提交
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
/**
 * 商品管理页面
 *
 * 提供商品列表、搜索筛选、新增/编辑（含图片上传和规格管理）、
 * 上下架切换、删除等功能。
 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getProductList, saveProduct, updateProduct, deleteProduct, uploadImage, getProductDetail, onProduct, offProduct } from '@/api/admin'

/** 表格数据 */
const tableData = ref([])
/** 表格加载状态 */
const loading = ref(false)
/** 新增/编辑弹窗可见性 */
const dialogVisible = ref(false)
/** 提交按钮 loading */
const submitLoading = ref(false)
/** 表单引用 */
const formRef = ref(null)
/** 是否编辑模式 */
const isEdit = ref(false)
/** 图片模式：url | upload */
const imageMode = ref('url')
/** 上传文件列表 */
const uploadFileList = ref([])

/** 搜索表单 */
const searchForm = reactive({
  keyword: '',
  status: null
})

/** 分页参数 */
const pagination = reactive({ page: 1, size: 10, total: 0 })

/** 商品表单 */
const form = reactive({
  id: null,
  name: '',
  categoryId: 1,
  price: 0,
  stock: 0,
  images: '',
  description: '',
  status: 1,
  specs: []
})

/** 表单校验规则 */
const rules = {
  name: [{ required: true, message: '请输入商品名称', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
  stock: [{ required: true, message: '请输入库存', trigger: 'blur' }]
}

/**
 * 加载商品列表
 *
 * 根据分页和筛选条件查询商品，更新表格数据和总数。
 * 错误由 Axios 响应拦截器统一处理。
 */
const loadData = async () => {
  loading.value = true
  try {
    const res = await getProductList({
      page: pagination.page,
      size: pagination.size,
      keyword: searchForm.keyword,
      status: searchForm.status
    })
    tableData.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (err) {
    // 错误由请求拦截器统一处理
  } finally {
    loading.value = false
  }
}

/** 重置搜索条件并重新加载 */
const resetSearch = () => {
  searchForm.keyword = ''
  searchForm.status = null
  pagination.page = 1
  loadData()
}

/** 打开新增商品弹窗，重置表单为默认值 */
const handleAdd = () => {
  isEdit.value = false
  imageMode.value = 'url'
  uploadFileList.value = []
  Object.assign(form, {
    id: null,
    name: '',
    categoryId: 1,
    price: 0,
    stock: 0,
    images: '',
    description: '',
    status: 1,
    specs: []
  })
  dialogVisible.value = true
}

/**
 * 打开编辑商品弹窗
 *
 * 从 API 获取商品详情填充表单；失败时使用列表行数据作为兜底。
 *
 * @param {Object} row - 当前行的商品数据
 */
const handleEdit = async (row) => {
  isEdit.value = true
  imageMode.value = 'url'
  uploadFileList.value = []
  try {
    const res = await getProductDetail(row.id)
    const detail = res.data || res
    Object.assign(form, {
      id: detail.id,
      name: detail.name,
      categoryId: detail.categoryId,
      price: detail.price,
      stock: detail.stock,
      images: detail.images || '',
      description: detail.description || '',
      status: detail.status,
      specs: (detail.specs || []).map(s => ({ ...s }))
    })
  } catch (err) {
    // 接口失败时使用列表行数据兜底
    Object.assign(form, {
      id: row.id,
      name: row.name,
      categoryId: row.categoryId,
      price: row.price,
      stock: row.stock,
      images: row.images || '',
      description: row.description || '',
      status: row.status,
      specs: []
    })
  }
  dialogVisible.value = true
}

// ======== 图片上传相关 ========

/** 上传文件变化回调 */
const onProductFileChange = (file, fileList) => {
  uploadFileList.value = fileList
}

/** 移除上传文件回调 */
const onProductFileRemove = (file, fileList) => {
  uploadFileList.value = fileList
}

/**
 * 提交商品表单（新增/编辑）
 *
 * 先校验表单，本地上传模式下逐个上传图片并收集 URL，
 * 再根据 isEdit 调用新增或更新接口。
 */
const handleSubmit = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  submitLoading.value = true
  try {
    // 本地上传模式：逐个上传图片并收集 URL
    if (imageMode.value === 'upload' && uploadFileList.value.length > 0) {
      const uploadedUrls = []
      for (const fileItem of uploadFileList.value) {
        if (fileItem.response) {
          // 已上传过的文件
          const data = fileItem.response.data || fileItem.response
          uploadedUrls.push(typeof data === 'string' ? data : data.url)
        } else if (fileItem.url && !fileItem.raw) {
          // 已有的URL（编辑时）
          uploadedUrls.push(fileItem.url)
        } else if (fileItem.raw) {
          // 新文件需要上传
          const res = await uploadImage(fileItem.raw)
          const url = res.data || res
          uploadedUrls.push(typeof url === 'string' ? url : url.url)
        }
      }
      form.images = uploadedUrls.join(',')
    }

    if (isEdit.value) {
      await updateProduct(form)
      ElMessage.success('更新成功')
    } else {
      await saveProduct(form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadData()
  } catch (err) {
    // 错误由请求拦截器统一处理
  } finally {
    submitLoading.value = false
  }
}

/**
 * 删除商品
 *
 * 弹出确认框，用户确认后调用删除接口。
 *
 * @param {number} id - 商品 ID
 */
const handleDelete = (id) => {
  ElMessageBox.confirm('确定删除该商品？删除后不可恢复！', '确认删除', {
    confirmButtonText: '确定删除',
    cancelButtonText: '取消',
    type: 'warning',
    confirmButtonClass: 'el-button--danger'
  }).then(async () => {
    await deleteProduct(id)
    ElMessage.success('删除成功')
    loadData()
  }).catch(() => {})
}

/** 添加一行空白规格 */
const addSpec = () => {
  form.specs.push({ specName: '', specValue: '' })
}

/** 删除指定位置的规格 */
const removeSpec = (index) => {
  form.specs.splice(index, 1)
}

/**
 * 切换商品上下架状态
 *
 * @param {Object} row - 当前行的商品数据
 */
const handleToggleStatus = async (row) => {
  const newStatus = row.status === 1 ? 0 : 1
  const action = newStatus === 1 ? '上架' : '下架'
  try {
    if (newStatus === 1) {
      await onProduct(row.id)
    } else {
      await offProduct(row.id)
    }
    ElMessage.success(`商品已${action}`)
    loadData()
  } catch (err) {
    console.error('操作失败:', err)
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
  width: 240px;
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

/* 商品表格 */
.product-table {
  border-radius: 8px;
  overflow: hidden;
}

.product-cell {
  display: flex;
  align-items: center;
  gap: 16px;
}

.product-image-wrapper {
  flex-shrink: 0;
}

.product-image {
  width: 64px;
  height: 64px;
  border-radius: 8px;
  overflow: hidden;
}

.image-placeholder {
  width: 64px;
  height: 64px;
  background: #f5f7fa;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
  font-size: 24px;
}

.product-info {
  min-width: 0;
}

.product-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-id {
  font-size: 12px;
  color: #909399;
  margin-bottom: 4px;
}

.product-desc {
  font-size: 12px;
  color: #c0c4cc;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 200px;
}

/* 价格 */
.price-wrapper {
  display: flex;
  align-items: baseline;
  justify-content: center;
}

.price-symbol {
  font-size: 14px;
  color: #f56c6c;
}

.price-value {
  font-size: 18px;
  font-weight: 600;
  color: #f56c6c;
}

/* 库存 */
.stock-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.stock-value.low {
  color: #e6a23c;
}

.warning-icon {
  color: #e6a23c;
}

/* 操作按钮 */
.action-buttons {
  display: flex;
  align-items: center;
  justify-content: center;
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

/* 弹窗 */
.product-dialog :deep(.el-dialog__header) {
  border-bottom: 1px solid #f0f0f0;
  padding: 20px 24px;
  margin: 0;
}

.product-dialog :deep(.el-dialog__title) {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.product-dialog :deep(.el-dialog__body) {
  padding: 28px 24px;
}

.product-dialog :deep(.el-dialog__footer) {
  border-top: 1px solid #f0f0f0;
  padding: 16px 24px;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.spec-list {
  width: 100%;
  margin-bottom: 8px;
}

.spec-row {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 8px;
}

.form-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}

.image-preview-list {
  margin-top: 12px;
  padding: 12px;
  background: #fafafa;
  border-radius: 8px;
}

.image-preview-label {
  font-size: 13px;
  color: #606266;
  margin-bottom: 8px;
}

.image-preview-items {
  display: flex;
  flex-wrap: wrap;
}

.image-placeholder-small {
  width: 60px;
  height: 60px;
  background: #f5f7fa;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #c0c4cc;
}
</style>
