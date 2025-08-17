<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="css/chat.css">
<!-- FontAwesome 아이콘 (이미 로드되어 있지 않은 경우에만) -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<!-- 채팅 컨테이너 -->
<div class="chat-container">
    <!-- 채팅 메뉴 버튼 -->
    <button class="chat-menu-toggle" onclick="toggleChatDrawer()">
        <i class="fas fa-comment-alt"></i> 채팅
    </button>

    <!-- 채팅 오버레이 -->
    <div class="chat-overlay" id="chatOverlay" onclick="closeChatDrawer()"></div>

    <!-- 채팅 드로어 -->
    <div class="chat-drawer" id="chatDrawer">
        <div class="chat-drawer-header">
            <button class="close-chat-drawer" onclick="closeChatDrawer()">
                <i class="fas fa-times"></i>
            </button>
            <h2><i class="fas fa-users"></i> 채팅 참여</h2>
            <p>닉네임을 입력하고 채팅을 시작하세요</p>
        </div>
        
        <div class="chat-drawer-content">
            <form class="chat-form" onsubmit="return false;">
                <div class="input-group">
                    <label for="chatId">
                        <i class="fas fa-user"></i> 닉네임
                    </label>
                    <input 
                        type="text" 
                        id="chatId" 
                        class="chat-input" 
                        placeholder="사용할 닉네임을 입력하세요"
                        maxlength="10"
                    >
                </div>
                <button type="button" class="join-btn" onclick="chatWinOpen()">
                    <i class="fas fa-sign-in-alt"></i> 채팅방 입장
                </button>
            </form>
        </div>
    </div>
</div>

<script>
// jQuery가 로드되어 있는지 확인
if (typeof jQuery === 'undefined') {
    // jQuery가 없으면 CDN에서 로드
    var script = document.createElement('script');
    script.src = 'https://code.jquery.com/jquery-3.7.0.min.js';
    document.head.appendChild(script);
    
    script.onload = function() {
        initializeChatFunctions();
    };
} else {
    // jQuery가 이미 있으면 바로 초기화
    $(document).ready(function() {
        initializeChatFunctions();
    });
}

function initializeChatFunctions() {
    // 엔터키로 채팅방 입장
    $('#chatId').keypress(function(e) {
        if (e.which === 13) {
            chatWinOpen();
        }
    });

    // 입력 시 에러 스타일 제거
    $('#chatId').on('input', function() {
        $(this).removeClass('error');
    });
    
    // ESC 키로 드로어 닫기
    $(document).keydown(function(e) {
        if (e.keyCode === 27) {
            closeChatDrawer();
        }
    });
}

function toggleChatDrawer() {
    var drawer = document.getElementById('chatDrawer');
    var overlay = document.getElementById('chatOverlay');
    
    if (drawer.classList.contains('open')) {
        closeChatDrawer();
    } else {
        drawer.classList.add('open');
        overlay.classList.add('show');
        
        // 포커스를 약간 지연시켜 애니메이션과 겹치지 않도록
        setTimeout(function() {
            document.getElementById('chatId').focus();
        }, 400);
    }
}

function closeChatDrawer() {
    var drawer = document.getElementById('chatDrawer');
    var overlay = document.getElementById('chatOverlay');
    
    drawer.classList.remove('open');
    overlay.classList.remove('show');
}

function chatWinOpen() {
    var idElement = document.getElementById('chatId');
    var id = idElement.value.trim();
    
    if (id === "") {
        alert("닉네임을 입력해주세요.");
        idElement.focus();
        return;
    }
    
    if (id.length < 2) {
        alert("닉네임은 2글자 이상 입력해주세요.");
        idElement.focus();
        return;
    }

    // 채팅창 열기 - 경로를 현재 구조에 맞게 수정
    try {
        window.open(
            "body/ChatWindow.jsp?chatId=" + encodeURIComponent(id), 
            "chatWindow", 
            "width=420,height=680,resizable=yes,scrollbars=no,status=no,menubar=no,toolbar=no,location=no"
        );
        
        idElement.value = "";
        closeChatDrawer();
    } catch (error) {
        // 팝업이 차단된 경우
        alert("팝업이 차단되었습니다. 브라우저의 팝업 차단을 해제해주세요.");
    }
}
</script>