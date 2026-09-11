package com.jisu;

import com.jisu.entity.SingerInfo;
import com.jisu.service.SingerInfoService;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;

/**
 * 歌手信息Servlet - 返回薛之谦资料数据
 */
public class InfoServlet extends HttpServlet {
    
    private SingerInfoService singerInfoService = new SingerInfoService();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        SingerInfo info = singerInfoService.get();
        
        if (info != null) {
            PrintWriter out = response.getWriter();
            out.print("{\"code\":0,\"data\":");
            out.print(singerInfoToJson(info));
            out.print("}");
        } else {
            PrintWriter out = response.getWriter();
            out.print("{\"code\":1,\"message\":\"暂无歌手信息\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 将SingerInfo对象转换为JSON字符串
     */
    private String singerInfoToJson(SingerInfo info) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"id\":").append(info.getId()).append(",");
        sb.append("\"name\":\"").append(escapeJson(info.getName())).append("\",");
        sb.append("\"realName\":\"").append(escapeJson(info.getRealName())).append("\",");
        sb.append("\"birthday\":\"").append(info.getBirthday() != null ? sdf.format(info.getBirthday()) : "").append("\",");
        sb.append("\"birthplace\":\"").append(escapeJson(info.getBirthplace())).append("\",");
        sb.append("\"constellation\":\"").append(escapeJson(info.getConstellation())).append("\",");
        sb.append("\"height\":\"").append(escapeJson(info.getHeight())).append("\",");
        sb.append("\"bloodType\":\"").append(escapeJson(info.getBloodType())).append("\",");
        sb.append("\"debutDate\":\"").append(info.getDebutDate() != null ? sdf.format(info.getDebutDate()) : "").append("\",");
        sb.append("\"company\":\"").append(escapeJson(info.getCompany())).append("\",");
        sb.append("\"introduction\":\"").append(escapeJson(info.getIntroduction())).append("\",");
        sb.append("\"achievements\":\"").append(escapeJson(info.getAchievements())).append("\",");
        sb.append("\"avatar\":\"").append(escapeJson(info.getAvatar())).append("\"");
        sb.append("}");
        return sb.toString();
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
