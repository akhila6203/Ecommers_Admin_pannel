-- ============================================================
-- Cart storefront columns for website add-to-cart
-- ============================================================

USE lms;

ALTER TABLE cart
  ADD COLUMN IF NOT EXISTS selected_size varchar(100) DEFAULT NULL AFTER quantity,
  ADD COLUMN IF NOT EXISTS selected_color varchar(100) DEFAULT NULL AFTER selected_size,
  ADD COLUMN IF NOT EXISTS item_price decimal(12,2) DEFAULT 0.00 AFTER selected_color,
  ADD COLUMN IF NOT EXISTS item_data longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL AFTER item_price;

ALTER TABLE cart ADD INDEX IF NOT EXISTS idx_cart_store_customer (store_id, customer_id);
ALTER TABLE cart ADD INDEX IF NOT EXISTS idx_cart_store_session (store_id, session_id);
