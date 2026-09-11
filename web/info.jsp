<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>歌手资料 | i谦之家</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Microsoft YaHei", "PingFang SC", sans-serif; }
        body { background: linear-gradient(135deg, #0a0a0a 0%, #1a1815 100%); min-height: 100vh; color: #f0f0f0; }
        
        .navbar { position: fixed; top: 0; left: 0; right: 0; z-index: 1000; background: rgba(0,0,0,0.9); backdrop-filter: blur(10px); padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(212,175,55,0.2); }
        .logo { font-size: 28px; font-weight: 700; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; letter-spacing: 2px; text-decoration: none; }
        .nav-links { display: flex; gap: 35px; }
        .nav-links a { color: #f0f0f0; text-decoration: none; font-size: 15px; transition: all 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: #d4af37; }
        .nav-right a { padding: 8px 20px; border-radius: 20px; text-decoration: none; font-size: 14px; color: #d4af37; border: 1px solid #d4af37; margin-left: 10px; }
        
        .main-content { margin-top: 100px; max-width: 1200px; margin-left: auto; margin-right: auto; padding: 0 20px 60px; }
        
        /* 歌手头像和基本信息 */
        .profile-header { display: flex; gap: 50px; margin-bottom: 50px; }
        .profile-avatar { width: 300px; height: 380px; background: linear-gradient(135deg, #2d281f, #1a1815); border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 150px; border: 2px solid rgba(212,175,55,0.2); flex-shrink: 0; overflow: hidden; }
        .profile-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .profile-info { flex: 1; }
        .profile-name { font-size: 48px; background: linear-gradient(90deg, #f8e190, #d4af37); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 20px; }
        .profile-tags { display: flex; gap: 10px; margin-bottom: 25px; flex-wrap: wrap; }
        .profile-tags span { padding: 6px 16px; background: rgba(212,175,55,0.1); color: #d4af37; border-radius: 20px; font-size: 13px; }
        .profile-basic { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-bottom: 30px; }
        .profile-basic-item { display: flex; gap: 10px; }
        .profile-basic-item label { color: #888; min-width: 60px; }
        .profile-basic-item span { color: #f0f0f0; }
        
        /* 简介区域 */
        .section { background: #1a1815; border-radius: 16px; padding: 30px; margin-bottom: 30px; border: 1px solid rgba(212,175,55,0.1); }
        .section-title { font-size: 22px; color: #d4af37; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid rgba(212,175,55,0.1); display: flex; align-items: center; gap: 10px; }
        .section-title::before { content: ''; width: 4px; height: 24px; background: linear-gradient(180deg, #d4af37, #9f7928); border-radius: 2px; }
        .section-content { color: #ccc; line-height: 1.9; font-size: 15px; }
        .section-content p { margin-bottom: 15px; }
        
        /* 成就荣誉 */
        .achievements { white-space: pre-line; }
        .achievement-category { margin-bottom: 25px; }
        .achievement-category h4 { color: #f8e190; font-size: 16px; margin-bottom: 12px; }
        .achievement-list { list-style: none; }
        .achievement-list li { color: #ccc; font-size: 14px; padding: 8px 0; padding-left: 20px; position: relative; }
        .achievement-list li::before { content: '★'; position: absolute; left: 0; color: #d4af37; }
        
        /* 出道历程时间线 */
        .timeline { position: relative; padding-left: 30px; }
        .timeline::before { content: ''; position: absolute; left: 8px; top: 0; bottom: 0; width: 2px; background: linear-gradient(180deg, #d4af37, rgba(212,175,55,0.1)); }
        .timeline-item { position: relative; margin-bottom: 30px; }
        .timeline-item::before { content: ''; position: absolute; left: -26px; top: 5px; width: 12px; height: 12px; background: #d4af37; border-radius: 50%; border: 3px solid #1a1815; }
        .timeline-year { color: #d4af37; font-size: 18px; font-weight: 600; margin-bottom: 8px; }
        .timeline-content { color: #ccc; font-size: 14px; line-height: 1.7; }
        
        @media (max-width: 768px) {
            .navbar { padding: 15px 20px; }
            .nav-links { display: none; }
            .profile-header { flex-direction: column; align-items: center; }
            .profile-avatar { width: 200px; height: 250px; font-size: 100px; }
            .profile-name { font-size: 32px; text-align: center; }
            .profile-basic { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">i谦之家</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/info.jsp" class="active">歌手资料</a>
            <a href="${pageContext.request.contextPath}/works.jsp">作品展示</a>
            <a href="${pageContext.request.contextPath}/forum.jsp">粉丝互动</a>
            <a href="${pageContext.request.contextPath}/download.jsp">资源下载</a>
        </div>
        <div class="nav-right">
            <% if (session.getAttribute("loginUser") != null) { %>
                <a href="${pageContext.request.contextPath}/user.jsp">个人中心</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp">登录</a>
            <% } %>
        </div>
    </nav>

    <div class="main-content">
        <!-- 歌手头像和基本信息 -->
        <div class="profile-header">
            <div class="profile-avatar" id="avatarContainer">
                <img src="${pageContext.request.contextPath}/download?type=image&file=xue1.png" alt="薛之谦" onerror="this.parentElement.innerHTML='🎤';">
            </div>
            <div class="profile-info">
                <h1 class="profile-name" id="singerName">薛之谦</h1>
                <div class="profile-tags">
                    <span>歌手</span>
                    <span>音乐制作人</span>
                    <span>演员</span>
                    <span>综艺达人</span>
                </div>
                <div class="profile-basic">
                    <div class="profile-basic-item">
                        <label>生日：</label>
                        <span id="birthday">1983年7月17日</span>
                    </div>
                    <div class="profile-basic-item">
                        <label>星座：</label>
                        <span id="constellation">巨蟹座</span>
                    </div>
                    <div class="profile-basic-item">
                        <label>籍贯：</label>
                        <span id="birthplace">上海</span>
                    </div>
                    <div class="profile-basic-item">
                        <label>身高：</label>
                        <span id="height">180cm</span>
                    </div>
                    <div class="profile-basic-item">
                        <label>血型：</label>
                        <span id="bloodType">B型</span>
                    </div>
                    <div class="profile-basic-item">
                        <label>出道：</label>
                        <span id="debutDate">2005年</span>
                    </div>
                    <div class="profile-basic-item">
                        <label>公司：</label>
                        <span id="company">海蝶音乐</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 个人简介 -->
        <div class="section">
            <h3 class="section-title">个人简介</h3>
            <div class="section-content" id="introduction">
                <p>薛之谦，1983年7月17日出生于上海，中国内地流行乐男歌手、影视演员、音乐制作人，毕业于格里昂酒店管理学院。</p>
                <p>2005年因参加选秀节目《我型我秀》正式出道。2006年发行首张同名专辑《薛之谦》，其中歌曲《认真的雪》获得广泛关注。</p>
                <p>2013年凭借歌曲《丑八怪》再度走红。2015年发行专辑《绅士》，同名主打歌曲《绅士》及《演员》广受好评，开启音乐事业高峰期。</p>
            </div>
        </div>

        <!-- 出道历程 -->
        <div class="section">
            <h3 class="section-title">出道历程</h3>
            <div class="timeline">
                <div class="timeline-item">
                    <div class="timeline-year">2005年</div>
                    <div class="timeline-content">参加东方卫视《我型我秀》选秀节目，获得全国总决赛第四名，正式踏入演艺圈。</div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2006年</div>
                    <div class="timeline-content">发行首张同名专辑《薛之谦》，主打歌《认真的雪》成为年度热门单曲，奠定音乐道路基础。</div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2013年</div>
                    <div class="timeline-content">凭借《丑八怪》重返乐坛巅峰，歌曲独特的风格引发广泛共鸣。</div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2015年</div>
                    <div class="timeline-content">发行专辑《绅士》，《演员》《绅士》等歌曲火遍全国，开启事业巅峰期。</div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2016-2020年</div>
                    <div class="timeline-content">连续举办多场大型演唱会，参与多档综艺节目，成为娱乐圈顶流艺人。</div>
                </div>
                <div class="timeline-item">
                    <div class="timeline-year">2021年至今</div>
                    <div class="timeline-content">继续深耕音乐创作，推出多首优质单曲，全国巡回演唱会持续进行中。</div>
                </div>
            </div>
        </div>

        <!-- 成就荣誉 -->
        <div class="section">
            <h3 class="section-title">成就荣誉</h3>
            <div class="section-content">
                <div class="achievement-category">
                    <h4>🏆 音乐成就</h4>
                    <ul class="achievement-list">
                        <li>2016年 音悦V榜年度盛典 年度最佳男歌手</li>
                        <li>2017年 东方风云榜 最佳男歌手</li>
                        <li>2018年 全球华语榜中榜 亚洲影响力歌手</li>
                        <li>2019年 华语金曲奖 年度最佳男歌手</li>
                        <li>2020年 中国歌曲排行榜 年度金曲《天外来物》</li>
                    </ul>
                </div>
                <div class="achievement-category">
                    <h4>🎬 影视综艺</h4>
                    <ul class="achievement-list">
                        <li>《我是歌手》竞演歌手</li>
                        <li>《火星情报局》常驻嘉宾</li>
                        <li>多部电影主题曲演唱</li>
                    </ul>
                </div>
                <div class="achievement-category">
                    <h4>🌟 其他荣誉</h4>
                    <ul class="achievement-list">
                        <li>微博粉丝数超7000万</li>
                        <li>个人演唱会场场爆满</li>
                        <li>被誉为"段子手歌手"，综艺感满分</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script>
        // 从后端获取歌手信息（可选，也可以使用静态数据）
        fetch('${pageContext.request.contextPath}/info')
            .then(response => response.json())
            .then(data => {
                if (data.code === 0 && data.data) {
                    const info = data.data;
                    if (info.name) document.getElementById('singerName').textContent = info.name;
                    if (info.birthday) document.getElementById('birthday').textContent = info.birthday;
                    if (info.constellation) document.getElementById('constellation').textContent = info.constellation;
                    if (info.birthplace) document.getElementById('birthplace').textContent = info.birthplace;
                    if (info.height) document.getElementById('height').textContent = info.height;
                    if (info.bloodType) document.getElementById('bloodType').textContent = info.bloodType;
                    if (info.company) document.getElementById('company').textContent = info.company;
                    
                    // 如果有头像信息，则更新头像
                    if (info.avatar) {
                        const avatarContainer = document.getElementById('avatarContainer');
                        avatarContainer.innerHTML = `<img src="${info.avatar}" alt="薛之谦" onerror="this.parentElement.innerHTML='🎤';">`;
                    }
                }
            })
            .catch(err => console.log('加载歌手信息失败，使用默认数据'));
    </script>
</body>
</html>