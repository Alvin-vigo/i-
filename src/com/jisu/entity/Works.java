package com.jisu.entity;

import java.util.Date;

/**
 * 作品实体类
 */
public class Works {
    private Integer id;           // 作品ID
    private String type;          // 类型：song-歌曲，album-专辑，variety-综艺，movie-影视
    private String name;          // 作品名称
    private String cover;         // 封面图路径
    private String description;   // 作品简介
    private String lyrics;        // 歌词（歌曲类型适用）
    private Date releaseDate;     // 发布日期
    private String duration;      // 时长
    private Integer playCount;    // 播放/收听次数
    private Integer status;       // 状态：0-下架，1-上架
    private Date createTime;      // 创建时间
    private Date updateTime;      // 更新时间
    
    // 默认构造方法
    public Works() {}
    
    // Getter和Setter方法
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getCover() {
        return cover;
    }
    
    public void setCover(String cover) {
        this.cover = cover;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getLyrics() {
        return lyrics;
    }
    
    public void setLyrics(String lyrics) {
        this.lyrics = lyrics;
    }
    
    public Date getReleaseDate() {
        return releaseDate;
    }
    
    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public Integer getPlayCount() {
        return playCount;
    }
    
    public void setPlayCount(Integer playCount) {
        this.playCount = playCount;
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
     * 获取类型的中文名称
     */
    public String getTypeName() {
        if (type == null) return "";
        switch (type) {
            case "song": return "歌曲";
            case "album": return "专辑";
            case "variety": return "综艺";
            case "movie": return "影视";
            default: return type;
        }
    }
    
    /**
     * 格式化播放次数（如：9876万）
     */
    public String getFormattedPlayCount() {
        if (playCount == null) return "0";
        if (playCount >= 100000000) {
            return String.format("%.1f亿", playCount / 100000000.0);
        } else if (playCount >= 10000) {
            return String.format("%.1f万", playCount / 10000.0);
        }
        return playCount.toString();
    }
    
    @Override
    public String toString() {
        return "Works{" +
                "id=" + id +
                ", type='" + type + '\'' +
                ", name='" + name + '\'' +
                ", releaseDate=" + releaseDate +
                ", playCount=" + playCount +
                '}';
    }
}
