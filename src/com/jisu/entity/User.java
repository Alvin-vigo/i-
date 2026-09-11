package com.jisu.entity;

import java.util.Date;

/**
 * 用户实体类
 */
public class User {
    private Integer id;           // 用户ID
    private String username;      // 用户名
    private String password;      // 密码
    private String phone;         // 手机号
    private String email;         // 邮箱
    private String avatar;        // 头像路径
    private Integer role;         // 角色：0-普通用户，1-管理员
    private Integer status;       // 状态：0-禁用，1-正常
    private Date createTime;      // 注册时间
    private Date updateTime;      // 更新时间
    
    // 默认构造方法
    public User() {}
    
    // 带参构造方法
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    // Getter和Setter方法
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAvatar() {
        return avatar;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    
    public Integer getRole() {
        return role;
    }
    
    public void setRole(Integer role) {
        this.role = role;
    }
    
    public Integer getStatus() {
        return status;
    }
    
    public void setStatus(Integer status) {
        this.status = status;
    }
    
    public Date getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
    
    public Date getUpdateTime() {
        return updateTime;
    }
    
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
    
    /**
     * 判断是否为管理员
     */
    public boolean isAdmin() {
        return role != null && role == 1;
    }
    
    /**
     * 判断账号是否正常
     */
    public boolean isActive() {
        return status != null && status == 1;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", phone='" + phone + '\'' +
                ", role=" + role +
                ", status=" + status +
                ", createTime=" + createTime +
                '}';
    }
}
