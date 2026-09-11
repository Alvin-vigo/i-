package com.jisu.entity;

import java.util.Date;

/**
 * 歌手信息实体类
 */
public class SingerInfo {
    private Integer id;           // ID
    private String name;          // 艺名
    private String realName;      // 本名
    private Date birthday;        // 生日
    private String birthplace;    // 籍贯
    private String constellation; // 星座
    private String height;        // 身高
    private String bloodType;     // 血型
    private Date debutDate;       // 出道日期
    private String company;       // 经纪公司
    private String introduction;  // 个人简介
    private String achievements;  // 成就荣誉
    private String avatar;        // 头像
    private Date updateTime;      // 更新时间
    
    // 默认构造方法
    public SingerInfo() {}
    
    // Getter和Setter方法
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getRealName() {
        return realName;
    }
    
    public void setRealName(String realName) {
        this.realName = realName;
    }
    
    public Date getBirthday() {
        return birthday;
    }
    
    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }
    
    public String getBirthplace() {
        return birthplace;
    }
    
    public void setBirthplace(String birthplace) {
        this.birthplace = birthplace;
    }
    
    public String getConstellation() {
        return constellation;
    }
    
    public void setConstellation(String constellation) {
        this.constellation = constellation;
    }
    
    public String getHeight() {
        return height;
    }
    
    public void setHeight(String height) {
        this.height = height;
    }
    
    public String getBloodType() {
        return bloodType;
    }
    
    public void setBloodType(String bloodType) {
        this.bloodType = bloodType;
    }
    
    public Date getDebutDate() {
        return debutDate;
    }
    
    public void setDebutDate(Date debutDate) {
        this.debutDate = debutDate;
    }
    
    public String getCompany() {
        return company;
    }
    
    public void setCompany(String company) {
        this.company = company;
    }
    
    public String getIntroduction() {
        return introduction;
    }
    
    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }
    
    public String getAchievements() {
        return achievements;
    }
    
    public void setAchievements(String achievements) {
        this.achievements = achievements;
    }
    
    public String getAvatar() {
        return avatar;
    }
    
    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }
    
    public Date getUpdateTime() {
        return updateTime;
    }
    
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
    
    @Override
    public String toString() {
        return "SingerInfo{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", birthday=" + birthday +
                ", birthplace='" + birthplace + '\'' +
                '}';
    }
}
