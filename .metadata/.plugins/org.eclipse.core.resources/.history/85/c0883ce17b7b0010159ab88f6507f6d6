<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>FromJ</title>
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
	
</head>
<body>

<!-- 하단 메뉴 버튼 -->
<jsp:include page="header/header.jsp"></jsp:include>

<!-- 본문 메뉴 버튼 -->
<jsp:include page="body/body.jsp"></jsp:include>

<!-- 하단 메뉴 버튼 -->
<jsp:include page="footer/footer.jsp"></jsp:include>

</body>
</html>