package com.jisu;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class VideoServlet extends HttpServlet {
    // 视频文件根目录（src/data/video）
    private static final String VIDEO_BASE_PATH = "I:/zx/finish/download_files/mv/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 获取视频文件名
        String fileName = request.getParameter("fileName");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "缺少视频文件名");
            return;
        }

        // 构建视频文件路径
        File videoFile = new File(VIDEO_BASE_PATH + fileName);
        if (!videoFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "视频文件不存在");
            return;
        }

        // 设置响应头
        response.setContentType("video/mp4");
        response.setContentLength((int) videoFile.length());
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");

        // 读取视频文件并输出
        try (InputStream in = new FileInputStream(videoFile);
             ServletOutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "视频播放出错");
        }
    }
}