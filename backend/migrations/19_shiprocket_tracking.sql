-- ============================================================
-- LM Shopping Mall - Shiprocket order tracking fields
-- ============================================================

USE lms;

ALTER TABLE orders ADD COLUMN IF NOT EXISTS shiprocket_order_id VARCHAR(100) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS shiprocket_shipment_id VARCHAR(100) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS courier_name VARCHAR(255) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS awb_code VARCHAR(100) DEFAULT NULL;

ALTER TABLE orders MODIFY COLUMN order_status
  enum('pending','confirmed','packed','shipped','out_for_delivery','delivered','cancelled','returned','refunded')
  DEFAULT 'pending';

ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_orders_awb_code (awb_code);
ALTER TABLE orders ADD INDEX IF NOT EXISTS idx_orders_tracking_number (tracking_number);


ALTER TABLE orders ADD COLUMN IF NOT EXISTS shiprocket_label_url VARCHAR(500) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS shiprocket_pickup_status VARCHAR(100) DEFAULT NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS shiprocket_pickup_token VARCHAR(255) DEFAULT NULL;