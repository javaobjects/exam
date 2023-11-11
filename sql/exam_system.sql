/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 50639
 Source Host           : localhost:3306
 Source Schema         : exam_system

 Target Server Type    : MySQL
 Target Server Version : 50639
 File Encoding         : 65001

 Date: 02/11/2022 22:57:44
*/

drop database if exists exam_system;
create database exam_system charset utf8;
use exam_system;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for answer
-- ----------------------------
DROP TABLE IF EXISTS `answer`;
CREATE TABLE `answer` (
  `id` int(50) NOT NULL AUTO_INCREMENT COMMENT '答案表的主键',
  `all_option` longtext COMMENT '当前题目所有答案的信息',
  `images` longtext COMMENT '答案的图片路径',
  `analysis` longtext COMMENT '答案解析',
  `question_id` int(50) NOT NULL COMMENT '对应题目的id',
  `true_option` varchar(25) DEFAULT NULL COMMENT '正确的选项对应的下标',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of answer
-- ----------------------------
BEGIN;
INSERT INTO `answer` VALUES (1, '1,2', '', '1', 5, '0');
INSERT INTO `answer` VALUES (3, '语文,数学,英语,选修课', ',', NULL, 6, '0,1,2');
INSERT INTO `answer` VALUES (10, '0,1', '', '111', 11, '0');
INSERT INTO `answer` VALUES (11, '11,16', '', '16', 12, '1');
INSERT INTO `answer` VALUES (12, '9,8', '', '9', 13, '0');
INSERT INTO `answer` VALUES (13, '4,3', '', '4', 14, '0');
INSERT INTO `answer` VALUES (14, '18,11', '', '18', 15, '0');
INSERT INTO `answer` VALUES (15, '1', '', '1', 16, '0');
INSERT INTO `answer` VALUES (16, '4,3', '', '4', 17, '0');
INSERT INTO `answer` VALUES (17, '1,2,3,4', '', NULL, 18, '0,1');
INSERT INTO `answer` VALUES (18, '奇数,偶数', '', '奇数', 19, '0');
INSERT INTO `answer` VALUES (19, '奇数,偶数', '', '奇数', 20, '0');
INSERT INTO `answer` VALUES (20, '111,222,333', '', NULL, 21, '0,1,2');
INSERT INTO `answer` VALUES (21, '选项1,选项2,选项3,选项4', '', '22', 22, '1');
INSERT INTO `answer` VALUES (22, '选项1,选项2,选项3,选项4', '', NULL, 23, '0,2');
INSERT INTO `answer` VALUES (23, '题目23', '', '11', 24, '0');
INSERT INTO `answer` VALUES (24, '题目24', '', NULL, 25, '0');
COMMIT;

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam` (
  `exam_id` int(50) NOT NULL AUTO_INCREMENT,
  `exam_name` varchar(100) NOT NULL COMMENT '考试名称',
  `exam_desc` varchar(100) DEFAULT NULL COMMENT '考试描述',
  `type` int(15) NOT NULL DEFAULT '1' COMMENT '1完全公开  2需要密码',
  `password` varchar(50) DEFAULT NULL COMMENT '需要密码考试的密码',
  `duration` int(50) NOT NULL COMMENT '考试时长',
  `start_time` date DEFAULT NULL COMMENT '考试开始时间',
  `end_time` date DEFAULT NULL COMMENT '考试结束时间',
  `total_score` int(30) NOT NULL COMMENT '考试总分',
  `pass_score` int(30) NOT NULL COMMENT '考试通过线',
  `status` int(15) NOT NULL DEFAULT '1' COMMENT '1有效 2无效',
  PRIMARY KEY (`exam_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of exam
-- ----------------------------
BEGIN;
INSERT INTO `exam` VALUES (9, '考试1', '考试1', 1, NULL, 120, NULL, NULL, 100, 60, 1);
INSERT INTO `exam` VALUES (10, '考试2', '考试2', 1, NULL, 90, NULL, NULL, 100, 60, 1);
INSERT INTO `exam` VALUES (11, '考试3', '考试3', 2, '123', 90, NULL, NULL, 100, 60, 1);
INSERT INTO `exam` VALUES (12, '考试4', '考试4', 1, NULL, 120, NULL, NULL, 100, 60, 1);
INSERT INTO `exam` VALUES (13, '考试5', '考试5', 1, NULL, 120, '2022-11-02', '2022-11-02', 100, 60, 1);
INSERT INTO `exam` VALUES (14, '考试6', '考试6', 1, NULL, 120, '2022-11-02', '2022-11-02', 100, 60, 1);
COMMIT;

-- ----------------------------
-- Table structure for exam_question
-- ----------------------------
DROP TABLE IF EXISTS `exam_question`;
CREATE TABLE `exam_question` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `question_ids` varchar(100) NOT NULL COMMENT '考试的题目id列表',
  `exam_id` int(50) NOT NULL COMMENT '考试的id',
  `scores` varchar(100) NOT NULL COMMENT '每一题的分数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of exam_question
-- ----------------------------
BEGIN;
INSERT INTO `exam_question` VALUES (5, '3,11,19,12,15,14,8,6,13,18', 9, '10,10,10,10,10,10,10,10,10,10');
INSERT INTO `exam_question` VALUES (6, '18,6,3,8', 10, '20,20,30,30');
INSERT INTO `exam_question` VALUES (7, '3,8,26,12', 11, '30,30,30,10');
INSERT INTO `exam_question` VALUES (8, '6,12,15,13,14,19,8,18,20,11', 12, '10,10,10,10,10,10,10,10,10,10');
INSERT INTO `exam_question` VALUES (9, '19,18,15,3,8', 13, '10,20,10,30,30');
INSERT INTO `exam_question` VALUES (10, '11,12,13,14,15,6,18,19,20,3', 14, '10,10,10,10,10,10,10,5,5,20');
COMMIT;

-- ----------------------------
-- Table structure for exam_record
-- ----------------------------
DROP TABLE IF EXISTS `exam_record`;
CREATE TABLE `exam_record` (
  `record_id` int(50) NOT NULL AUTO_INCREMENT COMMENT '考试记录的id',
  `user_id` int(50) NOT NULL COMMENT '考试用户的id',
  `user_answers` longtext NOT NULL COMMENT '用户的答案列表',
  `credit_img_url` longtext COMMENT '考试诚信截图',
  `exam_id` int(50) NOT NULL COMMENT '考试的id',
  `logic_score` int(50) DEFAULT NULL COMMENT '考试的逻辑得分(除简答)',
  `exam_time` datetime NOT NULL COMMENT '考试时间',
  `question_ids` varchar(150) NOT NULL COMMENT '考试的题目信息',
  `total_score` int(50) DEFAULT NULL COMMENT '考试总分数 (逻辑+简答)',
  `error_question_ids` varchar(50) DEFAULT NULL COMMENT '用户考试的错题',
  PRIMARY KEY (`record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of exam_record
-- ----------------------------
BEGIN;
INSERT INTO `exam_record` VALUES (1, 2, '0-0-1-1-1-1,2-1,2,3-0-aaaaa-bbbb', '', 9, 20, '2022-11-02 22:21:38', '11,12,15,14,13,6,18,19,3,8', 40, '12,15,14,13,6,18');
INSERT INTO `exam_record` VALUES (2, 2, '1-解析1-解析3-解析25', '', 11, 10, '2022-11-02 19:52:06', '12,3,8,26', 100, NULL);
INSERT INTO `exam_record` VALUES (3, 8, '0-0-0-0-0-0,1,2-0,2-0-解析1-解析3', '', 9, 60, '2022-11-02 20:25:59', '14,15,11,12,13,6,18,19,3,8', 75, '12,18');
INSERT INTO `exam_record` VALUES (4, 8, '0-0-0-0-0,1,2-0,3-0-0-解析3', '', 12, 60, '2022-11-02 20:27:59', '12,14,11,15,6,18,20,19,8', 70, '12,18');
INSERT INTO `exam_record` VALUES (5, 2, '1-0-0', '', 12, 10, '2022-11-02 22:45:44', '11,6,19', NULL, '11,6');
INSERT INTO `exam_record` VALUES (6, 2, '0-0-0-0-0-0-0-0-aaaa', '', 12, 60, '2022-11-02 22:47:43', '15,13,14,11,6,18,19,20,8', 70, '6,18');
COMMIT;

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `qu_content` longtext NOT NULL COMMENT '问题内容',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_person` varchar(50) NOT NULL COMMENT '创建人',
  `qu_type` int(10) NOT NULL COMMENT '问题类型 1单选 2多选 3判断 4简答',
  `level` int(10) NOT NULL DEFAULT '1' COMMENT '题目难度 1简单 2中等 3困难',
  `image` longtext COMMENT '图片',
  `qu_bank_id` varchar(40) NOT NULL COMMENT '所属题库id',
  `qu_bank_name` varchar(255) NOT NULL COMMENT '所属题库名称',
  `analysis` varchar(255) DEFAULT NULL COMMENT '解析',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of question
-- ----------------------------
BEGIN;
INSERT INTO `question` VALUES (3, '题目1', '2022-11-02 21:17:19', 'admin', 4, 2, NULL, '1,2,5', '程序设计,数据结构,算法分析', '解析1');
INSERT INTO `question` VALUES (6, '题目2', '2022-11-02 10:11:28', 'admin', 2, 1, NULL, '1,5', '程序设计,算法分析', '解析2');
INSERT INTO `question` VALUES (8, '题目3', '2022-11-02 21:17:30', 'admin', 4, 3, NULL, '1,5', '程序设计,算法分析', '解析3');
INSERT INTO `question` VALUES (11, '题目4', '2022-11-02 21:12:52', 'admin', 1, 1, NULL, '5,2', '算法分析,数据结构', '解析4');
INSERT INTO `question` VALUES (12, '题目5', '2022-11-02 15:32:44', 'admin', 1, 3, NULL, '1,5', '程序设计,算法分析', '解析5');
INSERT INTO `question` VALUES (13, '题目6', '2022-11-02 15:13:38', 'admin', 1, 1, NULL, '1,5', '程序设计,算法分析', '解析6');
INSERT INTO `question` VALUES (14, '题目7', '2022-11-02 16:17:09', 'admin', 1, 1, '', '1,5', '程序设计,算法分析', '解析7');
INSERT INTO `question` VALUES (15, '题目8', '2022-11-02 15:53:14', 'admin', 1, 1, '', '1,5', '程序设计,算法分析', '解析8');
INSERT INTO `question` VALUES (18, '题目9', '2022-11-02 10:09:13', 'admin', 2, 2, NULL, '1', '程序设计', '解析9');
INSERT INTO `question` VALUES (19, '题目10', '2022-11-02 14:54:09', 'admin', 3, 1, NULL, '1', '程序设计', '解析10');
INSERT INTO `question` VALUES (20, '题目11', '2022-11-02 20:26:49', 'admin', 3, 1, NULL, '1', '程序设计', '解析11');
INSERT INTO `question` VALUES (21, '题目12', '2022-11-02 14:42:56', 'admin', 2, 1, NULL, '1,2', '程序设计,数据结构', '解析12');
INSERT INTO `question` VALUES (22, '题目21', '2022-11-02 21:48:38', 'admin', 1, 1, NULL, '2', '数据结构', '解析21');
INSERT INTO `question` VALUES (23, '题目22', '2022-11-02 21:50:18', 'tom', 2, 1, NULL, '1,5', '程序设计,算法分析', '解析22');
INSERT INTO `question` VALUES (24, '题目23', '2022-11-02 21:52:32', 'tom', 3, 1, NULL, '2', '数据结构', '解析23');
INSERT INTO `question` VALUES (25, '题目24', '2022-11-02 21:54:06', 'tom', 2, 1, NULL, '5', '算法分析', '解析24');
INSERT INTO `question` VALUES (26, '题目25', '2022-11-02 19:45:33', 'admin', 4, 2, NULL, '2,5,1', '数据结构,算法分析,程序设计', '解析25');
COMMIT;

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank` (
  `bank_id` int(40) NOT NULL AUTO_INCREMENT,
  `bank_name` varchar(100) NOT NULL,
  PRIMARY KEY (`bank_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of question_bank
-- ----------------------------
BEGIN;
INSERT INTO `question_bank` VALUES (1, '程序设计');
INSERT INTO `question_bank` VALUES (2, '数据结构');
INSERT INTO `question_bank` VALUES (5, '算法分析');
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `role_id` int(10) NOT NULL DEFAULT '1' COMMENT '1(学生) 2(教师) 3(管理员)',
  `username` varchar(100) NOT NULL,
  `true_name` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `salt` varchar(30) NOT NULL,
  `status` int(10) NOT NULL DEFAULT '1' COMMENT '用户是否被禁用 1正常 2禁用',
  `create_date` datetime NOT NULL COMMENT '用户创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` VALUES (1, 3, 'admin', '管理员', '9499273223c7aca5949e3055eaa57f6f', 'c667d6', 1, '2022-11-02 15:05:15');
INSERT INTO `user` VALUES (2, 1, 'zhangsan', '张三', '9499273223c7aca5949e3055eaa57f6f', 'c667d6', 1, '2022-11-02 10:46:25');
INSERT INTO `user` VALUES (3, 2, 'tom', '汤姆', '9499273223c7aca5949e3055eaa57f6f', 'c667d6', 1, '2022-11-02 11:10:12');
INSERT INTO `user` VALUES (4, 1, 'zhaoliu', '赵六', '98d4fa4da534339cbed32b62d7b246c7', 'ccb14b', 1, '2022-11-02 18:13:20');
INSERT INTO `user` VALUES (5, 1, 'mc', '马冲', '2a2176cb62f5a62d396dbb2bdeed294c', '605d1c', 1, '2022-11-02 15:51:51');
INSERT INTO `user` VALUES (6, 1, 'amao', '阿毛', '41b8d2eff6cd26fc425be6ab343de397', '8e2880', 2, '2022-11-02 15:52:30');
INSERT INTO `user` VALUES (8, 1, 'lisi', '李四', '6d0e86b7df3040a3de6b7dce73a7d818', '8097b9', 1, '2022-11-02 15:54:48');
INSERT INTO `user` VALUES (9, 1, 'wangwu', '王五', '4ba6f54cc49fac7afc907b0b5fbfd7ac', 'c6ce5f', 1, '2022-11-02 15:55:04');
INSERT INTO `user` VALUES (10, 1, 'qiaoqi', '乔七', '62e9ce36958d0ee247a145d29caab889', '9a9d8c', 1, '2022-11-02 15:55:25');
INSERT INTO `user` VALUES (11, 1, 'pgl', '陈八', 'f7dcc6093292b30c698ec73bca37a7a4', 'd6da4b', 1, '2022-11-02 15:55:52');
INSERT INTO `user` VALUES (12, 1, 'wjh', '孙九', 'c94de75b9de1b60e2c5261dfade215f2', '33641a', 1, '2022-11-02 09:54:55');
INSERT INTO `user` VALUES (13, 3, 'll', '丽丽', '0b600b5d50de0f1207a2a045bc22debf', '0824f0', 1, '2022-11-02 10:02:09');
COMMIT;

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int(10) NOT NULL,
  `role_id` int(10) NOT NULL DEFAULT '1' COMMENT '1学生 2教师 3超级管理员',
  `role_name` varchar(15) NOT NULL,
  `menu_info` longtext NOT NULL COMMENT '主页的菜单信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of user_role
-- ----------------------------
BEGIN;
INSERT INTO `user_role` VALUES (1, 1, '学生', '[{\"topMenuName\":\"系统介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"在线考试\",\"topIcon\":\"el-icon-menu\",\"submenu\":[{\"name\":\"在线考试\",\"icon\":\"el-icon-s-promotion\",\"url\":\"/examOnline\"},{\"name\":\"我的成绩\",\"icon\":\"el-icon-trophy\",\"url\":\"/myGrade\"},{\"name\":\"我的题库\",\"icon\":\"el-icon-notebook-2\",\"url\":\"/myQuestionBank\"}]}]');
INSERT INTO `user_role` VALUES (2, 2, '老师', '[{\"topMenuName\":\"系统介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"考试管理\",\"topIcon\":\"el-icon-bangzhu\",\"submenu\":[{\"name\":\"题库管理\",\"icon\":\"el-icon-aim\",\"url\":\"/questionBankMange\"},{\"name\":\"试题管理\",\"icon\":\"el-icon-news\",\"url\":\"/questionManage\"},{\"name\":\"考试管理\",\"icon\":\"el-icon-tickets\",\"url\":\"/examManage\"},{\"name\":\"阅卷管理\",\"icon\":\"el-icon-view\",\"url\":\"/markManage\"}]},{\"topMenuName\":\"考试统计\",\"topIcon\":\"el-icon-pie-chart\",\"submenu\":[{\"name\":\"统计总览\",\"icon\":\"el-icon-data-line\",\"url\":\"/staticOverview\"}]}]');
INSERT INTO `user_role` VALUES (3, 3, '超级管理员', '[{\"topMenuName\":\"系统介绍\",\"topIcon\":\"el-icon-odometer\",\"url\":\"/dashboard\"},{\"topMenuName\":\"考试管理\",\"topIcon\":\"el-icon-bangzhu\",\"submenu\":[{\"name\":\"题库管理\",\"icon\":\"el-icon-aim\",\"url\":\"/questionBankMange\"},{\"name\":\"试题管理\",\"icon\":\"el-icon-news\",\"url\":\"/questionManage\"},{\"name\":\"考试管理\",\"icon\":\"el-icon-tickets\",\"url\":\"/examManage\"},{\"name\":\"阅卷管理\",\"icon\":\"el-icon-view\",\"url\":\"/markManage\"}]},{\"topMenuName\":\"考试统计\",\"topIcon\":\"el-icon-pie-chart\",\"submenu\":[{\"name\":\"统计总览\",\"icon\":\"el-icon-data-line\",\"url\":\"/staticOverview\"}]},{\"topMenuName\":\"系统设置\",\"topIcon\":\"el-icon-setting\",\"submenu\":[{\"name\":\"角色管理\",\"icon\":\"el-icon-s-custom\",\"url\":\"/roleManage\"},{\"name\":\"用户管理\",\"icon\":\"el-icon-user-solid\",\"url\":\"/userManage\"}]}]');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
