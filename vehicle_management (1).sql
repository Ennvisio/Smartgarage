-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 09, 2021 at 06:33 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.4.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `vehicle_management`
--

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`id`, `owner_id`, `name`, `description`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 3, 'brand_1', 'description_1', NULL, '2021-04-19 04:34:52', NULL),
(2, 3, 'brand_2', 'description_2', NULL, '2021-04-19 04:34:52', NULL),
(5, 3, 'brand_3', 'heelo_updated', NULL, '2021-04-18 22:39:59', '2021-04-18 22:40:20'),
(6, 3, 'brand_3_updated', 'description_3_updated', NULL, '2021-04-18 22:40:32', '2021-04-27 06:36:45'),
(7, 1, 'brand_1', 'description', NULL, '2021-04-27 06:33:02', '2021-04-27 06:36:28'),
(8, 1, 'brand_5', 'asdsad', NULL, '2021-04-28 03:29:11', '2021-04-28 03:29:11'),
(9, 1, 'brand_4', 'test_description', NULL, '2021-04-28 03:29:55', '2021-05-09 02:15:08'),
(10, 1, 'brand_6_updated', 'brand_6  description', NULL, '2021-05-20 00:21:40', '2021-05-20 00:21:55'),
(11, 1, 'asdsaddsa', NULL, '2021-09-02 00:03:46', '2021-05-20 00:22:00', '2021-09-02 00:03:46'),
(12, 1, 'brand_7', 'brand_7 description_updated', NULL, '2021-05-30 00:44:13', '2021-05-30 00:44:23'),
(13, 1, 'hello', 'world', NULL, '2021-08-29 05:02:16', '2021-08-29 05:02:16'),
(14, 1, 'azmaeen', 'dsad', '2021-09-02 00:03:28', '2021-09-02 00:02:30', '2021-09-02 00:03:28'),
(15, 1, 'hgj', 'ghjj', '2021-09-02 00:03:38', '2021-09-02 00:03:34', '2021-09-02 00:03:38');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `short_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `owner_id`, `short_code`, `parent_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Product', 1, 'cat-1', 0, NULL, '2021-04-15 08:21:41', '2021-05-20 00:18:51'),
(2, 'Service', 1, 'service-1', 0, NULL, '2021-04-15 08:21:41', '2021-05-20 00:59:40'),
(4, 'sub_cat_1', 3, 'sub-cat-20', 1, NULL, '2021-04-18 05:05:42', '2021-04-18 05:05:42'),
(5, 'sub_cat_2', 3, 'sub-20', NULL, '2021-04-18 05:07:26', '2021-04-18 05:06:48', '2021-04-18 05:07:26'),
(6, 'asdsad', 1, 'sad', 0, '2021-04-27 06:37:25', '2021-04-21 03:12:28', '2021-04-27 06:37:25'),
(7, 'test_updated', 1, 'N/A', 4, '2021-05-20 00:17:14', '2021-04-27 06:37:12', '2021-05-20 00:17:14'),
(8, 'sdsadsad', 1, NULL, 0, '2021-05-20 00:17:17', '2021-04-28 03:26:50', '2021-05-20 00:17:17'),
(9, 'hello_world', 1, '376', 1, '2021-05-30 00:43:58', '2021-05-30 00:43:34', '2021-05-30 00:43:58'),
(10, 'fdggd', 1, 'bcvbcv', 1, '2021-09-01 23:53:46', '2021-09-01 23:52:57', '2021-09-01 23:53:46'),
(11, 'bmbn_uy', 1, 'nbbmbbm', 0, '2021-09-01 23:56:19', '2021-09-01 23:56:05', '2021-09-01 23:56:19');

-- --------------------------------------------------------

--
-- Table structure for table `colors`
--

