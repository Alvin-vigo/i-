package com.jisu;

import com.jisu.entity.Message;
import com.jisu.entity.User;
import com.jisu.service.MessageService;
import com.jisu.service.UserService;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * 管理员Servlet - 处理用户管理/留言审核
 */
public class AdminServlet extends HttpServlet {
    
    private UserService userService = new UserService();
    private MessageService messageService = new MessageService();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        // 验证管理员权限
        if (!isAdmin(request)) {
            sendError(response, "无权访问");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "users";
        
        switch (action) {
            case "users":
                handleUserList(request, response);
                break;
            case "messages":
                handleMessageList(request, response);
                break;
            case "stats":
                handleStats(request, response);
                break;
            default:
                handleUserList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        // 验证管理员权限
        if (!isAdmin(request)) {
            sendError(response, "无权访问");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            sendError(response, "缺少action参数");
            return;
        }
        
        switch (action) {
            case "disableUser":
                handleDisableUser(request, response);
                break;
            case "enableUser":
                handleEnableUser(request, response);
                break;
            case "addUser":
                handleAddUser(request, response);
                break;
            case "deleteMessage":
                handleDeleteMessage(request, response);
                break;
            case "markViolation":
                handleMarkViolation(request, response);
                break;
            case "unmarkViolation":
                handleUnmarkViolation(request, response);
                break;
            default:
                sendError(response, "未知操作");
        }
    }
    
    /**
     * 验证是否为管理员
     */
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userRole = (Integer) session.getAttribute("userRole");
        return userRole != null && userRole == 1;
    }
    
    /**
     * 查询用户列表
     */
    private void handleUserList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        List<User> users = userService.findAll(page, pageSize);
        int total = userService.countAll();
        int totalPages = (int) Math.ceil((double) total / pageSize);
        
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"data\":{");
        out.print("\"list\":[");
        
        for (int i = 0; i < users.size(); i++) {
            if (i > 0) out.print(",");
            User user = users.get(i);
            out.print("{");
            out.print("\"id\":" + user.getId() + ",");
            out.print("\"username\":\"" + escapeJson(user.getUsername()) + "\",");
            out.print("\"phone\":\"" + escapeJson(user.getPhone()) + "\",");
            out.print("\"email\":\"" + escapeJson(user.getEmail()) + "\",");
            out.print("\"status\":" + user.getStatus() + ",");
            out.print("\"createTime\":\"" + (user.getCreateTime() != null ? sdf.format(user.getCreateTime()) : "") + "\"");
            out.print("}");
        }
        
        out.print("],");
        out.print("\"page\":" + page + ",");
        out.print("\"totalPages\":" + totalPages + ",");
        out.print("\"total\":" + total);
        out.print("}}");
    }
    
    /**
     * 查询留言列表（管理员）
     */
    private void handleMessageList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        List<Message> messages = messageService.findAllAdmin(page, pageSize);
        int total = messageService.countAll();
        int totalPages = (int) Math.ceil((double) total / pageSize);
        
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"data\":{");
        out.print("\"list\":[");
        
        for (int i = 0; i < messages.size(); i++) {
            if (i > 0) out.print(",");
            Message msg = messages.get(i);
            out.print("{");
            out.print("\"id\":" + msg.getId() + ",");
            out.print("\"userId\":" + msg.getUserId() + ",");
            out.print("\"username\":\"" + escapeJson(msg.getUsername()) + "\",");
            out.print("\"content\":\"" + escapeJson(msg.getContent()) + "\",");
            out.print("\"isViolation\":" + msg.getIsViolation() + ",");
            out.print("\"likeCount\":" + msg.getLikeCount() + ",");
            out.print("\"createTime\":\"" + (msg.getCreateTime() != null ? sdf.format(msg.getCreateTime()) : "") + "\"");
            out.print("}");
        }
        
        out.print("],");
        out.print("\"page\":" + page + ",");
        out.print("\"totalPages\":" + totalPages + ",");
        out.print("\"total\":" + total);
        out.print("}}");
    }
    
    /**
     * 获取统计信息
     */
    private void handleStats(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int userCount = userService.countAll();
        int messageCount = messageService.countAll();
        
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"data\":{");
        out.print("\"userCount\":" + userCount + ",");
        out.print("\"messageCount\":" + messageCount);
        out.print("}}");
    }
    
    /**
     * 禁用用户
     */
    private void handleDisableUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int userId = getIntParam(request, "userId", 0);
        
        if (userId <= 0) {
            sendError(response, "无效的用户ID");
            return;
        }
        
        boolean result = userService.updateStatus(userId, 0);
        
        if (result) {
            sendSuccess(response, "禁用成功");
        } else {
            sendError(response, "禁用失败");
        }
    }
    
    /**
     * 启用用户
     */
    private void handleEnableUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int userId = getIntParam(request, "userId", 0);
        
        if (userId <= 0) {
            sendError(response, "无效的用户ID");
            return;
        }
        
        boolean result = userService.updateStatus(userId, 1);
        
        if (result) {
            sendSuccess(response, "启用成功");
        } else {
            sendError(response, "启用失败");
        }
    }
    
    /**
     * 添加用户
     */
    private void handleAddUser(HttpServletRequest request, HttpServletResponse response) 
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
        
        // 验证手机号格式
        if (phone != null && !phone.trim().isEmpty() && !userService.validatePhone(phone)) {
            sendError(response, "手机号格式不正确");
            return;
        }
        
        // 验证邮箱格式
        if (email != null && !email.trim().isEmpty() && !userService.validateEmail(email)) {
            sendError(response, "邮箱格式不正确");
            return;
        }
        
        // 创建用户对象
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setEmail(email != null ? email.trim() : null);
        
        // 注册用户
        int result = userService.register(user);
        
        if (result == 0) {
            sendSuccess(response, "添加用户成功");
        } else if (result == 1) {
            sendError(response, "用户名已存在");
        } else {
            sendError(response, "添加用户失败");
        }
    }
    
    /**
     * 删除留言
     */
    private void handleDeleteMessage(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int messageId = getIntParam(request, "messageId", 0);
        
        if (messageId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        boolean result = messageService.delete(messageId);
        
        if (result) {
            sendSuccess(response, "删除成功");
        } else {
            sendError(response, "删除失败");
        }
    }
    
    /**
     * 标记违规留言
     */
    private void handleMarkViolation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int messageId = getIntParam(request, "messageId", 0);
        
        if (messageId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        boolean result = messageService.markViolation(messageId);
        
        if (result) {
            sendSuccess(response, "已标记违规");
        } else {
            sendError(response, "操作失败");
        }
    }
    
    /**
     * 取消违规标记
     */
    private void handleUnmarkViolation(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int messageId = getIntParam(request, "messageId", 0);
        
        if (messageId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        boolean result = messageService.unmarkViolation(messageId);
        
        if (result) {
            sendSuccess(response, "已取消违规标记");
        } else {
            sendError(response, "操作失败");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    private int getIntParam(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        try {
            return value != null ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
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
