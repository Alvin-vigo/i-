<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>i谦之家 | 薛之谦官方粉丝平台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #1a1815 100%); min-height: 100vh; color: #f0f0f0; }

        /* 顶部导航 */
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background: rgba(0,0,0,0.9); backdrop-filter: blur(10px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(212,175,55,0.2); }
        .logo { font-size: 28px; font-weight: 700; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 2px; }
        .nav-links { display: flex; gap: 35px; }
        .nav-links a { color: #f0f0f0; text-decoration: none; font-size: 15px; transition: all 0.3s; position: relative; }
        .nav-links a:hover { color: #d4af37; }
        .nav-links a::after { content: ''; position: absolute; bottom: -5px; left: 0; width: 0; height: 2px; background: #d4af37; transition: width 0.3s; }
        .nav-links a:hover::after { width: 100%; }
        .nav-right { display: flex; gap: 15px; }
        .nav-btn { padding: 8px 20px; border-radius: 20px; text-decoration: none; font-size: 14px; transition: all 0.3s; }
        .nav-btn.login { color: #d4af37; border: 1px solid #d4af37; }
        .nav-btn.login:hover { background: rgba(212,175,55,0.1); }
        .nav-btn.register { background: linear-gradient(90deg, #d4af37, #9f7928); color: #000; }
        .nav-btn.register:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(212,175,55,0.3); }

        /* 替换后的轮播图样式 - 核心修改（新增图片自适应） */
        .carousel-container {
            margin-top: 78px;
            width: 100%;
            aspect-ratio: 16/9;
            max-height: 60vh;
            min-height: 200px;
            position: relative;
            overflow: hidden;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .carousel-slide {
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
            opacity: 0;
            transition: opacity 0.8s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .carousel-slide.active {
            opacity: 1;
        }

        /* 轮播图图片自适应核心样式 */
        .carousel-img-wrapper {
            width: 100%;
            height: 100%;
            position: relative;
            overflow: hidden;
        }
        .carousel-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* 保持比例填充容器，裁剪超出部分 */
            object-position: center center; /* 居中显示，可根据需求调整 */
            transition: transform 0.5s ease, object-position 0.3s ease; /* 缩放和位置过渡效果 */
        }
        /* 鼠标悬停时轻微放大，增强视觉效果 */
        .carousel-slide:hover img {
            transform: scale(1.02);
        }
        
        /* 高分辨率屏幕优化 */
        @media (-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi) {
            .carousel-slide img {
                image-rendering: -webkit-optimize-contrast;
                image-rendering: crisp-edges;
            }
        }

        /* 轮播图图片加载失败的默认样式 */
        .img-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg,#1a1815,#2d281f);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .img-placeholder span {
            font-size: 120px;
        }

        .carousel-dots {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 10;
        }

        .carousel-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255,255,255,0.6);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .carousel-dot.active {
            background: #d4af37;
            transform: scale(1.2);
        }

        .carousel-prev, .carousel-next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(0,0,0,0.5);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: none;
            font-size: 20px;
            z-index: 10;
            transition: all 0.3s ease;
        }

        .carousel-prev:hover, .carousel-next:hover {
            background: #d4af37;
        }

        .carousel-prev {
            left: 20px;
        }

        .carousel-next {
            right: 20px;
        }

        /* 轮播图文字内容自适应 */
        .carousel-content {
            position: absolute;
            bottom: 120px;
            left: 80px;
            z-index: 10;
            max-width: 600px;
            /* 文字自适应 */
            width: calc(100% - 160px);
        }
        .carousel-content h2 {
            font-size: clamp(1.5rem, 4vw, 3rem); /* 响应式字体大小 */
            color: #fff;
            margin-bottom: 20px;
            text-shadow: 2px 2px 15px rgba(0,0,0,0.6);
            line-height: 1.2;
        }
        .carousel-content p {
            font-size: clamp(0.875rem, 2vw, 1.25rem); /* 响应式字体大小 */
            color: rgba(255,255,255,0.9);
            line-height: 1.6;
        }

        /* 主内容区 */
        .main-content { max-width: 1200px; margin: 0 auto; padding: 80px 20px 60px; }
        .section-title { text-align: center; margin-bottom: 50px; }
        .section-title h2 { font-size: 32px; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 10px; }
        .section-title p { color: #888; font-size: 14px; }

        /* 快速入口 */
        .quick-entry { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; margin-bottom: 80px; }
        .entry-card { background: linear-gradient(135deg, #1a1815 0%, #252220 100%); border-radius: 16px; padding: 35px 25px; text-align: center; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; cursor: pointer; text-decoration: none; }
        .entry-card:hover { transform: translateY(-8px); border-color: rgba(212,175,55,0.3); box-shadow: 0 15px 40px rgba(0,0,0,0.3); }
        .entry-icon { font-size: 48px; margin-bottom: 20px; }
        .entry-card h3 { color: #f8e190; font-size: 20px; margin-bottom: 10px; }
        .entry-card p { color: #888; font-size: 13px; line-height: 1.6; }

        /* 最新动态 */
        .news-section { margin-bottom: 80px; }
        .news-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 25px; }
        .news-card { background: #1a1815; border-radius: 12px; overflow: hidden; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; }
        .news-card:hover { transform: translateY(-5px); border-color: rgba(212,175,55,0.3); }
        .news-img { height: 180px; background: linear-gradient(135deg, #2d281f, #1a1815); display: flex; align-items: center; justify-content: center; font-size: 60px; }
        .news-body { padding: 20px; }
        .news-tag { display: inline-block; padding: 4px 12px; background: rgba(212,175,55,0.1); color: #d4af37; font-size: 12px; border-radius: 12px; margin-bottom: 10px; }
        .news-card h4 { color: #f0f0f0; font-size: 16px; margin-bottom: 8px; }
        .news-card p { color: #888; font-size: 13px; line-height: 1.6; }
        .news-date { color: #666; font-size: 12px; margin-top: 12px; }

        /* 热门作品 */
        .works-section { margin-bottom: 80px; }
        .works-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .work-card { background: #1a1815; border-radius: 12px; overflow: hidden; border: 1px solid rgba(212,175,55,0.1); transition: all 0.3s; cursor: pointer; }
        .work-card:hover { transform: scale(1.03); border-color: rgba(212,175,55,0.3); }
        .work-cover { height: 160px; background: linear-gradient(135deg, #2d281f, #1a1815); display: flex; align-items: center; justify-content: center; font-size: 50px; position: relative; }
        .work-cover::after { content: '▶'; position: absolute; inset: 0; background: rgba(0,0,0,0.5); display: flex; align-items: center; justify-content: center; font-size: 30px; color: #d4af37; opacity: 0; transition: opacity 0.3s; }
        .work-card:hover .work-cover::after { opacity: 1; }
        .work-info { padding: 15px; }
        .work-info h5 { color: #f0f0f0; font-size: 14px; margin-bottom: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .work-info span { color: #888; font-size: 12px; }

        /* 页脚 */
        .footer { background: #0a0a0a; padding: 50px 20px 30px; border-top: 1px solid rgba(212,175,55,0.1); }
        .footer-content { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; }
        .footer-logo { font-size: 24px; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 15px; }
        .footer-desc { color: #666; font-size: 13px; max-width: 300px; line-height: 1.8; }
        .footer-links { display: flex; gap: 60px; flex-wrap: wrap; }
        .footer-col { margin-bottom: 20px; }
        .footer-col h4 { color: #d4af37; font-size: 14px; margin-bottom: 15px; }
        .footer-col a { display: block; color: #888; font-size: 13px; text-decoration: none; margin-bottom: 10px; transition: color 0.3s; }
        .footer-col a:hover { color: #d4af37; }
        .footer-bottom { max-width: 1200px; margin: 30px auto 0; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.05); text-align: center; color: #666; font-size: 12px; }

        /* 图片懒加载过渡 */
        img {
            opacity: 0;
            transition: opacity 0.5s ease;
        }
        img.loaded {
            opacity: 1;
        }

        /* 响应式调整 */
        @media (max-width: 992px) {
            .carousel-container { max-height: 40vh; }
            .carousel-content { left: 40px; bottom: 80px; width: calc(100% - 80px); }
            .carousel-prev, .carousel-next { width: 35px; height: 35px; font-size: 18px; }
        }

        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; }
            .carousel-container {
                margin-top: 70px;
                max-height: 30vh;
            }
            .carousel-content { left: 20px; bottom: 40px; width: calc(100% - 40px); }
            .carousel-content h2 { margin-bottom: 10px; }
            .quick-entry, .news-grid, .works-grid { grid-template-columns: repeat(2, 1fr); }
            .main-content { padding: 60px 20px 40px; }
            .carousel-dots { bottom: 10px; }
            .carousel-dot { width: 10px; height: 10px; }
            .footer-content { flex-direction: column; gap: 30px; }
            .footer-links { gap: 30px; }
        }

        @media (max-width: 480px) {
            .carousel-container {
                max-height: 25vh;
                aspect-ratio: 4/3;
            }
            .quick-entry, .news-grid, .works-grid { grid-template-columns: 1fr; }
            .carousel-prev, .carousel-next { width: 30px; height: 30px; font-size: 16px; }
            .carousel-prev { left: 10px; }
            .carousel-next { right: 10px; }
        }
    </style>
</head>
<body>
<!-- 顶部导航 -->
<nav class="navbar">
    <div class="logo">i谦之家</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp" class="active">首页</a>
        <a href="${pageContext.request.contextPath}/info.jsp">歌手资料</a>
        <a href="${pageContext.request.contextPath}/works.jsp">作品展示</a>
        <a href="${pageContext.request.contextPath}/forum.jsp">粉丝互动</a>
        <a href="${pageContext.request.contextPath}/download.jsp">资源下载</a>
    </div>
    <div class="nav-right">
        <% if (session.getAttribute("loginUser") != null) { %>
        <a href="${pageContext.request.contextPath}/user.jsp" class="nav-btn login">个人中心</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-btn register">退出</a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/login.jsp" class="nav-btn login">登录</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="nav-btn register">注册</a>
        <% } %>
    </div>
</nav>

<!-- 替换后的轮播图结构 -->
<div class="carousel-container" id="carouselContainer">
    <!-- 轮播幻灯片（动态生成） -->
    <div id="carouselSlides"></div>

    <!-- 轮播控制按钮 -->
    <button class="carousel-prev">◀</button>
    <button class="carousel-next">▶</button>

    <!-- 轮播指示器 -->
    <div class="carousel-dots" id="carouselDots"></div>
</div>

<!-- 主内容 -->
<div class="main-content">
    <!-- 快速入口 -->
    <div class="section-title">
        <h2>探索谦谦的世界</h2>
        <p>了解薛之谦的一切，从这里开始</p>
    </div>
    <div class="quick-entry">
        <a href="${pageContext.request.contextPath}/info.jsp" class="entry-card">
            <div class="entry-icon">📖</div>
            <h3>歌手资料</h3>
            <p>了解薛之谦的成长历程、荣誉成就</p>
        </a>
        <a href="${pageContext.request.contextPath}/works.jsp" class="entry-card">
            <div class="entry-icon">🎶</div>
            <h3>作品展示</h3>
            <p>歌曲、专辑、综艺、影视作品全收录</p>
        </a>
        <a href="${pageContext.request.contextPath}/forum.jsp" class="entry-card">
            <div class="entry-icon">💬</div>
            <h3>粉丝互动</h3>
            <p>与全国谦友一起交流互动</p>
        </a>
        <a href="${pageContext.request.contextPath}/user.jsp" class="entry-card">
            <div class="entry-icon">👤</div>
            <h3>个人中心</h3>
            <p>管理个人信息，查看我的留言</p>
        </a>
    </div>

    <!-- 最新动态 -->
    <div class="news-section">
        <div class="section-title">
            <h2>最新动态</h2>
            <p>薛之谦的最新消息和活动资讯</p>
        </div>
        <div class="news-grid">
            <div class="news-card">
                <div class="news-img">🎤</div>
                <div class="news-body">
                    <span class="news-tag">演唱会</span>
                    <h4>2025巡回演唱会北京站开票</h4>
                    <p>北京站将于1月15日正式开票，预计场馆为国家体育场，容纳8万观众</p>
                    <div class="news-date">2025-12-01</div>
                </div>
            </div>
            <div class="news-card">
                <div class="news-img">🎵</div>
                <div class="news-body">
                    <span class="news-tag">新歌</span>
                    <h4>全新单曲《如果爱忘了》上线</h4>
                    <p>继《天外来物》后又一力作，讲述爱情中的遗憾与释然</p>
                    <div class="news-date">2025-11-28</div>
                </div>
            </div>
            <div class="news-card">
                <div class="news-img">📺</div>
                <div class="news-body">
                    <span class="news-tag">综艺</span>
                    <h4>薛之谦加盟《歌手2025》</h4>
                    <p>时隔多年重返歌手舞台，将带来全新编曲的经典曲目</p>
                    <div class="news-date">2025-11-25</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 热门作品 -->
    <div class="works-section">
        <div class="section-title">
            <h2>热门作品</h2>
            <p>最受欢迎的歌曲和专辑</p>
        </div>
        <div class="works-grid" id="hotWorks">
            <div class="work-card">
                <div class="work-cover">🎵</div>
                <div class="work-info"><h5>演员</h5><span>9876万次播放</span></div>
            </div>
            <div class="work-card">
                <div class="work-cover">🎵</div>
                <div class="work-info"><h5>绅士</h5><span>8765万次播放</span></div>
            </div>
            <div class="work-card">
                <div class="work-cover">🎵</div>
                <div class="work-info"><h5>认真的雪</h5><span>7654万次播放</span></div>
            </div>
            <div class="work-card">
                <div class="work-cover">🎵</div>
                <div class="work-info"><h5>刚刚好</h5><span>6543万次播放</span></div>
            </div>
        </div>
    </div>

    <!-- 下载专区 -->
    <div class="works-section">
        <div class="section-title">
            <h2>📥 资源下载</h2>
            <p>下载薛之谦的音乐、视频和精美图片</p>
        </div>
        <div class="quick-entry">
            <a href="${pageContext.request.contextPath}/download.jsp?type=mp3" class="entry-card">
                <div class="entry-icon">🎵</div>
                <h3>音乐下载</h3>
                <p>下载薛之谦热门歌曲MP3</p>
            </a>
            <a href="${pageContext.request.contextPath}/download.jsp?type=mp4" class="entry-card">
                <div class="entry-icon">🎬</div>
                <h3>视频下载</h3>
                <p>下载演唱会、综艺视频</p>
            </a>
            <a href="${pageContext.request.contextPath}/download.jsp?type=image" class="entry-card">
                <div class="entry-icon">🖼️</div>
                <h3>图片下载</h3>
                <p>下载高清写真和专辑封面</p>
            </a>
            <a href="${pageContext.request.contextPath}/download.jsp" class="entry-card">
                <div class="entry-icon">📚</div>
                <h3>全部资源</h3>
                <p>浏览所有可下载资源</p>
            </a>
        </div>
    </div>
</div>

<!-- 页脚 -->
<footer class="footer">
    <div class="footer-content">
        <div>
            <div class="footer-logo">i谦之家</div>
            <p class="footer-desc">薛之谦官方粉丝平台，汇聚全国谦友，分享音乐与故事。这里是属于每一位谦友的家。</p>
        </div>
        <div class="footer-links">
            <div class="footer-col">
                <h4>快速导航</h4>
                <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
                <a href="${pageContext.request.contextPath}/info.jsp">歌手资料</a>
                <a href="${pageContext.request.contextPath}/works.jsp">作品展示</a>
            </div>
            <div class="footer-col">
                <h4>互动社区</h4>
                <a href="${pageContext.request.contextPath}/forum.jsp">粉丝留言</a>
                <a href="${pageContext.request.contextPath}/user.jsp">个人中心</a>
            </div>
        </div>
    </div>
    <div class="footer-bottom">© 2025 i谦之家 - 薛之谦粉丝平台 | 仅供学习交流使用</div>
</footer>

<script>
    var ctxPath = "${pageContext.request.contextPath}";
    // 轮播图数据
    const carouselItems = [
        {
            image: ctxPath + "/download?type=image&file=xue1.png&inline=true",
            title: "薛之谦2025巡回演唱会",
            description: "我们都是有故事的人 全国巡演正式启动，与谦谦一起感受音乐的力量"
        },
        {
            image: ctxPath + "/download?type=image&file=xue2.png&inline=true",
            title: "新专辑《天外来物》热销中",
            description: "全新创作专辑，12首诚意之作，用音乐诉说每一个故事"
        },
        {
            image: ctxPath + "/download?type=image&file=xue3.png&inline=true",
            title: "薛之谦荣获年度最佳男歌手",
            description: "实力与人气的双重认可，感谢每一位谦友的支持与陪伴"
        },
        {
            image: ctxPath + "/download?type=image&file=xue4.png&inline=true",
            title: "薛之谦×综艺《无限歌谣季》",
            description: "原创音乐搭档之旅，用创意碰撞出不一样的音乐火花"
        },
        {
            image: ctxPath + "/download?type=image&file=xue5.png&inline=true",
            title: "谦友见面会·上海站",
            description: "与谦谦近距离互动，分享音乐背后的故事与感动"
        },
        {
            image: ctxPath + "/download?type=image&file=xue6.jpg&inline=true",
            title: "《演员》十周年纪念版上线",
            description: "经典重新编曲，赋予这首金曲全新的音乐生命力"
        }
    ];

    // 轮播图核心逻辑
    let currentIndex = 0;
    let carouselInterval;
    const slidesContainer = document.getElementById('carouselSlides');
    const dotsContainer = document.getElementById('carouselDots');
    const prevBtn = document.querySelector('.carousel-prev');
    const nextBtn = document.querySelector('.carousel-next');
    const carouselContainer = document.getElementById('carouselContainer');

    // 初始化轮播图DOM
    function initCarouselDOM() {
        // 清空容器
        slidesContainer.innerHTML = '';
        dotsContainer.innerHTML = '';

        // 生成轮播幻灯片和指示器
        carouselItems.forEach((item, index) => {
            // 创建幻灯片
            const slide = document.createElement('div');
            slide.className = `carousel-slide ${index == 0 ? 'active' : ''}`;

            // 创建图片包裹容器
            const imgWrapper = document.createElement('div');
            imgWrapper.className = 'carousel-img-wrapper';

            // 创建图片
            const img = document.createElement('img');
            // 使用懒加载，初始不设置src
            img.alt = item.title;
            // 图片懒加载标记
            img.dataset.src = item.image;
            img.classList.add('lazy'); // 添加lazy类用于观察器识别
            
            // 图片加载失败处理
            img.onerror = function() {
                this.style.display = 'none';
                const placeholder = document.createElement('div');
                placeholder.className = 'img-placeholder';
                placeholder.innerHTML = '<span>🎤</span>';
                imgWrapper.appendChild(placeholder);
                
                // 尝试加载备用图片
                loadFallbackImage(this, item);
            };

            // 图片加载完成后添加样式
            img.onload = function() {
                this.classList.add('loaded');
                // 根据图片比例和容器比例调整object-position，实现更好的自适应
                adjustImagePosition(this);
                // 添加设备特定的优化
                optimizeForDevice(this);
            };

            imgWrapper.appendChild(img);
            slide.appendChild(imgWrapper);

            // 创建文字内容
            const content = document.createElement('div');
            content.className = 'carousel-content';
            content.innerHTML = `<h2>${item.title}</h2><p>${item.description}</p>`;
            slide.appendChild(content);

            slidesContainer.appendChild(slide);

            // 创建指示器
            const dot = document.createElement('div');
            dot.className = `carousel-dot ${index == 0 ? 'active' : ''}`;
            dot.dataset.index = index;
            dot.addEventListener('click', () => goToSlide(index));
            dotsContainer.appendChild(dot);
        });

        // 触发第一张图片加载
        const firstImg = document.querySelector('.carousel-slide.active img');
        if (firstImg) {
            firstImg.src = firstImg.dataset.src;
            // 页面加载完成后进行设备优化
            setTimeout(() => {
                optimizeForDevice(firstImg);
            }, 100);
        }
    }

    // 初始化轮播逻辑
    function initCarousel() {
        // 初始化DOM结构
        initCarouselDOM();
        
        // 设置Intersection Observer实现懒加载
        setupLazyLoading();
        
        // 预加载图片
        preloadImages();
        
        // 自动轮播
        carouselInterval = setInterval(nextSlide, 5000);
        
        // 绑定按钮事件
        prevBtn.addEventListener('click', prevSlide);
        nextBtn.addEventListener('click', nextSlide);
        
        // 鼠标悬停暂停轮播
        carouselContainer.addEventListener('mouseenter', pauseCarousel);
        carouselContainer.addEventListener('mouseleave', startCarousel);
        
        // 窗口大小变化时重新适配
        window.addEventListener('resize', adjustCarouselImages);
    }
    
    // 设置懒加载观察器
    function setupLazyLoading() {
        // 检查浏览器是否支持Intersection Observer
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        // 加载图片
                        img.src = img.dataset.src;
                        img.classList.remove('lazy');
                        // 停止观察已加载的图片
                        imageObserver.unobserve(img);
                    }
                });
            }, {
                rootMargin: '50px 0px', // 提前50px开始加载
                threshold: 0.1
            });
            
            // 观察所有带lazy类的图片
            document.querySelectorAll('img[data-src]').forEach(img => {
                imageObserver.observe(img);
            });
        } else {
            // 不支持Intersection Observer的浏览器回退到传统方式
            document.querySelectorAll('img[data-src]').forEach(img => {
                img.src = img.dataset.src;
            });
        }
    }
    
    // 预加载图片函数
    function preloadImages() {
        // 预加载下一张图片以提高用户体验
        const nextIndex = (currentIndex + 1) % carouselItems.length;
        const nextItem = carouselItems[nextIndex];
        
        if (nextItem && nextItem.image) {
            // 检查图片是否已经在缓存中
            if (isImageCached(nextItem.image)) {
                console.log('图片已在缓存中:', nextItem.image);
                return;
            }
            
            const img = new Image();
            img.src = nextItem.image;
            img.onload = function() {
                console.log('预加载图片完成:', nextItem.image);
                // 将图片添加到缓存
                cacheImage(nextItem.image);
            };
            img.onerror = function() {
                console.log('预加载图片失败:', nextItem.image);
            };
        }
    }
    
    // 图片缓存对象
    const imageCache = {};
    
    // 检查图片是否在缓存中
    function isImageCached(src) {
        return imageCache[src] === true;
    }
    
    // 将图片添加到缓存
    function cacheImage(src) {
        imageCache[src] = true;
    }
    
    // 清除图片缓存
    function clearImageCache() {
        Object.keys(imageCache).forEach(key => {
            delete imageCache[key];
        });
    }
    
    // 备用图片加载函数
    function loadFallbackImage(failedImg, item) {
        // 尝试加载不同格式的备用图片
        const fileName = item.image.split('/').pop();
        const fileNameWithoutExt = fileName.split('.')[0];
        const extensions = ['png', 'jpg', 'jpeg', 'gif'];
        
        // 尝试不同的扩展名
        for (let ext of extensions) {
            const fallbackUrl = item.image.replace(fileName, `${fileNameWithoutExt}.${ext}`);
            if (fallbackUrl !== item.image) {
                const img = new Image();
                img.src = fallbackUrl;
                img.onload = function() {
                    // 替换失败的图片
                    const placeholder = failedImg.nextElementSibling;
                    if (placeholder && placeholder.classList.contains('img-placeholder')) {
                        placeholder.remove();
                    }
                    failedImg.style.display = 'block';
                    failedImg.src = fallbackUrl;
                    failedImg.classList.add('loaded');
                    adjustImagePosition(failedImg);
                    return;
                };
            }
        }
        
        // 如果所有备用图片都失败，显示默认占位符
        console.log('所有备用图片加载失败，使用默认占位符');
    }

    // 窗口大小变化时调整图片适配
    function adjustCarouselImages() {
        const activeImg = document.querySelector('.carousel-slide.active img');
        if (activeImg && activeImg.style.display !== 'none') {
            adjustImagePosition(activeImg);
            optimizeForDevice(activeImg);
        }
    }

    // 智能调整图片位置函数
    function adjustImagePosition(img) {
        const container = img.closest('.carousel-img-wrapper');
        if (!container) return;

        // 获取容器和图片的实际尺寸
        const containerWidth = container.clientWidth;
        const containerHeight = container.clientHeight;
        const imgNaturalWidth = img.naturalWidth;
        const imgNaturalHeight = img.naturalHeight;

        // 计算比例
        const containerRatio = containerWidth / containerHeight;
        const imgRatio = imgNaturalWidth / imgNaturalHeight;

        // 根据比例差异调整object-position
        if (Math.abs(imgRatio - containerRatio) < 0.1) {
            // 比例接近，居中显示
            img.style.objectPosition = 'center center';
        } else if (imgRatio > containerRatio) {
            // 图片更宽，优先显示左侧内容
            img.style.objectPosition = 'left center';
        } else {
            // 图片更高，优先显示顶部内容
            img.style.objectPosition = 'center top';
        }

        // 对于特定图片，可以进一步微调
        // 例如，如果图片包含人脸，可以使用face detection库来定位人脸位置
        // 这里只是一个简单的实现
    }

    // 设备特定优化函数
    function optimizeForDevice(img) {
        // 检测设备类型
        const isMobile = window.innerWidth <= 768;
        const isTablet = window.innerWidth > 768 && window.innerWidth <= 992;
        
        // 移动设备优化
        if (isMobile) {
            // 在移动设备上，稍微放大图片以适应小屏幕
            img.style.objectFit = 'cover';
            // 可以根据需要调整object-position
            if (img.style.objectPosition === 'left center') {
                img.style.objectPosition = 'center center';
            }
        }
        
        // 平板设备优化
        if (isTablet) {
            // 在平板设备上，保持默认设置
            img.style.objectFit = 'cover';
        }
        
        // 检测高分辨率屏幕
        if (window.devicePixelRatio > 1) {
            // 在高分辨率屏幕上，可以考虑加载更高清的图片
            // 这里可以添加逻辑来加载更高分辨率的图片版本
        }
        
        // 智能缩放优化
        smartZoomOptimization(img);
    }

    // 智能缩放优化函数
    function smartZoomOptimization(img) {
        // 获取图片和容器的尺寸
        const container = img.closest('.carousel-img-wrapper');
        if (!container) return;
        
        const containerWidth = container.clientWidth;
        const containerHeight = container.clientHeight;
        const imgNaturalWidth = img.naturalWidth;
        const imgNaturalHeight = img.naturalHeight;
        
        // 计算缩放比例
        const scaleX = containerWidth / imgNaturalWidth;
        const scaleY = containerHeight / imgNaturalHeight;
        const scale = Math.max(scaleX, scaleY);
        
        // 如果图片比容器小，需要放大
        if (scale > 1) {
            // 可以考虑加载更大尺寸的图片
            // 或者使用CSS transform进行放大（但会影响清晰度）
        }
        
        // 如果图片远大于容器，可以考虑压缩图片以提高性能
        if (scale < 0.5) {
            // 可以考虑加载适当尺寸的图片版本
        }
    }

    // 切换到指定幻灯片
    function goToSlide(index) {
        const slides = document.querySelectorAll('.carousel-slide');
        const dots = document.querySelectorAll('.carousel-dot');

        // 移除所有激活状态
        slides.forEach(slide => slide.classList.remove('active'));
        dots.forEach(dot => dot.classList.remove('active'));

        // 处理边界
        currentIndex = index;
        if (currentIndex < 0) currentIndex = carouselItems.length - 1;
        if (currentIndex >= carouselItems.length) currentIndex = 0;

        // 添加激活状态
        slides[currentIndex].classList.add('active');
        dots[currentIndex].classList.add('active');

        // 加载当前幻灯片的图片
        const currentImg = slides[currentIndex].querySelector('img');
        if (currentImg && currentImg.dataset.src) {
            currentImg.src = currentImg.dataset.src;
            currentImg.removeAttribute('data-src');
        }

        // 调整当前图片适配
        adjustCarouselImages();
        
        // 预加载下一张图片
        preloadImages();
    }

    // 下一张
    function nextSlide() {
        goToSlide(currentIndex + 1);
    }

    // 上一张
    function prevSlide() {
        goToSlide(currentIndex - 1);
    }

    // 暂停轮播
    function pauseCarousel() {
        clearInterval(carouselInterval);
    }

    // 开始轮播
    function startCarousel() {
        carouselInterval = setInterval(nextSlide, 5000);
    }

    // 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', initCarousel);
    
    // 页面卸载时清除缓存
    window.addEventListener('beforeunload', function() {
        clearImageCache();
    });
</script>
</body>
</html>