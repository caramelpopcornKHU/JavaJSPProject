<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%@ page import="com.football.model.News" %>
<!DOCTYPE html>
<html lang="ko">
<head>
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>축구 읽어주는 여자</title>
   <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
   <style>
       * {
           margin: 0;
           padding: 0;
           box-sizing: border-box;
       }
       body {
           font-family: 'Inter', sans-serif;
           background-color: #f8f8f8;
           color: #1a1a1a;
           line-height: 1.6;
       }
       .container {
           max-width: 1200px;
           margin: 0 auto;
           padding: 0 20px;
       }
       /* Header */
       header {
           background: #fff;
           padding: 20px 0;
           border-bottom: 1px solid #e0e0e0;
           position: sticky;
           top: 0;
           z-index: 100;
       }
       .header-content {
           display: flex;
           justify-content: space-between;
           align-items: center;
       }
       .logo {
           font-size: 24px;
           font-weight: 700;
           letter-spacing: 2px;
           color: #1a1a1a;
           text-decoration: none;
       }
       .nav {
           display: flex;
           gap: 40px;
       }
       .nav a {
           text-decoration: none;
           color: #666;
           font-weight: 400;
           transition: color 0.3s ease;
       }
       .nav a:hover {
           color: #1a1a1a;
       }
       /* Hero Section */
       .hero {
           background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%);
           color: #fff;
           text-align: center;
           padding: 100px 0;
           margin-bottom: 80px;
       }
       
       .hero h1 {
           font-size: 48px;
           font-weight: 300;
           letter-spacing: 3px;
           margin-bottom: 20px;
       }
       .hero p {
           font-size: 18px;
           font-weight: 300;
           opacity: 0.8;
           max-width: 600px;
           margin: 0 auto;
       }

       .breaking-bar {
           background: #232733;
           color: #fff;
           padding: 7px 0;
           font-size: 15px;
           font-weight: 400;
           margin: 0 auto 40px auto;
           max-width: 900px;
           overflow: hidden;
           border-radius: 0;
           box-shadow: none;
       }
       .breaking-wrap {
           display: flex;
           gap: 30px;
           align-items: center;
           animation: scrollBar 3s linear infinite;
       }
       .breaking-item {
           white-space: nowrap;
           font-size: 15px;
           letter-spacing: 0.1em;
           font-weight: 400;
           opacity: 0.92;
       }
       
       @keyframes scrollBar {
           0%   { transform: translateX(0);}
           100% { transform: translateX(-50%);}
       }

       /* 메인 콘텐츠 섹션 */
       .main-content-section {
           padding: 0 0 80px;
       }

       /* 나란히 배치를 위한 컨테이너 */
       .content-wrapper {
           display: grid;
           grid-template-columns: 0.5fr 1.5fr; /* 리그 순위 : 뉴스 = 1 : 1.2 비율 */
           gap: 40px;
           max-width: 1200px;
           margin: 0 auto;
           align-items: start;
       }

       /* 리그 순위 스타일 */
       .league-container {
           display: flex;
           flex-direction: column;
           gap: 20px;
       }

       .league-table {
           background: #2a2a2a;
           border-radius: 12px;
           overflow: hidden;
           box-shadow: 0 4px 20px rgba(0,0,0,0.15);
       }

       .league-header {
           background: #1a1a1a;
           color: #fff;
           padding: 15px 20px;
           font-size: 16px;
           font-weight: 600;
           text-align: center;
           position: relative;
       }

       .league-header::after {
           content: '';
           position: absolute;
           bottom: 0;
           left: 20px;
           right: 20px;
           height: 2px;
           background: linear-gradient(90deg, #007bff, #00d4ff);
       }

       .season-info {
           color: #888;
           font-size: 12px;
           font-weight: 400;
           margin-top: 2px;
       }

       .standings-list {
           padding: 0;
       }

       .standing-item {
           display: flex;
           align-items: center;
           padding: 12px 20px;
           border-bottom: 1px solid #3a3a3a;
           background: #2a2a2a;
           transition: all 0.2s ease;
       }

       .standing-item:last-child {
           border-bottom: none;
       }

       .standing-item:hover {
           background: #333;
           transform: translateX(2px);
       }

       .position {
           font-size: 14px;
           font-weight: 700;
           color: #fff;
           min-width: 25px;
           text-align: center;
           margin-right: 15px;
           background: #007bff;
           border-radius: 50%;
           width: 25px;
           height: 25px;
           display: flex;
           align-items: center;
           justify-content: center;
           font-size: 12px;
       }

       /* 상위 3팀 특별 색상 */
       .standing-item:nth-child(1) .position {
           background: linear-gradient(135deg, #FFD700, #FFA500);
       }

       .standing-item:nth-child(2) .position {
           background: linear-gradient(135deg, #C0C0C0, #A8A8A8);
       }

       .standing-item:nth-child(3) .position {
           background: linear-gradient(135deg, #CD7F32, #B8860B);
       }

       .team-name {
           font-size: 14px;
           color: #fff;
           font-weight: 500;
           flex: 1;
       }

       /* 뉴스 섹션 스타일 */
       .section-title {
           text-align: center;
           margin-bottom: 40px;
       }

       .section-title h2 {
           font-size: 32px;
           font-weight: 300;
           letter-spacing: 1px;
           margin-bottom: 8px;
           color: #1a1a1a;
       }

       .section-subtitle {
           font-size: 16px;
           color: #666;
           font-weight: 300;
       }

       .news-list {
           background: #fff;
           border-radius: 8px;
           padding: 30px;
           box-shadow: 0 2px 10px rgba(0,0,0,0.1);
       }

       .news-item {
           display: flex;
           align-items: center;
           padding: 15px 0;
           border-bottom: 1px solid #e0e0e0;
           gap: 15px;
       }

       .news-item:last-child {
           border-bottom: none;
       }

       .news-number {
           font-size: 14px;
           color: #999;
           min-width: 20px;
           font-weight: 500;
       }

       .news-thumbnail {
           width: 60px;
           height: 60px;
           border-radius: 4px;
           object-fit: cover;
           flex-shrink: 0;
       }

       .news-content {
           flex: 1;
       }

       .news-item-title {
           font-size: 16px;
           font-weight: 500;
           color: #1a1a1a;
           margin-bottom: 5px;
           line-height: 1.4;
       }

       .news-meta {
           font-size: 12px;
           color: #666;
       }

       .comment-count {
           color: #007bff;
           font-weight: 500;
       }

       /* Footer */
       footer {
           background: #1a1a1a;
           color: #fff;
           text-align: center;
           padding: 60px 0;
       }
       .footer-content {
           max-width: 800px;
           margin: 0 auto;
       }
       .footer-links {
           display: flex;
           justify-content: center;
           gap: 40px;
           margin-bottom: 40px;
       }
       .footer-links a {
           color: #ccc;
           text-decoration: none;
           font-weight: 300;
           transition: color 0.3s ease;
       }
       .footer-links a:hover {
           color: #fff;
       }
       .footer-text {
           font-size: 14px;
           color: #888;
           font-weight: 300;
       }

       /* 반응형 */
       @media (max-width: 768px) {
           .hero h1 {
               font-size: 32px;
           }
           .hero p {
               font-size: 16px;
           }
           .nav {
               display: none;
           }
           .footer-links {
               flex-direction: column;
               gap: 20px;
           }
           .breaking-bar { 
               max-width: 98vw; 
               font-size: 14px; 
           }
           .breaking-wrap { 
               gap: 16px; 
           }
           
           /* 모바일에서는 세로 배치 */
           .content-wrapper {
               grid-template-columns: 1fr;
               gap: 40px;
               margin: 0 15px;
           }
           
           .league-section {
               order: 2; /* 모바일에서는 뉴스가 먼저, 리그 순위가 나중에 */
           }
           
           .news-section {
               order: 1;
           }
           
           .news-list {
               padding: 20px;
           }

           .standing-item {
               padding: 10px 15px;
           }

           .team-name {
               font-size: 13px;
           }
       }
   </style>
</head>
<body>
   <!-- Header -->
   <header>
       <div class="container">
           <div class="header-content">
               <a href="/home" class="logo">축구읽어주는 여자</a>
               <nav class="nav">
                   <a href="/home">축구 소식통</a>
                   <a href="/football_world">해외축구</a>
                   <a href="/football_korean">국내축구</a>
                   <a href="/board">게시판 글쓰기</a>        
               </nav>
           </div>
       </div>
   </header>
   

   <!-- Hero Section -->
   <section class="hero">
       <div class="container">
           <h1>여기에 뭐 넣지 ..</h1>
           <p>메인 설명 텍스트</p>
       </div>
   </section>

   <!-- Breaking News Bar -->
	<div class="breaking-bar">
	  <div class="breaking-wrap">
	    <c:forEach var="brief" items="${breakingNews}">
	      <span class="breaking-item">
	        <span class="breaking-dot"></span> ${brief.title}
	      </span>
	    </c:forEach>
	  </div>
	</div>

   <!-- 메인 콘텐츠 섹션 (리그 순위 + 뉴스) -->
   <section class="main-content-section">
       <div class="container">
           <div class="content-wrapper">
               <!-- 왼쪽: 리그 순위 -->
               <div class="league-section">
                   <div class="section-title">
                       <h2>리그 순위</h2>
                       <p class="section-subtitle">프리미어리그 & 라리가 최신 순위</p>
                        <button id="refreshRankBtn">순위 새로고침🗘</button>
                   </div>
                   <div class="league-container">
                       <!-- 프리미어리그 -->
                       <div class="league-table">
                           <div class="league-header">
                               프리미어리그
                               <div class="season-info">2025-26</div>
                           </div>
                           <div class="standings-list">
                               <c:forEach var="team" items="${premierLeague}">
                                   <div class="standing-item">
                                       <span class="position">${team.position}</span>
                                       <span class="team-name">${team.teamName}</span>
                                   </div>
                               </c:forEach>
                           </div>
                       </div>
                       
                       <!-- 라리가 -->
                       <div class="league-table">
                           <div class="league-header">
                               라리가
                               <div class="season-info">2025-26</div>
                           </div>
                           <div class="standings-list">
                               <c:forEach var="team" items="${laLiga}">
                                   <div class="standing-item">
                                       <span class="position">${team.position}</span>
                                       <span class="team-name">${team.teamName}</span>
                                   </div>
                               </c:forEach>
                           </div>
                       </div>
                   </div>
               </div>

               <!-- 오른쪽: 뉴스 섹션 -->
               <div class="news-section">
                   <div class="section-title">
                       <h2>축구 소식통</h2>
                       <p class="section-subtitle">축구 소식통 최근 인기글</p>
                       <button id="refreshBtn">소식 새로고침🗘</button>
                   </div>
                   
                   <div class="news-list">
                       <c:forEach var="news" items="${newsList}" varStatus="status">
                           <div class="news-item">
                               <span class="news-number">${status.index + 1}</span>
                               <img src="${news.imageUrl}" alt="${news.title}" class="news-thumbnail">
                               <div class="news-content">
                                   <div class="news-item-title">${news.title}</div>
                                   <div class="news-meta">
                                       ${news.category} | 
                                       <fmt:formatDate value="${news.createdAt}" pattern="MM월 dd일 HH:mm:ss"/> | 
                                       <span class="comment-count">[${news.commentCount}]</span>
                                   </div>
                               </div>
                           </div>
                       </c:forEach>
                   </div>
               </div>
           </div>
       </div>
   </section>
   
   <!-- Footer -->
   <footer>
       <div class="container">
           <div class="footer-content">
               <div class="footer-links">
                   <a href="/link1">홈</a>
                   <a href="/link2">어성준은 힘들다</a>
                   <a href="/link3">링크3</a>
                   <a href="/link4">링크4</a>
                   <a href="/link5">링크5</a>
                   <a href="/link5">chat</a>
               </div>
               <p class="footer-text">© 2025 축구읽어주는 여자. All rights reserved.</p>
           </div>
       </div>
   </footer>
   
   <script>  
	<!--JQuery-->
	$(document).ready(function(){
	    window.handleClick = function(itemId) {
	        alert('클릭되었습니다. Item ID: ' + itemId);
	    };
	    
	    $(window).scroll(function() {
	        if($(window).scrollTop() > 100) {
	            $('header').css('box-shadow', '0 2px 20px rgba(0,0,0,0.1)');
	        } else {
	            $('header').css('box-shadow', 'none');
	        }
	    });
	});
   </script>
   
   <script>
	$(document).ready(function() {
	    $("#refreshBtn").click(function() {
	        var button = $(this);
	        button.prop("disabled", true).text("새로고침 중...");
	        
	        // Ajax로 서버에 요청
	        $.ajax({
	            type: "GET",
	            url: window.location.href, // 현재 페이지 주소
	            data: "ajax=true", // Ajax 요청임을 표시
	            success: function(data) {
	                console.log("Ajax 성공!");
	                // 1초 후 페이지 새로고침
	                setTimeout(function() {
	                    window.location.reload();
	                }, 1000);
	            },
	            error: function() {
	                console.log("Ajax 실패");
	                alert("새로고침 실패");
	                button.prop("disabled", false).text("소식 새로고침");
	            }
	        });
	    });
	});
</script>

<script>
	$("#refreshRankBtn").click(function() {
	    var button = $(this);
	    button.prop("disabled", true).text("새로고침 중...");
	    
	    $.ajax({
	        type: "GET",
	        data: "ajax=rank",         
	        success: function(data) {
	            setTimeout(function() {
	                window.location.reload();
	            }, 1000);
	        },
	        error: function() {
	            alert("순위 새로고침 실패!");
	            button.prop("disabled", false).text("순위 새로고침");
	        }
	    });
	});
</script>

	<div>
		<!-- 메뉴 열기 버튼 -->
		<jsp:include page="body/chat.jsp"></jsp:include>
	</div>

   
</body>
</html>