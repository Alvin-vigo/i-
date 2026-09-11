package com.jisu;

import com.jisu.util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 50,       // 50MB
    maxRequestSize = 1024 * 1024 * 100    // 100MB
)
public class UploadServlet extends HttpServlet {
    
    // 文件存储根目录
    private static final String FILE_STORAGE_PATH = "I:/zx/finish/download_files/";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        // 检查管理员权限
        Integer userRole = (Integer) request.getSession().getAttribute("userRole");
        if (userRole == null || userRole != 1) {
            sendError(response, "无权限操作");
            return;
        }
        
        try {
            // 获取上传参数
            String fileType = request.getParameter("fileType"); // mp4, mp3, image
            String fileName = request.getParameter("fileName");
            Part filePart = request.getPart("file");
            
            // 参数校验
            if (fileType == null || fileType.isEmpty()) {
                sendError(response, "请选择文件类型");
                return;
            }
            
            if (fileName == null || fileName.trim().isEmpty()) {
                sendError(response, "请输入文件名");
                return;
            }
            
            if (filePart == null || filePart.getSize() == 0) {
                sendError(response, "请选择要上传的文件");
                return;
            }
            
            // 安全校验：防止目录遍历攻击
            if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
                sendError(response, "文件名包含非法字符");
                return;
            }
            
            // 确定子目录
            String subDir = "";
            switch (fileType.toLowerCase()) {
                case "mp4":
                    subDir = "mv/";
                    break;
                case "mp3":
                    subDir = "music/";
                    break;
                case "image":
                    subDir = "images/";
                    break;
                default:
                    sendError(response, "不支持的文件类型");
                    return;
            }
            
            // 构造完整文件路径
            Path uploadPath = Paths.get(FILE_STORAGE_PATH, subDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            // 处理文件扩展名
            String originalFileName = getFileName(filePart);
            String fileExtension = getFileExtension(originalFileName);
            String finalFileName = fileName + (fileExtension.isEmpty() ? "" : "." + fileExtension);
            Path filePath = uploadPath.resolve(finalFileName);
            
            // 保存文件
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            // 记录到数据库（可选）
            saveFileInfoToDatabase(fileType, finalFileName, filePart.getSize());
            
            // 返回成功响应
            sendSuccess(response, "文件上传成功: " + finalFileName);
            
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "文件上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 从Part中提取原始文件名
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String cd : contentDisposition.split(";")) {
                if (cd.trim().startsWith("filename")) {
                    return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "";
    }
    
    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf('.') == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf('.') + 1);
    }
    
    /**
     * 保存文件信息到数据库（可选）
     */
    private void saveFileInfoToDatabase(String fileType, String fileName, long fileSize) {
        String sql = "INSERT INTO uploaded_files (file_type, file_name, file_size, upload_time) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, fileType);
            pstmt.setString(2, fileName);
            pstmt.setLong(3, fileSize);
            pstmt.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("保存文件信息到数据库失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void sendSuccess(HttpServletResponse response, String message) throws IOException {
        response.getWriter().print("{\"code\":0,\"message\":\"" + message + "\"}");
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.getWriter().print("{\"code\":1,\"message\":\"" + message + "\"}");
    }
}