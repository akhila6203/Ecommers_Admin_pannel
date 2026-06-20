-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2026 at 08:01 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lms`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `admin_id`, `customer_id`, `action`, `description`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-15 08:06:25'),
(2, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-15 08:07:41'),
(3, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-15 08:12:42'),
(4, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-15 09:43:12'),
(5, 1, NULL, 'update_profile', 'Profile updated', NULL, NULL, '2026-06-15 10:07:03'),
(6, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-15 10:55:51'),
(7, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-15 11:58:29'),
(8, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-16 04:33:33'),
(9, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-16 06:20:05'),
(10, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-16 09:15:37'),
(11, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-16 11:16:18'),
(12, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 04:39:13'),
(13, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 04:57:22'),
(14, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 04:57:39'),
(15, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 04:58:23'),
(16, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 04:59:48'),
(17, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 05:15:38'),
(18, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 06:58:01'),
(19, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 06:58:46'),
(20, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 06:59:06'),
(21, 1, NULL, 'login', 'Admin logged in', NULL, NULL, '2026-06-17 07:04:21');

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` varchar(50) DEFAULT 'admin',
  `role_id` int(11) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `last_login_ip` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `phone`, `role`, `role_id`, `avatar`, `status`, `email_verified_at`, `last_login_at`, `last_login_ip`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Super Admin', 'admin@lms.com', '$2a$12$6F66uecUyYsBZFtP4Afm/./RtjohaA6cnzzzW3koLauQb89XKTHfO', '769879', 'super_admin', NULL, NULL, 'active', NULL, '2026-06-17 07:04:21', '::1', '2026-06-15 06:51:34', '2026-06-17 07:04:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `entity` varchar(100) NOT NULL,
  `entity_id` int(11) DEFAULT NULL,
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`details`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `admin_id`, `action`, `entity`, `entity_id`, `details`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, 'update', 'category', 7, '{\"body\":{\"name\":\"Gowns\"},\"params\":{\"id\":\"7\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 09:44:24'),
(2, 1, 'update', 'sub_category', 23, '{\"body\":{\"name\":\"Silk Blouses\"},\"params\":{\"id\":\"23\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 09:44:33'),
(3, 1, 'create', 'category', 9, '{\"body\":{\"name\":\"accessaries\"},\"params\":{},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 10:00:48'),
(4, 1, 'update', 'sub_category', 3, '{\"body\":{\"name\":\"Banarasi Saree\"},\"params\":{\"id\":\"3\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 10:02:01'),
(5, 1, 'delete', 'sub_category', 2, '{\"body\":{},\"params\":{\"id\":\"2\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-15 10:02:43'),
(6, 1, 'create', 'product', 13, '{\"body\":{\"name\":\"sareesadlk,dlfmfmr\",\"slug\":\"f\",\"category_id\":\"1\",\"sub_category_id\":\"3\",\"child_category_id\":\"\",\"brand\":\"\",\"vendor\":\" vcv\",\"price\":\"67\",\"offer_price\":\"657\",\"cost_price\":\"878\",\"discount_percentage\":\"0\",\"gst_percent\":\"6\",\"short_description\":\"ffjuhjo\",\"long_description\":\"<p>fvc gvhljk</p>\",\"tags\":\"nmjcnkv\",\"status\":\"active\",\"specifications\":\"{\\\"fgfh\\\":\\\"gfguj\\\",\\\"product_type\\\":\\\"v gbv\\\"}\"},\"params\":{},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-16 06:29:54'),
(7, 1, 'update', 'product_seo', 1, '{\"body\":{\"seo_title\":\"fdfvbhgv\",\"seo_description\":\"fbhgfnh gjn\"},\"params\":{\"productId\":\"13\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-16 06:29:54'),
(8, 1, 'create', 'product', 14, '{\"body\":{\"name\":\"sadfssf vfgt\",\"slug\":\"s\",\"category_id\":\"1\",\"sub_category_id\":\"6\",\"child_category_id\":\"\",\"brand\":\"\",\"vendor\":\"bgj b nh\",\"price\":\"768798\",\"offer_price\":\"454656\",\"cost_price\":\"6788\",\"discount_percentage\":\"41\",\"gst_percent\":\"1\",\"short_description\":\"uik,m,m\",\"long_description\":\"<p>n,m,bmjk</p>\",\"tags\":\"dfd,fhg btjh\",\"status\":\"active\",\"specifications\":\"{\\\"kj\\\":\\\"kj\\\",\\\"product_type\\\":\\\"kjkghjm\\\"}\",\"variant_options\":\"[{\\\"option_name\\\":\\\"Size\\\",\\\"option_values\\\":[\\\"hgb\\\"],\\\"sort_order\\\":0}]\",\"variants\":\"[{\\\"sku\\\":\\\"\\\",\\\"price\\\":\\\"768798\\\",\\\"offer_price\\\":\\\"454656\\\",\\\"stock\\\":0,\\\"options\\\":[{\\\"name\\\":\\\"Size\\\",\\\"value\\\":\\\"hgb\\\"}],\\\"size\\\":\\\"hgb\\\",\\\"color\\\":null}]\",\"seo_data\":\"{\\\"seo_title\\\":\\\"n bhjm\\\",\\\"seo_description\\\":\\\"hkmjhhmk\\\"}\"},\"params\":{},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-16 11:38:19'),
(9, 1, 'create', 'category', 10, '{\"body\":{\"name\":\"QA-Cat-1781672242918\"},\"params\":{},\"query\":{}}', '::1', 'node', '2026-06-17 04:57:22'),
(10, 1, 'update', 'category', 10, '{\"body\":{\"name\":\"QA-Cat-1781672242918-Updated\"},\"params\":{\"id\":\"10\"},\"query\":{}}', '::1', 'node', '2026-06-17 04:57:22'),
(11, 1, 'delete', 'category', 10, '{\"body\":{},\"params\":{\"id\":\"10\"},\"query\":{}}', '::1', 'node', '2026-06-17 04:57:23'),
(12, 1, 'create', 'category', 11, '{\"body\":{\"name\":\"TestCat123\"},\"params\":{},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249', '2026-06-17 04:57:39'),
(13, 1, 'update', 'category', 11, '{\"body\":{\"name\":\"TestCat123-Updated\"},\"params\":{\"id\":\"11\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-US) WindowsPowerShell/5.1.22621.4249', '2026-06-17 04:57:39'),
(14, 1, 'create', 'category', 12, '{\"body\":{\"name\":\"QA-Cat-1781672303915\"},\"params\":{},\"query\":{}}', '::1', 'node', '2026-06-17 04:58:23'),
(15, 1, 'update', 'category', 12, '{\"body\":{\"name\":\"QA-Cat-1781672303915-Updated\"},\"params\":{\"id\":\"12\"},\"query\":{}}', '::1', 'node', '2026-06-17 04:58:23'),
(16, 1, 'delete', 'category', 12, '{\"body\":{},\"params\":{\"id\":\"12\"},\"query\":{}}', '::1', 'node', '2026-06-17 04:58:24'),
(17, 1, 'create', 'category', 13, '{\"body\":{\"name\":\"Jest-Cat-1781672388889\"},\"params\":{},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 04:59:48'),
(18, 1, 'update', 'category', 13, '{\"body\":{\"name\":\"Jest-Cat-1781672388889-Updated\"},\"params\":{\"id\":\"13\"},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 04:59:48'),
(19, 1, 'delete', 'category', 13, '{\"body\":{},\"params\":{\"id\":\"13\"},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 04:59:48'),
(20, 1, 'create', 'category', 14, '{\"body\":{\"name\":\"Jest-Cat-1781673339259\"},\"params\":{},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 05:15:39'),
(21, 1, 'update', 'category', 14, '{\"body\":{\"name\":\"Jest-Cat-1781673339259-Updated\"},\"params\":{\"id\":\"14\"},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 05:15:39'),
(22, 1, 'delete', 'category', 14, '{\"body\":{},\"params\":{\"id\":\"14\"},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 05:15:39'),
(23, 1, 'update', 'product', 14, '{\"body\":{\"name\":\"sadfssf vfgtk\",\"slug\":\"s\",\"category_id\":\"1\",\"sub_category_id\":\"6\",\"child_category_id\":\"\",\"brand\":\"\",\"vendor\":\"\",\"price\":\"768798.00\",\"offer_price\":\"454656.00\",\"cost_price\":\"6788.00\",\"discount_percentage\":\"41\",\"gst_percent\":\"1.00\",\"short_description\":\"uik,m,m\",\"long_description\":\"<p>n,m,bmjk</p>\",\"tags\":\"dfd,fhg btjh\",\"status\":\"active\",\"specifications\":\"{\\\"kj\\\":\\\"kj\\\",\\\"product_type\\\":\\\"kjkghjm\\\"}\",\"variant_options\":\"[{\\\"option_name\\\":\\\"Size\\\",\\\"option_values\\\":[\\\"hgb\\\"],\\\"sort_order\\\":0}]\",\"variants\":\"[{\\\"sku\\\":\\\"VAR-14-000\\\",\\\"price\\\":\\\"768798.00\\\",\\\"offer_price\\\":\\\"454656.00\\\",\\\"stock\\\":0,\\\"options\\\":[{\\\"name\\\":\\\"Size\\\",\\\"value\\\":\\\"hgb\\\"}],\\\"size\\\":\\\"hgb\\\",\\\"color\\\":null}]\",\"seo_data\":\"{\\\"seo_title\\\":\\\"n bhjm\\\",\\\"seo_description\\\":\\\"hkmjhhmk\\\"}\"},\"params\":{\"id\":\"14\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-17 05:24:46'),
(24, 1, 'delete', 'product', 7, '{\"body\":{},\"params\":{\"id\":\"7\"},\"query\":{}}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-17 05:26:03'),
(25, 1, 'create', 'category', 15, '{\"body\":{\"name\":\"Jest-Cat-1781679481449\"},\"params\":{},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 06:58:01'),
(26, 1, 'update', 'category', 15, '{\"body\":{\"name\":\"Jest-Cat-1781679481449-Updated\"},\"params\":{\"id\":\"15\"},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 06:58:01'),
(27, 1, 'delete', 'category', 15, '{\"body\":{},\"params\":{\"id\":\"15\"},\"query\":{}}', '::ffff:127.0.0.1', NULL, '2026-06-17 06:58:01'),
(28, 1, 'update', 'product', 14, '{\"body\":{\"name\":\"sadfssf vfgt\"},\"params\":{\"id\":\"14\"},\"query\":{}}', '::1', 'node', '2026-06-17 06:59:06'),
(29, 1, 'update', 'product', 14, '{\"body\":{\"name\":\"sadfssf vfgt (smoke 1600)\",\"status\":\"active\",\"category_id\":\"1\",\"sub_category_id\":\"6\"},\"params\":{\"id\":\"14\"},\"query\":{}}', '::1', 'node', '2026-06-17 07:04:21'),
(30, 1, 'update', 'product', 14, '{\"body\":{\"name\":\"sadfssf vfgt\",\"status\":\"active\",\"category_id\":\"1\",\"sub_category_id\":\"6\"},\"params\":{\"id\":\"14\"},\"query\":{}}', '::1', 'node', '2026-06-17 07:04:21');

