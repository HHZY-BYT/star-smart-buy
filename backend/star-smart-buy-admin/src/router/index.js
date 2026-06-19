import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/admin/login',
    name: 'Login',
    component: () => import('@/views/login/Login.vue'),
    meta: { title: '登录', public: true }
  },
  {
    path: '/',
    redirect: '/admin/dashboard/overview'
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('@/views/dashboard/Dashboard.vue'),
    redirect: '/admin/dashboard/overview',
    children: [
      // 兼容旧路径 /admin/dashboard 重定向
      {
        path: 'dashboard',
        redirect: '/admin/dashboard/overview'
      },
      // 数据概览
      {
        path: 'dashboard/overview',
        name: 'Overview',
        component: () => import('@/views/dashboard/Overview.vue'),
        meta: { title: '数据概览' }
      },

      // 商品管理
      {
        path: 'products',
        name: 'Products',
        component: () => import('@/views/admin/Products.vue'),
        meta: { title: '商品列表' }
      },
      {
        path: 'categories',
        name: 'Categories',
        component: () => import('@/views/admin/Categories.vue'),
        meta: { title: '分类管理' }
      },
      {
        path: 'reviews',
        name: 'Reviews',
        component: () => import('@/views/admin/Reviews.vue'),
        meta: { title: '评价管理' }
      },

      // 订单管理
      {
        path: 'orders',
        name: 'Orders',
        component: () => import('@/views/admin/Orders.vue'),
        meta: { title: '全部订单' }
      },
      {
        path: 'refunds',
        name: 'Refunds',
        component: () => import('@/views/admin/Refunds.vue'),
        meta: { title: '退款售后' }
      },

      // 用户管理
      {
        path: 'users',
        name: 'Users',
        component: () => import('@/views/admin/Users.vue'),
        meta: { title: '用户管理' }
      },

      // 日志管理
      {
        path: 'logs',
        name: 'Logs',
        component: () => import('@/views/admin/Logs.vue'),
        meta: { title: '日志管理' }
      },

      // 系统设置
      {
        path: 'settings',
        name: 'Settings',
        component: () => import('@/views/admin/Settings.vue'),
        meta: { title: '系统设置' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫 - 登录校验
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')

  // 设置页面标题
  if (to.meta.title) {
    document.title = `${to.meta.title} - 星智购管理后台`
  }

  if (to.meta.public) {
    next()
  } else if (token) {
    next()
  } else {
    next('/admin/login')
  }
})

export default router
