package com.jisu.service;

import com.jisu.dao.WorksDao;
import com.jisu.entity.Works;

import java.util.List;

/**
 * 作品业务逻辑层
 */
public class WorksService {
    
    private WorksDao worksDao = new WorksDao();
    
    /**
     * 查询所有作品（分页）
     */
    public List<Works> findAll(int page, int pageSize) {
        return worksDao.findAll(page, pageSize);
    }
    
    /**
     * 按类型查询作品（分页）
     * @param type 类型：song-歌曲，album-专辑，variety-综艺，movie-影视
     */
    public List<Works> findByType(String type, int page, int pageSize) {
        return worksDao.findByType(type, page, pageSize);
    }
    
    /**
     * 搜索作品（按名称/年份）
     */
    public List<Works> search(String keyword, String year, int page, int pageSize) {
        return worksDao.search(keyword, year, page, pageSize);
    }
    
    /**
     * 根据ID查询作品
     */
    public Works findById(Integer id) {
        return worksDao.findById(id);
    }
    
    /**
     * 添加作品
     */
    public boolean add(Works works) {
        // 参数校验
        if (works.getName() == null || works.getName().trim().isEmpty()) {
            return false;
        }
        if (works.getType() == null || works.getType().trim().isEmpty()) {
            return false;
        }
        return worksDao.add(works);
    }
    
    /**
     * 更新作品
     */
    public boolean update(Works works) {
        if (works.getId() == null) {
            return false;
        }
        return worksDao.update(works);
    }
    
    /**
     * 删除作品
     */
    public boolean delete(Integer id) {
        return worksDao.delete(id);
    }
    
    /**
     * 统计作品总数
     */
    public int countAll() {
        return worksDao.countAll();
    }
    
    /**
     * 按类型统计作品数量
     */
    public int countByType(String type) {
        return worksDao.countByType(type);
    }
    
    /**
     * 获取热门作品
     */
    public List<Works> findHot(int limit) {
        return worksDao.findHot(limit);
    }
    
    /**
     * 获取最新作品
     */
    public List<Works> findLatest(int limit) {
        return worksDao.findLatest(limit);
    }
    
    /**
     * 计算总页数
     */
    public int getTotalPages(int totalCount, int pageSize) {
        return (int) Math.ceil((double) totalCount / pageSize);
    }
    
    /**
     * 计算某类型的总页数
     */
    public int getTotalPagesByType(String type, int pageSize) {
        int count = countByType(type);
        return getTotalPages(count, pageSize);
    }
    
    /**
     * 验证作品类型
     */
    public boolean isValidType(String type) {
        return "song".equals(type) || "album".equals(type) || 
               "variety".equals(type) || "movie".equals(type);
    }
}
