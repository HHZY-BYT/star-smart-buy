# 星智购 (StarSmart Buy)

> 🤖 AI 驱动的 3C 数码电商平台 — 微信小程序 + Vue 3 管理后台 + Spring Boot 后端

[![Java 21](https://img.shields.io/badge/Java-21-orange?style=flat-square&logo=openjdk)](https://openjdk.org/)
[![Spring Boot 3](https://img.shields.io/badge/Spring_Boot-3.5.9-green?style=flat-square&logo=springboot)](https://spring.io/)
[![MyBatis-Plus](https://img.shields.io/badge/MyBatis--Plus-3.5.7-blue?style=flat-square)](https://baomidou.com/)
[![Vue 3](https://img.shields.io/badge/Vue-3.x-4fc08d?style=flat-square&logo=vuedotjs)](https://vuejs.org/)
[![微信小程序](https://img.shields.io/badge/微信小程序-原生-viridian?style=flat-square&logo=wechat)](https://developers.weixin.qq.com/miniprogram/)
[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479a1?style=flat-square&logo=mysql)](https://www.mysql.com/)
[![Redis](https://img.shields.io/badge/Redis-latest-dc382d?style=flat-square&logo=redis)](https://redis.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)](LICENSE)

---

## 📑 目录

- [项目简介](#-项目简介)
- [功能特性](#-功能特性)
- [技术栈](#-技术栈)
- [项目结构](#-项目结构)
- [快速开始](#-快速开始)
- [数据库设计](#-数据库设计)
- [API 文档](#-api-文档)

- [开发说明](#-开发说明)
- [开源协议](#-开源协议)

---

## 🎯 项目简介

**星智购** 是一个功能完整的 3C 数码电商平台，集成了 AI 智能导购能力。系统采用前后端分离架构，包含 **微信小程序客户端**、**Vue 3 管理后台** 和 **Spring Boot 后端服务** 三部分，覆盖电商全链路业务场景。

> **适用场景**：课程设计 / 毕业设计参考、电商全链路学习、AI 集成实践、二次开发基础

**v1.0 已完成**：核心电商闭环（浏览→下单→支付→收货→评价→退款），AI 导购可用。支付为模拟模式，生产环境需接入真实微信支付。

---

## ✨ 功能特性

### 微信小程序（用户端）

| 模块 | 功能 |
|------|------|
| **登录认证** | 微信一键登录、手机号验证码登录（模拟验证码 123456） |
| **商品浏览** | 首页轮播图+公告+推荐、树形分类、搜索、商品详情（图文+规格+评价） |
| **购物车** | 添加/修改数量/删除、全选/反选、批量结算、数量角标 |
| **订单管理** | 创建订单、模拟支付、取消订单、确认收货、申请退款、状态筛选 |
| **收货地址** | 新增/编辑/删除/设为默认地址 |
| **商品评价** | 已完订单发表评价（评分+文字）、评价列表、我的评价 |
| **AI 助手** | 智能问答、需求推荐、会话上下文记忆 |
| **个人中心** | 昵称/手机/头像修改、订单统计 |

### Web 管理后台（Vue 3 + Element Plus）

| 模块 | 功能 |
|------|------|
| **数据概览** | 销售趋势图、订单状态分布、退款统计 |
| **商品管理** | CRUD、规格管理、上下架、分类管理 |
| **订单管理** | 发货、退款审核、状态流转 |
| **用户管理** | 用户列表、角色分配 |
| **内容管理** | 轮播图管理、公告管理 |
| **AI 配置** | 支持 DeepSeek / OpenAI / 智谱 / 通义千问 / 月之暗面 / 讯飞星火，后台一键切换 |
| **权限管理** | RBAC 角色+动态菜单，提升系统安全性 |
| **操作日志** | AOP 自动记录管理端所有操作，支持按模块/操作人/时间筛选 |

### 后端服务（Spring Boot 3）

- RESTful API 设计，统一响应格式
- JWT 双角色认证（用户 + 管理员，HS384 签名）
- MyBatis-Plus 简化 CRUD
- Redis 缓存支持
- WebSocket 实时通知
- 文件上传（图片）
- 全局异常处理
- AOP 操作日志

---

## 🛠 技术栈

| 层级 | 技术 |
|------|------|
| **小程序端** | 微信小程序原生框架、WXML/WXSS |
| **管理后台** | Vue 3 + Vite + Element Plus + Pinia + ECharts + Axios |
| **后端** | Spring Boot 3.5.9 + MyBatis-Plus 3.5.7 + JWT (jjwt 0.12.6) |
| **数据库** | MySQL 8.0 + Redis |
| **AI 集成** | DeepSeek / OpenAI 兼容接口 |
| **其他** | Hutool、Lombok、Spring Security Crypto、WebSocket |

---

## 📂 项目结构

简单画一下三个模块各自负责什么、代码大概放在哪：

### 🖥 后端 `backend/star-smart-buy-backend/`
Java 21 + Spring Boot 3.5.9，Maven 构建，分层就是经典的 controller → service → mapper 那一套。

| 包 / 目录 | 干嘛的 |
|---|---|
| `controller/` | 接口层，分了用户端和管理端两套 API，20+ 个 Controller |
| `service/` | 业务逻辑，每个模块都有对应的接口 + 实现类 |
| `mapper/` | MyBatis-Plus 的 Mapper，直接和数据库打交道 |
| `entity/` | 实体类，13 张表一个个建好的 |
| `dto/` | 几个登录、下单、AI 聊天用的传参对象 |
| `common/` | 统一返回格式 `Result`、分页封装、自定义异常 |
| `config/` | 各种配置：JWT、Redis、WebSocket、CORS、安全加密等 |
| `annotation/` + `aspect/` | 自定义 `@OperLog` 注解 + AOP 自动记操作日志 |
| `interceptor/` | JWT 拦截器，解析 token、判断用户 or 管理员 |
| `resources/sql/` | 建库脚本（`star_smart_buy.sql`）+ 测试数据（`star_smart_buy_test.sql`） |
| `resources/application.yml` | 所有配置都在这，数据库、Redis、JWT、文件上传等 |

### 🎨 管理后台 `backend/star-smart-buy-admin/`
Vue 3 + Vite + Element Plus + Pinia + ECharts，`npm run dev` 启动。

| 目录 | 干嘛的 |
|---|---|
| `views/login/` | 管理员登录页 |
| `views/dashboard/` | 首页数据概览、销售趋势图 |
| `views/admin/` | 商品管理、订单管理、用户管理、分类、轮播图、公告、退款审核、评价管理、AI 配置、操作日志 |
| `api/` | axios 封装 + 各模块的 API 调用 |
| `store/` | Pinia 存管理员登录态 |
| `router/` | 动态路由，根据角色权限加载菜单 |
| `components/` | 复用的表格、表单、弹窗组件 |
| `vite.config.js` | 代理配置，把 `/api` 转发到后端 8080 |

### 📱 微信小程序 `miniprogram/`
原生框架，一共 15 个页面，AppID 在 `project.config.json` 里改。

| 页面 | 路径 |
|---|---|
| 首页 | `pages/index/` |
| 分类 | `pages/category/` |
| 搜索 | `pages/search/` |
| 商品详情 | `pages/product/` |
| 购物车 | `pages/cart/` |
| 创建订单 | `pages/create-order/` |
| 订单列表 | `pages/order/` |
| 订单详情 | `pages/order-detail/` |
| 收货地址 | `pages/address/` |
| 编辑地址 | `pages/address-edit/` |
| 发表评价 | `pages/review/` |
| 我的评价 | `pages/my-reviews/` |
| 退款申请 | `pages/refund/` |
| AI 助手 | `pages/ai-chat/` |
| 个人中心 | `pages/user/` |
| API 封装 | `api/` 目录下按模块拆了 7 个 js 文件 |
| 工具函数 | `utils/request.js` 封装 wx.request，`utils/util.js` 杂项工具 |

### 🧩 其他
- `docx_lib/` — 一个独立的 Word 文档生成库，管理端导出报表用，不算项目主体代码
- `.gitignore` — 全局忽略 node_modules、target、uploads、.idea 等

---

## 🚀 快速开始

### 环境要求

| 软件 | 最低版本 | 说明 |
|------|---------|------|
| JDK | 21+ | 推荐 [Eclipse Temurin](https://adoptium.net/) |
| Maven | 3.8+ | 后端构建 |
| MySQL | 8.0+ | 数据库（默认端口 3307） |
| Redis | 6.0+ | 缓存（可选，不启动也能跑） |
| Node.js | 18+ | 管理后台构建 |
| 微信开发者工具 | 最新稳定版 | 小程序调试 |

### 第一步：启动后端

```bash
# 1. 导入数据库
# 用 MySQL 客户端执行：
CREATE DATABASE star_smart_buy DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE star_smart_buy;
SOURCE backend/star-smart-buy-backend/src/main/resources/sql/star_smart_buy.sql;

# 2. 修改数据库连接信息（如需要）
# 编辑 backend/star-smart-buy-backend/src/main/resources/application.yml
# 修改 spring.datasource.url / username / password

# 3. 启动后端
cd backend/star-smart-buy-backend
mvn spring-boot:run
```

后端启动后访问 http://localhost:8080/api 查看 Swagger（如有集成）。

### 第二步：启动管理后台

```bash
cd backend/star-smart-buy-admin
npm install
npm run dev
```

访问 http://localhost:5173（Vite 默认端口）。

### 第三步：运行小程序

用微信开发者工具打开 miniprogram/ 目录，选择对应的 AppID 进行调试。

---

## 🗄 数据库设计

### ER 核心表

| 表名 | 说明 |
|------|------|
| user | 用户表 |
| product | 商品表 |
| product_category | 商品分类表 |
| product_spec | 商品规格表 |
| shopping_cart | 购物车表 |
| order | 订单表 |
| order_item | 订单明细表 |
| address | 收货地址表 |
| product_review | 商品评价表 |
| efund | 退款申请表 |
| banner | 轮播图表 |
| 
otice | 公告表 |
| 
otification | 通知表 |
| ai_config | AI 配置表 |
| operation_log | 操作日志表 |
| admin | 管理员表 |

完整建表语句见 backend/star-smart-buy-backend/src/main/resources/sql/star_smart_buy.sql

---

## 📡 API 文档

### 用户端接口（小程序）

| 模块 | 路径前缀 | 说明 |
|------|---------|------|
| 认证 | /auth/ | 登录、注册、验证码 |
| 用户 | /user/ | 个人信息、头像 |
| 商品 | /product/ | 商品列表、详情、搜索 |
| 分类 | /category/ | 分类树 |
| 购物车 | /cart/ | 增删改查 |
| 订单 | /order/ | 创建、列表、详情、取消 |
| 地址 | /address/ | CRUD、设默认 |
| 评价 | /review/ | 发表、列表 |
| 退款 | /refund/ | 申请、列表 |
| AI | /ai/ | 智能对话 |
| 首页 | /home/ | 轮播图、公告、推荐 |

### 管理后台接口（Admin）

| 模块 | 路径前缀 | 说明 |
|------|---------|------|
| 登录 | /admin/auth/ | 管理员登录 |
| 商品 | /admin/product/ | CRUD、上下架 |
| 分类 | /admin/category/ | 树形管理 |
| 订单 | /admin/order/ | 发货、退款审核 |
| 用户 | /admin/user/ | 用户列表、角色分配 |
| 轮播图 | /admin/banner/ | CRUD |
| 公告 | /admin/notice/ | CRUD |
| AI 配置 | /admin/ai-config/ | 模型切换 |
| 操作日志 | /admin/log/ | 查询 |
| 统计 | /admin/statistics/ | 数据概览 |

---

## 📝 开发说明

### 默认账号

| 角色 | 账号 | 密码 |
|------|------|------|
| 管理员 | admin | admin123 (BCrypt 加密) |
| 小程序用户 | 微信一键登录 / 手机号+验证码 | 验证码 123456 |

### 配置说明

- **数据库端口**：默认 3307，如需改为 3306，请修改 application.yml
- **JWT Secret**：默认值仅用于开发，生产环境请更换
- **文件上传**：默认上传至 uploads/ 目录
- **AI 提供商**：在管理后台「AI 配置」中切换，支持 DeepSeek / OpenAI / 智谱 / 通义千问 / 月之暗面 / 讯飞星火

### 常见问题

| 问题 | 解决方案 |
|------|---------|
| 后端启动报数据库连接错误 | 检查 MySQL 是否运行，端口/用户名/密码是否正确 |
| 管理后台白屏 | 检查后端是否启动，vite.config.js 中的 proxy 是否指向正确地址 |
| 小程序接口请求失败 | 检查 miniprogram/utils/request.js 中的 baseUrl 是否正确 |
| 文件上传失败 | 确保 uploads/ 目录有写入权限 |

---

## 📜 开源协议

本项目基于 **[MIT License](LICENSE)** 开源，欢迎 Star / Fork / PR。

---

**Made with ❤️ by StarSmart Buy Team · v1.0**
