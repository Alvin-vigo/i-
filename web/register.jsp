<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %> <%-- 导入JDBC包，预留数据库操作 --%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改密码 | i谦之家</title>
    <style>
        /* 复用主页面全局样式，保持风格统一 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
        }

        body {
            /* 暗金棕渐变背景（与主页面一致） */
            background: linear-gradient(135deg, #2d281f 0%, #1f1b16 50%, #181510 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* 表单容器 */
        .form-container {
            width: 100%;
            max-width: 500px;
            background: #ffffff;
            border-radius: 12px;
            padding: 40px 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        }

        /* 表单标题 */
        .form-title {
            font-size: 24px;
            color: #2d281f;
            text-align: center;
            margin-bottom: 30px;
            font-weight: 600;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0b942;
        }

        /* 表单组 */
        .form-group {
            margin-bottom: 25px;
        }

        /* 标签样式 */
        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #5c5445;
            font-size: 15px;
            font-weight: 500;
        }

        /* 输入框样式 */
        .form-input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            color: #2d281f;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #e0b942;
            box-shadow: 0 0 0 3px rgba(224, 185, 66, 0.1);
        }

        /* 错误提示 */
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: none; /* 默认隐藏 */
        }

        /* 提交按钮 */
        .submit-btn {
            width: 100%;
            padding: 14px 0;
            background: linear-gradient(90deg, #2d281f 0%, #181510 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            background: linear-gradient(90deg, #181510 0%, #2d281f 100%);
        }

        /* 返回按钮 */
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #e0b942;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            color: #c8a438;
            text-decoration: underline;
        }

        /* 成功提示弹窗 */
        .success-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }

        .success-modal.show {
            opacity: 1;
            visibility: visible;
        }

        .modal-content {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px 40px;
            text-align: center;
            max-width: 400px;
            width: 100%;
        }

        .modal-icon {
            font-size: 50px;
            color: #e0b942;
            margin-bottom: 15px;
        }

        .modal-title {
            font-size: 20px;
            color: #2d281f;
            margin-bottom: 10px;
        }

        .modal-desc {
            color: #5c5445;
            margin-bottom: 20px;
        }

        .modal-btn {
            padding: 10px 25px;
            background: #e0b942;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .modal-btn:hover {
            background: #c8a438;
        }

        /* 响应式适配 */
        @media (max-width: 480px) {
            .form-container {
                padding: 30px 20px;
            }

            .form-title {
                font-size: 22px;
            }

            .form-input {
                padding: 11px 12px;
                font-size: 15px;
            }
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2 class="form-title">修改密码</h2>
    <!-- 表单：提交到ModifyPwdServlet处理 -->
    <form id="modifyPwdForm" action="${pageContext.request.contextPath}/modifyPwd" method="post">
        <!-- 原密码 -->
        <div class="form-group">
            <label for="oldPwd" class="form-label">原密码</label>
            <input type="password" id="oldPwd" name="oldPwd" class="form-input" placeholder="请输入原密码" required>
            <div class="error-message" id="oldPwdError">原密码输入错误</div>
        </div>

        <!-- 新密码 -->
        <div class="form-group">
            <label for="newPwd" class="form-label">新密码</label>
            <input type="password" id="newPwd" name="newPwd" class="form-input" placeholder="请输入6-16位新密码（字母+数字）" required>
            <div class="error-message" id="newPwdError">新密码格式不正确（6-16位字母+数字）</div>
        </div>

        <!-- 确认新密码 -->
        <div class="form-group">
            <label for="confirmPwd" class="form-label">确认新密码</label>
            <input type="password" id="confirmPwd" name="confirmPwd" class="form-input" placeholder="请再次输入新密码" required>
            <div class="error-message" id="confirmPwdError">两次输入的密码不一致</div>
        </div>

        <!-- 提交按钮 -->
        <button type="submit" class="submit-btn">确认修改</button>

        <!-- 返回主页面链接 -->
        <a href="${pageContext.request.contextPath}/main.jsp" class="back-link">返回主页面</a>
    </form>
</div>

<!-- 成功提示弹窗 -->
<div class="success-modal" id="successModal">
    <div class="modal-content">
        <div class="modal-icon">✓</div>
        <h3 class="modal-title">修改成功！</h3>
        <p class="modal-desc">您的密码已成功更新，请使用新密码登录</p>
        <button class="modal-btn" id="closeModal">确定</button>
    </div>
</div>

<script>
    // 1. 表单前端验证
    const form = document.getElementById('modifyPwdForm');
    const oldPwd = document.getElementById('oldPwd');
    const newPwd = document.getElementById('newPwd');
    const confirmPwd = document.getElementById('confirmPwd');
    const oldPwdError = document.getElementById('oldPwdError');
    const newPwdError = document.getElementById('newPwdError');
    const confirmPwdError = document.getElementById('confirmPwdError');
    const successModal = document.getElementById('successModal');
    const closeModal = document.getElementById('closeModal');

    // 新密码正则：6-16位，包含字母和数字
    const pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,16}$/;

    form.addEventListener('submit', function(e) {
        let isValid = true;

        // 验证新密码格式
        if (!pwdReg.test(newPwd.value)) {
            newPwdError.style.display = 'block';
            isValid = false;
        } else {
            newPwdError.style.display = 'none';
        }

        // 验证两次密码一致
        if (newPwd.value !== confirmPwd.value) {
            confirmPwdError.style.display = 'block';
            isValid = false;
        } else {
            confirmPwdError.style.display = 'none';
        }

        // 验证新密码与原密码不同
        if (newPwd.value === oldPwd.value) {
            alert('新密码不能与原密码相同！');
            isValid = false;
        }

        // 验证不通过则阻止提交
        if (!isValid) {
            e.preventDefault();
        }
    });

    // 输入框实时校验（失去焦点时）
    newPwd.addEventListener('blur', function() {
        if (!pwdReg.test(this.value)) {
            newPwdError.style.display = 'block';
        } else {
            newPwdError.style.display = 'none';
        }
    });

    confirmPwd.addEventListener('blur', function() {
        if (this.value !== newPwd.value) {
            confirmPwdError.style.display = 'block';
        } else {
            confirmPwdError.style.display = 'none';
        }
    });

    // 2. 成功弹窗控制
    // 后端修改成功后，会通过request传递success参数，前端显示弹窗
    <% if (request.getAttribute("success") != null && (Boolean) request.getAttribute("success")) { %>
    successModal.classList.add('show');
    <% } %>

    closeModal.addEventListener('click', function() {
        successModal.classList.remove('show');
        // 关闭弹窗后跳转到登录页（可选，根据需求调整）
        window.location.href = "${pageContext.request.contextPath}/login.jsp";
    });

    // 点击弹窗外部关闭
    successModal.addEventListener('click', function(e) {
        if (e.target === successModal) {
            successModal.classList.remove('show');
            window.location.href = "${pageContext.request.contextPath}/login.jsp";
        }
    });
</script>
</body>
</html>