CREATE TABLE `colors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `colors`
--

INSERT INTO `colors` (`id`, `owner_id`, `name`, `description`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'red', 'red_updated', NULL, '2021-04-28 01:04:52', '2021-08-29 05:51:15'),
(2, 1, 'blue', 'blue_updated', NULL, '2021-05-21 00:43:20', '2021-08-29 05:51:07'),
(4, 1, 'black_updated', 'black', NULL, '2021-08-29 06:02:25', '2021-09-01 04:47:40');

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('supplier','customer','both') COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `owner_id`, `type`, `name`, `email`, `mobile`, `address`, `created_by`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'supplier', 'supplier_1', 'supplier_1@gmail.com', '01683135864', 'Dhaka', 1, NULL, '2021-05-20 00:29:12', '2021-05-20 00:29:12'),
(2, 1, 'supplier', 'supplier_2', 'supplier_2@gmail.com', '01683135647', 'dhaka', 1, NULL, '2021-05-20 00:29:38', '2021-05-20 00:29:38'),
(3, 1, 'supplier', 'supplier_3', 'supplier_3@gmail.com', '01683135425', 'dhaka', 1, NULL, '2021-05-20 00:30:04', '2021-05-20 00:30:04'),
(4, 1, 'supplier', 'vxcv', 'sadsd@test.com', '016844578', 'dhaka', 1, '2021-08-29 05:02:50', '2021-05-20 00:31:49', '2021-08-29 05:02:50'),
(5, 1, 'customer', 'client_1', 'client_1@gmail.com', '01683135647', 'dhaka', 1, NULL, '2021-05-20 00:55:59', '2021-05-20 00:55:59'),
(6, 1, 'customer', 'client_2', 'client_2@gmail.com', '01683135647', 'dhaka', 1, NULL, '2021-05-20 00:56:20', '2021-05-20 00:56:20'),
(7, 1, 'customer', 'client_3', 'client_3@gmail.com', '0168564789', 'dhaka', 1, NULL, '2021-05-20 00:56:42', '2021-05-20 00:56:42'),
(8, 1, 'customer', 'test', 'sadsad@test.com', '016845987456', 'dhaka', 1, NULL, '2021-05-20 00:57:16', '2021-05-20 00:57:27'),
(9, 1, 'customer', 'customer_7', 'customer_7@test.com', '01683135265', 'dhaka', 1, NULL, '2021-06-01 06:37:44', '2021-06-01 06:37:44'),
(10, 1, 'supplier', 'maheeb_updated', 'maheeb@test.com', '46466', 'hello', 1, NULL, '2021-08-29 05:02:38', '2021-08-29 05:02:46'),
(11, 1, 'customer', 'azmaeen', 'azmaeen@test.com', '09345252', 'house 5, road 12, block C banasree', 1, NULL, '2021-08-29 05:03:25', '2021-08-29 05:03:25'),
(12, 1, 'supplier', 'jhkkj', 'jkh', 'jk', 'kjh', 1, '2021-09-02 00:22:55', '2021-09-02 00:22:50', '2021-09-02 00:22:55'),
(13, 1, 'customer', 'bmm', 'bnmn@test.com', '016831325647', 'jklkjl', 1, '2021-09-02 00:27:08', '2021-09-02 00:26:54', '2021-09-02 00:27:08');

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fileable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fileable_id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `invoice_number` int(11) NOT NULL,
  `date` date DEFAULT NULL,
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `client_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `client_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_cost` double NOT NULL,
  `paid_price` double DEFAULT NULL,
  `due_price` double DEFAULT NULL,
  `payment_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `vat` double NOT NULL,
  `vat_parcentage` double DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `owner_id`, `invoice_number`, `date`, `contact_id`, `client_name`, `client_phone`, `total_cost`, `paid_price`, `due_price`, `payment_status`, `created_by`, `discount`, `vat`, `vat_parcentage`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(41, 1, 1630906619, '2021-09-06', 5, NULL, NULL, 160, 100, 60, 'Paid', '1', 5, 10, NULL, NULL, '2021-09-05 23:24:44', '2021-09-05 23:26:49', NULL),
(42, 1, 1630906386, '2021-08-31', 7, NULL, NULL, 80, 39, 9, 'Paid', '1', 40, 20, NULL, NULL, '2021-09-05 23:32:05', '2021-09-08 01:21:30', NULL),
(43, 1, 1630906771, '2021-08-23', 7, NULL, NULL, 100, 61, NULL, 'Paid', '1', 44, 20, NULL, NULL, '2021-09-05 23:38:52', '2021-09-08 01:20:36', NULL),
(44, 1, 1630909489, '2021-09-06', 11, NULL, NULL, 215, 215, NULL, NULL, '1', 5, 10, NULL, NULL, '2021-09-06 00:11:50', '2021-09-06 00:22:14', '2021-09-06 00:22:14'),
(45, 1, 1630909049, '1970-01-01', 5, NULL, NULL, 139, 139, NULL, NULL, '1', 10, 5, NULL, NULL, '2021-09-06 00:14:27', '2021-09-06 00:22:10', '2021-09-06 00:22:10'),
(46, 1, 1630909799, '2021-08-24', 5, NULL, NULL, 90, 90, NULL, 'Paid', '1', 20, 10, NULL, NULL, '2021-09-06 00:23:02', '2021-09-06 01:58:12', NULL),
(47, 1, 1631085248, '1970-01-01', 5, NULL, NULL, 60, 60, NULL, NULL, '1', 3, 5, NULL, NULL, '2021-09-08 00:58:17', '2021-09-08 00:58:17', NULL),
(48, 1, 1631085394, '2021-09-08', 5, NULL, NULL, 28, 28, NULL, NULL, '1', 5, 10, NULL, NULL, '2021-09-08 01:01:07', '2021-09-08 01:01:07', NULL),
(49, 1, 1631085618, '1970-01-01', 7, NULL, NULL, 173, 1000, NULL, NULL, '1', 25, 10, NULL, NULL, '2021-09-08 01:15:34', '2021-09-08 01:18:37', '2021-09-08 01:18:37'),
(50, 1, 1631090002, '2021-09-08', 5, NULL, NULL, 4, 4, NULL, NULL, '1', 10, 20, NULL, NULL, '2021-09-08 02:17:38', '2021-09-08 02:17:38', NULL),
(51, 1, 1631090049, '2021-09-07', 5, NULL, NULL, 8, 0, NULL, 'Paid', '1', 5, 10, NULL, NULL, '2021-09-08 02:19:11', '2021-09-08 02:23:07', NULL),
(52, 1, 1631089505, '2021-09-08', 5, NULL, NULL, 61, 61, NULL, NULL, '1', 5, 10, NULL, NULL, '2021-09-08 02:22:16', '2021-09-08 02:22:16', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `invoice_id` bigint(20) UNSIGNED NOT NULL,
  `vehicle_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_quantity` int(11) DEFAULT NULL,
  `product_rate` double DEFAULT NULL,
  `product_total_price` double DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_quantity` int(11) DEFAULT NULL,
  `service_total_price` double DEFAULT NULL,
  `service_rate` double DEFAULT NULL,
  `total_price` double DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `vehicle_id`, `product_id`, `product_quantity`, `product_rate`, `product_total_price`, `service_id`, `service_quantity`, `service_total_price`, `service_rate`, `total_price`, `created_at`, `updated_at`, `deleted_at`) VALUES
