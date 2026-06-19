-- ==================== H2 兼容测试数据库初始化脚本 ====================
-- 去掉所有 MySQL 特有语法：ENGINE/CHARACTER SET/COLLATE/ROW_FORMAT/USING BTREE/COMMENT/ON UPDATE

DROP TABLE IF EXISTS address;
CREATE TABLE address (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  receiver VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  province VARCHAR(50),
  city VARCHAR(50),
  district VARCHAR(50),
  detail VARCHAR(255) NOT NULL,
  is_default TINYINT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO address VALUES (1, 5, '何智泳', '15278752329', '北京市', '北京市', '东城区', '北京大学', 1, '2026-06-14 20:06:07', '2026-06-14 20:06:07');

DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
  id BIGINT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  password VARCHAR(100) NOT NULL,
  role VARCHAR(20) DEFAULT 'admin',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO admin VALUES (1, 'admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'superadmin', '2026-06-14 19:57:57');

DROP TABLE IF EXISTS ai_config;
CREATE TABLE ai_config (
  id BIGINT NOT NULL AUTO_INCREMENT,
  provider VARCHAR(50) NOT NULL,
  api_key VARCHAR(500) NOT NULL,
  base_url VARCHAR(500) NOT NULL,
  model VARCHAR(100) NOT NULL,
  temperature DOUBLE DEFAULT 0.7,
  max_tokens INT DEFAULT 2048,
  system_prompt TEXT,
  is_active TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS banner;
CREATE TABLE banner (
  id BIGINT NOT NULL AUTO_INCREMENT,
  image VARCHAR(500) NOT NULL,
  title VARCHAR(100) DEFAULT '',
  link VARCHAR(500) DEFAULT '',
  sort INT DEFAULT 0,
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO banner VALUES (1, 'https://img95.699pic.com/photo/40245/0705.jpg_wh860.jpg', '新品上市', '', 1, 1, '2026-06-14 21:36:55', '2026-06-14 23:30:21');
INSERT INTO banner VALUES (2, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/458430/15/3518/99230/6a2e81f9F58b898c6/008332032012ca09.jpg!q70.dpg', '限时特惠', '', 2, 1, '2026-06-14 21:36:55', '2026-06-14 22:06:37');
INSERT INTO banner VALUES (3, 'http://localhost:8080/api/uploads/9eec2d71eed44460b35fe630ee204900.jpg', '热门推荐', '', 3, 1, '2026-06-14 21:36:55', '2026-06-14 21:51:40');

DROP TABLE IF EXISTS notice;
CREATE TABLE notice (
  id BIGINT NOT NULL AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  content TEXT,
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS notification;
CREATE TABLE notification (
  id BIGINT NOT NULL AUTO_INCREMENT,
  receiver_id BIGINT NOT NULL,
  title VARCHAR(100) NOT NULL,
  content TEXT,
  read_status TINYINT DEFAULT 0,
  type VARCHAR(20) DEFAULT 'system',
  related_id BIGINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS operation_log;
CREATE TABLE operation_log (
  id BIGINT NOT NULL AUTO_INCREMENT,
  operator_id BIGINT,
  operator_name VARCHAR(64),
  operator_type VARCHAR(16) DEFAULT 'ADMIN',
  operation_type VARCHAR(32) NOT NULL,
  module VARCHAR(32) NOT NULL,
  description VARCHAR(512),
  method VARCHAR(256),
  request_url VARCHAR(256),
  request_method VARCHAR(16),
  request_params TEXT,
  response_result TEXT,
  ip VARCHAR(64),
  location VARCHAR(128),
  status TINYINT DEFAULT 1,
  error_msg TEXT,
  cost_time BIGINT,
  user_agent VARCHAR(512),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS order_item;
CREATE TABLE order_item (
  id BIGINT NOT NULL AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_name VARCHAR(200) NOT NULL,
  spec_name VARCHAR(100),
  spec_value VARCHAR(200),
  spec_ids VARCHAR(100),
  price DECIMAL(10, 2) NOT NULL,
  quantity INT NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL,
  product_image VARCHAR(500),
  PRIMARY KEY (id)
);

INSERT INTO order_item VALUES (1, 1, 1, 'iPhone 15 Pro Max 256GB', NULL, NULL, NULL, 9999.00, 1, 9999.00, NULL);
INSERT INTO order_item VALUES (2, 2, 2, '小米14 Ultra 512GB', NULL, NULL, NULL, 6999.00, 1, 6999.00, NULL);
INSERT INTO order_item VALUES (3, 3, 4, 'MacBook Pro 14寸 M3 Pro', NULL, NULL, NULL, 16999.00, 1, 16999.00, NULL);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id BIGINT NOT NULL AUTO_INCREMENT,
  order_no VARCHAR(32) NOT NULL,
  user_id BIGINT NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  status TINYINT DEFAULT 0,
  address TEXT,
  consignee VARCHAR(50),
  phone VARCHAR(20),
  remark VARCHAR(500),
  pay_time TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO orders VALUES (1, 'ORD20240614001', 1, 9999.00, 0, '北京市朝阳区建国路88号', '张三', '13800138001', NULL, NULL, '2024-06-14 10:30:00', '2024-06-14 10:30:00');
INSERT INTO orders VALUES (2, 'ORD20240614002', 2, 6999.00, 2, '上海市浦东新区世纪大道100号', '李四', '13800138002', NULL, NULL, '2024-06-14 09:15:00', '2024-06-14 09:15:00');
INSERT INTO orders VALUES (3, 'ORD20240614003', 3, 16999.00, 3, '广州市天河区珠江新城', '王五', '13800138003', NULL, NULL, '2024-06-13 16:20:00', '2024-06-13 16:20:00');

DROP TABLE IF EXISTS product;
CREATE TABLE product (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(200) NOT NULL,
  category_id BIGINT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  stock INT NOT NULL DEFAULT 0,
  images TEXT,
  description TEXT,
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO product VALUES (1, 'iPhone 15 Pro Max 256GB', 7, 9999.00, 51, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/453802/31/7554/160573/6a2c5c3cFd25178ef/0083320320998bd9.jpg!q70.dpg', '苹果旗舰手机，A17 Pro芯片，钛金属边框', 1, '2026-06-14 19:57:57', '2026-06-14 23:34:05');
INSERT INTO product VALUES (2, '小米14 Ultra 512GB', 7, 6999.00, 98, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/318827/18/1068/65654/6826d8a7Fe4220735/3bc78c7e561ff76d.jpg!q70.dpg', '徕卡影像，骁龙8 Gen3处理器', 1, '2026-06-14 19:57:57', '2026-06-14 23:34:26');
INSERT INTO product VALUES (3, '华为Mate 60 Pro 512GB', 7, 7999.00, 79, 'https://m.360buyimg.com/mobilecms/s500x500_jfs/t1/436806/29/980/68168/6a04496dF9bf54f89/008332032086073f.jpg!q70.dpg', '麒麟9000S芯片，卫星通话', 1, '2026-06-14 19:57:57', '2026-06-14 23:35:58');

DROP TABLE IF EXISTS product_category;
CREATE TABLE product_category (
  id BIGINT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  parent_id BIGINT DEFAULT 0,
  sort INT DEFAULT 0,
  icon VARCHAR(50),
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO product_category VALUES (1, '手机通讯', 0, 1, 'Cellphone', 1, '2026-06-14 19:57:57');
INSERT INTO product_category VALUES (2, '电脑办公', 0, 2, 'Monitor', 1, '2026-06-14 19:57:57');
INSERT INTO product_category VALUES (7, '智能手机', 1, 1, 'Cellphone', 1, '2026-06-14 19:57:57');
INSERT INTO product_category VALUES (9, '笔记本电脑', 2, 1, 'Monitor', 1, '2026-06-14 19:57:57');

DROP TABLE IF EXISTS product_review;
CREATE TABLE product_review (
  id BIGINT NOT NULL AUTO_INCREMENT,
  product_id BIGINT NOT NULL,
  user_id BIGINT NOT NULL,
  user_name VARCHAR(50),
  rating TINYINT NOT NULL,
  content TEXT,
  images TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reply VARCHAR(500),
  reply_time TIMESTAMP NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS product_spec;
CREATE TABLE product_spec (
  id BIGINT NOT NULL AUTO_INCREMENT,
  product_id BIGINT NOT NULL,
  spec_name VARCHAR(50) NOT NULL,
  spec_value VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO product_spec VALUES (33, 1, '颜色', '原色钛金属', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (34, 1, '颜色', '蓝色钛金属', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (36, 1, '内存', '256GB', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (37, 1, '内存', '512GB', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (39, 2, '颜色', '黑色', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (40, 2, '颜色', '白色', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (53, 3, '颜色', '雅丹黑', '2026-06-14 22:53:29');
INSERT INTO product_spec VALUES (54, 3, '颜色', '南糯紫', '2026-06-14 22:53:29');

DROP TABLE IF EXISTS refund;
CREATE TABLE refund (
  id BIGINT NOT NULL AUTO_INCREMENT,
  order_id BIGINT NOT NULL,
  order_no VARCHAR(32) NOT NULL,
  user_id BIGINT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  reason VARCHAR(200),
  description TEXT,
  status TINYINT DEFAULT 0,
  process_time TIMESTAMP NULL,
  process_note VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS shopping_cart;
CREATE TABLE shopping_cart (
  id BIGINT NOT NULL AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  spec_id BIGINT,
  quantity INT NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS "user";
CREATE TABLE "user" (
  id BIGINT NOT NULL AUTO_INCREMENT,
  openid VARCHAR(64) NOT NULL,
  phone VARCHAR(20),
  nickname VARCHAR(64),
  avatar VARCHAR(255),
  status TINYINT DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO "user" VALUES (1, 'oTest001', '13800138001', '张三', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO "user" VALUES (2, 'oTest002', '13800138002', '李四', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO "user" VALUES (3, 'oTest003', '13800138003', '王五', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
INSERT INTO "user" VALUES (5, 'oTest005', '13800138005', '钱七', '', 1, '2026-06-14 19:57:57', '2026-06-14 19:57:57');
