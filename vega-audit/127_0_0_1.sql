-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 08, 2025 at 02:24 PM
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
-- Database: `auditdb`
--
CREATE DATABASE IF NOT EXISTS `auditdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `auditdb`;

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `sr_no` int(11) NOT NULL,
  `device_id` varchar(50) NOT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `device_type` varchar(100) DEFAULT NULL,
  `min_temp` decimal(10,2) DEFAULT NULL,
  `max_temp` decimal(10,2) DEFAULT NULL,
  `min_temp_warning` decimal(10,2) DEFAULT NULL,
  `max_temp_warning` decimal(10,2) DEFAULT NULL,
  `min_temp_probe` decimal(10,2) DEFAULT NULL,
  `max_temp_probe` decimal(10,2) DEFAULT NULL,
  `min_temp_warn_prob` decimal(10,2) DEFAULT NULL,
  `max_temp_warn_prob` decimal(10,2) DEFAULT NULL,
  `logging_interval` int(11) DEFAULT NULL,
  `sending_interval` int(11) DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`sr_no`, `device_id`, `device_name`, `device_type`, `min_temp`, `max_temp`, `min_temp_warning`, `max_temp_warning`, `min_temp_probe`, `max_temp_probe`, `min_temp_warn_prob`, `max_temp_warn_prob`, `logging_interval`, `sending_interval`, `user_id`, `updated_at`) VALUES
(1, 'BA1076', 'Temprature & humidity', 'Alpha', 23.00, 65.00, 23.00, 87.00, 34.00, 89.00, 34.00, 78.00, 2, 4, 'rathodyash636@gmail.com', '2025-11-08 02:48:29'),
(2, 'BA1000', 'Data logger ', 'Mega', 21.00, 43.00, 23.00, 46.00, 23.00, 90.00, 23.00, 87.00, 32, 23, 'rathodyash636@gmail.com', '2025-11-08 02:57:07'),
(3, 'BA7000', 'Name_BA7000', 'Alpha', 50.00, 66.00, 23.00, 66.00, 87.00, 24.00, 56.00, 57.00, 10, 10, 'rathodyash636@gmail.com', '2025-11-08 04:37:58');

--
-- Triggers `devices`
--
DELIMITER $$
CREATE TRIGGER `trg_device_delete` AFTER DELETE ON `devices` FOR EACH ROW BEGIN
    INSERT INTO devices_audit (         device_id,
        old_device_name, old_device_type, old_min_temp, old_max_temp,
        old_min_temp_warning, old_max_temp_warning, old_min_temp_probe, old_max_temp_probe,
        old_min_temp_warn_prob, old_max_temp_warn_prob,
        old_logging_interval, old_sending_interval,
        action_type, user_id, updated_at     ) VALUES (
        OLD.device_id,
        OLD.device_name, OLD.device_type, OLD.min_temp, OLD.max_temp,
        OLD.min_temp_warning, OLD.max_temp_warning, OLD.min_temp_probe, OLD.max_temp_probe,
        OLD.min_temp_warn_prob, OLD.max_temp_warn_prob,
        OLD.logging_interval, OLD.sending_interval,
        'DELETE', OLD.user_id, NOW()     );
    INSERT INTO devices_audit_report (         module, description, user_id, action, device_id
    ) VALUES (
        'Device Config',
        CONCAT(OLD.device_id, ' configuration deleted'),
        OLD.user_id,         'Device Config Deleted',
        OLD.device_id
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_device_insert` AFTER INSERT ON `devices` FOR EACH ROW BEGIN    INSERT INTO devices_audit (         device_id,
        new_device_name, new_device_type, new_min_temp, new_max_temp,
        new_min_temp_warning, new_max_temp_warning, new_min_temp_probe, new_max_temp_probe,
        new_min_temp_warn_prob, new_max_temp_warn_prob,
        new_logging_interval, new_sending_interval,
        action_type, user_id, updated_at     ) VALUES (
        NEW.device_id,
        NEW.device_name, NEW.device_type, NEW.min_temp, NEW.max_temp,
        NEW.min_temp_warning, NEW.max_temp_warning, NEW.min_temp_probe, NEW.max_temp_probe,
        NEW.min_temp_warn_prob, NEW.max_temp_warn_prob,
        NEW.logging_interval, NEW.sending_interval,
        'INSERT', NEW.user_id, NEW.updated_at     );    INSERT INTO devices_audit_report (
        module, description, user_id, action, device_id
    ) VALUES (
        'Device Config',
        CONCAT(NEW.device_id, ' configuration created'),
        NEW.user_id,         'Device Config Created',
        NEW.device_id
    );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_device_update` AFTER UPDATE ON `devices` FOR EACH ROW BEGIN
    INSERT INTO devices_audit (         device_id,
        old_device_name, old_device_type, old_min_temp, old_max_temp,
        old_min_temp_warning, old_max_temp_warning, old_min_temp_probe, old_max_temp_probe,
        old_min_temp_warn_prob, old_max_temp_warn_prob,
        old_logging_interval, old_sending_interval,
        new_device_name, new_device_type, new_min_temp, new_max_temp,
        new_min_temp_warning, new_max_temp_warning, new_min_temp_probe, new_max_temp_probe,
        new_min_temp_warn_prob, new_max_temp_warn_prob,
        new_logging_interval, new_sending_interval,
        action_type, user_id, updated_at     ) VALUES (
        NEW.device_id,
        OLD.device_name, OLD.device_type, OLD.min_temp, OLD.max_temp,
        OLD.min_temp_warning, OLD.max_temp_warning, OLD.min_temp_probe, OLD.max_temp_probe,
        OLD.min_temp_warn_prob, OLD.max_temp_warn_prob,
        OLD.logging_interval, OLD.sending_interval,
        NEW.device_name, NEW.device_type, NEW.min_temp, NEW.max_temp,
        NEW.min_temp_warning, NEW.max_temp_warning, NEW.min_temp_probe, NEW.max_temp_probe,
        NEW.min_temp_warn_prob, NEW.max_temp_warn_prob,
        NEW.logging_interval, NEW.sending_interval,
        'UPDATE', NEW.user_id, NEW.updated_at     );
    INSERT INTO devices_audit_report (         module, description, user_id, action, device_id
    ) VALUES (
        'Device Config',
        CONCAT(NEW.device_id, ' configuration updated'),
        NEW.user_id,         'Device Config Updated',
        NEW.device_id
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `devices_audit`
--

CREATE TABLE `devices_audit` (
  `audit_id` int(11) NOT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `old_device_name` varchar(255) DEFAULT NULL,
  `old_device_type` varchar(100) DEFAULT NULL,
  `old_min_temp` decimal(10,2) DEFAULT NULL,
  `old_max_temp` decimal(10,2) DEFAULT NULL,
  `old_min_temp_warning` decimal(10,2) DEFAULT NULL,
  `old_max_temp_warning` decimal(10,2) DEFAULT NULL,
  `old_min_temp_probe` decimal(10,2) DEFAULT NULL,
  `old_max_temp_probe` decimal(10,2) DEFAULT NULL,
  `old_min_temp_warn_prob` decimal(10,2) DEFAULT NULL,
  `old_max_temp_warn_prob` decimal(10,2) DEFAULT NULL,
  `old_logging_interval` int(11) DEFAULT NULL,
  `old_sending_interval` int(11) DEFAULT NULL,
  `new_device_name` varchar(255) DEFAULT NULL,
  `new_device_type` varchar(100) DEFAULT NULL,
  `new_min_temp` decimal(10,2) DEFAULT NULL,
  `new_max_temp` decimal(10,2) DEFAULT NULL,
  `new_min_temp_warning` decimal(10,2) DEFAULT NULL,
  `new_max_temp_warning` decimal(10,2) DEFAULT NULL,
  `new_min_temp_probe` decimal(10,2) DEFAULT NULL,
  `new_max_temp_probe` decimal(10,2) DEFAULT NULL,
  `new_min_temp_warn_prob` decimal(10,2) DEFAULT NULL,
  `new_max_temp_warn_prob` decimal(10,2) DEFAULT NULL,
  `new_logging_interval` int(11) DEFAULT NULL,
  `new_sending_interval` int(11) DEFAULT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices_audit`
