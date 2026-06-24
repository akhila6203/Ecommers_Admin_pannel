-- ============================================================
-- LM Shopping Mall - Offers & Banners
-- Database: lms (matches XAMPP MariaDB schema)
-- ============================================================

USE lms;

CREATE TABLE IF NOT EXISTS `offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `title` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `type` enum('category','product','festival','flash_sale','scheduled') NOT NULL,
  `discount_type` enum('percentage','flat') DEFAULT 'percentage',
  `discount_value` decimal(10,2) NOT NULL,
  `applicable_on` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`applicable_on`)),
  `minimum_purchase` decimal(10,2) DEFAULT 0.00,
  `maximum_discount` decimal(10,2) DEFAULT 0.00,
  `banner` varchar(500) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `is_featured` tinyint(1) DEFAULT 0,
  `priority` int(11) DEFAULT 0,
  `status` enum('active','inactive','scheduled','expired') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_offers_store_slug` (`store_id`,`slug`),
  KEY `idx_offers_slug` (`slug`),
  KEY `idx_offers_status` (`status`),
  KEY `idx_offers_dates` (`start_date`,`end_date`),
  KEY `idx_offers_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(500) DEFAULT NULL,
  `subtitle1` varchar(255) DEFAULT '',
  `description` text DEFAULT NULL,
  `image` varchar(500) NOT NULL,
  `mobile_image` varchar(500) DEFAULT NULL,
  `type` enum('homepage','slider','mobile','promotional','popup') DEFAULT 'homepage',
  `position` varchar(50) DEFAULT NULL,
  `link` varchar(500) DEFAULT NULL,
  `button_text` varchar(100) DEFAULT NULL,
  `button_link` varchar(500) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `priority` int(11) DEFAULT 0,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_banners_type` (`type`),
  KEY `idx_banners_status` (`status`),
  KEY `idx_banners_position` (`position`),
  KEY `idx_banners_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

