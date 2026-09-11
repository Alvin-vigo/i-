-- 创建上传文件记录表
CREATE TABLE IF NOT EXISTS uploaded_files (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    file_type VARCHAR(20) NOT NULL COMMENT '文件类型(mp4/mp3/image)',
    file_name VARCHAR(255) NOT NULL COMMENT '文件名',
    file_size BIGINT DEFAULT 0 COMMENT '文件大小(字节)',
    upload_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    INDEX idx_file_type (file_type),
    INDEX idx_upload_time (upload_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='上传文件记录表';

-- 插入一些示例数据（可选）
-- INSERT INTO uploaded_files (file_type, file_name, file_size) VALUES 
-- ('image', 'carousel1.jpg', 1024000),
-- ('image', 'carousel2.jpg', 2048000),
-- ('mp3', '演员.mp3', 5120000),
-- ('mp4', '综艺片段.mp4', 51200000);