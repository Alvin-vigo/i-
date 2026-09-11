package com.jisu;

import com.jisu.entity.Works;
import com.jisu.service.WorksService;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * 作品Servlet - 处理作品查询/分类/搜索
 */
public class WorksServlet extends HttpServlet {
    
    private WorksService worksService = new WorksService();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                handleList(request, response);
                break;
            case "type":
                handleByType(request, response);
                break;
            case "search":
                handleSearch(request, response);
                break;
            case "detail":
                handleDetail(request, response);
                break;
            case "hot":
                handleHot(request, response);
                break;
            case "latest":
                handleLatest(request, response);
                break;
            default:
                handleList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * 查询所有作品（分页）
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        List<Works> worksList = worksService.findAll(page, pageSize);
        int total = worksService.countAll();
        int totalPages = worksService.getTotalPages(total, pageSize);
        
        sendWorksList(response, worksList, page, totalPages, total);
    }
    
    /**
     * 按类型查询作品
     */
    private void handleByType(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String type = request.getParameter("type");
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        if (type == null || !worksService.isValidType(type)) {
            sendError(response, "无效的作品类型");
            return;
        }
        
        List<Works> worksList = worksService.findByType(type, page, pageSize);
        int total = worksService.countByType(type);
        int totalPages = worksService.getTotalPages(total, pageSize);
        
        sendWorksList(response, worksList, page, totalPages, total);
    }
    
    /**
     * 搜索作品
     */
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String keyword = request.getParameter("keyword");
        String year = request.getParameter("year");
        int page = getIntParam(request, "page", 1);
        int pageSize = getIntParam(request, "pageSize", 10);
        
        List<Works> worksList = worksService.search(keyword, year, page, pageSize);
        
        sendWorksList(response, worksList, page, 1, worksList.size());
    }
    
    /**
     * 查询作品详情
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int id = getIntParam(request, "id", 0);
        
        if (id <= 0) {
            sendError(response, "无效的作品ID");
            return;
        }
        
        Works works = worksService.findById(id);
        
        if (works == null) {
            sendError(response, "作品不存在");
            return;
        }
        
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"data\":");
        out.print(worksToJson(works));
        out.print("}");
    }
    
    /**
     * 获取热门作品
     */
    private void handleHot(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int limit = getIntParam(request, "limit", 6);
        List<Works> worksList = worksService.findHot(limit);
        sendWorksList(response, worksList, 1, 1, worksList.size());
    }
    
    /**
     * 获取最新作品
     */
    private void handleLatest(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        int limit = getIntParam(request, "limit", 6);
        List<Works> worksList = worksService.findLatest(limit);
        sendWorksList(response, worksList, 1, 1, worksList.size());
    }
    
    /**
     * 发送作品列表响应
     */
    private void sendWorksList(HttpServletResponse response, List<Works> worksList, 
            int page, int totalPages, int total) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"code\":0,\"data\":{");
        out.print("\"list\":[");
        
        for (int i = 0; i < worksList.size(); i++) {
            if (i > 0) out.print(",");
            out.print(worksToJson(worksList.get(i)));
        }
        
        out.print("],");
        out.print("\"page\":" + page + ",");
        out.print("\"totalPages\":" + totalPages + ",");
        out.print("\"total\":" + total);
        out.print("}}");
    }
    
    /**
     * 将Works对象转换为JSON字符串
     */
    private String worksToJson(Works works) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"id\":").append(works.getId()).append(",");
        sb.append("\"type\":\"").append(escapeJson(works.getType())).append("\",");
        sb.append("\"typeName\":\"").append(escapeJson(works.getTypeName())).append("\",");
        sb.append("\"name\":\"").append(escapeJson(works.getName())).append("\",");
        sb.append("\"cover\":\"").append(escapeJson(works.getCover())).append("\",");
        sb.append("\"description\":\"").append(escapeJson(works.getDescription())).append("\",");
        sb.append("\"lyrics\":\"").append(escapeJson(works.getLyrics())).append("\",");
        sb.append("\"releaseDate\":\"").append(works.getReleaseDate() != null ? sdf.format(works.getReleaseDate()) : "").append("\",");
        sb.append("\"duration\":\"").append(escapeJson(works.getDuration())).append("\",");
        sb.append("\"playCount\":").append(works.getPlayCount()).append(",");
        sb.append("\"formattedPlayCount\":\"").append(works.getFormattedPlayCount()).append("\"");
        sb.append("}");
        return sb.toString();
    }
    
    /**
     * 转义JSON特殊字符
     */
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
    
    private int getIntParam(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        try {
            return value != null ? Integer.parseInt(value) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        PrintWriter out = response.getWriter();
        out.print("{\"code\":1,\"message\":\"" + message + "\"}");
    }
}
