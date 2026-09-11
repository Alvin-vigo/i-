package com.jisu;

import com.jisu.entity.User;
import com.jisu.service.UserService;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 设置请求编码（解决中文乱码）
        request.setCharacterEncoding("UTF-8");
        // 2. 获取表单提交的参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // 调试日志：打印接收到的参数
        System.out.println("【登录调试】收到登录请求");
        System.out.println("【登录调试】用户名: [" + username + "], 长度: " + (username != null ? username.length() : 0));
        System.out.println("【登录调试】密码: [" + password + "], 长度: " + (password != null ? password.length() : 0));

        // 3. 使用Service层验证用户
        User user = userService.login(username, password);
        
        // 调试日志：打印验证结果
        System.out.println("【登录调试】验证结果: " + (user != null ? "成功 - " + user.getUsername() : "失败"));

        if (user != null) {
            // 登录成功：创建 Session，保存用户信息
            HttpSession session = request.getSession();
            session.setAttribute("loginUser", user.getUsername());
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // Session 有效期 30 分钟

            // 根据角色跳转到不同页面
            if (user.isAdmin()) {
                response.sendRedirect("admin.jsp");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // 登录失败：设置错误信息并返回登录页
            request.setAttribute("errorMsg", "用户名或密码错误");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    // 处理 GET 请求（防止用户直接访问 /login 路径）
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 重定向到登录页面
        response.sendRedirect("login.jsp");
    }
}