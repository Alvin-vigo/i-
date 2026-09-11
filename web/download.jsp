<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 检查登录状态
    if (session.getAttribute("loginUser") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>资源下载 | i谦之家</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #1a1815 100%); min-height: 100vh; color: #f0f0f0; }
        
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background: rgba(0,0,0,0.9); backdrop-filter: blur(10px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(212,175,55,0.2); }
        .logo { font-size: 28px; font-weight: 700; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 2px; text-decoration: none; }
        .nav-links { display: flex; gap: 35px; }
        .nav-links a { color: #f0f0f0; text-decoration: none; font-size: 15px; transition: all 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: #d4af37; }
        .nav-right a { padding: 8px 20px; border-radius: 20px; text-decoration: none; font-size: 14px; color: #d4af37; border: 1px solid #d4af37; margin-left: 10px; }
        
        .main-content { margin-top: 100px; max-width: 1200px; margin-left: auto; margin-right: auto; padding: 0 20px 60px; }
        
        .page-title { text-align: center; margin-bottom: 40px; }
        .page-title h1 { font-size: 36px; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 10px; }
        .page-title p { color: #888; font-size: 14px; }
        
        /* 下载分类 */
        .download-categories { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; margin-bottom: 40px; }
        .category-card { background: linear-gradient(135deg, #1a1815 0%, #252220 100%); border-radius: 16px; padding: 35px 25px; text-align: center; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; cursor: pointer; }
        .category-card:hover { transform: translateY(-8px); border-color: rgba(212,175,55,0.3); box-shadow: 0 15px 40px rgba(0,0,0,0.3); }
        .category-icon { font-size: 48px; margin-bottom: 20px; }
        .category-card h3 { color: #f8e190; font-size: 20px; margin-bottom: 10px; }
        .category-card p { color: #888; font-size: 13px; line-height: 1.6; }
        
        /* 文件列表 */
        .file-section { background: #1a1815; border-radius: 16px; padding: 25px; margin-bottom: 30px; border: 1px solid rgba(212,175,55,0.1); display: none; }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid rgba(212,175,55,0.1); }
        .section-header h3 { color: #f0f0f0; font-size: 20px; }
        .file-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .file-card { background: rgba(0,0,0,0.3); border-radius: 12px; padding: 20px; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; }
        .file-card:hover { border-color: rgba(212,175,55,0.3); transform: translateY(-3px); }
        .file-icon { font-size: 36px; text-align: center; margin-bottom: 15px; }
        .file-info h4 { color: #f0f0f0; font-size: 15px; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .file-meta { display: flex; justify-content: space-between; color: #888; font-size: 12px; margin-top: 10px; }
        
        /* 媒体预览 */
        .media-preview { margin-top: 15px; text-align: center; }
        .audio-preview { width: 100%; }
        .image-preview { max-width: 100%; height: 150px; object-fit: cover; border-radius: 8px; }
        .video-preview { width: 100%; height: 150px; background: #000; border-radius: 8px; display: flex; align-items: center; justify-content: center; cursor: pointer; }
        .video-preview span { color: #d4af37; }
        
        .loading { text-align: center; padding: 40px; color: #888; }
        .empty-tip { text-align: center; padding: 40px 20px; color: #666; }
        .empty-tip span { font-size: 48px; display: block; margin-bottom: 15px; }
        
        @media (max-width: 992px) { 
            .download-categories, .file-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) { 
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; }
            .download-categories, .file-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">i谦之家</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/info.jsp">歌手资料</a>
            <a href="${pageContext.request.contextPath}/works.jsp">作品展示</a>
            <a href="${pageContext.request.contextPath}/forum.jsp">粉丝互动</a>
            <a href="${pageContext.request.contextPath}/download.jsp" class="active">资源下载</a>
        </div>
        <div class="nav-right">
            <a href="${pageContext.request.contextPath}/user.jsp">个人中心</a>
            <a href="${pageContext.request.contextPath}/logout">退出</a>
        </div>
    </nav>

    <div class="main-content">
        <div class="page-title">
            <h1>📥 资源中心</h1>
            <p>欣赏薛之谦的音乐、视频和精美图片</p>
        </div>
        
        <!-- 下载分类 -->
        <div class="download-categories">
            <div class="category-card" onclick="showCategory('music')">
                <div class="category-icon">🎵</div>
                <h3>音乐欣赏</h3>
                <p>在线欣赏薛之谦热门歌曲，感受音乐魅力</p>
            </div>
            <div class="category-card" onclick="showCategory('video')">
                <div class="category-icon">🎬</div>
                <h3>视频观赏</h3>
                <p>观看演唱会、综艺节目视频，重温精彩瞬间</p>
            </div>
            <div class="category-card" onclick="showCategory('image')">
                <div class="category-icon">🖼️</div>
                <h3>图片欣赏</h3>
                <p>欣赏高清写真和专辑封面，珍藏美好回忆</p>
            </div>
        </div>
        
        <!-- 音乐文件 -->
        <div class="file-section" id="musicSection">
            <div class="section-header">
                <h3>🎵 音乐欣赏</h3>
            </div>
            <div class="file-grid" id="musicGrid">
                <div class="loading">加载中...</div>
            </div>
        </div>
        
        <!-- 视频文件 -->
        <div class="file-section" id="videoSection">
            <div class="section-header">
                <h3>🎬 视频观赏</h3>
            </div>
            <div class="file-grid" id="videoGrid">
                <div class="loading">加载中...</div>
            </div>
        </div>
        
        <!-- 图片文件 -->
        <div class="file-section" id="imageSection">
            <div class="section-header">
                <h3>🖼️ 图片欣赏</h3>
            </div>
            <div class="file-grid" id="imageGrid">
                <div class="loading">加载中...</div>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        // 页面加载完成后检查URL参数
        document.addEventListener('DOMContentLoaded', function() {
            // 获取URL中的type参数
            const urlParams = new URLSearchParams(window.location.search);
            const type = urlParams.get('type');
            
            // 根据type参数显示相应分类
            if (type) {
                switch(type) {
                    case 'mp3':
                        showCategory('music');
                        break;
                    case 'mp4':
                        showCategory('video');
                        break;
                    case 'image':
                        showCategory('image');
                        break;
                    default:
                        // 如果type参数不是预期值，则显示音乐分类作为默认
                        showCategory('music');
                }
            }
            // 如果没有type参数，则不自动显示任何分类，保持原始行为
        });
        
        // 显示指定分类
        function showCategory(category) {
            // 隐藏所有分类
            document.getElementById('musicSection').style.display = 'none';
            document.getElementById('videoSection').style.display = 'none';
            document.getElementById('imageSection').style.display = 'none';
            
            // 显示指定分类并加载数据
            switch(category) {
                case 'music':
                    document.getElementById('musicSection').style.display = 'block';
                    loadFiles('mp3', 'musicGrid');
                    break;
                case 'video':
                    document.getElementById('videoSection').style.display = 'block';
                    loadFiles('mp4', 'videoGrid');
                    break;
                case 'image':
                    document.getElementById('imageSection').style.display = 'block';
                    loadFiles('image', 'imageGrid');
                    break;
            }
        }
        
        // 加载文件列表
        function loadFiles(fileType, containerId) {
            const container = document.getElementById(containerId);
            
            fetch(contextPath + '/download?action=list&type=' + fileType)
                .then(response => response.json())
                .then(files => {
                    if (files.length === 0) {
                        container.innerHTML = '<div class="empty-tip"><span>📁</span><p>暂无文件</p></div>';
                        return;
                    }
                    
                    let html = '';
                    files.forEach(file => {
                        const fileName = file.name;
                        const fileSize = formatFileSize(file.size);
                        const fileDate = file.lastModified;
                        
                        if (fileType === 'mp3') {
                            html += `
                                <div class="file-card">
                                    <div class="file-icon">🎵</div>
                                    <div class="file-info">
                                        <h4>` + escapeHtml(fileName) + `</h4>
                                        <div class="file-meta">
                                            <span>` + fileSize + `</span>
                                            <span>` + fileDate + `</span>
                                        </div>
                                        <div class="media-preview">
                                            <audio class="audio-preview" controls>
                                                <source src="` + contextPath + `/download?type=mp3&file=` + encodeURIComponent(fileName) + `&inline=true" type="audio/mpeg">
                                                您的浏览器不支持音频播放。
                                            </audio>
                                            <div style="margin-top: 10px;">
                                                <a href="` + contextPath + `/download?type=` + fileType + `&file=` + encodeURIComponent(fileName) + `" class="form-btn" style="padding: 8px 15px; font-size: 12px; text-decoration: none;">📥 下载</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        } else if (fileType === 'mp4') {
                            html += `
                                <div class="file-card">
                                    <div class="file-icon">🎬</div>
                                    <div class="file-info">
                                        <h4>` + escapeHtml(fileName) + `</h4>
                                        <div class="file-meta">
                                            <span>` + fileSize + `</span>
                                            <span>` + fileDate + `</span>
                                        </div>
                                        <div class="media-preview">
                                            <div class="video-preview" onclick="playVideo('` + encodeURIComponent(fileName) + `')">
                                                <span>▶️ 点击播放视频</span>
                                            </div>
                                            <div style="margin-top: 10px;">
                                                <a href="` + contextPath + `/download?type=` + fileType + `&file=` + encodeURIComponent(fileName) + `" class="form-btn" style="padding: 8px 15px; font-size: 12px; text-decoration: none;">📥 下载</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        } else if (fileType === 'image') {
                            html += `
                                <div class="file-card">
                                    <div class="file-icon">🖼️</div>
                                    <div class="file-info">
                                        <h4>` + escapeHtml(fileName) + `</h4>
                                        <div class="file-meta">
                                            <span>` + fileSize + `</span>
                                            <span>` + fileDate + `</span>
                                        </div>
                                        <div class="media-preview">
                                            <img class="image-preview" src="` + contextPath + `/download?type=` + fileType + `&file=` + encodeURIComponent(fileName) + `&inline=true" alt="` + escapeHtml(fileName) + `" onclick="showImage('` + encodeURIComponent(fileName) + `')">
                                            <div style="margin-top: 10px;">
                                                <a href="` + contextPath + `/download?type=` + fileType + `&file=` + encodeURIComponent(fileName) + `" class="form-btn" style="padding: 8px 15px; font-size: 12px; text-decoration: none;">📥 下载</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                        }
                    });
                    
                    container.innerHTML = html;
                })
                .catch(error => {
                    console.error('加载文件列表失败:', error);
                    container.innerHTML = '<div class="empty-tip"><span>❌</span><p>加载失败</p></div>';
                });
        }
        
        // 格式化文件大小
        function formatFileSize(bytes) {
            if (bytes === 0) return '0 Bytes';
            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));
            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        }
        
        // HTML转义
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        // 播放视频
        function playVideo(fileName) {
            // 创建模态窗口用于播放视频
            const modal = document.createElement('div');
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.9);
                z-index: 9999;
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
            `;
            
            const videoContainer = document.createElement('div');
            videoContainer.style.cssText = `
                position: relative;
                width: 80%;
                max-width: 800px;
                background: #000;
                border-radius: 8px;
                overflow: hidden;
            `;
            
            const closeBtn = document.createElement('button');
            closeBtn.innerText = '×';
            closeBtn.style.cssText = `
                position: absolute;
                top: 10px;
                right: 15px;
                background: none;
                border: none;
                color: white;
                font-size: 30px;
                cursor: pointer;
                z-index: 10000;
            `;
            
            const video = document.createElement('video');
            video.controls = true;
            video.autoplay = true;
            video.style.cssText = `
                width: 100%;
                height: auto;
                max-height: 80vh;
            `;
            
            const source = document.createElement('source');
            source.src = contextPath + '/download?type=mp4&file=' + fileName + '&inline=true';
            source.type = 'video/mp4';
            
            video.appendChild(source);
            videoContainer.appendChild(closeBtn);
            videoContainer.appendChild(video);
            modal.appendChild(videoContainer);
            
            document.body.appendChild(modal);
            
            // 关闭事件
            closeBtn.onclick = () => {
                document.body.removeChild(modal);
                video.pause();
            };
            
            modal.onclick = (e) => {
                if (e.target === modal) {
                    document.body.removeChild(modal);
                    video.pause();
                }
            };
        }
        
        // 显示大图
        function showImage(fileName) {
            const imageUrl = contextPath + '/download?type=image&file=' + fileName + '&inline=true';
            const imageWindow = window.open('', '_blank');
            imageWindow.document.write(`
                <html>
                    <head>
                        <title>图片预览</title>
                        <style>
                            body { margin: 0; background: #000; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
                            img { max-width: 95vw; max-height: 95vh; }
                        </style>
                    </head>
                    <body>
                        <img src="${imageUrl}" alt="图片预览">
                    </body>
                </html>
            `);
        }
    </script>
</body>
</html>