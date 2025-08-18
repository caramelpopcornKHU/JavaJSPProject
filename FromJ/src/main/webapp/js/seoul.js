// 전역 변수
let map;
let markers = [];
let currentRestaurants = [];
let selectedRestaurant = null;

// 앱 초기화 함수 (외부에서 호출)
function initializeApp() {
    console.log("앱 초기화 시작");
    initializeMap();
    loadInitialData();
    setupEventListeners();
}

// 카카오맵 초기화
function initializeMap() {
    console.log("지도 초기화 시작");
    
    try {
        const mapContainer = document.getElementById('map');
        console.log("지도 컨테이너:", mapContainer);
        
        if (!mapContainer) {
            console.error("지도 컨테이너를 찾을 수 없습니다");
            return;
        }
        
        const mapOption = {
            center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울 중심좌표
            level: 8 // 확대 레벨
        };
        
        console.log("지도 옵션:", mapOption);
        console.log("kakao.maps 객체:", kakao.maps);
        
        map = new kakao.maps.Map(mapContainer, mapOption);
        console.log("지도 객체 생성 완료:", map);
        
        // 지도 타입 컨트롤 추가
        const mapTypeControl = new kakao.maps.MapTypeControl();
        map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        
        // 줌 컨트롤 추가
        const zoomControl = new kakao.maps.ZoomControl();
        map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
        
        console.log("지도 초기화 완료");
        
    } catch (error) {
        console.error("지도 초기화 오류:", error);
        showMapError("지도 초기화에 실패했습니다: " + error.message);
    }
}

// 지도 오류 표시 함수
function showMapError(message) {
    const mapContainer = document.getElementById('map');
    if (mapContainer) {
        mapContainer.innerHTML = `
            <div style="
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100%;
                background: #f8f9fa;
                border: 2px dashed #dee2e6;
                color: #6c757d;
                text-align: center;
                padding: 20px;
                font-family: Arial, sans-serif;
            ">
                <div>
                    <h3 style="color: #dc3545; margin-bottom: 10px;">🗺️ 지도 로딩 오류</h3>
                    <p style="margin-bottom: 15px;">${message}</p>
                    <button onclick="location.reload()" style="
                        background: #007bff;
                        color: white;
                        border: none;
                        padding: 10px 20px;
                        border-radius: 5px;
                        cursor: pointer;
                    ">페이지 새로고침</button>
                </div>
            </div>
        `;
    }
}

// 초기 데이터 로드
function loadInitialData() {
    showLoading(true);
    
    // 모든 맛집 정보 로드
    loadRestaurants();
    
    // 지역 목록 로드
    loadDistricts();
    
    // 음식 종류 목록 로드
    loadFoodTypes();
}

// 맛집 정보 로드
function loadRestaurants(params = {}) {
    let url = 'RestaurantServlet?action=getAllRestaurants';
    
    if (params.district) {
        url = `RestaurantServlet?action=getByDistrict&district=${encodeURIComponent(params.district)}`;
    } else if (params.foodType) {
        url = `RestaurantServlet?action=getByFoodType&foodType=${encodeURIComponent(params.foodType)}`;
    } else if (params.keyword) {
        url = `RestaurantServlet?action=search&keyword=${encodeURIComponent(params.keyword)}`;
    }
    
    fetch(url)
        .then(response => response.json())
        .then(data => {
            currentRestaurants = data;
            filterByRating();
            displayRestaurants();
            displayMarkers();
            showLoading(false);
        })
        .catch(error => {
            console.error('Error loading restaurants:', error);
            showLoading(false);
        });
}

// 지역 목록 로드
function loadDistricts() {
    fetch('RestaurantServlet?action=getDistricts')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('districtSelect');
            data.forEach(district => {
                const option = document.createElement('option');
                option.value = district;
                option.textContent = district;
                select.appendChild(option);
            });
        })
        .catch(error => console.error('Error loading districts:', error));
}

// 음식 종류 목록 로드
function loadFoodTypes() {
    fetch('RestaurantServlet?action=getFoodTypes')
        .then(response => response.json())
        .then(data => {
            const select = document.getElementById('foodTypeSelect');
            data.forEach(foodType => {
                const option = document.createElement('option');
                option.value = foodType;
                option.textContent = foodType;
                select.appendChild(option);
            });
        })
        .catch(error => console.error('Error loading food types:', error));
}

