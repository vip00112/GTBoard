/*
Navicat MySQL Data Transfer

Source Server         : MySQL
Source Server Version : 50535
Source Host           : localhost:3306
Source Database       : gtboard
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `agreement`
-- ----------------------------
DROP TABLE IF EXISTS `agreement`;
CREATE TABLE `agreement` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of agreement
-- ----------------------------

-- ----------------------------
-- Table structure for `attachfiles`
-- ----------------------------
DROP TABLE IF EXISTS `attachfiles`;
CREATE TABLE `attachfiles` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `boardNo` int(10) NOT NULL,
  `name` text NOT NULL,
  `size` int(10) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `newName` text NOT NULL,
  `fullPath` text NOT NULL,
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of attachfiles
-- ----------------------------

-- ----------------------------
-- Table structure for `boards`
-- ----------------------------
DROP TABLE IF EXISTS `boards`;
CREATE TABLE `boards` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `typeNo` int(10) NOT NULL,
  `userNo` int(10) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `ip` varchar(255) NOT NULL,
  `commentCount` int(10) DEFAULT '0',
  `hit` int(10) DEFAULT '0',
  `thumb` int(10) DEFAULT '0',
  `groupName` varchar(10) DEFAULT 'normal',
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lastUpdate` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`no`),
  KEY `boards_fk_userNo` (`userNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of boards
-- ----------------------------

-- ----------------------------
-- Table structure for `comments`
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `boardNo` int(10) NOT NULL,
  `userNo` int(10) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `ip` varchar(255) NOT NULL,
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comments
-- ----------------------------

-- ----------------------------
-- Table structure for `download_log`
-- ----------------------------
DROP TABLE IF EXISTS `download_log`;
CREATE TABLE `download_log` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `userNo` int(10) NOT NULL,
  `fileNo` int(10) NOT NULL,
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of download_log
-- ----------------------------

-- ----------------------------
-- Table structure for `notice`
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `userNo` int(10) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  `title` text NOT NULL,
  `content` text NOT NULL,
  `hit` int(10) DEFAULT '0',
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of notice
-- ----------------------------

-- ----------------------------
-- Table structure for `point_history`
-- ----------------------------
DROP TABLE IF EXISTS `point_history`;
CREATE TABLE `point_history` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `userNo` int(10) NOT NULL,
  `type` char(1) NOT NULL,
  `point` int(10) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of point_history
-- ----------------------------

-- ----------------------------
-- Table structure for `thumbs`
-- ----------------------------
DROP TABLE IF EXISTS `thumbs`;
CREATE TABLE `thumbs` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `boardNo` int(10) NOT NULL,
  `userNo` int(10) NOT NULL,
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of thumbs
-- ----------------------------

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `no` int(10) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  `isActive` tinyint(1) DEFAULT '0',
  `grade` int(3) DEFAULT '1',
  `point` int(10) DEFAULT '0',
  `regdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`no`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users
-- ----------------------------
