<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>谦友登录 | i谦之家</title>
    <style>
        /* 全局样式重置与基础配置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
        }

        body {
            /* 页面背景：黑金低饱和渐变 */
            background: linear-gradient(135deg, #0a0a0a 0%, #221f1f 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* 主容器 - 左右布局 */
        .login-container {
            width: 100%;
            max-width: 900px;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 50px rgba(0, 0, 0, 0.5);
            display: flex;
            overflow: hidden;
            position: relative;
        }

        /* 主容器装饰：黑金渐变边框（视觉增强） */
        .login-container::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            border: 2px solid transparent;
            border-radius: 18px;
            padding: 2px;
            background: linear-gradient(135deg, #000000, #d4af37) border-box;
            -webkit-mask: linear-gradient(#fff 0 0) padding-box, linear-gradient(#fff 0 0);
            -webkit-mask-composite: xor;
            mask-composite: exclude;
            pointer-events: none;
        }

        /* 左侧标题区域 - 黑金渐变核心区 */
        .login-left {
            flex: 1;
            /* 左侧背景：黑金渐变（从纯黑到鎏金） */
            background: linear-gradient(135deg, #000000 0%, #332b18 50%, #000000 100%);
            color: #ffffff;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 40px 30px;
            position: relative;
        }

        /* 左侧渐变光效装饰 */
        .login-left::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(45deg, rgba(212, 175, 55, 0.1) 0%, rgba(212, 175, 55, 0) 100%);
            pointer-events: none;
        }

        .title-main {
            font-size: 52px;
            font-weight: 700;
            /* 标题文字渐变：黑金过渡 */
            background: linear-gradient(90deg, #f8e190 0%, #d4af37 50%, #9f7928 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            margin-bottom: 12px;
            letter-spacing: 3px;
            text-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
        }

        .title-sub {
            font-size: 20px;
            /* 副标题浅金渐变 */
            background: linear-gradient(90deg, #d4af37 0%, #f8e190 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            opacity: 0.9;
            letter-spacing: 1.5px;
        }

        /* 右侧登录表单区域 */
        .login-right {
            flex: 1;
            padding: 50px 40px;
            /* 右侧浅背景：微渐变 */
            background: linear-gradient(180deg, #fefefe 0%, #f5f5f0 100%);
        }

        .login-title {
            text-align: center;
            margin-bottom: 35px;
            /* 登录标题黑金渐变 */
            background: linear-gradient(90deg, #000000 0%, #332b18 50%, #000000 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            font-size: 30px;
            font-weight: 600;
            letter-spacing: 1px;
        }

        .login-title span {
            /* 标题金色点缀渐变 */
            background: linear-gradient(90deg, #f8e190 0%, #d4af37 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
        }

        /* 表单项样式 */
        .form-item {
            margin-bottom: 25px;
            position: relative;
        }

        .form-item label {
            display: block;
            margin-bottom: 8px;
            /* 标签黑金渐变 */
            background: linear-gradient(90deg, #000000 0%, #332b18 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            font-size: 15px;
            font-weight: 500;
        }

        .form-item input {
            width: 100%;
            height: 50px;
            padding: 0 18px;
            border: 1px solid #e8e0c8;
            border-radius: 8px;
            font-size: 15px;
            color: #221f1f;
            transition: all 0.3s ease;
            /* 输入框背景微渐变 */
            background: linear-gradient(180deg, #ffffff 0%, #faf7ed 100%);
        }

        /* 输入框聚焦效果（黑金渐变边框） */
        .form-item input:focus {
            outline: none;
            /* 聚焦边框：黑金渐变 */
            border: 1px solid transparent;
            background: linear-gradient(#ffffff, #ffffff) padding-box,
            linear-gradient(90deg, #000000 0%, #d4af37 100%) border-box;
            background-clip: padding-box, border-box;
            box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.15);
        }

        .form-item input::placeholder {
            color: #999;
            font-size: 14px;
        }

        /* 功能链接（忘记密码/注册） */
        .form-links {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .form-links a {
            /* 链接黑金渐变 */
            background: linear-gradient(90deg, #9f7928 0%, #d4af37 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            text-decoration: none;
            margin-left: 15px;
            transition: all 0.3s ease;
        }

        .form-links a:hover {
            /* hover时加深金色渐变 */
            background: linear-gradient(90deg, #d4af37 0%, #f8e190 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            text-decoration: underline;
        }

        /* 登录按钮（黑金渐变核心） */
        .login-btn {
            width: 100%;
            height: 52px;
            /* 按钮黑金渐变（从黑到鎏金） */
            background: linear-gradient(90deg, #000000 0%, #332b18 50%, #d4af37 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        /* 按钮hover渐变反转+光效 */
        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(212, 175, 55, 0.25);
            background: linear-gradient(90deg, #d4af37 0%, #332b18 50%, #000000 100%);
        }

        .login-btn:active {
            transform: translateY(0);
            box-shadow: 0 4px 10px rgba(212, 175, 55, 0.25);
        }

        /* 按钮内部光效（增强渐变质感） */
        .login-btn::before {
            content: "";
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                    to right,
                    transparent,
                    rgba(255, 255, 255, 0.1),
                    transparent
            );
            transform: rotate(30deg);
            animation: shine 3s infinite linear;
        }

        @keyframes shine {
            0% {
                transform: rotate(30deg) translateX(-100%);
            }
            100% {
                transform: rotate(30deg) translateX(100%);
            }
        }

        /* 底部提示 */
        .login-tip {
            text-align: center;
            margin-top: 25px;
            font-size: 13px;
            /* 提示文字黑金渐变 */
            background: linear-gradient(90deg, #332b18 0%, #666 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
        }

        .login-tip span {
            /* 测试账号金色渐变 */
            background: linear-gradient(90deg, #d4af37 0%, #9f7928 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            font-weight: 500;
        }

        /* 响应式适配（手机端改为上下布局） */
        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }

            .login-left {
                padding: 30px 20px;
                min-height: 200px;
            }

            .title-main {
                font-size: 40px;
            }

            .login-right {
                padding: 30px 25px;
            }

            .login-title {
                font-size: 26px;
                margin-bottom: 25px;
            }

            .form-item input {
                height: 46px;
            }

            .login-btn {
                height: 48px;
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
<div class="login-container">
    <!-- 左侧标题区域 -->
    <div class="login-left">
        <h1 class="title-main">i谦之家</h1>
        <p class="title-sub">谦友专属交流平台</p>
    </div>

    <!-- 右侧登录表单区域 -->
    <div class="login-right">
        <h3 class="login-title">谦友<span>登录</span></h3>
        <!-- 若后端用Servlet，调整action路径 -->
        <form action="${pageContext.request.contextPath}/login" method="post">
            <!-- 可选：显示后端传递的错误信息 -->
            <% if (request.getAttribute("errorMsg") != null) { %>
            <div style="color: #d43f3a; text-align: center; margin-bottom: 15px;">
                ${errorMsg}
            </div>
            <% } %>

            <div class="form-item">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" required placeholder="请输入用户名（默认：admin）"
                       value="${param.username}"> <!-- 回显用户名（可选） -->
            </div>
            <div class="form-item">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" required placeholder="请输入密码（默认：123456）">
            </div>

            <div class="form-links">
                <a href="${pageContext.request.contextPath}/forget-password.jsp" id="forgetPwd">忘记密码？</a>
                <a href="${pageContext.request.contextPath}/signup.jsp" id="register">新用户注册</a>
            </div>

            <button type="submit" class="login-btn">登录</button>
        </form>
    </div>
</div>
</body>
</html>