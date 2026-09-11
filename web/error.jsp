<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>登录失败 | i谦之家</title>
  <style>
    /* 全局样式重置与基础配置 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
    }

    body {
      /* 替换为暗金棕渐变（无纯黑，温润高级） */
      background: linear-gradient(135deg, #2d281f 0%, #1f1b16 50%, #181510 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    /* 失败提示容器 */
    .error-container {
      width: 100%;
      max-width: 450px;
      background: #ffffff;
      border-radius: 12px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      padding: 50px 40px;
      text-align: center;
      position: relative;
    }

    /* 顶部黑金装饰条（微调金色更适配新背景） */
    .error-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 6px;
      background: linear-gradient(90deg, #181510 0%, #d4af37 100%);
    }

    /* 错误图标（简化版） */
    .error-icon {
      font-size: 48px;
      /* 微调金色更暖，适配新背景 */
      color: #e0b942;
      margin-bottom: 20px;
    }

    /* 错误提示标题 */
    .error-title {
      font-size: 22px;
      color: #2d281f;
      margin-bottom: 15px;
      font-weight: 600;
    }

    /* 错误提示描述 */
    .error-desc {
      font-size: 15px;
      color: #5c5445;
      margin-bottom: 30px;
      line-height: 1.5;
    }

    /* 按钮/链接容器 */
    .action-btns {
      display: flex;
      flex-direction: column;
      gap: 15px;
    }

    /* 通用按钮样式 */
    .btn {
      padding: 12px 24px;
      border-radius: 8px;
      text-decoration: none;
      font-size: 15px;
      font-weight: 500;
      transition: all 0.3s ease;
      display: inline-block;
    }

    /* 返回登录按钮（适配新背景的黑金渐变） */
    .btn-back {
      background: linear-gradient(90deg, #2d281f 0%, #181510 100%);
      color: #ffffff;
    }

    .btn-back:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
      background: linear-gradient(90deg, #181510 0%, #2d281f 100%);
    }

    /* 辅助链接（忘记密码/注册） */
    .link-group {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-top: 10px;
    }

    .link-group a {
      /* 暖金色，适配新背景 */
      color: #e0b942;
      text-decoration: none;
      font-size: 14px;
      transition: color 0.3s ease;
    }

    .link-group a:hover {
      color: #c9a32e;
      text-decoration: underline;
    }

    /* 响应式适配 */
    @media (max-width: 480px) {
      .error-container {
        padding: 40px 25px;
      }

      .error-title {
        font-size: 20px;
      }

      .link-group {
        flex-direction: column;
        gap: 10px;
      }
    }
  </style>
</head>
<body>
<div class="error-container">
  <!-- 错误图标（使用文字替代图标，无需额外引入） -->
  <div class="error-icon">⚠</div>

  <!-- 核心提示 -->
  <h2 class="error-title">用户名或密码错误</h2>
  <p class="error-desc">请检查您输入的账号信息是否正确，若忘记密码可尝试找回，无账号可注册新账户</p>

  <!-- 操作按钮/链接（调整为JSP路径） -->
  <div class="action-btns">
    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-back">返回重新登录</a>

    <!-- 辅助跳转链接（调整为JSP路径） -->
    <div class="link-group">
      <a href="${pageContext.request.contextPath}/forget-password.jsp">忘记密码？点击找回</a>
      <a href="${pageContext.request.contextPath}/register.jsp">还没有账户？立即注册</a>
    </div>
  </div>
</div>
</body>
</html>