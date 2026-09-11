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
import java.util.ArrayList;
import java.util.List;

// 文件信息类
class FileInfo {
    private String name;
    private long size;
    private String lastModified;
    
    public FileInfo(String name, long size, long lastModified) {
        this.name = name;
        this.size = size;
        this.lastModified = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date(lastModified));
    }
    
    // Getters
    public String getName() { return name; }
    public long getSize() { return size; }
    public String getLastModified() { return lastModified; }
}

public class DownloadServlet extends HttpServlet {
    
    // 文件存储根目录（项目目录下的download_files文件夹）
    private static final String FILE_STORAGE_PATH = "I:/zx/finish/download_files/";
    
    // 静态初始化块，确保目录在类加载时就创建
    static {
        createDirectories();
    }
    
    /**
     * 创建必要的目录结构
     */
    private static void createDirectories() {
        try {
            java.nio.file.Path rootPath = java.nio.file.Paths.get(FILE_STORAGE_PATH);
            if (!java.nio.file.Files.exists(rootPath)) {
                java.nio.file.Files.createDirectories(rootPath);
                System.out.println("创建下载根目录: " + rootPath);
            }
            
            // 创建子目录
            java.nio.file.Path mvPath = rootPath.resolve("mv");
            java.nio.file.Path musicPath = rootPath.resolve("music");
            java.nio.file.Path imagesPath = rootPath.resolve("images");
            
            if (!java.nio.file.Files.exists(mvPath)) {
                java.nio.file.Files.createDirectory(mvPath);
                System.out.println("创建MV目录: " + mvPath);
            }
            
            if (!java.nio.file.Files.exists(musicPath)) {
                java.nio.file.Files.createDirectory(musicPath);
                System.out.println("创建音乐目录: " + musicPath);
            }
            
            if (!java.nio.file.Files.exists(imagesPath)) {
                java.nio.file.Files.createDirectory(imagesPath);
                System.out.println("创建图片目录: " + imagesPath);
            }
        } catch (Exception e) {
            System.err.println("创建下载目录失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // 检查是否是获取文件列表的请求
        String action = request.getParameter("action");
        if ("list".equals(action)) {
            listFiles(request, response);
            return;
        }
        
        // 获取文件类型和文件名
        String fileType = request.getParameter("type"); // mp4, mp3, image
        String fileName = request.getParameter("file"); // 文件名
        
        // 参数校验
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少文件名参数");
            return;
        }
        
        // 安全检查：防止目录遍历攻击
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "非法文件名");
            return;
        }
        
