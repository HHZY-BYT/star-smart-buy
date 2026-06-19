<template>
  <div class="page-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <div class="page-title">
        <h2>系统设置</h2>
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/admin/dashboard/overview' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>系统设置</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
    </div>

    <el-row :gutter="20">
      <!-- 左侧设置导航 -->
      <el-col :span="5">
        <el-card class="nav-card">
          <el-menu :default-active="activeTab" class="settings-nav">
            <el-menu-item index="ai" @click="activeTab = 'ai'">
              <el-icon><Cpu /></el-icon>
              <span>AI 配置</span>
            </el-menu-item>
            <el-menu-item index="banner" @click="activeTab = 'banner'">
              <el-icon><Picture /></el-icon>
              <span>轮播图管理</span>
            </el-menu-item>
            <el-menu-item index="notice" @click="activeTab = 'notice'">
              <el-icon><Bell /></el-icon>
              <span>公告管理</span>
            </el-menu-item>
            <el-menu-item index="security" @click="activeTab = 'security'">
              <el-icon><Lock /></el-icon>
              <span>安全设置</span>
            </el-menu-item>
          </el-menu>
        </el-card>
      </el-col>

      <!-- 右侧设置内容 -->
      <el-col :span="19">
        <!-- AI 配置 -->
        <el-card v-show="activeTab === 'ai'" class="content-card">
          <template #header>
            <div class="card-header">
              <span>
                <el-icon><Cpu /></el-icon>
                AI 智能助手配置
              </span>
              <div>
                <el-button type="primary" size="small" @click="addAiConfig">
                  <el-icon><Plus /></el-icon>
                  新增配置
                </el-button>
              </div>
            </div>
          </template>

          <!-- 已有配置列表 -->
          <el-table :data="aiConfigList" border stripe style="margin-bottom: 24px;">
            <el-table-column prop="provider" label="服务商" width="120">
              <template #default="{ row }">
                <el-tag :type="getProviderTagType(row.provider)" size="small">
                  {{ getProviderName(row.provider) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="model" label="模型" width="160" />
            <el-table-column label="API Key" width="200">
              <template #default="{ row }">
                <span>{{ maskApiKey(row.apiKey) }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="baseUrl" label="Base URL" show-overflow-tooltip />
            <el-table-column label="状态" width="80">
              <template #default="{ row }">
                <el-tag :type="row.isActive === 1 ? 'success' : 'info'" size="small">
                  {{ row.isActive === 1 ? '启用' : '未启用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200">
              <template #default="{ row }">
                <el-button type="primary" link size="small" @click="editAiConfig(row)">编辑</el-button>
                <el-button
                  v-if="row.isActive !== 1"
                  type="success"
                  link
                  size="small"
                  @click="activateAiConfig(row.id)"
                >启用</el-button>
                <el-button
                  v-if="row.isActive !== 1"
                  type="danger"
                  link
                  size="small"
                  @click="deleteAiConfig(row.id)"
                >删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- AI配置编辑表单 -->
          <el-divider content-position="left">{{ aiConfigForm.id ? '编辑配置' : '新增配置' }}</el-divider>
          <el-form label-width="140px" style="max-width: 700px;">
            <el-form-item label="AI 服务提供商">
              <el-select
                v-model="aiConfigForm.provider"
                style="width: 240px;"
                placeholder="选择AI服务商"
                @change="onProviderChange"
              >
                <el-option label="DeepSeek" value="deepseek">
                  <span class="provider-option">
                    <span class="provider-badge deepseek">D</span>
                    DeepSeek - 性价比之王
                  </span>
                </el-option>
                <el-option label="OpenAI" value="openai">
                  <span class="provider-option">
                    <span class="provider-badge openai">O</span>
                    OpenAI - GPT系列
                  </span>
                </el-option>
                <el-option label="智谱AI" value="zhipu">
                  <span class="provider-option">
                    <span class="provider-badge zhipu">智</span>
                    智谱AI - ChatGLM
                  </span>
                </el-option>
                <el-option label="通义千问" value="qwen">
                  <span class="provider-option">
                    <span class="provider-badge qwen">通</span>
                    通义千问 - 阿里云
                  </span>
                </el-option>
                <el-option label="Moonshot (Kimi)" value="moonshot">
                  <span class="provider-option">
                    <span class="provider-badge moonshot">M</span>
                    Moonshot - Kimi
                  </span>
                </el-option>
                <el-option label="讯飞星火" value="spark">
                  <span class="provider-option">
                    <span class="provider-badge spark">星</span>
                    讯飞星火 - Spark
                  </span>
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="API Key">
              <el-input
                v-model="aiConfigForm.apiKey"
                type="password"
                show-password
                placeholder="输入 API Key"
                style="width: 400px;"
              />
            </el-form-item>
            <el-form-item label="Base URL">
              <el-input
                v-model="aiConfigForm.baseUrl"
                placeholder="https://api.deepseek.com"
                style="width: 400px;"
              >
                <template #append>
                  <el-tooltip content="根据服务商自动填充" placement="top">
                    <el-button @click="autoFillBaseUrl">
                      <el-icon><Refresh /></el-icon>
                    </el-button>
                  </el-tooltip>
                </template>
              </el-input>
            </el-form-item>
            <el-form-item label="模型名称">
              <el-select
                v-model="aiConfigForm.model"
                style="width: 300px;"
                filterable
                allow-create
                placeholder="选择或输入模型名称"
              >
                <el-option
                  v-for="m in currentModels"
                  :key="m.value"
                  :label="m.label"
                  :value="m.value"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="Temperature">
              <el-slider v-model="aiConfigForm.temperature" :min="0" :max="1" :step="0.1" style="width: 300px;" />
              <span class="slider-value">{{ aiConfigForm.temperature }}</span>
            </el-form-item>
            <el-form-item label="Max Tokens">
              <el-input-number v-model="aiConfigForm.maxTokens" :min="256" :max="8192" :step="256" />
            </el-form-item>
            <el-form-item label="系统提示词">
              <el-input
                v-model="aiConfigForm.systemPrompt"
                type="textarea"
                :rows="4"
                placeholder="输入 AI 系统提示词"
                style="width: 500px;"
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="saveAiConfig">
                <el-icon><Check /></el-icon>
                保存配置
              </el-button>
              <el-button @click="testAiConnection" :loading="testing">
                <el-icon><Connection /></el-icon>
                测试连接
              </el-button>
              <el-button v-if="aiConfigForm.id" @click="resetAiForm">
                取消编辑
              </el-button>
            </el-form-item>
          </el-form>

          <!-- 测试结果 -->
          <el-alert
            v-if="testResult"
            :title="testResult.success ? '连接成功' : '连接失败'"
            :type="testResult.success ? 'success' : 'error'"
            :description="testResult.message"
            show-icon
            closable
            style="margin-top: 16px;"
          />
        </el-card>

        <!-- 轮播图管理 -->
        <el-card v-show="activeTab === 'banner'" class="content-card">
          <template #header>
            <div class="card-header">
              <span>
                <el-icon><Picture /></el-icon>
                轮播图管理
              </span>
              <el-button type="primary" size="small" @click="openBannerDialog()">
                <el-icon><Plus /></el-icon>
                新增轮播图
              </el-button>
            </div>
          </template>
          <el-table :data="banners" border stripe>
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column label="图片" width="200">
              <template #default="{ row }">
                <el-image :src="row.image" fit="cover" style="width: 160px; height: 60px; border-radius: 4px;" />
              </template>
            </el-table-column>
            <el-table-column prop="title" label="标题" />
            <el-table-column prop="link" label="跳转链接" show-overflow-tooltip />
            <el-table-column prop="sort" label="排序" width="80" />
            <el-table-column prop="status" label="状态" width="80">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small">
                  {{ row.status === 1 ? '显示' : '隐藏' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button type="primary" link @click="openBannerDialog(row)">编辑</el-button>
                <el-button type="danger" link @click="handleDeleteBanner(row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 轮播图对话框 -->
          <el-dialog v-model="bannerDialogVisible" :title="bannerForm.id ? '编辑轮播图' : '新增轮播图'" width="520px">
            <el-form label-width="100px">
              <el-form-item label="图片">
                <el-radio-group v-model="bannerImageMode" style="margin-bottom: 12px;">
                  <el-radio value="url">URL链接</el-radio>
                  <el-radio value="upload">本地上传</el-radio>
                </el-radio-group>
                <div v-if="bannerImageMode === 'url'">
                  <el-input v-model="bannerForm.image" placeholder="输入图片URL" />
                </div>
                <div v-else>
                  <el-upload
                    :auto-upload="false"
                    :file-list="bannerUploadList"
                    :on-change="onBannerFileChange"
                    :on-remove="onBannerFileRemove"
                    accept="image/*"
                    list-type="picture-card"
                    :limit="1"
                  >
                    <el-icon><Plus /></el-icon>
                  </el-upload>
                </div>
                <div v-if="bannerForm.image" style="margin-top: 8px;">
                  <div style="font-size: 13px; color: #606266; margin-bottom: 4px;">当前图片：</div>
                  <el-image :src="bannerForm.image" fit="cover" style="width: 160px; height: 80px; border-radius: 6px;" />
                </div>
              </el-form-item>
              <el-form-item label="标题">
                <el-input v-model="bannerForm.title" placeholder="输入轮播图标题" />
              </el-form-item>
              <el-form-item label="跳转链接">
                <el-input v-model="bannerForm.link" placeholder="点击跳转的页面路径，如 /pages/product/product?id=1" />
              </el-form-item>
              <el-form-item label="排序">
                <el-input-number v-model="bannerForm.sort" :min="0" :max="999" />
                <span style="margin-left: 12px; color: #909399; font-size: 13px;">越小越靠前</span>
              </el-form-item>
              <el-form-item label="状态">
                <el-switch v-model="bannerForm.status" :active-value="1" :inactive-value="0" active-text="显示" inactive-text="隐藏" />
              </el-form-item>
            </el-form>
            <template #footer>
              <el-button @click="bannerDialogVisible = false">取消</el-button>
              <el-button type="primary" @click="saveBanner">确定</el-button>
            </template>
          </el-dialog>
        </el-card>

        <!-- 公告管理 -->
        <el-card v-show="activeTab === 'notice'" class="content-card">
          <template #header>
            <div class="card-header">
              <span>
                <el-icon><Bell /></el-icon>
                公告管理
              </span>
              <el-button type="primary" size="small" @click="openNoticeDialog()">
                <el-icon><Plus /></el-icon>
                发布公告
              </el-button>
            </div>
          </template>
          <el-table :data="notices" border stripe>
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="title" label="标题" />
            <el-table-column prop="content" label="内容" show-overflow-tooltip />
            <el-table-column label="发布时间" width="170">
              <template #default="{ row }">
                {{ row.createdAt || row.createTime }}
              </template>
            </el-table-column>
            <el-table-column prop="status" label="状态" width="80">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'info'" size="small">
                  {{ row.status === 1 ? '显示' : '隐藏' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button type="primary" link @click="openNoticeDialog(row)">编辑</el-button>
                <el-button type="danger" link @click="handleDeleteNotice(row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>

          <!-- 公告对话框 -->
          <el-dialog v-model="noticeDialogVisible" :title="noticeForm.id ? '编辑公告' : '发布公告'" width="520px">
            <el-form label-width="100px">
              <el-form-item label="公告标题">
                <el-input v-model="noticeForm.title" placeholder="输入公告标题" />
              </el-form-item>
              <el-form-item label="公告内容">
                <el-input v-model="noticeForm.content" type="textarea" :rows="4" placeholder="输入公告内容" />
              </el-form-item>
              <el-form-item label="状态">
                <el-switch v-model="noticeForm.status" :active-value="1" :inactive-value="0" active-text="显示" inactive-text="隐藏" />
              </el-form-item>
            </el-form>
            <template #footer>
              <el-button @click="noticeDialogVisible = false">取消</el-button>
              <el-button type="primary" @click="saveNotice">确定</el-button>
            </template>
          </el-dialog>
        </el-card>

        <!-- 安全设置 -->
        <el-card v-show="activeTab === 'security'" class="content-card">
          <template #header>
            <div class="card-header">
              <span>
                <el-icon><Lock /></el-icon>
                安全设置
              </span>
            </div>
          </template>
          <el-form label-width="140px" style="max-width: 700px;">
            <el-form-item label="当前账号">
              <span class="info-value">{{ adminStore.username }}</span>
            </el-form-item>
            <el-divider content-position="left">修改密码</el-divider>
            <el-form-item label="当前密码" required>
              <el-input v-model="passwordForm.oldPassword" type="password" show-password placeholder="请输入当前密码" style="width: 250px;" />
            </el-form-item>
            <el-form-item label="新密码" required>
              <el-input v-model="passwordForm.newPassword" type="password" show-password placeholder="请输入新密码（至少6位）" style="width: 250px;" />
            </el-form-item>
            <el-form-item label="确认新密码" required>
              <el-input v-model="passwordForm.confirmPassword" type="password" show-password placeholder="请再次输入新密码" style="width: 250px;" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="updatePassword" :loading="passwordLoading">
                <el-icon><Check /></el-icon>
                修改密码
              </el-button>
            </el-form-item>
            <el-divider />
            <el-form-item label="登录超时">
              <el-select v-model="securityConfig.timeout" style="width: 150px;">
                <el-option label="30 分钟" :value="30" />
                <el-option label="1 小时" :value="60" />
                <el-option label="2 小时" :value="120" />
                <el-option label="24 小时" :value="1440" />
              </el-select>
            </el-form-item>
            <el-form-item label="登录限制">
              <el-switch v-model="securityConfig.loginLimit" />
              <span class="switch-tip">启用后，同一账号最多同时在线 3 台设备</span>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="saveSecurityConfig">
                <el-icon><Check /></el-icon>
                保存设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
/**
 * 系统设置页面
 *
 * 提供 AI 大模型配置（支持 6 家服务商）、轮播图管理、公告管理、安全设置、
 * 管理员密码修改等功能。AI 配置支持实时激活和连接测试。
 */
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useAdminStore } from '@/store/modules/admin'
import {
  getAiConfig, saveAiConfig as saveAiConfigApi, testAiConfig,
  getBannerList, addBanner as addBannerApi, updateBanner as updateBannerApi, deleteBanner as deleteBannerApi,
  getNoticeList, addNotice as addNoticeApi, updateNotice as updateNoticeApi, deleteNotice as deleteNoticeApi,
  uploadImage,
  updateAdminPassword
} from '@/api/admin'

const activeTab = ref('ai')
const adminStore = useAdminStore()

// ========== AI 配置 ==========
const aiConfigList = ref([])
const testing = ref(false)
const testResult = ref(null)

// 提供商预设配置
const PROVIDER_PRESETS = {
  deepseek: { baseUrl: 'https://api.deepseek.com', name: 'DeepSeek', models: [
    { value: 'deepseek-chat', label: 'deepseek-chat (通用)' },
    { value: 'deepseek-reasoner', label: 'deepseek-reasoner (推理)' }
  ]},
  openai: { baseUrl: 'https://api.openai.com', name: 'OpenAI', models: [
    { value: 'gpt-3.5-turbo', label: 'GPT-3.5 Turbo' },
    { value: 'gpt-4', label: 'GPT-4' },
    { value: 'gpt-4o', label: 'GPT-4o' },
    { value: 'gpt-4o-mini', label: 'GPT-4o Mini' }
  ]},
  zhipu: { baseUrl: 'https://open.bigmodel.cn/api/paas/v4', name: '智谱AI', models: [
    { value: 'glm-4', label: 'GLM-4' },
    { value: 'glm-4-flash', label: 'GLM-4 Flash' },
    { value: 'glm-4-plus', label: 'GLM-4 Plus' },
    { value: 'glm-4-air', label: 'GLM-4 Air' }
  ]},
  qwen: { baseUrl: 'https://dashscope.aliyuncs.com/compatible-mode/v1', name: '通义千问', models: [
    { value: 'qwen-turbo', label: 'Qwen Turbo' },
    { value: 'qwen-plus', label: 'Qwen Plus' },
    { value: 'qwen-max', label: 'Qwen Max' },
    { value: 'qwen-long', label: 'Qwen Long' }
  ]},
  moonshot: { baseUrl: 'https://api.moonshot.cn/v1', name: 'Moonshot (Kimi)', models: [
    { value: 'moonshot-v1-8k', label: 'Moonshot V1 8K' },
    { value: 'moonshot-v1-32k', label: 'Moonshot V1 32K' },
    { value: 'moonshot-v1-128k', label: 'Moonshot V1 128K' }
  ]},
  spark: { baseUrl: 'https://spark-api-open.xf-yun.com/v1', name: '讯飞星火', models: [
    { value: 'generalv3.5', label: 'Spark V3.5' },
    { value: 'generalv3', label: 'Spark V3' },
    { value: '4.0Ultra', label: 'Spark 4.0 Ultra' }
  ]}
}

const currentModels = computed(() => {
  const provider = aiConfigForm.provider
  return PROVIDER_PRESETS[provider]?.models || []
})

const aiConfigForm = reactive({
  id: null,
  provider: 'deepseek',
  apiKey: '',
  baseUrl: 'https://api.deepseek.com',
  model: 'deepseek-chat',
  temperature: 0.7,
  maxTokens: 2048,
  systemPrompt: '你是星智购的智能导购助手，专门帮助用户推荐和销售3C数码产品。请用简洁专业的语气回答。'
})

const getProviderName = (provider) => PROVIDER_PRESETS[provider]?.name || provider

const getProviderTagType = (provider) => {
  const map = { deepseek: '', openai: 'success', zhipu: 'warning', qwen: 'danger', moonshot: 'info', spark: '' }
  return map[provider] || ''
}

const maskApiKey = (key) => {
  if (!key) return ''
  if (key.length <= 8) return '****'
  return key.substring(0, 4) + '****' + key.substring(key.length - 4)
}

const onProviderChange = (provider) => {
  const preset = PROVIDER_PRESETS[provider]
  if (preset) {
    aiConfigForm.baseUrl = preset.baseUrl
    if (preset.models.length > 0) {
      aiConfigForm.model = preset.models[0].value
    }
  }
}

const autoFillBaseUrl = () => {
  const preset = PROVIDER_PRESETS[aiConfigForm.provider]
  if (preset) {
    aiConfigForm.baseUrl = preset.baseUrl
  }
}

/** 重置表单为新增 AI 配置的默认值 */
const addAiConfig = () => {
  Object.assign(aiConfigForm, {
    id: null,
    provider: 'deepseek',
    apiKey: '',
    baseUrl: 'https://api.deepseek.com',
    model: 'deepseek-chat',
    temperature: 0.7,
    maxTokens: 2048,
    systemPrompt: '你是星智购的智能导购助手，专门帮助用户推荐和销售3C数码产品。请用简洁专业的语气回答。'
  })
  testResult.value = null
}

const editAiConfig = (row) => {
  Object.assign(aiConfigForm, {
    id: row.id,
    provider: row.provider,
    apiKey: row.apiKey,
    baseUrl: row.baseUrl,
    model: row.model,
    temperature: row.temperature,
    maxTokens: row.maxTokens,
    systemPrompt: row.systemPrompt || ''
  })
  testResult.value = null
}

const resetAiForm = () => {
  addAiConfig()
}

const loadAiConfig = async () => {
  try {
    const res = await getAiConfig()
    const data = res.data || res
    if (data.active) {
      editAiConfig(data.active)
    }
    aiConfigList.value = data.configs || []
  } catch (error) {
    console.error('加载AI配置失败:', error)
  }
}

const saveAiConfig = async () => {
  if (!aiConfigForm.provider) {
    ElMessage.warning('请选择AI服务提供商')
    return
  }
  if (!aiConfigForm.apiKey) {
    ElMessage.warning('请输入API Key')
    return
  }
  try {
    await saveAiConfigApi(aiConfigForm)
    ElMessage.success('AI 配置已保存')
    loadAiConfig()
  } catch (error) {
    ElMessage.error('保存失败: ' + (error.message || '未知错误'))
  }
}

const activateAiConfig = async (id) => {
  try {
    const { default: request } = await import('@/api/request')
    await request.put(`/admin/ai/config/${id}/activate`)
    ElMessage.success('已切换AI配置')
    loadAiConfig()
  } catch (error) {
    ElMessage.error('切换失败')
  }
}

const deleteAiConfig = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除该AI配置吗？', '提示', { type: 'warning' })
    const { default: request } = await import('@/api/request')
    await request.delete(`/admin/ai/config/${id}`)
    ElMessage.success('已删除')
    loadAiConfig()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const testAiConnection = async () => {
  if (!aiConfigForm.apiKey || !aiConfigForm.baseUrl) {
    ElMessage.warning('请先填写 API Key 和 Base URL')
    return
  }
  testing.value = true
  testResult.value = null
  try {
    const res = await testAiConfig(aiConfigForm)
    testResult.value = res.data
  } catch (error) {
    testResult.value = { success: false, message: error.message || '连接测试失败' }
  } finally {
    testing.value = false
  }
}

const banners = ref([])
const notices = ref([])

// ========== 轮播图管理 ==========
const bannerDialogVisible = ref(false)
const bannerImageMode = ref('url')
const bannerUploadList = ref([])
const bannerForm = reactive({
  id: null,
  image: '',
  title: '',
  link: '',
  sort: 0,
  status: 1
})

const loadBanners = async () => {
  try {
    const res = await getBannerList()
    const data = res.data || res
    banners.value = Array.isArray(data) ? data : []
  } catch (error) {
    console.error('加载轮播图失败:', error)
    banners.value = []
  }
}

const openBannerDialog = (row = null) => {
  bannerImageMode.value = 'url'
  bannerUploadList.value = []
  if (row) {
    Object.assign(bannerForm, {
      id: row.id,
      image: row.image,
      title: row.title || '',
      link: row.link || '',
      sort: row.sort || 0,
      status: row.status
    })
  } else {
    Object.assign(bannerForm, { id: null, image: '', title: '', link: '', sort: 0, status: 1 })
  }
  bannerDialogVisible.value = true
}

const onBannerFileChange = (file, fileList) => {
  bannerUploadList.value = fileList
}

const onBannerFileRemove = (file, fileList) => {
  bannerUploadList.value = fileList
}

const saveBanner = async () => {
  // 如果是本地上传模式，先上传图片
  if (bannerImageMode.value === 'upload' && bannerUploadList.value.length > 0) {
    const fileItem = bannerUploadList.value[0]
    if (fileItem.raw) {
      try {
        const res = await uploadImage(fileItem.raw)
        const url = res.data || res
        bannerForm.image = typeof url === 'string' ? url : url.url
      } catch (error) {
        ElMessage.error('图片上传失败: ' + (error.message || '未知错误'))
        return
      }
    }
  }
  if (!bannerForm.image) {
    ElMessage.warning('请提供图片')
    return
  }
  try {
    if (bannerForm.id) {
      await updateBannerApi({ ...bannerForm })
      ElMessage.success('轮播图已更新')
    } else {
      await addBannerApi({ ...bannerForm })
      ElMessage.success('轮播图已添加')
    }
    bannerDialogVisible.value = false
    loadBanners()
  } catch (error) {
    ElMessage.error('保存失败: ' + (error.message || '未知错误'))
  }
}

const handleDeleteBanner = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除该轮播图吗？', '提示', { type: 'warning' })
    await deleteBannerApi(id)
    ElMessage.success('已删除')
    loadBanners()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// ========== 公告管理 ==========
const noticeDialogVisible = ref(false)
const noticeForm = reactive({
  id: null,
  title: '',
  content: '',
  status: 1
})

const loadNotices = async () => {
  try {
    const res = await getNoticeList()
    const data = res.data || res
    notices.value = Array.isArray(data) ? data : []
  } catch (error) {
    console.error('加载公告失败:', error)
    notices.value = []
  }
}

const openNoticeDialog = (row = null) => {
  if (row) {
    Object.assign(noticeForm, {
      id: row.id,
      title: row.title,
      content: row.content || '',
      status: row.status
    })
  } else {
    Object.assign(noticeForm, { id: null, title: '', content: '', status: 1 })
  }
  noticeDialogVisible.value = true
}

const saveNotice = async () => {
  if (!noticeForm.title) {
    ElMessage.warning('请输入公告标题')
    return
  }
  try {
    if (noticeForm.id) {
      await updateNoticeApi({ ...noticeForm })
      ElMessage.success('公告已更新')
    } else {
      await addNoticeApi({ ...noticeForm })
      ElMessage.success('公告已发布')
    }
    noticeDialogVisible.value = false
    loadNotices()
  } catch (error) {
    ElMessage.error('保存失败: ' + (error.message || '未知错误'))
  }
}

const handleDeleteNotice = async (id) => {
  try {
    await ElMessageBox.confirm('确定要删除该公告吗？', '提示', { type: 'warning' })
    await deleteNoticeApi(id)
    ElMessage.success('已删除')
    loadNotices()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const securityConfig = reactive({
  timeout: 60,
  loginLimit: true
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const passwordLoading = ref(false)

/**
 * 修改管理员密码
 *
 * 校验旧密码/新密码/确认密码 → 二次确认 → 调用 API → 清除 store → 跳转登录页。
 */
const updatePassword = async () => {
  if (!passwordForm.oldPassword) {
    ElMessage.warning('请输入当前密码')
    return
  }
  if (!passwordForm.newPassword) {
    ElMessage.warning('请输入新密码')
    return
  }
  if (passwordForm.newPassword.length < 6) {
    ElMessage.warning('新密码长度不能少于6位')
    return
  }
  if (passwordForm.newPassword !== passwordForm.confirmPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }

  try {
    await ElMessageBox.confirm('确定要修改密码吗？修改后需要重新登录', '确认修改密码', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
  } catch {
    return
  }

  passwordLoading.value = true
  try {
    await updateAdminPassword({
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })
    ElMessage.success('密码修改成功，即将重新登录')

    // 清空表单
    passwordForm.oldPassword = ''
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''

    // 延迟跳转登录页
    setTimeout(() => {
      adminStore.logout()
      window.location.href = '/admin/login'
    }, 1500)
  } catch (error) {
    // 错误已由拦截器处理
  } finally {
    passwordLoading.value = false
  }
}

const saveSecurityConfig = () => {
  ElMessage.success('安全设置已保存')
}

onMounted(() => {
  loadAiConfig()
  loadBanners()
  loadNotices()
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

.nav-card {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: none;
}

.settings-nav {
  border: none;
}

.settings-nav .el-menu-item {
  height: 48px;
  line-height: 48px;
  border-radius: 8px;
  margin-bottom: 4px;
  transition: all 0.3s ease;
}

.settings-nav .el-menu-item:hover {
  background: #f5f7fa;
}

.settings-nav .el-menu-item.is-active {
  background: linear-gradient(90deg, rgba(102, 126, 234, 0.1) 0%, rgba(102, 126, 234, 0.05) 100%);
  color: #667eea;
}

.settings-nav .el-menu-item .el-icon {
  margin-right: 10px;
  font-size: 18px;
}

.content-card {
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
  border: none;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  font-size: 16px;
  color: #303133;
}

.card-header .el-icon {
  margin-right: 8px;
  color: #667eea;
}

.slider-value {
  margin-left: 16px;
  color: #667eea;
  font-weight: 500;
}

.info-value {
  color: #303133;
  font-weight: 500;
}

.switch-tip {
  margin-left: 12px;
  color: #909399;
  font-size: 13px;
}

/* AI Provider 选项样式 */
.provider-option {
  display: flex;
  align-items: center;
  gap: 8px;
}

.provider-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  flex-shrink: 0;
}

.provider-badge.deepseek { background: #4d6bfe; }
.provider-badge.openai { background: #10a37f; }
.provider-badge.zhipu { background: #4f6ef7; }
.provider-badge.qwen { background: #ff6a00; }
.provider-badge.moonshot { background: #6c5ce7; }
.provider-badge.spark { background: #0066ff; }

:deep(.el-divider) {
  margin: 24px 0;
}
</style>
