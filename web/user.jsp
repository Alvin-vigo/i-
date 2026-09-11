<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 | i谦之家</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #1a1815 100%); min-height: 100vh; color: #f0f0f0; }
        
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background: rgba(0,0,0,0.9); backdrop-filter: blur(10px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(212,175,55,0.2); }
        .logo { font-size: 28px; font-weight: 700; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 2px; text-decoration: none; }
        .nav-links { display: flex; gap: 35px; }
        .nav-links a { color: #f0f0f0; text-decoration: none; font-size: 15px; transition: all 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: #d4af37; }
        .nav-right a { padding: 8px 20px; border-radius: 20px; text-decoration: none; font-size: 14px; color: #d4af37; border: 1px solid #d4af37; margin-left: 10px; }
        
        .main-content { margin-top: 100px; max-width: 1200px; margin-left: auto; margin-right: auto; padding: 0 20px 60px; display: flex; gap: 30px; }
        
        /* 左侧菜单 */
        .sidebar { width: 250px; flex-shrink: 0; }
        .user-card { background: #1a1815; border-radius: 16px; padding: 30px 20px; text-align: center; border: 1px solid rgba(212,175,55,0.1); margin-bottom: 20px; }
        .user-avatar { width: 100px; height: 100px; background: linear-gradient(135deg, #d4af37, #9f7928); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 40px; color: #000; margin: 0 auto 15px; overflow: hidden; }
        .user-avatar img { width: 100%; height: 100%; border-radius: 50%; object-fit: cover; }
        .user-name { color: #f0f0f0; font-size: 20px; margin-bottom: 5px; font-weight: 500; }
        .user-role { color: #888; font-size: 14px; }
        .menu-list { background: #1a1815; border-radius: 16px; overflow: hidden; border: 1px solid rgba(212,175,55,0.1); }
        .menu-item { padding: 16px 20px; border-bottom: 1px solid rgba(212,175,55,0.05); cursor: pointer; transition: all 0.3s; display: flex; align-items: center; gap: 12px; color: #ccc; font-size: 15px; }
        .menu-item:last-child { border-bottom: none; }
        .menu-item:hover, .menu-item.active { background: rgba(212,175,55,0.1); color: #d4af37; }
        
        /* 右侧内容 */
        .content { flex: 1; }
        .content-panel { display: none; background: #1a1815; border-radius: 16px; padding: 30px; border: 1px solid rgba(212,175,55,0.1); }
        .content-panel.active { display: block; animation: fadeIn 0.3s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        
        .panel-title { font-size: 22px; margin-bottom: 25px; color: #f0f0f0; padding-bottom: 15px; border-bottom: 1px solid rgba(212,175,55,0.1); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #ccc; font-size: 14px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px 15px; background: rgba(0,0,0,0.2); border: 1px solid rgba(212,175,55,0.1); border-radius: 8px; color: #f0f0f0; font-size: 14px; }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: rgba(212,175,55,0.5); }
        
        .avatar-preview { width: 100px; height: 100px; border-radius: 50%; overflow: hidden; margin: 15px 0; border: 2px dashed rgba(212,175,55,0.3); }
        .avatar-preview img { width: 100%; height: 100%; object-fit: cover; }
        
        .form-btn { padding: 12px 30px; background: linear-gradient(90deg, #d4af37, #9f7928); color: #000; border: none; border-radius: 25px; cursor: pointer; font-size: 14px; font-weight: 500; transition: all 0.3s; }
        .form-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(212,175,55,0.3); }
        .form-btn.secondary { background: rgba(212,175,55,0.1); color: #d4af37; }
        
        /* 我的留言 */
        .my-message { padding: 20px; background: rgba(0,0,0,0.2); border-radius: 12px; margin-bottom: 15px; }
        .my-message-content { color: #ccc; font-size: 14px; line-height: 1.7; margin-bottom: 10px; }
        .my-message-meta { display: flex; justify-content: space-between; align-items: center; }
        .my-message-meta span { color: #666; font-size: 12px; }
        .my-message-meta button { padding: 5px 15px; background: rgba(255,0,0,0.1); color: #ff6b6b; border: 1px solid rgba(255,0,0,0.2); border-radius: 15px; cursor: pointer; font-size: 12px; }
        .my-message-meta button:hover { background: rgba(255,0,0,0.2); }
        
        .empty-tip { text-align: center; padding: 40px 20px; color: #666; }
        .toast { position: fixed; top: 100px; left: 50%; transform: translateX(-50%); padding: 12px 30px; background: rgba(212,175,55,0.9); color: #000; border-radius: 25px; font-size: 14px; z-index: 3000; display: none; opacity: 0; transition: opacity 0.3s ease; }
        .toast.show { display: block; opacity: 1; }
        .toast.hide { opacity: 0; }
        
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; }
            .main-content { flex-direction: column; margin-top: 80px; }
            .sidebar { width: 100%; }
            .user-card { display: flex; align-items: center; text-align: left; padding: 20px; }
            .user-avatar { width: 70px; height: 70px; font-size: 28px; margin: 0 15px 0 0; flex-shrink: 0; }
            .user-info { flex: 1; }
            .user-name { font-size: 18px; margin-bottom: 3px; }
            .user-role { font-size: 13px; }
            .menu-list { display: flex; overflow-x: auto; }
            .menu-item { border-bottom: none; border-right: 1px solid rgba(212,175,55,0.05); white-space: nowrap; }
            .menu-item:last-child { border-right: none; }
            .content-panel { padding: 20px; }
            .panel-title { font-size: 20px; }
        }
    </style>
</head>
<body>
    <!-- 顶部导航 -->
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">i谦之家</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/info.jsp">歌手资料</a>
            <a href="${pageContext.request.contextPath}/works.jsp">作品展示</a>
            <a href="${pageContext.request.contextPath}/forum.jsp">粉丝互动</a>
            <a href="${pageContext.request.contextPath}/download.jsp">资源下载</a>
        </div>
        <div class="nav-right">
            <a href="${pageContext.request.contextPath}/logout">退出</a>
        </div>
    </nav>

    <div class="main-content">
        <!-- 左侧菜单 -->
        <div class="sidebar">
            <div class="user-card">
                <%
                    com.jisu.entity.User sidebarUser = (com.jisu.entity.User) session.getAttribute("user");
                    String avatarUrl = sidebarUser != null && sidebarUser.getAvatar() != null ? sidebarUser.getAvatar() : "/images/default-avatar.png";
                %>
                <div class="user-avatar">
                    <img src="<%= avatarUrl %>" alt="头像" onerror="handleAvatarError(this)">
                </div>
                <div class="user-name"><%= session.getAttribute("loginUser") %></div>
                <div class="user-role">谦友</div>
                <div style="margin-top: 20px; text-align: center;">
                    <form id="avatarForm" enctype="multipart/form-data">
                        <input type="file" id="avatarFile" accept="image/*" style="display: none;" onchange="uploadAvatar()">
                        <button type="button" class="form-btn secondary" onclick="document.getElementById('avatarFile').click()" style="font-size: 12px; padding: 6px 12px;">更换头像</button>
                    </form>
                </div>
            </div>
            <div class="menu-list">
                <div class="menu-item active" data-panel="profile"><span>👤</span> 个人信息</div>
                <div class="menu-item" data-panel="password"><span>🔒</span> 修改密码</div>
                <div class="menu-item" data-panel="messages"><span>💬</span> 我的留言</div>
            </div>
        </div>

        <!-- 右侧内容 -->
        <div class="content">
            <!-- 个人信息 -->
            <div class="content-panel active" id="panel-profile">
                <h3 class="panel-title">个人信息</h3>
                <form id="profileForm">
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" value="<%= session.getAttribute("loginUser") %>" readonly>
                    </div>
                    <div class="form-group">
                        <label>手机号</label>
                        <input type="tel" id="phone" placeholder="请输入手机号">
                    </div>
                    <div class="form-group">
                        <label>邮箱</label>
                        <input type="email" id="email" placeholder="请输入邮箱地址">
                    </div>
                    <div class="form-group">
                        <label>头像预览</label>
                        <div class="avatar-preview">
                            <img id="profileAvatarPreview" src="<%= avatarUrl %>" alt="头像预览" onerror="handleAvatarError(this)">
                        </div>
                        <input type="file" id="profileAvatar" accept="image/*" style="display: none;" onchange="previewAvatar(this)">
                        <button type="button" class="form-btn secondary" onclick="document.getElementById('profileAvatar').click()" style="font-size: 12px; padding: 6px 12px;">选择新头像</button>
                    </div>
                    <button type="button" class="form-btn" onclick="updateProfile()">保存信息</button>
                </form>
            </div>

            <!-- 修改密码 -->
            <div class="content-panel" id="panel-password">
                <h3 class="panel-title">修改密码</h3>
                <form id="passwordForm">
                    <div class="form-group">
                        <label>原密码</label>
                        <input type="password" id="oldPassword" placeholder="请输入原密码" required>
                    </div>
                    <div class="form-group">
                        <label>新密码</label>
                        <input type="password" id="newPassword" placeholder="6-16位，包含字母和数字" required>
                    </div>
                    <div class="form-group">
                        <label>确认新密码</label>
                        <input type="password" id="confirmPassword" placeholder="请再次输入新密码" required>
                    </div>
                    <button type="button" class="form-btn" onclick="updatePassword()">确认修改</button>
                </form>
            </div>

            <!-- 我的留言 -->
            <div class="content-panel" id="panel-messages">
                <h3 class="panel-title">我的留言</h3>
                <div id="myMessageList">
                    <!-- 留言将通过JS加载 -->
                </div>
            </div>
        </div>
    </div>

    <div class="toast" id="toast"></div>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        // 处理头像加载错误
        function handleAvatarError(img) {
            img.src = '/images/default-avatar.png';
            img.style.background = '#d4af37';
            img.style.display = 'flex';
            img.style.alignItems = 'center';
            img.style.justifyContent = 'center';
            img.style.fontSize = '40px';
            img.style.color = '#000';
            
            // 获取用户名首字母作为默认头像文本
            const loginUser = '<%= session.getAttribute("loginUser") != null ? session.getAttribute("loginUser").toString().charAt(0) : "谦" %>';
            img.parentNode.innerHTML = loginUser;
        }
        
        // HTML转义函数
        function escapeHtml(text) {
            if (!text) return '';
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        // 菜单切换
        document.querySelectorAll('.menu-item').forEach(item => {
            item.addEventListener('click', () => {
                document.querySelectorAll('.menu-item').forEach(i => i.classList.remove('active'));
                document.querySelectorAll('.content-panel').forEach(p => p.classList.remove('active'));
                
                item.classList.add('active');
                const panelId = 'panel-' + item.dataset.panel;
                document.getElementById(panelId).classList.add('active');
                
                if (item.dataset.panel === 'messages') {
                    loadMyMessages();
                }
            });
        });
        
        // 加载用户信息
        function loadUserInfo() {
            fetch(contextPath + '/user?action=info')
                .then(response => response.json())
                .then(data => {
                    if (data.code === 0 && data.data) {
                        document.getElementById('phone').value = data.data.phone || '';
                        document.getElementById('email').value = data.data.email || '';
                        
                        // 更新头像显示
                        const avatarUrl = data.data.avatar || '/images/default-avatar.png';
                        document.querySelectorAll('.user-avatar img, #profileAvatarPreview').forEach(img => {
                            img.src = avatarUrl;
                        });
                    }
                })
                .catch(error => {
                    console.error('加载用户信息失败:', error);
                });
        }
        
        // 预览头像
        function previewAvatar(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profileAvatarPreview').src = e.target.result;
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
        
        // 更新个人信息
        function updateProfile() {
            const phone = document.getElementById('phone').value;
            const email = document.getElementById('email').value;
            const avatarFile = document.getElementById('profileAvatar').files[0];
            
            if (avatarFile) {
                // 如果选择了头像文件，则使用FormData上传
                const formData = new FormData();
                formData.append('phone', phone);
                formData.append('email', email);
                formData.append('avatar', avatarFile);
                
                fetch(contextPath + '/user?action=updateWithAvatar', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) {
                        // 更新成功后重新加载用户信息
                        setTimeout(() => {
                            loadUserInfo();
                        }, 1500);
                    }
                })
                .catch(error => {
                    showToast('更新失败，请稍后重试');
                    console.error('更新个人信息失败:', error);
                });
            } else {
                // 没有选择头像文件，只更新基本信息
                fetch(contextPath + '/user?action=update', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'phone=' + encodeURIComponent(phone) + '&email=' + encodeURIComponent(email)
                })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) {
                        // 更新成功后重新加载用户信息
                        setTimeout(() => {
                            loadUserInfo();
                        }, 1500);
                    }
                })
                .catch(error => {
                    showToast('更新失败，请稍后重试');
                    console.error('更新个人信息失败:', error);
                });
            }
        }
        
        // 修改密码
        function updatePassword() {
            const oldPwd = document.getElementById('oldPassword').value;
            const newPwd = document.getElementById('newPassword').value;
            const confirmPwd = document.getElementById('confirmPassword').value;
            
            if (!oldPwd || !newPwd || !confirmPwd) {
                showToast('请填写完整信息');
                return;
            }
            
            if (newPwd !== confirmPwd) {
                showToast('两次密码输入不一致');
                return;
            }
            
            if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,16}$/.test(newPwd)) {
                showToast('密码需6-16位，包含字母和数字');
                return;
            }
            
            fetch(contextPath + '/user?action=updatePassword', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'oldPassword=' + encodeURIComponent(oldPwd) + '&newPassword=' + encodeURIComponent(newPwd)
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                if (data.code === 0) {
                    // 密码修改成功，清除表单并跳转到登录页
                    document.getElementById('passwordForm').reset();
                    setTimeout(() => {
                        window.location.href = contextPath + '/login.jsp';
                    }, 1500);
                }
            })
            .catch(error => {
                showToast('修改失败，请稍后重试');
                console.error('修改密码失败:', error);
            });
        }
        
        // 加载我的留言
        function loadMyMessages() {
            fetch(contextPath + '/message?action=myList&page=1&pageSize=20')
                .then(response => response.json())
                .then(data => {
                    const list = document.getElementById('myMessageList');
                    if (data.code === 0 && data.data.list.length > 0) {
                        list.innerHTML = data.data.list.map(msg => 
                            '<div class="my-message" data-id="' + msg.id + '">' +
                            '    <div class="my-message-content">' + escapeHtml(msg.content) + '</div>' +
                            '    <div class="my-message-meta">' +
                            '        <span>' + msg.createTime + ' | ❤ ' + (msg.likeCount || 0) + '</span>' +
                            '        <button onclick="deleteMessage(' + msg.id + ')">删除</button>' +
                            '    </div>' +
                            '</div>'
                        ).join('');
                    } else {
                        list.innerHTML = '<div class="empty-tip">暂无留言记录</div>';
                    }
                })
                .catch(error => {
                    document.getElementById('myMessageList').innerHTML = '<div class="empty-tip">加载失败，请稍后重试</div>';
                    console.error('加载留言失败:', error);
                });
        }
        
        // 删除留言
        function deleteMessage(id) {
            if (!confirm('确定要删除这条留言吗？')) return;
            
            fetch(contextPath + '/message?action=delete&id=' + id, { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    showToast(data.message);
                    if (data.code === 0) {
                        loadMyMessages();
                    }
                })
                .catch(error => {
                    showToast('删除失败，请稍后重试');
                    console.error('删除留言失败:', error);
                });
        }
        
        // 上传头像
        function uploadAvatar() {
            const fileInput = document.getElementById('avatarFile');
            const file = fileInput.files[0];
            
            if (!file) return;
            
            const formData = new FormData();
            formData.append('avatar', file);
            
            fetch(contextPath + '/user?action=updateAvatar', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                showToast(data.message);
                if (data.code === 0) {
                    // 上传成功后重新加载用户信息
                    setTimeout(() => {
                        loadUserInfo();
                    }, 1500);
                }
            })
            .catch(error => {
                showToast('上传失败，请稍后重试');
                console.error('上传头像失败:', error);
            });
        }
        
        function showToast(msg) {
            const toast = document.getElementById('toast');
            toast.textContent = msg;
            toast.classList.add('show');
            setTimeout(() => {
                toast.classList.remove('show');
            }, 2000);
        }
        
        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', function() {
            loadUserInfo();
        });
    </script>
</body>
</html>