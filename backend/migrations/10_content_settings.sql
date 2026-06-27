-- ============================================================
-- LM Shopping Mall - Content pages & settings
-- Database: lms (matches XAMPP MariaDB schema)
-- ============================================================

USE lms;

CREATE TABLE IF NOT EXISTS `content_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `page_key` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_content_pages_store_key` (`store_id`,`page_key`),
  KEY `idx_content_pages_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `group_name` varchar(100) NOT NULL,
  `key_name` varchar(100) NOT NULL,
  `value` longtext DEFAULT NULL,
  `type` enum('text','number','boolean','json','image','email') DEFAULT 'text',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_settings_store_group_key` (`store_id`,`group_name`,`key_name`),
  KEY `idx_settings_group` (`group_name`),
  KEY `idx_settings_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `store_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `company_name` varchar(255) DEFAULT '',
  `contact_email` varchar(255) DEFAULT '',
  `website_url` varchar(500) DEFAULT '',
  `gstin` varchar(20) DEFAULT '',
  `pan` varchar(20) DEFAULT '',
  `cin` varchar(30) DEFAULT '',
  `gst_state_code` varchar(10) DEFAULT '',
  `gst_registration_type` varchar(50) DEFAULT 'Regular',
  `facebook_url` varchar(500) DEFAULT '',
  `instagram_url` varchar(500) DEFAULT '',
  `linkedin_url` varchar(500) DEFAULT '',
  `youtube_url` varchar(500) DEFAULT '',
  `whatsapp_number` varchar(30) DEFAULT '',
  `whatsapp_message` text DEFAULT NULL,
  `store_address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT '',
  `state` varchar(100) DEFAULT '',
  `country` varchar(100) DEFAULT '',
  `postal_code` varchar(20) DEFAULT '',
  `store_logo` varchar(500) DEFAULT '',
  `store_banner` varchar(500) DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_store_settings_store_id` (`store_id`),
  KEY `idx_store_settings_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `integration_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_id` int(11) NOT NULL DEFAULT 1,
  `razorpay_enabled` tinyint(1) DEFAULT 0,
  `razorpay_key_id` varchar(255) DEFAULT '',
  `razorpay_key_secret` varchar(255) DEFAULT '',
  `whatsapp_enabled` tinyint(1) DEFAULT 0,
  `whatsapp_api_key` varchar(500) DEFAULT '',
  `whatsapp_phone_number` varchar(50) DEFAULT '',
  `shiprocket_enabled` tinyint(1) DEFAULT 0,
  `shiprocket_email` varchar(255) DEFAULT '',
  `shiprocket_password` varchar(255) DEFAULT '',
  `shiprocket_channel_id` varchar(100) DEFAULT '',
  `refund_enabled` tinyint(1) DEFAULT 0,
  `refund_auto` tinyint(1) DEFAULT 0,
  `refund_days` int(11) DEFAULT 7,
  `smtp_host` varchar(255) DEFAULT '',
  `smtp_port` varchar(10) DEFAULT '',
  `smtp_username` varchar(255) DEFAULT '',
  `smtp_password` varchar(255) DEFAULT '',
  `sender_email` varchar(255) DEFAULT '',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_integration_settings_store_id` (`store_id`),
  KEY `idx_integration_settings_store_id` (`store_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `settings_integrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO store_settings (store_id, company_name)
SELECT 1, 'LM Shopping Mall' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM store_settings WHERE store_id = 1);

INSERT INTO integration_settings (store_id)
SELECT 1 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM integration_settings WHERE store_id = 1);

INSERT IGNORE INTO content_pages (store_id, page_key, title, content, status) VALUES
  (1, 'about', 'About Us', '', 'active'),
  (1, 'contact', 'Contact Us', '{}', 'active'),
  (1, 'privacy-policy', 'Privacy Policy', '', 'active'),
  (1, 'terms-conditions', 'Terms & Conditions', '', 'active'),
  (1, 'shipping-policy', 'Shipping Policy', '', 'active'),
  (1, 'refund-policy', 'Refund Policy', '', 'active');


ALTER TABLE integration_settings
ADD COLUMN shiprocket_pickup_location VARCHAR(255) DEFAULT '';