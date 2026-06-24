-- ============================================================
-- LM Shopping Mall - Stores (multi-website / store_id)
-- Database: lms (matches XAMPP MariaDB schema)
-- ============================================================

USE lms;

CREATE TABLE IF NOT EXISTS `stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `domain` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_stores_slug` (`slug`),
  KEY `idx_stores_status` (`status`),
  KEY `idx_stores_domain` (`domain`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO stores (id, name, slug, status)
VALUES (1, 'LM Shopping Mall', 'lm-shopping-mall', 'active')
ON DUPLICATE KEY UPDATE name = VALUES(name), slug = VALUES(slug), status = VALUES(status);
