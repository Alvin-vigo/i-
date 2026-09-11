<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>谦友注册 | i谦之家</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #221f1f 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        
        .register-container { width: 100%; max-width: 500px; background: #ffffff; border-radius: 16px; box-shadow: 0 10px 50px rgba(0, 0, 0, 0.5); padding: 50px 40px; position: relative; }
        .register-container::after { content: ""; position: absolute; top: 0; left: 0; right: 0; bottom: 0; border: 2px solid transparent; border-radius: 18px; padding: 2px; background: linear-gradient(135deg, #000000, #d4af37) border-box; -webkit-mask: linear-gradient(#fff 0 0) padding-box, linear-gradient(#fff 0 0); -webkit-mask-composite: xor; mask-composite: exclude; pointer-events: none; }
        
        .register-title { text-align: center; margin-bottom: 35px; background: linear-gradient(90deg, #000000 0%, #332b18 50%, #000000 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-size: 30px; font-weight: 600; letter-spacing: 1px; }
        .register-title span { background: linear-gradient(90deg, #f8e190 0%, #d4af37 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        
        .form-item { margin-bottom: 25px; position: relative; }
        .form-item label { display: block; margin-bottom: 8px; background: linear-gradient(90deg, #000000 0%, #332b18 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-size: 15px; font-weight: 500; }
        .form-item input { width: 100%; height: 50px; padding: 0 18px; border: 1px solid #e8e0c8; border-radius: 8px; font-size: 15px; color: #221f1f; transition: all 0.3s ease; background: linear-gradient(180deg, #ffffff 0%, #faf7ed 100%); }
        .form-item input:focus { outline: none; border: 1px solid transparent; background: linear-gradient(#ffffff, #ffffff) padding-box, linear-gradient(90deg, #000000 0%, #d4af37 100%) border-box; background-clip: padding-box, border-box; box-shadow: 0 0 0 3px rgba(212, 175, 55, 0.15); }
        .form-item input::placeholder { color: #999; font-size: 14px; }
        
        .error-message { color: #dc3545; font-size: 13px; margin-top: 5px; display: none; }
        
        .register-btn { width: 100%; height: 52px; background: linear-gradient(90deg, #000000 0%, #332b18 50%, #d4af37 100%); color: #ffffff; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s ease; text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3); }
        .register-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(212, 175, 55, 0.25); background: linear-gradient(90deg, #d4af37 0%, #332b18 50%, #000000 100%); }
        .register-btn:disabled { opacity: 0.6; cursor: not-allowed; transform: none; }
        
        .login-link { text-align: center; margin-top: 25px; font-size: 14px; color: #666; }
        .login-link a { background: linear-gradient(90deg, #9f7928 0%, #d4af37 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-decoration: none; margin-left: 5px; }
        .login-link a:hover { text-decoration: underline; }
        
        .success-modal { position: fixed; inset: 0; background: rgba(0,0,0,0.7); display: none; align-items: center; justify-content: center; z-index: 9999; }
        .success-modal.show { display: flex; }
        .modal-content { background: #fff; border-radius: 16px; padding: 40px; text-align: center; max-width: 400px; }
        .modal-icon { font-size: 60px; margin-bottom: 20px; }
        .modal-title { font-size: 22px; color: #2d281f; margin-bottom: 10px; }
        .modal-desc { color: #666; margin-bottom: 25px; }
        .modal-btn { padding: 12px 40px; background: linear-gradient(90deg, #d4af37, #9f7928); color: #fff; border: none; border-radius: 8px; cursor: pointer; font-size: 15px; }
        
        @media (max-width: 480px) { .register-container { padding: 40px 25px; } .register-title { font-size: 26px; } }
    </style>
</head>
<body>
<div class="register-container">
    <h3 class="register-title">谦友<span>注册</span></h3>
    <form id="registerForm">
        <div class="form-item">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username" required placeholder="请输入用户名（3-20位）">
            <div class="error-message" id="usernameError"></div>
        </div>
        <div class="form-item">
            <label for="password">密码</label>
            <input type="password" id="password" name="password" required placeholder="6-16位，包含字母和数字">
            <div class="error-message" id="passwordError"></div>
        </div>
        <div class="form-item">
            <label for="confirmPassword">确认密码</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="请再次输入密码">
            <div class="error-message" id="confirmError"></div>
        </div>
        <div class="form-item">
            <label for="phone">手机号（选填）</label>
            <input type="text" id="phone" name="phone" placeholder="请输入手机号">
        </div>
        <div class="form-item">
            <label for="email">邮箱（选填）</label>
            <input type="email" id="email" name="email" placeholder="请输入邮箱">
        </div>
        <button type="submit" class="register-btn" id="registerBtn">立即注册</button>
    </form>
    <p class="login-link">已有账号？<a href="${pageContext.request.contextPath}/login.jsp">立即登录</a></p>
</div>

<!-- 成功弹窗 -->
<div class="success-modal" id="successModal">
    <div class="modal-content">
        <div class="modal-icon">✓</div>
        <h3 class="modal-title">注册成功！</h3>
        <p class="modal-desc">欢迎加入i谦之家，现在可以登录了</p>
        <button class="modal-btn" onclick="window.location.href='${pageContext.request.contextPath}/login.jsp'">去登录</button>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const form = document.getElementById('registerForm');
    const pwdReg = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,16}$/;
    
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const phone = document.getElementById('phone').value.trim();
        const email = document.getElementById('email').value.trim();
        
        // 清除错误
        document.querySelectorAll('.error-message').forEach(el => { el.style.display = 'none'; el.textContent = ''; });
        
        let valid = true;
        
        // 验证用户名
        if (username.length < 3 || username.length > 20) {
            document.getElementById('usernameError').textContent = '用户名需3-20位';
            document.getElementById('usernameError').style.display = 'block';
            valid = false;
        }
        
        // 验证密码
        if (!pwdReg.test(password)) {
            document.getElementById('passwordError').textContent = '密码需6-16位，包含字母和数字';
            document.getElementById('passwordError').style.display = 'block';
            valid = false;
        }
        
        // 验证确认密码
        if (password !== confirmPassword) {
            document.getElementById('confirmError').textContent = '两次密码输入不一致';
            document.getElementById('confirmError').style.display = 'block';
            valid = false;
        }
        
        if (!valid) return;
        
        // 提交注册
        const btn = document.getElementById('registerBtn');
        btn.disabled = true;
        btn.textContent = '注册中...';
        
        fetch(contextPath + '/user?action=register', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'username=' + encodeURIComponent(username) + 
                  '&password=' + encodeURIComponent(password) + 
                  '&phone=' + encodeURIComponent(phone) + 
                  '&email=' + encodeURIComponent(email)
        })
        .then(response => response.json())
        .then(data => {
            if (data.code === 0) {
                document.getElementById('successModal').classList.add('show');
            } else {
                document.getElementById('usernameError').textContent = data.message;
                document.getElementById('usernameError').style.display = 'block';
            }
        })
        .catch(() => {
            alert('网络错误，请稍后重试');
        })
        .finally(() => {
            btn.disabled = false;
            btn.textContent = '立即注册';
        });
    });
</script>
</body>
</html>
