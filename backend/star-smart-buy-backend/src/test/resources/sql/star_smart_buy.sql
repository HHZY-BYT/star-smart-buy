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

 Date: 23/06/2026 17:23:19
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
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_address_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '收货地址表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 5, '何智泳', '15278752329', '北京市', '北京市', '东城区', '北京大学', 1, '2026-06-14 20:06:07', '2026-06-14 20:06:07');
INSERT INTO `address` VALUES (2, 7, '八宝粥', '15278751208', '北京市', '北京市', '朝阳区', '清华大学', 1, '2026-06-15 15:23:23', '2026-06-15 15:23:23');
INSERT INTO `address` VALUES (3, 8, '吴小丽', '13900000002', '上海市', '上海市', '浦东新区', '张江高科技园区科苑路', 1, '2026-05-18 14:30:00', '2026-05-18 14:30:00');
INSERT INTO `address` VALUES (4, 9, '郑小刚', '13900000003', '广东省', '广州市', '天河区', '天河北路233号中信广场', 1, '2026-05-19 10:40:00', '2026-05-19 10:40:00');
INSERT INTO `address` VALUES (5, 10, '王小芳', '13900000004', '广东省', '深圳市', '南山区', '科技园南区深圳大学', 1, '2026-05-19 16:55:00', '2026-05-19 16:55:00');
INSERT INTO `address` VALUES (6, 11, '冯志强', '13900000005', '江苏省', '南京市', '鼓楼区', '中山路321号南京大学', 1, '2026-05-20 08:20:00', '2026-05-20 08:20:00');
INSERT INTO `address` VALUES (7, 12, '陈美玲', '13900000006', '浙江省', '杭州市', '西湖区', '文三路浙江大学玉泉校区', 1, '2026-05-20 11:40:00', '2026-05-20 11:40:00');
INSERT INTO `address` VALUES (8, 13, '褚志华', '13900000007', '四川省', '成都市', '武侯区', '一环路南一段四川大学', 1, '2026-05-20 15:10:00', '2026-05-20 15:10:00');
INSERT INTO `address` VALUES (9, 14, '卫国强', '13900000008', '湖北省', '武汉市', '武昌区', '珞瑜路1037号华中科技大学', 1, '2026-05-21 09:35:00', '2026-05-21 09:35:00');
INSERT INTO `address` VALUES (10, 15, '蒋文龙', '13900000009', '陕西省', '西安市', '雁塔区', '太白南路西安交通大学', 1, '2026-05-21 13:50:00', '2026-05-21 13:50:00');
INSERT INTO `address` VALUES (11, 16, '沈雅琴', '13900000010', '江苏省', '苏州市', '姑苏区', '人民路苏州大学', 1, '2026-05-22 10:15:00', '2026-05-22 10:15:00');
INSERT INTO `address` VALUES (12, 17, '韩建国', '13900000011', '天津市', '天津市', '南开区', '卫津路94号南开大学', 1, '2026-05-22 14:40:00', '2026-05-22 14:40:00');
INSERT INTO `address` VALUES (13, 18, '杨雪梅', '13900000012', '湖南省', '长沙市', '岳麓区', '麓山南路湖南大学', 1, '2026-05-23 10:00:00', '2026-05-23 10:00:00');
INSERT INTO `address` VALUES (14, 19, '朱俊杰', '13900000013', '山东省', '济南市', '历下区', '文化东路山东大学', 1, '2026-05-23 16:30:00', '2026-05-23 16:30:00');
INSERT INTO `address` VALUES (15, 20, '秦晓燕', '13900000014', '福建省', '厦门市', '思明区', '思明南路厦门大学', 1, '2026-05-24 11:10:00', '2026-05-24 11:10:00');
INSERT INTO `address` VALUES (16, 21, '尤大海', '13900000015', '辽宁省', '大连市', '甘井子区', '中山路2号大连理工大学', 1, '2026-05-24 15:40:00', '2026-05-24 15:40:00');
INSERT INTO `address` VALUES (17, 22, '许文静', '13900000016', '安徽省', '合肥市', '蜀山区', '肥西路中国科学技术大学', 1, '2026-05-25 09:55:00', '2026-05-25 09:55:00');
INSERT INTO `address` VALUES (18, 23, '何建军', '13900000017', '江西省', '南昌市', '东湖区', '八一大道南昌大学', 1, '2026-05-25 14:25:00', '2026-05-25 14:25:00');
INSERT INTO `address` VALUES (19, 24, '吕志远', '13900000018', '重庆市', '重庆市', '沙坪坝区', '大学城南路重庆大学', 1, '2026-05-26 10:30:00', '2026-05-26 10:30:00');
INSERT INTO `address` VALUES (20, 25, '施丽娟', '13900000019', '云南省', '昆明市', '五华区', '翠湖北路云南大学', 1, '2026-05-26 16:05:00', '2026-05-26 16:05:00');
INSERT INTO `address` VALUES (21, 5, '何智泳', '15278752329', '广东省', '广州市', '越秀区', '中山五路76号', 0, '2026-06-14 20:10:00', '2026-06-14 20:10:00');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '$2b$10$EhAFKZii93y0sNlM5/9OiuSiHKg.KQ9rvwQH3ziz1IW5rDDoYi9dK', 'superadmin', '2026-06-14 19:57:57');

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_config
-- ----------------------------
INSERT INTO `ai_config` VALUES (2, 'deepseek', 'sk-fd3c4925f0194394a2998d6cdb4445b3', 'https://api.deepseek.com', 'deepseek-chat', 0.7, 2048, '你是星智购的智能导购助手，专门帮助用户推荐和销售3C数码产品。请用简洁专业的语气回答。', 1, '2026-06-14 21:20:33', '2026-06-14 21:20:33');

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '轮播图' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of banner
-- ----------------------------
INSERT INTO `banner` VALUES (1, 'https://img.alicdn.com/img/i1/106298829/O1CN01kB4U1q2F5k0lHpbO9_!!4611686018427387341-0-saturn_solar.jpg', '新品上市', '', 1, 1, '2026-06-14 21:36:55', '2026-06-21 19:22:47');
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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告' ROW_FORMAT = DYNAMIC;

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
  INDEX `idx_read_status`(`read_status` ASC) USING BTREE,
  CONSTRAINT `fk_notification_admin` FOREIGN KEY (`receiver_id`) REFERENCES `admin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '通知表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `notification` VALUES (20, 1, '新订单通知', '用户下单，订单号：ORD1781508943622，金额：¥4899.0', 1, 'order', 16, '2026-06-15 15:35:44');
INSERT INTO `notification` VALUES (21, 1, '订单支付通知', '订单号：ORD1781508943622 已支付，金额：¥4899.0', 1, 'order', 16, '2026-06-15 15:35:51');
INSERT INTO `notification` VALUES (22, 1, '订单发货通知', '订单号：ORD1781508943622 已发货', 1, 'order', 16, '2026-06-15 15:36:22');
INSERT INTO `notification` VALUES (23, 1, '确认收货通知', '订单号：ORD1781508943622 用户已确认收货', 1, 'order', 16, '2026-06-15 15:36:31');
INSERT INTO `notification` VALUES (24, 1, '新评价通知', '用户对商品发表了评价，评分：5星', 1, 'system', 12, '2026-06-15 15:36:58');
INSERT INTO `notification` VALUES (25, 1, '新订单通知', '用户下单，订单号：ORD1781510445121，金额：¥7999.0', 1, 'order', 17, '2026-06-15 16:00:45');
INSERT INTO `notification` VALUES (26, 1, '订单支付通知', '订单号：ORD1781510445121 已支付，金额：¥7999.0', 1, 'order', 17, '2026-06-15 16:00:49');
INSERT INTO `notification` VALUES (27, 1, '新订单通知', '用户下单，订单号：ORD20260521001，金额：¥11999.0', 1, 'order', 19, '2026-05-21 16:45:00');
INSERT INTO `notification` VALUES (28, 1, '订单支付通知', '订单号：ORD20260521001 已支付，金额：¥11999.0，请尽快发货', 1, 'order', 19, '2026-05-21 17:30:00');
INSERT INTO `notification` VALUES (29, 1, '订单发货通知', '订单号：ORD20260520001 已发货', 1, 'order', 18, '2026-05-22 09:00:00');
INSERT INTO `notification` VALUES (30, 1, '退款申请通知', '用户申请退款，订单号：ORD20260601001，金额：¥1999.0', 1, 'refund', 6, '2026-06-01 10:55:15');
INSERT INTO `notification` VALUES (31, 1, '退款申请通知', '用户申请退款，订单号：ORD20260602001，金额：¥8999.0', 1, 'refund', 7, '2026-06-02 15:25:30');
INSERT INTO `notification` VALUES (32, 1, '新订单通知', '用户下单，订单号：ORD20260613001，金额：¥3599.0', 1, 'order', 30, '2026-06-13 11:40:00');
INSERT INTO `notification` VALUES (33, 1, '订单支付通知', '订单号：ORD20260614001 已支付，金额：¥4299.0，请尽快发货', 1, 'order', 32, '2026-06-14 09:30:00');
INSERT INTO `notification` VALUES (34, 1, '系统公告', '618大促销活动即将开始，请及时上架商品', 1, 'system', NULL, '2026-06-15 08:00:00');
INSERT INTO `notification` VALUES (35, 1, '确认收货通知', '订单号：ORD20260613001 用户已确认收货', 1, 'order', 30, '2026-06-21 19:36:51');
INSERT INTO `notification` VALUES (36, 1, '新订单通知', '用户下单，订单号：ORD1782045217092，金额：¥8999.0', 1, 'order', 46, '2026-06-21 20:33:37');
INSERT INTO `notification` VALUES (37, 1, '订单支付通知', '订单号：ORD1782045217092 已支付，金额：¥8999.0', 1, 'order', 46, '2026-06-21 20:33:50');
INSERT INTO `notification` VALUES (38, 1, '订单发货通知', '订单号：ORD1782045217092 已发货', 1, 'order', 46, '2026-06-21 20:34:26');
INSERT INTO `notification` VALUES (39, 1, '确认收货通知', '订单号：ORD1782045217092 用户已确认收货', 1, 'order', 46, '2026-06-21 20:34:46');
INSERT INTO `notification` VALUES (40, 1, '新评价通知', '用户对商品发表了评价，评分：5星', 1, 'system', 24, '2026-06-21 20:35:23');

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
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  CONSTRAINT `fk_operation_log_admin` FOREIGN KEY (`operator_id`) REFERENCES `admin` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 63 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '操作日志表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `operation_log` VALUES (8, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNTAyODAzLCJleHAiOjE3ODE1ODkyMDN9.lJedGUqFvC3ONv4m2_wP01melAf8EsklqXsy8k4NAupogY433SO5jYloRfvHdD1O\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 476, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 13:53:23');
INSERT INTO `operation_log` VALUES (9, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNTA0MDAyLCJleHAiOjE3ODE1OTA0MDJ9.drc2abMeyVQxY-PfVvOTURpVYkmee7gQO_7zGbVOTVY9NT4i3UL0AkKMh4OoPNnr\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 21, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 14:13:23');
INSERT INTO `operation_log` VALUES (10, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNTA0MDcwLCJleHAiOjE3ODE1OTA0NzB9.B4iHOPw8fXyBF0oYfQOyAnvB--hBGKv_0bm2Br80ogz6QieT4_KJk_7ZkKeUpmCL\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 23, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 14:14:30');
INSERT INTO `operation_log` VALUES (11, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNTA0MTQwLCJleHAiOjE3ODE1OTA1NDB9.1xxaOBAaVWoMhDYMnxfFctF9GjVGX_-9xanjEuH_1MeH2Tq-SfT2VF3jvSVUDGS4\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 3, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 14:15:40');
INSERT INTO `operation_log` VALUES (12, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgxNTA0Mjk1LCJleHAiOjE3ODE1OTA2OTV9.uD2YGFvlMP7jNBsdpVT-Xl9amAuV6PbtTAalCjB1zokDy4JvFcqmzYxSr_CcMCT0\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 4, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 14:18:16');
INSERT INTO `operation_log` VALUES (13, 1, '张三', 'admin', 'CREATE', 'PRODUCT', '添加商品', 'com.star.smartbuy.controller.AdminProductController.save', '/api/admin/products', 'POST', '[{\"id\":null,\"name\":\"vivo X300 Pro\",\"categoryId\":1,\"price\":4899.0,\"stock\":30,\"images\":\"https://gw.alicdn.com/imgextra/O1CN014JEbnD23opc5I0wIH_!!883737303-0-picasso.jpg_580x580q90.jpg_.webp\",\"description\":\"新品蔡司2亿APO超级长焦天玑9500拍照手机官方旗舰店官网\",\"status\":1,\"createdAt\":null,\"updatedAt\":null,\"categoryName\":null,\"specs\":[{\"id\":null,\"productId\":null,\"specName\":\"颜色\",\"specValue\":\"黑色\",\"createdAt\":null},{\"id\":null,\"productId\":null,\"specName\":\"内存\",\"specValue\":\"12+128\",\"createdAt\":null},{\"id\":null,\"productId\":null,\"specName\":\"内存\",\"specValue\":\"12+256\",\"createdAt\":null}]}]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 19, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 15:27:25');
INSERT INTO `operation_log` VALUES (14, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 15:33:57');
INSERT INTO `operation_log` VALUES (15, 1, '张三', 'admin', 'UPDATE', 'ORDER', '订单发货', 'com.star.smartbuy.controller.AdminOrderController.ship', '/api/admin/orders/16/ship', 'PUT', '[16]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 6, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 15:36:22');
INSERT INTO `operation_log` VALUES (16, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 107, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:14:30');
INSERT INTO `operation_log` VALUES (17, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 4, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:14:50');
INSERT INTO `operation_log` VALUES (18, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 5, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:15:09');
INSERT INTO `operation_log` VALUES (19, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 3, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:15:23');
INSERT INTO `operation_log` VALUES (20, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 3, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:15:34');
INSERT INTO `operation_log` VALUES (21, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 4, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:15:57');
INSERT INTO `operation_log` VALUES (22, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 5, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:16:53');
INSERT INTO `operation_log` VALUES (23, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin1\",\"password\":\"admin1\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 3, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:16:56');
INSERT INTO `operation_log` VALUES (24, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 3, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:18:07');
INSERT INTO `operation_log` VALUES (25, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 3, 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '2026-06-21 19:18:14');
INSERT INTO `operation_log` VALUES (26, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 4, 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '2026-06-21 19:18:21');
INSERT INTO `operation_log` VALUES (27, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":401,\"message\":\"用户名或密码错误\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 323, 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '2026-06-21 19:18:40');
INSERT INTO `operation_log` VALUES (28, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgyMDQwOTAwLCJleHAiOjE3ODIxMjczMDB9.PIDsYGrc0Hz1-M5bix1V4orqwcov6ulTtS0ghZDiOzp-lkOZdWSTvRIuDidMB9IN\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 148, 'Mozilla/5.0 (Linux; Android 15; Pixel 9) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '2026-06-21 19:21:40');
INSERT INTO `operation_log` VALUES (29, 1, '张三', 'admin', 'UPDATE', 'BANNER', '更新轮播图', 'com.star.smartbuy.controller.AdminBannerController.update', '/api/admin/banner', 'PUT', '[{\"id\":1,\"image\":\"https://img.alicdn.com/img/i1/106298829/O1CN01kB4U1q2F5k0lHpbO9_!!4611686018427387341-0-saturn_solar.jpg\",\"title\":\"新品上市\",\"link\":\"\",\"sort\":1,\"status\":1,\"createdAt\":null,\"updatedAt\":null}]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:22:47');
INSERT INTO `operation_log` VALUES (30, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 23, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:23:51');
INSERT INTO `operation_log` VALUES (31, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 12, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:24:19');
INSERT INTO `operation_log` VALUES (32, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 9, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:24:34');
INSERT INTO `operation_log` VALUES (33, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 17, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:24:48');
INSERT INTO `operation_log` VALUES (34, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:25:18');
INSERT INTO `operation_log` VALUES (35, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:25:35');
INSERT INTO `operation_log` VALUES (36, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 12, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:26:34');
INSERT INTO `operation_log` VALUES (37, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:26:45');
INSERT INTO `operation_log` VALUES (38, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:26:54');
INSERT INTO `operation_log` VALUES (39, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:27:10');
INSERT INTO `operation_log` VALUES (40, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:27:25');
INSERT INTO `operation_log` VALUES (41, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 12, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:27:47');
INSERT INTO `operation_log` VALUES (42, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 13, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:28:15');
INSERT INTO `operation_log` VALUES (43, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:28:28');
INSERT INTO `operation_log` VALUES (44, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 17, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:28:41');
INSERT INTO `operation_log` VALUES (45, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:29:19');
INSERT INTO `operation_log` VALUES (46, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 12, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:29:48');
INSERT INTO `operation_log` VALUES (47, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:29:59');
INSERT INTO `operation_log` VALUES (48, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 8, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:30:08');
INSERT INTO `operation_log` VALUES (49, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 9, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:30:17');
INSERT INTO `operation_log` VALUES (50, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:30:38');
INSERT INTO `operation_log` VALUES (51, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 15, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:31:06');
INSERT INTO `operation_log` VALUES (52, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 8, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:31:15');
INSERT INTO `operation_log` VALUES (53, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 9, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:31:30');
INSERT INTO `operation_log` VALUES (54, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:32:04');
INSERT INTO `operation_log` VALUES (55, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:32:16');
INSERT INTO `operation_log` VALUES (56, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 9, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:32:26');
INSERT INTO `operation_log` VALUES (57, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 10, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:32:36');
INSERT INTO `operation_log` VALUES (58, 1, '张三', 'admin', 'UPDATE', 'PRODUCT', '更新商品', 'com.star.smartbuy.controller.AdminProductController.update', '/api/admin/products', 'PUT', '参数序列化失败', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 11, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 19:32:48');
INSERT INTO `operation_log` VALUES (59, 1, '张三', 'admin', 'UPDATE', 'REFUND', '处理退款', 'com.star.smartbuy.controller.AdminRefundController.process', '/api/admin/refunds/10/process', 'PUT', '[10,{\"status\":1,\"reason\":\"同意退款\"}]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 24, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 20:34:18');
INSERT INTO `operation_log` VALUES (60, 1, '张三', 'admin', 'UPDATE', 'ORDER', '订单发货', 'com.star.smartbuy.controller.AdminOrderController.ship', '/api/admin/orders/46/ship', 'PUT', '[46]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 8, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 20:34:26');
INSERT INTO `operation_log` VALUES (61, 1, '张三', 'admin', 'UPDATE', 'REVIEW', '回复评价', 'com.star.smartbuy.controller.AdminReviewController.reply', '/api/admin/reviews/23/reply', 'PUT', '[23,{\"reply\":\"那当然了\"}]', '{\"code\":200,\"message\":\"success\",\"data\":null}', '127.0.0.1', NULL, 1, NULL, 6, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-21 20:35:51');
INSERT INTO `operation_log` VALUES (62, NULL, '匿名用户', 'ANONYMOUS', 'LOGIN', 'SETTING', '管理员登录', 'com.star.smartbuy.controller.AdminController.login', '/api/admin/login', 'POST', '[{\"username\":\"admin\",\"password\":\"admin123\"}]', '{\"code\":200,\"message\":\"success\",\"data\":{\"adminId\":1,\"token\":\"eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiIxIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzgyMjA0MDAxLCJleHAiOjE3ODIyOTA0MDF9.GzZ8dYA_nyhrndUkALVAhI9Zq5V3lanAfpyRqBkRX9QmTG6iG-v4qPT0KkhSjxCG\",\"username\":\"admin\"}}', '127.0.0.1', NULL, 1, NULL, 95, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-23 16:40:01');

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名称',
  `spec_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格名',
  `spec_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '规格值',
  `price` decimal(10, 2) NOT NULL COMMENT '单价',
  `quantity` int NOT NULL COMMENT '数量',
  `subtotal` decimal(10, 2) NOT NULL COMMENT '小计',
  `product_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '商品图片',
  `spec_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '多规格ID(逗号分隔)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order`(`order_id` ASC) USING BTREE,
  INDEX `fk_order_item_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单明细表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of order_item
-- ----------------------------
INSERT INTO `order_item` VALUES (1, 1, 1, 'iPhone 15 Pro Max 256GB', NULL, NULL, 9999.00, 1, 9999.00, NULL, NULL);
INSERT INTO `order_item` VALUES (2, 2, 2, '小米14 Ultra 512GB', NULL, NULL, 6999.00, 1, 6999.00, NULL, NULL);
INSERT INTO `order_item` VALUES (3, 3, 4, 'MacBook Pro 14寸 M3 Pro', NULL, NULL, 16999.00, 1, 16999.00, NULL, NULL);
INSERT INTO `order_item` VALUES (5, 5, 5, 'ThinkPad X1 Carbon 2024', NULL, NULL, 12999.00, 1, 12999.00, NULL, NULL);
INSERT INTO `order_item` VALUES (9, 11, 10, '小米路由器AX9000', NULL, NULL, 599.00, 1, 599.00, NULL, NULL);
INSERT INTO `order_item` VALUES (10, 12, 3, '华为Mate 60 Pro 512GB', NULL, NULL, 7999.00, 1, 7999.00, NULL, NULL);
INSERT INTO `order_item` VALUES (12, 14, 2, '小米14 Ultra 512GB', NULL, NULL, 6999.00, 1, 6999.00, NULL, NULL);
INSERT INTO `order_item` VALUES (14, 16, 12, 'vivo X300 Pro', '颜色', '黑色', 4899.00, 1, 4899.00, NULL, NULL);
INSERT INTO `order_item` VALUES (15, 17, 3, '华为Mate 60 Pro 512GB', '内存;颜色', '512GB;南糯紫', 7999.00, 1, 7999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/436806/29/980/68168/6a04496dF9bf54f89/008332032086073f.jpg!q70.dpg', '56,54');
INSERT INTO `order_item` VALUES (17, 20, 29, '佳能EOS R6 Mark II', '套装', '24-105mm套机', 16999.00, 1, 16999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (18, 21, 3, '华为Mate 60 Pro 512GB', NULL, NULL, 7999.00, 1, 7999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/436806/29/980/68168/6a04496dF9bf54f89/008332032086073f.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (19, 22, 38, '索尼WH-1000XM5', '颜色', '黑色', 2299.00, 1, 2299.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/236738/10/43097/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (20, 23, 33, 'Apple Watch Series 9', '颜色', '午夜色', 2999.00, 1, 2999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/236738/10/43097/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (21, 24, 39, 'Bose QuietComfort Ultra', '颜色', '黑色', 3299.00, 1, 3299.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (22, 25, 34, '华为Watch GT4', '颜色', '曜石黑', 1488.00, 1, 1488.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/236738/10/43097/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (23, 26, 17, '红米K70 Pro', '颜色', '晴雪', 2599.00, 1, 2599.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (24, 27, 24, '联想拯救者Y9000P', '颜色', '碳晶黑', 8999.00, 1, 8999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (25, 28, 35, '小米手环8 Pro', '颜色', '黑色', 399.00, 1, 399.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (26, 29, 37, 'AirPods Pro 2 USB-C版', '颜色', '白色', 1899.00, 1, 1899.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (27, 30, 28, '小米平板6 Max', '颜色', '黑色', 3599.00, 1, 3599.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (28, 31, 37, 'AirPods Pro 2 USB-C版', '颜色', '白色', 1899.00, 1, 1899.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (29, 32, 15, '魅族21 Pro', '颜色', '白色', 4299.00, 1, 4299.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (30, 33, 22, '戴尔XPS 15', '颜色', '铂金色', 13999.00, 1, 13999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (31, 34, 41, '罗技MX Master 3S鼠标', '颜色', '石墨灰', 799.00, 1, 799.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (32, 35, 1, 'iPhone 15 Pro Max 256GB', NULL, NULL, 9999.00, 1, 9999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/453802/31/7554/160573/6a2c5c3cFd25178ef/0083320320998bd9.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (33, 36, 32, '大疆Pocket 3', '套装', '标准套装', 3499.00, 1, 3499.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (34, 37, 12, 'OPPO Find X7 Ultra', '颜色', '钛金属黑', 5999.00, 1, 5999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (35, 38, 30, '索尼Alpha 7 IV', '套装', '28-70mm套机', 16999.00, 1, 16999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/236738/10/43097/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (36, 39, 35, '小米手环8 Pro', '颜色', '黑色', 399.00, 1, 399.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (37, 40, 9, 'AirPods Pro 2代', NULL, NULL, 1899.00, 1, 1899.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/440024/36/6983/37972/6a1458f4F5a14de58/0083320320da4a31.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (38, 41, 17, '红米K70 Pro', '颜色', '暗影', 2599.00, 1, 2599.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (39, 42, 13, 'vivo X100 Pro', '颜色', '月岩白', 4999.00, 1, 4999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/236738/10/43097/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (40, 43, 40, '森海塞尔Momentum 4', '颜色', '黑色', 1999.00, 1, 1999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/241250/15/41575/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (41, 44, 24, '联想拯救者Y9000P', '颜色', '碳晶黑', 8999.00, 1, 8999.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (42, 45, 19, '真我GT5 Pro', '颜色', '星夜', 2899.00, 1, 2899.00, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/240509/22/41720/180573/66d8f5c2Fb8a2e3d0/2d08e0a7739b62df.jpg!q70.dpg', NULL);
INSERT INTO `order_item` VALUES (43, 46, 24, '联想拯救者Y9000P', '颜色;内存', '冰魄白;16GB+1TB', 8999.00, 1, 8999.00, 'https://img.alicdn.com/img/O1CN015wpDwi1cTlm3lSpxg_!!4611686018427380930-2-item_pic.png', '251,252');

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
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '订单表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `orders` VALUES (16, 'ORD1781508943622', 7, 4899.00, 3, '北京市北京市朝阳区清华大学', '八宝粥', '15278751208', NULL, '2026-06-15 15:35:51', '2026-06-15 15:35:44', '2026-06-15 15:36:31');
INSERT INTO `orders` VALUES (17, 'ORD1781510445121', 7, 7999.00, 5, '北京市北京市朝阳区清华大学', '八宝粥', '15278751208', NULL, '2026-06-15 16:00:49', '2026-06-15 16:00:45', '2026-06-15 16:01:31');
INSERT INTO `orders` VALUES (18, 'ORD20260520001', 9, 4599.00, 3, '广东省广州市天河区天河北路233号中信广场', '郑小刚', '13900000003', '', '2026-05-20 11:20:00', '2026-05-20 10:30:45', '2026-05-24 18:00:00');
INSERT INTO `orders` VALUES (19, 'ORD20260521001', 10, 11999.00, 3, '广东省深圳市南山区科技园南区深圳大学', '王小芳', '13900000004', '公司采购', '2026-05-21 17:30:00', '2026-05-21 16:45:00', '2026-05-25 18:00:00');
INSERT INTO `orders` VALUES (20, 'ORD20260522001', 11, 16999.00, 3, '江苏省南京市鼓楼区中山路321号南京大学', '冯志强', '13900000005', '', '2026-05-22 09:45:00', '2026-05-22 08:12:30', '2026-05-26 18:00:00');
INSERT INTO `orders` VALUES (21, 'ORD20260523001', 12, 7999.00, 3, '浙江省杭州市西湖区文三路浙江大学玉泉校区', '陈美玲', '13900000006', '送女友', '2026-05-23 13:00:00', '2026-05-23 11:30:00', '2026-05-27 18:00:00');
INSERT INTO `orders` VALUES (22, 'ORD20260524001', 13, 2299.00, 5, '四川省成都市武侯区一环路南一段四川大学', '褚志华', '13900000007', '', '2026-05-24 16:20:00', '2026-05-24 15:00:20', '2026-06-21 20:34:18');
INSERT INTO `orders` VALUES (23, 'ORD20260525001', 14, 2999.00, 3, '湖北省武汉市武昌区珞瑜路1037号华中科技大学', '卫国强', '13900000008', '', '2026-05-25 10:15:00', '2026-05-25 09:25:00', '2026-05-29 18:00:00');
INSERT INTO `orders` VALUES (24, 'ORD20260526001', 15, 3299.00, 3, '陕西省西安市雁塔区太白南路西安交通大学', '蒋文龙', '13900000009', '送爸爸', '2026-05-26 14:30:00', '2026-05-26 13:40:15', '2026-05-30 18:00:00');
INSERT INTO `orders` VALUES (25, 'ORD20260527001', 16, 1488.00, 3, '江苏省苏州市姑苏区人民路苏州大学', '沈雅琴', '13900000010', '', '2026-05-27 11:45:00', '2026-05-27 10:05:40', '2026-05-31 18:00:00');
INSERT INTO `orders` VALUES (26, 'ORD20260610001', 17, 2599.00, 2, '天津市南开区卫津路94号南开大学', '韩建国', '13900000011', '加急', NULL, '2026-06-10 09:20:00', '2026-06-12 15:00:00');
INSERT INTO `orders` VALUES (27, 'ORD20260611001', 18, 8999.00, 2, '湖南省长沙市岳麓区麓山南路湖南大学', '杨雪梅', '13900000012', '', NULL, '2026-06-11 14:30:00', '2026-06-13 10:00:00');
INSERT INTO `orders` VALUES (28, 'ORD20260612001', 19, 399.00, 2, '山东省济南市历下区文化东路山东大学', '朱俊杰', '13900000013', '公司福利', NULL, '2026-06-12 10:15:00', '2026-06-14 09:00:00');
INSERT INTO `orders` VALUES (29, 'ORD20260612002', 20, 1999.00, 2, '福建省厦门市思明区思明南路厦门大学', '秦晓燕', '13900000014', '', NULL, '2026-06-12 16:20:00', '2026-06-14 11:00:00');
INSERT INTO `orders` VALUES (30, 'ORD20260613001', 21, 3599.00, 3, '辽宁省大连市甘井子区中山路2号大连理工大学', '尤大海', '13900000015', '', NULL, '2026-06-13 11:40:00', '2026-06-21 19:36:51');
INSERT INTO `orders` VALUES (31, 'ORD20260613002', 22, 1899.00, 1, '安徽省合肥市蜀山区肥西路中国科学技术大学', '许文静', '13900000016', '', '2026-06-13 15:00:00', '2026-06-13 14:20:00', '2026-06-13 15:00:00');
INSERT INTO `orders` VALUES (32, 'ORD20260614001', 23, 4299.00, 1, '江西省南昌市东湖区八一大道南昌大学', '何建军', '13900000017', '618活动下单', '2026-06-14 09:30:00', '2026-06-14 09:00:00', '2026-06-14 09:30:00');
INSERT INTO `orders` VALUES (33, 'ORD20260614002', 24, 13999.00, 1, '重庆市沙坪坝区大学城南路重庆大学', '吕志远', '13900000018', '', '2026-06-14 14:20:00', '2026-06-14 14:00:00', '2026-06-14 14:20:00');
INSERT INTO `orders` VALUES (34, 'ORD20260615001', 25, 799.00, 1, '云南省昆明市五华区翠湖北路云南大学', '施丽娟', '13900000019', '', '2026-06-15 10:15:00', '2026-06-15 10:00:00', '2026-06-15 10:15:00');
INSERT INTO `orders` VALUES (35, 'ORD20260615002', 26, 9999.00, 1, '北京市海淀区中关村大街', '张建华', '13900000020', '', '2026-06-15 13:40:00', '2026-06-15 13:30:00', '2026-06-15 13:40:00');
INSERT INTO `orders` VALUES (36, 'ORD20260615003', 27, 3499.00, 0, '天津市南开区卫津路', '孔令仪', '13900000021', '', NULL, '2026-06-15 14:00:00', '2026-06-15 14:00:00');
INSERT INTO `orders` VALUES (37, 'ORD20260615004', 28, 5999.00, 0, '广东省广州市天河区', '曹文博', '13900000022', '', NULL, '2026-06-15 14:30:00', '2026-06-15 14:30:00');
INSERT INTO `orders` VALUES (38, 'ORD20260615005', 29, 16999.00, 0, '陕西省西安市雁塔区', '严春晓', '13900000023', '', NULL, '2026-06-15 15:00:00', '2026-06-15 15:00:00');
INSERT INTO `orders` VALUES (39, 'ORD20260528001', 30, 399.00, 4, '江苏省苏州市姑苏区', '华宇轩', '13900000024', '买错了', NULL, '2026-05-28 11:25:35', '2026-05-28 13:00:00');
INSERT INTO `orders` VALUES (40, 'ORD20260529001', 31, 1899.00, 4, '江苏省南京市鼓楼区', '金丽娜', '13900000025', '不想要了', NULL, '2026-05-29 15:45:50', '2026-05-29 17:00:00');
INSERT INTO `orders` VALUES (41, 'ORD20260530001', 32, 2599.00, 4, '四川省成都市武侯区', '魏志鹏', '13900000026', '重复下单', NULL, '2026-05-30 10:00:25', '2026-05-30 11:30:00');
INSERT INTO `orders` VALUES (42, 'ORD20260531001', 33, 4999.00, 4, '湖北省武汉市武昌区', '陶思远', '13900000027', '资金紧张', NULL, '2026-05-31 14:30:00', '2026-05-31 16:00:00');
INSERT INTO `orders` VALUES (43, 'ORD20260601001', 34, 1999.00, 5, '安徽省合肥市蜀山区', '姜婷婷', '13900000028', '颜色不喜欢', '2026-06-01 11:00:00', '2026-06-01 10:55:15', '2026-06-03 18:00:00');
INSERT INTO `orders` VALUES (44, 'ORD20260602001', 5, 8999.00, 5, '广东省广州市越秀区中山五路76号', '何智泳', '15278752329', '尺寸不合适', '2026-06-02 15:30:00', '2026-06-02 15:25:30', '2026-06-05 18:00:00');
INSERT INTO `orders` VALUES (45, 'ORD20260603001', 35, 2899.00, 5, '山东省济南市历下区', '戚建国', '13900000029', '质量问题', '2026-06-03 16:10:20', '2026-06-03 16:10:20', '2026-06-06 18:00:00');
INSERT INTO `orders` VALUES (46, 'ORD1782045217092', 21, 8999.00, 3, '辽宁省大连市甘井子区中山路2号大连理工大学', '尤大海', '13900000015', '我要最新的', '2026-06-21 20:33:50', '2026-06-21 20:33:37', '2026-06-21 20:34:46');

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
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `product_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `product` VALUES (12, 'vivo X300 Pro', 1, 4899.00, 29, 'https://gw.alicdn.com/imgextra/O1CN014JEbnD23opc5I0wIH_!!883737303-0-picasso.jpg_580x580q90.jpg_.webp', '新品蔡司2亿APO超级长焦天玑9500拍照手机官方旗舰店官网', 1, '2026-06-15 15:27:25', '2026-06-15 15:33:57');
INSERT INTO `product` VALUES (13, 'vivo X100 Pro', 7, 4999.00, 180, 'https://img.alicdn.com/img/i4/110593945/O1CN01OSLNz21f0rXKDQ6AW_!!4611686018427381657-0-saturn_solar.jpg', '蔡司影像，蓝厂旗舰，天玑9300处理器', 1, '2026-05-15 10:05:00', '2026-06-21 19:30:08');
INSERT INTO `product` VALUES (14, '荣耀Magic6 Pro', 7, 4599.00, 150, 'https://img.alicdn.com/img/i2/2076210060/O1CN01uqB3RD1CJWsD1txEZ_!!4611686018427384716-0-saturn_solar.jpg', '荣耀旗舰，巨犀玻璃，青海湖电池', 1, '2026-05-15 10:10:00', '2026-06-21 19:29:59');
INSERT INTO `product` VALUES (15, '魅族21 Pro', 7, 4299.00, 120, 'https://img.alicdn.com/img/i1/366470039/O1CN01yddLhy1C9uYGiGFag_!!4611686018427380631-0-saturn_solar.jpg', '魅族旗舰，白色面板，骁龙8 Gen3', 1, '2026-05-15 10:15:00', '2026-06-21 19:29:48');
INSERT INTO `product` VALUES (16, '一加12', 7, 3999.00, 160, 'https://img.alicdn.com/img/O1CN01Zg61kf1NkyPWvc7G2_!!2200576841609.jpg', '哈苏影像，旗舰性能，护眼屏幕', 1, '2026-05-15 10:20:00', '2026-06-21 19:29:19');
INSERT INTO `product` VALUES (17, '红米K70 Pro', 7, 2599.00, 300, 'https://g-search3.alicdn.com/img/bao/uploaded/i4/i1/2216275804810/O1CN01sjlhoC1lP28xYAEyz_!!4611686018427380362-0-item_pic.jpg', '性价比旗舰，骁龙8 Gen2，2K屏幕', 1, '2026-05-15 10:25:00', '2026-06-21 19:28:41');
INSERT INTO `product` VALUES (18, 'iQOO Neo9', 7, 2299.00, 280, 'https://img.alicdn.com/img/O1CN01VPw0jK2Jm6zplmOf2_!!715939463.jpg', '游戏手机，天玑9300，散热强劲', 1, '2026-05-15 10:30:00', '2026-06-21 19:28:15');
INSERT INTO `product` VALUES (19, '真我GT5 Pro', 7, 2899.00, 140, 'https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/1663202745/O1CN01RXcqMT1W9GIgigvjJ_!!1663202745.jpg', '真我旗舰，大底主摄，快充之王', 1, '2026-05-15 10:35:00', '2026-06-21 19:28:28');
INSERT INTO `product` VALUES (20, '联想ThinkPad X1 Carbon 2024', 9, 11999.00, 50, 'https://gw.alicdn.com/imgextra/O1CN01cIpqnM1UsUDvx5jDU_!!2207284302573-0-picasso.jpg', '商务笔记本标杆，酷睿Ultra7处理器', 1, '2026-05-16 11:00:00', '2026-06-21 19:27:47');
INSERT INTO `product` VALUES (21, '华为MateBook X Pro', 9, 9999.00, 80, 'https://img.alicdn.com/img/O1CN01HhrfAT20eLga7RJoZ_!!3034056874.jpg', '超薄办公本，MateBook旗舰，OLED屏幕', 1, '2026-05-16 11:10:00', '2026-06-21 19:32:48');
INSERT INTO `product` VALUES (22, '戴尔XPS 15', 9, 13999.00, 40, 'https://g-search2.alicdn.com/img/bao/uploaded/i4/i3/2361902556/O1CN0128rI761UkhTOx61Y3_!!2361902556.jpg', '高性能轻薄本，酷睿i9，RTX显卡', 1, '2026-05-16 11:20:00', '2026-06-21 19:32:36');
INSERT INTO `product` VALUES (23, '华硕ROG 幻16', 9, 14999.00, 35, 'https://img.alicdn.com/img/O1CN01mB5elW1nHpD0uOSHO_!!2709385065.jpg', '游戏本天花板，RTX 4070，240Hz屏幕', 1, '2026-05-16 11:30:00', '2026-06-21 19:32:26');
INSERT INTO `product` VALUES (24, '联想拯救者Y9000P', 9, 8999.00, 99, 'https://img.alicdn.com/img/O1CN015wpDwi1cTlm3lSpxg_!!4611686018427380930-2-item_pic.png', '游戏本首选，i9-14900HX，RTX 4060', 1, '2026-05-16 11:40:00', '2026-06-21 19:32:16');
INSERT INTO `product` VALUES (25, '惠普暗影精灵10', 9, 7999.00, 90, 'https://g-search1.alicdn.com/img/bao/uploaded/i4/i4/2217538068010/O1CN01MTQF5m292dVNF3DWS_!!2217538068010.jpg', '高性价比游戏本，酷睿i7，RTX 4070', 1, '2026-05-16 11:50:00', '2026-06-21 19:32:04');
INSERT INTO `product` VALUES (26, 'iPad Air 6', 11, 4799.00, 200, 'https://img.alicdn.com/img/O1CN01qczA911FZVYgEZ7ZF_!!2217713730501.jpg', 'M2芯片，轻薄便携，适合学习办公', 1, '2026-05-17 12:00:00', '2026-06-21 19:31:30');
INSERT INTO `product` VALUES (27, '华为MatePad Pro 13.2', 11, 5199.00, 150, 'https://img.alicdn.com/imgextra/i4/385131841/O1CN01J21Lot1PTEHqiW5Nz_!!385131841-0-alimamacc.jpg', '华为平板旗舰，麒麟9000S，OLED屏幕', 1, '2026-05-17 12:10:00', '2026-06-21 19:31:15');
INSERT INTO `product` VALUES (28, '小米平板6 Max', 11, 3599.00, 180, 'https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/3357063493/O1CN01lXCWqR1bfqTbP4ouS_!!3357063493.jpg', '14寸大屏平板，骁龙8+，办公娱乐两不误', 1, '2026-05-17 12:20:00', '2026-06-21 19:31:06');
INSERT INTO `product` VALUES (29, '佳能EOS R6 Mark II', 3, 16999.00, 30, 'https://img.alicdn.com/img/i3/117000015/O1CN01QuyOwy1Byv1WFAp2I_!!4611686018427381583-0-saturn_solar.jpg', '专业级全画幅微单，40张/秒连拍', 1, '2026-05-12 13:00:00', '2026-06-21 19:24:19');
INSERT INTO `product` VALUES (30, '索尼Alpha 7 IV', 3, 18999.00, 25, 'https://img.alicdn.com/img/O1CN012lPBHB2M7IeNXXZli_!!4611686018427381156-0-item_pic.jpg', '索尼全画幅微单，3300万像素，4K视频', 1, '2026-05-12 13:10:00', '2026-06-21 19:24:34');
INSERT INTO `product` VALUES (31, '富士X-T5', 3, 10999.00, 60, 'https://img.alicdn.com/img/O1CN013bLSNj2MZhDJdQqJ6_!!4611686018427387538-0-item_pic.jpg', 'APS-C画幅微单，复古造型，4000万像素', 1, '2026-05-12 13:20:00', '2026-06-21 19:24:48');
INSERT INTO `product` VALUES (32, '大疆Pocket 3', 3, 3499.00, 150, 'https://img.alicdn.com/img/O1CN01oIyajv2FLJThdEpbe_!!4611686018427384895-0-item_pic.jpg', '口袋云台相机，1英寸传感器，4K120fps', 1, '2026-05-12 13:30:00', '2026-06-21 19:25:35');
INSERT INTO `product` VALUES (33, 'Apple Watch Series 9', 4, 2999.00, 250, 'https://img.alicdn.com/img/O1CN016sLAMX1YqQtvycbrA_!!4611686018427380886-0-item_pic.jpg', '苹果智能手表，S9芯片，精准健康监测', 1, '2026-05-13 14:00:00', '2026-06-21 19:25:18');
INSERT INTO `product` VALUES (34, '华为Watch GT4', 4, 1488.00, 300, 'https://g-search2.alicdn.com/img/bao/uploaded/i4/i3/2221549951104/O1CN01s4WzQd1K1gNJsxO81_!!4611686018427385984-0-item_pic.jpg', '华为运动手表，14天续航，血氧监测', 1, '2026-05-13 14:10:00', '2026-06-21 19:26:34');
INSERT INTO `product` VALUES (35, '小米手环8 Pro', 4, 399.00, 500, 'https://g-search3.alicdn.com/img/bao/uploaded/i4/i4/3576322078/O1CN01iKIy0F1RDm9lNyxdd_!!3576322078.jpg', '大屏智能手环，独立GPS，150+运动模式', 1, '2026-05-13 14:20:00', '2026-06-21 19:26:45');
INSERT INTO `product` VALUES (36, '佳明Forerunner 965', 4, 4980.00, 80, 'https://img.alicdn.com/imgextra/i2/3893688120/O1CN01BhnF7E29r1C6MivrN_!!3893688120-0-alimamacc.jpg', '专业运动手表，AMOLED屏幕，铁三训练', 1, '2026-05-13 14:30:00', '2026-06-21 19:26:54');
INSERT INTO `product` VALUES (37, 'AirPods Pro 2 USB-C版', 5, 1899.00, 400, 'https://img.alicdn.com/img/O1CN018lhtzi1pbda8SSXXi_!!2219578345379.jpg', '苹果降噪耳机，主动降噪，空间音频', 1, '2026-05-14 15:00:00', '2026-06-21 19:27:10');
INSERT INTO `product` VALUES (38, '索尼WH-1000XM5', 5, 2299.00, 121, 'https://img.alicdn.com/img/O1CN01SvQoMR2M7IfR2qiKQ_!!4611686018427381156-0-item_pic.jpg', '索尼旗舰降噪耳机，业界顶级降噪', 1, '2026-05-14 15:10:00', '2026-06-21 19:27:25');
INSERT INTO `product` VALUES (39, 'Bose QuietComfort Ultra', 5, 3299.00, 90, 'https://img.alicdn.com/img/O1CN01jkn4JO2GfIMH37zr3_!!4611686018427386418-0-item_pic.jpg', 'Bose旗舰降噪，沉浸式音频体验', 1, '2026-05-14 15:20:00', '2026-06-21 19:30:38');
INSERT INTO `product` VALUES (40, '森海塞尔Momentum 4', 5, 1999.00, 110, 'https://img.alicdn.com/img/i4/24889046/O1CN01viey9I2Gh7nuCvA0V_!!0-saturn_solar.jpg', '森海塞尔旗舰，卓越音质，60小时续航', 1, '2026-05-14 15:30:00', '2026-06-21 19:30:17');
INSERT INTO `product` VALUES (41, '罗技MX Master 3S鼠标', 6, 799.00, 350, 'https://img.alicdn.com/img/i1/116704693/O1CN01CJjqsc1kXRn7DSzZy_!!4611686018427381173-0-saturn_solar.jpg', '办公鼠标之王，静音按键，精准追踪', 1, '2026-05-11 16:00:00', '2026-06-21 19:23:51');

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
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_category_parent`(`parent_id` ASC) USING BTREE,
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `product_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_category
-- ----------------------------
INSERT INTO `product_category` VALUES (1, '手机通讯', NULL, 1, 'Cellphone', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (2, '电脑办公', NULL, 2, 'Monitor', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (3, '摄影器材', NULL, 3, 'Camera', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (4, '智能穿戴', NULL, 4, 'Watch', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (5, '音频设备', NULL, 5, 'Headset', 1, '2026-06-14 19:57:57');
INSERT INTO `product_category` VALUES (6, '配件周边', NULL, 6, 'Connection', 1, '2026-06-14 19:57:57');
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
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品评价表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of product_review
-- ----------------------------
INSERT INTO `product_review` VALUES (1, 2, 5, '钱七', 5, '非常好用', NULL, '2026-06-14 22:38:16', '好用多用啊', '2026-06-14 23:18:06');
INSERT INTO `product_review` VALUES (2, 3, 5, '钱七', 5, '超级好的手机', 'http://localhost:8080/api/uploads/d422e7bf40c7431a8d43682c59260e2e.jpg', '2026-06-14 23:50:28', NULL, NULL);
INSERT INTO `product_review` VALUES (3, 12, 7, '八宝粥', 5, '我也是很很支持好吧', 'http://localhost:8080/api/uploads/8c60d6b833e94e5fae330d309ee9e2a0.jpg', '2026-06-15 15:36:58', NULL, NULL);
INSERT INTO `product_review` VALUES (4, 13, 8, '吴小丽', 5, '蔡司影像名不虚传，拍出来的照片色彩很真实，天玑9300也很给力', NULL, '2026-05-21 14:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (5, 14, 9, '郑小刚', 4, '整体不错，巨犀玻璃很耐摔，就是续航稍微差一点点', NULL, '2026-05-22 11:20:00', '感谢反馈，续航问题我们会持续优化', '2026-05-22 16:00:00');
INSERT INTO `product_review` VALUES (6, 20, 10, '王小芳', 5, '商务办公首选，键盘手感一流，屏幕素质也很棒', NULL, '2026-05-23 18:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (7, 29, 11, '冯志强', 5, '专业级微单，对焦速度快，连拍功能强大，视频拍摄也很稳', NULL, '2026-05-24 12:00:00', '感谢您选择佳能产品！', '2026-05-24 15:30:00');
INSERT INTO `product_review` VALUES (8, 3, 12, '陈美玲', 5, '国产旗舰！卫星通话功能太实用了，信号超级好', NULL, '2026-05-25 10:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (9, 38, 13, '褚志华', 5, '降噪效果业界第一，音质也很棒，戴久了耳朵也不累', NULL, '2026-05-26 16:30:00', NULL, NULL);
INSERT INTO `product_review` VALUES (10, 33, 14, '卫国强', 4, '健康监测功能很全面，和iPhone配合完美，就是价格有点贵', NULL, '2026-05-27 14:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (11, 39, 15, '蒋文龙', 5, '沉浸式音频体验真的名不虚传，音质一流，降噪也很强', NULL, '2026-05-28 09:45:00', NULL, NULL);
INSERT INTO `product_review` VALUES (12, 34, 16, '沈雅琴', 5, '14天超长续航真香，运动模式齐全，性价比超高', NULL, '2026-05-29 13:20:00', NULL, NULL);
INSERT INTO `product_review` VALUES (13, 17, 17, '韩建国', 4, '性价比之王！2K屏幕+骁龙8 Gen2，这个价位无敌了', NULL, '2026-05-30 15:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (14, 24, 18, '杨雪梅', 5, '游戏性能爆表，3A大作无压力，散热也很给力', NULL, '2026-05-31 10:30:00', '感谢您的支持！', '2026-05-31 14:00:00');
INSERT INTO `product_review` VALUES (15, 35, 19, '朱俊杰', 5, '独立GPS很实用，屏幕也很大，150+运动模式够用了', NULL, '2026-06-01 16:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (16, 37, 20, '秦晓燕', 5, '主动降噪效果超棒，空间音频很惊艳，和苹果设备无缝切换', NULL, '2026-06-02 11:30:00', NULL, NULL);
INSERT INTO `product_review` VALUES (17, 28, 21, '尤大海', 4, '14寸大屏看视频太爽了，办公也够用，唯一缺点有点重', NULL, '2026-06-03 14:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (18, 15, 23, '何建军', 3, '白色面板很好看，但系统优化还有提升空间，期待后续更新', NULL, '2026-06-05 10:00:00', '感谢您的宝贵意见，我们会持续优化系统体验', '2026-06-05 15:30:00');
INSERT INTO `product_review` VALUES (19, 30, 24, '吕志远', 5, '3300万像素全画幅，拍照视频双修，专业摄影师的好选择', NULL, '2026-06-06 13:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (20, 40, 25, '施丽娟', 5, '森海塞尔的音质真的无可挑剔，60小时续航也很惊人', NULL, '2026-06-07 15:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (21, 16, 26, '张建华', 4, '哈苏影像加持，拍照色彩很有味道，护眼屏幕也不错', NULL, '2026-06-08 12:00:00', NULL, NULL);
INSERT INTO `product_review` VALUES (22, 41, 22, '许文静', 5, '办公鼠标首选，静音按键很棒，多设备切换太方便了', NULL, '2026-06-09 10:30:00', NULL, NULL);
INSERT INTO `product_review` VALUES (23, 24, 21, '尤大海', 5, '这个确实可以', 'http://localhost:8080/api/uploads/186b287c63d3475ca4ee7da6beb2102a.jpg', '2026-06-21 20:35:23', '那当然了', '2026-06-21 20:35:51');

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
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_spec_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 266 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '商品规格表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `product_spec` VALUES (60, 12, '颜色', '黑色', '2026-06-15 15:27:25');
INSERT INTO `product_spec` VALUES (61, 12, '颜色', '白色', '2026-06-15 15:33:57');
INSERT INTO `product_spec` VALUES (62, 12, '内存', '12+128', '2026-06-15 15:33:57');
INSERT INTO `product_spec` VALUES (63, 12, '内存', '12+256', '2026-06-15 15:33:57');
INSERT INTO `product_spec` VALUES (166, 41, '颜色', '石墨灰', '2026-05-11 16:00:00');
INSERT INTO `product_spec` VALUES (167, 41, '颜色', '淡雅粉', '2026-05-11 16:00:00');
INSERT INTO `product_spec` VALUES (168, 41, '版本', '标准版', '2026-05-11 16:00:00');
INSERT INTO `product_spec` VALUES (169, 29, '颜色', '黑色', '2026-05-12 13:00:00');
INSERT INTO `product_spec` VALUES (170, 29, '套装', '单机身', '2026-05-12 13:00:00');
INSERT INTO `product_spec` VALUES (171, 29, '套装', '24-105mm套机', '2026-05-12 13:00:00');
INSERT INTO `product_spec` VALUES (172, 30, '颜色', '黑色', '2026-05-12 13:10:00');
INSERT INTO `product_spec` VALUES (173, 30, '套装', '单机身', '2026-05-12 13:10:00');
INSERT INTO `product_spec` VALUES (174, 30, '套装', '28-70mm套机', '2026-05-12 13:10:00');
INSERT INTO `product_spec` VALUES (175, 31, '颜色', '银色', '2026-05-12 13:20:00');
INSERT INTO `product_spec` VALUES (176, 31, '颜色', '黑色', '2026-05-12 13:20:00');
INSERT INTO `product_spec` VALUES (177, 31, '套装', '单机身', '2026-05-12 13:20:00');
INSERT INTO `product_spec` VALUES (178, 31, '套装', '16-80mm套机', '2026-05-12 13:20:00');
INSERT INTO `product_spec` VALUES (179, 33, '颜色', '午夜色', '2026-05-13 14:00:00');
INSERT INTO `product_spec` VALUES (180, 33, '颜色', '星光色', '2026-05-13 14:00:00');
INSERT INTO `product_spec` VALUES (181, 33, '尺寸', '41mm', '2026-05-13 14:00:00');
INSERT INTO `product_spec` VALUES (182, 33, '尺寸', '45mm', '2026-05-13 14:00:00');
INSERT INTO `product_spec` VALUES (183, 32, '颜色', '黑色', '2026-05-12 13:30:00');
INSERT INTO `product_spec` VALUES (184, 32, '套装', '标准套装', '2026-05-12 13:30:00');
INSERT INTO `product_spec` VALUES (185, 32, '套装', '大师套装', '2026-05-12 13:30:00');
INSERT INTO `product_spec` VALUES (186, 34, '颜色', '曜石黑', '2026-05-13 14:10:00');
INSERT INTO `product_spec` VALUES (187, 34, '颜色', '月光白', '2026-05-13 14:10:00');
INSERT INTO `product_spec` VALUES (188, 34, '尺寸', '46mm', '2026-05-13 14:10:00');
INSERT INTO `product_spec` VALUES (189, 34, '尺寸', '41mm', '2026-05-13 14:10:00');
INSERT INTO `product_spec` VALUES (190, 35, '颜色', '黑色', '2026-05-13 14:20:00');
INSERT INTO `product_spec` VALUES (191, 35, '颜色', '金色', '2026-05-13 14:20:00');
INSERT INTO `product_spec` VALUES (192, 35, '尺寸', '标准', '2026-05-13 14:20:00');
INSERT INTO `product_spec` VALUES (193, 36, '颜色', '黑色', '2026-05-13 14:30:00');
INSERT INTO `product_spec` VALUES (194, 36, '颜色', '深灰色', '2026-05-13 14:30:00');
INSERT INTO `product_spec` VALUES (195, 36, '尺寸', '47mm', '2026-05-13 14:30:00');
INSERT INTO `product_spec` VALUES (196, 37, '版本', 'USB-C充电盒', '2026-05-14 15:00:00');
INSERT INTO `product_spec` VALUES (197, 37, '颜色', '白色', '2026-05-14 15:00:00');
INSERT INTO `product_spec` VALUES (198, 38, '颜色', '黑色', '2026-05-14 15:10:00');
INSERT INTO `product_spec` VALUES (199, 38, '颜色', '银色', '2026-05-14 15:10:00');
INSERT INTO `product_spec` VALUES (200, 20, '颜色', '黑色', '2026-05-16 11:00:00');
INSERT INTO `product_spec` VALUES (201, 20, '颜色', '银色', '2026-05-16 11:00:00');
INSERT INTO `product_spec` VALUES (202, 20, '内存', '16GB+512GB', '2026-05-16 11:00:00');
INSERT INTO `product_spec` VALUES (203, 20, '内存', '32GB+1TB', '2026-05-16 11:00:00');
INSERT INTO `product_spec` VALUES (204, 18, '颜色', '星曜白', '2026-05-15 10:30:00');
INSERT INTO `product_spec` VALUES (205, 18, '颜色', '游戏黑', '2026-05-15 10:30:00');
INSERT INTO `product_spec` VALUES (206, 18, '内存', '8GB+256GB', '2026-05-15 10:30:00');
INSERT INTO `product_spec` VALUES (207, 18, '内存', '12GB+256GB', '2026-05-15 10:30:00');
INSERT INTO `product_spec` VALUES (208, 19, '颜色', '星夜', '2026-05-15 10:35:00');
INSERT INTO `product_spec` VALUES (209, 19, '颜色', '火星', '2026-05-15 10:35:00');
INSERT INTO `product_spec` VALUES (210, 19, '内存', '8GB+256GB', '2026-05-15 10:35:00');
INSERT INTO `product_spec` VALUES (211, 19, '内存', '12GB+256GB', '2026-05-15 10:35:00');
INSERT INTO `product_spec` VALUES (212, 17, '颜色', '暗影', '2026-05-15 10:25:00');
INSERT INTO `product_spec` VALUES (213, 17, '颜色', '晴雪', '2026-05-15 10:25:00');
INSERT INTO `product_spec` VALUES (214, 17, '内存', '8GB+128GB', '2026-05-15 10:25:00');
INSERT INTO `product_spec` VALUES (215, 17, '内存', '12GB+256GB', '2026-05-15 10:25:00');
INSERT INTO `product_spec` VALUES (216, 16, '颜色', '岩黑', '2026-05-15 10:20:00');
INSERT INTO `product_spec` VALUES (217, 16, '颜色', '松绿', '2026-05-15 10:20:00');
INSERT INTO `product_spec` VALUES (218, 16, '内存', '12GB+256GB', '2026-05-15 10:20:00');
INSERT INTO `product_spec` VALUES (219, 16, '内存', '16GB+512GB', '2026-05-15 10:20:00');
INSERT INTO `product_spec` VALUES (220, 15, '颜色', '黑色', '2026-05-15 10:15:00');
INSERT INTO `product_spec` VALUES (221, 15, '颜色', '白色', '2026-05-15 10:15:00');
INSERT INTO `product_spec` VALUES (222, 15, '内存', '12GB+256GB', '2026-05-15 10:15:00');
INSERT INTO `product_spec` VALUES (223, 15, '内存', '16GB+512GB', '2026-05-15 10:15:00');
INSERT INTO `product_spec` VALUES (224, 14, '颜色', '绒黑色', '2026-05-15 10:10:00');
INSERT INTO `product_spec` VALUES (225, 14, '颜色', '祁连雪', '2026-05-15 10:10:00');
INSERT INTO `product_spec` VALUES (226, 14, '内存', '12GB+256GB', '2026-05-15 10:10:00');
INSERT INTO `product_spec` VALUES (227, 14, '内存', '16GB+512GB', '2026-05-15 10:10:00');
INSERT INTO `product_spec` VALUES (228, 13, '内存', '12GB+256GB', '2026-05-15 10:05:00');
INSERT INTO `product_spec` VALUES (229, 13, '内存', '16GB+512GB', '2026-05-15 10:05:00');
INSERT INTO `product_spec` VALUES (230, 40, '颜色', '黑色', '2026-05-14 15:30:00');
INSERT INTO `product_spec` VALUES (231, 40, '颜色', '白色', '2026-05-14 15:30:00');
INSERT INTO `product_spec` VALUES (232, 39, '颜色', '黑色', '2026-05-14 15:20:00');
INSERT INTO `product_spec` VALUES (233, 39, '颜色', '烟白色', '2026-05-14 15:20:00');
INSERT INTO `product_spec` VALUES (234, 28, '颜色', '黑色', '2026-05-17 12:20:00');
INSERT INTO `product_spec` VALUES (235, 28, '颜色', '银色', '2026-05-17 12:20:00');
INSERT INTO `product_spec` VALUES (236, 28, '内存', '8GB+256GB', '2026-05-17 12:20:00');
INSERT INTO `product_spec` VALUES (237, 28, '内存', '12GB+512GB', '2026-05-17 12:20:00');
INSERT INTO `product_spec` VALUES (238, 27, '颜色', '曜金黑', '2026-05-17 12:10:00');
INSERT INTO `product_spec` VALUES (239, 27, '颜色', '晶钻白', '2026-05-17 12:10:00');
INSERT INTO `product_spec` VALUES (240, 27, '内存', '12GB+256GB', '2026-05-17 12:10:00');
INSERT INTO `product_spec` VALUES (241, 27, '内存', '12GB+512GB', '2026-05-17 12:10:00');
INSERT INTO `product_spec` VALUES (242, 26, '颜色', '深空蓝', '2026-05-17 12:00:00');
INSERT INTO `product_spec` VALUES (243, 26, '颜色', '星光紫', '2026-05-17 12:00:00');
INSERT INTO `product_spec` VALUES (244, 26, '内存', '8GB+128GB', '2026-05-17 12:00:00');
INSERT INTO `product_spec` VALUES (245, 26, '内存', '8GB+256GB', '2026-05-17 12:00:00');
INSERT INTO `product_spec` VALUES (246, 25, '颜色', '暗夜紫', '2026-05-16 11:50:00');
INSERT INTO `product_spec` VALUES (247, 25, '颜色', '陨石黑', '2026-05-16 11:50:00');
INSERT INTO `product_spec` VALUES (248, 25, '内存', '16GB+512GB', '2026-05-16 11:50:00');
INSERT INTO `product_spec` VALUES (249, 25, '内存', '16GB+1TB', '2026-05-16 11:50:00');
INSERT INTO `product_spec` VALUES (250, 24, '颜色', '碳晶黑', '2026-05-16 11:40:00');
INSERT INTO `product_spec` VALUES (251, 24, '颜色', '冰魄白', '2026-05-16 11:40:00');
INSERT INTO `product_spec` VALUES (252, 24, '内存', '16GB+1TB', '2026-05-16 11:40:00');
INSERT INTO `product_spec` VALUES (253, 24, '内存', '32GB+2TB', '2026-05-16 11:40:00');
INSERT INTO `product_spec` VALUES (254, 23, '颜色', '日蚀灰', '2026-05-16 11:30:00');
INSERT INTO `product_spec` VALUES (255, 23, '颜色', '月耀白', '2026-05-16 11:30:00');
INSERT INTO `product_spec` VALUES (256, 23, '内存', '16GB+1TB', '2026-05-16 11:30:00');
INSERT INTO `product_spec` VALUES (257, 23, '内存', '32GB+2TB', '2026-05-16 11:30:00');
INSERT INTO `product_spec` VALUES (258, 22, '颜色', '铂金色', '2026-05-16 11:20:00');
INSERT INTO `product_spec` VALUES (259, 22, '颜色', '石墨黑', '2026-05-16 11:20:00');
INSERT INTO `product_spec` VALUES (260, 22, '内存', '16GB+512GB', '2026-05-16 11:20:00');
INSERT INTO `product_spec` VALUES (261, 22, '内存', '32GB+1TB', '2026-05-16 11:20:00');
INSERT INTO `product_spec` VALUES (262, 21, '颜色', '深空灰', '2026-05-16 11:10:00');
INSERT INTO `product_spec` VALUES (263, 21, '颜色', '皓月银', '2026-05-16 11:10:00');
INSERT INTO `product_spec` VALUES (264, 21, '内存', '16GB+512GB', '2026-05-16 11:10:00');
INSERT INTO `product_spec` VALUES (265, 21, '内存', '32GB+1TB', '2026-05-16 11:10:00');

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
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `fk_refund_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_refund_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '退款/售后表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of refund
-- ----------------------------
INSERT INTO `refund` VALUES (5, 1, 'ORD20240614001', 1, 9999.00, '不想要了', '我不需要了', 1, '2026-06-14 23:57:53', '同意退款', '2026-06-14 23:57:36', '2026-06-14 23:57:36');
INSERT INTO `refund` VALUES (6, 17, 'ORD1781510445121', 7, 7999.00, '不想要了', '', 1, '2026-06-15 16:01:31', '系统自动同意：付款24小时内快速退款', '2026-06-15 16:01:31', '2026-06-15 16:01:31');
INSERT INTO `refund` VALUES (9, 42, 'ORD20260531001', 33, 4999.00, '资金紧张', '近期需要用钱，先退货了', 1, '2026-05-31 16:30:00', '已处理退款', '2026-05-31 16:00:00', '2026-05-31 16:30:00');
INSERT INTO `refund` VALUES (10, 22, 'ORD20260524001', 13, 2299.00, '音质不符合预期', '听起来没有想象中好', 1, '2026-06-21 20:34:18', '同意退款', '2026-06-10 10:00:00', '2026-06-10 10:00:00');

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
  `spec_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '多规格id逗号分隔',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '购物车表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of shopping_cart
-- ----------------------------
INSERT INTO `shopping_cart` VALUES (1, 5, 1, NULL, 1, '2026-06-14 22:45:48', '2026-06-14 22:45:48', NULL);
INSERT INTO `shopping_cart` VALUES (2, 7, 12, 60, 1, '2026-05-18 10:00:00', '2026-05-18 10:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (3, 8, 13, 64, 1, '2026-05-19 14:30:00', '2026-05-19 14:30:00', NULL);
INSERT INTO `shopping_cart` VALUES (4, 9, 14, 68, 1, '2026-05-20 11:00:00', '2026-05-20 11:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (5, 10, 20, 92, 1, '2026-05-21 16:00:00', '2026-05-21 16:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (6, 11, 29, 130, 1, '2026-05-22 09:30:00', '2026-05-22 09:30:00', NULL);
INSERT INTO `shopping_cart` VALUES (7, 12, 3, NULL, 1, '2026-05-23 14:00:00', '2026-05-23 14:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (8, 13, 38, 157, 1, '2026-05-24 10:20:00', '2026-05-24 10:20:00', NULL);
INSERT INTO `shopping_cart` VALUES (9, 14, 33, 141, 1, '2026-05-25 15:00:00', '2026-05-25 15:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (10, 15, 39, 159, 1, '2026-05-26 11:45:00', '2026-05-26 11:45:00', NULL);
INSERT INTO `shopping_cart` VALUES (11, 16, 34, 145, 1, '2026-05-27 16:00:00', '2026-05-27 16:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (12, 17, 17, 80, 1, '2026-05-28 10:30:00', '2026-05-28 10:30:00', NULL);
INSERT INTO `shopping_cart` VALUES (13, 18, 24, 108, 1, '2026-05-29 14:00:00', '2026-05-29 14:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (14, 19, 35, 149, 2, '2026-05-30 09:15:00', '2026-05-30 09:15:00', NULL);
INSERT INTO `shopping_cart` VALUES (15, 20, 37, 155, 1, '2026-05-31 15:30:00', '2026-05-31 15:30:00', NULL);
INSERT INTO `shopping_cart` VALUES (17, 22, 41, 163, 1, '2026-06-02 16:20:00', '2026-06-02 16:20:00', NULL);
INSERT INTO `shopping_cart` VALUES (18, 23, 15, 72, 1, '2026-06-03 10:45:00', '2026-06-03 10:45:00', NULL);
INSERT INTO `shopping_cart` VALUES (19, 24, 30, 133, 1, '2026-06-04 14:00:00', '2026-06-04 14:00:00', NULL);
INSERT INTO `shopping_cart` VALUES (20, 25, 40, 161, 1, '2026-06-05 09:30:00', '2026-06-05 09:30:00', NULL);
INSERT INTO `shopping_cart` VALUES (21, 26, 16, 76, 1, '2026-06-06 15:00:00', '2026-06-06 15:00:00', NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'oTest001', '13800138001', '张三', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (2, 'oTest002', '13800138002', '李四', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (3, 'oTest003', '13800138003', '王五', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (4, 'oTest004', '13800138004', '赵六', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (5, 'oTest005', '13800138005', '钱七', 'http://localhost:8080/api/uploads/af4dc578c35a4c3d8102ba6f8087a611.png', 1, '2026-06-14 19:57:57', '2026-06-14 22:22:45');
INSERT INTO `user` VALUES (6, 'oTest006', '13800138006', '孙八', '', 0, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO `user` VALUES (7, 'wx_1781508116217_gtjyz6cuj', '15278751208', '八宝粥', 'http://localhost:8080/api/uploads/415a498331a74b74b906784c673d5bfd.jpg', 1, '2026-06-15 15:21:56', '2026-06-15 15:22:52');
INSERT INTO `user` VALUES (8, 'oTest008', '13900000002', '吴小丽', '', 1, '2026-05-18 14:22:10', '2026-05-18 14:22:10');
INSERT INTO `user` VALUES (9, 'oTest009', '13900000003', '郑小刚', '', 1, '2026-05-19 10:30:45', '2026-05-19 10:30:45');
INSERT INTO `user` VALUES (10, 'oTest010', '13900000004', '王小芳', '', 1, '2026-05-19 16:45:00', '2026-05-19 16:45:00');
INSERT INTO `user` VALUES (11, 'oTest011', '13900000005', '冯志强', '', 1, '2026-05-20 08:12:30', '2026-05-20 08:12:30');
INSERT INTO `user` VALUES (12, 'oTest012', '13900000006', '陈美玲', '', 1, '2026-05-20 11:30:00', '2026-05-20 11:30:00');
INSERT INTO `user` VALUES (13, 'oTest013', '13900000007', '褚志华', '', 1, '2026-05-20 15:00:20', '2026-05-20 15:00:20');
INSERT INTO `user` VALUES (14, 'oTest014', '13900000008', '卫国强', '', 1, '2026-05-21 09:25:00', '2026-05-21 09:25:00');
INSERT INTO `user` VALUES (15, 'oTest015', '13900000009', '蒋文龙', '', 1, '2026-05-21 13:40:15', '2026-05-21 13:40:15');
INSERT INTO `user` VALUES (16, 'oTest016', '13900000010', '沈雅琴', '', 1, '2026-05-22 10:05:40', '2026-05-22 10:05:40');
INSERT INTO `user` VALUES (17, 'oTest017', '13900000011', '韩建国', '', 1, '2026-05-22 14:30:55', '2026-05-22 14:30:55');
INSERT INTO `user` VALUES (18, 'oTest018', '13900000012', '杨雪梅', '', 1, '2026-05-23 09:50:30', '2026-05-23 09:50:30');
INSERT INTO `user` VALUES (19, 'oTest019', '13900000013', '朱俊杰', '', 1, '2026-05-23 16:20:00', '2026-05-23 16:20:00');
INSERT INTO `user` VALUES (20, 'oTest020', '13900000014', '秦晓燕', '', 1, '2026-05-24 11:00:10', '2026-05-24 11:00:10');
INSERT INTO `user` VALUES (21, 'oTest021', '13900000015', '尤大海', 'http://localhost:8080/api/uploads/ff4040af06ab47b2b40427f75c59a333.jpg', 1, '2026-05-24 15:30:20', '2026-06-21 19:36:40');
INSERT INTO `user` VALUES (22, 'oTest022', '13900000016', '许文静', '', 1, '2026-05-25 09:45:00', '2026-05-25 09:45:00');
INSERT INTO `user` VALUES (23, 'oTest023', '13900000017', '何建军', '', 1, '2026-05-25 14:15:30', '2026-05-25 14:15:30');
INSERT INTO `user` VALUES (24, 'oTest024', '13900000018', '吕志远', '', 1, '2026-05-26 10:20:15', '2026-05-26 10:20:15');
INSERT INTO `user` VALUES (25, 'oTest025', '13900000019', '施丽娟', '', 1, '2026-05-26 15:55:40', '2026-05-26 15:55:40');
INSERT INTO `user` VALUES (26, 'oTest026', '13900000020', '张建华', '', 1, '2026-05-27 09:30:00', '2026-05-27 09:30:00');
INSERT INTO `user` VALUES (27, 'oTest027', '13900000021', '孔令仪', '', 1, '2026-05-27 13:50:20', '2026-05-27 13:50:20');
INSERT INTO `user` VALUES (28, 'oTest028', '13900000022', '曹文博', '', 1, '2026-05-28 10:40:45', '2026-05-28 10:40:45');
INSERT INTO `user` VALUES (29, 'oTest029', '13900000023', '严春晓', '', 1, '2026-05-28 16:05:10', '2026-05-28 16:05:10');
INSERT INTO `user` VALUES (30, 'oTest030', '13900000024', '华宇轩', '', 1, '2026-05-29 11:25:35', '2026-05-29 11:25:35');
INSERT INTO `user` VALUES (31, 'oTest031', '13900000025', '金丽娜', '', 1, '2026-05-29 15:45:50', '2026-05-29 15:45:50');
INSERT INTO `user` VALUES (32, 'oTest032', '13900000026', '魏志鹏', '', 1, '2026-05-30 10:00:25', '2026-05-30 10:00:25');
INSERT INTO `user` VALUES (33, 'oTest033', '13900000027', '陶思远', '', 1, '2026-05-30 14:30:00', '2026-05-30 14:30:00');
INSERT INTO `user` VALUES (34, 'oTest034', '13900000028', '姜婷婷', '', 1, '2026-05-31 09:10:50', '2026-05-31 09:10:50');
INSERT INTO `user` VALUES (35, 'oTest035', '13900000029', '戚建国', '', 0, '2026-05-31 13:45:30', '2026-05-31 13:45:30');
INSERT INTO `user` VALUES (36, 'oTest036', '13900000030', '谢伟民', '', 1, '2026-06-01 10:55:15', '2026-06-01 10:55:15');
INSERT INTO `user` VALUES (37, 'oTest037', '13900000031', '邹雨晴', '', 1, '2026-06-01 15:20:40', '2026-06-01 15:20:40');
INSERT INTO `user` VALUES (38, 'oTest038', '13900000032', '喻鹏飞', '', 1, '2026-06-02 09:35:25', '2026-06-02 09:35:25');
INSERT INTO `user` VALUES (39, 'oTest039', '13900000033', '柏志刚', '', 1, '2026-06-02 14:05:50', '2026-06-02 14:05:50');
INSERT INTO `user` VALUES (40, 'oTest040', '13900000034', '水若曦', '', 1, '2026-06-03 11:25:05', '2026-06-03 11:25:05');
INSERT INTO `user` VALUES (41, 'oTest041', '13900000035', '窦建华', '', 1, '2026-06-03 16:10:20', '2026-06-03 16:10:20');
INSERT INTO `user` VALUES (42, 'oTest042', '13900000036', '章文博', '', 1, '2026-06-04 10:30:35', '2026-06-04 10:30:35');
INSERT INTO `user` VALUES (43, 'oTest043', '13900000037', '云晓峰', '', 1, '2026-06-04 15:15:55', '2026-06-04 15:15:55');
INSERT INTO `user` VALUES (44, 'oTest044', '13900000038', '苏明月', '', 1, '2026-06-05 09:50:10', '2026-06-05 09:50:10');
INSERT INTO `user` VALUES (45, 'oTest045', '13900000039', '潘高峰', '', 1, '2026-06-05 14:20:30', '2026-06-05 14:20:30');
INSERT INTO `user` VALUES (46, 'oTest046', '13900000040', '葛明辉', '', 1, '2026-06-06 11:40:45', '2026-06-06 11:40:45');
INSERT INTO `user` VALUES (47, 'oTest047', '13900000041', '奚秀兰', '', 1, '2026-06-06 16:00:15', '2026-06-06 16:00:15');
INSERT INTO `user` VALUES (48, 'oTest048', '13900000042', '范思哲', '', 1, '2026-06-07 10:15:30', '2026-06-07 10:15:30');
INSERT INTO `user` VALUES (49, 'oTest049', '13900000043', '彭万里', '', 1, '2026-06-07 15:50:45', '2026-06-07 15:50:45');
INSERT INTO `user` VALUES (50, 'oTest050', '13900000044', '郎平志', '', 1, '2026-06-08 09:25:00', '2026-06-08 09:25:00');
INSERT INTO `user` VALUES (51, 'oTest051', '13900000045', '鲁振华', '', 1, '2026-06-08 13:55:20', '2026-06-08 13:55:20');
INSERT INTO `user` VALUES (52, 'oTest052', '13900000046', '韦嘉欣', '', 1, '2026-06-09 11:10:40', '2026-06-09 11:10:40');
INSERT INTO `user` VALUES (53, 'oTest053', '13900000047', '昌志远', '', 0, '2026-06-09 15:35:55', '2026-06-09 15:35:55');
INSERT INTO `user` VALUES (54, 'oTest054', '13900000048', '马文博', '', 1, '2026-06-10 10:20:25', '2026-06-10 10:20:25');
INSERT INTO `user` VALUES (55, 'oTest055', '13900000049', '凤来仪', '', 1, '2026-06-10 14:50:10', '2026-06-10 14:50:10');
INSERT INTO `user` VALUES (56, 'oTest056', '13900000050', '苗青青', '', 1, '2026-06-11 09:45:30', '2026-06-11 09:45:30');

SET FOREIGN_KEY_CHECKS = 1;
