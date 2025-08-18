// 전역 변수로 map과 markers 배열을 선언합니다.
let map;
let markers = [];

// 1. 페이지가 로드되면 실행될 초기화 함수
document.addEventListener("DOMContentLoaded", function() {
    initMap(); // 지도 생성
    fetchRestaurants(); // 모든 맛집 데이터 로드

    // 검색 버튼 클릭 이벤트 리스너
    document.getElementById('searchButton').addEventListener('click', function() {
        const keyword = document.getElementById('searchInput').value;
        fetchRestaurants(keyword); // 검색어로 맛집 데이터 로드
    });
    
    // 엔터 키 입력 이벤트 리스너
    document.getElementById('searchInput').addEventListener('keyup', function(event) {
        if (event.key === 'Enter') {
            const keyword = document.getElementById('searchInput').value;
            fetchRestaurants(keyword);
        }
    });
});

// 2. 지도 생성 함수
function initMap() {
    const mapContainer = document.getElementById('map');
    const mapOption = {
        center: new kakao.maps.LatLng(37.566826, 126.9786567), // 서울시청
        level: 7
    };
    map = new kakao.maps.Map(mapContainer, mapOption);
}

// 3. 서버에 맛집 데이터를 요청하는 함수
function fetchRestaurants(keyword) {
    let url = '/FromJ/getRestaurants'; // 기본 서블릿 URL

    // 검색어가 있으면 URL에 쿼리 파라미터를 추가합니다.
    if (keyword) {
        url += '?search=' + encodeURIComponent(keyword);
    }

    fetch(url)
        .then(response => response.json())
        .then(data => {
            displayMarkers(data); // 받아온 데이터로 마커 표시
        })
        .catch(error => console.error('Error fetching data:', error));
}

// 4. 지도에 마커를 표시하는 함수
function displayMarkers(restaurants) {
    // 기존 마커들을 지도에서 제거합니다.
    markers.forEach(marker => marker.setMap(null));
    markers = []; // 마커 배열 초기화

    if (restaurants.length === 0) {
        alert("검색 결과가 없습니다.");
        return;
    }

    // 맛집 데이터 배열을 순회하며 마커와 인포윈도우를 생성합니다.
    restaurants.forEach(resto => {
        const position = new kakao.maps.LatLng(resto.latitude, resto.longitude);

        // 마커 생성
        const marker = new kakao.maps.Marker({
            map: map,
            position: position,
            title: resto.restaurantName
        });

        // 인포윈도우에 표시할 내용 (HTML)
        const content = `
            <div style="padding:10px; width:250px;">
                <h5 style="font-weight:bold; margin-bottom:5px;">${resto.restaurantName}</h5>
                <p style="font-size:13px; margin:0;">주소: ${resto.address}</p>
                <p style="font-size:13px; margin:0;">종류: ${resto.foodType} (평점: ${resto.rating})</p>
                <p style="font-size:13px; margin:0;">태그: ${resto.tags}</p>
            </div>
        `;

        // 인포윈도우 생성
        const infowindow = new kakao.maps.InfoWindow({
            content: content,
            removable: true
        });

        // 마커에 클릭 이벤트를 추가합니다.
        kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map, marker);
        });

        markers.push(marker); // 생성된 마커를 배열에 추가
    });
	// (파일의 다른 부분은 동일)

	// 4. 지도에 마커를 표시하는 함수
	function displayMarkers(restaurants) {
	    // ... (이전 코드 동일)

	    // 인포윈도우에 표시할 내용 (HTML)
	    const content = `
	        <div style="padding:10px; width:280px; font-size:14px; line-height:1.6;">
	            <h5 style="font-weight:bold; margin-bottom:8px;">${resto.restaurantName}</h5>
	            <p style="margin:0;"><b>종류:</b> ${resto.foodType} (⭐${resto.rating})</p>
	            <p style="margin:0;"><b>주소:</b> ${resto.address}</p>
	            <p style="margin:0;"><b>가까운 역:</b> ${resto.nearbyStation}</p> <!-- ⭐ 역 정보 표시 추가 -->
	            <p style="margin:0;"><b>태그:</b> ${resto.tags}</p>
	        </div>
	    `;

	    // ... (이후 코드 동일)
	}
}