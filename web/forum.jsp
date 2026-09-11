<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>粉丝互动 | i谦之家</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #1a1815 100%); min-height: 100vh; color: #f0f0f0; }
        
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background: rgba(0,0,0,0.9); backdrop-filter: blur(10px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(212,175,55,0.2); }
        .logo { font-size: 28px; font-weight: 700; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 2px; text-decoration: none; }
        .nav-links { display: flex; gap: 35px; }
        .nav-links a { color: #f0f0f0; text-decoration: none; font-size: 15px; transition: all 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: #d4af37; }
        .nav-right a { padding: 8px 20px; border-radius: 20px; text-decoration: none; font-size: 14px; color: #d4af37; border: 1px solid #d4af37; margin-left: 10px; }
        
        .main-content { margin-top: 100px; max-width: 900px; margin-left: auto; margin-right: auto; padding: 0 20px 60px; }
        
        .page-title { text-align: center; margin-bottom: 40px; }
        .page-title h1 { font-size: 36px; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 10px; }
        .page-title p { color: #888; font-size: 14px; }
        
        /* 发布留言区域 */
        .post-area { background: #1a1815; border-radius: 16px; padding: 25px; margin-bottom: 30px; border: 1px solid rgba(212,175,55,0.1); }
        .post-area h3 { color: #d4af37; font-size: 18px; margin-bottom: 15px; }
        .post-textarea { width: 100%; height: 120px; padding: 15px; background: rgba(0,0,0,0.3); border: 1px solid rgba(212,175,55,0.2); border-radius: 12px; color: #f0f0f0; font-size: 15px; resize: none; }
        .post-textarea:focus { outline: none; border-color: #d4af37; }
        .post-textarea::placeholder { color: #666; }
        .post-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; }
        .post-footer span { color: #666; font-size: 13px; }
        .post-btn { padding: 10px 30px; background: linear-gradient(90deg, #d4af37, #9f7928); color: #000; border: none; border-radius: 25px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.3s; }
        .post-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(212,175,55,0.3); }
        .post-btn:disabled { opacity: 0.5; cursor: not-allowed; transform: none; }
        .login-tip { color: #888; font-size: 14px; }
        .login-tip a { color: #d4af37; text-decoration: none; }
        
        /* 留言列表 */
        .message-list { margin-bottom: 30px; }
        .message-card { background: #1a1815; border-radius: 16px; padding: 25px; margin-bottom: 20px; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; }
        .message-card:hover { border-color: rgba(212,175,55,0.2); }
        .message-header { display: flex; align-items: center; gap: 15px; margin-bottom: 15px; }
        .message-avatar { width: 50px; height: 50px; background: linear-gradient(135deg, #d4af37, #9f7928); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; color: #000; }
        .message-user { flex: 1; }
        .message-user h4 { color: #f0f0f0; font-size: 16px; margin-bottom: 4px; }
        .message-user span { color: #666; font-size: 12px; }
        .message-actions-right { display: flex; align-items: center; }
        .delete-btn { background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2); color: #f0f0f0; padding: 5px 10px; border-radius: 5px; cursor: pointer; font-size: 12px; }
        .delete-btn:hover { background: rgba(255,0,0,0.2); }
        .message-content { color: #ccc; font-size: 15px; line-height: 1.8; margin-bottom: 15px; padding-left: 65px; }
        .message-actions { display: flex; gap: 20px; padding-left: 65px; }
        .action-btn { display: flex; align-items: center; gap: 5px; color: #888; font-size: 13px; cursor: pointer; transition: all 0.3s; background: none; border: none; }
        .action-btn:hover { color: #d4af37; }
        .action-btn.liked { color: #d4af37; }
        .action-btn span { font-size: 16px; }
        
        /* 回复区域 */
        .reply-area { margin-top: 15px; padding-left: 65px; display: none; }
        .reply-area.show { display: block; }
        .reply-input { display: flex; gap: 10px; margin-bottom: 15px; }
        .reply-input input { flex: 1; padding: 10px 15px; background: rgba(0,0,0,0.3); border: 1px solid rgba(212,175,55,0.2); border-radius: 20px; color: #f0f0f0; font-size: 14px; }
        .reply-input input:focus { outline: none; border-color: #d4af37; }
        .reply-input button { padding: 10px 20px; background: #d4af37; color: #000; border: none; border-radius: 20px; cursor: pointer; font-size: 13px; }
        
        /* 回复列表 */
        .replies-list { margin-top: 15px; }
        .replies-title { color: #888; font-size: 14px; margin-bottom: 10px; }
        .reply-item { background: rgba(0,0,0,0.2); border-radius: 12px; padding: 15px; margin-bottom: 10px; position: relative; }
        .reply-item .delete-btn { position: absolute; top: 10px; right: 10px; }
        .reply-header { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .reply-user { color: #d4af37; font-size: 14px; font-weight: 500; }
        .reply-time { color: #666; font-size: 12px; }
        .reply-content { color: #ccc; font-size: 14px; line-height: 1.6; }
        
        /* 分页 */
        .pagination { display: flex; justify-content: center; gap: 10px; margin-top: 30px; }
        .pagination button { width: 40px; height: 40px; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.2); border-radius: 8px; color: #d4af37; cursor: pointer; transition: all 0.3s; }
        .pagination button:hover, .pagination button.active { background: #d4af37; color: #000; }
        .pagination button:disabled { opacity: 0.3; cursor: not-allowed; }
        
        .empty-tip { text-align: center; padding: 60px 20px; color: #666; }
        .empty-tip span { font-size: 60px; display: block; margin-bottom: 20px; }
        
        .toast { position: fixed; top: 100px; left: 50%; transform: translateX(-50%); padding: 12px 30px; background: rgba(212,175,55,0.9); color: #000; border-radius: 25px; font-size: 14px; z-index: 3000; display: none; }
        .toast.show { display: block; animation: fadeInOut 2s ease; }
        @keyframes fadeInOut { 0%, 100% { opacity: 0; } 10%, 90% { opacity: 1; } }
        
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; }
            .message-content, .message-actions, .reply-area { padding-left: 0; }
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
            <a href="${pageContext.request.contextPath}/forum.jsp" class="active">粉丝互动</a>
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
            <h1>粉丝互动区</h1>
            <p>与全国谦友一起交流，分享你对谦谦的喜爱</p>
        </div>

        <!-- 发布留言 -->
        <div class="post-area">
            <h3>💬 发表留言</h3>
            <% if (session.getAttribute("loginUser") != null) { %>
                <textarea class="post-textarea" id="messageContent" placeholder="写下你想对谦谦说的话...（最多500字）" maxlength="500"></textarea>
                <div class="post-footer">
                    <span id="charCount">0/500</span>
                    <button class="post-btn" id="postBtn" onclick="postMessage()">发布留言</button>
                </div>
            <% } else { %>
                <p class="login-tip">💡 请先 <a href="${pageContext.request.contextPath}/login.jsp">登录</a> 后再发表留言</p>
            <% } %>
        </div>

        <!-- 留言列表 -->
        <div class="message-list" id="messageList">
            <!-- 留言将通过JS动态加载 -->
        </div>

        <!-- 分页 -->
        <div class="pagination" id="pagination"></div>
    </div>

    <!-- 提示消息 -->
    <div class="toast" id="toast"></div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        const isLoggedIn = <%= session.getAttribute("loginUser") != null %>;
        let currentPage = 1;
        const pageSize = 10;
        
        // 初始化
        document.addEventListener('DOMContentLoaded', () => {
            loadMessages();
            bindCharCount();
        });
        
        // 绑定字数统计
        function bindCharCount() {
            const textarea = document.getElementById('messageContent');
            if (textarea) {
                textarea.addEventListener('input', () => {
                    document.getElementById('charCount').textContent = textarea.value.length + '/500';
                });
            }
        }
        
        // 加载留言列表
        function loadMessages() {
            fetch(contextPath + '/message?action=list&page=' + currentPage + '&pageSize=' + pageSize)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        renderMessages(data.data.list);
                        renderPagination(data.data.page, data.data.totalPages);
                    } else {
                        showEmpty();
                    }
                })
                .catch(() => showEmpty());
        }
        
        // 渲染留言列表
        function renderMessages(messages) {
            const list = document.getElementById('messageList');
            if (!messages || messages.length === 0) {
                showEmpty();
                return;
            }
            
            let html = '';
            messages.forEach(msg => {
                html += '<div class="message-card" data-id="' + msg.id + '">';
                html += '<div class="message-header">';
                html += '<div class="message-avatar">' + (msg.username ? msg.username.charAt(0).toUpperCase() : '谦') + '</div>';
                html += '<div class="message-user">';
                html += '<h4>' + escapeHtml(msg.username || '谦友') + '</h4>';
                html += '<span>' + msg.createTime + '</span>';
                html += '</div>';
                // 添加删除按钮
                html += '<div class="message-actions-right">';
                html += '<button class="action-btn delete-btn" onclick="deleteMessage(' + msg.id + ')">🗑️ 删除</button>';
                html += '</div>';
                html += '</div>';
                html += '<div class="message-content">' + escapeHtml(msg.content) + '</div>';
                html += '<div class="message-actions">';
                html += '<button class="action-btn ' + (msg.liked ? 'liked' : '') + '" onclick="likeMessage(' + msg.id + ', this)">';
                html += '<span>❤</span> <em>' + (msg.likeCount || 0) + '</em>';
                html += '</button>';
                html += '<button class="action-btn" onclick="toggleReply(' + msg.id + ')">';
                html += '<span>💬</span> 回复';
                html += '</button>';
                html += '</div>';
                html += '<div class="reply-area" id="reply-' + msg.id + '">';
                html += '<div class="reply-input">';
                html += '<input type="text" placeholder="写下你的回复..." id="replyInput-' + msg.id + '">';
                html += '<button onclick="submitReply(' + msg.id + ')">发送</button>';
                html += '</div>';
                // 添加回复列表显示区域
                html += '<div class="replies-list" id="replies-' + msg.id + '"></div>';
                html += '</div>';
                html += '</div>';
            });
            list.innerHTML = html;
            
            // 获取并显示回复
            messages.forEach(msg => {
                loadReplies(msg.id);
            });
        }
        
        // 加载回复列表
        function loadReplies(parentId) {
            fetch(contextPath + '/message?action=replies&parentId=' + parentId)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0 && data.data.list.length > 0) {
                        renderReplies(parentId, data.data.list);
                    }
                });
        }
        
        // 渲染回复列表
        function renderReplies(parentId, replies) {
            const repliesContainer = document.getElementById('replies-' + parentId);
            if (!repliesContainer) return;
            
            let html = '<div class="replies-title">回复 (' + replies.length + '条)</div>';
            replies.forEach(reply => {
                html += '<div class="reply-item">';
                html += '<div class="reply-header">';
                html += '<span class="reply-user">' + escapeHtml(reply.username || '谦友') + '</span>';
                html += '<span class="reply-time">' + reply.createTime + '</span>';
                // 为回复添加删除按钮
                html += '<button class="action-btn delete-btn" onclick="deleteMessage(' + reply.id + ')">🗑️</button>';
                html += '</div>';
                html += '<div class="reply-content">' + escapeHtml(reply.content) + '</div>';
                html += '</div>';
            });
            
            repliesContainer.innerHTML = html;
            // 显示回复区域
            document.getElementById('reply-' + parentId).classList.add('show');
        }
        
        // 发布留言
        function postMessage() {
            if (!isLoggedIn) {
                showToast('请先登录');
                return;
            }
            
            const content = document.getElementById('messageContent').value.trim();
            if (!content) {
                showToast('请输入留言内容');
                return;
            }
            
            const btn = document.getElementById('postBtn');
            btn.disabled = true;
            btn.textContent = '发布中...';
            
            fetch(contextPath + '/message?action=add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'content=' + encodeURIComponent(content)
            })
            .then(response => response.json())
            .then(data => {
                console.log('发布留言响应:', data); // 添加调试信息
                if (data.code === 0) {
                    showToast('发布成功！');
                    document.getElementById('messageContent').value = '';
                    document.getElementById('charCount').textContent = '0/500';
                    currentPage = 1;
                    loadMessages();
                } else {
                    showToast(data.message || '发布失败');
                }
            })
            .catch(error => {
                console.error('发布留言错误:', error); // 添加调试信息
                showToast('网络错误');
            })
            .finally(() => {
                btn.disabled = false;
                btn.textContent = '发布留言';
            });
        }
        
        // 点赞
        function likeMessage(id, btn) {
            if (!isLoggedIn) {
                showToast('请先登录');
                return;
            }
            
            fetch(contextPath + '/message?action=like&id=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        btn.classList.toggle('liked', data.data.liked);
                        btn.querySelector('em').textContent = data.data.likeCount;
                    } else {
                        showToast(data.message);
                    }
                });
        }
        
        // 切换回复区域
        function toggleReply(id) {
            if (!isLoggedIn) {
                showToast('请先登录');
                return;
            }
            const replyArea = document.getElementById('reply-' + id);
            replyArea.classList.toggle('show');
        }
        
        // 提交回复
        function submitReply(parentId) {
            const input = document.getElementById('replyInput-' + parentId);
            const content = input.value.trim();
            
            if (!content) {
                showToast('请输入回复内容');
                return;
            }
            
            fetch(contextPath + '/message?action=reply', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'content=' + encodeURIComponent(content) + '&parentId=' + parentId
            })
            .then(response => response.json())
            .then(data => {
                console.log('回复响应:', data); // 添加调试信息
                if (data.code === 0) {
                    showToast('回复成功！');
                    input.value = '';
                    document.getElementById('reply-' + parentId).classList.remove('show');
                    // 重新加载回复列表
                    loadReplies(parentId);
                } else {
                    showToast(data.message || '回复失败');
                }
            })
            .catch(error => {
                console.error('回复错误:', error); // 添加调试信息
                showToast('网络错误');
            });
        }
        
        // 删除留言
        function deleteMessage(id) {
            if (!confirm('确定要删除这条留言吗？')) return;
            
            fetch(contextPath + '/message?action=delete&id=' + id, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                console.log('删除留言响应:', data); // 添加调试信息
                if (data.code === 0) {
                    showToast('删除成功！');
                    // 重新加载留言列表
                    loadMessages();
                } else {
                    showToast(data.message || '删除失败');
                }
            })
            .catch(error => {
                console.error('删除留言错误:', error); // 添加调试信息
                showToast('网络错误');
            });
        }
        
        // 分页
        function renderPagination(page, totalPages) {
            if (totalPages <= 1) {
                document.getElementById('pagination').innerHTML = '';
                return;
            }
            
            let html = `<button onclick="goToPage(${page - 1})" ${page <= 1 ? 'disabled' : ''}>&lt;</button>`;
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
            loadMessages();
            window.scrollTo({ top: 300, behavior: 'smooth' });
        }
        
        function showEmpty() {
            document.getElementById('messageList').innerHTML = `
                <div class="empty-tip"><span>💬</span><p>暂无留言，快来发表第一条吧！</p></div>
            `;
        }
        
        function showToast(msg) {
            const toast = document.getElementById('toast');
            toast.textContent = msg;
            toast.classList.add('show');
            setTimeout(() => toast.classList.remove('show'), 2000);
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
