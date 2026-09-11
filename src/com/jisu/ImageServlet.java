package com.jisu;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ImageServlet extends HttpServlet {
    
    // 图片存储根目录
    private static final String IMAGE_STORAGE_PATH = "I:/zx/finish/download_files/images/";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 获取图片文件名
        String fileName = request.getParameter("file");
        
        // 参数校验
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少文件参数");
            return;
        }
        
        // 安全检查：防止目录遍历攻击
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "非法文件名");
            return;
        }
        
        // 构造完整文件路径
        Path filePath = Paths.get(IMAGE_STORAGE_PATH, fileName);
        
        // 检查文件是否存在
        if (!Files.exists(filePath)) {
            // 返回默认图片
            Path defaultImagePath = Paths.get(IMAGE_STORAGE_PATH, "default-carousel.jpg");
            if (Files.exists(defaultImagePath)) {
                filePath = defaultImagePath;
            } else {
                // 如果连默认图片都没有，则返回404
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "图片不存在");
                return;
            }
        }
        
        // 设置响应头
        String contentType = getContentType(fileName);
        response.setContentType(contentType);
        response.setContentLengthLong(Files.size(filePath));
        
        // 输出文件内容
        try (InputStream in = Files.newInputStream(filePath);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        } catch (IOException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "图片加载失败");
        }
    }
    
    /**
     * 根据文件扩展名返回对应的Content-Type
     */
    private String getContentType(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "application/octet-stream";
        }
        
        String lowerFileName = fileName.toLowerCase();
        if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (lowerFileName.endsWith(".png")) {
            return "image/png";
        } else if (lowerFileName.endsWith(".gif")) {
            return "image/gif";
        } else if (lowerFileName.endsWith(".bmp")) {
            return "image/bmp";
        } else {
            return "image/jpeg"; // 默认JPEG
        }
    }
}