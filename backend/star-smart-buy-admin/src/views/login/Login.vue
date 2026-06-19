<template>
  <div class="login-page">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
      <div class="grid-lines"></div>
    </div>

    <!-- 登录容器 -->
    <div class="login-container">
      <!-- 左侧品牌区域 -->
      <div class="brand-section">
        <div class="brand-content">
          <div class="brand-logo">
            <div class="logo-icon">
              <el-icon :size="48"><Shop /></el-icon>
            </div>
            <h1 class="brand-name">星智购</h1>
            <p class="brand-slogan">智能购物平台管理系统</p>
          </div>

          <div class="brand-features">
            <div class="feature-item">
              <el-icon><DataAnalysis /></el-icon>
              <span>数据驱动决策</span>
            </div>
            <div class="feature-item">
              <el-icon><Goods /></el-icon>
              <span>商品精准管理</span>
            </div>
            <div class="feature-item">
              <el-icon><List /></el-icon>
              <span>订单高效处理</span>
            </div>
            <div class="feature-item">
              <el-icon><User /></el-icon>
              <span>用户深度运营</span>
            </div>
          </div>

          <div class="brand-footer">
            <p>© 2026 星智购</p>
          </div>
        </div>
      </div>

      <!-- 右侧登录表单区域 -->
      <div class="form-section">
        <div class="form-wrapper">
          <div class="form-header">
            <h2 class="form-title">欢迎回来</h2>
            <p class="form-subtitle">请输入您的账号信息登录系统</p>
          </div>

          <el-form
            ref="formRef"
            :model="form"
            :rules="rules"
            class="login-form"
            size="large"
          >
            <el-form-item prop="username">
              <div class="form-item-wrapper">
                <label class="form-label">
                  <el-icon><User /></el-icon>
                  用户名
                </label>
                <el-input
                  v-model="form.username"
                  placeholder="请输入用户名"
                  prefix-icon="User"
                  clearable
                  class="form-input"
                />
              </div>
            </el-form-item>

            <el-form-item prop="password">
              <div class="form-item-wrapper">
                <label class="form-label">
                  <el-icon><Lock /></el-icon>
                  密码
                </label>
                <el-input
                  v-model="form.password"
                  type="password"
                  placeholder="请输入密码"
                  prefix-icon="Lock"
                  show-password
                  class="form-input"
                  @keyup.enter="handleLogin"
                />
              </div>
            </el-form-item>

            <el-form-item>
              <el-button
                type="primary"
                :loading="loading"
                class="submit-btn"
                @click="handleLogin"
              >
                <span v-if="!loading">登 录</span>
                <span v-else>登录中...</span>
              </el-button>
            </el-form-item>
          </el-form>

        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * 管理员登录页面
 *
 * 提供用户名+密码登录，成功后由 Pinia store 管理 token 和用户状态，
 * 跳转至管理后台首页。
 */
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { adminLogin } from '@/api/admin'
import { useAdminStore } from '@/store/modules/admin'

const router = useRouter()
const adminStore = useAdminStore()

/** 表单引用 */
const formRef = ref(null)
/** 登录按钮 loading 状态 */
const loading = ref(false)

/** 登录表单数据 */
const form = reactive({
  username: '',
  password: ''
})

/** 表单校验规则 */
const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度为 3-20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为 6-20 个字符', trigger: 'blur' }
  ]
}

/**
 * 处理登录提交
 *
 * 校验表单 → 调用登录 API → 存储 token 到 Pinia → 跳转后台首页。
 * 错误由 Axios 响应拦截器统一处理。
 */
const handleLogin = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    const res = await adminLogin(form)
    adminStore.setAuth(res.data.token, res.data.adminId, res.data.username)
    ElMessage.success('登录成功，欢迎回来！')
    router.push('/admin/dashboard/overview')
  } catch (err) {
    // 错误由请求拦截器统一处理
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
  position: relative;
  overflow: hidden;
}

/* 背景装饰 */
.bg-decoration {
  position: absolute;
  inset: 0;
  overflow: hidden;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.3), rgba(118, 75, 162, 0.1));
  animation: float 20s infinite ease-in-out;
}

.circle-1 {
  width: 600px;
  height: 600px;
  top: -200px;
  right: -100px;
  animation-delay: 0s;
}

