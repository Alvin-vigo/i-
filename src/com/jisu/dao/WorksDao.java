package com.jisu.dao;

import com.jisu.entity.Works;
import com.jisu.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 作品数据访问层
 */
public class WorksDao {
    
    /**
     * 查询所有作品（分页）
     */
    public List<Works> findAll(int page, int pageSize) {
        String sql = "SELECT * FROM works WHERE status = 1 ORDER BY release_date DESC LIMIT ?, ?";
        return executeQuery(sql, (page - 1) * pageSize, pageSize);
    }
    
    /**
     * 按类型查询作品（分页）
     */
    public List<Works> findByType(String type, int page, int pageSize) {
        String sql = "SELECT * FROM works WHERE type = ? AND status = 1 ORDER BY release_date DESC LIMIT ?, ?";
        List<Works> works = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, type);
            pstmt.setInt(2, (page - 1) * pageSize);
            pstmt.setInt(3, pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                works.add(mapResultSetToWorks(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return works;
    }
    
    /**
     * 搜索作品（按名称/年份）
     */
    public List<Works> search(String keyword, String year, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM works WHERE status = 1");
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (year != null && !year.trim().isEmpty()) {
            sql.append(" AND YEAR(release_date) = ?");
            params.add(Integer.parseInt(year));
        }
        
        sql.append(" ORDER BY release_date DESC LIMIT ?, ?");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        
        List<Works> works = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                works.add(mapResultSetToWorks(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return works;
    }
    
    /**
     * 根据ID查询作品
     */
    public Works findById(Integer id) {
        String sql = "SELECT * FROM works WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToWorks(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    /**
     * 添加作品
     */
    public boolean add(Works works) {
        String sql = "INSERT INTO works (type, name, cover, description, lyrics, release_date, duration, play_count, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, works.getType());
            pstmt.setString(2, works.getName());
            pstmt.setString(3, works.getCover());
            pstmt.setString(4, works.getDescription());
            pstmt.setString(5, works.getLyrics());
            pstmt.setDate(6, works.getReleaseDate() != null ? new java.sql.Date(works.getReleaseDate().getTime()) : null);
            pstmt.setString(7, works.getDuration());
            pstmt.setInt(8, works.getPlayCount() != null ? works.getPlayCount() : 0);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 更新作品
     */
    public boolean update(Works works) {
        String sql = "UPDATE works SET type = ?, name = ?, cover = ?, description = ?, lyrics = ?, release_date = ?, duration = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, works.getType());
            pstmt.setString(2, works.getName());
            pstmt.setString(3, works.getCover());
            pstmt.setString(4, works.getDescription());
            pstmt.setString(5, works.getLyrics());
            pstmt.setDate(6, works.getReleaseDate() != null ? new java.sql.Date(works.getReleaseDate().getTime()) : null);
            pstmt.setString(7, works.getDuration());
            pstmt.setInt(8, works.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 删除作品（软删除）
     */
    public boolean delete(Integer id) {
        String sql = "UPDATE works SET status = 0 WHERE id = ?";
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
     * 统计作品总数
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM works WHERE status = 1";
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
     * 按类型统计作品数量
     */
    public int countByType(String type) {
        String sql = "SELECT COUNT(*) FROM works WHERE type = ? AND status = 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, type);
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
     * 获取热门作品
     */
    public List<Works> findHot(int limit) {
        String sql = "SELECT * FROM works WHERE status = 1 ORDER BY play_count DESC LIMIT ?";
        return executeQueryWithLimit(sql, limit);
    }
    
    /**
     * 获取最新作品
     */
    public List<Works> findLatest(int limit) {
        String sql = "SELECT * FROM works WHERE status = 1 ORDER BY release_date DESC LIMIT ?";
        return executeQueryWithLimit(sql, limit);
    }
    
    /**
     * 执行查询（分页）
     */
    private List<Works> executeQuery(String sql, int offset, int limit) {
        List<Works> works = new ArrayList<>();
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
                works.add(mapResultSetToWorks(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return works;
    }
    
    /**
     * 执行查询（限制数量）
     */
    private List<Works> executeQueryWithLimit(String sql, int limit) {
        List<Works> works = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                works.add(mapResultSetToWorks(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return works;
    }
    
    /**
     * 映射结果集到Works对象
     */
    private Works mapResultSetToWorks(ResultSet rs) throws SQLException {
        Works works = new Works();
        works.setId(rs.getInt("id"));
        works.setType(rs.getString("type"));
        works.setName(rs.getString("name"));
        works.setCover(rs.getString("cover"));
        works.setDescription(rs.getString("description"));
        works.setLyrics(rs.getString("lyrics"));
        works.setReleaseDate(rs.getDate("release_date"));
        works.setDuration(rs.getString("duration"));
        works.setPlayCount(rs.getInt("play_count"));
        works.setStatus(rs.getInt("status"));
        works.setCreateTime(rs.getTimestamp("create_time"));
        works.setUpdateTime(rs.getTimestamp("update_time"));
        return works;
    }
}
