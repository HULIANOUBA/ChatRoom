/*
Navicat MySQL Data Transfer

Source Server         : gg
Source Server Version : 50716
Source Host           : localhost:3306
Source Database       : chat

Target Server Type    : MYSQL
Target Server Version : 50716
File Encoding         : 65001

Date: 2017-09-06 19:14:15
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for c_user
-- ----------------------------
DROP TABLE IF EXISTS `c_user`;
CREATE TABLE `c_user` (
  `u_id` int(11) NOT NULL AUTO_INCREMENT,
  `u_name` varchar(255) NOT NULL,
  `u_password` varchar(255) NOT NULL,
  `u_sex` varchar(255) NOT NULL,
  `u_avatarurl` varchar(255) NOT NULL,
  `u_oldname` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`u_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of c_user
-- ----------------------------
INSERT INTO `c_user` VALUES ('1', 'gg', '123', 'male', 'http://192.168.1.164:8080/uploadPic/avatar/1502978856611.jpg', 'ggg');
INSERT INTO `c_user` VALUES ('2', 'mm', '123', 'female', 'http://192.168.1.164:8080/uploadPic/avatar/1503029492686.jpg', 'mm');
INSERT INTO `c_user` VALUES ('3', 'hulian', '123', 'male', 'http://192.168.1.164:8080/ChatRoom/uploadPic/avatar/1504696346109.jpeg', 'hulian');
INSERT INTO `c_user` VALUES ('4', '互联', '123', 'male', 'http://192.168.1.164:8080/uploadPic/avatar/male.jpg', '互联');
