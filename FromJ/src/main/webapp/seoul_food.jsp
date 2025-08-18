<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>서울 맛집 지도</title>
    <link rel="stylesheet" href="css/food.css">
</head>
<body>
    <div class="container">
        <!-- 헤더 -->
        <header class="header">
            <div class="header-content">
                <h1 class="logo">🍴 서울 맛집 지도</h1>
                <div class="search-container">
                    <input type="text" id="searchInput" placeholder="맛집, 음식종류, 지역을 검색하세요..." class="search-input">
                    <button id="searchBtn" class="search-btn">검색</button>
                </div>
            </div>
        </header>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">
            <!-- 사이드바 -->
            <aside class="sidebar">
                <div class="filter-section">
                    <h3>🗺️ 지역별 검색</h3>
                    <select id="districtSelect" class="filter-select">
                        <option value="">전체 지역</option>
                    </select>
                </div>

                <div class="filter-section">
                    <h3>🍽️ 음식 종류</h3>
                    <select id="foodTypeSelect" class="filter-select">
                        <option value="">전체 음식</option>
                    </select>
                </div>

                <div class="filter-section">
                    <h3>⭐ 평점별 필터</h3>
                    <div class="rating-filter">
                        <input type="range" id="ratingSlider" min="0" max="5" step="0.1" value="0" class="slider">
                        <div class="rating-display">
                            <span id="ratingValue">0.0</span>점 이상
                        </div>
                    </div>
                </div>

                <div class="filter-section">
                    <button id="resetBtn" class="reset-btn">필터 초기화</button>
                </div>

                <!-- 맛집 리스트 -->
                <div class="restaurant-list">
                    <h3>📍 맛집 목록</h3>
                    <div id="restaurantItems" class="restaurant-items">
                        <!-- 맛집 아이템들이 여기에 동적으로 추가됩니다 -->
                    </div>
                </div>
            </aside>

            <!-- 지도 영역 -->
            <div class="map-container">
                <div id="map" class="map"></div>
                
                <!-- 로딩 스피너 -->
                <div id="loading" class="loading">
                    <div class="spinner"></div>
                    <p>맛집 정보를 불러오는 중...</p>
                </div>
            </div>
        </main>

        <!-- 맛집 상세 정보 모달 -->
        <div id="restaurantModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <div id="modalBody" class="modal-body">
                    <!-- 맛집 상세 정보가 여기에 표시됩니다 -->
                </div>
            </div>
        </div>

        <!-- 푸터 -->
        <footer class="footer">
            <p>&copy; 2024 서울 맛집 지도. All rights reserved.</p>
        </footer>
    </div>

    <script>
        // 전역 변수
        let map;
        let markers = [];
        let currentRestaurants = [];
        let selectedRestaurant = null;

        // 앱 초기화
        function initializeApp() {
            loadKakaoMapAPI()
                .then(() => {
                    initializeMap();
                    loadInitialData();
                    setupEventListeners();
                })
                .catch(error => {
                    console.error("초기화 오류:", error);
                    showMapError("지도 로딩에 실패했습니다.");
                });
        }

        // 카카오맵 API 로딩
        function loadKakaoMapAPI() {
            return new Promise((resolve, reject) => {
                if (window.kakao && window.kakao.maps) {
                    resolve();
                    return;
                }
                
                const script = document.createElement('script');
                script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=f095b37b01f01cf65f0126b3a001a917&autoload=false';
                
                script.onload = () => {
                    kakao.maps.load(() => {
                        console.log("카카오맵 API 로딩 완료");
                        resolve();
                    });
                };
                
                script.onerror = () => reject(new Error("카카오맵 API 로딩 실패"));
                document.head.appendChild(script);
            });
        }

        // 지도 초기화
        function initializeMap() {
            const mapContainer = document.getElementById('map');
            mapContainer.style.height = '600px';
            
            const mapOption = {
                center: new kakao.maps.LatLng(37.5665, 126.9780),
                level: 8
            };
            
            map = new kakao.maps.Map(mapContainer, mapOption);
            
            // 지도 컨트롤 추가
            map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
            map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
            
            setTimeout(() => map.relayout(), 100);
            console.log("지도 초기화 완료");
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
                url = 'RestaurantServlet?action=getByDistrict&district=' + encodeURIComponent(params.district);
            } else if (params.foodType) {
                url = 'RestaurantServlet?action=getByFoodType&foodType=' + encodeURIComponent(params.foodType);
            } else if (params.keyword) {
                url = 'RestaurantServlet?action=search&keyword=' + encodeURIComponent(params.keyword);
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
                    showMapError("맛집 정보를 불러오는데 실패했습니다.");
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
            
            item.innerHTML = 
                '<div class="restaurant-name">' + restaurant.restaurantName + '</div>' +
                '<div class="restaurant-rating">⭐ ' + restaurant.rating + '</div>' +
                '<div class="restaurant-type">' + restaurant.foodType + '</div>' +
                '<div class="restaurant-district">📍 ' + restaurant.district + '</div>';
            
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
            const selectedItem = document.querySelector('[data-id="' + restaurant.id + '"]');
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
                const overlayContent = 
                    '<div class="custom-overlay">' +
                    '<div class="restaurant-name">' + restaurant.restaurantName + '</div>' +
                    '<div class="restaurant-rating">⭐ ' + restaurant.rating + '</div>' +
                    '</div>';
                
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
            
            let tagsHtml = '';
            if (tags.length > 0) {
                tagsHtml = '<div class="detail-item">' +
                          '<div class="detail-icon">🏷️</div>' +
                          '<div class="detail-content">' +
                          '<div class="detail-label">태그</div>' +
                          '<div class="tags">' +
                          tags.map(tag => '<span class="tag">' + tag + '</span>').join('') +
                          '</div>' +
                          '</div>' +
                          '</div>';
            }
            
            modalBody.innerHTML = 
                '<div class="modal-header">' +
                '<div class="modal-restaurant-name">' + restaurant.restaurantName + '</div>' +
                '<div class="modal-rating">⭐ ' + restaurant.rating + '</div>' +
                '<div class="modal-type">' + restaurant.foodType + '</div>' +
                '</div>' +
                '<div class="modal-details">' +
                '<div class="detail-item">' +
                '<div class="detail-icon">📍</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">주소</div>' +
                '<div class="detail-value">' + restaurant.address + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🗺️</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">지역</div>' +
                '<div class="detail-value">' + restaurant.district + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🚇</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">인근 지하철역</div>' +
                '<div class="detail-value">' + (restaurant.nearbyStation || '정보 없음') + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🕒</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">영업시간</div>' +
                '<div class="detail-value">' + (restaurant.openingHours || '정보 없음') + '</div>' +
                '</div>' +
                '</div>' +
                tagsHtml +
                '</div>';
            
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

        // 지도 오류 표시
        function showMapError(message) {
            const mapContainer = document.getElementById('map');
            mapContainer.innerHTML = 
                '<div style="display: flex; align-items: center; justify-content: center; height: 100%; background: #f8f9fa; border: 2px dashed #dee2e6; color: #6c757d; text-align: center; padding: 20px;">' +
                '<div><h3 style="color: #dc3545;">🗺️ 지도 로딩 오류</h3>' +
                '<p>' + message + '</p>' +
                '<button onclick="location.reload()" style="background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">새로고침</button></div></div>';
        }

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', initializeApp);
    </script>
</body>
</html>console.log("카카오맵 API 로딩 완료");
                        resolve();
                    });
                };
                
                script.onerror = () => reject(new Error("카카오맵 API 로딩 실패"));
                document.head.appendChild(script);
            });
        }

        // 지도 초기화
        function initializeMap() {
            const mapContainer = document.getElementById('map');
            mapContainer.style.height = '600px';
            
            const mapOption = {
                center: new kakao.maps.LatLng(37.5665, 126.9780),
                level: 8
            };
            
            kakaoMap = new kakao.maps.Map(mapContainer, mapOption);
            
            // 지도 컨트롤 추가
            kakaoMap.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
            kakaoMap.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);
            
            setTimeout(() => kakaoMap.relayout(), 100);
            console.log("지도 초기화 완료");
        }

        // 초기 데이터 표시
        function displayInitialData() {
            if (restaurantsData.length > 0) {
                filterAndDisplay();
                console.log("초기 데이터 표시 완료:", restaurantsData.length + "개 맛집");
            } else {
                console.log("데이터가 없습니다.");
            }
        }

        // 필터링 및 표시
        function filterAndDisplay() {
            const minRating = parseFloat(document.getElementById('ratingSlider').value);
            const selectedDistrict = document.getElementById('districtSelect').value;
            const selectedFoodType = document.getElementById('foodTypeSelect').value;
            const searchKeyword = document.getElementById('searchInput').value.toLowerCase().trim();

            currentRestaurants = restaurantsData.filter(restaurant => {
                // 평점 필터
                if (restaurant.rating < minRating) return false;
                
                // 지역 필터
                if (selectedDistrict && restaurant.district !== selectedDistrict) return false;
                
                // 음식 종류 필터
                if (selectedFoodType && restaurant.foodType !== selectedFoodType) return false;
                
                // 검색어 필터
                if (searchKeyword) {
                    const searchIn = (restaurant.restaurantName + ' ' + restaurant.foodType + ' ' + 
                                    restaurant.district + ' ' + (restaurant.tags || '')).toLowerCase();
                    if (!searchIn.includes(searchKeyword)) return false;
                }
                
                return true;
            });

            displayRestaurants();
            displayMarkers();
        }

        // 맛집 목록 표시
        function displayRestaurants() {
            const items = document.querySelectorAll('.restaurant-item');
            let visibleCount = 0;

            items.forEach(item => {
                const id = parseInt(item.dataset.id);
                const isVisible = currentRestaurants.some(r => r.id === id);
                item.style.display = isVisible ? 'block' : 'none';
                if (isVisible) visibleCount++;
            });

            // 결과 수 업데이트
            const listHeader = document.querySelector('.restaurant-list h3');
            if (listHeader) {
                listHeader.textContent = '📍 맛집 목록 (' + visibleCount + '개)';
            }
        }

        // 마커 표시
        function displayMarkers() {
            // 기존 마커 제거
            mapMarkers.forEach(marker => marker.setMap(null));
            mapMarkers = [];

            currentRestaurants.forEach(restaurant => {
                const position = new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude);
                
                const marker = new kakao.maps.Marker({
                    position: position,
                    map: kakaoMap
                });

                // 마커 클릭 이벤트
                kakao.maps.event.addListener(marker, 'click', () => {
                    selectRestaurant(restaurant);
                    showRestaurantModal(restaurant);
                });

                mapMarkers.push(marker);
            });

            // 지도 영역 조정
            if (currentRestaurants.length > 0) {
                const bounds = new kakao.maps.LatLngBounds();
                currentRestaurants.forEach(restaurant => {
                    bounds.extend(new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude));
                });
                kakaoMap.setBounds(bounds);
            }
        }

        // 맛집 선택
        function selectRestaurant(restaurant) {
            document.querySelectorAll('.restaurant-item').forEach(item => {
                item.classList.remove('selected');
            });

            const selectedItem = document.querySelector('[data-id="' + restaurant.id + '"]');
            if (selectedItem) {
                selectedItem.classList.add('selected');
                selectedItem.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }

            const position = new kakao.maps.LatLng(restaurant.latitude, restaurant.longitude);
            kakaoMap.setCenter(position);
            kakaoMap.setLevel(3);
        }

        // 모달 표시
        function showRestaurantModal(restaurant) {
            const modal = document.getElementById('restaurantModal');
            const modalBody = document.getElementById('modalBody');
            
            const tags = restaurant.tags ? restaurant.tags.split(',').map(tag => tag.trim()) : [];
            
            let tagsHtml = '';
            if (tags.length > 0 && tags[0] !== '') {
                tagsHtml = '<div class="detail-item">' +
                          '<div class="detail-icon">🏷️</div>' +
                          '<div class="detail-content">' +
                          '<div class="detail-label">태그</div>' +
                          '<div class="tags">' +
                          tags.map(tag => '<span class="tag">' + tag + '</span>').join('') +
                          '</div></div></div>';
            }
            
            modalBody.innerHTML = 
                '<div class="modal-header">' +
                '<div class="modal-restaurant-name">' + restaurant.restaurantName + '</div>' +
                '<div class="modal-rating">⭐ ' + restaurant.rating + '</div>' +
                '<div class="modal-type">' + restaurant.foodType + '</div>' +
                '</div>' +
                '<div class="modal-details">' +
                '<div class="detail-item">' +
                '<div class="detail-icon">📍</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">주소</div>' +
                '<div class="detail-value">' + restaurant.address + '</div>' +
                '</div></div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🗺️</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">지역</div>' +
                '<div class="detail-value">' + restaurant.district + '</div>' +
                '</div></div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🚇</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">인근 지하철역</div>' +
                '<div class="detail-value">' + (restaurant.nearbyStation || '정보 없음') + '</div>' +
                '</div></div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🕒</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">영업시간</div>' +
                '<div class="detail-value">' + (restaurant.openingHours || '정보 없음') + '</div>' +
                '</div></div>' +
                tagsHtml +
                '</div>';
            
            modal.style.display = 'block';
        }

        // 이벤트 리스너 설정
        function setupEventListeners() {
            // 검색
            document.getElementById('searchBtn').addEventListener('click', filterAndDisplay);
            document.getElementById('searchInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') filterAndDisplay();
            });

            // 필터
            document.getElementById('districtSelect').addEventListener('change', filterAndDisplay);
            document.getElementById('foodTypeSelect').addEventListener('change', filterAndDisplay);
            
            // 평점 슬라이더
            document.getElementById('ratingSlider').addEventListener('input', function() {
                document.getElementById('ratingValue').textContent = parseFloat(this.value).toFixed(1);
                filterAndDisplay();
            });

            // 필터 초기화
            document.getElementById('resetBtn').addEventListener('click', function() {
                document.getElementById('districtSelect').value = '';
                document.getElementById('foodTypeSelect').value = '';
                document.getElementById('searchInput').value = '';
                document.getElementById('ratingSlider').value = '0';
                document.getElementById('ratingValue').textContent = '0.0';
                filterAndDisplay();
            });

            // 맛집 아이템 클릭
            document.querySelectorAll('.restaurant-item').forEach(item => {
                item.addEventListener('click', function() {
                    const id = parseInt(this.dataset.id);
                    const restaurant = restaurantsData.find(r => r.id === id);
                    if (restaurant) {
                        selectRestaurant(restaurant);
                        showRestaurantModal(restaurant);
                    }
                });
            });

            // 모달 닫기
            document.querySelector('.close').addEventListener('click', () => {
                document.getElementById('restaurantModal').style.display = 'none';
            });
            
            document.getElementById('restaurantModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    this.style.display = 'none';
                }
            });

            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape') {
                    document.getElementById('restaurantModal').style.display = 'none';
                }
            });
        }

        // 에러 표시
        function showMapError(message) {
            const mapContainer = document.getElementById('map');
            mapContainer.innerHTML = 
                '<div style="display: flex; align-items: center; justify-content: center; height: 100%; background: #f8f9fa; border: 2px dashed #dee2e6; color: #6c757d; text-align: center; padding: 20px;">' +
                '<div><h3 style="color: #dc3545;">🗺️ 지도 로딩 오류</h3>' +
                '<p>' + message + '</p>' +
                '<button onclick="location.reload()" style="background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;">새로고침</button></div></div>';
        }

        // 페이지 로드 시 초기화
        document.addEventListener('DOMContentLoaded', initializeApp);
    </script>