--

INSERT INTO `devices_audit` (`audit_id`, `device_id`, `old_device_name`, `old_device_type`, `old_min_temp`, `old_max_temp`, `old_min_temp_warning`, `old_max_temp_warning`, `old_min_temp_probe`, `old_max_temp_probe`, `old_min_temp_warn_prob`, `old_max_temp_warn_prob`, `old_logging_interval`, `old_sending_interval`, `new_device_name`, `new_device_type`, `new_min_temp`, `new_max_temp`, `new_min_temp_warning`, `new_max_temp_warning`, `new_min_temp_probe`, `new_max_temp_probe`, `new_min_temp_warn_prob`, `new_max_temp_warn_prob`, `new_logging_interval`, `new_sending_interval`, `action_type`, `user_id`, `updated_at`) VALUES
(1, 'BA1076', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Temprature & humidity', 'Alpha', 23.00, 65.00, 23.00, 87.00, 34.00, 89.00, 34.00, 78.00, 2, 4, 'INSERT', 'rathodyash636@gmail.com', '2025-11-08 02:48:29'),
(2, 'BA1000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Data logger', 'Alpha', 21.00, 43.00, 23.00, 46.00, 23.00, 90.00, 23.00, 87.00, 32, 23, 'INSERT', 'rathodyash636@gmail.com', '2025-11-08 02:57:07'),
(3, 'BA1000', 'Data logger', 'Alpha', 21.00, 43.00, 23.00, 46.00, 23.00, 90.00, 23.00, 87.00, 32, 23, 'Data logger & hum', 'Alpha', 21.00, 43.00, 23.00, 46.00, 23.00, 90.00, 23.00, 87.00, 32, 23, 'UPDATE', 'rathodyash636@gmail.com', '2025-11-08 02:57:07'),
(4, 'BA1000', 'Data logger & hum', 'Alpha', 21.00, 43.00, 23.00, 46.00, 23.00, 90.00, 23.00, 87.00, 32, 23, 'Data logger ', 'Mega', 21.00, 43.00, 23.00, 46.00, 23.00, 90.00, 23.00, 87.00, 32, 23, 'UPDATE', 'rathodyash636@gmail.com', '2025-11-08 02:57:07'),
(5, 'BA7000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Name_BA7000', 'Alpha', 45.00, 66.00, 23.00, 66.00, 87.00, 24.00, 56.00, 57.00, 5, 5, 'INSERT', 'rathodyash636@gmail.com', '2025-11-08 04:37:58'),
(6, 'BA7000', 'Name_BA7000', 'Alpha', 45.00, 66.00, 23.00, 66.00, 87.00, 24.00, 56.00, 57.00, 5, 5, 'Name_BA7000', 'Alpha', 50.00, 66.00, 23.00, 66.00, 87.00, 24.00, 56.00, 57.00, 10, 10, 'UPDATE', 'rathodyash636@gmail.com', '2025-11-08 04:37:58');

-- --------------------------------------------------------

--
-- Table structure for table `devices_audit_report`
--

CREATE TABLE `devices_audit_report` (
  `sr_no` int(11) NOT NULL,
  `device_id` varchar(50) DEFAULT NULL,
  `date_time` datetime DEFAULT current_timestamp(),
  `module` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices_audit_report`
--

INSERT INTO `devices_audit_report` (`sr_no`, `device_id`, `date_time`, `module`, `description`, `user_id`, `action`) VALUES
(1, 'BA1076', '2025-11-08 02:48:29', 'Device Config', 'BA1076 configuration created', 'rathodyash636@gmail.com', 'Device Config Created'),
(2, 'BA1000', '2025-11-08 02:57:07', 'Device Config', 'BA1000 configuration created', 'rathodyash636@gmail.com', 'Device Config Created'),
(3, 'BA1000', '2025-11-08 04:05:12', 'Device Config', 'BA1000 configuration updated', 'rathodyash636@gmail.com', 'Device Config Updated'),
(4, 'BA1000', '2025-11-08 04:07:20', 'Device Config', 'BA1000 configuration updated', 'rathodyash636@gmail.com', 'Device Config Updated'),
(5, 'BA7000', '2025-11-08 04:37:58', 'Device Config', 'BA7000 configuration created', 'rathodyash636@gmail.com', 'Device Config Created'),
(6, 'BA7000', '2025-11-08 04:38:41', 'Device Config', 'BA7000 configuration updated', 'rathodyash636@gmail.com', 'Device Config Updated');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`sr_no`),
  ADD UNIQUE KEY `device_id` (`device_id`);

--
-- Indexes for table `devices_audit`
--
ALTER TABLE `devices_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- Indexes for table `devices_audit_report`
--
ALTER TABLE `devices_audit_report`
  ADD PRIMARY KEY (`sr_no`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `devices`
--
ALTER TABLE `devices`
  MODIFY `sr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `devices_audit`
--
ALTER TABLE `devices_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `devices_audit_report`
--
ALTER TABLE `devices_audit_report`
  MODIFY `sr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- Database: `email`
--
CREATE DATABASE IF NOT EXISTS `email` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `email`;

-- --------------------------------------------------------

--
-- Table structure for table `auditreport`
--

CREATE TABLE `auditreport` (
  `date_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `module` varchar(200) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `changed_desc` longtext DEFAULT NULL,
  `sr_no` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auditreport`
--

INSERT INTO `auditreport` (`date_time`, `module`, `description`, `changed_desc`, `sr_no`) VALUES
('2025-11-06 12:16:58', 'report', 'file >>Windows>>PDF', NULL, NULL),
('2025-11-06 12:17:07', 'report', 'file name>>Mac>>PDF', 'file is>>window>>pdf', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `emaildata`
--

CREATE TABLE `emaildata` (
  `id` int(11) NOT NULL,
  `email_id` varchar(100) DEFAULT NULL,
  `start_date` varchar(50) DEFAULT NULL,
  `end_date` varchar(50) DEFAULT NULL,
  `number_time` int(11) DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `birthDate` int(11) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emaildata`
--

INSERT INTO `emaildata` (`id`, `email_id`, `start_date`, `end_date`, `number_time`, `message`, `birthDate`, `user_name`) VALUES
(1, 'fsd', '2025-11-04', '2025-11-04', 34, 'dfds', NULL, NULL),
(2, 'fsd', '2025-11-04', '2025-11-04', 34, 'dfds', NULL, NULL),
(3, '434', '2025-11-18', '2025-11-17', 23, 'erewr', NULL, NULL),
(4, '434', '2025-11-18', '2025-11-17', 23, 'erewr', NULL, NULL),
(5, 'ew@ds', '2025-11-11', '2025-11-14', 2, 'dsdsd', NULL, NULL),
(6, 'dds', '2025-11-11', '2025-11-06T07:33:57.443Z', 0, 'dew', NULL, NULL),
(7, 'dds', '2025-11-11', '2025-11-06T07:33:57.443Z', 0, 'dew', NULL, NULL),
(8, 'dds', '2025-11-11', '2025-11-06T07:33:57.443Z', 0, 'dew', NULL, NULL),
(9, 'dds', '2025-11-11', '2025-11-06T07:33:57.443Z', 0, 'dew', NULL, NULL),
(10, 'dds', '2025-11-11', '2025-11-06T07:33:57.443Z', 0, 'dew', NULL, NULL),
(11, 'dds', '2025-11-11', '2025-11-06T07:33:57.443Z', 0, 'dew', NULL, NULL),
(12, 'grre@dfg.com', '2025-11-04', '2025-11-07', 4, 'gerg', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `emails`
--

CREATE TABLE `emails` (
  `id` int(11) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `birth_time` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `emails`
--

INSERT INTO `emails` (`id`, `email`, `user_name`, `birth_time`) VALUES
(1, 'rathodyash636@gmail.com', 'rathod', '04:00'),
(2, 'satishyadav25218@gmail.com', 'satish yadav', '02:20');

-- --------------------------------------------------------

--
-- Table structure for table `vega_audit`
--

CREATE TABLE `vega_audit` (
  `sr_no` int(11) NOT NULL,
  `date_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `module` varchar(100) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `user_id` varchar(200) DEFAULT NULL,
  `action` varchar(200) DEFAULT NULL,
  `device_id` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vega_audit`
--

INSERT INTO `vega_audit` (`sr_no`, `date_time`, `module`, `description`, `user_id`, `action`, `device_id`) VALUES
(1, '2025-11-08 06:41:02', 'Device Config', 'BA1067 configration updated', 'rathodyash636@gmail.com', 'Device Config Updated', 'BA1067'),
(2, '2025-11-08 07:02:57', 'Device Config', 'BA1067 configration updated', 'rathodyash636@gmail.com', 'Updated', 'BA1067'),
(3, '2025-11-08 07:04:12', 'Device Config', 'BA1000s configration updated', 'rathodyash636@gmail.com', 'Updated', 'BA1000s');

--
-- Triggers `vega_audit`
--
DELIMITER $$
CREATE TRIGGER `trg_vega_audit_delete` AFTER DELETE ON `vega_audit` FOR EACH ROW BEGIN
    INSERT INTO vega_audit_log 
    (sr_no, date_time, module, description, user_id, action, device_id)
    VALUES 
    (OLD.sr_no, OLD.date_time, OLD.module, OLD.description, OLD.user_id, OLD.action, OLD.device_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_vega_audit_insert` AFTER INSERT ON `vega_audit` FOR EACH ROW BEGIN
    INSERT INTO vega_audit_log 
    (sr_no, date_time, module, description, user_id, action, device_id)
    VALUES 
    (NEW.sr_no, NEW.date_time, NEW.module, NEW.description, NEW.user_id, NEW.action, NEW.device_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_vega_audit_update` AFTER UPDATE ON `vega_audit` FOR EACH ROW BEGIN
    INSERT INTO vega_audit_log 
    (sr_no, date_time, module, description, user_id, action, device_id)
    VALUES 
    (NEW.sr_no, NEW.date_time, NEW.module, NEW.description, NEW.user_id, NEW.action, NEW.device_id);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `vega_audit_log`
--

CREATE TABLE `vega_audit_log` (
  `log_id` int(11) NOT NULL,
  `action_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sr_no` int(11) DEFAULT NULL,
  `date_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `module` varchar(100) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `user_id` varchar(200) DEFAULT NULL,
  `action` varchar(200) DEFAULT NULL,
  `device_id` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vega_audit_log`
--

INSERT INTO `vega_audit_log` (`log_id`, `action_time`, `sr_no`, `date_time`, `module`, `description`, `user_id`, `action`, `device_id`) VALUES
(1, '2025-11-08 06:41:02', 1, '2025-11-08 06:41:02', 'Device Config', 'BA1067 configration updated', 'rathodyash636@gmail.com', 'Device Config Updated', 'BA1067'),
(2, '2025-11-08 07:02:57', 2, '2025-11-08 07:02:57', 'Device Config', 'BA1067 configration updated', 'rathodyash636@gmail.com', 'Updated', 'BA1067'),
(3, '2025-11-08 07:04:12', 3, '2025-11-08 07:04:12', 'Device Config', 'BA1000s configration updated', 'rathodyash636@gmail.com', 'Updated', 'BA1000s');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `emaildata`
--
ALTER TABLE `emaildata`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `emails`
--
ALTER TABLE `emails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vega_audit`
--
ALTER TABLE `vega_audit`
  ADD PRIMARY KEY (`sr_no`);

--
-- Indexes for table `vega_audit_log`
--
ALTER TABLE `vega_audit_log`
  ADD PRIMARY KEY (`log_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `emaildata`
--
ALTER TABLE `emaildata`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `emails`
--
ALTER TABLE `emails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `vega_audit`
--
ALTER TABLE `vega_audit`
  MODIFY `sr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vega_audit_log`
--
ALTER TABLE `vega_audit_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- Database: `nuxt`
--
CREATE DATABASE IF NOT EXISTS `nuxt` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `nuxt`;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CustomerID` int(11) NOT NULL,
  `CustomerName` varchar(100) DEFAULT NULL,
  `ContactName` varchar(100) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `City` varchar(100) DEFAULT NULL,
  `PostalCode` varchar(20) DEFAULT NULL,
  `Country` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CustomerID`, `CustomerName`, `ContactName`, `Address`, `City`, `PostalCode`, `Country`) VALUES
(1, 'Alfreds Futterkiste', 'Maria Anders', 'Obere Str. 57', 'Berlin', '12209', 'Germany'),
(2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Avda. de la Constitución 2222', 'México D.F.', '05021', 'Mexico'),
(3, 'Antonio Moreno Taquería', 'Antonio Moreno', 'Mataderos 2312', 'México D.F.', '05023', 'Mexico');

-- --------------------------------------------------------

--
-- Table structure for table `new_test`
--

CREATE TABLE `new_test` (
  `id` int(11) NOT NULL,
  `task` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_completed` tinyint(1) DEFAULT 1,
  `age` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `new_test`
--

INSERT INTO `new_test` (`id`, `task`, `created_at`, `is_completed`, `age`) VALUES
(1, 'my sql', '2025-11-04 21:52:41', 0, 22),
(2, 'nuxt app', '2025-11-04 21:52:41', 0, 21);

-- --------------------------------------------------------

--
-- Table structure for table `persions`
--

CREATE TABLE `persions` (
  `PersionID` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `persons`
--

CREATE TABLE `persons` (
  `PersonID` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `testing`
--

CREATE TABLE `testing` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,
  `country` varchar(20) DEFAULT NULL,
  `sum` int(30) DEFAULT NULL,
  `total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `testing`
--

INSERT INTO `testing` (`id`, `name`, `age`, `email`, `created_at`, `is_active`, `country`, `sum`, `total`) VALUES
(1, 'Alice Johnson', 25, 'alice@example.com', '2025-11-04 21:41:45', 1, 'india', 51, 50.5),
(3, 'Charlie Brown', 28, 'charlie@example.com', '2025-11-04 21:41:45', 1, 'india', 51, 50.5),
(4, 'Diana Prince', 40, 'diana@example.com', '2025-11-04 21:41:45', 1, 'india', 51, 50.5),
(6, 'rathod yash', 21, 'rathodyash636@gmail.com', '2025-11-04 21:44:01', 1, 'france', 51, 50.5);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`);

--
-- Indexes for table `new_test`
--
ALTER TABLE `new_test`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `testing`
--
ALTER TABLE `testing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `yash` (`name`,`email`),
  ADD KEY `yo` (`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `new_test`
--
ALTER TABLE `new_test`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `testing`
--
ALTER TABLE `testing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- Database: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

-- Table structure for table `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Table structure for table `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

-- --------------------------------------------------------

--
-- Table structure for table `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Table structure for table `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Table structure for table `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Table structure for table `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

--
-- Dumping data for table `pma__recent`
--

INSERT INTO `pma__recent` (`username`, `tables`) VALUES
('root', '[{\"db\":\"vega\",\"table\":\"device_config_audit\"},{\"db\":\"vega\",\"table\":\"device_config\"}]');

-- --------------------------------------------------------

--
-- Table structure for table `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Table structure for table `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

--
-- Dumping data for table `pma__table_uiprefs`
--

INSERT INTO `pma__table_uiprefs` (`username`, `db_name`, `table_name`, `prefs`, `last_update`) VALUES
('root', 'vega', 'device_config', '{\"CREATE_TIME\":\"2025-11-06 20:58:07\",\"col_order\":[0,7,1,2,3,5,6,8,9,10,11,12,13,4,14,15],\"col_visib\":[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]}', '2025-11-07 09:14:20');

-- --------------------------------------------------------

--
-- Table structure for table `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Table structure for table `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Dumping data for table `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2025-11-08 13:23:36', '{\"Console\\/Mode\":\"collapse\",\"NavigationWidth\":0}');

-- --------------------------------------------------------

--
-- Table structure for table `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Table structure for table `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Indexes for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Indexes for table `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Indexes for table `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Indexes for table `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Indexes for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Indexes for table `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Indexes for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Indexes for table `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Indexes for table `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Indexes for table `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Indexes for table `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Indexes for table `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Indexes for table `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Database: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
--
-- Database: `testdb`
--
CREATE DATABASE IF NOT EXISTS `testdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `testdb`;

-- --------------------------------------------------------

--
-- Table structure for table `signup_user`
--

CREATE TABLE `signup_user` (
  `id` int(11) NOT NULL,
  `firstName` varchar(100) DEFAULT NULL,
  `lastName` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `passwod` varchar(100) DEFAULT NULL,
  `confirmPassword` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `signup_user`
--

INSERT INTO `signup_user` (`id`, `firstName`, `lastName`, `email`, `passwod`, `confirmPassword`) VALUES
(1, 'hjas', 'sdf', 'ds@sdf', '', ''),
(2, 'hjas', 'sdf', 'dsfds@sds', '123', '123'),
(3, 'yAH', 'SAD', 'SD@FGD', '123', '123'),
(4, 'yash', 'rathod', 'rathodyash636@gmail.com', 'rathodyash', 'rathodyash'),
(5, 'yay', 'asda', 'ssd@sdfsd', 'sfsdf1111', 'sfsdf1111');

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL,
  `task` varchar(100) DEFAULT NULL,
  `completed` tinyint(1) DEFAULT NULL,
  `pin` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `task`, `completed`, `pin`) VALUES
(1, 'yash', 0, 0),
(2, 'rathod', 0, 0),
(3, 'jay ho', 0, 0),
(4, 'sdf', 0, 0),
(5, 'sdf', 0, 0),
(6, 'sdss', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`) VALUES
(1, 'yoyoyoyo', 'yash@gmail.com'),
(2, 'yoyoyoyo', 'yashrathod636@gmail.com');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `signup_user`
--
ALTER TABLE `signup_user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tasks`
--
ALTER TABLE `tasks`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `signup_user`
--
ALTER TABLE `signup_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tasks`
--
ALTER TABLE `tasks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Database: `vega`
--
CREATE DATABASE IF NOT EXISTS `vega` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `vega`;

-- --------------------------------------------------------

--
-- Table structure for table `device_config`
--

CREATE TABLE `device_config` (
  `sr_no` int(11) NOT NULL,
  `device_id` varchar(150) DEFAULT NULL,
  `device_name` varchar(200) DEFAULT NULL,
  `device_type` varchar(150) DEFAULT NULL,
  `min_temp` float(50,2) DEFAULT NULL,
  `max_temp` float(50,2) DEFAULT NULL,
  `min_temp_warning` float(50,2) DEFAULT NULL,
  `max_temp_warning` float(50,2) DEFAULT NULL,
  `min_temp_probe` float(50,2) DEFAULT NULL,
  `max_temp_probe` float(50,2) DEFAULT NULL,
  `min_temp_warn_prob` float(50,2) DEFAULT NULL,
  `max_temp_warn_prob` float(50,2) DEFAULT NULL,
  `logging_interval` int(11) DEFAULT NULL,
  `sending_interval` int(11) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_config`
--

INSERT INTO `device_config` (`sr_no`, `device_id`, `device_name`, `device_type`, `min_temp`, `max_temp`, `min_temp_warning`, `max_temp_warning`, `min_temp_probe`, `max_temp_probe`, `min_temp_warn_prob`, `max_temp_warn_prob`, `logging_interval`, `sending_interval`, `updated_by`, `updated_at`) VALUES
(1, 'BA1067', 'Single temprature and humidity', 'Alpha', 30.00, 80.00, 20.00, 100.00, 35.00, 75.00, 10.00, 120.00, 1, 1, 'yash', '2025-11-07 22:41:02'),
(2, 'BA1067', 'Single temprature data logger', 'Alpha', 43.00, 43.00, -443.00, 43.00, -43.00, 34.00, 43.00, 43.00, 1, 32, 'yash', '2025-11-07 23:02:57'),
(3, 'BA1000s', 'Single temprature data logger', 'Alpha', 43.00, 433.00, -443.00, 43.00, -43.00, 34.00, 43.00, 43.00, 1, 32, 'yash', '2025-11-07 23:04:12');

--
-- Triggers `device_config`
--
DELIMITER $$
CREATE TRIGGER `trg_device_config_delete` AFTER DELETE ON `device_config` FOR EACH ROW INSERT INTO device_config_audit (   device_id,
  old_device_name, old_device_type, old_min_temp, old_max_temp,
  old_min_temp_warning, old_max_temp_warning, old_min_temp_probe, old_max_temp_probe,
  old_min_temp_warn_prob, old_max_temp_warn_prob, old_logging_interval, old_sending_interval,
  action_type, updated_by
)
VALUES (
  OLD.device_id,
  OLD.device_name, OLD.device_type, OLD.min_temp, OLD.max_temp,
  OLD.min_temp_warning, OLD.max_temp_warning, OLD.min_temp_probe, OLD.max_temp_probe,
  OLD.min_temp_warn_prob, OLD.max_temp_warn_prob, OLD.logging_interval, OLD.sending_interval,
  'DELETE', CURRENT_USER()
)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_device_config_insert` AFTER INSERT ON `device_config` FOR EACH ROW INSERT INTO device_config_audit (   device_id,
  new_device_name, new_device_type, new_min_temp, new_max_temp,
  new_min_temp_warning, new_max_temp_warning, new_min_temp_probe, new_max_temp_probe,
  new_min_temp_warn_prob, new_max_temp_warn_prob, new_logging_interval, new_sending_interval,
  action_type, updated_by
)
VALUES (
  NEW.device_id,
  NEW.device_name, NEW.device_type, NEW.min_temp, NEW.max_temp,
  NEW.min_temp_warning, NEW.max_temp_warning, NEW.min_temp_probe, NEW.max_temp_probe,
  NEW.min_temp_warn_prob, NEW.max_temp_warn_prob, NEW.logging_interval, NEW.sending_interval,
  'INSERT', CURRENT_USER()
)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_device_config_update` AFTER UPDATE ON `device_config` FOR EACH ROW INSERT INTO device_config_audit (   device_id,
  old_device_name, old_device_type, old_min_temp, old_max_temp,
  old_min_temp_warning, old_max_temp_warning, old_min_temp_probe, old_max_temp_probe,
  old_min_temp_warn_prob, old_max_temp_warn_prob, old_logging_interval, old_sending_interval,
  new_device_name, new_device_type, new_min_temp, new_max_temp,
  new_min_temp_warning, new_max_temp_warning, new_min_temp_probe, new_max_temp_probe,
  new_min_temp_warn_prob, new_max_temp_warn_prob, new_logging_interval, new_sending_interval,
  action_type, updated_by
)
VALUES (
  OLD.device_id,
  OLD.device_name, OLD.device_type, OLD.min_temp, OLD.max_temp,
  OLD.min_temp_warning, OLD.max_temp_warning, OLD.min_temp_probe, OLD.max_temp_probe,
  OLD.min_temp_warn_prob, OLD.max_temp_warn_prob, OLD.logging_interval, OLD.sending_interval,
  NEW.device_name, NEW.device_type, NEW.min_temp, NEW.max_temp,
  NEW.min_temp_warning, NEW.max_temp_warning, NEW.min_temp_probe, NEW.max_temp_probe,
  NEW.min_temp_warn_prob, NEW.max_temp_warn_prob, NEW.logging_interval, NEW.sending_interval,
  'UPDATE', CURRENT_USER()
)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `device_config_audit`
--

CREATE TABLE `device_config_audit` (
  `audit_id` int(11) NOT NULL,
  `device_id` varchar(150) DEFAULT NULL,
  `old_device_name` varchar(200) DEFAULT NULL,
  `old_device_type` varchar(150) DEFAULT NULL,
  `old_min_temp` float(50,2) DEFAULT NULL,
  `old_max_temp` float(50,2) DEFAULT NULL,
  `old_min_temp_warning` float(50,2) DEFAULT NULL,
  `old_max_temp_warning` float(50,2) DEFAULT NULL,
  `old_min_temp_probe` float(50,2) DEFAULT NULL,
  `old_max_temp_probe` float(50,2) DEFAULT NULL,
  `old_min_temp_warn_prob` float(50,2) DEFAULT NULL,
  `old_max_temp_warn_prob` float(50,2) DEFAULT NULL,
  `old_logging_interval` int(11) DEFAULT NULL,
  `old_sending_interval` int(11) DEFAULT NULL,
  `new_device_name` varchar(200) DEFAULT NULL,
  `new_device_type` varchar(150) DEFAULT NULL,
  `new_min_temp` float(50,2) DEFAULT NULL,
  `new_max_temp` float(50,2) DEFAULT NULL,
  `new_min_temp_warning` float(50,2) DEFAULT NULL,
  `new_max_temp_warning` float(50,2) DEFAULT NULL,
  `new_min_temp_probe` float(50,2) DEFAULT NULL,
  `new_max_temp_probe` float(50,2) DEFAULT NULL,
  `new_min_temp_warn_prob` float(50,2) DEFAULT NULL,
  `new_max_temp_warn_prob` float(50,2) DEFAULT NULL,
  `new_logging_interval` int(11) DEFAULT NULL,
  `new_sending_interval` int(11) DEFAULT NULL,
  `action_type` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_config_audit`
--

INSERT INTO `device_config_audit` (`audit_id`, `device_id`, `old_device_name`, `old_device_type`, `old_min_temp`, `old_max_temp`, `old_min_temp_warning`, `old_max_temp_warning`, `old_min_temp_probe`, `old_max_temp_probe`, `old_min_temp_warn_prob`, `old_max_temp_warn_prob`, `old_logging_interval`, `old_sending_interval`, `new_device_name`, `new_device_type`, `new_min_temp`, `new_max_temp`, `new_min_temp_warning`, `new_max_temp_warning`, `new_min_temp_probe`, `new_max_temp_probe`, `new_min_temp_warn_prob`, `new_max_temp_warn_prob`, `new_logging_interval`, `new_sending_interval`, `action_type`, `updated_by`, `updated_at`) VALUES
(1, 'BA1067', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Single temprature and humidity', 'Alpha', 30.00, 80.00, 20.00, 100.00, 35.00, 75.00, 10.00, 120.00, 1, 1, 'INSERT', 'root@localhost', '2025-11-08 06:41:02'),
(2, 'BA1067', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Single temprature data logger', 'Alpha', 43.00, 43.00, -443.00, 43.00, -43.00, 34.00, 43.00, 43.00, 1, 32, 'INSERT', 'root@localhost', '2025-11-08 07:02:57'),
(3, 'BA1000s', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Single temprature data logger', 'Alpha', 43.00, 433.00, -443.00, 43.00, -43.00, 34.00, 43.00, 43.00, 1, 32, 'INSERT', 'root@localhost', '2025-11-08 07:04:12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `device_config`
--
ALTER TABLE `device_config`
  ADD PRIMARY KEY (`sr_no`);

--
-- Indexes for table `device_config_audit`
--
ALTER TABLE `device_config_audit`
  ADD PRIMARY KEY (`audit_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `device_config`
--
ALTER TABLE `device_config`
  MODIFY `sr_no` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `device_config_audit`
--
ALTER TABLE `device_config_audit`
  MODIFY `audit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
