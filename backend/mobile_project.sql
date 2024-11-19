-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db:3306
-- Generation Time: Nov 19, 2024 at 11:33 AM
-- Server version: 11.5.2-MariaDB-ubu2404
-- PHP Version: 8.2.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mobile_project`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`%` PROCEDURE `cancel_request` ()   BEGIN
    UPDATE mobile_project.bookings
    SET
        bookings.status = IF(bookings.status = 'pending', 'cancel', bookings.status);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `disable_slot_1` ()   BEGIN
    UPDATE mobile_project.rooms
    SET slot_1 = 'disabled';
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `reset_all_slots` ()   BEGIN
    UPDATE mobile_project.rooms
    SET
        slot_1 = 'free',
        slot_2 = 'free',
        slot_3 = 'free',
        slot_4 = 'free';
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blacklist`
--

CREATE TABLE `blacklist` (
  `id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `slot` enum('slot_1','slot_2','slot_3','slot_4') NOT NULL,
  `status` enum('pending','approved','rejected','cancel') NOT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `booking_date` date NOT NULL DEFAULT current_timestamp(),
  `reason` varchar(60) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `user_id`, `room_id`, `slot`, `status`, `approved_by`, `booking_date`, `reason`, `created_at`, `updated_at`) VALUES
(9, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-13', 'test', '2024-11-13 18:39:16', '2024-11-15 04:02:41'),
(10, 20, 1, 'slot_3', 'cancel', NULL, '2024-11-13', 'ttgg', '2024-11-13 18:51:26', '2024-11-15 04:29:09'),
(11, 20, 1, 'slot_4', 'cancel', NULL, '2024-11-13', 'ff', '2024-11-13 18:53:09', '2024-11-15 04:56:57'),
(12, 20, 1, 'slot_2', 'cancel', NULL, '2024-11-13', 'ttt', '2024-11-13 18:59:17', '2024-11-15 04:57:06'),
(13, 20, 2, 'slot_1', 'cancel', NULL, '2024-11-13', 'hh', '2024-11-13 18:59:57', '2024-11-15 04:57:08'),
(14, 20, 2, 'slot_3', 'cancel', NULL, '2024-11-13', 'r4ff', '2024-11-13 19:00:33', '2024-11-15 04:57:09'),
(15, 20, 2, 'slot_4', 'cancel', NULL, '2024-11-13', 'ffg', '2024-11-13 19:00:51', '2024-11-15 04:57:10'),
(16, 20, 2, 'slot_2', 'cancel', NULL, '2024-11-13', 'uuu', '2024-11-13 19:01:41', '2024-11-15 04:57:11'),
(17, 20, 3, 'slot_1', 'cancel', NULL, '2024-11-15', 'ddyf', '2024-11-15 04:32:57', '2024-11-15 04:57:12'),
(18, 20, 3, 'slot_2', 'cancel', NULL, '2024-11-15', 'ttg', '2024-11-15 04:34:09', '2024-11-15 04:57:13'),
(19, 20, 3, 'slot_3', 'cancel', NULL, '2024-11-15', 'rhg', '2024-11-15 04:35:28', '2024-11-15 04:57:14'),
(20, 20, 3, 'slot_4', 'cancel', NULL, '2024-11-15', 'y to e', '2024-11-15 04:36:27', '2024-11-15 04:57:15'),
(21, 20, 4, 'slot_1', 'cancel', NULL, '2024-11-15', 'cv', '2024-11-15 04:38:06', '2024-11-15 04:57:16'),
(22, 20, 4, 'slot_2', 'cancel', NULL, '2024-11-15', 'ru going', '2024-11-15 04:39:25', '2024-11-15 04:57:16'),
(23, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'you', '2024-11-15 05:08:12', '2024-11-15 05:08:20'),
(24, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'rush to', '2024-11-15 05:10:45', '2024-11-15 05:10:49'),
(25, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'then', '2024-11-15 05:11:55', '2024-11-15 05:13:52'),
(26, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'see if Dad', '2024-11-15 13:17:30', '2024-11-15 13:17:35'),
(27, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'dish so do go can', '2024-11-15 13:17:46', '2024-11-15 13:25:55'),
(28, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'to at day heh heh', '2024-11-15 13:26:02', '2024-11-15 13:30:08'),
(29, 20, 8, 'slot_1', 'cancel', NULL, '2024-11-15', 'we try and go as', '2024-11-15 13:30:16', '2024-11-15 13:30:21'),
(30, 20, 1, 'slot_1', 'cancel', NULL, '2024-11-15', 'we sign go to get the do to help the in on', '2024-11-15 13:30:37', '2024-11-15 13:49:47'),
(31, 22, 1, 'slot_2', 'cancel', NULL, '2024-11-15', 'g try try to to I\'m', '2024-11-15 13:48:22', '2024-11-15 13:48:32'),
(32, 20, 1, 'slot_1', 'pending', NULL, '2024-11-15', 'see so all', '2024-11-15 13:49:56', '2024-11-15 13:49:56'),
(33, 20, 2, 'slot_2', 'pending', NULL, '2024-11-15', 'we do all heh', '2024-11-15 13:50:04', '2024-11-15 13:50:04'),
(34, 23, 7, 'slot_1', 'cancel', NULL, '2024-11-15', 'to try to to y\'all in', '2024-11-15 13:52:29', '2024-11-15 13:52:47'),
(35, 24, 2, 'slot_1', 'cancel', NULL, '2024-11-15', 'which do let to', '2024-11-15 13:57:24', '2024-11-15 13:57:33'),
(36, 24, 1, 'slot_3', 'cancel', NULL, '2024-11-15', 'we do', '2024-11-15 13:57:54', '2024-11-15 13:57:56');

-- --------------------------------------------------------

--
-- Table structure for table `bookmarks`
--

CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookmarks`
--

INSERT INTO `bookmarks` (`id`, `user_id`, `room_id`, `created_at`) VALUES
(8, 17, 1, '2024-11-09 20:07:39'),
(27, 20, 2, '2024-11-15 13:17:17'),
(30, 22, 1, '2024-11-15 13:48:49'),
(32, 23, 2, '2024-11-15 13:53:20'),
(33, 24, 1, '2024-11-15 13:58:12');

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `room_name` varchar(40) NOT NULL,
  `desc` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `slot_1` enum('free','pending','reserved','disabled') NOT NULL,
  `slot_2` enum('free','pending','reserved','disabled') NOT NULL,
  `slot_3` enum('free','pending','reserved','disabled') NOT NULL,
  `slot_4` enum('free','pending','reserved','disabled') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`id`, `room_name`, `desc`, `image`, `slot_1`, `slot_2`, `slot_3`, `slot_4`, `created_at`, `updated_at`) VALUES
