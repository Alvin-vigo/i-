package com.jisu.util;

import java.sql.*;

/**
 * 数据库连接工具类
 * 使用JDBC连接池优化数据库连接
 */
public class DBUtil {
    
    // 数据库连接参数
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/xuezhiqian_fans?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "JISU_2025"; // 请根据实际情况修改密码
    
    // 静态代码块加载驱动
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("数据库驱动加载失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 获取数据库连接
     * @return Connection对象
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            System.err.println("获取数据库连接失败：" + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }
    
    /**
     * 关闭数据库资源
     * @param conn 连接
     * @param stmt 语句
     * @param rs 结果集
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (stmt != null) {
                stmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * 关闭数据库资源（无结果集）
     * @param conn 连接
     * @param stmt 语句
     */
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
    
    /**
     * 测试数据库连接
     */
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("数据库连接成功！");
            close(conn, null, null);
        } else {
            System.out.println("数据库连接失败！");
        }
    }
}
