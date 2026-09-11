package com.jisu.entity;

import java.util.Date;

/**
 * 留言实体类
 */
public class Message {
    private Integer id;           // 留言ID
    private Integer userId;       // 用户ID
    private String content;       // 留言内容
    private Integer parentId;     // 父留言ID（回复时使用）
    private Integer likeCount;    // 点赞数
    private Integer isViolation;  // 是否违规：0-正常，1-违规
    private Integer status;       // 状态：0-删除，1-正常
    private Date createTime;      // 发布时间
    private Date updateTime;      // 更新时间
    
    // 关联用户信息（非数据库字段）
    private String username;      // 用户名（关联查询）
    private String avatar;        // 用户头像（关联查询）
    
    // 默认构造方法
    public Message() {}
    
    // Getter和Setter方法
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
        this.userId = userId;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Integer getParentId() {
        return parentId;
    }
    
    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }
    
    public Integer getLikeCount() {
        return likeCount;
    }
    
    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }
    
    public Integer getIsViolation() {
        return isViolation;
    }
    
    public void setIsViolation(Integer isViolation) {
        this.isViolation = isViolation;
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
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getAvatar() {
        return avatar;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    
    /**
     * 判断留言是否正常（未删除、未违规）
     */
    public boolean isValid() {
        return status != null && status == 1 && 
               (isViolation == null || isViolation == 0);
    }
    
    @Override
    public String toString() {
        return "Message{" +
                "id=" + id +
                ", userId=" + userId +
                ", content='" + content + '\'' +
                ", likeCount=" + likeCount +
                ", createTime=" + createTime +
                '}';
    }
}
