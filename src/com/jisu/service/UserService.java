package com.jisu.service;

import com.jisu.dao.UserDao;
import com.jisu.entity.User;

import java.util.List;

/**
 * 用户业务逻辑层
 */
public class UserService {
    
    private UserDao userDao = new UserDao();
    
    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功返回User对象，失败返回null
     */
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            return null;
        }
        return userDao.login(username.trim(), password);
    }
    
    /**
     * 用户注册
     * @param user 用户信息
     * @return 注册结果：0-成功，1-用户名已存在，2-注册失败
     */
    public int register(User user) {
        // 检查用户名是否已存在
        User existUser = userDao.findByUsername(user.getUsername());
        if (existUser != null) {
            return 1; // 用户名已存在
        }
        
        // 执行注册
        boolean result = userDao.register(user);
        return result ? 0 : 2; // 0-成功，2-失败
    }
    
    /**
     * 根据用户名查询用户
     */
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }
    
    /**
     * 根据ID查询用户
     */
    public User findById(Integer id) {
        return userDao.findById(id);
    }
    
    /**
     * 更新用户信息
     */
    public boolean update(User user) {
        return userDao.update(user);
    }
    
    /**
     * 修改密码
     * @param userId 用户ID
     * @param oldPassword 原密码
     * @param newPassword 新密码
     * @return 修改结果：0-成功，1-原密码错误，2-修改失败
     */
    public int updatePassword(Integer userId, String oldPassword, String newPassword) {
        // 验证原密码
        User user = userDao.findById(userId);
        if (user == null || !user.getPassword().equals(oldPassword)) {
            return 1; // 原密码错误
        }
        
        // 修改密码
        boolean result = userDao.updatePassword(userId, newPassword);
        return result ? 0 : 2;
    }
    
    /**
     * 查询所有用户（分页）
     */
    public List<User> findAll(int page, int pageSize) {
        return userDao.findAll(page, pageSize);
    }
    
    /**
     * 统计用户总数
     */
    public int countAll() {
        return userDao.countAll();
    }
    
    /**
     * 更新用户状态（禁用/启用）
     */
    public boolean updateStatus(Integer userId, Integer status) {
        return userDao.updateStatus(userId, status);
    }
    
    /**
     * 验证密码格式（6-16位，包含字母和数字）
     */
    public boolean validatePassword(String password) {
        if (password == null) return false;
        return password.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,16}$");
    }
    
    /**
     * 验证手机号格式
     */
    public boolean validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) return true; // 允许为空
        return phone.matches("^1[3-9]\\d{9}$");
    }
    
    /**
     * 验证邮箱格式
     */
    public boolean validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) return true; // 允许为空
        return email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    }
}
