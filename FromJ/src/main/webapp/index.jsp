<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<style>
.drawer {
  position: fixed;
  top: 0;
  right: -250px; /* 초기에는 숨김 */
  width: 250px;
  height: 100%;
  background-color: #f0f0f0;
  transition: right 0.3s ease; /* 애니메이션 효과 */
  z-index: 100; /* 다른 요소 위에 표시 */
}
.drawer.open {
  right: 0; /* 열렸을 때 위치 */
}
.content {
  right: 0;
  transition: padding-right 0.3s ease;
}
.content.drawer-open {
  padding-right: 250px; /* 드로어가 열렸을 때 콘텐츠 밀어냄 */
}
</style>

	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>

<!-- 메뉴 열기 버튼 -->
<jsp:include page="chat.jsp"></jsp:include>

<div class="content" id="myContent">
  <h1>본문 내용</h1>
  <p>여기에 본문 내용이 들어갑니다.</p>
  
</div>

<jsp:include page="header.jsp"></jsp:include>
<section>
	<p>페이지 내용</p>
</section>
<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>