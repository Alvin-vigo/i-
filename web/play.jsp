<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>视频播放 | i谦之家</title>
  <style>
    body {
      margin: 0;
      padding: 20px;
      font-family: "Microsoft YaHei", sans-serif;
      background: linear-gradient(135deg, #2d281f 0%, #1f1b16 50%, #181510 100%);
      color: #fff;
    }
    .back-btn {
      color: #e0b942;
      text-decoration: none;
      font-size: 16px;
      margin-bottom: 20px;
      display: inline-block;
    }
    .video-container {
      max-width: 1200px;
      margin: 0 auto;
      background: #fff;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.2);
    }
    video {
      width: 100%;
      border-radius: 8px;
    }
    h2 {
      color: #2d281f;
      margin-bottom: 20px;
      padding-bottom: 10px;
      border-bottom: 2px solid #e0b942;
    }
  </style>
</head>
<body>
<!-- 返回按钮 -->
<a href="${pageContext.request.contextPath}/main.jsp" class="back-btn">← 返回首页</a>

<!-- 视频播放区域 -->
<div class="video-container">
  <h2 id="videoTitle">视频播放</h2>
  <video id="videoPlayer" controls width="100%" style="margin: 20px 0;">
    <source src="" type="video/mp4">
    您的浏览器不支持HTML5视频播放
  </video>
</div>

<script>
  // 获取URL中的videoId参数
  const urlParams = new URLSearchParams(window.location.search);
  const videoId = urlParams.get('videoId');

  // 根据videoId设置不同的视频源和标题
  const videoPlayer = document.getElementById('videoPlayer');
  const videoTitle = document.getElementById('videoTitle');

  // 核心修改：通过VideoServlet获取视频
  const servletPath = '${pageContext.request.contextPath}/video/stream?fileName=';

  switch(videoId) {
    case '1':
      videoTitle.textContent = '系统操作指南';
      videoPlayer.src = servletPath + 'demo.mp4';
      break;
    case '2':
      videoTitle.textContent = '新手入门教程';
      videoPlayer.src = servletPath + 'beginner-tutorial.mp4';
      break;
    case '3':
      videoTitle.textContent = '高级功能讲解';
      videoPlayer.src = servletPath + 'advanced-features.mp4';
      break;
    case '4':
      videoTitle.textContent = '常见问题解答';
      videoPlayer.src = servletPath + 'faq.mp4';
      break;
    default:
      videoTitle.textContent = '视频不存在';
      videoPlayer.src = '';
      alert('无效的视频ID');
  }
</script>
</body>
</html>