-- --------------------------------------------------------

--
-- Table structure for table `banners`
--

CREATE TABLE `banners` (
  `id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(500) DEFAULT NULL,
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
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `banners`
--

INSERT INTO `banners` (`id`, `title`, `subtitle`, `description`, `image`, `mobile_image`, `type`, `position`, `link`, `button_text`, `button_link`, `sort_order`, `priority`, `start_date`, `end_date`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Summer Collection', 'Fresh arrivals for the season', 'Explore our new summer collection', 'uploads/banners/placeholder.svg', NULL, 'homepage', NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, 'active', '2026-06-15 06:51:34', '2026-06-17 07:29:33', '2026-06-17 07:29:33'),
(2, 'Festival Sale', 'Up to 50% off on ethnic wear', 'Celebrate with style', 'uploads/banners/placeholder.svg', NULL, 'slider', NULL, NULL, NULL, NULL, 2, 0, NULL, NULL, 'active', '2026-06-15 06:51:34', '2026-06-17 07:29:36', '2026-06-17 07:29:36'),
(3, 'New Arrivals', 'Check out the latest trends', 'Be the first to wear them', 'uploads/banners/placeholder.svg', NULL, 'promotional', NULL, NULL, NULL, NULL, 3, 0, NULL, NULL, 'active', '2026-06-15 06:51:34', '2026-06-17 07:29:39', '2026-06-17 07:29:39'),
(4, 'abc', NULL, NULL, 'uploads/banners/1781673588835-728682782.png', NULL, 'homepage', NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, 'active', '2026-06-17 05:19:48', '2026-06-17 05:19:48', NULL),
(5, 'Smoke Banner Updated 1781679861510', NULL, NULL, 'uploads/banners/1781679861489-743411448.png', NULL, 'homepage', NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, 'active', '2026-06-17 07:04:21', '2026-06-17 07:04:21', '2026-06-17 07:04:21');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `image`, `icon`, `status`, `sort_order`, `meta_title`, `meta_description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Sarees', 'sarees', 'Premium Sarees collection', NULL, NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(2, 'Kurtis', 'kurtis', 'Premium Kurtis collection', NULL, NULL, 'active', 1, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(3, 'Lehengas', 'lehengas', 'Premium Lehengas collection', NULL, NULL, 'active', 2, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(4, 'Dupattas', 'dupattas', 'Premium Dupattas collection', NULL, NULL, 'active', 3, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(6, 'Blouses', 'blouses', 'Premium Blouses collection', NULL, NULL, 'active', 5, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(7, 'Gowns', 'gowns', 'Premium Gowns collection', NULL, NULL, 'active', 6, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(8, 'Fusion Wear', 'fusion-wear', 'Premium Fusion Wear collection', NULL, NULL, 'active', 7, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(9, 'accessaries', 'accessaries', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-15 10:00:48', '2026-06-15 10:00:48', NULL),
(10, 'QA-Cat-1781672242918', 'qa-cat-1781672242918', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-17 04:57:22', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(11, 'TestCat123', 'testcat123', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-17 04:57:39', '2026-06-17 04:57:39', NULL),
(12, 'QA-Cat-1781672303915-Updated', 'qa-cat-1781672303915-updated', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-17 04:58:23', '2026-06-17 04:58:24', '2026-06-17 04:58:24'),
(13, 'Jest-Cat-1781672388889-Updated', 'jest-cat-1781672388889-updated', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-17 04:59:48', '2026-06-17 04:59:48', '2026-06-17 04:59:48'),
(14, 'Jest-Cat-1781673339259-Updated', 'jest-cat-1781673339259-updated', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-17 05:15:39', '2026-06-17 05:15:39', '2026-06-17 05:15:39'),
(15, 'Jest-Cat-1781679481449-Updated', 'jest-cat-1781679481449-updated', NULL, NULL, NULL, 'active', 0, NULL, NULL, '2026-06-17 06:58:01', '2026-06-17 06:58:01', '2026-06-17 06:58:01');

-- --------------------------------------------------------

--
-- Table structure for table `child_categories`
--

CREATE TABLE `child_categories` (
  `id` int(11) NOT NULL,
  `sub_category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `collections`
--

CREATE TABLE `collections` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `banner` varchar(500) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `status` enum('active','inactive') DEFAULT 'active',
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `collections`
--

INSERT INTO `collections` (`id`, `name`, `slug`, `description`, `image`, `banner`, `type`, `sort_order`, `status`, `meta_title`, `meta_description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'bmn bm,', 'bmn-bm', 'm mn', NULL, NULL, NULL, 0, 'active', NULL, NULL, '2026-06-17 07:32:05', '2026-06-17 07:32:05', NULL),
(2, 'df', 'df', 'gfgt', NULL, NULL, NULL, 0, 'active', NULL, NULL, '2026-06-17 07:48:20', '2026-06-17 07:48:20', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `collection_products`
--

CREATE TABLE `collection_products` (
  `id` int(11) NOT NULL,
  `collection_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `collection_products`
--

INSERT INTO `collection_products` (`id`, `collection_id`, `product_id`, `sort_order`, `created_at`) VALUES
(1, 1, 12, 0, '2026-06-17 07:32:05'),
(2, 2, 3, 0, '2026-06-17 07:48:20'),
(3, 2, 2, 1, '2026-06-17 07:48:20'),
(4, 2, 4, 2, '2026-06-17 07:48:20'),
(5, 2, 5, 3, '2026-06-17 07:48:20');

-- --------------------------------------------------------

--
-- Table structure for table `content_pages`
--

CREATE TABLE `content_pages` (
  `id` int(11) NOT NULL,
  `page_key` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `content_pages`
--

INSERT INTO `content_pages` (`id`, `page_key`, `title`, `content`, `image`, `status`, `created_at`, `updated_at`) VALUES
(1, 'about', 'About Us Smoke Test', '<p>Smoke test about content</p>', 'uploads/content/1781679861686-191600712.png', 'active', '2026-06-17 07:04:07', '2026-06-17 07:04:21'),
(2, 'contact', 'Contact Us', '{\"storeName\":\"LM Smoke Store\",\"email\":\"smoke@test.com\",\"mobile\":\"+91 9876543210\",\"alternateMobile\":\"+91 9998887776\",\"address\":\"123 Test Street\",\"googleMapsUrl\":\"https://maps.google.com/\",\"whatsappNumber\":\"+91 9876543210\"}', NULL, 'active', '2026-06-17 07:04:07', '2026-06-17 07:04:21'),
(3, 'privacy-policy', 'Privacy Policy Smoke', '<p>Privacy smoke content</p>', NULL, 'active', '2026-06-17 07:04:07', '2026-06-17 07:04:21'),
(4, 'terms-conditions', 'Terms Smoke', '<p>Terms smoke content</p>', NULL, 'active', '2026-06-17 07:04:07', '2026-06-17 07:04:21'),
(5, 'shipping-policy', 'Shipping Smoke', '<p>Shipping smoke content</p>', NULL, 'active', '2026-06-17 07:04:07', '2026-06-17 07:04:21'),
(6, 'refund-policy', 'Refund Smoke', '<p>Refund smoke content</p>', NULL, 'active', '2026-06-17 07:04:07', '2026-06-17 07:04:21');

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `type` enum('percentage','flat') NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `minimum_order_amount` decimal(10,2) DEFAULT 0.00,
  `maximum_discount` decimal(10,2) DEFAULT 0.00,
  `usage_limit` int(11) DEFAULT 0,
  `used_count` int(11) DEFAULT 0,
  `per_user_limit` int(11) DEFAULT 1,
  `is_for_new_customers` tinyint(1) DEFAULT 0,
  `start_date` date DEFAULT NULL,
  `expiry_date` date NOT NULL,
  `status` enum('active','inactive','expired') DEFAULT 'active',
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `type`, `value`, `minimum_order_amount`, `maximum_discount`, `usage_limit`, `used_count`, `per_user_limit`, `is_for_new_customers`, `start_date`, `expiry_date`, `status`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'WELCOME10', 'percentage', 10.00, 500.00, 500.00, 100, 0, 1, 0, NULL, '2027-12-31', 'active', NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(2, 'FESTIVE50', 'flat', 500.00, 2000.00, 500.00, 50, 0, 1, 0, NULL, '2026-12-31', 'active', NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(3, 'FREESHIP', 'percentage', 100.00, 499.00, 49.00, 200, 0, 1, 0, NULL, '2027-06-30', 'active', NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(4, 'NEWUSER', 'percentage', 20.00, 1000.00, 1000.00, 50, 0, 1, 0, NULL, '2026-12-31', 'active', NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(5, 'QA1781672243', 'percentage', 15.00, 0.00, 100.00, 10, 0, 1, 0, '2026-01-01', '2027-12-31', 'active', 'QA test coupon', '2026-06-17 04:57:23', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(6, 'QA1781672304', 'percentage', 15.00, 0.00, 100.00, 10, 0, 1, 0, '2026-01-01', '2027-12-31', 'active', 'QA test coupon', '2026-06-17 04:58:24', '2026-06-17 04:58:24', '2026-06-17 04:58:24'),
(7, 'GFHGNN B', 'percentage', 30.00, 0.00, 0.00, 0, 0, 1, 0, '2026-06-16', '2026-06-20', 'active', NULL, '2026-06-17 05:21:39', '2026-06-17 05:22:50', '2026-06-17 05:22:50'),
(8, 'TEST1781679546300', 'percentage', 10.00, 0.00, 0.00, 0, 0, 1, 0, NULL, '2026-12-31', 'active', NULL, '2026-06-17 06:59:06', '2026-06-17 06:59:06', '2026-06-17 06:59:06'),
(9, 'SMOKE861534', 'percentage', 20.00, 100.00, 0.00, 50, 0, 1, 0, '2026-02-01', '2026-11-30', 'active', NULL, '2026-06-17 07:04:21', '2026-06-17 07:04:21', '2026-06-17 07:04:21'),
(10, 'VB NN', 'percentage', 20.00, 0.00, 0.00, 0, 0, 1, 0, '2026-06-15', '2026-06-25', 'active', NULL, '2026-06-17 07:30:29', '2026-06-17 07:30:49', '2026-06-17 07:30:49');

-- --------------------------------------------------------

--
-- Table structure for table `coupon_usages`
--

CREATE TABLE `coupon_usages` (
  `id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `used_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar` varchar(500) DEFAULT NULL,
  `gender` enum('male','female','other') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `status` enum('active','inactive','blocked') DEFAULT 'active',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `total_orders` int(11) DEFAULT 0,
  `total_spent` decimal(12,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `first_name`, `last_name`, `email`, `password`, `phone`, `avatar`, `gender`, `date_of_birth`, `status`, `email_verified_at`, `last_login_at`, `total_orders`, `total_spent`, `notes`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Priya', 'Sharma', 'priya@email.com', '$2a$12$.twJLvdCOqxl6H5tIOlWwuUekn/SMvv0m.2RBoKxArwripXbBPWJ2', '9876543210', NULL, NULL, NULL, 'active', NULL, NULL, 0, 0.00, NULL, '2026-06-15 06:51:34', '2026-06-17 05:23:15', '2026-06-17 05:23:15'),
(2, 'Ananya', 'Verma', 'ananya@email.com', '$2a$12$.twJLvdCOqxl6H5tIOlWwuUekn/SMvv0m.2RBoKxArwripXbBPWJ2', '9876543211', NULL, NULL, NULL, 'active', NULL, NULL, 0, 0.00, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(3, 'Riya', 'Patel', 'riya@email.com', '$2a$12$.twJLvdCOqxl6H5tIOlWwuUekn/SMvv0m.2RBoKxArwripXbBPWJ2', '9876543212', NULL, NULL, NULL, 'active', NULL, NULL, 0, 0.00, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(4, 'Neha', 'Singh', 'neha@email.com', '$2a$12$.twJLvdCOqxl6H5tIOlWwuUekn/SMvv0m.2RBoKxArwripXbBPWJ2', '9876543213', NULL, NULL, NULL, 'active', NULL, NULL, 0, 0.00, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(5, 'Kavya', 'Reddy', 'kavya@email.com', '$2a$12$.twJLvdCOqxl6H5tIOlWwuUekn/SMvv0m.2RBoKxArwripXbBPWJ2', '9876543214', NULL, NULL, NULL, 'active', NULL, NULL, 0, 0.00, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `customer_addresses`
--

CREATE TABLE `customer_addresses` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `address_type` enum('billing','shipping','both') DEFAULT 'both',
  `full_name` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `address_line1` varchar(500) NOT NULL,
  `address_line2` varchar(500) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `pincode` varchar(10) NOT NULL,
  `country` varchar(100) DEFAULT 'India',
  `is_default` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `email_templates`
--

CREATE TABLE `email_templates` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `subject` varchar(500) NOT NULL,
  `body` longtext NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 0,
  `reserved_quantity` int(11) DEFAULT 0,
  `available_quantity` int(11) DEFAULT 0,
  `low_stock_threshold` int(11) DEFAULT 5,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `product_id`, `quantity`, `reserved_quantity`, `available_quantity`, `low_stock_threshold`, `created_at`, `updated_at`) VALUES
(1, 1, 51, 0, 51, 5, '2026-06-15 06:51:34', '2026-06-17 05:23:48'),
(2, 2, 100, 0, 100, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(3, 3, 30, 0, 30, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(4, 4, 80, 0, 80, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(5, 5, 150, 0, 150, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(6, 6, 45, 0, 45, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(7, 7, 10, 0, 10, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(8, 8, 20, 0, 20, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(9, 9, 100, 0, 100, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(10, 10, 60, 0, 60, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(11, 11, 40, 0, 40, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(12, 12, 55, 0, 55, 5, '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(13, 13, 0, 0, 0, 5, '2026-06-16 06:29:53', '2026-06-16 06:29:53'),
(14, 14, 0, 0, 0, 5, '2026-06-16 11:38:19', '2026-06-16 11:38:19');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_logs`
--

CREATE TABLE `inventory_logs` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `type` enum('purchase','sale','adjustment','return','transfer') NOT NULL,
  `quantity` int(11) NOT NULL,
  `previous_quantity` int(11) DEFAULT NULL,
  `new_quantity` int(11) DEFAULT NULL,
  `reference_type` varchar(100) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_logs`
--

INSERT INTO `inventory_logs` (`id`, `product_id`, `type`, `quantity`, `previous_quantity`, `new_quantity`, `reference_type`, `reference_id`, `notes`, `created_by`, `created_at`) VALUES
(1, 1, 'return', 1, NULL, NULL, 'order', 1, 'Order cancelled', NULL, '2026-06-17 05:23:48');

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` int(11) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `original_name` varchar(500) NOT NULL,
  `path` varchar(500) NOT NULL,
  `url` varchar(500) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `folder` varchar(255) DEFAULT 'general',
  `alt_text` varchar(255) DEFAULT NULL,
  `uploaded_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `filename`, `original_name`, `path`, `url`, `type`, `size`, `width`, `height`, `mime_type`, `folder`, `alt_text`, `uploaded_by`, `created_at`) VALUES
(1, '1781675299356-897091741.png', 'dsnaturals-logo-6-300x233.png', 'C:/Users/Dell/Downloads/LM/LM/backend/uploads/media/1781675299356-897091741.png', 'uploads/media/1781675299356-897091741.png', 'image', 79196, NULL, NULL, 'image/png', 'settings', 'dsnaturals-logo-6-300x233.png', 1, '2026-06-17 05:48:19'),
(2, '1781675359807-767561484.png', 'dsnaturals-logo-6-300x233.png', 'C:/Users/Dell/Downloads/LM/LM/backend/uploads/media/1781675359807-767561484.png', 'uploads/media/1781675359807-767561484.png', 'image', 79196, NULL, NULL, 'image/png', 'settings', 'dsnaturals-logo-6-300x233.png', 1, '2026-06-17 05:49:19'),
(3, '1781682281964-514191296.png', 'dsnaturals-logo-6-300x233.png', 'C:/Users/Dell/Downloads/LM/LM/backend/uploads/media/1781682281964-514191296.png', 'uploads/media/1781682281964-514191296.png', 'image', 79196, NULL, NULL, 'image/png', 'settings', 'dsnaturals-logo-6-300x233.png', 1, '2026-06-17 07:44:41'),
(4, '1781759897743-819392722.png', 'dsnaturals-logo-6-300x233.png', 'C:/Users/Dell/Downloads/LM/LM/backend/uploads/media/1781759897743-819392722.png', 'uploads/media/1781759897743-819392722.png', 'image', 79196, NULL, NULL, 'image/png', 'settings', 'dsnaturals-logo-6-300x233.png', 1, '2026-06-18 05:18:17');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data`)),
  `channel` enum('email','sms','push','in_app','all') DEFAULT 'in_app',
  `recipient_type` enum('admin','customer','all','specific') DEFAULT 'all',
  `recipient_id` int(11) DEFAULT NULL,
  `sent_at` timestamp NULL DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `offers`
--

CREATE TABLE `offers` (
  `id` int(11) NOT NULL,
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
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_number` varchar(50) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `billing_address_id` int(11) DEFAULT NULL,
  `shipping_address_id` int(11) DEFAULT NULL,
  `shipping_name` varchar(255) DEFAULT NULL,
  `shipping_phone` varchar(20) DEFAULT NULL,
  `shipping_address` varchar(500) DEFAULT NULL,
  `shipping_city` varchar(100) DEFAULT NULL,
  `shipping_state` varchar(100) DEFAULT NULL,
  `shipping_pincode` varchar(10) DEFAULT NULL,
  `shipping_country` varchar(100) DEFAULT 'India',
  `billing_name` varchar(255) DEFAULT NULL,
  `billing_phone` varchar(20) DEFAULT NULL,
  `billing_address` varchar(500) DEFAULT NULL,
  `billing_city` varchar(100) DEFAULT NULL,
  `billing_state` varchar(100) DEFAULT NULL,
  `billing_pincode` varchar(10) DEFAULT NULL,
  `billing_country` varchar(100) DEFAULT 'India',
  `subtotal` decimal(12,2) NOT NULL DEFAULT 0.00,
  `discount_amount` decimal(12,2) DEFAULT 0.00,
  `coupon_id` int(11) DEFAULT NULL,
  `coupon_code` varchar(50) DEFAULT NULL,
  `discount_type` varchar(20) DEFAULT NULL,
  `shipping_charge` decimal(10,2) DEFAULT 0.00,
  `tax_amount` decimal(12,2) DEFAULT 0.00,
  `gst_amount` decimal(12,2) DEFAULT 0.00,
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(12,2) DEFAULT 0.00,
  `due_amount` decimal(12,2) DEFAULT 0.00,
  `payment_method` varchar(50) DEFAULT 'cod',
  `payment_status` enum('pending','paid','failed','refunded','partially_refunded') DEFAULT 'pending',
  `payment_id` varchar(255) DEFAULT NULL,
  `order_status` enum('pending','confirmed','packed','shipped','delivered','cancelled','returned','refunded') DEFAULT 'pending',
  `shipping_method` varchar(100) DEFAULT NULL,
  `tracking_number` varchar(255) DEFAULT NULL,
  `tracking_url` varchar(500) DEFAULT NULL,
  `estimated_delivery` date DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `admin_notes` text DEFAULT NULL,
  `is_paid` tinyint(1) DEFAULT 0,
  `is_cod` tinyint(1) DEFAULT 0,
  `invoice_number` varchar(100) DEFAULT NULL,
  `invoice_generated_at` timestamp NULL DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_number`, `customer_id`, `admin_id`, `email`, `phone`, `billing_address_id`, `shipping_address_id`, `shipping_name`, `shipping_phone`, `shipping_address`, `shipping_city`, `shipping_state`, `shipping_pincode`, `shipping_country`, `billing_name`, `billing_phone`, `billing_address`, `billing_city`, `billing_state`, `billing_pincode`, `billing_country`, `subtotal`, `discount_amount`, `coupon_id`, `coupon_code`, `discount_type`, `shipping_charge`, `tax_amount`, `gst_amount`, `total_amount`, `paid_amount`, `due_amount`, `payment_method`, `payment_status`, `payment_id`, `order_status`, `shipping_method`, `tracking_number`, `tracking_url`, `estimated_delivery`, `delivered_at`, `notes`, `admin_notes`, `is_paid`, `is_cod`, `invoice_number`, `invoice_generated_at`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'LM-1781506294804-1', 1, NULL, 'priya@email.com', '9876543210', NULL, NULL, 'Priya Sharma', '9876543210', '123, Main Street', 'Mumbai', 'Maharashtra', '400001', 'India', NULL, NULL, NULL, NULL, NULL, NULL, 'India', 4000.00, 0.00, NULL, NULL, NULL, 49.00, 0.00, 0.00, 4049.00, 0.00, 0.00, 'online', 'paid', NULL, 'cancelled', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, 1, '2026-06-15 06:51:34', '2026-06-17 07:31:16', NULL),
(2, 'LM-1781506294822-2', 2, NULL, 'ananya@email.com', '9876543211', NULL, NULL, 'Ananya Verma', '9876543211', '123, Main Street', 'Mumbai', 'Maharashtra', '400001', 'India', NULL, NULL, NULL, NULL, NULL, NULL, 'India', 5000.00, 0.00, NULL, NULL, NULL, 49.00, 0.00, 0.00, 5049.00, 0.00, 0.00, 'razorpay', 'pending', NULL, 'confirmed', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, 1, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(3, 'LM-1781506294833-3', 3, NULL, 'riya@email.com', '9876543212', NULL, NULL, 'Riya Patel', '9876543212', '123, Main Street', 'Mumbai', 'Maharashtra', '400001', 'India', NULL, NULL, NULL, NULL, NULL, NULL, 'India', 6000.00, 0.00, NULL, NULL, NULL, 49.00, 0.00, 0.00, 6049.00, 0.00, 0.00, 'cod', 'paid', NULL, 'packed', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, 1, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(4, 'LM-1781506294875-4', 4, NULL, 'neha@email.com', '9876543213', NULL, NULL, 'Neha Singh', '9876543213', '123, Main Street', 'Mumbai', 'Maharashtra', '400001', 'India', NULL, NULL, NULL, NULL, NULL, NULL, 'India', 7000.00, 0.00, NULL, NULL, NULL, 49.00, 0.00, 0.00, 7049.00, 0.00, 0.00, 'online', 'pending', NULL, 'shipped', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL, 1, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(5, 'LM-1781506294891-5', 5, NULL, 'kavya@email.com', '9876543214', NULL, NULL, 'Kavya Reddy', '9876543214', '123, Main Street', 'Mumbai', 'Maharashtra', '400001', 'India', NULL, NULL, NULL, NULL, NULL, NULL, 'India', 8000.00, 0.00, NULL, NULL, NULL, 49.00, 0.00, 0.00, 8049.00, 0.00, 0.00, 'razorpay', 'paid', NULL, 'delivered', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, 1, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_name` varchar(500) NOT NULL,
  `product_sku` varchar(100) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `variant_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variant_info`)),
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price` decimal(12,2) NOT NULL,
  `offer_price` decimal(12,2) DEFAULT NULL,
  `total_price` decimal(12,2) NOT NULL,
  `gst_percent` decimal(5,2) DEFAULT 0.00,
  `gst_amount` decimal(12,2) DEFAULT 0.00,
  `image` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `product_name`, `product_sku`, `variant_id`, `variant_info`, `quantity`, `price`, `offer_price`, `total_price`, `gst_percent`, `gst_amount`, `image`, `created_at`) VALUES
(1, 1, 1, 'Traditional Banarasi Silk Saree', 'SKU-1', NULL, NULL, 1, 4200.00, NULL, 4200.00, 0.00, 0.00, NULL, '2026-06-15 06:51:34'),
(2, 2, 2, 'Handloom Cotton Saree', 'SKU-2', NULL, NULL, 1, 1500.00, NULL, 1500.00, 0.00, 0.00, NULL, '2026-06-15 06:51:34'),
(3, 3, 3, 'Designer Kanjivaram Silk Saree', 'SKU-3', NULL, NULL, 1, 6500.00, NULL, 6500.00, 0.00, 0.00, NULL, '2026-06-15 06:51:34'),
(4, 4, 4, 'Elegant Anarkali Kurti', 'SKU-4', NULL, NULL, 1, 1800.00, NULL, 1800.00, 0.00, 0.00, NULL, '2026-06-15 06:51:34'),
(5, 5, 5, 'Cotton Straight Cut Kurti', 'SKU-5', NULL, NULL, 1, 899.00, NULL, 899.00, 0.00, 0.00, NULL, '2026-06-15 06:51:34');

-- --------------------------------------------------------

--
-- Table structure for table `order_notes`
--

CREATE TABLE `order_notes` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `note` text NOT NULL,
  `note_type` enum('admin','customer','system') DEFAULT 'admin',
  `created_by` int(11) DEFAULT NULL,
  `is_visible_to_customer` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_timeline`
--

CREATE TABLE `order_timeline` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `status` varchar(50) NOT NULL,
  `note` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_timeline`
--

INSERT INTO `order_timeline` (`id`, `order_id`, `status`, `note`, `created_by`, `created_at`) VALUES
(1, 1, 'pending', 'Order placed', NULL, '2026-06-15 06:51:34'),
(2, 2, 'pending', 'Order placed', NULL, '2026-06-15 06:51:34'),
(3, 3, 'pending', 'Order placed', NULL, '2026-06-15 06:51:34'),
(4, 4, 'pending', 'Order placed', NULL, '2026-06-15 06:51:34'),
(5, 5, 'pending', 'Order placed', NULL, '2026-06-15 06:51:34'),
(6, 1, 'cancelled', 'Order status changed to cancelled', 1, '2026-06-17 05:23:48'),
(7, 1, 'payment_paid', 'Payment status changed to paid', 1, '2026-06-17 07:31:16'),
(8, 1, 'cancelled', 'Order status changed to cancelled', 1, '2026-06-17 07:31:19');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `email`, `token`, `expires_at`, `used_at`, `created_at`) VALUES
(1, 'admin@lms.com', '8827f4b20ac5d1d43c2d398d911066becac80a9b16dadcadf792d8550043647c', '2026-06-17 06:15:39', NULL, '2026-06-17 05:15:39'),
(2, 'admin@lms.com', '3fd10291548a88cecc2fb28713990e3fa3d4a0e97fccd6c2a48ebc087f6bdeb4', '2026-06-17 07:58:01', NULL, '2026-06-17 06:58:01');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `module` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(500) NOT NULL,
  `slug` varchar(500) NOT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `sub_category_id` int(11) DEFAULT NULL,
  `child_category_id` int(11) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `offer_price` decimal(12,2) DEFAULT 0.00,
  `discount_percentage` int(11) DEFAULT 0,
  `cost_price` decimal(12,2) DEFAULT 0.00,
  `stock` int(11) DEFAULT 0,
  `stock_status` enum('in_stock','out_of_stock','low_stock') DEFAULT 'in_stock',
  `low_stock_threshold` int(11) DEFAULT 5,
  `size` varchar(255) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL,
  `material` varchar(255) DEFAULT NULL,
  `fabric` varchar(255) DEFAULT NULL,
  `occasion` varchar(255) DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `unit` varchar(20) DEFAULT 'pcs',
  `short_description` text DEFAULT NULL,
  `long_description` longtext DEFAULT NULL,
  `specifications` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`specifications`)),
  `tags` text DEFAULT NULL,
  `thumbnail` varchar(500) DEFAULT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `gst_percent` decimal(5,2) DEFAULT 0.00,
  `shipping_charge` decimal(10,2) DEFAULT 0.00,
  `is_featured` tinyint(1) DEFAULT 0,
  `is_trending` tinyint(1) DEFAULT 0,
  `is_best_seller` tinyint(1) DEFAULT 0,
  `is_new_arrival` tinyint(1) DEFAULT 0,
  `status` enum('active','inactive','draft') DEFAULT 'active',
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `meta_keywords` text DEFAULT NULL,
  `total_sales` int(11) DEFAULT 0,
  `avg_rating` decimal(3,2) DEFAULT 0.00,
  `review_count` int(11) DEFAULT 0,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `slug`, `sku`, `category_id`, `sub_category_id`, `child_category_id`, `brand`, `price`, `offer_price`, `discount_percentage`, `cost_price`, `stock`, `stock_status`, `low_stock_threshold`, `size`, `color`, `material`, `fabric`, `occasion`, `weight`, `unit`, `short_description`, `long_description`, `specifications`, `tags`, `thumbnail`, `video_url`, `gst_percent`, `shipping_charge`, `is_featured`, `is_trending`, `is_best_seller`, `is_new_arrival`, `status`, `meta_title`, `meta_description`, `meta_keywords`, `total_sales`, `avg_rating`, `review_count`, `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Traditional Banarasi Silk Saree', 'traditional-banarasi-silk-saree', 'PRO-1781506294316-IGGI', 1, 3, NULL, NULL, 5000.00, 4200.00, 16, 0.00, 51, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful traditional banarasi silk saree - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 1, 1, 1, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-17 05:23:48', NULL),
(2, 'Handloom Cotton Saree', 'handloom-cotton-saree', 'PRO-1781506294333-I6N9', 1, 2, NULL, NULL, 2000.00, 1500.00, 25, 0.00, 100, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful handloom cotton saree - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 1, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(3, 'Designer Kanjivaram Silk Saree', 'designer-kanjivaram-silk-saree', 'PRO-1781506294342-GY5J', 1, 4, NULL, NULL, 8000.00, 6500.00, 19, 0.00, 30, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful designer kanjivaram silk saree - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 1, 1, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(4, 'Elegant Anarkali Kurti', 'elegant-anarkali-kurti', 'PRO-1781506294350-I2H6', 2, 7, NULL, NULL, 2500.00, 1800.00, 28, 0.00, 80, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful elegant anarkali kurti - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 1, 1, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(5, 'Cotton Straight Cut Kurti', 'cotton-straight-cut-kurti', 'PRO-1781506294359-ZEQI', 2, 8, NULL, NULL, 1200.00, 899.00, 25, 0.00, 150, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful cotton straight cut kurti - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 0, 1, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(6, 'Designer A-Line Kurti Set', 'designer-a-line-kurti-set', 'PRO-1781506294368-P5DP', 2, 9, NULL, NULL, 3000.00, 2200.00, 27, 0.00, 45, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful designer a-line kurti set - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 1, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(7, 'Premium Bridal Lehenga', 'premium-bridal-lehenga', 'PRO-1781506294376-8CGM', 3, 12, NULL, NULL, 25000.00, 18999.00, 24, 0.00, 10, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful premium bridal lehenga - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 1, 1, 1, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-17 05:26:03', '2026-06-17 05:26:03'),
(8, 'Party Wear Lehenga Choli', 'party-wear-lehenga-choli', 'PRO-1781506294385-K5X9', 3, 13, NULL, NULL, 15000.00, 11000.00, 27, 0.00, 20, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful party wear lehenga choli - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 1, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(9, 'Traditional Silk Dupatta', 'traditional-silk-dupatta', 'PRO-1781506294393-10E9', 4, NULL, NULL, NULL, 1500.00, 999.00, 33, 0.00, 100, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful traditional silk dupatta - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(10, 'Designer Jewelry Set', 'designer-jewelry-set', 'PRO-1781506294401-LS0W', NULL, NULL, NULL, NULL, 3500.00, 2500.00, 29, 0.00, 60, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful designer jewelry set - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 1, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(11, 'Embroidered Designer Blouse', 'embroidered-designer-blouse', 'PRO-1781506294409-DNOS', 6, 22, NULL, NULL, 2500.00, 1800.00, 28, 0.00, 40, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful embroidered designer blouse - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(12, 'Silk Designer Blouse Piece', 'silk-designer-blouse-piece', 'PRO-1781506294416-KNKU', 6, 23, NULL, NULL, 1800.00, 1200.00, 33, 0.00, 55, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'Beautiful silk designer blouse piece - perfect for any occasion', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(13, 'sareesadlk,dlfmfmr', 'sareesadlkdlfmfmr', 'CAT-SAR-1781591393937', 1, 3, NULL, NULL, 67.00, 657.00, -881, 878.00, 0, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'ffjuhjo', '<p>fvc gvhljk</p>', '\"{\\\"fgfh\\\":\\\"gfguj\\\",\\\"product_type\\\":\\\"v gbv\\\"}\"', 'nmjcnkv', NULL, NULL, 6.00, 0.00, 0, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, 1, '2026-06-16 06:29:53', '2026-06-16 06:29:53', NULL),
(14, 'sadfssf vfgt', 'sadfssf-vfgt', 'CAT-SAD-1781609899205', 1, 6, NULL, NULL, 768798.00, 454656.00, 41, 6788.00, 0, 'in_stock', 5, NULL, NULL, NULL, NULL, NULL, NULL, 'pcs', 'uik,m,m', '<p>n,m,bmjk</p>', '{\"kj\":\"kj\",\"product_type\":\"kjkghjm\"}', 'dfd,fhg btjh', NULL, NULL, 1.00, 0.00, 0, 0, 0, 0, 'active', NULL, NULL, NULL, 0, 0.00, 0, 1, 1, '2026-06-16 11:38:19', '2026-06-17 07:04:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `image` varchar(500) NOT NULL,
  `image_type` enum('thumbnail','gallery') DEFAULT 'gallery',
  `sort_order` int(11) DEFAULT 0,
  `alt_text` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_images`
--

INSERT INTO `product_images` (`id`, `product_id`, `image`, `image_type`, `sort_order`, `alt_text`, `created_at`) VALUES
(1, 13, 'uploads/products/1781591393926-830532075.png', 'thumbnail', 0, NULL, '2026-06-16 06:29:53'),
(2, 13, 'uploads/products/1781591393928-613683454.png', 'gallery', 1, NULL, '2026-06-16 06:29:53'),
(3, 14, 'uploads/products/1781609899151-531232247.png', 'thumbnail', 0, NULL, '2026-06-16 11:38:19');

-- --------------------------------------------------------

--
-- Table structure for table `product_seo`
--

CREATE TABLE `product_seo` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `seo_title` varchar(255) DEFAULT NULL,
  `seo_description` text DEFAULT NULL,
  `keywords` text DEFAULT NULL,
  `canonical_url` varchar(500) DEFAULT NULL,
  `meta_robots` varchar(50) DEFAULT 'index,follow',
  `og_title` varchar(255) DEFAULT NULL,
  `og_description` text DEFAULT NULL,
  `og_image` varchar(500) DEFAULT NULL,
  `twitter_title` varchar(255) DEFAULT NULL,
  `twitter_description` text DEFAULT NULL,
  `twitter_image` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_seo`
--

INSERT INTO `product_seo` (`id`, `product_id`, `seo_title`, `seo_description`, `keywords`, `canonical_url`, `meta_robots`, `og_title`, `og_description`, `og_image`, `twitter_title`, `twitter_description`, `twitter_image`, `created_at`, `updated_at`) VALUES
(1, 13, 'fdfvbhgv', 'fbhgfnh gjn', NULL, NULL, 'index,follow', NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-16 06:29:54', '2026-06-16 06:29:54'),
(2, 14, 'n bhjm', 'hkmjhhmk', NULL, NULL, 'index,follow', NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-16 11:38:19', '2026-06-16 11:38:19');

-- --------------------------------------------------------

--
-- Table structure for table `product_variants`
--

CREATE TABLE `product_variants` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `sku` varchar(100) DEFAULT NULL,
  `size` varchar(50) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT NULL,
  `offer_price` decimal(12,2) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `image` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_variants`
--

INSERT INTO `product_variants` (`id`, `product_id`, `sku`, `size`, `color`, `price`, `offer_price`, `stock`, `image`, `status`, `created_at`, `updated_at`) VALUES
(1, 14, 'VAR-14-000', 'hgb', NULL, 768798.00, 454656.00, 0, NULL, 'active', '2026-06-16 11:38:19', '2026-06-16 11:38:19');

-- --------------------------------------------------------

--
-- Table structure for table `product_variant_options`
--

CREATE TABLE `product_variant_options` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `option_name` varchar(100) NOT NULL,
  `option_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`option_values`)),
  `sort_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_variant_options`
--

INSERT INTO `product_variant_options` (`id`, `product_id`, `option_name`, `option_values`, `sort_order`, `created_at`, `updated_at`) VALUES
(1, 14, 'Size', '[\"hgb\"]', 0, '2026-06-16 11:38:19', '2026-06-16 11:38:19');

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `token` varchar(500) NOT NULL,
  `expires_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `revoked_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `admin_id`, `customer_id`, `token`, `expires_at`, `revoked_at`, `created_at`) VALUES
(1, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTEwNzg1LCJleHAiOjE3ODIxMTU1ODUsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.Q764XtSRSrAXtEvgR53S3VWSI5r6M6tDN3xy6H0ILds', '2026-06-22 08:06:25', NULL, '2026-06-15 08:06:25'),
(2, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTEwODYxLCJleHAiOjE3ODIxMTU2NjEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.tRxDxjmnZZvktngjcbZL3uiBn7htwC2Fzxlj59vennQ', '2026-06-22 08:07:41', NULL, '2026-06-15 08:07:41'),
(3, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTExMTYyLCJleHAiOjE3ODIxMTU5NjIsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ._qq3WmJ3mmNqBJGS8SZCdHaQSh-wuJOspkyI1eyzg1I', '2026-06-22 08:12:42', NULL, '2026-06-15 08:12:42'),
(4, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTE2NTkyLCJleHAiOjE3ODIxMjEzOTIsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.MD4wHTCpNpycZwq33ign4DHGKEEUZqNyugdq5cLn1TE', '2026-06-22 09:43:12', NULL, '2026-06-15 09:43:12'),
(5, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTIwOTUxLCJleHAiOjE3ODIxMjU3NTEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.HsEjCKyHZVuiYcsUEs0XDP2YMV3wAcuFIMk-vV08_90', '2026-06-22 10:55:51', NULL, '2026-06-15 10:55:51'),
(6, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTI0NzA5LCJleHAiOjE3ODIxMjk1MDksImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.rEEjzpHCkxO9m36UJU-nIFWF1dlAG1mn8-dwZDqnlDA', '2026-06-22 11:58:29', NULL, '2026-06-15 11:58:29'),
(7, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTg0NDEzLCJleHAiOjE3ODIxODkyMTMsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.CXFkQrCxpb8brffzeaNaznWed6n-S9bHebdoqzytb1U', '2026-06-23 04:33:33', NULL, '2026-06-16 04:33:33'),
(8, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNTkwODA1LCJleHAiOjE3ODIxOTU2MDUsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.tXVtLMvBeTLjPldiu9Pam0ig7O9yaJCgBoc90dK7q14', '2026-06-23 06:20:05', NULL, '2026-06-16 06:20:05'),
(9, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjAxMzM3LCJleHAiOjE3ODIyMDYxMzcsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.iLJrnKh-mzmWXK_69KRY_hq0ljGk2Pn50br6WHckNQY', '2026-06-23 09:15:37', NULL, '2026-06-16 09:15:37'),
(10, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjA4NTc4LCJleHAiOjE3ODIyMTMzNzgsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.bGrz7y2W2uHt9FR4i42b_m8_zmBfNEbRLm9jg7uup6E', '2026-06-17 05:18:53', '2026-06-17 05:18:53', '2026-06-16 11:16:18'),
(11, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjcxMTUzLCJleHAiOjE3ODIyNzU5NTMsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.1pS3wFu_t1_NNcUMjPJTRcQ3ks3KJ-vXOvOvHPWXlyk', '2026-06-18 04:50:42', '2026-06-18 04:50:42', '2026-06-17 04:39:13'),
(12, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjcyMjQyLCJleHAiOjE3ODIyNzcwNDIsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.G5TIjFQagyFh8PbwYiNJmbmnZQUSTjM7MpxqrwbDYeI', '2026-06-24 04:57:22', NULL, '2026-06-17 04:57:22'),
(13, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjcyMjU5LCJleHAiOjE3ODIyNzcwNTksImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.reCoIBCxNVJw5YWKrM8QWeVrg9EaFkkVXsG1ZvPwm4A', '2026-06-24 04:57:39', NULL, '2026-06-17 04:57:39'),
(14, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjcyMzAzLCJleHAiOjE3ODIyNzcxMDMsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.9jDt77msGdS54NG6q8NlTKHHPKDwo_snb7s9M9Hv5gc', '2026-06-24 04:58:23', NULL, '2026-06-17 04:58:23'),
(15, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwiaWF0IjoxNzgxNjcyMzg4LCJleHAiOjE3ODIyNzcxODgsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.we856UnKtj7QhKvBGZbeKaSXiVPXWE4oB5UTaKML5_M', '2026-06-24 04:59:48', NULL, '2026-06-17 04:59:48'),
(16, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjczMzM4LCJleHAiOjE3ODIyNzgxMzgsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ._mZadfbH6MXr-rJEeZYGirlEkDLJ8Priow-003tzKk0', '2026-06-17 05:15:39', '2026-06-17 05:15:39', '2026-06-17 05:15:38'),
(17, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjczMzM5LCJleHAiOjE3ODIyNzgxMzksImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.mncyml8cy-ASLnrxzd0w9aF2ZbjKVR76Xp_pN1j5HTk', '2026-06-24 05:15:39', NULL, '2026-06-17 05:15:39'),
(18, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjczNTMzLCJleHAiOjE3ODIyNzgzMzMsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.rWvolwWvVZz1fok7NvhqKEFBCNpp8hvxQhpm9Bickvc', '2026-06-17 06:27:42', '2026-06-17 06:27:42', '2026-06-17 05:18:53'),
(19, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjc3NjYyLCJleHAiOjE3ODIyODI0NjIsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.1pZOzDN7tL_y_hHHivaqYMS-XNXIQkSrCMZBg-LRWtk', '2026-06-17 07:28:27', '2026-06-17 07:28:27', '2026-06-17 06:27:42'),
(20, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjc5NDgxLCJleHAiOjE3ODIyODQyODEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.HSUxMKUVtoKxodNjJBhlOWup765_DrQ72MUlKhHNk1M', '2026-06-17 06:58:01', '2026-06-17 06:58:01', '2026-06-17 06:58:01'),
(21, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjc5NDgxLCJleHAiOjE3ODIyODQyODEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.HSUxMKUVtoKxodNjJBhlOWup765_DrQ72MUlKhHNk1M', '2026-06-24 06:58:01', NULL, '2026-06-17 06:58:01'),
(22, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjc5NTI2LCJleHAiOjE3ODIyODQzMjYsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.GWa4qLUJ-QCdbZoS0KN6VjexTK_d1RpP-j8xdFqP4yQ', '2026-06-24 06:58:46', NULL, '2026-06-17 06:58:46'),
(23, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjc5NTQ2LCJleHAiOjE3ODIyODQzNDYsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.-2Uf4sXlIz8hLxQ5hrpbiKrTiG2RKnAZ63jq41O4GJU', '2026-06-24 06:59:06', NULL, '2026-06-17 06:59:06'),
(24, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjc5ODYxLCJleHAiOjE3ODIyODQ2NjEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.YDnzkrTxkZCItagOnhkBIZyHegrVjZiTww-7oFv-Jeg', '2026-06-24 07:04:21', NULL, '2026-06-17 07:04:21'),
(25, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNjgxMzA3LCJleHAiOjE3ODIyODYxMDcsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.WMg5zqq_UeFoEqJ7_lXEbhg294Ca5-n0APGUw6_CfAo', '2026-06-24 07:28:27', NULL, '2026-06-17 07:28:27'),
(26, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNzU4MjQyLCJleHAiOjE3ODIzNjMwNDIsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.9eXkiOKFb35ZQA43aFy-1GTfRPSnux9ldg6fVb_Vdmw', '2026-06-18 05:56:21', '2026-06-18 05:56:21', '2026-06-18 04:50:42'),
(27, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNzYyMTgxLCJleHAiOjE3ODIzNjY5ODEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.4d64n15GPx8r-XsS1Hds9o0OGOwiWucVwhd_aCWjsSU', '2026-06-18 06:57:40', '2026-06-18 06:57:40', '2026-06-18 05:56:21'),
(28, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxNzY1ODYwLCJleHAiOjE3ODIzNzA2NjAsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.QHJso-PdvEqA6cZJYGCEf7hCBS1Tp34W7akIAqIOGiE', '2026-06-19 05:58:41', '2026-06-19 05:58:41', '2026-06-18 06:57:40'),
(29, 1, NULL, 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiZW1haWwiOiJhZG1pbkBsbXMuY29tIiwicm9sZSI6InN1cGVyX2FkbWluIiwibmFtZSI6IlN1cGVyIEFkbWluIiwiaWF0IjoxNzgxODQ4NzIxLCJleHAiOjE3ODI0NTM1MjEsImlzcyI6IkxNIFNob3BwaW5nIE1hbGwifQ.cNVp5m9T0JV51Fk_TugN_fmsICs4x5pR9ve2PUNK_x0', '2026-06-26 05:58:41', NULL, '2026-06-19 05:58:41');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` >= 1 and `rating` <= 5),
  `title` varchar(255) DEFAULT NULL,
  `review` text DEFAULT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`images`)),
  `is_verified_purchase` tinyint(1) DEFAULT 0,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `admin_reply` text DEFAULT NULL,
  `replied_at` timestamp NULL DEFAULT NULL,
  `replied_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `slug`, `description`, `permissions`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Super Admin', 'super-admin', 'Full access to all features', NULL, 'active', '2026-06-15 06:51:33', '2026-06-15 06:51:33', NULL),
(2, 'Admin', 'admin', 'Administrative access with limited controls', NULL, 'active', '2026-06-15 06:51:33', '2026-06-15 06:51:33', NULL),
(3, 'Manager', 'manager', 'Can manage products, orders, and customers', NULL, 'active', '2026-06-15 06:51:33', '2026-06-15 06:51:33', NULL),
(4, 'Staff', 'staff', 'Limited staff access', NULL, 'active', '2026-06-15 06:51:33', '2026-06-15 06:51:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `group_name` varchar(100) NOT NULL,
  `key_name` varchar(100) NOT NULL,
  `value` longtext DEFAULT NULL,
  `type` enum('text','number','boolean','json','image','email') DEFAULT 'text',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `group_name`, `key_name`, `value`, `type`, `created_at`, `updated_at`) VALUES
(1, 'general', 'store_name', 'LM Shopping Mall', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(2, 'general', 'store_email', 'info@lmshoppingmall.com', 'email', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(3, 'general', 'store_phone', '+91 9876543210', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(4, 'general', 'store_address', '123, Fashion Street, Mumbai - 400001', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(5, 'general', 'store_currency', 'INR', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(6, 'general', 'store_currency_symbol', '₹', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(7, 'seo', 'meta_title', 'LM Shopping Mall - Premium Fashion Store', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(8, 'seo', 'meta_description', 'Shop premium sarees, kurtis, lehengas and more', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(9, 'smtp', 'smtp_host', 'smtp.gmail.com', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(10, 'smtp', 'smtp_port', '587', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(11, 'payment', 'cod_enabled', 'true', 'boolean', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(12, 'payment', 'online_payment_enabled', 'true', 'boolean', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(13, 'shipping', 'free_shipping_minimum', '499', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(14, 'shipping', 'shipping_charge', '49', 'text', '2026-06-15 06:51:34', '2026-06-15 06:51:34'),
(15, 'store', 'storeName', 'sdffghj', 'text', '2026-06-15 10:05:22', '2026-06-18 05:18:34'),
(16, 'store', 'email', 'syhtjuk', 'text', '2026-06-15 10:05:22', '2026-06-15 10:05:22'),
(17, 'store', 'phone', '356680-0=-', 'text', '2026-06-15 10:05:22', '2026-06-15 10:05:22'),
(18, 'store', 'logoUrl', 'uploads/media/1781759897743-819392722.png', 'text', '2026-06-15 10:05:22', '2026-06-18 05:18:19'),
(19, 'store', 'logoSize', '36', 'text', '2026-06-15 10:05:22', '2026-06-15 10:05:22'),
(20, 'store', 'address', 'fyhtkiuk', 'text', '2026-06-15 10:05:22', '2026-06-15 10:05:22'),
(21, 'store', 'supportEmail', 'jmkjhyujtyk', 'text', '2026-06-15 10:05:22', '2026-06-15 10:06:50'),
(22, 'store', 'whatsapp', 'jhk7698098', 'text', '2026-06-15 10:05:22', '2026-06-15 10:06:50'),
(23, 'store', 'location', 'jklbil', 'text', '2026-06-15 10:05:22', '2026-06-15 10:06:51'),
(24, 'store', 'mapLocation', 'jhkuj', 'text', '2026-06-15 10:05:22', '2026-06-15 10:06:51'),
(25, 'privacy', 'privacyPolicy', 'yhkiulok', 'text', '2026-06-15 10:05:56', '2026-06-15 10:05:56'),
(26, 'terms', 'termsContent', 'juykik', 'text', '2026-06-15 10:06:25', '2026-06-15 10:06:25'),
(37, 'store_information', 'companyName', 'sdffghj', 'text', '2026-06-17 04:57:23', '2026-06-18 05:18:34'),
(38, 'store_information', 'contactEmail', '', 'text', '2026-06-17 04:57:23', '2026-06-18 05:18:19'),
(39, 'store_information', 'websiteUrl', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:59:48'),
(40, 'store_information', 'gstin', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(41, 'store_information', 'pan', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(42, 'store_information', 'cin', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(43, 'store_information', 'gstStateCode', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:59:48'),
(44, 'store_information', 'gstRegistrationType', 'Regular', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(45, 'store_information', 'facebookUrl', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(46, 'store_information', 'instagramUrl', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(47, 'store_information', 'linkedinUrl', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(48, 'store_information', 'youtubeUrl', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(49, 'store_information', 'whatsappNumber', '', 'text', '2026-06-17 04:57:23', '2026-06-18 05:18:19'),
(50, 'store_information', 'whatsappMessage', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(51, 'store_information', 'storeAddress', '', 'text', '2026-06-17 04:57:23', '2026-06-18 05:18:19'),
(52, 'store_information', 'city', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:59:48'),
(53, 'store_information', 'state', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:59:48'),
(54, 'store_information', 'country', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:59:48'),
(55, 'store_information', 'postalCode', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:59:48'),
(56, 'store_information', 'storeLogo', 'uploads/media/1781759897743-819392722.png', 'text', '2026-06-17 04:57:23', '2026-06-18 05:18:19'),
(57, 'store_information', 'storeBanner', '', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(58, 'privacy_policy', 'title', 'Privacy QA', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23'),
(59, 'privacy_policy', 'content', '<p>Test content</p>', 'text', '2026-06-17 04:57:23', '2026-06-17 04:57:23');

-- --------------------------------------------------------

--
-- Table structure for table `settings_integrations`
--

CREATE TABLE `settings_integrations` (
  `id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sub_categories`
--

CREATE TABLE `sub_categories` (
  `id` int(11) NOT NULL,
  `main_category_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(500) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT 'active',
  `sort_order` int(11) DEFAULT 0,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sub_categories`
--

INSERT INTO `sub_categories` (`id`, `main_category_id`, `name`, `slug`, `description`, `image`, `status`, `sort_order`, `meta_title`, `meta_description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'Silk Sarees', 'silk-sarees', 'Silk Sarees collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(2, 1, 'Cotton Sarees', 'cotton-sarees', 'Cotton Sarees collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 10:02:43', '2026-06-15 10:02:43'),
(3, 1, 'Banarasi Sarees', 'banarasi-sarees', 'Banarasi Sarees collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(4, 1, 'Kanjivaram Sarees', 'kanjivaram-sarees', 'Kanjivaram Sarees collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(5, 1, 'Designer Sarees', 'designer-sarees', 'Designer Sarees collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(6, 1, 'Daily Wear Sarees', 'daily-wear-sarees', 'Daily Wear Sarees collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(7, 2, 'Anarkali Kurtis', 'anarkali-kurtis', 'Anarkali Kurtis collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(8, 2, 'Straight Cut Kurtis', 'straight-cut-kurtis', 'Straight Cut Kurtis collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(9, 2, 'A-Line Kurtis', 'a-line-kurtis', 'A-Line Kurtis collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(10, 2, 'Pakistani Kurtis', 'pakistani-kurtis', 'Pakistani Kurtis collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(11, 2, 'Cotton Kurtis', 'cotton-kurtis', 'Cotton Kurtis collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(12, 3, 'Bridal Lehengas', 'bridal-lehengas', 'Bridal Lehengas collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(13, 3, 'Party Wear Lehengas', 'party-wear-lehengas', 'Party Wear Lehengas collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(14, 3, 'Designer Lehengas', 'designer-lehengas', 'Designer Lehengas collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(15, 3, 'Simple Lehengas', 'simple-lehengas', 'Simple Lehengas collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(22, 6, 'Designer Blouses', 'designer-blouses', 'Designer Blouses collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(23, 6, 'Silk Blouses', 'silk-blouses', 'Silk Blouses collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(24, 6, 'Cotton Blouses', 'cotton-blouses', 'Cotton Blouses collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL),
(25, 6, 'Embroidered Blouses', 'embroidered-blouses', 'Embroidered Blouses collection', NULL, 'active', 0, NULL, NULL, '2026-06-15 06:51:34', '2026-06-15 06:51:34', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_activity_logs_admin` (`admin_id`),
  ADD KEY `idx_activity_logs_customer` (`customer_id`),
  ADD KEY `idx_activity_logs_action` (`action`),
  ADD KEY `idx_activity_logs_created` (`created_at`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `idx_admins_email` (`email`),
  ADD KEY `idx_admins_status` (`status`),
  ADD KEY `idx_admins_role` (`role`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_logs_admin` (`admin_id`),
  ADD KEY `idx_audit_logs_entity` (`entity`,`entity_id`),
  ADD KEY `idx_audit_logs_action` (`action`),
  ADD KEY `idx_audit_logs_created` (`created_at`);

--
-- Indexes for table `banners`
--
ALTER TABLE `banners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_banners_type` (`type`),
  ADD KEY `idx_banners_status` (`status`),
  ADD KEY `idx_banners_position` (`position`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_cart_customer` (`customer_id`),
  ADD KEY `idx_cart_session` (`session_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_categories_slug` (`slug`),
  ADD KEY `idx_categories_status` (`status`);

--
-- Indexes for table `child_categories`
--
ALTER TABLE `child_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_child_categories_slug` (`slug`),
  ADD KEY `idx_child_categories_sub` (`sub_category_id`),
  ADD KEY `idx_child_categories_status` (`status`);

--
-- Indexes for table `collections`
--
ALTER TABLE `collections`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_collections_slug` (`slug`),
  ADD KEY `idx_collections_status` (`status`);

--
-- Indexes for table `collection_products`
--
ALTER TABLE `collection_products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_collection_product` (`collection_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `content_pages`
--
ALTER TABLE `content_pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `page_key` (`page_key`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `idx_coupons_code` (`code`),
  ADD KEY `idx_coupons_status` (`status`),
  ADD KEY `idx_coupons_expiry` (`expiry_date`);

--
-- Indexes for table `coupon_usages`
--
ALTER TABLE `coupon_usages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_coupon_usages_coupon` (`coupon_id`),
  ADD KEY `idx_coupon_usages_customer` (`customer_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_customers_email` (`email`),
  ADD KEY `idx_customers_status` (`status`),
  ADD KEY `idx_customers_phone` (`phone`);

--
-- Indexes for table `customer_addresses`
--
ALTER TABLE `customer_addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_customer_addresses_customer` (`customer_id`);

--
-- Indexes for table `email_templates`
--
ALTER TABLE `email_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_inventory_product` (`product_id`);

--
-- Indexes for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_inventory_logs_product` (`product_id`),
  ADD KEY `idx_inventory_logs_type` (`type`),
  ADD KEY `idx_inventory_logs_created` (`created_at`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_media_folder` (`folder`),
  ADD KEY `idx_media_type` (`type`),
  ADD KEY `idx_media_uploader` (`uploaded_by`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_notifications_type` (`type`),
  ADD KEY `idx_notifications_recipient` (`recipient_type`,`recipient_id`),
  ADD KEY `idx_notifications_read` (`is_read`);

--
-- Indexes for table `offers`
--
ALTER TABLE `offers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD KEY `idx_offers_slug` (`slug`),
  ADD KEY `idx_offers_status` (`status`),
  ADD KEY `idx_offers_dates` (`start_date`,`end_date`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `idx_orders_number` (`order_number`),
  ADD KEY `idx_orders_customer` (`customer_id`),
  ADD KEY `idx_orders_status` (`order_status`),
  ADD KEY `idx_orders_payment` (`payment_status`),
  ADD KEY `idx_orders_created` (`created_at`),
  ADD KEY `idx_orders_invoice` (`invoice_number`),
  ADD KEY `idx_orders_order_status` (`order_status`),
  ADD KEY `idx_orders_created_at` (`created_at`),
  ADD KEY `idx_orders_status_created` (`order_status`,`created_at`,`deleted_at`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_items_order` (`order_id`),
  ADD KEY `idx_order_items_product` (`product_id`);

--
-- Indexes for table `order_notes`
--
ALTER TABLE `order_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_notes_order` (`order_id`);

--
-- Indexes for table `order_timeline`
--
ALTER TABLE `order_timeline`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_timeline_order` (`order_id`),
  ADD KEY `idx_order_timeline_status` (`status`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_password_resets_email` (`email`),
  ADD KEY `idx_password_resets_token` (`token`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`),
  ADD UNIQUE KEY `sku` (`sku`),
  ADD KEY `sub_category_id` (`sub_category_id`),
  ADD KEY `child_category_id` (`child_category_id`),
  ADD KEY `idx_products_slug` (`slug`),
  ADD KEY `idx_products_sku` (`sku`),
  ADD KEY `idx_products_category` (`category_id`),
  ADD KEY `idx_products_status` (`status`),
  ADD KEY `idx_products_featured` (`is_featured`),
  ADD KEY `idx_products_trending` (`is_trending`),
  ADD KEY `idx_products_bestseller` (`is_best_seller`),
  ADD KEY `idx_products_stock` (`stock`),
  ADD KEY `idx_products_category_id` (`category_id`),
  ADD KEY `idx_products_deleted_at` (`deleted_at`),
  ADD KEY `idx_products_category_status` (`category_id`,`status`,`deleted_at`);
ALTER TABLE `products` ADD FULLTEXT KEY `idx_products_search` (`name`,`short_description`,`tags`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_images_product` (`product_id`);

--
-- Indexes for table `product_seo`
--
ALTER TABLE `product_seo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `product_id` (`product_id`),
  ADD KEY `idx_product_seo_product` (`product_id`);

--
-- Indexes for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_variants_product` (`product_id`);

--
-- Indexes for table `product_variant_options`
--
ALTER TABLE `product_variant_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pvo_product` (`product_id`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_refresh_tokens_token` (`token`),
  ADD KEY `idx_refresh_tokens_admin` (`admin_id`),
  ADD KEY `idx_refresh_tokens_customer` (`customer_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reviews_product` (`product_id`),
  ADD KEY `idx_reviews_customer` (`customer_id`),
  ADD KEY `idx_reviews_status` (`status`),
  ADD KEY `idx_reviews_rating` (`rating`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_role_permission` (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_setting` (`group_name`,`key_name`);

--
-- Indexes for table `settings_integrations`
--
ALTER TABLE `settings_integrations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sub_categories_slug` (`slug`),
  ADD KEY `idx_sub_categories_main` (`main_category_id`),
  ADD KEY `idx_sub_categories_status` (`status`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_wishlist` (`customer_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `banners`
--
ALTER TABLE `banners`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `child_categories`
--
ALTER TABLE `child_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `collections`
--
ALTER TABLE `collections`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `collection_products`
--
ALTER TABLE `collection_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `content_pages`
--
ALTER TABLE `content_pages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `coupon_usages`
--
ALTER TABLE `coupon_usages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `customer_addresses`
--
ALTER TABLE `customer_addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `email_templates`
--
ALTER TABLE `email_templates`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `offers`
--
ALTER TABLE `offers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `order_notes`
--
ALTER TABLE `order_notes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_timeline`
--
ALTER TABLE `order_timeline`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `product_seo`
--
ALTER TABLE `product_seo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `product_variant_options`
--
ALTER TABLE `product_variant_options`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `role_permissions`
--
ALTER TABLE `role_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=233;

--
-- AUTO_INCREMENT for table `settings_integrations`
--
ALTER TABLE `settings_integrations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sub_categories`
--
ALTER TABLE `sub_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `admins_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `child_categories`
--
ALTER TABLE `child_categories`
  ADD CONSTRAINT `child_categories_ibfk_1` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `collection_products`
--
ALTER TABLE `collection_products`
  ADD CONSTRAINT `collection_products_ibfk_1` FOREIGN KEY (`collection_id`) REFERENCES `collections` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `collection_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `coupon_usages`
--
ALTER TABLE `coupon_usages`
  ADD CONSTRAINT `coupon_usages_ibfk_1` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `coupon_usages_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `customer_addresses`
--
ALTER TABLE `customer_addresses`
  ADD CONSTRAINT `customer_addresses_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `inventory_logs`
--
ALTER TABLE `inventory_logs`
  ADD CONSTRAINT `inventory_logs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_notes`
--
ALTER TABLE `order_notes`
  ADD CONSTRAINT `order_notes_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_timeline`
--
ALTER TABLE `order_timeline`
  ADD CONSTRAINT `order_timeline_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`sub_category_id`) REFERENCES `sub_categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`child_category_id`) REFERENCES `child_categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_seo`
--
ALTER TABLE `product_seo`
  ADD CONSTRAINT `product_seo_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_variant_options`
--
ALTER TABLE `product_variant_options`
  ADD CONSTRAINT `product_variant_options_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sub_categories`
--
ALTER TABLE `sub_categories`
  ADD CONSTRAINT `sub_categories_ibfk_1` FOREIGN KEY (`main_category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
