<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 检查管理员权限
    Integer userRole = (Integer) session.getAttribute("userRole");
    if (userRole == null || userRole != 1) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理后台 | i谦之家</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #1a1815 100%); min-height: 100vh; color: #f0f0f0; display: flex; }
        
        /* 左侧边栏 */
        .sidebar { width: 240px; background: #111; height: 100vh; position: fixed; left: 0; top: 0; border-right: 1px solid rgba(212,175,55,0.1); }
        .sidebar-header { padding: 25px 20px; border-bottom: 1px solid rgba(212,175,55,0.1); }
        .sidebar-logo { font-size: 22px; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 700; }
        .sidebar-sub { color: #888; font-size: 12px; margin-top: 5px; }
        .sidebar-menu { padding: 20px 0; }
        .menu-item { display: flex; align-items: center; gap: 12px; padding: 15px 25px; color: #ccc; cursor: pointer; transition: all 0.3s; border-left: 3px solid transparent; }
        .menu-item:hover, .menu-item.active { background: rgba(212,175,55,0.1); color: #d4af37; border-left-color: #d4af37; }
        .menu-item span { font-size: 18px; }
        .sidebar-footer { position: absolute; bottom: 0; left: 0; right: 0; padding: 20px; border-top: 1px solid rgba(212,175,55,0.1); }
        .sidebar-footer a { color: #888; text-decoration: none; font-size: 14px; display: flex; align-items: center; gap: 8px; }
        .sidebar-footer a:hover { color: #d4af37; }
        
        /* 主内容区 */
        .main-area { margin-left: 240px; flex: 1; padding: 30px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-title { font-size: 26px; color: #d4af37; }
        .admin-info { display: flex; align-items: center; gap: 10px; color: #888; }
        
        /* 统计卡片 */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: #1a1815; border-radius: 12px; padding: 25px; border: 1px solid rgba(212,175,55,0.1); }
        .stat-card h4 { color: #888; font-size: 14px; margin-bottom: 10px; }
        .stat-card .value { font-size: 32px; color: #d4af37; font-weight: 700; }
        .stat-card .trend { font-size: 12px; color: #4ade80; margin-top: 5px; }
        
        /* 内容面板 */
        .content-panel { background: #1a1815; border-radius: 12px; padding: 25px; border: 1px solid rgba(212,175,55,0.1); display: none; }
        .content-panel.active { display: block; }
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid rgba(212,175,55,0.1); }
        .panel-header h3 { color: #f0f0f0; font-size: 18px; }
        
        /* 表格 */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th, .data-table td { padding: 15px; text-align: left; border-bottom: 1px solid rgba(212,175,55,0.05); }
        .data-table th { color: #888; font-size: 13px; font-weight: 500; }
        .data-table td { color: #ccc; font-size: 14px; }
        .data-table tr:hover { background: rgba(212,175,55,0.05); }
        
        /* 状态标签 */
        .status-tag { padding: 4px 12px; border-radius: 12px; font-size: 12px; }
        .status-tag.active { background: rgba(74,222,128,0.1); color: #4ade80; }
        .status-tag.disabled { background: rgba(255,107,107,0.1); color: #ff6b6b; }
        .status-tag.violation { background: rgba(255,165,0,0.1); color: #ffa500; }
        
        /* 操作按钮 */
        .action-btn { padding: 6px 15px; border-radius: 6px; border: none; cursor: pointer; font-size: 12px; margin-right: 5px; transition: all 0.3s; }
        .action-btn.primary { background: rgba(212,175,55,0.1); color: #d4af37; border: 1px solid rgba(212,175,55,0.2); }
        .action-btn.danger { background: rgba(255,107,107,0.1); color: #ff6b6b; border: 1px solid rgba(255,107,107,0.2); }
        .action-btn:hover { transform: translateY(-1px); }
        
        /* 分页 */
        .pagination { display: flex; justify-content: center; gap: 8px; margin-top: 25px; }
        .pagination button { width: 36px; height: 36px; background: rgba(212,175,55,0.1); border: 1px solid rgba(212,175,55,0.2); border-radius: 6px; color: #d4af37; cursor: pointer; }
        .pagination button:hover, .pagination button.active { background: #d4af37; color: #000; }
        .pagination button:disabled { opacity: 0.3; cursor: not-allowed; }
        
        .toast { position: fixed; top: 30px; right: 30px; padding: 15px 25px; background: rgba(212,175,55,0.9); color: #000; border-radius: 8px; font-size: 14px; z-index: 3000; display: none; }
        .toast.show { display: block; animation: slideIn 0.3s ease; }
        @keyframes slideIn { from { transform: translateX(100px); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        
        @media (max-width: 1200px) { .stats-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 768px) { 
            .sidebar { width: 200px; }
            .main-area { margin-left: 200px; padding: 20px; }
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- 左侧边栏 -->
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">i谦之家</div>
            <div class="sidebar-sub">管理后台</div>
        </div>
        <div class="sidebar-menu">
            <div class="menu-item active" data-panel="dashboard"><span>📊</span> 数据概览</div>
            <div class="menu-item" data-panel="users"><span>👥</span> 用户管理</div>
            <div class="menu-item" data-panel="messages"><span>💬</span> 留言审核</div>
            <div class="menu-item" data-panel="upload"><span>📤</span> 文件上传</div>
        </div>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/index.jsp"><span>🏠</span> 返回前台</a>
        </div>
    </div>

    <!-- 主内容区 -->
    <div class="main-area">
        <div class="page-header">
            <h1 class="page-title">管理后台</h1>
            <div class="admin-info">
                <span>👤 ${sessionScope.loginUser}</span>
                <a href="${pageContext.request.contextPath}/logout" style="color:#d4af37;text-decoration:none;margin-left:15px;">退出</a>
            </div>
        </div>

        <!-- 数据概览 -->
        <div class="content-panel active" id="panel-dashboard">
            <div class="stats-grid">
                <div class="stat-card">
                    <h4>注册用户</h4>
                    <div class="value" id="userCount">0</div>
                    <div class="trend">↑ 今日新增 5</div>
                </div>
                <div class="stat-card">
                    <h4>留言总数</h4>
                    <div class="value" id="messageCount">0</div>
                    <div class="trend">↑ 今日新增 12</div>
                </div>
                <div class="stat-card">
                    <h4>作品数量</h4>
                    <div class="value">10</div>
                    <div class="trend">歌曲/专辑/综艺</div>
                </div>
                <div class="stat-card">
                    <h4>访问量</h4>
                    <div class="value">1,258</div>
                    <div class="trend">↑ 较昨日 +15%</div>
                </div>
            </div>
            <div style="background:#1a1815;border-radius:12px;padding:25px;border:1px solid rgba(212,175,55,0.1);">
                <h3 style="color:#f0f0f0;margin-bottom:20px;">📢 系统公告</h3>
                <p style="color:#ccc;line-height:1.8;">欢迎使用i谦之家管理后台！您可以在这里管理用户账号、审核粉丝留言。请定期检查违规内容，维护良好的社区环境。</p>
            </div>
        </div>

        <!-- 用户管理 -->
        <div class="content-panel" id="panel-users">
            <div class="panel-header">
                <h3>👥 用户管理</h3>
                <button class="action-btn primary" onclick="showAddUserForm()" style="margin-left: auto;">➕ 添加用户</button>
            </div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>手机号</th>
                        <th>邮箱</th>
                        <th>注册时间</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="userTableBody">
                    <!-- 用户数据将通过JS加载 -->
                </tbody>
            </table>
            <div class="pagination" id="userPagination"></div>
        </div>

        <!-- 留言审核 -->
        <div class="content-panel" id="panel-messages">
            <div class="panel-header">
                <h3>💬 留言审核</h3>
            </div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户</th>
                        <th>内容</th>
                        <th>发布时间</th>
                        <th>点赞</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody id="messageTableBody">
                    <!-- 留言数据将通过JS加载 -->
                </tbody>
            </table>
            <div class="pagination" id="messagePagination"></div>
        </div>
        
        <!-- 文件上传 -->
        <div class="content-panel" id="panel-upload">
            <div class="panel-header">
                <h3>📤 文件上传</h3>
            </div>
            <div style="max-width: 600px; margin: 0 auto; padding: 30px; background: #1a1815; border-radius: 12px; border: 1px solid rgba(212,175,55,0.1);">
                <form id="uploadForm" enctype="multipart/form-data">
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; color: #ccc; margin-bottom: 8px;">文件类型 *</label>
                        <select id="fileType" name="fileType" style="width: 100%; padding: 12px; background: #222; border: 1px solid #444; border-radius: 6px; color: #fff; font-size: 14px;">
                            <option value="">请选择文件类型</option>
                            <option value="mp4">视频文件 (MP4)</option>
                            <option value="mp3">音频文件 (MP3)</option>
                            <option value="image">图片文件</option>
                        </select>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; color: #ccc; margin-bottom: 8px;">文件名 *</label>
                        <input type="text" id="fileName" name="fileName" style="width: 100%; padding: 12px; background: #222; border: 1px solid #444; border-radius: 6px; color: #fff; font-size: 14px;" placeholder="请输入文件名（不含扩展名）">
                        <div style="color: #888; font-size: 12px; margin-top: 5px;">提示：文件会自动加上原始扩展名</div>
                    </div>
                    
                    <div style="margin-bottom: 25px;">
                        <label style="display: block; color: #ccc; margin-bottom: 8px;">选择文件 *</label>
                        <input type="file" id="file" name="file" style="width: 100%; padding: 12px; background: #222; border: 1px solid #444; border-radius: 6px; color: #fff; font-size: 14px;" accept=".mp4,.mp3,image/*">
                    </div>
                    
                    <button type="submit" class="action-btn primary" style="width: 100%; padding: 12px; font-size: 16px;">📤 上传文件</button>
                </form>
                
                <div id="uploadResult" style="margin-top: 20px; padding: 15px; border-radius: 6px; display: none;"></div>
            </div>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        let userPage = 1, messagePage = 1;
        const pageSize = 10;
        
        // 菜单切换
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', () => {
                document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));
                document.querySelectorAll('.content-panel').forEach(p => p.classList.remove('active'));
                
                item.classList.add('active');
                const panelId = 'panel-' + item.dataset.panel;
                document.getElementById(panelId).classList.add('active');
                
                if (item.dataset.panel === 'users') loadUsers();
                if (item.dataset.panel === 'messages') loadMessages();
            });
        });
        
        // 加载统计数据
        function loadStats() {
            fetch(contextPath + '/admin?action=stats')
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        document.getElementById('userCount').textContent = data.data.userCount;
                        document.getElementById('messageCount').textContent = data.data.messageCount;
                    }
                });
        }
        
        // 加载用户列表
        function loadUsers() {
            fetch(contextPath + '/admin?action=users&page=' + userPage + '&pageSize=' + pageSize)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        renderUsers(data.data.list);
                        renderPagination('userPagination', data.data.page, data.data.totalPages, 'user');
                    }
                });
        }
        
        function renderUsers(users) {
            const tbody = document.getElementById('userTableBody');
            tbody.innerHTML = users.map(user => `
                <tr>
                    <td>\${user.id}</td>
                    <td>\${escapeHtml(user.username)}</td>
                    <td>\${user.phone || '-'}</td>
                    <td>\${user.email || '-'}</td>
                    <td>\${user.createTime}</td>
                    <td><span class="status-tag \${user.status == 1 ? 'active' : 'disabled'}">\${user.status == 1 ? '正常' : '禁用'}</span></td>
                    <td>
                        \${user.status == 1 
                            ? `<button class="action-btn danger" onclick="disableUser(\${user.id})">禁用</button>`
                            : `<button class="action-btn primary" onclick="enableUser(\${user.id})">启用</button>`
                        }
                    </td>
                </tr>
            `).join('');
        }
        
        // 禁用/启用用户
        function disableUser(id) {
            if (!confirm('确定要禁用该用户吗？')) return;
            fetch(contextPath + '/admin?action=disableUser&userId=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) loadUsers();
                });
        }
        
        function enableUser(id) {
            fetch(contextPath + '/admin?action=enableUser&userId=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) loadUsers();
                });
        }
        
        // 加载留言列表
        function loadMessages() {
            fetch(contextPath + '/admin?action=messages&page=' + messagePage + '&pageSize=' + pageSize)
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0) {
                        renderMessages(data.data.list);
                        renderPagination('messagePagination', data.data.page, data.data.totalPages, 'message');
                    }
                });
        }
        
        function renderMessages(messages) {
            const tbody = document.getElementById('messageTableBody');
            tbody.innerHTML = messages.map(msg => `
                <tr>
                    <td>\${msg.id}</td>
                    <td>\${escapeHtml(msg.username)}</td>
                    <td style="max-width:300px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">\${escapeHtml(msg.content)}</td>
                    <td>\${msg.createTime}</td>
                    <td>\${msg.likeCount}</td>
                    <td><span class="status-tag \${msg.isViolation == 1 ? 'violation' : 'active'}">\${msg.isViolation == 1 ? '违规' : '正常'}</span></td>
                    <td>
                        \${msg.isViolation == 1 
                            ? `<button class="action-btn primary" onclick="unmarkViolation(\${msg.id})">取消违规</button>`
                            : `<button class="action-btn primary" onclick="markViolation(\${msg.id})">标记违规</button>`
                        }
                        <button class="action-btn danger" onclick="deleteMessage(\${msg.id})">删除</button>
                    </td>
                </tr>
            `).join('');
        }
        
        // 标记违规
        function markViolation(id) {
            if (!confirm('确定要标记该留言为违规吗？')) return;
            fetch(contextPath + '/admin?action=markViolation&messageId=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) loadMessages();
                });
        }
        
        // 取消违规标记
        function unmarkViolation(id) {
            if (!confirm('确定要取消该留言的违规标记吗？')) return;
            fetch(contextPath + '/admin?action=unmarkViolation&messageId=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) loadMessages();
                });
        }
        
        // 删除留言
        function deleteMessage(id) {
            if (!confirm('确定要删除该留言吗？')) return;
            fetch(contextPath + '/admin?action=deleteMessage&messageId=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) loadMessages();
                });
        }
        
        // 分页
        function renderPagination(containerId, page, totalPages, type) {
            if (totalPages <= 1) {
                document.getElementById(containerId).innerHTML = '';
                return;
            }
            
            let html = `<button onclick="goToPage('\${type}', \${page - 1})" \${page <= 1 ? 'disabled' : ''}>&lt;</button>`;
            for (let i = 1; i <= totalPages; i++) {
                html += `<button onclick="goToPage('${type}', ${i})" class="${i == page ? 'active' : ''}">${i}</button>`;
            }
            html += `<button onclick="goToPage('\${type}', \${page + 1})" \${page >= totalPages ? 'disabled' : ''}>&gt;</button>`;
            document.getElementById(containerId).innerHTML = html;
        }
        
        function goToPage(type, page) {
            if (type === 'user') {
                userPage = page;
                loadUsers();
            } else {
                messagePage = page;
                loadMessages();
            }
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
        
        // 添加用户功能
        function showAddUserForm() {
            // 创建添加用户表单的HTML
            const formHtml = `
                <div id="addUserModal" style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);display:flex;align-items:center;justify-content:center;z-index:2000;">
                    <div style="background:#1a1815;border:1px solid rgba(212,175,55,0.2);border-radius:12px;padding:30px;width:400px;max-width:90%;">
                        <h3 style="color:#f0f0f0;margin-top:0;margin-bottom:20px;">添加新用户</h3>
                        <div style="margin-bottom:15px;">
                            <label style="display:block;color:#ccc;margin-bottom:5px;">用户名 *</label>
                            <input type="text" id="addUsername" style="width:100%;padding:10px;background:#222;border:1px solid #444;border-radius:6px;color:#fff;" placeholder="请输入用户名">
                        </div>
                        <div style="margin-bottom:15px;">
                            <label style="display:block;color:#ccc;margin-bottom:5px;">密码 *</label>
                            <input type="password" id="addPassword" style="width:100%;padding:10px;background:#222;border:1px solid #444;border-radius:6px;color:#fff;" placeholder="请输入密码">
                        </div>
                        <div style="margin-bottom:15px;">
                            <label style="display:block;color:#ccc;margin-bottom:5px;">手机号</label>
                            <input type="text" id="addPhone" style="width:100%;padding:10px;background:#222;border:1px solid #444;border-radius:6px;color:#fff;" placeholder="请输入手机号">
                        </div>
                        <div style="margin-bottom:15px;">
                            <label style="display:block;color:#ccc;margin-bottom:5px;">邮箱</label>
                            <input type="email" id="addEmail" style="width:100%;padding:10px;background:#222;border:1px solid #444;border-radius:6px;color:#fff;" placeholder="请输入邮箱">
                        </div>
                        <div style="display:flex;gap:10px;margin-top:20px;">
                            <button class="action-btn primary" onclick="addUser()" style="flex:1;">添加</button>
                            <button class="action-btn danger" onclick="closeAddUserForm()" style="flex:1;">取消</button>
                        </div>
                    </div>
                </div>
            `;
            
            // 添加到页面
            document.body.insertAdjacentHTML('beforeend', formHtml);
        }
        
        function closeAddUserForm() {
            const modal = document.getElementById('addUserModal');
            if (modal) {
                modal.remove();
            }
        }
        
        function addUser() {
            const username = document.getElementById('addUsername').value.trim();
            const password = document.getElementById('addPassword').value;
            const phone = document.getElementById('addPhone').value.trim();
            const email = document.getElementById('addEmail').value.trim();
            
            // 基本验证
            if (!username) {
                showToast('用户名不能为空');
                return;
            }
            
            if (!password) {
                showToast('密码不能为空');
                return;
            }
            
            // 发送请求
            const formData = new FormData();
            formData.append('action', 'addUser');
            formData.append('username', username);
            formData.append('password', password);
            if (phone) formData.append('phone', phone);
            if (email) formData.append('email', email);
            
            fetch(contextPath + '/admin', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                if (data.code === 0) {
                    closeAddUserForm();
                    loadUsers(); // 重新加载用户列表
                }
            })
            .catch(error => {
                showToast('添加用户失败: ' + error.message);
            });
        }
        
        // 初始化
        loadStats();
        
        // 绑定上传表单事件
        document.getElementById('uploadForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const fileType = document.getElementById('fileType').value;
            const fileName = document.getElementById('fileName').value.trim();
            const fileInput = document.getElementById('file');
            
            // 验证表单
            if (!fileType) {
                showToast('请选择文件类型');
                return;
            }
            
            if (!fileName) {
                showToast('请输入文件名');
                return;
            }
            
            if (!fileInput.files || fileInput.files.length === 0) {
                showToast('请选择要上传的文件');
                return;
            }
            
            // 创建FormData对象
            const formData = new FormData();
            formData.append('fileType', fileType);
            formData.append('fileName', fileName);
            formData.append('file', fileInput.files[0]);
            
            // 显示上传中状态
            const resultDiv = document.getElementById('uploadResult');
            resultDiv.style.display = 'block';
            resultDiv.style.background = 'rgba(212,175,55,0.1)';
            resultDiv.style.color = '#d4af37';
            resultDiv.innerHTML = '📤 文件上传中...';
            
            // 发送上传请求
            fetch(contextPath + '/upload', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.code === 0) {
                    resultDiv.style.background = 'rgba(74,222,128,0.1)';
                    resultDiv.style.color = '#4ade80';
                    resultDiv.innerHTML = '✅ ' + data.message;
                    showToast('上传成功');
                    
                    // 清空表单
                    document.getElementById('uploadForm').reset();
                } else {
                    resultDiv.style.background = 'rgba(255,107,107,0.1)';
                    resultDiv.style.color = '#ff6b6b';
                    resultDiv.innerHTML = '❌ ' + data.message;
                    showToast('上传失败: ' + data.message);
                }
            })
            .catch(error => {
                resultDiv.style.background = 'rgba(255,107,107,0.1)';
                resultDiv.style.color = '#ff6b6b';
                resultDiv.innerHTML = '❌ 上传失败: ' + error.message;
                showToast('上传失败: ' + error.message);
            });
        });
    </script>
</body>
</html>