// 평점 필터링
function filterByRating() {
    const minRating = parseFloat(document.getElementById('ratingSlider').value);
    currentRestaurants = currentRestaurants.filter(restaurant => restaurant.rating >= minRating);
}

// 맛집 목록 표시
function displayRestaurants() {
    const container = document.getElementById('restaurantItems');
    container.innerHTML = '';
    
    if (currentRestaurants.length === 0) {
        container.innerHTML = '<div class="no-results">검색 결과가 없습니다.</div>';
        return;
    }
    
    currentRestaurants.forEach(restaurant => {
        const item = createRestaurantItem(restaurant);
        container.appendChild(item);
    });
}

// 맛집 아이템 생성
function createRestaurantItem(restaurant) {
    const item = document.createElement('div');
    item.className = 'restaurant-item';
    item.setAttribute('data-id', restaurant.id);
    
    item.innerHTML = `
        <div class="restaurant-name">${restaurant.restaurantName}</div>
        <div class="restaurant-rating">⭐ ${restaurant.rating}</div>
        <div class="restaurant-type">${restaurant.foodType}</div>
        <div class="restaurant-district">📍 ${restaurant.district}</div>
    `;
    
    item.addEventListener('click', () => {
        selectRestaurant(restaurant);
        showRestaurantModal(restaurant);
    });
    
    return item;
}

// 맛집 선택
function selectRestaurant(restaurant) {
    // 이전 선택 해제
    document.querySelectorAll('.restaurant-item').forEach(item => {
        item.classList.remove('selected');
    });
    
    // 현재 선택 표시
    const selectedItem = document.querySelector(`[data-id="${restaurant.id}"]`);
    if (selectedItem) {
        selectedItem.classList.add('selected');
    }
    
    selectedRestaurant = restaurant;
    
    // 지도 중심을 선택된 맛집으로 이동
    const position = new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude);
    map.setCenter(position);
    map.setLevel(3);
}

// 지도 마커 표시
function displayMarkers() {
    // 기존 마커 제거
    markers.forEach(marker => marker.setMap(null));
    markers = [];
    
    currentRestaurants.forEach(restaurant => {
        const position = new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude);
        
        // 마커 생성
        const marker = new kakao.maps.Marker({
            position: position,
            map: map
        });
        
        // 커스텀 오버레이 생성
        const overlayContent = `
            <div class="custom-overlay">
                <div class="restaurant-name">${restaurant.restaurantName}</div>
                <div class="restaurant-rating">⭐ ${restaurant.rating}</div>
            </div>
        `;
        
        const customOverlay = new kakao.maps.CustomOverlay({
            position: position,
            content: overlayContent,
            yAnchor: 1.2
        });
        
        // 마커 클릭 이벤트
        kakao.maps.event.addListener(marker, 'click', () => {
            // 모든 오버레이 숨기기
            markers.forEach(m => {
                if (m.overlay) {
                    m.overlay.setMap(null);
                }
            });
            
            // 선택된 오버레이만 표시
            customOverlay.setMap(map);
            selectRestaurant(restaurant);
            showRestaurantModal(restaurant);
        });
        
        marker.overlay = customOverlay;
        markers.push(marker);
    });
    
    // 지도 영역 조정
    if (currentRestaurants.length > 0) {
        const bounds = new kakao.maps.LatLngBounds();
        currentRestaurants.forEach(restaurant => {
            bounds.extend(new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude));
        });
        map.setBounds(bounds);
    }
}