(1, 'room_001', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'pending', 'free', 'free', 'free', '2024-11-05 18:24:06', '2024-11-15 13:57:56'),
(2, 'room_002', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'pending', 'free', 'free', '2024-11-05 18:28:08', '2024-11-15 13:57:33'),
(3, 'room_003', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'free', 'free', 'free', '2024-11-05 18:28:12', '2024-11-15 04:59:55'),
(4, 'room_004', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'free', 'free', 'free', '2024-11-05 18:28:15', '2024-11-15 04:59:55'),
(5, 'room_005', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'free', 'free', 'free', '2024-11-05 18:28:17', '2024-11-12 23:33:32'),
(6, 'room_006', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'free', 'free', 'free', '2024-11-05 18:32:48', '2024-11-12 23:33:32'),
(7, 'room_007', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'free', 'free', 'free', '2024-11-06 04:44:56', '2024-11-15 13:52:47'),
(8, 'room_008', 'test', '1731453875754-toa-heftiba-FV3GConVSss-unsplash.jpg', 'free', 'free', 'free', 'free', '2024-11-12 23:24:35', '2024-11-15 13:30:21');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `role` enum('student','staff','approver') NOT NULL DEFAULT 'student',
  `username` varchar(60) NOT NULL,
  `password` varchar(60) NOT NULL,
  `email` varchar(60) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `role`, `username`, `password`, `email`, `created_at`, `updated_at`) VALUES
