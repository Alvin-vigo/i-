package com.jisu;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(filterName = "LoginCheckFilter", value = {"/*"})
public class LoginCheckFilter implements Filter {
    public void init(FilterConfig config) throws ServletException {
    }

    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws ServletException, IOException {
        // 转换为HttpServletRequest/HttpServletResponse（获取Session和重定向需要）
        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        // 1. 排除不需要拦截的资源（登录页、登录接口、退出接口）
        String requestUrl = httpReq.getRequestURI();
        if (requestUrl.endsWith("/login.jsp")
                || requestUrl.endsWith("/register.jsp")
                || requestUrl.endsWith("/forget-password.jsp")
                || requestUrl.endsWith("/login")
                || requestUrl.endsWith("/logout")
                || requestUrl.endsWith("/download")
                || requestUrl.endsWith("/error.jsp")
                ) {
            chain.doFilter(request, response); // 放行不需要登录的资源
            return;
        }

        // 2. 判断用户是否已登录（Session中是否有用户信息）
        Object loginUser = httpReq.getSession().getAttribute("loginUser");
        if (loginUser != null) {
            // 已登录：放行到目标资源
            System.out.println("【LoginCheckFilter】用户已登录，放行请求：" + requestUrl);
            chain.doFilter(request, response);
        } else {
            // 未登录：重定向到登录页
            System.out.println("【LoginCheckFilter】用户未登录，跳转至登录页");
            httpResp.sendRedirect(httpReq.getContextPath() + "/login.jsp");
        }
    }
}
