<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>页面未找到 | i谦之家</title>
  <style>
    /* 复用原有全局样式，保持风格统一 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Microsoft YaHei", "PingFang SC", "Helvetica Neue", Arial, sans-serif;
    }

    body {
      /* 与主页面一致的暗金棕渐变背景 */
      background: linear-gradient(135deg, #2d281f 0%, #1f1b16 50%, #181510 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }

    /* 404 容器样式 */
    .error-container {
      max-width: 600px;
      width: 100%;
      background: #ffffff;
      border-radius: 12px;
      padding: 60px 40px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
      text-align: center;
    }

    /* 404 图标 */
    .error-icon {
      font-size: 80px;
      color: #e0b942;
      margin-bottom: 25px;
      animation: bounce 1.5s ease-in-out infinite alternate;
    }

    /* 图标弹跳动画 */
    @keyframes bounce {
      from { transform: scale(1); }
      to { transform: scale(1.1); }
    }

    /* 错误标题 */
    .error-title {
      font-size: 36px;
      color: #2d281f;
      margin-bottom: 15px;
      font-weight: 700;
      letter-spacing: 1px;
    }

    /* 错误描述 */
    .error-desc {
      font-size: 16px;
      color: #5c5445;
      line-height: 1.8;
      margin-bottom: 35px;
    }

    /* 按钮容器（弹性布局，适配多按钮） */
    .btn-group {
      display: flex;
      gap: 15px;
      justify-content: center;
      flex-wrap: wrap;
    }

    /* 按钮样式（复用主页面按钮风格） */
    .error-btn {
      display: inline-block;
      padding: 12px 30px;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 500;
      text-decoration: none;
      transition: all 0.3s ease;
    }

    /* 主按钮（返回登录页） */
    .btn-login {
      background: linear-gradient(90deg, #2d281f 0%, #181510 100%);
      color: #ffffff;
    }

    .btn-login:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
      background: linear-gradient(90deg, #181510 0%, #2d281f 100%);
    }

    /* 次要按钮（刷新页面） */
    .btn-refresh {
      background: #ffffff;
      color: #2d281f;
      border: 1px solid #e0b942;
    }

    .btn-refresh:hover {
      background: rgba(224, 185, 66, 0.1);
      color: #e0b942;
    }

    /* 响应式适配（与主页面保持一致） */
    @media (max-width: 768px) {
      .error-container {
        padding: 45px 25px;
      }

      .error-title {
        font-size: 28px;
      }

      .error-icon {
        font-size: 65px;
      }
    }

    @media (max-width: 480px) {
      .error-container {
        padding: 35px 15px;
      }

      .error-title {
        font-size: 24px;
      }

      .error-icon {
        font-size: 55px;
      }

      .btn-group {
        gap: 10px;
      }

      .error-btn {
        padding: 10px 20px;
        width: 100%;
      }
    }
  </style>
</head>
<body>
<div class="error-container">
  <!-- 404 图标（使用文字图标，无需图片） -->
  <div class="error-icon">🔍</div>
  <h2 class="error-title">404 - 页面未找到</h2>
  <p class="error-desc">
    抱歉，您访问的页面不存在、已被删除或路径错误！<br>
    可能是输入的网址有误，或该页面已迁移，请检查路径后重试。
  </p>
  <div class="btn-group">
    <!-- 返回登录页按钮（核心需求） -->
    <a href="${pageContext.request.contextPath}/main.jsp" class="error-btn btn-login">返回上一页面</a>
    <!-- 刷新页面按钮（辅助功能） -->
    <a href="javascript:location.reload()" class="error-btn btn-refresh">刷新当前页面</a>
  </div>
</div>
</body>
</html>