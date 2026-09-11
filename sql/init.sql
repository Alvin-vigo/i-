-- ============================================
-- i谦之家 - 薛之谦粉丝网站数据库设计
-- 创建数据库和核心表
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS xuezhiqian_fans DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE xuezhiqian_fans;

-- ============================================
-- 1. 用户表 (user)
-- ============================================
CREATE TABLE IF NOT EXISTS `user` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码（建议加密存储）',
    `phone` VARCHAR(20) COMMENT '手机号',
    `email` VARCHAR(100) COMMENT '邮箱',
    `avatar` VARCHAR(255) DEFAULT '/images/default-avatar.png' COMMENT '头像路径',
    `role` TINYINT DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-正常',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 插入管理员账号
INSERT INTO `user` (`username`, `password`, `phone`, `role`, `status`) VALUES 
('admin', '123456', '13800138000', 1, 1),
('谦友小明', '123456', '13900139000', 0, 1),
('演唱会狂热粉', '123456', '13700137000', 0, 1);

-- ============================================
-- 2. 作品表 (works)
-- ============================================
CREATE TABLE IF NOT EXISTS `works` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '作品ID',
    `type` VARCHAR(20) NOT NULL COMMENT '类型：song-歌曲，album-专辑，variety-综艺，movie-影视',
    `name` VARCHAR(100) NOT NULL COMMENT '作品名称',
    `cover` VARCHAR(255) COMMENT '封面图路径',
    `description` TEXT COMMENT '作品简介',
    `lyrics` TEXT COMMENT '歌词（歌曲类型适用）',
    `release_date` DATE COMMENT '发布日期',
    `duration` VARCHAR(20) COMMENT '时长',
    `play_count` INT DEFAULT 0 COMMENT '播放/收听次数',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-下架，1-上架',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='作品表';

-- 插入示例作品数据
INSERT INTO `works` (`type`, `name`, `cover`, `description`, `lyrics`, `release_date`, `duration`, `play_count`) VALUES 
('song', '演员', '/images/works/yanyi.jpg', '《演员》是薛之谦创作并演唱的歌曲，收录于2015年发行的同名专辑《绅士》。这首歌曲以细腻的情感和独特的嗓音打动了无数听众。', '简单点，说话的方式简单点\n递进的情绪请省略\n你又不是个演员\n别设计那些情节...', '2015-06-05', '4:32', 98765432),
('song', '绅士', '/images/works/shenshi.jpg', '《绅士》是薛之谦的代表作之一，讲述了爱情中克制与成全的故事。', '好久没见了\n什么角色呢\n细心装扮着...', '2015-06-05', '4:18', 87654321),
('song', '认真的雪', '/images/works/renzhendexue.jpg', '《认真的雪》是薛之谦早期代表作，发行于2006年，是其成名曲之一。', '雪下得那么深\n下得那么认真\n倒映出我躺在雪中的伤痕...', '2006-06-09', '4:25', 76543210),
('song', '刚刚好', '/images/works/gangganghao.jpg', '《刚刚好》收录于2016年发行的专辑《初学者》，展现了薛之谦对爱情的独特诠释。', '我们的爱情\n到这刚刚好\n剩不多也不少...', '2016-07-18', '4:05', 65432109),
('song', '像风一样', '/images/works/xiangfengyiyang.jpg', '《像风一样》是一首治愈系歌曲，传递自由与希望。', '像风一样自由\n像风一样流浪...', '2017-11-28', '3:58', 54321098),
('album', '绅士', '/images/works/album_shenshi.jpg', '《绅士》是薛之谦2015年发行的专辑，收录10首歌曲，包括《演员》《绅士》等热门单曲。', NULL, '2015-06-05', '45:00', 12345678),
('album', '初学者', '/images/works/album_chuxuezhe.jpg', '《初学者》是薛之谦2016年发行的专辑，标志着其音乐风格的成熟。', NULL, '2016-07-18', '48:00', 11234567),
('variety', '我是歌手', '/images/works/variety_singer.jpg', '薛之谦参加《我是歌手》第五季竞演，带来多首精彩演绎。', NULL, '2017-01-21', NULL, 8765432),
('variety', '火星情报局', '/images/works/variety_mars.jpg', '薛之谦作为常驻嘉宾参与《火星情报局》，展现幽默搞笑的一面。', NULL, '2016-04-15', NULL, 7654321),
('movie', '从你的全世界路过', '/images/works/movie_1.jpg', '薛之谦为电影《从你的全世界路过》演唱主题曲《我好像在哪见过你》。', NULL, '2016-09-29', '2:03:00', 5432109);