.circle-2 {
  width: 400px;
  height: 400px;
  bottom: -100px;
  left: -100px;
  animation-delay: -5s;
}

.circle-3 {
  width: 300px;
  height: 300px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  animation-delay: -10s;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0) scale(1); }
  25% { transform: translate(20px, -20px) scale(1.05); }
  50% { transform: translate(-10px, 10px) scale(0.95); }
  75% { transform: translate(15px, 15px) scale(1.02); }
}

.grid-lines {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(255, 255, 255, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.03) 1px, transparent 1px);
  background-size: 60px 60px;
}

/* 登录容器 */
.login-container {
  display: flex;
  width: 1000px;
  min-height: 600px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 24px;
  box-shadow:
    0 25px 50px -12px rgba(0, 0, 0, 0.5),
    0 0 0 1px rgba(255, 255, 255, 0.1);
  overflow: hidden;
  position: relative;
  z-index: 10;
}

/* 左侧品牌区域 */
.brand-section {
  flex: 1;
  background: linear-gradient(135deg, #1a1f36 0%, #0d1117 100%);
  padding: 60px 48px;
  display: flex;
  align-items: center;
  position: relative;
  overflow: hidden;
}

.brand-section::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle, rgba(102, 126, 234, 0.15) 0%, transparent 70%);
}

.brand-content {
  position: relative;
  z-index: 1;
  width: 100%;
}

.brand-logo {
  text-align: center;
  margin-bottom: 60px;
}

.logo-icon {
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  margin: 0 auto 24px;
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
}

.brand-name {
  font-size: 36px;
  font-weight: 700;
  color: #fff;
  margin: 0 0 12px;
  letter-spacing: 4px;
}

.brand-slogan {
  font-size: 16px;
  color: #8b919e;
  margin: 0;
  letter-spacing: 2px;
}

.brand-features {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.feature-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 20px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 12px;
  color: #fff;
  font-size: 15px;
  transition: all 0.3s ease;
}

.feature-item:hover {
  background: rgba(102, 126, 234, 0.2);
  transform: translateX(8px);
}

.feature-item .el-icon {
  font-size: 20px;
  color: #667eea;
}

.brand-footer {
  position: absolute;
  bottom: 40px;
  left: 48px;
  right: 48px;
  text-align: center;
  color: #8b919e;
  font-size: 13px;
}

/* 右侧表单区域 */
.form-section {
  flex: 1;
  padding: 60px 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
}

.form-wrapper {
  width: 100%;
  max-width: 360px;
}

.form-header {
  margin-bottom: 40px;
}

.form-title {
  font-size: 28px;
  font-weight: 600;
  color: #1a1f36;
  margin: 0 0 8px;
}

.form-subtitle {
  font-size: 14px;
  color: #8b919e;
  margin: 0;
}

/* 表单项样式 */
.login-form {
  margin-top: 0;
}

.form-item-wrapper {
  width: 100%;
}

.form-label {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 10px;
}

.form-label .el-icon {
  color: #667eea;
}

.form-input :deep(.el-input__wrapper) {
  padding: 4px 16px;
  border-radius: 10px;
  box-shadow: 0 0 0 1px #dcdfe6;
  transition: all 0.3s ease;
}

.form-input :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #667eea;
}

.form-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2), 0 0 0 1px #667eea;
}

.submit-btn {
  width: 100%;
  height: 48px;
  border-radius: 10px;
  font-size: 16px;
  font-weight: 500;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  transition: all 0.3s ease;
}

.submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
}

.submit-btn:active {
  transform: translateY(0);
}

.form-footer {
  margin-top: 32px;
  text-align: center;
  font-size: 14px;
  color: #8b919e;
}

.register-link {
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
  margin-left: 4px;
  transition: color 0.3s ease;
}

.register-link:hover {
  color: #764ba2;
}

/* 响应式 */
@media (max-width: 900px) {
  .login-container {
    width: 100%;
    min-height: 100vh;
    border-radius: 0;
    flex-direction: column;
  }

  .brand-section {
    padding: 40px 24px;
    min-height: 280px;
  }

  .brand-features {
    display: none;
  }

  .brand-footer {
    display: none;
  }

  .form-section {
    padding: 40px 24px;
    flex: 1;
  }
}
</style>