(17, 'student', 'stu', '$2b$10$yEXArLPDe9DEfyjiNjAGs.4vw5ioz83wwglpldKbE6cAmG.f8r7Si', 'stu@lamduan.mfu.ac.th', '2024-11-09 19:46:47', '2024-11-09 19:46:47'),
(18, 'staff', 'staff', '$2b$10$My86lJMjBfWXikqz8LmM4u6BZL/dNkHmK25gWRHP0Rz5YnfD1Wyge', 'staff@lamduan.mfu.ac.th', '2024-11-09 20:06:12', '2024-11-09 20:06:50'),
(19, 'approver', 'lec', '$2b$10$ARxWHjEMhNhayT0cLvUlT.tGjcYWUzXsG9ZlmGpLda5ntVInLVTt6', 'lec@lamduan.mfu.ac.th', '2024-11-09 20:06:35', '2024-11-09 20:06:50'),
(20, 'student', 'test', '$2b$10$VRfwJdA8s4etMVzxvAegFeJJIC95hO8/dJEeXA1LS8UCRYeNm/i5y', 'test@lamduan.mfu.ac.th', '2024-11-11 19:55:38', '2024-11-11 19:55:38'),
(21, 'student', 'hsoifhas;', '$2b$10$BA.8V.bViv8pF/CIjh.0BO5iXXvBb4YUlY6UbVT6yF/B6xF0.VUbS', 'sjhaflkjsdh@email.com', '2024-11-15 13:45:25', '2024-11-15 13:45:25'),
(22, 'student', 'student', '$2b$10$HtDJMoxOwiD140p0GSebyeJ/V29GHjBxonmhTeXZb1x42P0MY.5rK', 'student@email.com', '2024-11-15 13:47:23', '2024-11-15 13:47:23'),
(23, 'student', 'stu1', '$2b$10$T9EoWmnGhrVSleP1IgY4VeeHCj5PEyeTMbriouQxEwSreqfh7fKve', 'stu1@email.com', '2024-11-15 13:51:35', '2024-11-15 13:51:35'),
(24, 'student', 'stu2', '$2b$10$xAiY5l4CSg.tcYw.RFOABO0sL0bCmeh8SpFUGxLqJwWLxqCK/hGmK', 'stu2@email.com', '2024-11-15 13:56:23', '2024-11-15 13:56:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blacklist`
--
ALTER TABLE `blacklist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `approved_by` (`approved_by`);

--
-- Indexes for table `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blacklist`
--
ALTER TABLE `blacklist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `bookmarks`
--
ALTER TABLE `bookmarks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_approved_by_fk` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `bookings_room_fk` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bookmarks`
--
ALTER TABLE `bookmarks`
  ADD CONSTRAINT `bookmarks_room_fk` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookmarks_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`%` EVENT `dairy_reset` ON SCHEDULE EVERY 1 DAY STARTS '2024-11-01 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
CALL reset_all_slots();
CALL cancel_request();
END$$

CREATE DEFINER=`root`@`%` EVENT `disable_after_10:00` ON SCHEDULE EVERY 1 DAY STARTS '2024-11-01 10:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
CALL disable_slot("slot_1");
END$$

CREATE DEFINER=`root`@`%` EVENT `disable_after_12:00` ON SCHEDULE EVERY 1 DAY STARTS '2024-11-01 12:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
CALL disable_slot("slot_2");
END$$

CREATE DEFINER=`root`@`%` EVENT `disable_after_15:00` ON SCHEDULE EVERY 1 DAY STARTS '2024-11-01 15:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
CALL disable_slot("slot_3");
END$$

CREATE DEFINER=`root`@`%` EVENT `disable_after_17:00` ON SCHEDULE EVERY 1 DAY STARTS '2024-11-01 17:00:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
CALL disable_slot("slot_4");
END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
