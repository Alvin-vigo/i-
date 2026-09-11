<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>忘记密码 | i谦之家</title>
    <style>
        /* 复用全局样式，保持暗金棕风格统一 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
        }

        body {
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

        /* 步骤指示器 */
        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }

        .step-indicator::before {
            content: "";
            position: absolute;
            top: 12px;
            left: 30px;
            right: 30px;
            height: 2px;
            background: #f0f0f0;
            z-index: 1;
        }

        .step-indicator::after {
            content: "";
            position: absolute;
            top: 12px;
            left: 30px;
            height: 2px;
            background: #e0b942;
            z-index: 2;
            transition: width 0.3s ease;
        <%-- 步骤1默认宽度：1/3 --%>
            width: calc((100% - 60px) / 3);
        }

        .step-item {
            position: relative;
            z-index: 3;
            text-align: center;
            width: 33.33%;
        }

        .step-icon {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: #f0f0f0;
            color: #888;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .step-text {
            font-size: 14px;
            color: #888;
            transition: all 0.3s ease;
        }

        /* 激活步骤样式 */
        .step-item.active .step-icon {
            background: #e0b942;
            color: #ffffff;
        }

        .step-item.active .step-text {
            color: #e0b942;
            font-weight: 500;
        }

        /* 完成步骤样式 */
        .step-item.completed .step-icon {
            background: #e0b942;
            color: #ffffff;
            content: "✓";
        }

        /* 表单组 */
        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            color: #5c5445;
            font-size: 15px;
            font-weight: 500;
        }

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

        /* 验证码输入组（输入框+按钮） */
        .verify-group {
            display: flex;
            gap: 10px;
        }

        .verify-input {
            flex: 1;
        }

        .send-code-btn {
            padding: 0 20px;
            background: linear-gradient(90deg, #e0b942 0%, #c8a438 100%);
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .send-code-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        /* 错误提示 */
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        /* 按钮样式 */
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .form-btn {
            flex: 1;
            padding: 14px 0;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }

        .next-btn {
            background: linear-gradient(90deg, #2d281f 0%, #181510 100%);
            color: #ffffff;
        }

        .next-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
            background: linear-gradient(90deg, #181510 0%, #2d281f 100%);
        }

        .back-btn {
            background: #f0f0f0;
            color: #5c5445;
        }

        .back-btn:hover {
            background: #e5e5e5;
        }

        /* 单按钮样式（步骤3） */
        .single-btn {
            width: 100%;
        }

        /* 返回登录链接 */
        .login-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #e0b942;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .login-link:hover {
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

            .btn-group {
                flex-direction: column;
                gap: 10px;
            }

            .step-text {
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
<div class="form-container">
    <h2 class="form-title">忘记密码</h2>

    <!-- 步骤指示器（3步：验证信息→验证手机→设置新密码） -->
    <div class="step-indicator">
        <div class="step-item active" id="step1">
            <div class="step-icon">1</div>
            <div class="step-text">验证账号</div>
        </div>
        <div class="step-item" id="step2">
            <div class="step-icon">2</div>
            <div class="step-text">验证手机</div>
        </div>
        <div class="step-item" id="step3">
            <div class="step-icon">3</div>
            <div class="step-text">设置新密码</div>
        </div>
    </div>

    <!-- 步骤1：输入账号和手机号（默认显示） -->
    <form id="step1Form" class="form-step active">
        <div class="form-group">
            <label for="username" class="form-label">账号</label>
            <input type="text" id="username" name="username" class="form-input" placeholder="请输入您的登录账号" required>
            <div class="error-message" id="usernameError">账号不存在</div>
        </div>

        <div class="form-group">
            <label for="phone" class="form-label">手机号</label>
            <input type="tel" id="phone" name="phone" class="form-input" placeholder="请输入绑定的手机号" required>
            <div class="error-message" id="phoneError">手机号格式不正确或未绑定该账号</div>
        </div>

        <div class="btn-group">
            <button type="button" class="form-btn back-btn" onclick="window.location.href='${pageContext.request.contextPath}/login.jsp'">返回登录</button>
            <button type="button" class="form-btn next-btn" id="toStep2Btn">下一步</button>
        </div>
    </form>

    <!-- 步骤2：验证手机验证码（默认隐藏） -->
    <form id="step2Form" class="form-step" style="display: none;">
        <div class="form-group verify-group">
            <label for="verifyCode" class="form-label">手机验证码</label>
            <input type="text" id="verifyCode" name="verifyCode" class="form-input verify-input" placeholder="请输入6位验证码" required>
            <button type="button" class="send-code-btn" id="sendCodeBtn">发送验证码</button>
            <div class="error-message" id="verifyCodeError">验证码不正确或已过期</div>
        </div>

        <div class="btn-group">
            <button type="button" class="form-btn back-btn" id="backToStep1Btn">上一步</button>
            <button type="button" class="form-btn next-btn" id="toStep3Btn">下一步</button>
        </div>
    </form>

    <!-- 步骤3：设置新密码（默认隐藏） -->
    <form id="step3Form" action="${pageContext.request.contextPath}/resetPwd" method="post" style="display: none;">
        <!-- 隐藏字段：传递账号和手机号（后端校验用） -->
        <input type="hidden" name="username" id="hiddenUsername">
        <input type="hidden" name="phone" id="hiddenPhone">
        <input type="hidden" name="verifyCode" id="hiddenVerifyCode">

        <div class="form-group">
            <label for="newPwd" class="form-label">新密码</label>
            <input type="password" id="newPwd" name="newPwd" class="form-input" placeholder="请输入6-16位新密码（字母+数字）" required>
            <div class="error-message" id="newPwdError">新密码格式不正确（6-16位字母+数字）</div>
        </div>

        <div class="form-group">
            <label for="confirmPwd" class="form-label">确认新密码</label>
            <input type="password" id="confirmPwd" name="confirmPwd" class="form-input" placeholder="请再次输入新密码" required>
            <div class="error-message" id="confirmPwdError">两次输入的密码不一致</div>
        </div>

        <div class="btn-group">
            <button type="button" class="form-btn back-btn" id="backToStep2Btn">上一步</button>
            <button type="submit" class="form-btn next-btn single-btn">确认重置</button>
        </div>

        <a href="${pageContext.request.contextPath}/login.jsp" class="login-link">返回登录页面</a>
    </form>
</div>

<!-- 成功提示弹窗 -->
<div class="success-modal" id="successModal">
    <div class="modal-content">
        <div class="modal-icon">✓</div>
        <h3 class="modal-title">密码重置成功！</h3>
        <p class="modal-desc">您的密码已更新，请使用新密码登录</p>
        <button class="modal-btn" id="closeModal">立即登录</button>
    </div>
</div>

<script>
    // 全局变量：存储验证码和倒计时
    let verifyCode = ""; // 后端生成的验证码（实际项目中应由后端发送，前端仅存储）
    let countdown = 0;
    let timer = null;

    // DOM元素
    const step1 = document.getElementById('step1');
    const step2 = document.getElementById('step2');
    const step3 = document.getElementById('step3');
    const step1Form = document.getElementById('step1Form');
    const step2Form = document.getElementById('step2Form');
    const step3Form = document.getElementById('step3Form');
    const toStep2Btn = document.getElementById('toStep2Btn');
    const backToStep1Btn = document.getElementById('backToStep1Btn');
    const sendCodeBtn = document.getElementById('sendCodeBtn');
    const toStep3Btn = document.getElementById('toStep3Btn');
    const backToStep2Btn = document.getElementById('backToStep2Btn');
    const successModal = document.getElementById('successModal');
    const closeModal = document.getElementById('closeModal');

    // 输入框和错误提示
    const username = document.getElementById('username');
    const phone = document.getElementById('phone');
    const verifyCodeInput = document.getElementById('verifyCode');
    const newPwd = document.getElementById('newPwd');
    const confirmPwd = document.getElementById('confirmPwd');
    const usernameError = document.getElementById('usernameError');
    const phoneError = document.getElementById('phoneError');
    const verifyCodeError = document.getElementById('verifyCodeError');
    const newPwdError = document.getElementById('newPwdError');
    const confirmPwdError = document.getElementById('confirmPwdError');

    // 隐藏字段（传递数据）
    const hiddenUsername = document.getElementById('hiddenUsername');
    const hiddenPhone = document.getElementById('hiddenPhone');
    const hiddenVerifyCode = document.getElementById('hiddenVerifyCode');

    // 正则表达式
    const phoneReg = /^1[3-9]\d{9}$/; // 手机号正则（11位，以13-9开头）
    const pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,16}$/; // 密码正则（6-16位字母+数字）
    const codeReg = /^\d{6}$/; // 验证码正则（6位数字）

    // 步骤1 → 步骤2：验证账号和手机号
    toStep2Btn.addEventListener('click', function() {
        let isValid = true;

        // 验证账号（前端仅做非空，后端校验是否存在）
        if (!username.value.trim()) {
            usernameError.style.display = 'block';
            usernameError.innerText = '账号不能为空';
            isValid = false;
        } else {
            usernameError.style.display = 'none';
        }

        // 验证手机号格式
        if (!phoneReg.test(phone.value.trim())) {
            phoneError.style.display = 'block';
            phoneError.innerText = '手机号格式不正确';
            isValid = false;
        } else {
            phoneError.style.display = 'none';
        }

        // 验证通过，跳转到步骤2
        if (isValid) {
            // 传递账号和手机号到隐藏字段
            hiddenUsername.value = username.value.trim();
            hiddenPhone.value = phone.value.trim();

            // 更新步骤指示器
            step1.classList.remove('active');
            step1.classList.add('completed');
            step2.classList.add('active');
            document.querySelector('.step-indicator::after').style.width = 'calc((100% - 60px) * 2/3)';

            // 切换表单显示
            step1Form.style.display = 'none';
            step2Form.style.display = 'block';
        }
    });

    // 步骤2 → 步骤1：返回上一步
    backToStep1Btn.addEventListener('click', function() {
        step2.classList.remove('active');
        step1.classList.remove('completed');
        step1.classList.add('active');
        document.querySelector('.step-indicator::after').style.width = 'calc((100% - 60px) / 3)';
        step2Form.style.display = 'none';
        step1Form.style.display = 'block';
        verifyCodeError.style.display = 'none';
    });

    // 发送验证码（模拟，实际项目中调用后端接口发送短信）
    sendCodeBtn.addEventListener('click', function() {
        const phoneVal = phone.value.trim();
        if (!phoneReg.test(phoneVal)) {
            phoneError.style.display = 'block';
            phoneError.innerText = '请先输入正确的手机号';
            return;
        }

        // 模拟生成6位随机验证码
        verifyCode = Math.floor(100000 + Math.random() * 900000).toString();
        console.log('生成的验证码：', verifyCode); // 实际项目中删除（仅测试用）

        // 模拟发送短信（实际项目中替换为后端接口请求）
        alert(`验证码已发送至手机号 ${phoneVal}，验证码：${verifyCode}（5分钟内有效）`);

        // 倒计时60秒
        countdown = 60;
        sendCodeBtn.disabled = true;
        sendCodeBtn.innerText = `重新发送(${countdown}s)`;

        timer = setInterval(function() {
            countdown--;
            sendCodeBtn.innerText = `重新发送(${countdown}s)`;
            if (countdown <= 0) {
                clearInterval(timer);
                sendCodeBtn.disabled = false;
                sendCodeBtn.innerText = '发送验证码';
            }
        }, 1000);
    });

    // 步骤2 → 步骤3：验证验证码
    toStep3Btn.addEventListener('click', function() {
        let isValid = true;
        const codeVal = verifyCodeInput.value.trim();

        // 验证验证码格式
        if (!codeReg.test(codeVal)) {
            verifyCodeError.style.display = 'block';
            verifyCodeError.innerText = '验证码格式不正确（6位数字）';
            isValid = false;
        } else {
            // 前端校验验证码（实际项目中需后端再次校验）
            if (codeVal !== verifyCode) {
                verifyCodeError.style.display = 'block';
                verifyCodeError.innerText = '验证码不正确或已过期';
                isValid = false;
            } else {
                verifyCodeError.style.display = 'none';
            }
        }

        // 验证通过，跳转到步骤3
        if (isValid) {
            hiddenVerifyCode.value = codeVal;

            // 更新步骤指示器
            step2.classList.remove('active');
            step2.classList.add('completed');
            step3.classList.add('active');
            document.querySelector('.step-indicator::after').style.width = 'calc(100% - 60px)';

            // 切换表单显示
            step2Form.style.display = 'none';
            step3Form.style.display = 'block';
        }
    });

    // 步骤3 → 步骤2：返回上一步
    backToStep2Btn.addEventListener('click', function() {
        step3.classList.remove('active');
        step2.classList.remove('completed');
        step2.classList.add('active');
        document.querySelector('.step-indicator::after').style.width = 'calc((100% - 60px) * 2/3)';
        step3Form.style.display = 'none';
        step2Form.style.display = 'block';
        newPwdError.style.display = 'none';
        confirmPwdError.style.display = 'none';
    });

    // 步骤3表单提交验证
    step3Form.addEventListener('submit', function(e) {
        let isValid = true;
        const newPwdVal = newPwd.value;
        const confirmPwdVal = confirmPwd.value;

        // 验证新密码格式
        if (!pwdReg.test(newPwdVal)) {
            newPwdError.style.display = 'block';
            isValid = false;
        } else {
            newPwdError.style.display = 'none';
        }

        // 验证两次密码一致
        if (newPwdVal !== confirmPwdVal) {
            confirmPwdError.style.display = 'block';
            isValid = false;
        } else {
            confirmPwdError.style.display = 'none';
        }

        // 验证不通过阻止提交
        if (!isValid) {
            e.preventDefault();
        }
    });

    // 实时输入校验
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

    // 成功弹窗控制
    <% if (request.getAttribute("resetSuccess") != null && (Boolean) request.getAttribute("resetSuccess")) { %>
    successModal.classList.add('show');
    <% } %>

    closeModal.addEventListener('click', function() {
        window.location.href = "${pageContext.request.contextPath}/login.jsp";
    });

    successModal.addEventListener('click', function(e) {
        if (e.target === successModal) {
            window.location.href = "${pageContext.request.contextPath}/login.jsp";
        }
    });

    // 页面卸载时清除定时器
    window.addEventListener('unload', function() {
        if (timer) clearInterval(timer);
    });
</script>
</body>
</html>