/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80045 (8.0.45)
 Source Host           : localhost:3307
 Source Schema         : star_smart_buy

 Target Server Type    : MySQL
 Target Server Version : 80045 (8.0.45)
 File Encoding         : 65001

 Date: 15/06/2026 13:18:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `receiver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收货人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '手机号',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '区',
  `detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '详细地址',
  `is_default` tinyint NULL DEFAULT 0 COMMENT '是否默认 0-否 1-是',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '收货地址表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 5, '何智泳', '15278752329', '北京市', '北京市', '东城区', '北京大学', 1, '2026-06-14 20:06:07', '2026-06-14 20:06:07');

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'admin' COMMENT '角色',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
-- 密码：admin123（BCrypt 加密）
INSERT INTO `admin` VALUES (1, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'superadmin', '2026-06-14 19:57:57');

-- ----------------------------
-- Table structure for ai_config
-- ----------------------------
DROP TABLE IF EXISTS `ai_config`;
CREATE TABLE `ai_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'AI服务提供商: deepseek/openai/zhipu/qwen/moonshot/spark',
  `api_key` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'API Key',
  `base_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'API Base URL',
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '模型名称',
  `temperature` double NULL DEFAULT 0.7 COMMENT '温度参数',
  `max_tokens` int NULL DEFAULT 2048 COMMENT '最大token数',
  `system_prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '系统提示词',
  `is_active` tinyint NULL DEFAULT 1 COMMENT '是否启用: 0-禁用 1-启用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ai_config
-- ----------------------------
INSERT INTO `ai_config` VALUES (2, 'deepseek', 'your-api-key-here', 'https://api.deepseek.com', 'deepseek-chat', 0.7, 2048, '你是星智购的智能导购助手，专门帮助用户推荐和销售3C数码产品。请用简洁专业的语气回答。', 1, '2026-06-14 21:20:33', '2026-06-14 21:20:33');

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '图片URL',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '标题',
  `link` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '' COMMENT '跳转链接',
  `sort` int NULL DEFAULT 0 COMMENT '排序（越小越靠前）',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 1-显示, 0-隐藏',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, 'https://img95.699pic.com/photo/40245/0705.jpg_wh860.jpg', '新品上市', '', 1, 1, '2026-06-14 21:36:55', '2026-06-14 23:30:21');
INSERT INTO `banner` VALUES (2, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/458430/15/3518/99230/6a2e81f9F58b898c6/008332032012ca09.jpg!q70.dpg', '限时特惠', '', 2, 1, '2026-06-14 21:36:55', '2026-06-14 22:06:37');
INSERT INTO `banner` VALUES (3, 'http://localhost:8080/api/uploads/9eec2d71eed44460b35fe630ee204900.jpg', '热门推荐', '', 3, 1, '2026-06-14 21:36:55', '2026-06-14 21:51:40');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '公告内容',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 1-显示, 0-隐藏',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '欢迎来到星智购', '星智购 — 您的智能3C数码购物平台，正品保障，极速发货！', 1, '2026-06-14 21:36:55', '2026-06-14 21:36:55');
INSERT INTO `notice` VALUES (2, '新用户专享优惠', '注册即送50元优惠券，首单满100减20！', 1, '2026-06-14 21:36:55', '2026-06-14 21:58:38');

-- ----------------------------
-- Table structure for notification
-- ----------------------------
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `receiver_id` bigint NOT NULL COMMENT '接收者ID（管理员ID）',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '通知标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '通知内容',
  `read_status` tinyint NULL DEFAULT 0 COMMENT '是否已读: 0-未读, 1-已读',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'system' COMMENT '通知类型: order-订单通知, refund-退款通知, system-系统通知',
  `related_id` bigint NULL DEFAULT NULL COMMENT '关联数据ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_receiver`(`receiver_id` ASC) USING BTREE,
  INDEX `idx_read_status`(`read_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notification
-- ----------------------------
INSERT INTO `notification` VALUES (5, 1, '退款申请通知', '用户申请退款，订单号：ORD1781439946604，金额：¥9999.0', 1, 'refund', 10, '2026-06-14 22:23:12');
INSERT INTO `notification` VALUES (6, 1, '新订单通知', '用户下单，订单号：ORD1781447634415，金额：¥9999.0', 1, 'order', 13, '2026-06-14 22:33:54');
INSERT INTO `notification` VALUES (7, 1, '订单支付通知', '订单号：ORD1781447634415 已支付，金额：¥9999.0，请尽快发货', 1, 'order', 13, '2026-06-14 22:33:58');
INSERT INTO `notification` VALUES (8, 1, '新订单通知', '用户下单，订单号：ORD1781447810748，金额：¥6999.0', 1, 'order', 14, '2026-06-14 22:36:51');
INSERT INTO `notification` VALUES (9, 1, '订单支付通知', '订单号：ORD1781447810748 已支付，金额：¥6999.0，请尽快发货', 1, 'order', 14, '2026-06-14 22:37:00');
INSERT INTO `notification` VALUES (10, 1, '订单发货通知', '订单号：ORD1781447810748 已发货', 1, 'order', 14, '2026-06-14 22:37:27');
INSERT INTO `notification` VALUES (11, 1, '新评价通知', '用户对商品发表了评价，评分：5星', 1, 'system', 2, '2026-06-14 22:38:16');
INSERT INTO `notification` VALUES (12, 1, '订单发货通知', '订单号：ORD1781440974306 已发货', 1, 'order', 12, '2026-06-14 23:49:11');
INSERT INTO `notification` VALUES (13, 1, '新评价通知', '用户对商品发表了评价，评分：5星', 1, 'system', 3, '2026-06-14 23:50:28');
INSERT INTO `notification` VALUES (14, 1, '新订单通知', '用户下单，订单号：ORD1781452387027，金额：¥16999.0', 1, 'order', 15, '2026-06-14 23:53:07');
INSERT INTO `notification` VALUES (15, 1, '订单支付通知', '订单号：ORD1781452387027 已支付，金额：¥16999.0，请尽快发货', 1, 'order', 15, '2026-06-14 23:53:12');
INSERT INTO `notification` VALUES (16, 1, '订单支付通知', '订单号：ORD20240614004 已支付，金额：¥1899.0，请尽快发货', 1, 'order', 4, '2026-06-14 23:55:57');
INSERT INTO `notification` VALUES (17, 1, '订单发货通知', '订单号：ORD20240614004 已发货', 1, 'order', 4, '2026-06-14 23:56:06');
INSERT INTO `notification` VALUES (18, 1, '退款申请通知', '用户申请退款，订单号：ORD20240614004，金额：¥1899.0', 1, 'refund', 4, '2026-06-14 23:56:21');
INSERT INTO `notification` VALUES (19, 1, '退款申请通知', '用户申请退款，订单号：ORD20240614001，金额：¥9999.0', 1, 'refund', 1, '2026-06-14 23:57:36');

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作人名称',
  `operator_type` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'ADMIN' COMMENT '操作人类型: ADMIN-管理员, USER-用户',
  `operation_type` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型: CREATE/UPDATE/DELETE/LOGIN/EXPORT/IMPORT/OTHER',
  `module` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作模块: PRODUCT/ORDER/USER/CATEGORY/BANNER/NOTICE/REVIEW/REFUND/SETTING/AI/OTHER',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作描述',
  `method` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求方法',
  `request_url` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_method` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'HTTP请求方法',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '请求参数',
  `response_result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '返回结果',
  `ip` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `location` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '操作地点',
  `status` tinyint NULL DEFAULT 1 COMMENT '操作状态: 1-成功, 0-失败',
  `error_msg` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `cost_time` bigint NULL DEFAULT NULL COMMENT '耗时(毫秒)',
  `user_agent` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '浏览器UA',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operator_id`(`operator_id` ASC) USING BTREE,
  INDEX `idx_operation_type`(`operation_type` ASC) USING BTREE,
  INDEX `idx_module`(`module` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNDUyMTEzLCJleHAiOjE3ODE1Mzg1MTN9.4_TGVezfy6iggi1P1tsIZ_ApM44XWw4dXFRKfJlT7rVECoCgWda-A1mXho6cL5sV\",\"username\":\"admin\"}}', '0:0:0:0:0:0:0:1', NULL, 1, NULL, 28, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 23:48:33');
INSERT INTO `operation_log` VALUES (2, 1, '张三', 'admin', 'UPDATE', 'ORDER', '订单发货', 'com.star.smartbuy.controller.AdminOrderController.ship', '/api/admin/orders/12/ship', 'PUT', '[12]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '0:0:0:0:0:0:0:1', NULL, 1, NULL, 27, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 23:49:11');
INSERT INTO `operation_log` VALUES (3, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNDUyMzM3LCJleHAiOjE3ODE1Mzg3Mzd9.tGvA31tEpme4jP5bpluxPPjI0Dv9Br1doMFHf86e26zxhaiNCk1nKgLOA-dEvhRY\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 25, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 23:52:17');
INSERT INTO `operation_log` VALUES (4, 1, '张三', 'admin', 'UPDATE', 'ORDER', '订单发货', 'com.star.smartbuy.controller.AdminOrderController.ship', '/api/admin/orders/4/ship', 'PUT', '[4]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 9, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 23:56:06');
INSERT INTO `operation_log` VALUES (5, 1, '张三', 'admin', 'UPDATE', 'REFUND', '处理退款', 'com.star.smartbuy.controller.AdminRefundController.process', '/api/admin/refunds/4/process', 'PUT', '[4,{\"status\":1,\"reason\":\"同意退款\"}]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 14, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 23:56:36');
INSERT INTO `operation_log` VALUES (6, 1, '张三', 'admin', 'UPDATE', 'REFUND', '处理退款', 'com.star.smartbuy.controller.AdminRefundController.process', '/api/admin/refunds/5/process', 'PUT', '[5,{\"status\":1,\"reason\":\"同意退款\"}]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 29, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-14 23:57:53');
INSERT INTO `operation_log` VALUES (7, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNDUzMTM3LCJleHAiOjE3ODE1Mzk1Mzd9.YebvH6sQ7FsAK7mJ59D2T92g2e7ba2SsFLfl7RA11mml1q9SOo0dOrajr1iV1jSn\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 16, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 00:05:37');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `spec_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格名',
  `spec_value` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格值',
  `spec_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '多规格ID（逗号分隔）',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `quantity` int NOT NULL COMMENT '数量',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计',
  `product_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品图片',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 1, 1, 'iPhone 15 Pro Max 256GB', NULL, NULL, 9999.00, 1, 9999.00);
INSERT INTO `order_item` VALUES (2, 2, 2, '小米14 Ultra 512GB', NULL, NULL, 6999.00, 1, 6999.00);
INSERT INTO `order_item` VALUES (3, 3, 4, 'MacBook Pro 14寸 M3 Pro', NULL, NULL, 16999.00, 1, 16999.00);
INSERT INTO `order_item` VALUES (5, 5, 5, 'ThinkPad X1 Carbon 2024', NULL, NULL, 12999.00, 1, 12999.00);
INSERT INTO `order_item` VALUES (7, 9, 2, '小米14 Ultra 512GB', NULL, NULL, 6999.00, 1, 6999.00);
INSERT INTO `order_item` VALUES (9, 11, 10, '小米路由器AX9000', NULL, NULL, 599.00, 1, 599.00);
INSERT INTO `order_item` VALUES (10, 12, 3, '华为Mate 60 Pro 512GB', NULL, NULL, 7999.00, 1, 7999.00);
INSERT INTO `order_item` VALUES (12, 14, 2, '小米14 Ultra 512GB', NULL, NULL, 6999.00, 1, 6999.00);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额',
  `status` tinyint NULL DEFAULT 0 COMMENT '0-待付款 1-已付款 2-已发货 3-已完成 4-已取消 5-已退款',
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '收货地址',
  `consignee` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '收货人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '联系电话',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '备注',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 'ORD20240614001', 1, 9999.00, 5, '北京市朝阳区建国路88号', '张三', '13800138001', NULL, NULL, '2024-06-14 10:30:00', '2026-06-14 23:57:53');
INSERT INTO `orders` VALUES (2, 'ORD20240614002', 2, 6999.00, 2, '上海市浦东新区世纪大道100号', '李四', '13800138002', NULL, NULL, '2024-06-14 09:15:00', '2026-06-14 19:57:57');
INSERT INTO `orders` VALUES (3, 'ORD20240614003', 3, 16999.00, 3, '广州市天河区珠江新城', '王五', '13800138003', NULL, NULL, '2024-06-13 16:20:00', '2026-06-14 19:57:57');
INSERT INTO `orders` VALUES (5, 'ORD20240614005', 4, 12999.00, 1, '深圳市南山区科技园', '赵六', '13800138004', NULL, NULL, '2024-06-11 14:30:00', '2026-06-14 19:57:57');
INSERT INTO `orders` VALUES (11, 'ORD1781440793967', 5, 599.00, 1, '北京市北京市东城区北京大学', '何智泳', '15278752329', '哇哟', NULL, '2026-06-14 20:39:54', '2026-06-14 20:39:59');
INSERT INTO `orders` VALUES (12, 'ORD1781440974306', 5, 7999.00, 3, '北京市北京市东城区北京大学', '何智泳', '15278752329', '给我好一点的', NULL, '2026-06-14 20:42:54', '2026-06-14 23:49:57');
INSERT INTO `orders` VALUES (14, 'ORD1781447810748', 5, 6999.00, 3, '北京市北京市东城区北京大学', '何智泳', '15278752329', '给我弄大一点', '2026-06-14 22:37:00', '2026-06-14 22:36:51', '2026-06-14 22:37:39');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `category_id` bigint NOT NULL COMMENT '分类ID',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `stock` int NOT NULL DEFAULT 0 COMMENT '库存',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '图片URL，多个逗号分隔',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '商品描述',
  `status` tinyint NULL DEFAULT 1 COMMENT '0-下架 1-上架',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, 'iPhone 15 Pro Max 256GB', 7, 9999.00, 51, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/453802/31/7554/160573/6a2c5c3cFd25178ef/0083320320998bd9.jpg!q70.dpg', '苹果旗舰手机，A17 Pro芯片，钛金属边框', 1, '2026-06-14 19:57:57', '2026-06-14 23:34:05');
INSERT INTO `product` VALUES (2, '小米14 Ultra 512GB', 7, 6999.00, 98, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/318827/18/1068/65654/6826d8a7Fe4220735/3bc78c7e561ff76d.jpg!q70.dpg', '徕卡影像，骁龙8 Gen3处理器', 1, '2026-06-14 19:57:57', '2026-06-14 23:34:26');
INSERT INTO `product` VALUES (3, '华为Mate 60 Pro 512GB', 7, 7999.00, 79, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/436806/29/980/68168/6a04496dF9bf54f89/008332032086073f.jpg!q70.dpg', '麒麟9000S芯片，卫星通话', 1, '2026-06-14 19:57:57', '2026-06-14 23:35:58');
INSERT INTO `product` VALUES (4, 'MacBook Pro 14寸 M3 Pro', 9, 16999.00, 30, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/431012/34/11467/108326/6a014d28F27e9620b/008332032029fce2.jpg!q70.dpg', 'M3 Pro芯片，18小时续航', 1, '2026-06-14 19:57:57', '2026-06-14 23:35:34');
INSERT INTO `product` VALUES (5, 'ThinkPad X1 Carbon 2024', 9, 12999.00, 45, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/404660/24/11813/115190/69ba75e2F2943fea6/00833203207a6d1d.jpg!q70.dpg', 'Intel酷睿Ultra处理器，轻薄商务本', 1, '2026-06-14 19:57:57', '2026-06-14 23:35:00');
INSERT INTO `product` VALUES (6, 'iPad Pro 12.9寸 M2', 11, 9299.00, 60, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/451954/18/2419/107871/6a22365eF203ad4de/0083320320cb2126.jpg!q70.dpg', 'M2芯片，Liquid视网膜XDR屏', 1, '2026-06-14 19:57:57', '2026-06-14 23:34:44');
INSERT INTO `product` VALUES (7, '索尼A7M4微单相机', 3, 16999.00, 25, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/424690/25/16104/114553/69f1b03cF60707c27/025815e15e064d70.jpg!q70.dpg', '3300万像素，全画幅微单', 1, '2026-06-14 19:57:57', '2026-06-14 22:58:01');
INSERT INTO `product` VALUES (8, 'Apple Watch Ultra 2', 4, 6499.00, 70, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/427623/8/1251/72174/69ede283Fdf556acf/00833203207c99d1.jpg!q70.dpg', '钛金属表壳，100米防水', 1, '2026-06-14 19:57:57', '2026-06-14 22:57:32');
INSERT INTO `product` VALUES (9, 'AirPods Pro 2代', 5, 1899.00, 201, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/440024/36/6983/37972/6a1458f4F5a14de58/0083320320da4a31.jpg!q70.dpg', '主动降噪，空间音频', 1, '2026-06-14 19:57:57', '2026-06-14 22:56:42');
INSERT INTO `product` VALUES (10, '小米路由器AX9000', 6, 599.00, 149, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/153191/8/44378/50765/665868e3Fb589f122/6a5cd299d9d9a21c.jpg!q70.dpg', '三频WiFi6，9000Mbps', 1, '2026-06-14 19:57:57', '2026-06-14 22:56:24');
INSERT INTO `product` VALUES (11, 'iPhone 17 Pro Max 512GB', 1, 7999.90, 50, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/432537/22/3952/63615/69fc6b22F9c0c76fe/0083320320877fd6.png!q70.dpg', '苹果旗舰手机，A18 Pro芯片', 1, '2026-06-14 22:49:16', '2026-06-14 23:33:21');

-- ----------------------------
-- Table structure for product_category
-- ----------------------------
DROP TABLE IF EXISTS `product_category`;
CREATE TABLE `product_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父分类ID，0表示顶级',
  `sort` int NULL DEFAULT 0 COMMENT '排序',
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '图标',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 1-显示, 0-隐藏',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_category
-- ----------------------------
INSERT INTO `product_category` VALUES (1, '手机通讯', 0, 1, 'Cellphone', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (2, '电脑办公', 0, 2, 'Monitor', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (3, '摄影器材', 0, 3, 'Camera', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (4, '智能穿戴', 0, 4, 'Watch', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (5, '音频设备', 0, 5, 'Headset', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (6, '配件周边', 0, 6, 'Connection', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (7, '智能手机', 1, 1, 'Cellphone', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (8, '功能手机', 1, 2, 'Cellphone', 0, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (9, '笔记本电脑', 2, 1, 'Monitor', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (10, '台式机', 2, 2, 'Monitor', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (11, '平板电脑', 2, 3, 'Monitor', 1, '2026-06-14 19:57:57');

-- ----------------------------
-- Table structure for product_review
-- ----------------------------
DROP TABLE IF EXISTS `product_review`;
CREATE TABLE `product_review`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
  `rating` tinyint NOT NULL COMMENT '评分 1-5',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '评价内容',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '评价图片，多个逗号分隔',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `reply` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '管理员回复',
  `reply_time` datetime NULL DEFAULT NULL COMMENT '回复时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品评价表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_review
-- ----------------------------
INSERT INTO `product_review` VALUES (1, 2, 5, '钱七', 5, '非常好用', NULL, '2026-06-14 22:38:16', '好用多用啊', '2026-06-14 23:18:06');
INSERT INTO `product_review` VALUES (2, 3, 5, '钱七', 5, '超级好的手机', 'http://localhost:8080/api/uploads/d422e7bf40c7431a8d43682c59260e2e.jpg', '2026-06-14 23:50:28', NULL, NULL);

-- ----------------------------
-- Table structure for product_spec
-- ----------------------------
DROP TABLE IF EXISTS `product_spec`;
CREATE TABLE `product_spec`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `spec_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格名，如颜色',
  `spec_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '规格值，如黑色',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品规格表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_spec
-- ----------------------------
INSERT INTO `product_spec` VALUES (25, 7, '套装', '单机身', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (26, 7, '套装', '24-70mm镜头套装', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (27, 8, '表壳', '钛金属', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (28, 8, '表壳', '铝金属', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (29, 9, '版本', 'MagSafe充电盒', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (30, 9, '版本', 'Lightning充电盒', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (31, 10, '颜色', '黑色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (32, 11, '颜色', '橙色', '2026-06-14 23:33:21');
INSERT INTO `product_spec` VALUES (33, 1, '颜色', '原色钛金属', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (34, 1, '颜色', '蓝色钛金属', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (35, 1, '颜色', '白色钛金属', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (36, 1, '内存', '256GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (37, 1, '内存', '512GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (38, 1, '内存', '1TB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (39, 2, '颜色', '黑色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (40, 2, '颜色', '白色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (41, 2, '内存', '256GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (42, 2, '内存', '512GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (43, 6, '颜色', '银色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (44, 6, '颜色', '深空灰', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (45, 6, '内存', '128GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (46, 6, '内存', '256GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (47, 5, '颜色', '黑色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (48, 5, '颜色', '银色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (49, 4, '颜色', '深空黑', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (50, 4, '颜色', '银色', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (51, 4, '内存', '18GB+512GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (52, 4, '内存', '36GB+1TB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (53, 3, '颜色', '雅丹黑', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (54, 3, '颜色', '南糯紫', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (55, 3, '内存', '256GB', '2026-06-14 22:53:29');
INSERT INTO `product_spec` VALUES (56, 3, '内存', '512GB', '2026-06-14 22:53:29');

-- ----------------------------
-- Table structure for refund
-- ----------------------------
DROP TABLE IF EXISTS `refund`;
CREATE TABLE `refund`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '关联订单ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `amount` decimal(10, 2) NOT NULL COMMENT '退款金额',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '退款原因',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '退款说明',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0-待处理, 1-已同意, 2-已拒绝',
  `process_time` datetime NULL DEFAULT NULL COMMENT '处理时间',
  `process_note` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '处理备注',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款/售后表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund
-- ----------------------------
INSERT INTO `refund` VALUES (1, 10, 'ORD1781439946604', 5, 9999.00, '不想要了', '不需要了', 1, '2026-06-14 22:25:47', '同意退款', '2026-06-14 22:23:12', '2026-06-14 22:23:12');
INSERT INTO `refund` VALUES (5, 1, 'ORD20240614001', 1, 9999.00, '不想要了', '我不需要了', 1, '2026-06-14 23:57:53', '同意退款', '2026-06-14 23:57:36', '2026-06-14 23:57:36');

-- ----------------------------
-- Table structure for shopping_cart
-- ----------------------------
DROP TABLE IF EXISTS `shopping_cart`;
CREATE TABLE `shopping_cart`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `spec_id` bigint NULL DEFAULT NULL COMMENT '规格ID',
  `quantity` int NOT NULL DEFAULT 1 COMMENT '数量',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------
INSERT INTO `shopping_cart` VALUES (1, 5, 1, NULL, 1, '2026-06-14 22:45:48', '2026-06-14 22:45:48');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `openid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信openid',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像URL',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 1-正常, 0-禁用',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'oTest001', '13800138001', '张三', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (2, 'oTest002', '13800138002', '李四', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (3, 'oTest003', '13800138003', '王五', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (4, 'oTest004', '13800138004', '赵六', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (5, 'oTest005', '13800138005', '钱七', 'http://localhost:8080/api/uploads/af4dc578c35a4c3d8102ba6f8087a611.png', 1, '2026-06-14 19:57:57', '2026-06-14 22:22:45');
INSERT INTO `user` VALUES (6, 'oTest006', '13800138006', '孙八', '', 0, '2026-06-14 19:57:57', '2026-06-14 19:57:57');

SET FOREIGN_KEY_CHECKS = 1;