(72, 41, 1, 5, 5, 30, NULL, NULL, NULL, NULL, NULL, 150, '2021-09-05 23:24:44', '2021-09-05 23:24:44', NULL),
(73, 42, 5, 7, 2, 20, NULL, NULL, NULL, NULL, NULL, 40, '2021-09-05 23:32:05', '2021-09-05 23:32:05', NULL),
(74, 43, 3, 17, 3, 20, NULL, NULL, NULL, NULL, NULL, 60, '2021-09-05 23:38:52', '2021-09-05 23:38:52', NULL),
(75, 44, 4, NULL, NULL, NULL, NULL, 4, 1, NULL, 200, 200, '2021-09-06 00:11:50', '2021-09-06 00:11:50', NULL),
(76, 45, 1, 5, 1, 30, NULL, NULL, NULL, NULL, NULL, 30, '2021-09-06 00:14:27', '2021-09-06 00:14:27', NULL),
(77, 45, 1, 6, 1, 12, NULL, NULL, NULL, NULL, NULL, 12, '2021-09-06 00:14:27', '2021-09-06 00:14:27', NULL),
(78, 45, 1, 17, 5, 20, NULL, NULL, NULL, NULL, NULL, 100, '2021-09-06 00:14:27', '2021-09-06 00:14:27', NULL),
(79, 46, 1, 5, 2, 30, NULL, NULL, NULL, NULL, NULL, 60, '2021-09-06 00:23:02', '2021-09-06 00:23:02', NULL),
(80, 46, 1, 17, 2, 20, NULL, NULL, NULL, NULL, NULL, 40, '2021-09-06 00:23:28', '2021-09-06 00:23:28', NULL),
(81, 47, 1, 5, 2, 30, NULL, NULL, NULL, NULL, NULL, 60, '2021-09-08 00:58:17', '2021-09-08 00:58:17', NULL),
(82, 48, 1, 5, 1, 30, NULL, NULL, NULL, NULL, NULL, 30, '2021-09-08 01:01:07', '2021-09-08 01:01:07', NULL),
(83, 49, 3, 5, 6, 30, NULL, NULL, NULL, NULL, NULL, 180, '2021-09-08 01:15:34', '2021-09-08 01:17:58', NULL),
(84, 43, 3, 7, 3, 20, NULL, NULL, NULL, NULL, NULL, 60, '2021-09-08 01:20:36', '2021-09-08 01:20:36', NULL),
(85, 42, 5, 17, 3, 20, NULL, NULL, NULL, NULL, NULL, 60, '2021-09-08 01:21:30', '2021-09-08 01:21:30', NULL),
(86, 50, 1, 6, 1, 12, NULL, NULL, NULL, NULL, NULL, 12, '2021-09-08 02:17:38', '2021-09-08 02:17:38', NULL),
(87, 51, 1, 6, 1, 12, NULL, NULL, NULL, NULL, NULL, 12, '2021-09-08 02:19:11', '2021-09-08 02:19:11', NULL),
(88, 52, 1, 7, 3, 20, NULL, NULL, NULL, NULL, NULL, 60, '2021-09-08 02:22:16', '2021-09-08 02:22:16', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `job_cards`
--

CREATE TABLE `job_cards` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_part` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `number_part` int(11) DEFAULT NULL,
  `job_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2017_07_23_113209_create_brands_table', 1),
(4, '2017_07_26_122313_create_units_table', 1),
(6, '2017_07_27_104124_create_expense_categories_table', 1),
(7, '2017_08_04_071038_create_categories_table', 1),
(9, '2021_03_14_050409_create_expenses_table', 1),
(10, '2021_03_15_064125_create_opening_stock_qties_table', 1),
(11, '2021_03_18_091107_create_purchases_table', 1),
(12, '2021_03_18_105705_create_purchase_items_table', 1),
(13, '2021_03_18_105726_create_purchase_payments_table', 1),
(14, '2021_03_24_065635_create_sales_table', 1),
(15, '2021_03_24_070645_create_sale_items_table', 1),
(16, '2021_04_05_113228_create_files_table', 1),
(17, '2021_04_11_113219_create_vouchers_table', 1),
(18, '2021_04_11_113808_create_voucher_items_table', 1),
(19, '2021_04_11_114148_create_services_table', 1),
(20, '2021_04_11_114356_create_job_cards_table', 1),
(26, '2021_04_15_041114_add_brand_name_column_to_vehicles_table', 1),
(27, '2021_04_11_114813_create_vehicle_types_table', 2),
(28, '2021_04_11_114902_create_colors_table', 2),
(29, '2021_04_11_114502_create_vehicles_table', 3),
(30, '2017_08_08_115903_create_products_table', 4),
(35, '2021_04_11_115014_create_invoices_table', 5),
(36, '2021_04_11_115226_create_invoice_items_table', 5),
(37, '2017_07_27_075706_create_contacts_table', 6),
(39, '2021_08_31_082907_add_paid_amount_due_amount_column_to_purchase_table', 7),
(40, '2021_09_05_082809_create_payments_table', 8),
(41, '2021_09_05_111910_add_card_no_bank_name_column_to_payments_table', 9);

-- --------------------------------------------------------

--
-- Table structure for table `opening_stock_qties`
--

CREATE TABLE `opening_stock_qties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `paymentable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `paymentable_id` bigint(20) UNSIGNED NOT NULL,
  `payment_amount` decimal(20,2) NOT NULL,
  `payment_method` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `card_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bank_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `account_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `payment_details` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `paymentable_type`, `paymentable_id`, `payment_amount`, `payment_method`, `card_no`, `bank_name`, `account_no`, `payment_date`, `payment_details`, `created_at`, `updated_at`) VALUES
