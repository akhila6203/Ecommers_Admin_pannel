-- ============================================================
-- Product variant images + Banner videos
-- Safe migration — does not delete existing product/collection data
-- Database: lms
-- ============================================================

USE lms;

-- Variant-level multiple images (Flipkart-style color/size variants)
CREATE TABLE IF NOT EXISTS `product_variant_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `image` varchar(500) NOT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pvi_variant` (`variant_id`),
  KEY `idx_pvi_product` (`product_id`),
  KEY `idx_pvi_store_id` (`store_id`),
  CONSTRAINT `product_variant_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_variant_images_ibfk_2` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Optional fabric column on variants (also stored in option_values JSON)
SET @fabric_col_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'product_variants' AND COLUMN_NAME = 'fabric'
);
SET @sql_fabric = IF(
  @fabric_col_exists = 0,
  'ALTER TABLE `product_variants` ADD COLUMN `fabric` varchar(100) DEFAULT NULL AFTER `color`',
  'SELECT 1'
);
PREPARE stmt_fabric FROM @sql_fabric;
EXECUTE stmt_fabric;
DEALLOCATE PREPARE stmt_fabric;

-- Ensure collections.image exists (cover/banner image for collection)
SET @coll_image_exists = (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'collections' AND COLUMN_NAME = 'image'
);
SET @sql_coll = IF(
  @coll_image_exists = 0,
  'ALTER TABLE `collections` ADD COLUMN `image` varchar(500) DEFAULT NULL AFTER `description`',
  'SELECT 1'
);
PREPARE stmt_coll FROM @sql_coll;
EXECUTE stmt_coll;
DEALLOCATE PREPARE stmt_coll;

-- Homepage / banner page videos (separate from banners table)
CREATE TABLE IF NOT EXISTS `banner_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `video_path` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_banner_videos_store` (`store_id`),
  KEY `idx_banner_videos_status` (`status`),
  KEY `idx_banner_videos_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Migrate existing single variant.image into product_variant_images (one-time, safe)
INSERT INTO `product_variant_images` (`store_id`, `product_id`, `variant_id`, `image`, `sort_order`)
SELECT pv.store_id, pv.product_id, pv.id, pv.image, 0
FROM `product_variants` pv
WHERE pv.image IS NOT NULL AND pv.image != ''
  AND NOT EXISTS (
    SELECT 1 FROM `product_variant_images` pvi
    WHERE pvi.variant_id = pv.id AND pvi.image = pv.image
  );