// 맛집 상세 정보 모달 표시
function showRestaurantModal(restaurant) {
    const modal = document.getElementById('restaurantModal');
    const modalBody = document.getElementById('modalBody');
    
    const tags = restaurant.tags ? restaurant.tags.split(',').map(tag => tag.trim()) : [];
    
    modalBody.innerHTML = `
        <div class="modal-header">
            <div class="modal-restaurant-name">${restaurant.restaurantName}</div>
            <div class="modal-rating">⭐ ${restaurant.rating}</div>
            <div class="modal-type">${restaurant.foodType}</div>
        </div>
        
        <div class="modal-details">
            <div class="detail-item">
                <div class="detail-icon">📍</div>
                <div class="detail-content">
                    <div class="detail-label">주소</div>
                    <div class="detail-value">${restaurant.address}</div>
                </div>
            </div>
            
            <div class="detail-item">
                <div class="detail-icon">🗺️</div>
                <div class="detail-content">
                    <div class="detail-label">지역</div>
                    <div class="detail-value">${restaurant.district}</div>
                </div>
            </div>
            
            <div class="detail-item">
                <div class="detail-icon">🚇</div>
                <div class="detail-content">
                    <div class="detail-label">인근 지하철역</div>
                    <div class="detail-value">${restaurant.nearbyStation || '정보 없음'}</div>
                </div>
            </div>
            
            <div class="detail-item">
                <div class="detail-icon">🕒</div>
                <div class="detail-content">
                    <div class="detail-label">영업시간</div>
                    <div class="detail-value">${restaurant.openingHours || '정보 없음'}</div>
                </div>
            </div>
            
            ${tags.length > 0 ? `
            <div class="detail-item">
                <div class="detail-icon">🏷️</div>
                <div class="detail-content">
                    <div class="detail-label">태그</div>
                    <div class="tags">
                        ${tags.map(tag => `<span class="tag">${tag}</span>`).join('')}
                    </div>
                </div>
            </div>
            ` : ''}
        </div>
    `;
    
    modal.style.display = 'block';
}

// 이벤트 리스너 설정
function setupEventListeners() {
    // 검색 버튼
    document.getElementById('searchBtn').addEventListener('click', performSearch);
    
    // 검색 입력 엔터키
    document.getElementById('searchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            performSearch();
        }
    });
    
    // 지역 선택
    document.getElementById('districtSelect').addEventListener('change', function() {
        const district = this.value;
        if (district) {
            loadRestaurants({ district });
        } else {
            loadRestaurants();
        }
        resetOtherFilters('district');
    });
    
    // 음식 종류 선택
    document.getElementById('foodTypeSelect').addEventListener('change', function() {
        const foodType = this.value;
        if (foodType) {
            loadRestaurants({ foodType });
        } else {
            loadRestaurants();
        }
        resetOtherFilters('foodType');
    });
    
    // 평점 슬라이더
    const ratingSlider = document.getElementById('ratingSlider');
    const ratingValue = document.getElementById('ratingValue');
    
    ratingSlider.addEventListener('input', function() {
        ratingValue.textContent = parseFloat(this.value).toFixed(1);
        filterByRating();
        displayRestaurants();
        displayMarkers();
    });
    
    // 필터 초기화 버튼
    document.getElementById('resetBtn').addEventListener('click', resetAllFilters);
    
    // 모달 닫기
    document.querySelector('.close').addEventListener('click', closeModal);
    
    // 모달 배경 클릭시 닫기
    document.getElementById('restaurantModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
    
    // ESC 키로 모달 닫기
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });
}

// 검색 수행
function performSearch() {
    const keyword = document.getElementById('searchInput').value.trim();
    if (keyword) {
        loadRestaurants({ keyword });
        resetOtherFilters('search');
    }
}

// 다른 필터 초기화
function resetOtherFilters(except) {
    if (except !== 'district') {
        document.getElementById('districtSelect').value = '';
    }
    if (except !== 'foodType') {
        document.getElementById('foodTypeSelect').value = '';
    }
    if (except !== 'search') {
        document.getElementById('searchInput').value = '';
    }
}

// 모든 필터 초기화
function resetAllFilters() {
    document.getElementById('districtSelect').value = '';
    document.getElementById('foodTypeSelect').value = '';
    document.getElementById('searchInput').value = '';
    document.getElementById('ratingSlider').value = '0';
    document.getElementById('ratingValue').textContent = '0.0';
    
    loadRestaurants();
}

// 모달 닫기
function closeModal() {
    document.getElementById('restaurantModal').style.display = 'none';
}

// 로딩 표시/숨김
function showLoading(show) {
    const loading = document.getElementById('loading');
    loading.style.display = show ? 'block' : 'none';
}

// 유틸리티 함수들
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// 에러 처리
window.addEventListener('error', function(e) {
    console.error('JavaScript Error:', e.error);
    showLoading(false);
});

// 네트워크 에러 처리
window.addEventListener('unhandledrejection', function(e) {
    console.error('Promise Rejection:', e.reason);
    showLoading(false);
});