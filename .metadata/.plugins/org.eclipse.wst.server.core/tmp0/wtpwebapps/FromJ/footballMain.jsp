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
   <link rel="stylesheet" href="css/football.css">
</head>
<body>
   <!-- Header -->
   <header>
       <div class="container">
           <div class="header-content">
               <a href="/footballMain" class="logo">축구읽어주는 여자</a>
               <nav class="nav">
                   <a href="/footballMain">축구 소식통</a>
                   <a href="/football_world">해외축구</a>
                   <a href="/football_korean">국내축구</a>
                   <a href="ESJ.jsp">게시판 글쓰기</a>        
               </nav>
           </div>
       </div>
   </header>
   

   <!-- Hero Section -->
   <section class="hero">
       <div class="container">
       
           <h1></h1>
           <p></p>
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

   <!--네비게이션 2-->
   <div class="secondary-nav-container">
       <ul class="secondary-nav-menu">
           <li class="secondary-nav-item home">
               <span>홈</span>
           </li>
           <li class="secondary-nav-item">
               <span>인기</span>
           </li>
           <li class="secondary-nav-item epl active">
               <span>EPL</span>
           </li>
           <li class="secondary-nav-item esp">
               <span>ESP</span>
           </li>
           <li class="secondary-nav-item ita">
               <span>ITA</span>
           </li>
           <li class="secondary-nav-item ger">
               <span>GER</span>
           </li>
           <li class="secondary-nav-item fra">
               <span>FRA</span>
           </li>
           <li class="secondary-nav-item community">
               <span>기타</span>
           </li>
           <li class="secondary-nav-item sns">
               <span>SNS</span>
           </li>
           <li class="secondary-nav-item talk">
               <span>TALK</span>
           </li>
           <li class="secondary-nav-item job">
               <span>잡담</span>
           </li>
           <li class="secondary-nav-item stats">
               <span>영상</span>
           </li>
           <li class="secondary-nav-item event">
               <span>이벤트</span>
           </li>
       </ul>
   </div>
   

   <!-- 단축키 패널 -->
   <div class="shortcut-panel">
       <div class="shortcut-header">
           <span class="shortcut-title">단축키</span>
           <button class="shortcut-toggle">설정하기 ▶</button>
       </div>
       <div class="shortcut-content">
           <div class="shortcut-item">
               <span class="shortcut-key">alt+c</span>
               <span class="shortcut-desc">댓글쓰기</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">alt+w</span>
               <span class="shortcut-desc">글쓰기</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">alt+q</span>
               <span class="shortcut-desc">댓글 등록</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">e</span>
               <span class="shortcut-desc">상단으로</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">s</span>
               <span class="shortcut-desc">이전</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">d</span>
               <span class="shortcut-desc">하단으로</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">f</span>
               <span class="shortcut-desc">다음</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">q</span>
               <span class="shortcut-desc">메인</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">w</span>
               <span class="shortcut-desc">인기글</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">1</span>
               <span class="shortcut-desc">프리미어리그</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">2</span>
               <span class="shortcut-desc">축구소식통</span>
           </div>
           <div class="shortcut-item">
               <span class="shortcut-key">3</span>
               <span class="shortcut-desc">축구소식</span>
           </div>
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
                   <a href="index.jsp">홈</a>
                   <a href="ESJ.jsp">어성준은 힘들다</a>
                   <a href="seoul_food.jsp">서울맛집지도</a>
                   <a>이용약관</a>
                   <a>개인정보처리방침</a>
                   <a>문의/신고</a>
                   <a>게시글중단요청</a>
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