package com.jisu;

import com.jisu.entity.User;
import com.jisu.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * 用户Servlet - 处理登录/注册/个人信息修改
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class UserServlet extends HttpServlet {
    
    private UserService userService = new UserService();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String action = request.getParameter("action");
        
        if (action == null) {
            sendError(response, "缺少action参数");
            return;
        }
        
        switch (action) {
            case "login":
                handleLogin(request, response);
                break;
            case "register":
                handleRegister(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "updateWithAvatar":
                handleUpdateWithAvatar(request, response);
                break;
            case "updateAvatar":
                handleUpdateAvatar(request, response);
                break;
            case "updatePassword":
                handleUpdatePassword(request, response);
                break;
            default:
                sendError(response, "未知操作");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String action = request.getParameter("action");
        
        if ("info".equals(action)) {
            handleGetInfo(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }
    
    /**
     * 处理登录
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        User user = userService.login(username, password);
        
        if (user != null) {
            // 登录成功，保存到Session
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user.getUsername());
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30分钟
            
            sendSuccess(response, "登录成功");
        } else {
            sendError(response, "用户名或密码错误");
        }
    }
    
    /**
     * 处理注册
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        // 参数校验
        if (username == null || username.trim().isEmpty()) {
            sendError(response, "用户名不能为空");
            return;
        }
        if (password == null || password.trim().isEmpty()) {
            sendError(response, "密码不能为空");
            return;
        }
        
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setPhone(phone);
        user.setEmail(email);
        
        int result = userService.register(user);
        
        switch (result) {
            case 0:
                sendSuccess(response, "注册成功");
                break;
            case 1:
                sendError(response, "用户名已存在");
                break;
            default:
                sendError(response, "注册失败，请稍后重试");
        }
    }
    
    /**
     * 处理更新用户信息
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        User user = userService.findById(userId);
        if (user == null) {
            sendError(response, "用户不存在");
            return;
        }
        
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        user.setPhone(phone);
        user.setEmail(email);
        
        boolean result = userService.update(user);
        
        if (result) {
            // 更新Session中的用户信息
            session.setAttribute("user", user);
            sendSuccess(response, "修改成功");
        } else {
            sendError(response, "修改失败");
        }
    }
    
    /**
     * 处理更新用户信息和头像
     */
    private void handleUpdateWithAvatar(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        User user = userService.findById(userId);
        if (user == null) {
            sendError(response, "用户不存在");
            return;
        }
        
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        
        user.setPhone(phone);
        user.setEmail(email);
        
        // 处理头像上传
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String avatarPath = saveAvatar(filePart, userId);
            if (avatarPath != null) {
                user.setAvatar(avatarPath);
            }
        }
        
        boolean result = userService.update(user);
        
        if (result) {
            // 更新Session中的用户信息
            session.setAttribute("user", user);
            sendSuccess(response, "修改成功");
        } else {
            sendError(response, "修改失败");
        }
    }
    
    /**
     * 处理仅更新头像
     */
    private void handleUpdateAvatar(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        User user = userService.findById(userId);
        if (user == null) {
            sendError(response, "用户不存在");
            return;
        }
        
        // 处理头像上传
        Part filePart = request.getPart("avatar");
        if (filePart != null && filePart.getSize() > 0) {
            String avatarPath = saveAvatar(filePart, userId);
            if (avatarPath != null) {
                user.setAvatar(avatarPath);
                boolean result = userService.update(user);
                
                if (result) {
                    // 更新Session中的用户信息
                    session.setAttribute("user", user);
                    sendSuccess(response, "头像上传成功");
                    return;
                }
            }
        }
        
        sendError(response, "头像上传失败");
    }
    
    /**
     * 保存头像文件
     */
    private String saveAvatar(Part filePart, Integer userId) {
        try {
            // 获取文件名
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String fileExtension = getFileExtension(fileName);
            
            // 验证文件类型
            if (!isValidImageType(fileExtension)) {
                return null;
            }
            
            // 生成新的文件名
            String newFileName = "avatar_" + userId + "_" + System.currentTimeMillis() + fileExtension;
            
            // 创建头像目录
            String avatarDir = System.getProperty("user.dir") + "/avatars/";
            Path avatarPath = Paths.get(avatarDir);
            if (!Files.exists(avatarPath)) {
                Files.createDirectories(avatarPath);
            }
            
            // 保存文件
            Path filePath = avatarPath.resolve(newFileName);
            try (InputStream inputStream = filePart.getInputStream()) {
                Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            }
            
            // 返回相对路径
            return "/avatars/" + newFileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.lastIndexOf('.') == -1) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf('.'));
    }
    
    /**
     * 验证是否为有效的图片类型
     */
    private boolean isValidImageType(String fileExtension) {
        return ".jpg".equalsIgnoreCase(fileExtension) || 
               ".jpeg".equalsIgnoreCase(fileExtension) || 
               ".png".equalsIgnoreCase(fileExtension) || 
               ".gif".equalsIgnoreCase(fileExtension);
    }
    
    /**
     * 处理修改密码
     */
    private void handleUpdatePassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        
        if (oldPassword == null || newPassword == null) {
            sendError(response, "参数不完整");
            return;
        }
        
        int result = userService.updatePassword(userId, oldPassword, newPassword);
        
        switch (result) {
            case 0:
                // 修改成功，清除Session
                session.invalidate();
                sendSuccess(response, "密码修改成功，请重新登录");
                break;
            case 1:
                sendError(response, "原密码错误");
                break;
            default:
                sendError(response, "修改失败");
        }
    }
    
    /**
     * 获取当前用户信息
     */
    private void handleGetInfo(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        User user = userService.findById(userId);
        if (user != null) {
            PrintWriter out = response.getWriter();
            out.print("{\"code\":0,\"data\":{");
            out.print("\"id\":" + user.getId() + ",");
            out.print("\"username\":\"" + user.getUsername() + "\",");
            out.print("\"phone\":\"" + (user.getPhone() != null ? user.getPhone() : "") + "\",");
            out.print("\"email\":\"" + (user.getEmail() != null ? user.getEmail() : "") + "\",");
            out.print("\"avatar\":\"" + (user.getAvatar() != null ? user.getAvatar() : "") + "\"");
            out.print("}}");
        } else {
            sendError(response, "用户不存在");
        }
    }
    
    private void sendSuccess(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"message\":\"" + message + "\"}");
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"code\":1,\"message\":\"" + message + "\"}");
    }
}