-- ============================================
-- 3. 留言表 (message)
-- ============================================
CREATE TABLE IF NOT EXISTS `message` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '留言ID',
    `user_id` INT NOT NULL COMMENT '用户ID',
    `content` TEXT NOT NULL COMMENT '留言内容',
    `parent_id` INT DEFAULT NULL COMMENT '父留言ID（回复时使用）',
    `like_count` INT DEFAULT 0 COMMENT '点赞数',
    `is_violation` TINYINT DEFAULT 0 COMMENT '是否违规：0-正常，1-违规',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-删除，1-正常',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='留言表';

-- 插入示例留言
INSERT INTO `message` (`user_id`, `content`, `like_count`) VALUES 
(2, '薛之谦的歌真的太好听了，每一首都能唱到心坎里！', 128),
(3, '刚刚听完演唱会回来，嗓子都喊哑了，但是超值！', 256),
(2, '新歌期待中，谦谦加油！', 64),
(3, '《演员》这首歌陪伴我度过了最艰难的日子，感谢谦谦。', 512);

-- ============================================
-- 4. 点赞记录表 (message_like)
-- ============================================
CREATE TABLE IF NOT EXISTS `message_like` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    `user_id` INT NOT NULL COMMENT '用户ID',
    `message_id` INT NOT NULL COMMENT '留言ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
    UNIQUE KEY `uk_user_message` (`user_id`, `message_id`),
    FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`message_id`) REFERENCES `message`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='点赞记录表';

-- ============================================
-- 5. 歌手信息表 (singer_info) - 存储薛之谦资料
-- ============================================
CREATE TABLE IF NOT EXISTS `singer_info` (
    `id` INT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    `name` VARCHAR(50) NOT NULL COMMENT '艺名',
    `real_name` VARCHAR(50) COMMENT '本名',
    `birthday` DATE COMMENT '生日',
    `birthplace` VARCHAR(100) COMMENT '籍贯',
    `constellation` VARCHAR(20) COMMENT '星座',
    `height` VARCHAR(10) COMMENT '身高',
    `blood_type` VARCHAR(5) COMMENT '血型',
    `debut_date` DATE COMMENT '出道日期',
    `company` VARCHAR(100) COMMENT '经纪公司',
    `introduction` TEXT COMMENT '个人简介',
    `achievements` TEXT COMMENT '成就荣誉',
    `avatar` VARCHAR(255) COMMENT '头像',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='歌手信息表';

-- 插入薛之谦资料
INSERT INTO `singer_info` (`name`, `real_name`, `birthday`, `birthplace`, `constellation`, `height`, `blood_type`, `debut_date`, `company`, `introduction`, `achievements`, `avatar`) VALUES 
('薛之谦', '薛之谦', '1983-07-17', '上海', '巨蟹座', '180cm', 'B型', '2005-08-01', '海蝶音乐', 
'薛之谦，1983年7月17日出生于上海，中国内地流行乐男歌手、影视演员、音乐制作人，毕业于格里昂酒店管理学院。2005年因参加选秀节目《我型我秀》正式出道。2006年发行首张同名专辑《薛之谦》，其中歌曲《认真的雪》获得广泛关注。2013年凭借歌曲《丑八怪》再度走红。2015年发行专辑《绅士》，同名主打歌曲《绅士》及《演员》广受好评，开启音乐事业高峰期。',
'【音乐成就】\n• 2016年 音悦V榜年度盛典 年度最佳男歌手\n• 2017年 东方风云榜 最佳男歌手\n• 2018年 全球华语榜中榜 亚洲影响力歌手\n• 2019年 华语金曲奖 年度最佳男歌手\n• 2020年 中国歌曲排行榜 年度金曲《天外来物》\n\n【影视综艺】\n• 《我是歌手》竞演歌手\n• 《火星情报局》常驻嘉宾\n• 电影主题曲多首\n\n【其他荣誉】\n• 微博粉丝数超7000万\n• 个人演唱会场场爆满',
'/images/xuezhiqian.jpg');
