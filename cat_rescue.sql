-- MySQL dump 10.13  Distrib 9.3.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: cat_rescue
-- ------------------------------------------------------
-- Server version	9.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adoption_application`
--

DROP TABLE IF EXISTS `adoption_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `adoption_application` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ç”³è¯·ID',
  `cat_id` bigint NOT NULL COMMENT 'çŒ«å’ªID',
  `user_id` bigint NOT NULL COMMENT 'ç”³è¯·äººID',
  `reason` text COLLATE utf8mb4_unicode_ci COMMENT 'é¢†å…»ç†ç”±',
  `living_condition` text COLLATE utf8mb4_unicode_ci COMMENT 'å±…ä½æ¡ä»¶è¯´æ˜Ž',
  `experience` text COLLATE utf8mb4_unicode_ci COMMENT 'å…»çŒ«ç»éªŒ',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»ç”µè¯',
  `contact_address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»åœ°å€',
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING' COMMENT 'ç”³è¯·çŠ¶æ€ï¼šå¾…å®¡æ ¸/é€šè¿‡/æ‹’ç»/å·²å–æ¶ˆ',
  `reject_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ‹’ç»ç†ç”±',
  `review_user_id` bigint DEFAULT NULL COMMENT 'å®¡æ ¸äººID',
  `review_time` datetime DEFAULT NULL COMMENT 'å®¡æ ¸æ—¶é—´',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `review_user_id` (`review_user_id`),
  CONSTRAINT `adoption_application_ibfk_1` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`),
  CONSTRAINT `adoption_application_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `adoption_application_ibfk_3` FOREIGN KEY (`review_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='é¢†å…»ç”³è¯·è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adoption_application`
--

LOCK TABLES `adoption_application` WRITE;
/*!40000 ALTER TABLE `adoption_application` DISABLE KEYS */;
INSERT INTO `adoption_application` VALUES (5,1,4,'我非常喜欢橘猫，家里有足够的空间，承诺会好好照顾它。','独立住房，有阳台，已安装纱窗','之前养过一只猫5年，有丰富经验','13800138003','海淀区学院路小区','PENDING',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-04 15:48:41'),(6,2,6,'看到小黑的照片就被吸引了，希望能给它一个温暖的家。','合租公寓，室友同意养猫','家里养过猫，了解基本护理','13800138005','朝阳区望京SOHO','PENDING',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-04 15:48:41'),(7,5,4,'咪咪太可爱了，希望能领养它陪伴我。','独立住房，封闭阳台','有3年养猫经验','13800138003','海淀区五道口','APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-04 15:48:41'),(8,4,6,'奶牛的花色太好看了，想领养。','独立公寓，有养猫经验','养过2只猫','13800138005','朝阳区三里屯','REJECTED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-04 15:48:41');
/*!40000 ALTER TABLE `adoption_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat`
--

DROP TABLE IF EXISTS `cat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'çŒ«å’ªID',
  `university_id` bigint DEFAULT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'çŒ«å’ªåç§°',
  `breed` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å“ç§',
  `gender` tinyint DEFAULT NULL COMMENT 'æ€§åˆ«ï¼š0-æ¯ 1-å…¬',
  `age` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å¹´é¾„ï¼ˆå¦‚ï¼š2å²/6ä¸ªæœˆï¼‰',
  `color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ¯›è‰²',
  `character` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ€§æ ¼æè¿°',
  `cover_image` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å°é¢å›¾ç‰‡',
  `status` enum('ADOPTABLE','ADOPTED','TREATMENT','OBSERVATION') COLLATE utf8mb4_unicode_ci DEFAULT 'OBSERVATION' COMMENT 'çŠ¶æ€ï¼šå¯é¢†å…»/å·²é¢†å…»/æ²»ç–—ä¸­/è§‚å¯Ÿä¸­',
  `health_status` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å¥åº·çŠ¶å†µ',
  `is_sterilized` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦ç»è‚²ï¼š0-å¦ 1-æ˜¯',
  `is_vaccinated` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦æŽ¥ç§ç–«è‹—ï¼š0-å¦ 1-æ˜¯',
  `rescue_location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ•‘åŠ©åœ°ç‚¹',
  `rescue_date` date DEFAULT NULL COMMENT 'æ•‘åŠ©æ—¥æœŸ',
  `rescue_story` text COLLATE utf8mb4_unicode_ci COMMENT 'æ•‘åŠ©æ•…äº‹',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'è¯¦ç»†æè¿°',
  `view_count` int DEFAULT '0' COMMENT 'æµè§ˆæ¬¡æ•°',
  `like_count` int DEFAULT '0' COMMENT 'å–œæ¬¢æ¬¡æ•°',
  `cloud_adoption_count` int DEFAULT '0',
  `create_user_id` bigint DEFAULT NULL COMMENT 'åˆ›å»ºäººID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `is_deleted` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦åˆ é™¤ï¼š0-å¦ 1-æ˜¯',
  `version` int DEFAULT '0' COMMENT 'ä¹è§‚é”ç‰ˆæœ¬å·',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_name` (`name`),
  KEY `create_user_id` (`create_user_id`),
  CONSTRAINT `cat_ibfk_1` FOREIGN KEY (`create_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='çŒ«å’ªæ¡£æ¡ˆè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat`
--

LOCK TABLES `cat` WRITE;
/*!40000 ALTER TABLE `cat` DISABLE KEYS */;
INSERT INTO `cat` VALUES (1,1,'橘子','中华田园猫',1,'2岁','橘色','亲人、活泼、贪吃','/uploads/cats/cat1.jpg','ADOPTABLE','健康',1,1,'图书馆东侧','2024-03-15','橘子是在图书馆东侧发现的，当时瘦骨嶙峋，经过志愿者们的悉心照料，现在已经是一只健康的大橘猫了。','橘子是一只非常亲人的大橘猫，喜欢被摸，会主动蹭人。已完成绝育和疫苗接种。',165,42,5,3,'2026-01-04 15:48:41','2026-02-01 08:22:22',0,0),(2,1,'小黑','中华田园猫',1,'1岁半','黑色','高冷、独立、聪明','/uploads/cats/cat2.jpg','ADOPTABLE','健康',1,1,'食堂后门','2024-05-20','小黑在食堂后门被发现，是一只非常聪明的猫咪。','小黑虽然看起来高冷，但熟悉后非常粘人。毛色纯黑发亮，眼睛金黄。',100,28,3,3,'2026-01-04 15:48:41','2026-01-04 15:56:12',0,0),(3,1,'花花','中华田园猫',0,'3岁','三花','温柔、安静、胆小','/uploads/cats/cat3.jpg','ADOPTABLE','健康',1,1,'宿舍区绿化带','2024-01-10','花花是在宿舍区绿化带发现的流浪猫妈妈。','花花性格温柔安静，不吵不闹，适合喜欢安静的领养人。',88,35,2,5,'2026-01-04 15:48:41','2026-01-04 16:22:55',0,0),(4,1,'奶牛','中华田园猫',1,'8个月','黑白','活泼、调皮、粘人','/uploads/cats/cat4.jpg','ADOPTABLE','健康',1,1,'操场看台下','2024-08-05','奶牛是在操场看台下发现的小奶猫。','奶牛花色像奶牛一样可爱，性格活泼好动。',134,56,8,3,'2026-01-04 15:48:41','2026-01-04 15:48:41',0,0),(5,1,'咪咪','英短串',0,'2岁','蓝灰色','温顺、乖巧、爱睡觉','/uploads/cats/cat5.jpg','ADOPTED','健康',1,1,'教学楼走廊','2024-02-28','咪咪疑似是被遗弃的家猫，已成功被领养。','咪咪已于2024年9月被爱心人士领养。',203,78,12,5,'2026-01-04 15:48:41','2026-01-04 15:48:41',0,0),(6,1,'小橘','中华田园猫',1,'6个月','橘白','活泼、好奇、亲人','/uploads/cats/cat6.jpg','OBSERVATION','观察中',0,0,'校门口','2024-11-01','小橘是最近在校门口发现的小流浪猫。','小橘正在适应期，等待绝育和疫苗接种后将开放领养。',45,18,0,3,'2026-01-04 15:48:41','2026-01-04 15:48:41',0,0),(7,1,'团团','中华田园猫',0,'4岁','玳瑁','独立、警觉、慢热','/uploads/cats/cat7.jpg','TREATMENT','治疗中-皮肤病',1,1,'实验楼后','2024-10-15','团团被发现时有轻微皮肤病，正在接受治疗。','团团性格独立，需要有耐心的领养人。康复后将开放领养。',32,12,0,5,'2026-01-04 15:48:41','2026-01-04 15:48:41',0,0);
/*!40000 ALTER TABLE `cat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_dynamic`
--

DROP TABLE IF EXISTS `cat_dynamic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_dynamic` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'åŠ¨æ€ID',
  `user_id` bigint NOT NULL COMMENT 'å‘å¸ƒäººID',
  `cat_id` bigint DEFAULT NULL COMMENT 'å…³è”çŒ«å’ªIDï¼ˆå¯é€‰ï¼‰',
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'åŠ¨æ€å†…å®¹',
  `images` json DEFAULT NULL COMMENT 'å›¾ç‰‡åˆ—è¡¨ï¼ˆJSONæ•°ç»„ï¼‰',
  `video_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è§†é¢‘URL',
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'åœ°ç‚¹',
  `type` enum('FEED','PHOTO','UPDATE','OTHER') COLLATE utf8mb4_unicode_ci DEFAULT 'OTHER' COMMENT 'åŠ¨æ€ç±»åž‹ï¼šæŠ•å–‚/ç…§ç‰‡/æ›´æ–°/å…¶ä»–',
  `like_count` int DEFAULT '0' COMMENT 'ç‚¹èµžæ•°',
  `comment_count` int DEFAULT '0' COMMENT 'è¯„è®ºæ•°',
  `is_top` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦ç½®é¡¶ï¼š0-å¦ 1-æ˜¯',
  `is_featured` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦ç²¾åŽï¼š0-å¦ 1-æ˜¯',
  `view_count` int DEFAULT '0' COMMENT 'æµè§ˆæ¬¡æ•°',
  `share_count` int DEFAULT '0' COMMENT 'åˆ†äº«æ¬¡æ•°',
  `audit_status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci DEFAULT 'APPROVED' COMMENT 'å®¡æ ¸çŠ¶æ€ï¼šå¾…å®¡æ ¸/å·²é€šè¿‡/å·²æ‹’ç»',
  `audit_user_id` bigint DEFAULT NULL COMMENT 'å®¡æ ¸äººID',
  `audit_time` datetime DEFAULT NULL COMMENT 'å®¡æ ¸æ—¶é—´',
  `audit_remark` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å®¡æ ¸å¤‡æ³¨',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `is_deleted` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦åˆ é™¤ï¼š0-å¦ 1-æ˜¯',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_create_time` (`create_time`),
  CONSTRAINT `cat_dynamic_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `cat_dynamic_ibfk_2` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ç¤¾åŒºåŠ¨æ€è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_dynamic`
--

LOCK TABLES `cat_dynamic` WRITE;
/*!40000 ALTER TABLE `cat_dynamic` DISABLE KEYS */;
INSERT INTO `cat_dynamic` VALUES (7,3,1,'今天去看望了橘子，它又胖了一圈！希望能尽快找到爱它的主人~','[\"/uploads/dynamic/d1.jpg\"]',NULL,'图书馆东侧','PHOTO',23,5,0,0,10,0,'APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-19 22:53:57',0),(8,5,2,'小黑今天状态很好，毛发越来越亮了。给它拍了一组照片！','[\"/uploads/dynamic/d2.jpg\"]',NULL,'志愿者之家','PHOTO',45,8,0,0,10,0,'APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-19 22:53:57',0),(9,3,NULL,'【投喂日记】今天傍晚在食堂后面投喂了5只流浪猫，天气渐冷，希望它们都能平安过冬。','[\"/uploads/dynamic/d3.jpg\"]',NULL,'食堂后门','FEED',67,12,0,0,10,0,'APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-19 22:53:57',0),(10,4,5,'今天正式领养了咪咪！谢谢志愿者们的付出，我会好好照顾它的！','[\"/uploads/dynamic/dynamic1.jpg\"]',NULL,'新家','UPDATE',89,15,0,0,10,0,'APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-19 22:53:57',0),(11,5,6,'新救助的小橘正在适应环境，已经会用猫砂盆了！','[\"/uploads/dynamic/dynamic2.jpg\"]',NULL,'志愿者之家','UPDATE',34,6,0,0,10,0,'APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-01-19 22:53:57',0),(12,5,7,'团团的皮肤病治疗进展顺利，医生说再治疗两周就能康复了。','[\"/uploads/dynamic/dynamic3.jpg\"]',NULL,'宠物医院','UPDATE',56,9,0,0,16,0,'APPROVED',NULL,NULL,NULL,'2026-01-04 15:48:41','2026-02-01 08:22:22',0);
/*!40000 ALTER TABLE `cat_dynamic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_image`
--

DROP TABLE IF EXISTS `cat_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_image` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'å›¾ç‰‡ID',
  `cat_id` bigint NOT NULL COMMENT 'çŒ«å’ªID',
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'å›¾ç‰‡URL',
  `sort_order` int DEFAULT '0' COMMENT 'æŽ’åº',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_cat_id` (`cat_id`),
  CONSTRAINT `cat_image_ibfk_1` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='çŒ«å’ªå›¾ç‰‡è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_image`
--

LOCK TABLES `cat_image` WRITE;
/*!40000 ALTER TABLE `cat_image` DISABLE KEYS */;
INSERT INTO `cat_image` VALUES (92,1,'/uploads/cats/cat1_1.jpg',1,'2026-01-04 15:48:41'),(93,1,'/uploads/cats/cat1_2.jpg',2,'2026-01-04 15:48:41'),(94,1,'/uploads/cats/cat1_3.jpg',3,'2026-01-04 15:48:41'),(95,2,'/uploads/cats/cat2_1.jpg',1,'2026-01-04 15:48:41'),(96,2,'/uploads/cats/cat2_2.jpg',2,'2026-01-04 15:48:41'),(97,3,'/uploads/cats/cat3_1.jpg',1,'2026-01-04 15:48:41'),(98,3,'/uploads/cats/cat3_2.jpg',2,'2026-01-04 15:48:41'),(99,4,'/uploads/cats/cat4_1.jpg',1,'2026-01-04 15:48:41'),(100,4,'/uploads/cats/cat4_2.jpg',2,'2026-01-04 15:48:41'),(101,4,'/uploads/cats/cat4_3.jpg',3,'2026-01-04 15:48:41'),(102,5,'/uploads/cats/cat5_1.jpg',1,'2026-01-04 15:48:41'),(103,5,'/uploads/cats/cat5_2.jpg',2,'2026-01-04 15:48:41'),(104,6,'/uploads/cats/cat6_1.jpg',1,'2026-01-04 15:48:41'),(105,6,'/uploads/cats/cat6_2.jpg',2,'2026-01-04 15:48:41'),(106,7,'/uploads/cats/cat7_1.jpg',1,'2026-01-04 15:48:41'),(107,7,'/uploads/cats/cat7_2.jpg',2,'2026-01-04 15:48:41');
/*!40000 ALTER TABLE `cat_image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_tag`
--

DROP TABLE IF EXISTS `cat_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_tag` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'æ ‡ç­¾ID',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'æ ‡ç­¾åç§°',
  `type` enum('ACTIVITY','STATUS','CHARACTER','LOCATION','HEALTH','OTHER') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ ‡ç­¾é¢œè‰²',
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å›¾æ ‡',
  `sort_order` int DEFAULT '0',
  `is_active` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='æ ‡ç­¾è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_tag`
--

LOCK TABLES `cat_tag` WRITE;
/*!40000 ALTER TABLE `cat_tag` DISABLE KEYS */;
INSERT INTO `cat_tag` VALUES (1,'å›¾ä¹¦é¦†','LOCATION','#409EFF',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(2,'é£Ÿå ‚','LOCATION','#409EFF',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(3,'å®¿èˆåŒº','LOCATION','#409EFF',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(4,'æ•™å­¦æ¥¼','LOCATION','#409EFF',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(5,'æ“åœº','LOCATION','#409EFF',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(6,'æ ¡é—¨å£','LOCATION','#409EFF',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(7,'äº²äºº','CHARACTER','#67C23A',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(8,'æ´»æ³¼','CHARACTER','#67C23A',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(9,'å®‰é™','CHARACTER','#67C23A',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(10,'èƒ†å°','CHARACTER','#67C23A',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(11,'ç²˜äºº','CHARACTER','#67C23A',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(12,'ç‹¬ç«‹','CHARACTER','#67C23A',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(13,'å¥åº·','HEALTH','#E6A23C',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(14,'å·²ç»è‚²','HEALTH','#E6A23C',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(15,'å·²ç–«è‹—','HEALTH','#E6A23C',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(16,'éœ€æ²»ç–—','HEALTH','#F56C6C',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27'),(17,'ç‰¹æ®Šç…§é¡¾','HEALTH','#F56C6C',NULL,0,1,'2025-10-24 16:40:31','2025-10-24 20:48:27');
/*!40000 ALTER TABLE `cat_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cat_tag_relation`
--

DROP TABLE IF EXISTS `cat_tag_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_tag_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `cat_id` bigint NOT NULL COMMENT 'çŒ«å’ªID',
  `tag_id` bigint NOT NULL COMMENT 'æ ‡ç­¾ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cat_tag` (`cat_id`,`tag_id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_tag_id` (`tag_id`),
  CONSTRAINT `cat_tag_relation_ibfk_1` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cat_tag_relation_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `cat_tag` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='çŒ«å’ªæ ‡ç­¾å…³è”è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cat_tag_relation`
--

LOCK TABLES `cat_tag_relation` WRITE;
/*!40000 ALTER TABLE `cat_tag_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `cat_tag_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cloud_adoption`
--

DROP TABLE IF EXISTS `cloud_adoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cloud_adoption` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'äº‘å…»ID',
  `user_id` bigint NOT NULL COMMENT 'äº‘å…»äººID',
  `cat_id` bigint NOT NULL COMMENT 'çŒ«å’ªID',
  `adoption_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'äº‘å…»åç§°',
  `monthly_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'æ¯æœˆäº‘å…»é‡‘é¢',
  `start_date` date DEFAULT NULL COMMENT 'å¼€å§‹äº‘å…»æ—¥æœŸ',
  `end_date` date DEFAULT NULL COMMENT 'ç»“æŸäº‘å…»æ—¥æœŸ',
  `is_active` tinyint DEFAULT '1' COMMENT 'æ˜¯å¦æ´»è·ƒï¼š0-å¦ 1-æ˜¯',
  `total_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'ç´¯è®¡äº‘å…»é‡‘é¢',
  `message` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'äº‘å…»å¯„è¯­',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_cat` (`user_id`,`cat_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_active` (`is_active`),
  CONSTRAINT `cloud_adoption_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cloud_adoption_ibfk_2` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='äº‘å…»å…³ç³»è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_adoption`
--

LOCK TABLES `cloud_adoption` WRITE;
/*!40000 ALTER TABLE `cloud_adoption` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_adoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'è¯„è®ºID',
  `dynamic_id` bigint NOT NULL COMMENT 'åŠ¨æ€ID',
  `user_id` bigint NOT NULL COMMENT 'è¯„è®ºäººID',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'è¯„è®ºå†…å®¹',
  `parent_id` bigint DEFAULT '0' COMMENT 'çˆ¶è¯„è®ºIDï¼ˆ0è¡¨ç¤ºé¡¶çº§è¯„è®ºï¼‰',
  `reply_to_user_id` bigint DEFAULT NULL COMMENT 'å›žå¤ç›®æ ‡ç”¨æˆ·ID',
  `like_count` int DEFAULT '0' COMMENT 'ç‚¹èµžæ•°',
  `audit_status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci DEFAULT 'APPROVED' COMMENT 'å®¡æ ¸çŠ¶æ€ï¼šå¾…å®¡æ ¸/å·²é€šè¿‡/å·²æ‹’ç»',
  `audit_user_id` bigint DEFAULT NULL COMMENT 'å®¡æ ¸äººID',
  `audit_time` datetime DEFAULT NULL COMMENT 'å®¡æ ¸æ—¶é—´',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `is_deleted` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦åˆ é™¤ï¼š0-å¦ 1-æ˜¯',
  PRIMARY KEY (`id`),
  KEY `idx_dynamic_id` (`dynamic_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `reply_to_user_id` (`reply_to_user_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`dynamic_id`) REFERENCES `cat_dynamic` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`reply_to_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='è¯„è®ºè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crowdfunding`
--

DROP TABLE IF EXISTS `crowdfunding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crowdfunding` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ä¼—ç­¹ID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'é¡¹ç›®æ ‡é¢˜',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'é¡¹ç›®æè¿°',
  `cat_id` bigint DEFAULT NULL COMMENT 'å…³è”çŒ«å’ªIDï¼ˆå¯é€‰ï¼‰',
  `creator_id` bigint NOT NULL COMMENT 'å‘èµ·äººID',
  `target_amount` decimal(10,2) NOT NULL COMMENT 'ç›®æ ‡é‡‘é¢',
  `current_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'å½“å‰é‡‘é¢',
  `start_date` date DEFAULT NULL COMMENT 'å¼€å§‹æ—¥æœŸ',
  `end_date` date DEFAULT NULL COMMENT 'ç»“æŸæ—¥æœŸ',
  `status` enum('DRAFT','ACTIVE','COMPLETED','FAILED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT' COMMENT 'çŠ¶æ€ï¼šè‰ç¨¿/è¿›è¡Œä¸­/å·²å®Œæˆ/å·²å¤±è´¥/å·²å–æ¶ˆ',
  `cover_image` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å°é¢å›¾ç‰‡',
  `image_urls` text COLLATE utf8mb4_unicode_ci COMMENT 'é¡¹ç›®å›¾ç‰‡ï¼ˆJSONæ ¼å¼ï¼‰',
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'é¡¹ç›®åˆ†ç±»',
  `contact_info` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»æ–¹å¼',
  `update_message` text COLLATE utf8mb4_unicode_ci COMMENT 'é¡¹ç›®è¿›å±•æ›´æ–°',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_creator_id` (`creator_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ä¼—ç­¹é¡¹ç›®è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crowdfunding`
--

LOCK TABLES `crowdfunding` WRITE;
/*!40000 ALTER TABLE `crowdfunding` DISABLE KEYS */;
INSERT INTO `crowdfunding` VALUES (1,'团团皮肤病治疗费用','团团正在接受皮肤病治疗，预计需要治疗费用2000元，希望大家能帮助它渡过难关。',7,3,2000.00,1350.00,'2024-10-20','2024-12-20','ACTIVE',NULL,NULL,NULL,NULL,NULL,'2026-01-04 14:48:56','2026-01-19 22:10:35'),(2,'小橘绝育疫苗费用','小橘需要进行绝育手术和疫苗接种，预计费用800元。',6,5,800.00,450.00,'2024-11-15','2024-12-31','ACTIVE',NULL,NULL,NULL,NULL,NULL,'2026-01-04 14:48:56','2026-01-19 22:10:35');
/*!40000 ALTER TABLE `crowdfunding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation`
--

DROP TABLE IF EXISTS `donation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'æèµ ID',
  `user_id` bigint NOT NULL COMMENT 'æèµ äººID',
  `cat_id` bigint DEFAULT NULL COMMENT 'çŒ«å’ªIDï¼ˆå¯é€‰ï¼‰',
  `crowdfunding_id` bigint DEFAULT NULL COMMENT 'ä¼—ç­¹é¡¹ç›®ID',
  `amount` decimal(10,2) NOT NULL COMMENT 'æèµ é‡‘é¢',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ”¯ä»˜æ–¹å¼',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ç¬¬ä¸‰æ–¹äº¤æ˜“å·',
  `status` enum('PENDING','SUCCESS','FAILED','REFUNDED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING' COMMENT 'çŠ¶æ€',
  `message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ç•™è¨€',
  `is_anonymous` tinyint(1) DEFAULT '0' COMMENT 'æ˜¯å¦åŒ¿å',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_crowdfunding_id` (`crowdfunding_id`),
  KEY `idx_status` (`status`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='æèµ è®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation`
--

LOCK TABLES `donation` WRITE;
/*!40000 ALTER TABLE `donation` DISABLE KEYS */;
INSERT INTO `donation` VALUES (1,4,NULL,1,200.00,'WECHAT',NULL,'SUCCESS','团团加油！',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(2,6,NULL,1,100.00,'ALIPAY',NULL,'SUCCESS','希望早日康复',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(3,2,NULL,1,500.00,'WECHAT',NULL,'SUCCESS','支持流浪猫救助',1,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(4,4,NULL,1,300.00,'WECHAT',NULL,'SUCCESS','再捐一点',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(5,6,NULL,1,250.00,'ALIPAY',NULL,'SUCCESS','',0,'2026-01-04 14:48:56','2026-01-19 22:34:09'),(6,4,NULL,2,200.00,'WECHAT',NULL,'SUCCESS','小橘要健康',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(7,2,NULL,2,150.00,'ALIPAY',NULL,'SUCCESS','',0,'2026-01-04 14:48:56','2026-01-19 22:34:09'),(8,6,NULL,2,100.00,'WECHAT',NULL,'SUCCESS','加油',0,'2026-01-04 14:48:56','2026-01-19 22:53:27');
/*!40000 ALTER TABLE `donation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finance`
--

DROP TABLE IF EXISTS `finance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `finance` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL COMMENT 'ç±»åž‹ï¼šINCOME-æ”¶å…¥ EXPENSE-æ”¯å‡º',
  `category` varchar(50) NOT NULL COMMENT 'åˆ†ç±»',
  `amount` decimal(10,2) NOT NULL COMMENT 'é‡‘é¢',
  `description` varchar(500) DEFAULT NULL COMMENT 'æè¿°',
  `related_id` bigint DEFAULT NULL COMMENT 'å…³è”ID',
  `related_type` varchar(50) DEFAULT NULL COMMENT 'å…³è”ç±»åž‹',
  `payment_method` varchar(50) DEFAULT NULL COMMENT 'æ”¯ä»˜æ–¹å¼',
  `transaction_id` varchar(100) DEFAULT NULL COMMENT 'äº¤æ˜“å·',
  `receipt_image` varchar(255) DEFAULT NULL COMMENT 'æ”¶æ®å›¾ç‰‡',
  `approver_id` bigint DEFAULT NULL COMMENT 'å®¡æ‰¹äººID',
  `status` varchar(20) DEFAULT 'PENDING' COMMENT 'çŠ¶æ€',
  `occur_date` date NOT NULL COMMENT 'å‘ç”Ÿæ—¥æœŸ',
  `create_user_id` bigint DEFAULT NULL COMMENT 'åˆ›å»ºäººID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_status` (`status`),
  KEY `idx_occur_date` (`occur_date`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='è´¢åŠ¡è®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `finance`
--

LOCK TABLES `finance` WRITE;
/*!40000 ALTER TABLE `finance` DISABLE KEYS */;
INSERT INTO `finance` VALUES (1,'INCOME','爱心捐赠',500.00,'用户小明爱心捐赠',NULL,'DONATION','微信支付',NULL,NULL,1,'APPROVED','2026-01-15',1,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(2,'INCOME','众筹收入',1350.00,'团团皮肤病治疗众筹收入',NULL,'CROWDFUNDING','支付宝',NULL,NULL,1,'APPROVED','2026-01-13',1,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(3,'INCOME','爱心捐赠',200.00,'匿名爱心捐赠',NULL,'DONATION','微信支付',NULL,NULL,1,'APPROVED','2026-01-11',2,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(4,'INCOME','众筹收入',450.00,'小橘绝育疫苗众筹收入',NULL,'CROWDFUNDING','微信支付',NULL,NULL,1,'APPROVED','2026-01-09',1,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(5,'EXPENSE','医疗费用',800.00,'团团皮肤病治疗费用第一期',NULL,'MEDICAL','银行转账',NULL,NULL,1,'APPROVED','2026-01-07',1,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(6,'EXPENSE','猫粮采购',350.00,'购买猫粮20kg',NULL,'FOOD','支付宝',NULL,NULL,1,'APPROVED','2026-01-05',2,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(7,'EXPENSE','疫苗费用',200.00,'小橘疫苗接种',NULL,'MEDICAL','微信支付',NULL,NULL,1,'APPROVED','2026-01-03',1,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(8,'INCOME','爱心捐赠',100.00,'用户小红爱心捐赠',NULL,'DONATION','微信支付',NULL,NULL,NULL,'PENDING','2026-01-01',3,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(9,'EXPENSE','日常用品',150.00,'购买猫砂、猫窝等用品',NULL,'SUPPLIES','现金',NULL,NULL,1,'APPROVED','2025-12-30',1,'2026-01-17 19:22:04','2026-01-19 22:11:16'),(10,'INCOME','活动收入',300.00,'领养日活动捐款',NULL,'EVENT','现金',NULL,NULL,1,'APPROVED','2025-12-28',1,'2026-01-17 19:22:04','2026-01-19 22:11:16');
/*!40000 ALTER TABLE `finance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `identity_verification`
--

DROP TABLE IF EXISTS `identity_verification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `identity_verification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'è®¤è¯ID',
  `user_id` bigint NOT NULL COMMENT 'ç”¨æˆ·ID',
  `university_id` bigint DEFAULT NULL COMMENT 'é«˜æ ¡ID',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'çœŸå®žå§“å',
  `student_id` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'å­¦å·/å·¥å·',
  `department` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'é™¢ç³»/éƒ¨é—¨',
  `id_card` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'èº«ä»½è¯å·',
  `id_card_front` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'èº«ä»½è¯æ­£é¢ç…§ç‰‡',
  `id_card_back` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'èº«ä»½è¯èƒŒé¢ç…§ç‰‡',
  `student_card` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å­¦ç”Ÿè¯/å·¥ä½œè¯ç…§ç‰‡',
  `verification_type` enum('STUDENT','TEACHER','STAFF') COLLATE utf8mb4_unicode_ci DEFAULT 'STUDENT' COMMENT 'è®¤è¯ç±»åž‹ï¼šå­¦ç”Ÿ/æ•™å¸ˆ/èŒå·¥',
  `status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING' COMMENT 'è®¤è¯çŠ¶æ€ï¼šå¾…å®¡æ ¸/é€šè¿‡/æ‹’ç»',
  `reject_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ‹’ç»ç†ç”±',
  `review_user_id` bigint DEFAULT NULL COMMENT 'å®¡æ ¸äººID',
  `review_time` datetime DEFAULT NULL COMMENT 'å®¡æ ¸æ—¶é—´',
  `expire_time` datetime DEFAULT NULL COMMENT 'è¿‡æœŸæ—¶é—´',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_university` (`user_id`,`university_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_university_id` (`university_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_status` (`status`),
  KEY `review_user_id` (`review_user_id`),
  CONSTRAINT `identity_verification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `identity_verification_ibfk_2` FOREIGN KEY (`university_id`) REFERENCES `university` (`id`),
  CONSTRAINT `identity_verification_ibfk_3` FOREIGN KEY (`review_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='èº«ä»½è®¤è¯è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `identity_verification`
--

LOCK TABLES `identity_verification` WRITE;
/*!40000 ALTER TABLE `identity_verification` DISABLE KEYS */;
/*!40000 ALTER TABLE `identity_verification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `like_record`
--

DROP TABLE IF EXISTS `like_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `like_record` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT 'ç”¨æˆ·ID',
  `target_id` bigint NOT NULL COMMENT 'ç›®æ ‡IDï¼ˆåŠ¨æ€/è¯„è®º/çŒ«å’ªï¼‰',
  `target_type` enum('DYNAMIC','COMMENT','CAT') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ç›®æ ‡ç±»åž‹',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_target` (`user_id`,`target_id`,`target_type`),
  KEY `idx_target` (`target_id`,`target_type`),
  CONSTRAINT `like_record_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ç‚¹èµžè®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `like_record`
--

LOCK TABLES `like_record` WRITE;
/*!40000 ALTER TABLE `like_record` DISABLE KEYS */;
INSERT INTO `like_record` VALUES (1,4,1,'CAT','2025-12-24 20:57:31'),(2,4,2,'CAT','2025-12-24 20:57:31'),(3,4,4,'CAT','2025-12-24 20:57:31'),(4,6,1,'CAT','2025-12-24 20:57:31'),(5,6,3,'CAT','2025-12-24 20:57:31'),(6,6,4,'CAT','2025-12-24 20:57:31'),(7,4,1,'DYNAMIC','2025-12-24 20:57:31'),(8,4,2,'DYNAMIC','2025-12-24 20:57:31'),(9,4,4,'DYNAMIC','2025-12-24 20:57:31'),(10,6,1,'DYNAMIC','2025-12-24 20:57:31'),(11,6,3,'DYNAMIC','2025-12-24 20:57:31'),(12,6,6,'DYNAMIC','2025-12-24 20:57:31'),(13,3,4,'DYNAMIC','2025-12-24 20:57:31'),(14,5,4,'DYNAMIC','2025-12-24 20:57:31');
/*!40000 ALTER TABLE `like_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'é€šçŸ¥ID',
  `user_id` bigint NOT NULL COMMENT 'æŽ¥æ”¶ç”¨æˆ·ID',
  `type` varchar(50) NOT NULL COMMENT 'é€šçŸ¥ç±»åž‹ï¼šSYSTEM-ç³»ç»Ÿé€šçŸ¥ ADOPTION-é¢†å…»é€šçŸ¥ RESCUE-æ•‘åŠ©é€šçŸ¥ COMMENT-è¯„è®ºé€šçŸ¥ LIKE-ç‚¹èµžé€šçŸ¥ DONATION-æèµ é€šçŸ¥',
  `title` varchar(200) NOT NULL COMMENT 'é€šçŸ¥æ ‡é¢˜',
  `content` text COMMENT 'é€šçŸ¥å†…å®¹',
  `related_type` varchar(50) DEFAULT NULL COMMENT 'å…³è”ç±»åž‹ï¼šCAT-çŒ«å’ª ADOPTION-é¢†å…»ç”³è¯· RESCUE-æ•‘åŠ© DYNAMIC-åŠ¨æ€ COMMENT-è¯„è®º',
  `related_id` bigint DEFAULT NULL COMMENT 'å…³è”å¯¹è±¡ID',
  `sender_id` bigint DEFAULT NULL COMMENT 'å‘é€è€…IDï¼ˆç³»ç»Ÿé€šçŸ¥ä¸ºNULLï¼‰',
  `is_read` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'æ˜¯å¦å·²è¯»ï¼š0-æœªè¯» 1-å·²è¯»',
  `read_time` datetime DEFAULT NULL COMMENT 'é˜…è¯»æ—¶é—´',
  `priority` varchar(20) DEFAULT 'NORMAL' COMMENT 'ä¼˜å…ˆçº§ï¼šLOW-ä½Ž NORMAL-æ™®é€š HIGH-é«˜ URGENT-ç´§æ€¥',
  `action_url` varchar(500) DEFAULT NULL COMMENT 'æ“ä½œé“¾æŽ¥',
  `extra_data` json DEFAULT NULL COMMENT 'é¢å¤–æ•°æ®ï¼ˆJSONæ ¼å¼ï¼‰',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'æ˜¯å¦åˆ é™¤ï¼š0-å¦ 1-æ˜¯',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_is_read` (`is_read`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_related` (`related_type`,`related_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='æ¶ˆæ¯é€šçŸ¥è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,4,'ADOPTION','é¢†å…»ç”³è¯·å·²æäº¤','æ‚¨å¯¹çŒ«å’ª\"æ©˜å­\"çš„é¢†å…»ç”³è¯·å·²æäº¤ï¼Œè¯·ç­‰å¾…å®¡æ ¸ã€‚','ADOPTION_APPLICATION',1,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(2,6,'ADOPTION','é¢†å…»ç”³è¯·å·²æäº¤','æ‚¨å¯¹çŒ«å’ª\"å°é»‘\"çš„é¢†å…»ç”³è¯·å·²æäº¤ï¼Œè¯·ç­‰å¾…å®¡æ ¸ã€‚','ADOPTION_APPLICATION',2,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(3,4,'ADOPTION','é¢†å…»ç”³è¯·å·²é€šè¿‡','æ­å–œï¼æ‚¨å¯¹çŒ«å’ª\"å’ªå’ª\"çš„é¢†å…»ç”³è¯·å·²é€šè¿‡å®¡æ ¸ã€‚','ADOPTION_APPLICATION',3,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(4,6,'ADOPTION','é¢†å…»ç”³è¯·æœªé€šè¿‡','å¾ˆæŠ±æ­‰ï¼Œæ‚¨å¯¹çŒ«å’ª\"å¥¶ç‰›\"çš„é¢†å…»ç”³è¯·æœªé€šè¿‡å®¡æ ¸ã€‚','ADOPTION_APPLICATION',4,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(5,3,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"çŽ‹äº”\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',1,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(6,3,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"å­™ä¸ƒ\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',1,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(7,5,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"æŽå››\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',2,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(8,3,'RESCUE','æ•‘åŠ©ä¿¡æ¯å·²å¤„ç†','æ‚¨å‘å¸ƒçš„æ•‘åŠ©ä¿¡æ¯\"å‘çŽ°å—ä¼¤æµæµªçŒ«\"å·²æœ‰å¿—æ„¿è€…å“åº”','RESCUE_INFO',1,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:38:46','2026-01-04 14:38:46',0),(9,4,'ADOPTION','é¢†å…»ç”³è¯·å·²æäº¤','æ‚¨å¯¹çŒ«å’ª\"æ©˜å­\"çš„é¢†å…»ç”³è¯·å·²æäº¤ï¼Œè¯·ç­‰å¾…å®¡æ ¸ã€‚','ADOPTION_APPLICATION',1,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(10,6,'ADOPTION','é¢†å…»ç”³è¯·å·²æäº¤','æ‚¨å¯¹çŒ«å’ª\"å°é»‘\"çš„é¢†å…»ç”³è¯·å·²æäº¤ï¼Œè¯·ç­‰å¾…å®¡æ ¸ã€‚','ADOPTION_APPLICATION',2,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(11,4,'ADOPTION','é¢†å…»ç”³è¯·å·²é€šè¿‡','æ­å–œï¼æ‚¨å¯¹çŒ«å’ª\"å’ªå’ª\"çš„é¢†å…»ç”³è¯·å·²é€šè¿‡å®¡æ ¸ã€‚','ADOPTION_APPLICATION',3,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(12,6,'ADOPTION','é¢†å…»ç”³è¯·æœªé€šè¿‡','å¾ˆæŠ±æ­‰ï¼Œæ‚¨å¯¹çŒ«å’ª\"å¥¶ç‰›\"çš„é¢†å…»ç”³è¯·æœªé€šè¿‡å®¡æ ¸ã€‚','ADOPTION_APPLICATION',4,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(13,3,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"çŽ‹äº”\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',1,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(14,5,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"æŽå››\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',2,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(15,3,'RESCUE','æ•‘åŠ©å“åº”','æ‚¨çš„æ•‘åŠ©ä¿¡æ¯å·²æœ‰å¿—æ„¿è€…å“åº”','RESCUE_INFO',1,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:41:19','2026-01-04 14:41:19',0),(16,4,'ADOPTION','é¢†å…»ç”³è¯·å·²æäº¤','æ‚¨å¯¹çŒ«å’ª\"æ©˜å­\"çš„é¢†å…»ç”³è¯·å·²æäº¤ï¼Œè¯·ç­‰å¾…å®¡æ ¸ã€‚','ADOPTION_APPLICATION',1,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0),(17,6,'ADOPTION','é¢†å…»ç”³è¯·å·²æäº¤','æ‚¨å¯¹çŒ«å’ª\"å°é»‘\"çš„é¢†å…»ç”³è¯·å·²æäº¤ï¼Œè¯·ç­‰å¾…å®¡æ ¸ã€‚','ADOPTION_APPLICATION',2,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0),(18,4,'ADOPTION','é¢†å…»ç”³è¯·å·²é€šè¿‡','æ­å–œï¼æ‚¨å¯¹çŒ«å’ª\"å’ªå’ª\"çš„é¢†å…»ç”³è¯·å·²é€šè¿‡å®¡æ ¸ã€‚','ADOPTION_APPLICATION',3,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0),(19,6,'ADOPTION','é¢†å…»ç”³è¯·æœªé€šè¿‡','å¾ˆæŠ±æ­‰ï¼Œæ‚¨å¯¹çŒ«å’ª\"å¥¶ç‰›\"çš„é¢†å…»ç”³è¯·æœªé€šè¿‡å®¡æ ¸ã€‚','ADOPTION_APPLICATION',4,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0),(20,3,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"çŽ‹äº”\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',1,NULL,0,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0),(21,5,'COMMENT','æ”¶åˆ°æ–°è¯„è®º','ç”¨æˆ·\"æŽå››\"è¯„è®ºäº†æ‚¨çš„åŠ¨æ€','DYNAMIC',2,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0),(22,3,'RESCUE','æ•‘åŠ©å“åº”','æ‚¨çš„æ•‘åŠ©ä¿¡æ¯å·²æœ‰å¿—æ„¿è€…å“åº”','RESCUE_INFO',1,NULL,1,NULL,'NORMAL',NULL,NULL,'2026-01-04 14:45:11','2026-01-04 14:45:11',0);
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_setting`
--

DROP TABLE IF EXISTS `notification_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_setting` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'è®¾ç½®ID',
  `user_id` bigint NOT NULL COMMENT 'ç”¨æˆ·ID',
  `notification_type` varchar(50) NOT NULL COMMENT 'é€šçŸ¥ç±»åž‹',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'æ˜¯å¦å¯ç”¨ï¼š0-ç¦ç”¨ 1-å¯ç”¨',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_type` (`user_id`,`notification_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='é€šçŸ¥è®¾ç½®è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_setting`
--

LOCK TABLES `notification_setting` WRITE;
/*!40000 ALTER TABLE `notification_setting` DISABLE KEYS */;
/*!40000 ALTER TABLE `notification_setting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rescue_info`
--

DROP TABLE IF EXISTS `rescue_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rescue_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'æ•‘åŠ©ä¿¡æ¯ID',
  `user_id` bigint NOT NULL COMMENT 'å‘å¸ƒäººID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'æ ‡é¢˜',
  `type` enum('INJURED','LOST','MATERIAL','EMERGENCY') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ç±»åž‹ï¼šå—ä¼¤/èµ°å¤±/ç‰©èµ„/ç´§æ€¥',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'è¯¦ç»†æè¿°',
  `images` json DEFAULT NULL COMMENT 'å›¾ç‰‡åˆ—è¡¨',
  `location` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'åœ°ç‚¹',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»ç”µè¯',
  `status` enum('PENDING','PROCESSING','RESOLVED','CLOSED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING' COMMENT 'çŠ¶æ€ï¼šå¾…å¤„ç†/å¤„ç†ä¸­/å·²è§£å†³/å·²å…³é—­',
  `priority` tinyint DEFAULT '0' COMMENT 'ä¼˜å…ˆçº§ï¼š0-æ™®é€š 1-ç´§æ€¥',
  `volunteer_id` bigint DEFAULT NULL COMMENT 'å“åº”å¿—æ„¿è€…ID',
  `response_time` datetime DEFAULT NULL COMMENT 'å“åº”æ—¶é—´',
  `resolve_note` text COLLATE utf8mb4_unicode_ci COMMENT 'è§£å†³è¯´æ˜Ž',
  `view_count` int DEFAULT '0' COMMENT 'æµè§ˆæ¬¡æ•°',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `is_deleted` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦åˆ é™¤ï¼š0-å¦ 1-æ˜¯',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_type` (`type`),
  KEY `idx_priority` (`priority`),
  KEY `volunteer_id` (`volunteer_id`),
  CONSTRAINT `rescue_info_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `rescue_info_ibfk_2` FOREIGN KEY (`volunteer_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='æ•‘åŠ©ä¿¡æ¯è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rescue_info`
--

LOCK TABLES `rescue_info` WRITE;
/*!40000 ALTER TABLE `rescue_info` DISABLE KEYS */;
INSERT INTO `rescue_info` VALUES (5,4,'发现受伤流浪猫','INJURED','在图书馆后面发现一只流浪猫，腿部好像受伤了，需要救助。','[\"uploads/rescue/rescue1.jpg\"]','图书馆后面草坪','13800138003','RESOLVED',1,NULL,NULL,NULL,6,'2026-01-04 15:48:41','2026-02-01 08:22:22',0),(6,6,'食堂附近有猫咪需要帮助','INJURED','看到一只猫咪眼睛好像有问题，一直流泪，需要医疗救助。','[\"uploads/rescue/rescue2.jpg\"]','第二食堂门口','13800138005','PROCESSING',1,NULL,NULL,NULL,0,'2026-01-04 15:48:41','2026-01-04 15:48:41',0),(7,4,'宿舍楼下发现小奶猫','LOST','在7号宿舍楼下发现一窝小奶猫，大概4只，需要救助。','[\"uploads/rescue/rescue3.jpg\"]','7号宿舍楼绿化带','13800138003','RESOLVED',0,NULL,NULL,NULL,0,'2026-01-04 15:48:41','2026-01-04 15:48:41',0),(8,6,'需要猫粮物资','MATERIAL','最近救助的猫咪比较多，猫粮消耗很快，急需猫粮物资支援。','[\"uploads/rescue/rescue4.jpg\"]','志愿者活动中心','13800138005','PENDING',0,NULL,NULL,NULL,0,'2026-01-04 15:48:41','2026-01-04 15:48:41',0);
/*!40000 ALTER TABLE `rescue_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_config`
--

DROP TABLE IF EXISTS `system_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'é…ç½®ID',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'é…ç½®é”®',
  `config_value` text COLLATE utf8mb4_unicode_ci COMMENT 'é…ç½®å€¼',
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æè¿°',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ç³»ç»Ÿé…ç½®è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_config`
--

LOCK TABLES `system_config` WRITE;
/*!40000 ALTER TABLE `system_config` DISABLE KEYS */;
INSERT INTO `system_config` VALUES (1,'site_name','æ ¡å›­æµæµªçŒ«æ•‘åŠ©å¹³å°','ç½‘ç«™åç§°','2025-10-24 16:40:31','2025-10-24 16:40:31'),(2,'max_upload_size','10485760','æœ€å¤§ä¸Šä¼ æ–‡ä»¶å¤§å°ï¼ˆå­—èŠ‚ï¼‰','2025-10-24 16:40:31','2025-10-24 16:40:31'),(3,'adoption_review_notify','1','é¢†å…»å®¡æ ¸é€šçŸ¥å¼€å…³ï¼š0-å…³é—­ 1-å¼€å¯','2025-10-24 16:40:31','2025-10-24 16:40:31'),(4,'rescue_notify','1','æ•‘åŠ©ä¿¡æ¯é€šçŸ¥å¼€å…³ï¼š0-å…³é—­ 1-å¼€å¯','2025-10-24 16:40:31','2025-10-24 16:40:31');
/*!40000 ALTER TABLE `system_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `university`
--

DROP TABLE IF EXISTS `university`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `university` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'é«˜æ ¡ID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'é«˜æ ¡åç§°',
  `province` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'çœä»½',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'åŸŽå¸‚',
  `district` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'åŒºåŸŸ',
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è¯¦ç»†åœ°å€',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»ç”µè¯',
  `contact_email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»é‚®ç®±',
  `website` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å®˜æ–¹ç½‘ç«™',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'å­¦æ ¡ç®€ä»‹',
  `logo_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ ¡å¾½URL',
  `status` tinyint DEFAULT '1' COMMENT 'çŠ¶æ€ï¼š0-ç¦ç”¨ 1-å¯ç”¨',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_province` (`province`),
  KEY `idx_city` (`city`),
  KEY `idx_name` (`name`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='é«˜æ ¡ä¿¡æ¯è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `university`
--

LOCK TABLES `university` WRITE;
/*!40000 ALTER TABLE `university` DISABLE KEYS */;
INSERT INTO `university` VALUES (1,'示范大学','北京市','北京市','海淀区','学院路100号','010-12345678',NULL,NULL,'示范大学是一所综合性重点大学',NULL,1,'2025-12-24 20:03:16','2026-01-19 22:57:00');
/*!40000 ALTER TABLE `university` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ç”¨æˆ·ID',
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ç”¨æˆ·å',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'å¯†ç ï¼ˆBCryptåŠ å¯†ï¼‰',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'çœŸå®žå§“å',
  `student_id` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å­¦å·/å·¥å·',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ‰‹æœºå·',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'é‚®ç®±',
  `avatar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å¤´åƒURL',
  `role` enum('USER','VOLUNTEER','ADMIN','SUPER_ADMIN') COLLATE utf8mb4_unicode_ci DEFAULT 'USER' COMMENT 'è§’è‰²',
  `status` tinyint DEFAULT '1' COMMENT 'çŠ¶æ€ï¼š0-ç¦ç”¨ 1-æ­£å¸¸',
  `gender` tinyint DEFAULT NULL COMMENT 'æ€§åˆ«ï¼š0-å¥³ 1-ç”·',
  `college` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å­¦é™¢',
  `introduction` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ä¸ªäººç®€ä»‹',
  `view_count` int DEFAULT '0' COMMENT 'æµè§ˆæ¬¡æ•°',
  `like_count` int DEFAULT '0' COMMENT 'ç‚¹èµžæ•°',
  `last_login_time` datetime DEFAULT NULL COMMENT 'æœ€åŽç™»å½•æ—¶é—´',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `version` int DEFAULT '0' COMMENT 'ä¹è§‚é”ç‰ˆæœ¬å·',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `student_id` (`student_id`),
  KEY `idx_student_id` (`student_id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ç”¨æˆ·è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi','ç³»ç»Ÿç®¡ç†å‘˜',NULL,NULL,NULL,NULL,'SUPER_ADMIN',1,NULL,NULL,NULL,0,0,NULL,'2025-10-24 16:40:31','2026-02-01 08:25:25',26),(2,'zhangsan','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi','å¼ ä¸‰','2021001001','13800138001','zhangsan@edu.cn',NULL,'USER',1,1,'è®¡ç®—æœºå­¦é™¢','å–œæ¬¢å°åŠ¨ç‰©ï¼Œå¸Œæœ›èƒ½é¢†å…»ä¸€åªçŒ«å’ª',0,0,NULL,'2025-12-24 20:02:41','2025-12-24 20:02:41',0),(3,'lisi','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi','æŽå››','2021001002','13800138002','lisi@edu.cn',NULL,'VOLUNTEER',1,0,'æ–‡å­¦é™¢','æ ¡å›­æµæµªçŒ«æ•‘åŠ©å¿—æ„¿è€…ï¼Œå·²å‚ä¸Žæ•‘åŠ©20+åªçŒ«å’ª',0,0,NULL,'2025-12-24 20:02:41','2025-12-24 20:02:41',0),(4,'wangwu','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi','çŽ‹äº”','2021001003','13800138003','wangwu@edu.cn',NULL,'USER',1,1,'ç»æµŽç®¡ç†å­¦é™¢','çŒ«å’ªçˆ±å¥½è€…',0,0,NULL,'2025-12-24 20:02:41','2025-12-24 20:02:41',0),(5,'zhaoliu','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi','èµµå…­','2020002001','13800138004','zhaoliu@edu.cn',NULL,'VOLUNTEER',1,0,'è‰ºæœ¯å­¦é™¢','æ“…é•¿çŒ«å’ªæ‘„å½±ï¼Œè´Ÿè´£çŒ«å’ªæ¡£æ¡ˆæ‹æ‘„',0,0,NULL,'2025-12-24 20:02:41','2025-12-24 20:02:41',0),(6,'sunqi','$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi','å­™ä¸ƒ','2022003001','13800138005','sunqi@edu.cn',NULL,'USER',1,1,'åŒ»å­¦é™¢','æœ‰å…»çŒ«ç»éªŒï¼Œå®¶é‡Œå·²æœ‰ä¸€åªçŒ«',0,0,NULL,'2025-12-24 20:02:41','2025-12-24 20:02:41',0);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'cat_rescue'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-01  8:54:44
