package com.jisu.dao;

import com.jisu.entity.Message;
import com.jisu.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 留言数据访问层
 */
public class MessageDao {
    
    /**
     * 查询所有留言（分页，关联用户信息）
     */
    public List<Message> findAll(int page, int pageSize) {
        String sql = "SELECT m.*, u.username, u.avatar FROM message m " +
                     "LEFT JOIN user u ON m.user_id = u.id " +
                     "WHERE m.status = 1 AND m.is_violation = 0 AND m.parent_id IS NULL " +
                     "ORDER BY m.create_time DESC LIMIT ?, ?";
        return executeQueryWithUser(sql, (page - 1) * pageSize, pageSize);
    }
    
    /**
     * 查询所有留言（管理员，包括违规）
     */
    public List<Message> findAllAdmin(int page, int pageSize) {
        String sql = "SELECT m.*, u.username, u.avatar FROM message m " +
                     "LEFT JOIN user u ON m.user_id = u.id " +
                     "WHERE m.status = 1 AND m.parent_id IS NULL " +
                     "ORDER BY m.create_time DESC LIMIT ?, ?";
        return executeQueryWithUser(sql, (page - 1) * pageSize, pageSize);
    }
    
    /**
     * 根据用户ID查询留言
     */
    public List<Message> findByUserId(Integer userId, int page, int pageSize) {
        String sql = "SELECT m.*, u.username, u.avatar FROM message m " +
                     "LEFT JOIN user u ON m.user_id = u.id " +
                     "WHERE m.user_id = ? AND m.status = 1 " +
                     "ORDER BY m.create_time DESC LIMIT ?, ?";
        List<Message> messages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, (page - 1) * pageSize);
            pstmt.setInt(3, pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                messages.add(mapResultSetToMessage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return messages;
    }
    
    /**
     * 根据ID查询留言
     */
    public Message findById(Integer id) {
        String sql = "SELECT m.*, u.username, u.avatar FROM message m " +
                     "LEFT JOIN user u ON m.user_id = u.id " +
                     "WHERE m.id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToMessage(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    /**
     * 发布留言
     */
    public boolean add(Message message) {
        String sql = "INSERT INTO message (user_id, content, parent_id, like_count, is_violation, status) VALUES (?, ?, ?, 0, 0, 1)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, message.getUserId());
            pstmt.setString(2, message.getContent());
            if (message.getParentId() != null) {
                pstmt.setInt(3, message.getParentId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            
            int result = pstmt.executeUpdate();
            
            // 如果插入成功，设置生成的ID
            if (result > 0) {
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    message.setId(generatedKeys.getInt(1));
                }
                generatedKeys.close();
            }
            
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 删除留言（软删除）
     */
    public boolean delete(Integer id) {
        String sql = "UPDATE message SET status = 0 WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 点赞留言
     */
    public boolean like(Integer messageId, Integer userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            // 检查是否已点赞
            String checkSql = "SELECT COUNT(*) FROM message_like WHERE user_id = ? AND message_id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, messageId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // 已点赞，取消点赞
                String deleteSql = "DELETE FROM message_like WHERE user_id = ? AND message_id = ?";
                pstmt = conn.prepareStatement(deleteSql);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, messageId);
                pstmt.executeUpdate();
                
                // 减少点赞数
                String updateSql = "UPDATE message SET like_count = like_count - 1 WHERE id = ? AND like_count > 0";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setInt(1, messageId);
                pstmt.executeUpdate();
            } else {
                // 未点赞，添加点赞
                String insertSql = "INSERT INTO message_like (user_id, message_id) VALUES (?, ?)";
                pstmt = conn.prepareStatement(insertSql);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, messageId);
                pstmt.executeUpdate();
                
                // 增加点赞数
                String updateSql = "UPDATE message SET like_count = like_count + 1 WHERE id = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setInt(1, messageId);
                pstmt.executeUpdate();
            }
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 检查用户是否已点赞
     */
    public boolean hasLiked(Integer messageId, Integer userId) {
        String sql = "SELECT COUNT(*) FROM message_like WHERE user_id = ? AND message_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, messageId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return false;
    }
    
    /**
     * 标记违规留言
     */
    public boolean markViolation(Integer id) {
        String sql = "UPDATE message SET is_violation = 1 WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 取消违规标记
     */
    public boolean unmarkViolation(Integer id) {
        String sql = "UPDATE message SET is_violation = 0 WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 统计留言总数
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM message WHERE status = 1 AND is_violation = 0 AND parent_id IS NULL";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }
    
    /**
     * 统计用户留言数
     */
    public int countByUserId(Integer userId) {
        String sql = "SELECT COUNT(*) FROM message WHERE user_id = ? AND status = 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return 0;
    }
    
    /**
     * 获取留言的回复列表
     */
    public List<Message> findReplies(Integer parentId) {
        String sql = "SELECT m.*, u.username, u.avatar FROM message m " +
                     "LEFT JOIN user u ON m.user_id = u.id " +
                     "WHERE m.parent_id = ? AND m.status = 1 AND m.is_violation = 0 " +
                     "ORDER BY m.create_time ASC";
        List<Message> messages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, parentId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                messages.add(mapResultSetToMessage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return messages;
    }
    
    /**
     * 执行查询（分页，关联用户）
     */
    private List<Message> executeQueryWithUser(String sql, int offset, int limit) {
        List<Message> messages = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, offset);
            pstmt.setInt(2, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                messages.add(mapResultSetToMessage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return messages;
    }
    
    /**
     * 映射结果集到Message对象
     */
    private Message mapResultSetToMessage(ResultSet rs) throws SQLException {
        Message message = new Message();
        message.setId(rs.getInt("id"));
        message.setUserId(rs.getInt("user_id"));
        message.setContent(rs.getString("content"));
        
        int parentId = rs.getInt("parent_id");
        if (!rs.wasNull()) {
            message.setParentId(parentId);
        }
        
        message.setLikeCount(rs.getInt("like_count"));
        message.setIsViolation(rs.getInt("is_violation"));
        message.setStatus(rs.getInt("status"));
        message.setCreateTime(rs.getTimestamp("create_time"));
        message.setUpdateTime(rs.getTimestamp("update_time"));
        
        // 关联用户信息
        message.setUsername(rs.getString("username"));
        message.setAvatar(rs.getString("avatar"));
        
        return message;
    }
}
