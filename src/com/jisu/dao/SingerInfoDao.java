package com.jisu.dao;

import com.jisu.entity.SingerInfo;
import com.jisu.util.DBUtil;

import java.sql.*;

/**
 * 歌手信息数据访问层
 */
public class SingerInfoDao {
    
    /**
     * 获取歌手信息（默认取第一条）
     */
    public SingerInfo get() {
        String sql = "SELECT * FROM singer_info LIMIT 1";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSingerInfo(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    /**
     * 根据ID获取歌手信息
     */
    public SingerInfo findById(Integer id) {
        String sql = "SELECT * FROM singer_info WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSingerInfo(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
        return null;
    }
    
    /**
     * 更新歌手信息
     */
    public boolean update(SingerInfo info) {
        String sql = "UPDATE singer_info SET name = ?, real_name = ?, birthday = ?, birthplace = ?, " +
                     "constellation = ?, height = ?, blood_type = ?, debut_date = ?, company = ?, " +
                     "introduction = ?, achievements = ?, avatar = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, info.getName());
            pstmt.setString(2, info.getRealName());
            pstmt.setDate(3, info.getBirthday() != null ? new java.sql.Date(info.getBirthday().getTime()) : null);
            pstmt.setString(4, info.getBirthplace());
            pstmt.setString(5, info.getConstellation());
            pstmt.setString(6, info.getHeight());
            pstmt.setString(7, info.getBloodType());
            pstmt.setDate(8, info.getDebutDate() != null ? new java.sql.Date(info.getDebutDate().getTime()) : null);
            pstmt.setString(9, info.getCompany());
            pstmt.setString(10, info.getIntroduction());
            pstmt.setString(11, info.getAchievements());
            pstmt.setString(12, info.getAvatar());
            pstmt.setInt(13, info.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt);
        }
        return false;
    }
    
    /**
     * 映射结果集到SingerInfo对象
     */
    private SingerInfo mapResultSetToSingerInfo(ResultSet rs) throws SQLException {
        SingerInfo info = new SingerInfo();
        info.setId(rs.getInt("id"));
        info.setName(rs.getString("name"));
        info.setRealName(rs.getString("real_name"));
        info.setBirthday(rs.getDate("birthday"));
        info.setBirthplace(rs.getString("birthplace"));
        info.setConstellation(rs.getString("constellation"));
        info.setHeight(rs.getString("height"));
        info.setBloodType(rs.getString("blood_type"));
        info.setDebutDate(rs.getDate("debut_date"));
        info.setCompany(rs.getString("company"));
        info.setIntroduction(rs.getString("introduction"));
        info.setAchievements(rs.getString("achievements"));
        info.setAvatar(rs.getString("avatar"));
        info.setUpdateTime(rs.getTimestamp("update_time"));
        return info;
    }
}
