<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서울 맛집 지도</title>
    <%-- 여기에 기존의 CSS, JS 링크 등 헤더 정보 --%>
    
    <%-- ★★★★★ 1. 동적 헤더 포함 ★★★★★ --%>
    
   <div>
    <!-- 메뉴 열기 버튼 -->
	<jsp:include page="foodheader.jsp"></jsp:include>
</div>
    
</head>
<body>
    <div id="map" style="width:100%;height:600px;"></div>

    <%-- 즐겨찾기 추가를 위한 숨겨진 폼 --%>
    <form id="favForm" action="/addFavoriteProc.jsp" method="post" style="display:none;">
        <input type="hidden" id="favRestaurantId" name="restaurantId">
    </form>

    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f32bcf87a6f85ab908ddb72d2f01c85b"></script>
    <script>
        // ... 기존의 지도 생성 코드 ...

        // 마커와 인포윈도우를 생성하는 부분 (예시: positions 배열을 순회)
        positions.forEach(function(place) {
            let marker = new kakao.maps.Marker({
                map: map,
                position: new kakao.maps.LatLng(place.lat, place.lng)
            });

            // ★★★★★ 2. 인포윈도우 컨텐츠 구성 ★★★★★
            let content = '<div class="infowindow">' +
                          '   <h5>' + place.title + '</h5>' +
                          '   <p>' + place.address + '</p>';

            <%-- JSP를 이용해 로그인 상태일 때만 버튼 추가 --%>
            <% if (session.getAttribute("userId") != null) { %>
                // place.id는 식당의 고유 ID라고 가정합니다. JSON 데이터에 id 필드가 있어야 합니다.
                content += '<button onclick="addFavorite(\'' + place.id + '\')">⭐ 즐겨찾기 추가</button>';
            <% } %>
            
            content += '</div>';

            let infowindow = new kakao.maps.InfoWindow({
                content: content
            });

            // 마커에 클릭 이벤트를 등록합니다
            kakao.maps.event.addListener(marker, 'click', function() {
                infowindow.open(map, marker);
            });
        });

        // ★★★★★ 3. 즐겨찾기 추가 JavaScript 함수 ★★★★★
        function addFavorite(restaurantId) {
            if (confirm(restaurantId + " 맛집을 즐겨찾기에 추가하시겠습니까?")) {
                document.getElementById('favRestaurantId').value = restaurantId;
                document.getElementById('favForm').submit();
            }
        }
    </script>
    
    <%-- 기존의 footer 등 나머지 body 내용 --%>
</body>
</html>