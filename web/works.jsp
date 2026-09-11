<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>作品展示 | i谦之家</title>
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
        
        /* 搜索和筛选 */
        .filter-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; flex-wrap: wrap; gap: 20px; }
        .filter-tabs { display: flex; gap: 10px; }
        .filter-tab { padding: 10px 25px; background: rgba(212,175,55,0.1); color: #d4af37; border: 1px solid rgba(212,175,55,0.2); border-radius: 25px; cursor: pointer; transition: all 0.3s; font-size: 14px; }
        .filter-tab:hover, .filter-tab.active { background: #d4af37; color: #000; border-color: #d4af37; }
        .search-box { display: flex; gap: 10px; }
        .search-box input { padding: 10px 20px; background: rgba(255,255,255,0.05); border: 1px solid rgba(212,175,55,0.2); border-radius: 25px; color: #f0f0f0; font-size: 14px; width: 200px; }
        .search-box input:focus { outline: none; border-color: #d4af37; }
        .search-box input::placeholder { color: #666; }
        .search-box select { padding: 10px 20px; background: rgba(255,255,255,0.05); border: 1px solid rgba(212,175,55,0.2); border-radius: 25px; color: #f0f0f0; font-size: 14px; cursor: pointer; }
        .search-box button { padding: 10px 25px; background: linear-gradient(90deg, #d4af37, #9f7928); color: #000; border: none; border-radius: 25px; cursor: pointer; font-size: 14px; transition: all 0.3s; }
        .search-box button:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(212,175,55,0.3); }
        
        /* 作品网格 */
        .works-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; }
        .work-card { background: #1a1815; border-radius: 12px; overflow: hidden; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; cursor: pointer; }
        .work-card:hover { transform: translateY(-8px); border-color: rgba(212,175,55,0.3); box-shadow: 0 15px 40px rgba(0,0,0,0.3); }
        .work-cover { height: 180px; background: linear-gradient(135deg, #2d281f, #1a1815); display: flex; align-items: center; justify-content: center; font-size: 60px; position: relative; overflow: hidden; }
        .work-cover::after { content: '▶'; position: absolute; inset: 0; background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; font-size: 40px; color: #d4af37; opacity: 0; transition: opacity 0.3s; }
        .work-card:hover .work-cover::after { opacity: 1; }
        .work-type { position: absolute; top: 10px; left: 10px; padding: 4px 12px; background: rgba(212,175,55,0.9); color: #000; font-size: 12px; border-radius: 12px; z-index: 5; }
        .work-info { padding: 18px; }
        .work-info h4 { color: #f0f0f0; font-size: 16px; margin-bottom: 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .work-meta { display: flex; justify-content: space-between; color: #888; font-size: 12px; }
        
        /* 分页 */
        .pagination { display: flex; justify-content: center; gap: 10px; margin-top: 50px; }
        .pagination button { width: 40px; height: 40px; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.2); border-radius: 8px; color: #d4af37; cursor: pointer; transition: all 0.3s; }
        .pagination button:hover, .pagination button.active { background: #d4af37; color: #000; }
        .pagination button:disabled { opacity: 0.3; cursor: not-allowed; }
        
        /* 作品详情弹窗 */
        .modal { position: fixed; inset: 0; background: rgba(0,0,0,0.8); display: none; align-items: center; justify-content: center; z-index: 2000; padding: 20px; }
        .modal.show { display: flex; }
        .modal-content { background: #1a1815; border-radius: 16px; max-width: 700px; width: 100%; max-height: 90vh; overflow-y: auto; border: 1px solid rgba(212,175,55,0.2); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; padding: 20px 25px; border-bottom: 1px solid rgba(212,175,55,0.1); }
        .modal-header h3 { color: #d4af37; font-size: 20px; }
        .modal-close { width: 36px; height: 36px; background: rgba(255,255,255,0.1); border: none; border-radius: 50%; color: #fff; font-size: 20px; cursor: pointer; }
        .modal-body { padding: 25px; }
        .modal-cover { height: 250px; background: linear-gradient(135deg, #2d281f, #252220); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 80px; margin-bottom: 20px; }
        .modal-meta { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 20px; }
        .modal-meta-item { display: flex; gap: 10px; }
        .modal-meta-item label { color: #888; min-width: 60px; }
        .modal-meta-item span { color: #f0f0f0; }
        .modal-desc { color: #ccc; line-height: 1.8; margin-bottom: 20px; }
        .modal-lyrics { background: rgba(0,0,0,0.3); padding: 20px; border-radius: 12px; }
        .modal-lyrics h4 { color: #d4af37; margin-bottom: 15px; font-size: 16px; }
        .modal-lyrics pre { color: #ccc; font-size: 14px; line-height: 2; white-space: pre-wrap; font-family: inherit; }
        
        .empty-tip { text-align: center; padding: 60px 20px; color: #666; }
        .empty-tip span { font-size: 60px; display: block; margin-bottom: 20px; }
        
        @media (max-width: 992px) { .works-grid { grid-template-columns: repeat(3, 1fr); } }
        @media (max-width: 768px) { 
            .navbar { padding: 15px 20px; } 
            .nav-links { display: none; } 
            .works-grid { grid-template-columns: repeat(2, 1fr); } 
            .filter-bar { flex-direction: column; }
        }
        @media (max-width: 480px) { .works-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">i谦之家</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/info.jsp">歌手资料</a>
            <a href="${pageContext.request.contextPath}/works.jsp" class="active">作品展示</a>
            <a href="${pageContext.request.contextPath}/forum.jsp">粉丝互动</a>
            <a href="${pageContext.request.contextPath}/download.jsp">资源下载</a>
        </div>
        <div class="nav-right">
            <% if (session.getAttribute("loginUser") != null) { %>
                <a href="${pageContext.request.contextPath}/user.jsp">个人中心</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp">登录</a>
            <% } %>
        </div>
    </nav>

    <div class="main-content">
        <div class="page-title">
            <h1>作品展示</h1>
            <p>薛之谦的歌曲、专辑、综艺、影视作品全收录</p>
        </div>

        <!-- 筛选和搜索 -->
        <div class="filter-bar">
            <div class="filter-tabs">
                <button class="filter-tab active" data-type="all">全部</button>
                <button class="filter-tab" data-type="song">歌曲</button>
                <button class="filter-tab" data-type="album">专辑</button>
                <button class="filter-tab" data-type="variety">综艺</button>
                <button class="filter-tab" data-type="movie">影视</button>
            </div>
            <div class="search-box">
                <input type="text" id="searchKeyword" placeholder="搜索作品名称...">
                <select id="searchYear">
                    <option value="">全部年份</option>
                    <option value="2024">2024年</option>
                    <option value="2023">2023年</option>
                    <option value="2022">2022年</option>
                    <option value="2021">2021年</option>
                    <option value="2020">2020年</option>
                    <option value="2019">2019年</option>
                    <option value="2018">2018年</option>
                    <option value="2017">2017年</option>
                    <option value="2016">2016年</option>
                    <option value="2015">2015年</option>
                </select>
                <button onclick="searchWorks()">搜索</button>
            </div>
        </div>

        <!-- 作品列表 -->
        <div class="works-grid" id="worksGrid">
            <!-- 作品将通过JS动态加载 -->
        </div>

        <!-- 分页 -->
        <div class="pagination" id="pagination"></div>
    </div>

    <!-- 作品详情弹窗 -->
    <div class="modal" id="workModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">作品详情</h3>
                <button class="modal-close" onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <div class="modal-cover" id="modalCover">🎵</div>
                <div class="modal-meta" id="modalMeta"></div>
                <div class="modal-desc" id="modalDesc"></div>
                <div class="modal-download" id="modalDownload" style="margin: 20px 0; display: none;">
                    <h4>下载资源</h4>
                    <div style="display: flex; gap: 10px; margin-top: 10px; flex-wrap: wrap;">
                        <a href="" id="downloadMp4" class="action-btn primary" style="display: none;" target="_blank">📥 下载MV</a>
                        <a href="" id="downloadMp3" class="action-btn primary" style="display: none;" target="_blank">🎵 下载音频</a>
                        <a href="" id="downloadImage" class="action-btn primary" style="display: none;" target="_blank">🖼️ 下载封面</a>
                    </div>
                </div>
                <div class="modal-lyrics" id="modalLyrics" style="display:none;">
                    <h4>歌词</h4>
                    <pre id="lyricsContent"></pre>
                </div>
            </div>
        </div>
    </div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let currentType = 'all';
        let currentPage = 1;
        const pageSize = 8;
        
        // 类型图标映射
        const typeIcons = { song: '🎵', album: '💿', variety: '📺', movie: '🎬' };
        
        // 初始化
        document.addEventListener('DOMContentLoaded', () => {
            loadWorks();
            bindFilterTabs();
        });
        
        // 绑定筛选标签
        function bindFilterTabs() {
            document.querySelectorAll('.filter-tab').forEach(tab => {
                tab.addEventListener('click', () => {
                    document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
                    tab.classList.add('active');
                    currentType = tab.dataset.type;
                    currentPage = 1;
                    loadWorks();
                });
            });
        }
        
        // 加载作品列表
        function loadWorks() {
            let url = contextPath + '/works?action=';
            if (currentType === 'all') {
                url += 'list';
            } else {
                url += 'type&type=' + currentType;
            }
            url += '&page=' + currentPage + '&pageSize=' + pageSize;
            
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        renderWorks(data.data.list);
                        renderPagination(data.data.page, data.data.totalPages);
                    } else {
                        showEmpty();
                    }
                })
                .catch(() => showEmpty());
        }
        
        // 搜索作品
        function searchWorks() {
            const keyword = document.getElementById('searchKeyword').value;
            const year = document.getElementById('searchYear').value;
            
            let url = contextPath + '/works?action=search&page=1&pageSize=' + pageSize;
            if (keyword) url += '&keyword=' + encodeURIComponent(keyword);
            if (year) url += '&year=' + year;
            
            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0 && data.data.list.length > 0) {
                        renderWorks(data.data.list);
                        document.getElementById('pagination').innerHTML = '';
                    } else {
                        showEmpty();
                    }
                })
                .catch(() => showEmpty());
        }
        
        // 渲染作品列表
        function renderWorks(works) {
            const grid = document.getElementById('worksGrid');
            if (!works || works.length === 0) {
                showEmpty();
                return;
            }
            
            let html = '';
            works.forEach(work => {
                html += '<div class="work-card" onclick="showWorkDetail(' + work.id + ')">';
                html += '<div class="work-cover">';
                html += '<span class="work-type">' + work.typeName + '</span>';
                html += typeIcons[work.type] || '🎵';
                html += '</div>';
                html += '<div class="work-info">';
                html += '<h4>' + escapeHtml(work.name) + '</h4>';
                html += '<div class="work-meta">';
                html += '<span>' + (work.releaseDate || '未知') + '</span>';
                html += '<span>' + work.formattedPlayCount + '次播放</span>';
                html += '</div>';
                html += '</div>';
                html += '</div>';
            });
            grid.innerHTML = html;
        }
        
        // 渲染分页
        function renderPagination(page, totalPages) {
            if (totalPages <= 1) {
                document.getElementById('pagination').innerHTML = '';
                return;
            }
            
            let html = '';
            html += `<button onclick="goToPage(${page - 1})" ${page <= 1 ? 'disabled' : ''}>&lt;</button>`;
            
            for (let i = 1; i <= totalPages; i++) {
                if (i === 1 || i === totalPages || (i >= page - 2 && i <= page + 2)) {
                    html += `<button onclick="goToPage(${i})" class="${i == page ? 'active' : ''}">${i}</button>`;
                } else if (i === page - 3 || i === page + 3) {
                    html += '<button disabled>...</button>';
                }
            }
            
            html += `<button onclick="goToPage(${page + 1})" ${page >= totalPages ? 'disabled' : ''}>&gt;</button>`;
            
            document.getElementById('pagination').innerHTML = html;
        }
        
        function goToPage(page) {
            currentPage = page;
            loadWorks();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        // 显示作品详情
        function showWorkDetail(id) {
            fetch(contextPath + '/works?action=detail&id=' + id)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        const work = data.data;
                        document.getElementById('modalTitle').textContent = work.name;
                        document.getElementById('modalCover').textContent = typeIcons[work.type] || '🎵';
                        
                        document.getElementById('modalMeta').innerHTML = `
                            <div class="modal-meta-item"><label>类型：</label><span>${work.typeName}</span></div>
                            <div class="modal-meta-item"><label>发布：</label><span>${work.releaseDate || '未知'}</span></div>
                            <div class="modal-meta-item"><label>时长：</label><span>${work.duration || '未知'}</span></div>
                            <div class="modal-meta-item"><label>播放：</label><span>${work.formattedPlayCount}次</span></div>
                        `;
                        
                        document.getElementById('modalDesc').textContent = work.description || '暂无简介';
                        
                        const lyricsDiv = document.getElementById('modalLyrics');
                        if (work.lyrics && work.type === 'song') {
                            document.getElementById('lyricsContent').textContent = work.lyrics;
                            lyricsDiv.style.display = 'block';
                        } else {
                            lyricsDiv.style.display = 'none';
                        }
                        
                        // 设置下载链接
                        const downloadDiv = document.getElementById('modalDownload');
                        const downloadMp4 = document.getElementById('downloadMp4');
                        const downloadMp3 = document.getElementById('downloadMp3');
                        const downloadImage = document.getElementById('downloadImage');
                        
                        // 隐藏所有下载链接
                        downloadMp4.style.display = 'none';
                        downloadMp3.style.display = 'none';
                        downloadImage.style.display = 'none';
                        downloadDiv.style.display = 'none';
                        
                        // 根据作品类型显示相应的下载链接
                        if (work.type === 'song') {
                            // 歌曲：显示MP3和封面下载
                            if (work.cover) {
                                downloadImage.href = contextPath + '/download?type=image&file=' + encodeURIComponent(work.cover.split('/').pop());
                                downloadImage.style.display = 'inline-block';
                            }
                            downloadMp3.href = contextPath + '/download?type=mp3&file=' + encodeURIComponent(work.name + '.mp3');
                            downloadMp3.style.display = 'inline-block';
                            downloadDiv.style.display = 'block';
                        } else if (work.type === 'album') {
                            // 专辑：显示封面下载
                            if (work.cover) {
                                downloadImage.href = contextPath + '/download?type=image&file=' + encodeURIComponent(work.cover.split('/').pop());
                                downloadImage.style.display = 'inline-block';
                                downloadDiv.style.display = 'block';
                            }
                        } else if (work.type === 'variety') {
                            // 综艺：显示MP4和封面下载
                            if (work.cover) {
                                downloadImage.href = contextPath + '/download?type=image&file=' + encodeURIComponent(work.cover.split('/').pop());
                                downloadImage.style.display = 'inline-block';
                            }
                            downloadMp4.href = contextPath + '/download?type=mp4&file=' + encodeURIComponent(work.name + '.mp4');
                            downloadMp4.style.display = 'inline-block';
                            downloadDiv.style.display = 'block';
                        } else if (work.type === 'movie') {
                            // 影视：显示MP4和封面下载
                            if (work.cover) {
                                downloadImage.href = contextPath + '/download?type=image&file=' + encodeURIComponent(work.cover.split('/').pop());
                                downloadImage.style.display = 'inline-block';
                            }
                            downloadMp4.href = contextPath + '/download?type=mp4&file=' + encodeURIComponent(work.name + '.mp4');
                            downloadMp4.style.display = 'inline-block';
                            downloadDiv.style.display = 'block';
                        }
                        
                        document.getElementById('workModal').classList.add('show');
                    }
                });
        }
        
        function closeModal() {
            document.getElementById('workModal').classList.remove('show');
        }
        
        // 点击弹窗外部关闭
        document.getElementById('workModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
        
        function showEmpty() {
            document.getElementById('worksGrid').innerHTML = `
                <div class="empty-tip" style="grid-column: 1/-1;">
                    <span>🔍</span>
                    <p>暂无相关作品</p>
                </div>
            `;
        }
        
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
    </script>
</body>
</html>
