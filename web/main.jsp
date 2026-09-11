<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录成功 | i谦之家</title>
    <style>
        /* 全局样式重置与基础配置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
        }

        body {
            /* 暗金棕渐变背景 */
            background: linear-gradient(135deg, #2d281f 0%, #1f1b16 50%, #181510 100%);
            min-height: 100vh;
            display: flex;
        }

        /* 左侧菜单栏 */
        .sidebar {
            width: 220px;
            background: linear-gradient(180deg, #211e18 0%, #181510 100%);
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2);
            padding: 30px 0;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 10;
        }

        .sidebar-title {
            color: #e0b942;
            font-size: 18px;
            font-weight: 600;
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(224, 185, 66, 0.2);
            margin: 0 20px 20px;
            letter-spacing: 1px;
        }

        .menu-list {
            list-style: none;
        }

        .menu-item {
            margin-bottom: 8px;
        }

        .menu-link {
            display: block;
            padding: 12px 25px;
            color: #f0f0f0;
            text-decoration: none;
            font-size: 15px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        /* 菜单激活状态样式 */
        .menu-link.active {
            background: rgba(224, 185, 66, 0.1);
            color: #e0b942;
            border-left-color: #e0b942;
        }

        .menu-link:hover {
            background: rgba(224, 185, 66, 0.1);
            color: #e0b942;
            border-left-color: #e0b942;
            padding-left: 30px;
        }

        /* 右侧主内容区 */
        .main-content {
            flex: 1;
            margin-left: 220px;
            padding: 30px 40px;
        }

        /* 顶部导航栏 - 用户名下拉菜单核心样式 */
        .top-nav {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 15px 0;
            margin-bottom: 40px;
            border-bottom: 1px solid rgba(224, 185, 66, 0.2);
            position: relative;
        }

        /* 用户名触发按钮 */
        .user-trigger {
            color: #e0b942;
            font-size: 16px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 8px 15px;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .user-trigger:hover {
            background: rgba(224, 185, 66, 0.1);
        }

        .user-trigger::before {
            content: "👤";
            font-size: 18px;
        }

        .user-trigger::after {
            content: "▼";
            font-size: 12px;
            transition: transform 0.3s ease;
        }

        /* 下拉菜单展开时的箭头旋转 */
        .user-trigger.active::after {
            transform: rotate(180deg);
        }

        /* 下拉菜单容器 */
        .user-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 8px;
            width: 180px;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
            list-style: none;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            z-index: 999;
        }

        /* 下拉菜单展开状态 */
        .user-dropdown.show {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        /* 下拉菜单项 */
        .dropdown-item {
            padding: 12px 20px;
            border-bottom: 1px solid #f0f0f0;
        }

        .dropdown-item:last-child {
            border-bottom: none;
        }

        .dropdown-link {
            color: #2d281f;
            text-decoration: none;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .dropdown-link:hover {
            color: #e0b942;
            padding-left: 5px;
        }

        /* 菜单项图标 */
        .dropdown-link::before {
            font-size: 16px;
        }

        .modify-pwd::before {
            content: "🔒";
        }

        .logout::before {
            content: "🚪";
        }

        /* 成功提示区域 */
        .success-container {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 12px;
            padding: 50px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            text-align: center;
            display: block; /* 初始显示成功提示 */
        }

        /* 菜单内容容器样式 */
        .menu-content {
            max-width: 1000px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 12px;
            padding: 30px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            display: none; /* 默认隐藏所有菜单内容 */
        }

        /* 激活的内容显示 */
        .menu-content.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }

        /* 内容淡入动画 */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 菜单内容标题样式 */
        .content-title {
            font-size: 24px;
            color: #2d281f;
            margin-bottom: 20px;
            font-weight: 600;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0b942;
        }

        /* 菜单内容文本样式 */
        .content-text {
            font-size: 16px;
            color: #5c5445;
            line-height: 1.8;
            margin-bottom: 20px;
        }

        /* 内容列表样式 */
        .content-list {
            list-style: disc;
            padding-left: 20px;
            color: #5c5445;
            line-height: 1.8;
        }

        .success-icon {
            font-size: 60px;
            color: #e0b942;
            margin-bottom: 20px;
        }

        .success-title {
            font-size: 28px;
            color: #2d281f;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .success-desc {
            font-size: 16px;
            color: #5c5445;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        /* 退出登录备用按钮（可保留/删除） */
        .logout-btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(90deg, #2d281f 0%, #181510 100%);
            color: #ffffff;
            text-decoration: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            background: linear-gradient(90deg, #181510 0%, #2d281f 100%);
        }

        /* 响应式适配 */
        @media (max-width: 768px) {
            .sidebar {
                width: 180px;
            }

            .main-content {
                margin-left: 180px;
                padding: 20px 25px;
            }

            .success-container, .menu-content {
                padding: 40px 25px;
            }

            .success-title, .content-title {
                font-size: 24px;
            }
        }

        @media (max-width: 480px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
            }

            .main-content {
                margin-left: 0;
                padding: 20px 15px;
            }

            .menu-list {
                display: flex;
                overflow-x: auto;
                padding: 0 10px;
            }

            .menu-item {
                margin: 0 5px;
            }

            .menu-link {
                padding: 10px 15px;
                border-left: none;
                border-bottom: 3px solid transparent;
            }

            /* 移动端菜单激活状态调整 */
            .menu-link.active {
                border-left: none;
                border-bottom-color: #e0b942;
            }

            .menu-link:hover {
                padding-left: 15px;
                border-left: none;
                border-bottom-color: #e0b942;
            }

            /* 移动端下拉菜单适配 */
            .user-dropdown {
                width: 160px;
            }
        }
    </style>
</head>
<body>
<!-- 左侧菜单栏：给第一个菜单添加默认 active -->
<div class="sidebar">
    <h3 class="sidebar-title">功能菜单</h3>
    <ul class="menu-list">
        <li class="menu-item"><a href="#menu1" class="menu-link active" data-target="content1">菜单选项1</a></li>
        <li class="menu-item"><a href="#menu2" class="menu-link" data-target="content2">菜单选项2</a></li>
        <li class="menu-item"><a href="#menu3" class="menu-link" data-target="content3">菜单选项3</a></li>
        <li class="menu-item"><a href="#menu4" class="menu-link" data-target="content4">菜单选项4</a></li>
    </ul>
</div>

<!-- 右侧主内容区 -->
<div class="main-content">
    <!-- 顶部导航栏（用户名下拉菜单） -->
    <div class="top-nav">
        <div class="user-trigger" id="userTrigger">
            <!-- 修复：移除冗余的"当前登录："静态文本，仅保留元素用于JS赋值 -->
            <span id="nav-username"><%= session.getAttribute("loginUser") != null ? session.getAttribute("loginUser") : "未知用户" %></span>
        </div>
        <!-- 下拉菜单：退出链接指向 LogoutServlet -->
        <ul class="user-dropdown" id="userDropdown">
            <li class="dropdown-item">
                <a href="${pageContext.request.contextPath}/register.jsp" class="dropdown-link modify-pwd">修改密码</a>
            </li>
            <li class="dropdown-item">
                <a href="${pageContext.request.contextPath}/logout" class="dropdown-link logout">退出登录</a>
            </li>
        </ul>
    </div>

    <!-- 登录成功提示区域（初始显示） -->
    <div class="success-container" id="successContainer">
        <div class="success-icon">✓</div>
        <h2 class="success-title">登录成功！</h2>
        <p class="success-desc">欢迎回来，<span id="success-username">
            <%= session.getAttribute("loginUser") != null ? session.getAttribute("loginUser") : "未知用户" %>
        </span>！您已成功进入i谦之家，可使用左侧菜单进行相关操作。</p>
        <!-- 备用退出按钮：指向 LogoutServlet -->
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">退出登录</a>
    </div>

    <!-- 菜单1内容 -->
    <div class="menu-content" id="content1">
        <h3 class="content-title">菜单选项1 - 数据概览</h3>
        <p class="content-text">欢迎查看系统数据概览页面，这里展示了平台的核心运营数据：</p>
        <ul class="content-list">
            <li>用户总数：1,258 人</li>
            <li>今日新增：28 人</li>
            <li>活跃用户：896 人</li>
            <li>数据更新时间：2025-11-28 10:30</li>
        </ul>
        <p class="content-text">您可以通过此页面快速了解平台整体运营状况，如需查看详细数据，请点击下方的"导出报表"按钮（示例）。</p>
    </div>


    <!-- 菜单2内容 -->
    <div class="menu-content" id="content2">
        <h3 class="content-title">菜单选项2 - 用户管理</h3>
        <p class="content-text">用户管理页面支持以下操作：</p>
        <ul class="content-list">
            <li>查看所有用户详细信息</li>
            <li>修改用户权限和角色</li>
            <li>禁用/启用用户账号</li>
            <li>导出用户列表数据</li>
        </ul>
        <p class="content-text">操作提示：点击用户名可进入详情页，批量操作请先勾选用户列表前的复选框。</p>

        <!-- 下载功能区域（修改后） -->
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #f0f0f0;">
            <h4 style="color: #2d281f; font-size: 16px; margin-bottom: 15px;">数据下载中心</h4>
            <p class="content-text" style="margin-bottom: 15px;">下载相关数据文件，支持Excel格式导出：</p>

            <!-- 下载按钮组（链接指向DownloadServlet，传递fileName参数） -->
            <div style="display: flex; gap: 15px; flex-wrap: wrap;">
                <!-- 下载用户列表：fileName=用户列表.xlsx -->
                <a href="${pageContext.request.contextPath}/download?fileName=q.xlsx"
                   class="logout-btn">
                    📊 下载用户列表（Excel）
                </a>

                <!-- 下载用户详情模板：fileName=用户详情模板.xlsx -->
                <a href="${pageContext.request.contextPath}/download?fileName=用户详情模板.xlsx"
                   class="logout-btn"
                   style="background: linear-gradient(90deg, #e0b942 0%, #c8a438 100%);">
                    📋 下载用户详情模板
                </a>
            </div>

            <!-- 下载说明（更新路径说明） -->
            <p style="margin-top: 15px; font-size: 14px; color: #888;">
                提示：下载文件默认保存为Excel格式，文件路径：src/main/resources/data
            </p>
        </div>
    </div>

    <!-- 菜单3内容 -->
<%--    <div class="menu-content" id="content3">--%>
<%--        <h3 class="content-title">菜单选项3 - 系统设置</h3>--%>
<%--        <p class="content-text">系统设置页面包含以下配置项：</p>--%>
<%--        <ul class="content-list">--%>
<%--            <li>网站基本信息配置（名称、logo、联系方式）</li>--%>
<%--            <li>邮件服务器设置</li>--%>
<%--            <li>权限规则配置</li>--%>
<%--            <li>缓存清理与系统日志</li>--%>
<%--        </ul>--%>
<%--        <p class="content-text">注意：修改系统设置需要管理员权限，所有更改将在保存后立即生效，请谨慎操作。</p>--%>
<%--    </div>--%>
    <div class="menu-content" id="content3">
        <h3 class="content-title">视频播放中心 - 数据概览</h3>
        <p class="content-text">欢迎查看视频播放中心，这里展示了平台的视频资源和播放数据：</p>
        <ul class="content-list">
            <li>视频总数：86 个</li>
            <li>今日播放量：1,258 次</li>
            <li>热门视频：《系统操作指南》</li>
            <li>数据更新时间：2025-11-28 10:30</li>
        </ul>

        <!-- 快速播放按钮区域 -->
        <div style="margin: 30px 0;">
            <h4 style="color: #2d281f; font-size: 18px; margin-bottom: 15px;">快速播放</h4>
            <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=1" class="btn play-btn">▶️ 播放系统操作指南</a>
            <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=2" class="btn play-btn">▶️ 播放新手入门教程</a>
            <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=3" class="btn play-btn">▶️ 播放高级功能讲解</a>
        </div>

        <!-- 视频列表区域 -->
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #f0f0f0;">
            <h4 style="color: #2d281f; font-size: 18px; margin-bottom: 20px;">视频资源列表</h4>

            <div class="video-list">
                <!-- 视频卡片1 -->
                <div class="video-card">
                    <h5 class="video-title">系统操作指南</h5>
                    <p class="video-desc">详细讲解平台各项功能的操作方法，适合初次使用的用户</p>
                    <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=1" class="btn play-btn">立即播放</a>
                </div>

                <!-- 视频卡片2 -->
                <div class="video-card">
                    <h5 class="video-title">新手入门教程</h5>
                    <p class="video-desc">5分钟快速上手平台核心功能，零基础也能轻松掌握</p>
                    <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=2" class="btn play-btn">立即播放</a>
                </div>

                <!-- 视频卡片3 -->
                <div class="video-card">
                    <h5 class="video-title">高级功能讲解</h5>
                    <p class="video-desc">深入讲解平台高级功能和技巧，提升使用效率</p>
                    <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=3" class="btn play-btn">立即播放</a>
                </div>

                <!-- 视频卡片4 -->
                <div class="video-card">
                    <h5 class="video-title">常见问题解答</h5>
                    <p class="video-desc">解答用户使用过程中遇到的常见问题和解决方案</p>
                    <a href="${pageContext.request.contextPath}/video/play.jsp?videoId=4" class="btn play-btn">立即播放</a>
                </div>
            </div>

            <p class="content-text" style="margin-top: 20px;">
                提示：点击"立即播放"按钮将跳转到视频播放页面，支持倍速播放、全屏观看、画质切换等功能。
            </p>
        </div>
    </div>

    <!-- 菜单4内容 -->
    <div class="menu-content" id="content4">
        <h3 class="content-title">菜单选项4 - 帮助中心</h3>
        <p class="content-text">欢迎使用帮助中心，您可以在这里找到：</p>
        <ul class="content-list">
            <li>系统操作手册（PDF下载）</li>
            <li>常见问题解答（FAQ）</li>
            <li>联系技术支持</li>
            <li>更新日志与版本说明</li>
        </ul>
        <p class="content-text">如果您在使用过程中遇到问题，建议先查看FAQ，如未解决可联系技术支持：support@iqianzhijia.com</p>
    </div>
</div>

<script>
    // 从 Session 获取用户名（JSP 渲染后传递给 JS）
    const loginUsername = "<%= session.getAttribute("loginUser") != null ? session.getAttribute("loginUser") : "未知用户" %>";
    // 修复1：给顶部导航栏用户名添加"当前登录："前缀（无重复）
    document.getElementById("nav-username").innerText = `当前登录：${loginUsername}`;
    // 修复2：同步更新成功提示区的用户名（ID 唯一）
    document.getElementById("success-username").innerText = loginUsername;

    // 用户名下拉菜单核心逻辑
    const userTrigger = document.getElementById('userTrigger');
    const userDropdown = document.getElementById('userDropdown');

    // 点击用户名切换下拉菜单显示/隐藏
    userTrigger.addEventListener('click', function(e) {
        e.stopPropagation(); // 阻止事件冒泡
        this.classList.toggle('active');
        userDropdown.classList.toggle('show');
    });

    // 点击页面其他区域关闭下拉菜单
    document.addEventListener('click', function() {
        userTrigger.classList.remove('active');
        userDropdown.classList.remove('show');
    });

    // 阻止下拉菜单内部点击触发关闭
    userDropdown.addEventListener('click', function(e) {
        e.stopPropagation();
    });

    // 菜单切换核心逻辑
    const menuLinks = document.querySelectorAll('.menu-link');
    const successContainer = document.getElementById('successContainer');
    const menuContents = document.querySelectorAll('.menu-content');

    // 修复3：移除页面加载时的强制切换逻辑，保留"初始显示成功提示"的设计
    // （用户点击菜单后再切换内容，避免闪烁）

    // 菜单点击事件
    menuLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();

            // 1. 移除所有菜单的激活状态
            menuLinks.forEach(item => item.classList.remove('active'));
            // 2. 给当前点击的菜单添加激活状态
            this.classList.add('active');

            // 3. 隐藏登录成功提示
            successContainer.style.display = 'none';

            // 4. 隐藏所有菜单内容
            menuContents.forEach(content => content.classList.remove('active'));

            // 5. 显示对应菜单内容
            const targetId = this.getAttribute('data-target');
            const targetContent = document.getElementById(targetId);
            if (targetContent) {
                targetContent.classList.add('active');
            }
        });
    });
</script>
</body>
</html>