(2, 'App\\Models\\Purchase', 31, '100.00', 'Cash', NULL, NULL, NULL, '2021-09-05', 'jhkkjk', '2021-09-05 04:51:00', '2021-09-05 04:51:00'),
(3, 'App\\Models\\Purchase', 32, '80.00', 'Cash', NULL, NULL, NULL, '2021-09-05', 'gjhgj', '2021-09-05 05:22:00', '2021-09-05 05:22:00'),
(4, 'App\\Models\\Purchase', 32, '14.00', 'Cash', NULL, NULL, NULL, '2021-09-05', NULL, '2021-09-05 05:28:00', '2021-09-05 05:28:00'),
(5, 'App\\Models\\Invoice', 41, '100.00', NULL, NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:24:00', '2021-09-05 23:24:00'),
(6, 'App\\Models\\Invoice', 41, '60.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:26:00', '2021-09-05 23:26:00'),
(7, 'App\\Models\\Invoice', 42, '30.00', NULL, NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:32:00', '2021-09-05 23:32:00'),
(8, 'App\\Models\\Invoice', 42, '9.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:32:00', '2021-09-05 23:32:00'),
(9, 'App\\Models\\Purchase', 33, '10.00', 'Cash', NULL, NULL, NULL, '2021-09-06', '10', '2021-09-05 23:35:00', '2021-09-05 23:35:00'),
(10, 'App\\Models\\Purchase', 33, '73.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:36:00', '2021-09-05 23:36:00'),
(11, 'App\\Models\\Invoice', 43, '50.00', NULL, NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:38:00', '2021-09-05 23:38:00'),
(12, 'App\\Models\\Invoice', 43, '16.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:39:00', '2021-09-05 23:39:00'),
(13, 'App\\Models\\Purchase', 34, '30.00', 'Cash', NULL, NULL, NULL, '2021-09-06', '4546545', '2021-09-05 23:45:00', '2021-09-05 23:45:00'),
(14, 'App\\Models\\Purchase', 34, '8.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-05 23:45:00', '2021-09-05 23:45:00'),
(15, 'App\\Models\\Invoice', 44, '215.00', NULL, NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 00:11:00', '2021-09-06 00:11:00'),
(16, 'App\\Models\\Invoice', 45, '139.00', NULL, NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 00:14:00', '2021-09-06 00:14:00'),
(17, 'App\\Models\\Purchase', 34, '122.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 00:16:00', '2021-09-06 00:16:00'),
(18, 'App\\Models\\Purchase', 35, '50.00', 'Cash', NULL, NULL, NULL, '2021-09-06', 'gfhhf', '2021-09-06 00:17:00', '2021-09-06 00:17:00'),
(19, 'App\\Models\\Purchase', 35, '80.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 00:18:00', '2021-09-06 00:18:00'),
(20, 'App\\Models\\Invoice', 46, '40.00', NULL, NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 00:23:00', '2021-09-06 00:23:00'),
(21, 'App\\Models\\Invoice', 46, '50.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 00:23:00', '2021-09-06 00:23:00'),
(22, 'App\\Models\\Purchase', 36, '38.00', 'Cash', NULL, NULL, NULL, '2021-09-06', 'hjgjhgjh', '2021-09-06 01:02:00', '2021-09-06 01:02:00'),
(23, 'App\\Models\\Purchase', 37, '11.00', 'Cash', NULL, NULL, NULL, '2021-09-06', 'jhjj', '2021-09-06 01:13:00', '2021-09-06 01:13:00'),
(24, 'App\\Models\\Invoice', 43, '-5.00', 'Cash', NULL, NULL, NULL, '2021-09-06', NULL, '2021-09-06 01:56:00', '2021-09-06 01:56:00'),
(25, 'App\\Models\\Purchase', 38, '292.00', 'Cash', NULL, NULL, NULL, '2021-09-08', 'paid', '2021-09-08 00:18:00', '2021-09-08 00:18:00'),
(26, 'App\\Models\\Purchase', 39, '52.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 00:53:00', '2021-09-08 00:53:00'),
(27, 'App\\Models\\Invoice', 47, '60.00', NULL, NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 00:58:00', '2021-09-08 00:58:00'),
(28, 'App\\Models\\Invoice', 48, '28.00', NULL, NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:01:00', '2021-09-08 01:01:00'),
(29, 'App\\Models\\Purchase', 40, '145.00', 'Cash', NULL, NULL, NULL, '2021-09-08', 'ggh', '2021-09-08 01:02:00', '2021-09-08 01:02:00'),
(30, 'App\\Models\\Purchase', 41, '94.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:07:00', '2021-09-08 01:07:00'),
(31, 'App\\Models\\Purchase', 42, '42.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:12:00', '2021-09-08 01:12:00'),
(32, 'App\\Models\\Purchase', 43, '230.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:13:00', '2021-09-08 01:13:00'),
(33, 'App\\Models\\Purchase', 43, '6.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:13:00', '2021-09-08 01:13:00'),
(34, 'App\\Models\\Invoice', 49, '1000.00', NULL, NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:15:00', '2021-09-08 01:15:00'),
(35, 'App\\Models\\Invoice', 43, '39.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:20:00', '2021-09-08 01:20:00'),
(36, 'App\\Models\\Invoice', 42, '41.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 01:21:00', '2021-09-08 01:21:00'),
(37, 'App\\Models\\Purchase', 44, '116.00', 'Cash', NULL, NULL, NULL, '2021-09-08', 'gdfgd', '2021-09-08 02:06:00', '2021-09-08 02:06:00'),
(38, 'App\\Models\\Invoice', 50, '4.00', NULL, NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 02:17:00', '2021-09-08 02:17:00'),
(39, 'App\\Models\\Invoice', 52, '61.00', NULL, NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 02:22:00', '2021-09-08 02:22:00'),
(40, 'App\\Models\\Invoice', 51, '8.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 02:23:00', '2021-09-08 02:23:00'),
(41, 'App\\Models\\Purchase', 45, '20.00', 'Cash', NULL, NULL, NULL, '2021-09-08', 'vbv', '2021-09-08 04:16:00', '2021-09-08 04:16:00'),
(42, 'App\\Models\\Purchase', 45, '230.00', 'Cash', NULL, NULL, NULL, '2021-09-08', NULL, '2021-09-08 04:20:00', '2021-09-08 04:20:00');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `buying_price` double NOT NULL,
  `selling_price` double DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` double NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `owner_id`, `name`, `category_id`, `brand_id`, `buying_price`, `selling_price`, `image`, `quantity`, `status`, `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'test_9', 1, 8, 12, 15, 'images/products/1620293349.png', 6, '1', 1, 1, '2021-04-28 04:05:59', '2021-08-29 05:01:58', '2021-08-29 05:01:58'),
(2, 1, 'BMW', 1, 9, 25, 55, 'images/products/1620495596.jpg', 35, '1', 1, 1, '2021-04-28 04:10:06', '2021-05-30 00:42:24', '2021-05-30 00:42:24'),
(3, 1, 'Azmaeen', 1, 9, 10, 20, NULL, 12, 'Active', 1, 1, '2021-04-28 04:12:06', '2021-05-06 03:41:42', '2021-05-06 03:41:42'),
(4, 1, 'maheeb', 1, 8, 100, 200, 'images/products/1619605091.png', 50, '0', 1, 1, '2021-04-28 04:18:11', '2021-08-29 05:05:18', '2021-08-29 05:05:18'),
(5, 1, 'product_1', 1, 9, 20, 30, 'images/products/1620495549.jpg', 107, '0', 1, 1, '2021-04-28 04:19:10', '2021-09-08 04:20:31', NULL),
(6, 1, 'product_2', 1, 9, 10, 12, 'images/products/1630558909.jpg', 79, '0', 1, 1, '2021-04-28 04:19:10', '2021-09-08 02:23:00', NULL),
(7, 1, 'product_3', 1, 9, 14, 20, 'images/products/1622356980.jpg', 86, '0', 1, 1, '2021-04-28 04:19:10', '2021-09-08 04:20:31', NULL),
(8, 1, 'product_4', 1, 8, 30, 64, 'images/products/1620495506.png', 97, '1', 1, 1, '2021-05-06 00:46:12', '2021-06-13 01:41:29', NULL),
(9, 1, 'asdsad', 1, 8, 12, 20, NULL, 5, '1', 1, 1, '2021-05-06 04:12:50', '2021-05-06 04:13:24', '2021-05-06 04:13:24'),
(10, 1, 'heelo', 1, 8, 25, 55, NULL, 20, '1', 1, NULL, '2021-05-08 11:24:16', '2021-05-08 11:24:21', '2021-05-08 11:24:21'),
(11, 1, 'cristiano', 1, 8, 25, 35, 'images/products/1620495380.png', 35, '1', 1, 1, '2021-05-08 11:27:53', '2021-05-08 11:36:39', '2021-05-08 11:36:39'),
(12, 1, 'test_25', 1, 9, 100, 200, 'images/products/1620495663.png', 20, '1', 1, 1, '2021-05-08 11:40:47', '2021-05-08 11:41:08', '2021-05-08 11:41:08'),
(13, 1, 'nbmb', 2, 10, 20, 155, NULL, 10, '1', 1, NULL, '2021-05-20 02:12:24', '2021-05-20 02:12:34', '2021-05-20 02:12:34'),
(14, 1, 'product_7_updated', 1, 8, 300, 450, 'images/products/1622354727.jpg', 120, '0', 1, 1, '2021-05-30 00:03:36', '2021-08-31 00:19:46', '2021-08-31 00:19:46'),
(15, 1, 'hello_updated', 1, 12, 100, 400, 'images/products/1630234900.jpg', 5, '0', 1, 1, '2021-08-29 05:01:40', '2021-08-31 23:45:36', '2021-08-31 23:45:36'),
(16, 1, 'product_10', 1, 12, 200, 400, 'images/products/1630559949.jpg', 100, '1', 1, NULL, '2021-09-01 23:19:09', '2021-09-01 23:19:09', NULL),
(17, 1, 'product_15', 1, 13, 10, 20, 'images/products/1630560165.jpg', 195, '0', 1, 1, '2021-09-01 23:22:45', '2021-09-08 04:20:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `purchase_number` int(11) DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `purchase_status` enum('Received','Pending','Ordered','Draft','Final') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `total_purchase_quantity` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtotal_cost` decimal(20,2) DEFAULT NULL,
  `purchase_discount` decimal(20,2) DEFAULT NULL,
  `purchase_tax` decimal(20,2) DEFAULT NULL,
  `total_cost` decimal(20,2) DEFAULT NULL,
  `paid_amount` double DEFAULT NULL,
  `due_amount` double DEFAULT NULL,
  `payment_status` enum('Paid','Due','Partial') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED NOT NULL,
  `updated_by` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `purchase_number`, `owner_id`, `contact_id`, `purchase_status`, `purchase_date`, `total_purchase_quantity`, `subtotal_cost`, `purchase_discount`, `purchase_tax`, `total_cost`, `paid_amount`, `due_amount`, `payment_status`, `note`, `created_by`, `updated_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
(31, 1630839469, 1, 1, 'Received', '2021-09-05', '4', '120.00', '20.00', '10.00', '112.00', NULL, NULL, 'Paid', NULL, 1, 1, '2021-09-05 04:51:38', '2021-09-05 05:21:40', '2021-09-05 05:21:40'),
(32, 1630841702, 1, 1, 'Received', '2021-09-05', '3', '90.00', '5.00', '10.00', '94.00', NULL, NULL, 'Paid', NULL, 1, 1, '2021-09-05 05:22:15', '2021-09-05 05:28:16', NULL),
(33, 1630907138, 1, 1, 'Received', '2021-09-06', '4', '80.00', '5.00', '10.00', '83.00', NULL, NULL, 'Paid', NULL, 1, 1, '2021-09-05 23:35:57', '2021-09-05 23:36:05', NULL),
(34, 1630907824, 1, 1, 'Received', '2021-09-06', '12', '40.00', '20.00', '5.00', '160.00', 38, NULL, 'Paid', NULL, 1, 1, '2021-09-05 23:45:32', '2021-09-06 00:16:40', NULL),
(35, 1630909912, 1, 1, 'Received', '2021-09-06', '5', '90.00', '4.00', '10.00', '130.00', NULL, NULL, 'Paid', NULL, 1, 1, '2021-09-06 00:17:35', '2021-09-06 00:18:23', NULL),
(36, 1630911944, 1, 2, 'Received', '2021-08-17', '2', '40.00', '10.00', '20.00', '38.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-06 01:02:43', '2021-09-06 01:02:43', NULL),
(37, 1630913321, 1, 1, 'Received', '2021-09-06', '1', '20.00', '10.00', '5.00', '11.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-06 01:13:15', '2021-09-06 01:13:15', NULL),
(38, 1631081963, 1, 1, 'Received', '2021-09-08', '15', '270.00', '5.00', '10.00', '292.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-08 00:18:10', '2021-09-08 00:18:10', NULL),
(39, 1631084888, 1, 1, 'Received', '2021-09-08', '4', '48.00', NULL, '10.00', '53.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-08 00:53:13', '2021-09-08 00:53:13', NULL),
(40, 1631084885, 1, 1, 'Received', '2021-09-08', '5', '150.00', '20.00', '10.00', '145.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-08 01:02:28', '2021-09-08 01:02:28', NULL),
(41, 1631085094, 1, 1, 'Received', '2021-09-08', '3', '90.00', '5.00', '10.00', '94.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-08 01:07:06', '2021-09-08 01:07:06', NULL),
(42, 1631085479, 1, 1, 'Received', '2021-09-08', '2', '50.00', '10.00', '5.00', '43.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-08 01:12:22', '2021-09-08 01:12:22', NULL),
(43, 1631085775, 1, 3, 'Received', '2021-09-08', '13', '200.00', '10.00', '20.00', '236.00', NULL, NULL, 'Paid', NULL, 1, 1, '2021-09-08 01:13:01', '2021-09-08 01:13:45', NULL),
(44, 1631089193, 1, 1, 'Received', '2021-09-08', '4', '120.00', '10.00', '5.00', '116.00', NULL, NULL, NULL, NULL, 1, 1, '2021-09-08 02:06:56', '2021-09-08 02:06:56', NULL),
(45, 1631096923, 1, 1, 'Received', '2021-09-08', '12', '30.00', '5.00', '10.00', '250.00', NULL, NULL, 'Paid', 'hello', 1, 1, '2021-09-08 04:16:55', '2021-09-08 04:20:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_items`
--

CREATE TABLE `purchase_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `purchase_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `purchase_quantity` decimal(20,2) DEFAULT NULL,
  `purchase_price` decimal(20,2) DEFAULT NULL,
  `total_price` decimal(20,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `purchase_items`
--

INSERT INTO `purchase_items` (`id`, `purchase_id`, `product_id`, `purchase_quantity`, `purchase_price`, `total_price`, `created_at`, `updated_at`) VALUES
(37, 31, 5, '4.00', '30.00', '120.00', '2021-09-05 04:51:38', '2021-09-05 04:51:38'),
(38, 32, 5, '3.00', '30.00', '90.00', '2021-09-05 05:22:15', '2021-09-05 05:22:15'),
(39, 33, 7, '4.00', '20.00', '80.00', '2021-09-05 23:35:57', '2021-09-05 23:35:57'),
(40, 34, 7, '2.00', '20.00', '40.00', '2021-09-05 23:45:32', '2021-09-06 00:15:18'),
(41, 34, 6, '10.00', '12.00', '120.00', '2021-09-06 00:15:18', '2021-09-06 00:15:18'),
(42, 35, 5, '3.00', '30.00', '90.00', '2021-09-06 00:17:35', '2021-09-06 00:18:10'),
(43, 35, 7, '2.00', '20.00', '40.00', '2021-09-06 00:18:10', '2021-09-06 00:18:10'),
(44, 36, 17, '2.00', '20.00', '40.00', '2021-09-06 01:02:43', '2021-09-06 01:02:43'),
(45, 37, 17, '1.00', '20.00', '20.00', '2021-09-06 01:13:15', '2021-09-06 01:13:15'),
(46, 38, 5, '5.00', '30.00', '150.00', '2021-09-08 00:18:10', '2021-09-08 00:18:10'),
(47, 38, 6, '10.00', '12.00', '120.00', '2021-09-08 00:18:10', '2021-09-08 00:18:10'),
(48, 39, 6, '4.00', '12.00', '48.00', '2021-09-08 00:53:13', '2021-09-08 00:53:13'),
(49, 40, 5, '5.00', '30.00', '150.00', '2021-09-08 01:02:28', '2021-09-08 01:02:28'),
(50, 41, 5, '3.00', '30.00', '90.00', '2021-09-08 01:07:06', '2021-09-08 01:07:06'),
(51, 42, 5, '1.00', '30.00', '30.00', '2021-09-08 01:12:22', '2021-09-08 01:12:22'),
(52, 42, 17, '1.00', '20.00', '20.00', '2021-09-08 01:12:22', '2021-09-08 01:12:22'),
(53, 43, 7, '10.00', '20.00', '200.00', '2021-09-08 01:13:01', '2021-09-08 01:13:36'),
(54, 43, 6, '3.00', '12.00', '36.00', '2021-09-08 01:13:36', '2021-09-08 01:13:36'),
(55, 44, 5, '4.00', '30.00', '120.00', '2021-09-08 02:06:56', '2021-09-08 02:06:56'),
(56, 45, 5, '1.00', '30.00', '30.00', '2021-09-08 04:16:55', '2021-09-08 04:20:31'),
(57, 45, 7, '1.00', '20.00', '20.00', '2021-09-08 04:19:35', '2021-09-08 04:20:31'),
(58, 45, 17, '10.00', '20.00', '200.00', '2021-09-08 04:20:31', '2021-09-08 04:20:31');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ref_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_id` bigint(20) UNSIGNED DEFAULT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `shipping_cost` decimal(20,2) DEFAULT NULL,
  `sale_status` enum('completed','pending','final') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `total_sale_quantity` decimal(20,2) DEFAULT NULL,
  `subtotal_cost` decimal(20,2) DEFAULT NULL,
  `sale_tax` decimal(20,2) DEFAULT NULL,
  `sale_discount` decimal(20,2) NOT NULL DEFAULT 0.00,
  `total_cost` decimal(20,2) DEFAULT NULL,
  `payment_status` enum('paid','due','partial','pending') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sale_date` date DEFAULT NULL,
  `sale_note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `staff_note` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `updated_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sale_items`
--

CREATE TABLE `sale_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `sale_quantity` decimal(20,2) DEFAULT NULL,
  `sale_price` decimal(20,2) DEFAULT NULL,
  `total_price` decimal(20,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `selling_price` double DEFAULT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `owner_id`, `name`, `category_id`, `selling_price`, `status`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 'service_1', 2, 10, 'Active', NULL, '2021-04-28 01:10:16', '2021-04-28 01:10:16'),
(3, 1, 'service_3_updated', 2, 300, 'Active', 'updated_again', '2021-04-28 01:10:16', '2021-08-31 00:34:27'),
(4, 1, 'service_4', 2, 200, 'Active', 'asdasd', '2021-08-31 00:08:51', '2021-08-31 00:08:51'),
(5, 1, 'service_5', 2, 5445, 'Active', 'ghfghf', '2021-08-31 00:15:49', '2021-08-31 00:15:49');

-- --------------------------------------------------------

--
-- Table structure for table `units`
--

CREATE TABLE `units` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `operator` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` decimal(20,2) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `surname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `language` char(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `surname`, `first_name`, `last_name`, `username`, `email`, `password`, `language`, `remember_token`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'MR', 'Imtiaz', 'ahmed', 'admin', 'admin@gmail.com', '$2y$12$7EcNNiccb.Ua1WwoxhL22eZS5zdRNFGGmngTIwvAGCMiaYysL8BbO', 'en', NULL, NULL, NULL, NULL),
(3, 'mr', 'maheeb', 'azmaeen', 'maheeb', 'maheeb@test.com', '$2y$10$327/P0iRh.L16rzv0sr80.5QxMOTz4OCDis1HFO3.3GsKl9vu0O1e', 'en', NULL, NULL, '2021-04-18 02:49:56', '2021-04-18 02:49:56'),
(5, '', 'asd', 'sasad', 'maheeb@test.com', 'asd@test.com', '$2y$10$YZTvYu4TThSr0H9xX4J3V.iX9jNBxt/nbZxHDSIVvBLwQKeLDYDNO', 'en', NULL, NULL, '2021-04-19 04:56:29', '2021-04-19 04:56:29'),
(6, '', 'maheeb', 'azmaeen', 'maheeb10', 'maheeb@test.com', '$2y$10$FlRSkUahLCtWC2PYaxftt.gxcOfQRr/qMvsy1Bw/F737cV7HgmfzK', 'en', NULL, NULL, '2021-09-08 05:29:53', '2021-09-08 05:29:53');

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `brand_id` bigint(20) UNSIGNED DEFAULT NULL,
  `model` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reg_no` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chassis_no` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mileage` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `owner_id`, `contact_id`, `brand_id`, `model`, `reg_no`, `chassis_no`, `mileage`, `color_id`, `type_id`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 5, 12, 'maheeb', '25', '26', '1', 1, 1, 'yuiy', '2021-04-28 01:07:58', '2021-04-28 01:07:58'),
(3, 1, 7, 8, 'model-56', 'reg-25', '5665', '5', 2, 1, 'sdasdd', '2021-06-13 01:55:08', '2021-06-13 01:55:08'),
(4, 1, 11, 9, '4654', '87897', '7987', '121', 1, 1, '5465', '2021-08-29 05:03:53', '2021-08-29 05:57:19'),
(5, 1, 7, 13, '120_upated', '520', '520', '520', 2, 1, 'Hello world', '2021-08-29 05:58:35', '2021-08-29 06:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `vehicle_types`
--

CREATE TABLE `vehicle_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vehicle_types`
--

INSERT INTO `vehicle_types` (`id`, `owner_id`, `name`, `description`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 'bike', 'cvb', NULL, '2021-04-28 01:05:01', '2021-09-01 04:38:04'),
(2, 1, 'car', 'car_1', NULL, '2021-05-21 00:43:07', '2021-05-21 00:43:07'),
(3, 1, 'bus', 'bsdsaddsa', NULL, '2021-08-29 05:04:20', '2021-08-29 05:04:20');

-- --------------------------------------------------------

--
-- Table structure for table `vouchers`
--

CREATE TABLE `vouchers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `voucher_number` int(11) NOT NULL,
  `date` date NOT NULL,
  `contact_id` bigint(20) UNSIGNED NOT NULL,
  `net_total_amount` double NOT NULL,
  `paid_amount` double DEFAULT NULL,
  `due_amount` double DEFAULT NULL,
  `payment_status` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `receipt` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `voucher_items`
--

CREATE TABLE `voucher_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `owner_id` bigint(20) UNSIGNED NOT NULL,
  `voucher_id` bigint(20) UNSIGNED NOT NULL,
  `voucher_number` int(11) NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `product_quantity` int(11) NOT NULL,
  `product_rate` double NOT NULL,
  `total_price` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `brands_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `colors_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contacts_owner_id_foreign` (`owner_id`),
  ADD KEY `contacts_created_by_foreign` (`created_by`);

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `files_fileable_type_fileable_id_index` (`fileable_type`,`fileable_id`),
  ADD KEY `files_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoices_invoice_number_unique` (`invoice_number`),
  ADD KEY `invoices_owner_id_foreign` (`owner_id`),
  ADD KEY `invoices_contact_id_foreign` (`contact_id`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  ADD KEY `invoice_items_vehicle_id_foreign` (`vehicle_id`),
  ADD KEY `invoice_items_product_id_foreign` (`product_id`),
  ADD KEY `invoice_items_service_id_foreign` (`service_id`);

--
-- Indexes for table `job_cards`
--
ALTER TABLE `job_cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `job_cards_job_number_unique` (`job_number`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `opening_stock_qties`
--
ALTER TABLE `opening_stock_qties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `opening_stock_qties_owner_id_foreign` (`owner_id`),
  ADD KEY `opening_stock_qties_product_id_foreign` (`product_id`),
  ADD KEY `opening_stock_qties_created_by_foreign` (`created_by`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_paymentable_type_paymentable_id_index` (`paymentable_type`,`paymentable_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_category_id_foreign` (`category_id`),
  ADD KEY `products_updated_by_foreign` (`updated_by`),
  ADD KEY `products_name_index` (`name`),
  ADD KEY `products_created_by_index` (`created_by`),
  ADD KEY `products_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `purchases_purchase_number_unique` (`purchase_number`),
  ADD KEY `purchases_owner_id_foreign` (`owner_id`),
  ADD KEY `purchases_contact_id_foreign` (`contact_id`),
  ADD KEY `purchases_created_by_foreign` (`created_by`),
  ADD KEY `purchases_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_items_purchase_id_foreign` (`purchase_id`),
  ADD KEY `purchase_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sales_ref_no_unique` (`ref_no`),
  ADD KEY `sales_contact_id_foreign` (`contact_id`),
  ADD KEY `sales_owner_id_foreign` (`owner_id`),
  ADD KEY `sales_created_by_foreign` (`created_by`),
  ADD KEY `sales_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_items_sale_id_foreign` (`sale_id`),
  ADD KEY `sale_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `services_name_unique` (`name`),
  ADD KEY `services_owner_id_foreign` (`owner_id`),
  ADD KEY `services_category_id_foreign` (`category_id`);

--
-- Indexes for table `units`
--
ALTER TABLE `units`
  ADD PRIMARY KEY (`id`),
  ADD KEY `units_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicles_owner_id_foreign` (`owner_id`),
  ADD KEY `vehicles_contact_id_foreign` (`contact_id`),
  ADD KEY `vehicles_brand_id_foreign` (`brand_id`),
  ADD KEY `vehicles_color_id_foreign` (`color_id`),
  ADD KEY `vehicles_type_id_foreign` (`type_id`);

--
-- Indexes for table `vehicle_types`
--
ALTER TABLE `vehicle_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_types_owner_id_foreign` (`owner_id`);

--
-- Indexes for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vouchers_voucher_number_unique` (`voucher_number`),
  ADD KEY `vouchers_owner_id_foreign` (`owner_id`),
  ADD KEY `vouchers_contact_id_foreign` (`contact_id`),
  ADD KEY `vouchers_created_by_foreign` (`created_by`);

--
-- Indexes for table `voucher_items`
--
ALTER TABLE `voucher_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `voucher_items_owner_id_foreign` (`owner_id`),
  ADD KEY `voucher_items_voucher_id_foreign` (`voucher_id`),
  ADD KEY `voucher_items_product_id_foreign` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `colors`
--
ALTER TABLE `colors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `job_cards`
--
ALTER TABLE `job_cards`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `opening_stock_qties`
--
ALTER TABLE `opening_stock_qties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `units`
--
ALTER TABLE `units`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vehicle_types`
--
ALTER TABLE `vehicle_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `vouchers`
--
ALTER TABLE `vouchers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `voucher_items`
--
ALTER TABLE `voucher_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `brands`
--
ALTER TABLE `brands`
  ADD CONSTRAINT `brands_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `colors`
--
ALTER TABLE `colors`
  ADD CONSTRAINT `colors_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `contacts_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `files`
--
ALTER TABLE `files`
  ADD CONSTRAINT `files_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoices_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `invoice_items_vehicle_id_foreign` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `opening_stock_qties`
--
ALTER TABLE `opening_stock_qties`
  ADD CONSTRAINT `opening_stock_qties_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `opening_stock_qties_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `opening_stock_qties_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `products_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `purchases_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchases_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchases_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchases_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD CONSTRAINT `purchase_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `purchase_items_purchase_id_foreign` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD CONSTRAINT `sale_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sale_items_sale_id_foreign` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `services_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `services_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `units`
--
ALTER TABLE `units`
  ADD CONSTRAINT `units_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_brand_id_foreign` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vehicles_color_id_foreign` FOREIGN KEY (`color_id`) REFERENCES `colors` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vehicles_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vehicles_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vehicles_type_id_foreign` FOREIGN KEY (`type_id`) REFERENCES `vehicle_types` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vehicle_types`
--
ALTER TABLE `vehicle_types`
  ADD CONSTRAINT `vehicle_types_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vouchers`
--
ALTER TABLE `vouchers`
  ADD CONSTRAINT `vouchers_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vouchers_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `vouchers_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `voucher_items`
--
ALTER TABLE `voucher_items`
  ADD CONSTRAINT `voucher_items_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `voucher_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `voucher_items_voucher_id_foreign` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
