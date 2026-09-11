package com.jisu;

import com.jisu.entity.Message;
import com.jisu.entity.User;
import com.jisu.service.MessageService;

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
 * 留言Servlet - 处理留言发布/查询/点赞
 */
public class MessageServlet extends HttpServlet {
    
    private MessageService messageService = new MessageService();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                handleList(request, response);
                break;
            case "myList":
                handleMyList(request, response);
                break;
            case "replies":
                handleReplies(request, response);
                break;
            default:
                handleList(request, response);
        }
    }
    
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
            case "add":
                handleAdd(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "like":
                handleLike(request, response);
                break;
            case "reply":
                handleReply(request, response);
                break;
            default:
                sendError(response, "未知操作");
        }
    }
    
    /**
     * 查询留言列表（分页）
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        List<Message> messages = messageService.findAll(page, pageSize);
        int total = messageService.countAll();
        int totalPages = messageService.getTotalPages(total, pageSize);
        
        // 检查当前用户是否已点赞
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        sendMessagesList(response, messages, page, totalPages, total, userId);
    }
    
    /**
     * 查询我的留言
     */
    private void handleMyList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        List<Message> messages = messageService.findByUserId(userId, page, pageSize);
        int total = messageService.countByUserId(userId);
        int totalPages = messageService.getTotalPages(total, pageSize);
        
        sendMessagesList(response, messages, page, totalPages, total, userId);
    }
    
    /**
     * 获取回复列表
     */
    private void handleReplies(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int parentId = getIntParam(request, "parentId", 0);
        
        if (parentId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        List<Message> replies = messageService.findReplies(parentId);
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        sendMessagesList(response, replies, 1, 1, replies.size(), userId);
    }
    
    /**
     * 发布留言
     */
    private void handleAdd(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        String content = request.getParameter("content");
        
        Message message = new Message();
        message.setUserId(userId);
        message.setContent(content);
        
        int result = messageService.add(message);
        
        switch (result) {
            case 0:
                sendSuccess(response, "发布成功");
                break;
            case 1:
                sendError(response, "内容不能为空");
                break;
            case 2:
                sendError(response, "内容包含违禁词");
                break;
            default:
                sendError(response, "发布失败");
        }
    }
    
    /**
     * 回复留言
     */
    private void handleReply(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        String content = request.getParameter("content");
        int parentId = getIntParam(request, "parentId", 0);
        
        if (parentId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        Message message = new Message();
        message.setUserId(userId);
        message.setContent(content);
        message.setParentId(parentId);
        
        int result = messageService.add(message);
        
        switch (result) {
            case 0:
                sendSuccess(response, "回复成功");
                break;
            case 1:
                sendError(response, "内容不能为空");
                break;
            case 2:
                sendError(response, "内容包含违禁词");
                break;
            default:
                sendError(response, "回复失败");
        }
    }
    
    /**
     * 删除留言
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Integer userRole = (Integer) session.getAttribute("userRole");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        int messageId = getIntParam(request, "id", 0);
        
        if (messageId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        boolean isAdmin = userRole != null && userRole == 1;
        
        if (!messageService.canDelete(messageId, userId, isAdmin)) {
            sendError(response, "无权删除此留言");
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
     * 点赞/取消点赞
     */
    private void handleLike(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            sendError(response, "请先登录");
            return;
        }
        
        int messageId = getIntParam(request, "id", 0);
        
        if (messageId <= 0) {
            sendError(response, "无效的留言ID");
            return;
        }
        
        boolean result = messageService.like(messageId, userId);
        
        if (result) {
            // 返回当前点赞状态
            boolean liked = messageService.hasLiked(messageId, userId);
            Message msg = messageService.findById(messageId);
            PrintWriter out = response.getWriter();
            out.print("{\"code\":0,\"message\":\"" + (liked ? "点赞成功" : "取消点赞") + "\",");
            out.print("\"data\":{\"liked\":" + liked + ",\"likeCount\":" + (msg != null ? msg.getLikeCount() : 0) + "}}");
        } else {
            sendError(response, "操作失败");
        }
    }
    
    /**
     * 发送留言列表响应
     */
    private void sendMessagesList(HttpServletResponse response, List<Message> messages, 
            int page, int totalPages, int total, Integer currentUserId) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"data\":{");
        out.print("\"list\":[");
        
        for (int i = 0; i < messages.size(); i++) {
            if (i > 0) out.print(",");
            Message msg = messages.get(i);
            boolean liked = currentUserId != null && messageService.hasLiked(msg.getId(), currentUserId);
            out.print(messageToJson(msg, liked));
        }
        
        out.print("],");
        out.print("\"page\":" + page + ",");
        out.print("\"totalPages\":" + totalPages + ",");
        out.print("\"total\":" + total);
        out.print("}}");
    }
    
    /**
     * 将Message对象转换为JSON字符串
     */
    private String messageToJson(Message msg, boolean liked) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"id\":").append(msg.getId()).append(",");
        sb.append("\"userId\":").append(msg.getUserId()).append(",");
        sb.append("\"username\":\"").append(escapeJson(msg.getUsername())).append("\",");
        sb.append("\"avatar\":\"").append(escapeJson(msg.getAvatar())).append("\",");
        sb.append("\"content\":\"").append(escapeJson(msg.getContent())).append("\",");
        sb.append("\"likeCount\":").append(msg.getLikeCount()).append(",");
        sb.append("\"liked\":").append(liked).append(",");
        sb.append("\"createTime\":\"").append(msg.getCreateTime() != null ? sdf.format(msg.getCreateTime()) : "").append("\"");
        sb.append("}");
        return sb.toString();
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