</body>
</html>
                    <input type="text" id="searchInput" placeholder="맛집, 음식종류, 지역을 검색하세요..." class="search-input">
                    <button id="searchBtn" class="search-btn">검색</button>
                </div>
            </div>
        </header>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">
            <!-- 사이드바 -->
            <aside class="sidebar">
                <div class="filter-section">
                    <h3>🗺️ 지역별 검색</h3>
                    <select id="districtSelect" class="filter-select">
                        <option value="">전체 지역</option>
                    </select>
                </div>

                <div class="filter-section">
                    <h3>🍽️ 음식 종류</h3>
                    <select id="foodTypeSelect" class="filter-select">
                        <option value="">전체 음식</option>
                    </select>
                </div>

                <div class="filter-section">
                    <h3>⭐ 평점별 필터</h3>
                    <div class="rating-filter">
                        <input type="range" id="ratingSlider" min="0" max="5" step="0.1" value="0" class="slider">
                        <div class="rating-display">
                            <span id="ratingValue">0.0</span>점 이상
                        </div>
                    </div>
                </div>

                <div class="filter-section">
                    <button id="resetBtn" class="reset-btn">필터 초기화</button>
                </div>

                <!-- 맛집 리스트 -->
                <div class="restaurant-list">
                    <h3>📍 맛집 목록</h3>
                    <div id="restaurantItems" class="restaurant-items">
                        <!-- 맛집 아이템들이 여기에 동적으로 추가됩니다 -->
                    </div>
                </div>
            </aside>

            <!-- 지도 영역 -->
            <div class="map-container">
                <div id="map" class="map"></div>
                
                <!-- 로딩 스피너 -->
                <div id="loading" class="loading">
                    <div class="spinner"></div>
                    <p>맛집 정보를 불러오는 중...</p>
                </div>
            </div>
        </main>

        <!-- 맛집 상세 정보 모달 -->
        <div id="restaurantModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <div id="modalBody" class="modal-body">
                    <!-- 맛집 상세 정보가 여기에 표시됩니다 -->
                </div>
            </div>
        </div>

        <!-- 푸터 -->
        <footer class="footer">
            <p>&copy; 2024 서울 맛집 지도. All rights reserved.</p>
        </footer>
    </div>

    <script>
        // 전역 변수
        let map;
        let markers = [];
        let currentRestaurants = [];
        let selectedRestaurant = null;

        // 카카오맵 API 동적 로딩 및 초기화
        function initializeApp() {
            const script = document.createElement('script');
            script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=f095b37b01f01cf65f0126b3a001a917&autoload=false';
            
            script.onload = function() {
                kakao.maps.load(function() {
                    console.log("카카오맵 API 로딩 완료");
                    initializeMap();
                    loadInitialData();
                    setupEventListeners();
                });
            };
            
            script.onerror = function() {
                console.error("카카오맵 API 로딩 실패");
                showMapError("카카오맵 API 로딩에 실패했습니다.");
            };
            
            document.head.appendChild(script);
        }

        // 카카오맵 초기화
        function initializeMap() {
            try {
                const mapContainer = document.getElementById('map');
                console.log("지도 컨테이너:", mapContainer);
                console.log("지도 컨테이너 크기:", mapContainer.offsetWidth, "x", mapContainer.offsetHeight);
                
                if (!mapContainer) {
                    console.error("지도 컨테이너를 찾을 수 없습니다");
                    return;
                }
                
                // 지도 컨테이너 크기 강제 설정
                mapContainer.style.width = '100%';
                mapContainer.style.height = '600px';
                
                const mapOption = {
                    center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울 중심좌표
                    level: 8 // 확대 레벨
                };
                
                map = new kakao.maps.Map(mapContainer, mapOption);
                console.log("지도 객체:", map);
                
                // 지도 타입 컨트롤 추가
                const mapTypeControl = new kakao.maps.MapTypeControl();
                map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
                
                // 줌 컨트롤 추가
                const zoomControl = new kakao.maps.ZoomControl();
                map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
                
                console.log("지도 초기화 완료");
                
                // 지도 크기 재조정 (중요!)
                setTimeout(() => {
                    map.relayout();
                }, 100);
                
            } catch (error) {
                console.error("지도 초기화 오류:", error);
                showMapError("지도 초기화에 실패했습니다: " + error.message);
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
                url = 'RestaurantServlet?action=getByDistrict&district=' + encodeURIComponent(params.district);
            } else if (params.foodType) {
                url = 'RestaurantServlet?action=getByFoodType&foodType=' + encodeURIComponent(params.foodType);
            } else if (params.keyword) {
                url = 'RestaurantServlet?action=search&keyword=' + encodeURIComponent(params.keyword);
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
                    showMapError("맛집 정보를 불러오는데 실패했습니다.");
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
            
            item.innerHTML = 
                '<div class="restaurant-name">' + restaurant.restaurantName + '</div>' +
                '<div class="restaurant-rating">⭐ ' + restaurant.rating + '</div>' +
                '<div class="restaurant-type">' + restaurant.foodType + '</div>' +
                '<div class="restaurant-district">📍 ' + restaurant.district + '</div>';
            
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
            const selectedItem = document.querySelector('[data-id="' + restaurant.id + '"]');
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
                const overlayContent = 
                    '<div class="custom-overlay">' +
                    '<div class="restaurant-name">' + restaurant.restaurantName + '</div>' +
                    '<div class="restaurant-rating">⭐ ' + restaurant.rating + '</div>' +
                    '</div>';
                
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
            
            let tagsHtml = '';
            if (tags.length > 0) {
                tagsHtml = '<div class="detail-item">' +
                          '<div class="detail-icon">🏷️</div>' +
                          '<div class="detail-content">' +
                          '<div class="detail-label">태그</div>' +
                          '<div class="tags">' +
                          tags.map(tag => '<span class="tag">' + tag + '</span>').join('') +
                          '</div>' +
                          '</div>' +
                          '</div>';
            }
            
            modalBody.innerHTML = 
                '<div class="modal-header">' +
                '<div class="modal-restaurant-name">' + restaurant.restaurantName + '</div>' +
                '<div class="modal-rating">⭐ ' + restaurant.rating + '</div>' +
                '<div class="modal-type">' + restaurant.foodType + '</div>' +
                '</div>' +
                '<div class="modal-details">' +
                '<div class="detail-item">' +
                '<div class="detail-icon">📍</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">주소</div>' +
                '<div class="detail-value">' + restaurant.address + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🗺️</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">지역</div>' +
                '<div class="detail-value">' + restaurant.district + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🚇</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">인근 지하철역</div>' +
                '<div class="detail-value">' + (restaurant.nearbyStation || '정보 없음') + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="detail-item">' +
                '<div class="detail-icon">🕒</div>' +
                '<div class="detail-content">' +
                '<div class="detail-label">영업시간</div>' +
                '<div class="detail-value">' + (restaurant.openingHours || '정보 없음') + '</div>' +
                '</div>' +
                '</div>' +
                tagsHtml +
                '</div>';
            
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

        // 지도 오류 표시
        function showMapError(message) {
            const mapContainer = document.getElementById('map');
            if (mapContainer) {
                mapContainer.innerHTML = 
                    '<div style="' +
                        'display: flex;' +
                        'align-items: center;' +
                        'justify-content: center;' +
                        'height: 100%;' +
                        'background: #f8f9fa;' +
                        'border: 2px dashed #dee2e6;' +
                        'color: #6c757d;' +
                        'text-align: center;' +
                        'padding: 20px;' +
                        'font-family: Arial, sans-serif;' +
                    '">' +
                        '<div>' +
                            '<h3 style="color: #dc3545; margin-bottom: 10px;">🗺️ 지도 로딩 오류</h3>' +
                            '<p style="margin-bottom: 15px;">' + message + '</p>' +
                            '<button onclick="location.reload()" style="' +
                                'background: #007bff;' +
                                'color: white;' +
                                'border: none;' +
                                'padding: 10px 20px;' +
                                'border-radius: 5px;' +
                                'cursor: pointer;' +
                            '">페이지 새로고침</button>' +
                        '</div>' +
                    '</div>';
            }
        }

        // 페이지 로드 완료 후 앱 초기화
        document.addEventListener('DOMContentLoaded', initializeApp);
    </script>
</body>
</html>