package com.jisu.service;

import com.jisu.dao.SingerInfoDao;
import com.jisu.entity.SingerInfo;

/**
 * 歌手信息业务逻辑层
 */
public class SingerInfoService {
    
    private SingerInfoDao singerInfoDao = new SingerInfoDao();
    
    /**
     * 获取歌手信息
     */
    public SingerInfo get() {
        return singerInfoDao.get();
    }
    
    /**
     * 根据ID获取歌手信息
     */
    public SingerInfo findById(Integer id) {
        return singerInfoDao.findById(id);
    }
    
    /**
     * 更新歌手信息
     */
    public boolean update(SingerInfo info) {
        if (info.getId() == null) {
            return false;
        }
        return singerInfoDao.update(info);
    }
}
