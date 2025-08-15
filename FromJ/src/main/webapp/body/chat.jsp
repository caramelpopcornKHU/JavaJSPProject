<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<style>
</style>



<!-- 메뉴 열기 버튼 -->
<button onclick="toggleDrawer()">메뉴 열기</button>

<!-- 드로어 영역 -->
<div class="drawer" id="myDrawer">
	<h2>웹 채팅</h2>
	닉네임 :
	<input type="text" id="chatId">
	<button onclick="chatWinOpen()">채팅 참여</button>
</div>

<script>
function toggleDrawer() {
	$('#myDrawer').toggleClass('open');
	$('#myContent').toggleClass('drawer-open');
}

function chatWinOpen() {
	let id = $("#chatId");

	if (id.val() === "") {
		alert("대화명을 입력 후 채팅창을 열어주세요.");
		id.focus();
		return;
	}

	window.open("body/ChatWindow.jsp?chatId=" + id.val(), "", "width=480,height=620");
	id.val(""); // 입력창 비우기
}
</script>
