package com.jisu;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 清除 Session 中的用户信息（关键）
        HttpSession session = request.getSession();
        session.removeAttribute("loginUser"); // 移除登录状态
        session.invalidate(); // 销毁 Session（可选，彻底注销）

        // 重定向到登录页
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}