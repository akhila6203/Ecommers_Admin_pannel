-- v6: Products & collections hard delete, organization fields, variant option_values, coupon_usage
-- Run against `lms` after backup.

USE lms;

-- ============================================================
-- 1. Permanently remove soft-deleted rows
-- ============================================================

DELETE FROM products WHERE deleted_at IS NOT NULL;
DELETE FROM collections WHERE deleted_at IS NOT NULL;

-- ============================================================
-- 2. Products: drop soft delete & unused columns, add organization fields
-- ============================================================

ALTER TABLE products DROP COLUMN deleted_at;

ALTER TABLE products
  ADD COLUMN vendor VARCHAR(255) NULL AFTER brand,
  ADD COLUMN product_type VARCHAR(255) NULL AFTER vendor;

ALTER TABLE products DROP COLUMN specifications;

ALTER TABLE products
  DROP COLUMN size,
  DROP COLUMN color,
  DROP COLUMN material,
  DROP COLUMN fabric,
  DROP COLUMN occasion,
  DROP COLUMN weight,
  DROP COLUMN unit;

ALTER TABLE products ADD INDEX idx_products_brand (brand);

-- ============================================================
-- 3. Product variants: store full option combinations
-- ============================================================

ALTER TABLE product_variants
  ADD COLUMN option_values JSON NULL AFTER color;

-- ============================================================
-- 4. Collections: hard delete only
-- ============================================================

ALTER TABLE collections DROP COLUMN deleted_at;

-- ============================================================
-- 5. Coupon usage table
-- ============================================================

CREATE TABLE IF NOT EXISTS coupon_usage (
  id INT PRIMARY KEY AUTO_INCREMENT,
  coupon_id INT NOT NULL,
  customer_id INT,
  order_id INT,
  discount_amount DECIMAL(10,2) DEFAULT 0.00,
  used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  INDEX idx_coupon_usage_coupon (coupon_id),
  INDEX idx_coupon_usage_customer (customer_id),
  INDEX idx_coupon_usage_order (order_id),
  INDEX idx_coupon_usage_used_at (used_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- If upgrading from coupon_usages, run manually before DROP:
-- INSERT INTO coupon_usage (coupon_id, customer_id, order_id, used_at)
-- SELECT coupon_id, customer_id, order_id, used_at FROM coupon_usages;

DROP TABLE IF EXISTS coupon_usages;

-- Add coupon tracking columns if missing (ignore errors if already exist)
-- ALTER TABLE coupons ADD COLUMN usage_limit INT DEFAULT 0;
-- ALTER TABLE coupons ADD COLUMN used_count INT DEFAULT 0;
-- ALTER TABLE coupons ADD COLUMN minimum_order_amount DECIMAL(10,2) DEFAULT 0.00;
-- ALTER TABLE coupons ADD COLUMN maximum_discount DECIMAL(10,2) DEFAULT 0.00;
-- ALTER TABLE coupons ADD COLUMN per_user_limit INT DEFAULT 1;
-- ALTER TABLE coupons ADD COLUMN is_for_new_customers TINYINT(1) DEFAULT 0;
-- ALTER TABLE coupons ADD COLUMN description TEXT NULL;
