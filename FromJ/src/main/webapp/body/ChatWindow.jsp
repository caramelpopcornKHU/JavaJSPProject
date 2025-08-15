<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>웹소켓 채팅</title>

<!-- jQuery CDN 불러오기 -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

<style>
/* 채팅 메시지 출력 영역 */
#chatWindow {
	border: 1px solid black;
	width: 270px;
	height: 310px;
	overflow: scroll;   /* 메시지가 많으면 스크롤 가능 */
	padding: 5px;
}

/* 메시지 입력창 */
#chatMessage {
	width: 236px;
	height: 30px;
}

/* 전송 버튼 스타일 */
#sendBtn {
	height: 30px;
	position: relative;
	top: 2px;
	left: -2px;
}

/* 채팅 종료 버튼 스타일 */
#closeBtn {
	margin-bottom: 3px;
	position: relative;
	top: 2px;
	left: -2px;
}

/* 닉네임 입력란 (읽기 전용) */
#chatId {
	width: 158px;
	height: 24px;
	border: 1px solid #AAAAAA;
	background-color: #EEEEEE;
}

/* 본인이 보낸 메시지는 오른쪽 정렬 */
.myMsg {
	text-align: right;
}
</style>
</head>
<body>

<!-- 닉네임 표시 및 채팅 종료 버튼 -->
닉네임 : <input type="text" id="chatId" value="${param.chatId}" readonly>
<button id="closeBtn">채팅 종료</button>

<!-- 채팅 메시지를 표시할 영역 -->
<div id="chatWindow"></div>

<!-- 메시지 입력창과 전송 버튼 -->
<div>
    <input type="text" id="chatMessage">
    <button id="sendBtn">전송</button>
</div>

<script>
$(document).ready(function() {
    // --------------------------
    // 1. DOM 요소 jQuery 객체로 저장
    // --------------------------
    let $chatWindow = $("#chatWindow");   // 메시지 표시 영역
    let $chatMessage = $("#chatMessage"); // 입력창
    let chatId = $("#chatId").val();      // 닉네임

    // --------------------------
    // 2. 웹소켓 연결
    // --------------------------
    let webSocket = new WebSocket(
        "<%= application.getInitParameter("CHAT_ADDR") %>" 
        + "<%= request.getContextPath() %>" 
        + "/ChatingServer"
    );

    // --------------------------
    // 3. 메시지 전송 함수
    // --------------------------
    function sendMessage() {
        if($chatMessage.val().trim() === "") return; // 빈 메시지 무시

        // 3-1. 본인 메시지 채팅창에 표시 (오른쪽 정렬)
        $chatWindow.append("<div class='myMsg'>" + $chatMessage.val() + "</div>");

        // 3-2. 서버로 메시지 전송 (형식: 닉네임|내용)
        webSocket.send(chatId + '|' + $chatMessage.val());

        // 3-3. 입력창 초기화
        $chatMessage.val("");

        // 3-4. 스크롤을 최신 메시지 위치로 이동
        $chatWindow.scrollTop($chatWindow[0].scrollHeight);
    }

    // --------------------------
    // 4. 엔터 키 처리
    // --------------------------
    $chatMessage.keyup(function(e){
        if(e.keyCode === 13) sendMessage(); // 엔터 키(13) 입력 시 전송
    });

    // --------------------------
    // 5. 전송 버튼 클릭 이벤트
    // --------------------------
    $("#sendBtn").click(sendMessage);

    // --------------------------
    // 6. 채팅 종료 버튼 클릭 이벤트
    // --------------------------
    $("#closeBtn").click(function() {
        webSocket.close();  // 서버 연결 종료
        window.close();     // 팝업 창 닫기
    });

    // --------------------------
    // 7. 웹소켓 이벤트 처리
    // --------------------------

    // 서버와 연결됐을 때
    webSocket.onopen = function() {
        $chatWindow.append("웹소켓 서버에 연결되었습니다.<br>");
    };

    // 서버와 연결 종료됐을 때
    webSocket.onclose = function() {
        $chatWindow.append("웹소켓 서버가 종료되었습니다.<br>");
    };

    // 에러 발생 시
    webSocket.onerror = function() {
        alert("WebSocket 연결 에러가 발생했습니다.");
        $chatWindow.append("채팅 중 에러가 발생하였습니다.<br>");
    };

    // 메시지를 받았을 때
    webSocket.onmessage = function(event) {
        let message = event.data.split("|"); // '닉네임|내용' 구분
        let sender = message[0];             // 보낸 사람 닉네임
        let content = message[1];            // 메시지 내용

        if(content != "") {
            // 7-1. 귓속말 처리
            if(content.match("/")) {
                if(content.match("/" + chatId)) {
                    let temp = content.replace(("/" + chatId), "[귓속말] : ");
                    $chatWindow.append("<div>" + sender + temp + "</div>");
                }
            } else {
                // 7-2. 일반 메시지
                $chatWindow.append("<div>" + sender + " : " + content + "</div>");
            }

            // 스크롤 최신 메시지 위치로 이동
            $chatWindow.scrollTop($chatWindow[0].scrollHeight);
        }
    };
});
</script>
</body>
</html>
