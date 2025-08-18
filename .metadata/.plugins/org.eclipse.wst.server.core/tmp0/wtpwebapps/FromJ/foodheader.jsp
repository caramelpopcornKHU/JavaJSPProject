<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 세션에서 로그인된 사용자 아이디를 가져옵니다.
    String userId = (String) session.getAttribute("userId");
%>
<header>
    <h1><a href="/index.jsp">서울 맛집 지도</a></h1>
    <nav>
        <ul>
            <% if (userId != null) { %>
                <%-- 로그인 상태일 때 --%>
                <li><strong><%= userId %>님</strong> 환영합니다!</li>
                <li><a href="#">내 즐겨찾기</a></li>
                <li><a href="/loginfood/logout.jsp">로그아웃</a></li>
            <% } else { %>
                <%-- 로그아웃 상태일 때 --%>
                <li><a href="/loginfood/foodlogin.jsp">로그인</a></li>
                <li><a href="/loginfood/foodregister.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </nav>
    
<div>
    <!-- 메뉴 열기 버튼 -->
	<jsp:include page="/body/chat.jsp"></jsp:include>
</div>

    
</header>