CREATE DATABASE IF NOT EXISTS `test_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `test_db`;

-- 1. 기존 users 테이블 (제공해주신 내용 유지)
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- 기존 데이터 입력
LOCK TABLES `users` WRITE;
INSERT INTO `users` VALUES (1,'Admin','admin','21232f297a57a5a743894a0e4a801fc3',1),(2,'11','11','6512bd43d9caa6e02c990b0a82652dca',11);
UNLOCK TABLES;

-- 2. 새롭게 추가된 세션 관리 테이블
-- 유효한 세션인지 DB에서 한 번 더 검증하기 위해 사용합니다.
DROP TABLE IF EXISTS `user_sessions`;
CREATE TABLE `user_sessions` (
  `session_id` varchar(255) NOT NULL, -- PHP의 session_id() 값
  `user_id` int NOT NULL,             -- users 테이블의 id
  `ip_address` varchar(45) DEFAULT NULL,
  `login_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;