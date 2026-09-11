package com.jisu;

import com.jisu.entity.User;
import com.jisu.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ResetPwdServlet extends HttpServlet {

    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. 获取表单参数
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String verifyCode = request.getParameter("verifyCode");
        String newPwd = request.getParameter("newPwd");
        String confirmPwd = request.getParameter("confirmPwd");

        // 2. 后端二次校验（防止前端绕过验证）
        if (username == null || phone == null || verifyCode == null || newPwd == null || confirmPwd == null) {
            request.setAttribute("error", "参数不完整");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 校验手机号格式
        if (!userService.validatePhone(phone)) {
            request.setAttribute("error", "手机号格式不正确");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 校验验证码格式（这里简化处理，实际应验证真实验证码）
        if (!verifyCode.matches("^\\d{6}$")) {
            request.setAttribute("error", "验证码格式不正确");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 校验密码格式
        if (!userService.validatePassword(newPwd)) {
            request.setAttribute("error", "新密码格式不正确（6-16位字母+数字）");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 校验两次密码一致
        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 3. 验证用户名和手机号是否匹配
        User user = userService.findByUsername(username);
        
        if (user == null) {
            request.setAttribute("error", "用户不存在");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }
        
        if (!phone.equals(user.getPhone())) {
            request.setAttribute("error", "用户名与手机号不匹配");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 4. 模拟验证码验证（实际项目中应从数据库/Redis中验证）
        // 这里简化处理，假设验证码为 "123456"
        if (!"123456".equals(verifyCode)) {
            request.setAttribute("error", "验证码不正确");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
            return;
        }

        // 5. 更新密码
        boolean result = userService.updatePassword(user.getId(), user.getPassword(), newPwd) == 0;
        
        if (result) {
            request.setAttribute("resetSuccess", true);
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "密码重置失败，请重试");
            request.getRequestDispatcher("/forget-password.jsp").forward(request, response);
        }
    }
}