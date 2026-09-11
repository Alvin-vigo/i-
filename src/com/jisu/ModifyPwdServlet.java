package com.jisu;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

public class ModifyPwdServlet extends HttpServlet {

    // ===================== 预留数据库连接配置（请替换为你的数据库信息）=====================
    private static final String DB_URL = "jdbc:mysql://localhost:3306/你的数据库名?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "数据库用户名（如root）";
    private static final String DB_PWD = "数据库密码";
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    // ===================================================================================

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 1. 获取表单参数
        String oldPwd = request.getParameter("oldPwd");
        String newPwd = request.getParameter("newPwd");
        String confirmPwd = request.getParameter("confirmPwd");
        HttpSession session = request.getSession();
        String loginUser = (String) session.getAttribute("loginUser"); // 从Session获取当前登录用户名

        // 2. 后端二次校验（防止前端绕过验证）
        if (loginUser == null) {
            // 未登录，跳转到登录页
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 校验新密码格式
        if (!newPwd.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,16}$")) {
            request.setAttribute("error", "新密码格式不正确（6-16位字母+数字）");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 校验两次密码一致
        if (!newPwd.equals(confirmPwd)) {
            request.setAttribute("error", "两次输入的密码不一致");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 校验新密码与原密码不同
        if (newPwd.equals(oldPwd)) {
            request.setAttribute("error", "新密码不能与原密码相同");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // 3. 连接数据库，校验原密码并更新新密码
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 加载JDBC驱动（MySQL 8.0+ 可省略，但建议保留）
            Class.forName(JDBC_DRIVER);

            // 建立数据库连接
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);

            // 第一步：查询原密码是否正确（假设用户表名为user，用户名字段为username，密码字段为password）
            String checkSql = "SELECT password FROM user WHERE username = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setString(1, loginUser);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
                // 用户不存在（理论上不会发生，因为已登录）
                request.setAttribute("error", "用户不存在");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 获取数据库中的原密码（注意：实际项目中密码应加密存储，此处为演示）
            String dbOldPwd = rs.getString("password");
            if (!dbOldPwd.equals(oldPwd)) { // 实际项目中应使用加密后的密码对比（如MD5、BCrypt）
                // 原密码错误
                request.setAttribute("error", "原密码输入错误");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 第二步：更新新密码
            String updateSql = "UPDATE user SET password = ? WHERE username = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, newPwd); // 实际项目中应加密后存储（如BCrypt.hashpw(newPwd, BCrypt.gensalt())）
            pstmt.setString(2, loginUser);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                // 修改成功，销毁当前Session，跳回修改密码页面显示成功弹窗
                session.invalidate(); // 强制退出登录，需重新登录
                request.setAttribute("success", true);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            } else {
                // 修改失败
                request.setAttribute("error", "密码修改失败，请重试");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "数据库驱动加载失败");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "数据库操作异常：" + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } finally {
            // 关闭资源（避免泄露）
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}