        Path filePath;
        if (fileType == null || fileType.isEmpty()) {
            // 如果没有指定文件类型，则从download_files根目录下载
            filePath = Paths.get(FILE_STORAGE_PATH, fileName);
        } else {
            // 构造文件路径
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
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "不支持的文件类型");
                    return;
            }
            
            // 构造完整文件路径
            filePath = Paths.get(FILE_STORAGE_PATH, subDir, fileName);
        }
        
        // 检查文件是否存在
        if (!Files.exists(filePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "文件不存在: " + filePath.toString());
            return;
        }
        
        // 检查是否明确要求内联显示（在线播放/查看）
        boolean isInline = "true".equals(request.getParameter("inline"));
        
        // 设置响应头
        response.setContentType(getContentTypeByFileName(fileName));
        if (isInline) {
            // 在线播放/查看，不触发下载
            response.setHeader("Content-Disposition", "inline; filename=\"" + 
                              URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + "\"");
        } else {
            // 下载文件
            response.setHeader("Content-Disposition", "attachment; filename=\"" + 
                              URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20") + "\"");
        }
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
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "文件处理失败");
        }
    }
    
    /**
     * 判断是否为内联请求（在线播放）- 已简化，不再自动判断
     */
    private boolean isInlineRequest(HttpServletRequest request) {
        // 只有当明确指定inline=true时才内联显示
        return "true".equals(request.getParameter("inline"));
    }
    
    /**
     * 列出指定类型的文件
     */
    private void listFiles(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fileType = request.getParameter("type");
        
        // 获取文件列表
        List<FileInfo> files = new ArrayList<>();
        
        if (fileType == null || fileType.isEmpty()) {
            // 如果没有指定文件类型，则列出download_files根目录下的文件
            Path rootDirPath = Paths.get(FILE_STORAGE_PATH);
            System.out.println("正在扫描根目录: " + rootDirPath.toString());
            
            if (Files.exists(rootDirPath) && Files.isDirectory(rootDirPath)) {
                try {
                    Files.list(rootDirPath)
                        .filter(Files::isRegularFile)
                        .forEach(path -> {
                            try {
                                String fileName = path.getFileName().toString();
                                long size = Files.size(path);
                                long lastModified = Files.getLastModifiedTime(path).toMillis();
                                files.add(new FileInfo(fileName, size, lastModified));
                                System.out.println("找到文件: " + fileName + ", 大小: " + size);
                            } catch (IOException e) {
                                System.err.println("读取文件信息失败: " + path.toString());
                                e.printStackTrace();
                            }
                        });
                } catch (IOException e) {
                    System.err.println("扫描根目录失败: " + rootDirPath.toString());
                    e.printStackTrace();
                }
            } else {
                System.out.println("根目录不存在或不是目录: " + rootDirPath.toString());
            }
        } else {
            // 确定子目录
            String subDir = "";
            switch (fileType.toLowerCase()) {
                case "mp4":
                    subDir = "mv";
                    break;
                case "mp3":
                    subDir = "music";
                    break;
                case "image":
                    subDir = "images";
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "不支持的文件类型");
                    return;
            }
            
            Path dirPath = Paths.get(FILE_STORAGE_PATH, subDir);
            
            System.out.println("正在扫描目录: " + dirPath.toString());
            
            if (Files.exists(dirPath) && Files.isDirectory(dirPath)) {
                try {
                    Files.list(dirPath)
                        .filter(Files::isRegularFile)
                        .forEach(path -> {
                            try {
                                String fileName = path.getFileName().toString();
                                long size = Files.size(path);
                                long lastModified = Files.getLastModifiedTime(path).toMillis();
                                files.add(new FileInfo(fileName, size, lastModified));
                                System.out.println("找到文件: " + fileName + ", 大小: " + size);
                            } catch (IOException e) {
                                System.err.println("读取文件信息失败: " + path.toString());
                                e.printStackTrace();
                            }
                        });
                } catch (IOException e) {
                    System.err.println("扫描目录失败: " + dirPath.toString());
                    e.printStackTrace();
                }
            } else {
                System.out.println("目录不存在或不是目录: " + dirPath.toString());
            }
        }
        
        // 返回JSON格式的文件列表（手动构造JSON）
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print("[");
        for (int i = 0; i < files.size(); i++) {
            FileInfo file = files.get(i);
            if (i > 0) out.print(",");
            out.print("{");
            out.print("\"name\":\"" + escapeJson(file.getName()) + "\",");
            out.print("\"size\":" + file.getSize() + ",");
            out.print("\"lastModified\":\"" + file.getLastModified() + "\"");
            out.print("}");
        }
        out.print("]");
        out.flush();
        
        System.out.println("返回文件列表，共 " + files.size() + " 个文件");
    }
    
    /**
     * 转义JSON字符串
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }
    
    /**
     * 根据文件类型返回对应的Content-Type
     */
    private String getContentType(String fileType) {
        switch (fileType.toLowerCase()) {
            case "mp4":
                return "video/mp4";
            case "mp3":
                return "audio/mpeg";
            case "image":
                // 根据文件扩展名判断图片类型
                return "image/jpeg";
            default:
                return "application/octet-stream";
        }
    }
    
    /**
     * 根据文件名返回对应的Content-Type
     */
    private String getContentTypeByFileName(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "application/octet-stream";
        }
        
        String lowerFileName = fileName.toLowerCase();
        if (lowerFileName.endsWith(".mp4")) {
            return "video/mp4";
        } else if (lowerFileName.endsWith(".mp3")) {
            return "audio/mpeg";
        } else if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (lowerFileName.endsWith(".png")) {
            return "image/png";
        } else if (lowerFileName.endsWith(".gif")) {
            return "image/gif";
        } else if (lowerFileName.endsWith(".sql")) {
            return "application/sql";
        } else if (lowerFileName.endsWith(".pdf")) {
            return "application/pdf";
        } else {
            return "application/octet-stream";
        }
    }
}