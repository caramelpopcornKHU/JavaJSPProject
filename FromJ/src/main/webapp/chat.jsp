<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>


<button onclick="toggleDrawer()">메뉴 열기</button>

<div class="drawer" id="myDrawer">
  <ul>
  
  </ul>
</div>

<script>
  function toggleDrawer() {
    const drawer = document.getElementById('myDrawer');
    const content = document.getElementById('myContent');
    drawer.classList.toggle('open');
    content.classList.toggle('drawer-open');
  }
</script>



</body>
</html>