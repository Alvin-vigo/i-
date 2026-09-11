package com.jisu.service;

import com.jisu.dao.MessageDao;
import com.jisu.entity.Message;

import java.util.List;

/**
 * 留言业务逻辑层
 */
public class MessageService {
    
    private MessageDao messageDao = new MessageDao();
    
    // 违禁词列表（可扩展）
    private static final String[] FORBIDDEN_WORDS = {
        "广告", "推广", "微信", "QQ群", "色情", "赌博"
    };
    
    /**
     * 查询所有留言（分页）
     */
    public List<Message> findAll(int page, int pageSize) {
        return messageDao.findAll(page, pageSize);
    }
    
    /**
     * 查询所有留言（管理员）
     */
    public List<Message> findAllAdmin(int page, int pageSize) {
        return messageDao.findAllAdmin(page, pageSize);
    }
    
    /**
     * 根据用户ID查询留言
     */
    public List<Message> findByUserId(Integer userId, int page, int pageSize) {
        return messageDao.findByUserId(userId, page, pageSize);
    }
    
    /**
     * 根据ID查询留言
     */
    public Message findById(Integer id) {
        return messageDao.findById(id);
    }
    
    /**
     * 发布留言
     * @param message 留言信息
     * @return 发布结果：0-成功，1-内容为空，2-包含违禁词，3-发布失败
     */
    public int add(Message message) {
        // 检查内容是否为空
        if (message.getContent() == null || message.getContent().trim().isEmpty()) {
            return 1;
        }
        
        // 检查是否包含违禁词
        String content = message.getContent().trim();
        for (String word : FORBIDDEN_WORDS) {
            if (content.contains(word)) {
                return 2;
            }
        }
        
        // 发布留言
        message.setContent(content);
        boolean result = messageDao.add(message);
        return result ? 0 : 3;
    }
    
    /**
     * 删除留言
     */
    public boolean delete(Integer id) {
        return messageDao.delete(id);
    }
    
    /**
     * 点赞/取消点赞
     */
    public boolean like(Integer messageId, Integer userId) {
        return messageDao.like(messageId, userId);
    }
    
    /**
     * 检查用户是否已点赞
     */
    public boolean hasLiked(Integer messageId, Integer userId) {
        return messageDao.hasLiked(messageId, userId);
    }
    
    /**
     * 标记违规留言
     */
    public boolean markViolation(Integer id) {
        return messageDao.markViolation(id);
    }
    
    /**
     * 取消违规标记
     */
    public boolean unmarkViolation(Integer id) {
        return messageDao.unmarkViolation(id);
    }
    
    /**
     * 统计留言总数
     */
    public int countAll() {
        return messageDao.countAll();
    }
    
    /**
     * 统计用户留言数
     */
    public int countByUserId(Integer userId) {
        return messageDao.countByUserId(userId);
    }
    
    /**
     * 获取留言的回复列表
     */
    public List<Message> findReplies(Integer parentId) {
        return messageDao.findReplies(parentId);
    }
    
    /**
     * 计算总页数
     */
    public int getTotalPages(int totalCount, int pageSize) {
        return (int) Math.ceil((double) totalCount / pageSize);
    }
    
    /**
     * 检查用户是否可以删除留言
     * @param messageId 留言ID
     * @param userId 用户ID
     * @param isAdmin 是否是管理员
     * @return 是否可以删除
     */
    public boolean canDelete(Integer messageId, Integer userId, boolean isAdmin) {
        if (isAdmin) return true; // 管理员可以删除任何留言
        
        Message message = messageDao.findById(messageId);
        if (message == null) return false;
        
        // 只能删除自己的留言
        return message.getUserId().equals(userId);
    }
}
