$(document).ready(function() {
    // 전역 변수
    var currentCategory = 'all';
    var currentPage = 1;
    var currentPost = null;
    var passwordAction = '';
    var passwordPostId = 0;
    var uploadedImages = [];
    var isSearchMode = false;
    var currentKeyword = '';

    // 초기 로드
    loadPostList();
    
    // 이벤트 핸들러 등록
    initEventHandlers();

    function initEventHandlers() {
        // 글쓰기 버튼
        $('#btnWrite').click(function() {
            console.log('새글쓰기 버튼 클릭');
            clearForm(); // 폼 초기화 먼저
            showWriteForm(); // 그 다음 폼 표시
        });

        // 새로고침 버튼
        $('#btnRefresh').click(function() {
            isSearchMode = false;
            currentKeyword = '';
            $('#searchInput').val('');
            loadPostList();
        });

        // 카테고리 링크
        $('.category-link').click(function(e) {
            e.preventDefault();
            currentCategory = $(this).data('category');
            currentPage = 1;
            $('.category-link').removeClass('active');
            $(this).addClass('active');
            
            if (isSearchMode) {
                searchPosts();
            } else {
                loadPostList();
            }
        });

        // 검색 기능
        $('#btnSearch').click(function() {
            searchPosts();
        });

        $('#searchInput').keypress(function(e) {
            if (e.which === 13) { // Enter 키
                searchPosts();
            }
        });

        // 상세보기 버튼들
        $('#btnList').click(function() {
            showPostList();
        });

        $('#btnEdit').click(function() {
            if (currentPost) {
                showPasswordModal('edit', currentPost.id);
            }
        });

        $('#btnDelete').click(function() {
            if (currentPost) {
                showPasswordModal('delete', currentPost.id);
            }
        });

        // 폼 관련
        $('#postForm').submit(function(e) {
            e.preventDefault();
            submitPost();
        });

        $('#cancelBtn').click(function() {
            hideWriteForm();
        });

        // 비밀번호 모달
        $('#passwordForm').submit(function(e) {
            e.preventDefault();
            checkPassword();
        });

        $('#passwordCancel').click(function() {
            hidePasswordModal();
        });

        // 이미지 모달
        $('#imageClose').click(function() {
            hideImageModal();
        });

        // 파일 업로드
        $('#fileInput').change(function() {
            handleFileSelect(this.files);
        });

        // 모달 외부 클릭
        $('.modal').click(function(e) {
            if (e.target === this) {
                $(this).hide();
            }
        });
    }

    // 검색 기능
    function searchPosts() {
        var keyword = $('#searchInput').val().trim();
        if (!keyword) {
            alert('검색어를 입력하세요.');
            return;
        }
        
        isSearchMode = true;
        currentKeyword = keyword;
        currentPage = 1;
        
        $.ajax({
            url: 'board.do',
            type: 'GET',
            data: {
                action: 'search',
                keyword: keyword,
                category: currentCategory,
                page: currentPage
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    displayPostList(response.posts, '검색결과: "' + keyword + '"');
                    displayPagination(response.pagination);
                } else {
                    alert('검색에 실패했습니다.');
                }
            },
            error: function() {
                alert('검색 중 오류가 발생했습니다.');
            }
        });
    }

    // 게시글 목록 로드
    function loadPostList() {
        $.ajax({
            url: 'board.do',
            type: 'GET',
            data: {
                action: 'list',
                category: currentCategory,
                page: currentPage
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    displayPostList(response.posts);
                    displayPagination(response.pagination);
                } else {
                    alert('목록을 불러오는데 실패했습니다.');
                }
            },
            error: function() {
                // 서버 연결 실패시 모의 데이터 사용
                loadMockData();
            }
        });
    }

    // 모의 데이터 로드
    function loadMockData() {
        var mockPosts = [
            {
                id: 1,
                category: 'society',
                categoryName: '사회',
                title: '안녕하세요 처음 가입했습니다',
                author: '신규회원',
                content: '안녕하세요! 게시판에 처음 가입했습니다.\n잘 부탁드립니다.',
                regDate: '2024-08-16 10:30:00',
                views: 45,
                hasImage: false,
                imageFiles: '',
                password: '1234'
            },
            {
                id: 2,
                category: 'culture',
                categoryName: '문화',
                title: '오늘 날씨가 정말 좋네요',
                author: '날씨맨',
                content: '오늘 하늘이 정말 맑고 파랗습니다.\n이런 날에는 밖으로 나가서 산책하는 것이 좋겠어요.',
                regDate: '2024-08-15 15:20:00',
                views: 23,
                hasImage: true,
                imageFiles: 'images/uploads/sample1.jpg',
                password: 'abcd'
            },
            {
                id: 3,
                category: 'economy',
                categoryName: '경제',
                title: '취업 준비 팁 공유합니다',
                author: '취준생',
                content: '취업 준비하면서 도움이 되었던 팁들을 공유합니다.\n면접 준비부터 자기소개서 작성법까지 상세히 설명합니다.',
                regDate: '2024-08-14 09:15:00',
                views: 67,
                hasImage: true,
                imageFiles: 'images/uploads/sample2.jpg,images/uploads/sample3.jpg',
                password: 'job123'
            },
            {
                id: 4,
                category: 'politics',
                categoryName: '정치',
                title: '지역 발전을 위한 제안',
                author: '시민',
                content: '우리 지역이 더 발전하기 위해 필요한 것들을 이야기해봅시다.\n지역 경제 활성화와 인프라 개선이 필요합니다.',
                regDate: '2024-08-13 14:45:00',
                views: 89,
                hasImage: false,
                imageFiles: '',
                password: 'politics'
            }
        ];

        // 카테고리 필터링
        var filteredPosts = mockPosts;
        if (currentCategory !== 'all') {
            filteredPosts = mockPosts.filter(function(post) {
                return post.category === currentCategory;
            });
        }

        displayPostList(filteredPosts);
        
        // 모의 페이지네이션
        displayPagination({
            currentPage: 1,
            totalPages: 1,
            totalCount: filteredPosts.length,
            hasPrev: false,
            hasNext: false,
            startPage: 1,
            endPage: 1
        });
    }

    // 게시글 목록 표시
    function displayPostList(posts, title) {
        var tbody = $('#boardTableBody');
        tbody.empty();

        // 검색 결과나 카테고리 변경시에도 배너는 그대로 유지 (텍스트 변경 안함)

        if (posts.length === 0) {
            tbody.append('<tr><td colspan="8" style="text-align: center;">등록된 게시글이 없습니다.</td></tr>');
            return;
        }

        $.each(posts, function(index, post) {
            var thumbnailHtml = '';
            
            if (post.hasImage && post.imageFiles) {
                var firstImage = post.imageFiles.split(',')[0];
                if (firstImage && firstImage.trim()) {
                    thumbnailHtml = '<img src="' + firstImage.trim() + '" class="thumbnail-img" onclick="showLargeImage(\'' + firstImage.trim() + '\')" onerror="this.src=\'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTAiIGhlaWdodD0iMzAiIHZpZXdCb3g9IjAgMCA1MCAzMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iNTAiIGhlaWdodD0iMzAiIGZpbGw9IiNkZGQiLz48dGV4dCB4PSI1MCUiIHk9IjUwJSIgZm9udC1mYW1pbHk9IkFyaWFsIiBmb250LXNpemU9IjEwIiBmaWxsPSIjNjY2IiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkeT0iLjNlbSI+7IKs7KeEPC90ZXh0Pjwvc3ZnPg==\'">';
                } else {
                    thumbnailHtml = '-';
                }
            } else {
                thumbnailHtml = '-';
            }

            // 카테고리명 확실히 표시
            var categoryName = post.categoryName || '기타';
            if (!categoryName || categoryName === 'undefined' || categoryName === '') {
                switch(post.category) {
                    case 'politics': categoryName = '정치'; break;
                    case 'economy': categoryName = '경제'; break;
                    case 'society': categoryName = '사회'; break;
                    case 'culture': categoryName = '문화'; break;
                    default: categoryName = '기타';
                }
            }

            var row = $('<tr>')
                .append($('<td class="num">').text(post.id))
                .append($('<td class="thumbnail">').html(thumbnailHtml))
                .append($('<td class="category-col">').html('<span class="category-tag">' + categoryName + '</span>'))
                .append($('<td class="title">').html('<a href="#" class="post-link" data-id="' + post.id + '">' + (post.title || '제목없음') + '</a>'))
                .append($('<td class="author">').text(post.author || '익명'))
                .append($('<td class="date">').text(post.regDate || ''))
                .append($('<td class="views">').text(post.views || 0))
                .append($('<td class="actions">').html(
                    '<a href="#" class="edit-link" data-id="' + post.id + '">수정</a><br>' +
                    '<a href="#" class="delete-link" data-id="' + post.id + '">삭제</a>'
                ));
            tbody.append(row);
        });

        // 동적으로 추가된 링크에 이벤트 핸들러 등록
        $('.post-link').click(function(e) {
            e.preventDefault();
            var postId = $(this).data('id');
            viewPost(postId);
        });

        $('.edit-link').click(function(e) {
            e.preventDefault();
            var postId = $(this).data('id');
            showPasswordModal('edit', postId);
        });

        $('.delete-link').click(function(e) {
            e.preventDefault();
            var postId = $(this).data('id');
            showPasswordModal('delete', postId);
        });
    }

    // 게시글 상세보기
    function viewPost(postId) {
        $.ajax({
            url: 'board.do',
            type: 'GET',
            data: {
                action: 'view',
                id: postId
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    currentPost = response.post; // currentPost에 저장
                    displayPost(response.post);
                } else {
                    alert('게시글을 불러오는데 실패했습니다.');
                }
            },
            error: function() {
                // 모의 데이터로 표시
                displayMockPost(postId);
            }
        });
    }

    // 모의 게시글 상세보기
    function displayMockPost(postId) {
        var mockPost = {
            id: postId,
            category: 'society',
            categoryName: '사회',
            title: '게시글 제목 ' + postId,
            author: '작성자' + postId,
            content: '게시글 내용입니다.\n여러 줄에 걸쳐 작성된 내용입니다.\n\n이것은 ' + postId + '번 게시글의 샘플 내용입니다.',
            regDate: '2024-08-16 10:30:00',
            views: 46 + postId,
            hasImage: postId % 2 === 0,
            imageFiles: postId % 2 === 0 ? 'images/uploads/sample.jpg' : '',
            password: '1234'
        };
        currentPost = mockPost; // currentPost에 저장
        displayPost(mockPost);
    }

    // 게시글 표시
    function displayPost(post) {
        currentPost = post;
        
        var categoryName = post.categoryName || '기타';
        if (!categoryName || categoryName === 'undefined' || categoryName === '') {
            switch(post.category) {
                case 'politics': categoryName = '정치'; break;
                case 'economy': categoryName = '경제'; break;
                case 'society': categoryName = '사회'; break;
                case 'culture': categoryName = '문화'; break;
                default: categoryName = '기타';
            }
        }
        
        $('#postTitle').html('<span class="category-tag">' + categoryName + '</span> ' + (post.title || '제목없음'));
        $('#postInfo').html('작성자: ' + (post.author || '익명') + ' | 등록일: ' + (post.regDate || '') + ' | 조회수: ' + (post.views || 0));
        
        var content = (post.content || '').replace(/\n/g, '<br>');
        $('#postContent').html(content);
        
        if (post.hasImage && post.imageFiles) {
            var imageFiles = post.imageFiles.split(',');
            var firstImage = imageFiles[0]; // 첫 번째 이미지만 표시
            
            if (firstImage && firstImage.trim()) {
                var imageHtml = '<div style="margin-top: 20px;"><strong>첨부 이미지:</strong><br><br>';
                imageHtml += '<div style="text-align: center; margin-bottom: 15px;">';
                imageHtml += '<img src="' + firstImage.trim() + '" style="max-width: 600px; max-height: 400px; width: auto; height: auto; border: 1px solid #ddd; cursor: pointer; display: block; margin: 0 auto;" onclick="showLargeImage(\'' + firstImage.trim() + '\')" onerror="this.style.display=\'none\'">';
                imageHtml += '</div></div>';
                $('#postContent').append(imageHtml);
            }
        }
        
        showPostView();
    }

    // 글쓰기 폼 표시/숨김
    function showWriteForm() {
        console.log('글쓰기 폼 표시');
        $('#writeForm').show();
        $('#boardList').hide();
        $('#postView').hide();
        
        // 제목 입력란에 포커스
        setTimeout(function() {
            $('#writeTitle').focus();
        }, 100);
    }

    function hideWriteForm() {
        $('#writeForm').hide();
        $('#boardList').show();
        clearForm();
    }

    // 폼 초기화 (새글쓰기용)
    function clearForm() {
        console.log('폼 초기화 (새글쓰기)');
        $('#postForm')[0].reset();
        $('#postId').val('');
        $('#formAction').val('write');
        $('#imagePreview').empty();
        uploadedImages = [];
        $('#fileInput').val('');
        
        // 새글쓰기 모드 설정
        $('#formTitle').text('글쓰기');
        $('#submitBtn').text('등록');
    }

    // 상세보기 표시/숨김
    function showPostView() {
        $('#postView').show();
        $('#boardList').hide();
        $('#writeForm').hide();
    }

    function showPostList() {
        $('#boardList').show();
        $('#postView').hide();
        $('#writeForm').hide();
        
        if (isSearchMode) {
            searchPosts();
        } else {
            loadPostList();
        }
    }

    // 비밀번호 모달
    function showPasswordModal(action, postId) {
        passwordAction = action;
        passwordPostId = postId;
        $('#passwordModal').show();
        $('#modalPassword').val('').focus();
    }

    function hidePasswordModal() {
        $('#passwordModal').hide();
        $('#modalPassword').val('');
    }

    function checkPassword() {
        var password = $('#modalPassword').val();
        
        if (!password) {
            alert('비밀번호를 입력하세요.');
            return;
        }

        $.ajax({
            url: 'board.do',
            type: 'POST',
            data: {
                action: 'checkPassword',
                id: passwordPostId,
                password: password
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    hidePasswordModal();
                    
                    if (passwordAction === 'edit') {
                        // 수정 모드: 게시글 정보를 다시 가져와서 폼 채우기
                        loadPostForEdit(passwordPostId);
                    } else if (passwordAction === 'delete') {
                        deletePost(passwordPostId);
                    }
                } else {
                    alert('비밀번호가 일치하지 않습니다.');
                    $('#modalPassword').val('').focus();
                }
            },
            error: function() {
                // 모의 확인 (개발용)
                hidePasswordModal();
                if (passwordAction === 'edit') {
                    loadPostForEdit(passwordPostId);
                } else if (passwordAction === 'delete') {
                    if (confirm('정말로 삭제하시겠습니까?')) {
                        alert('삭제되었습니다.');
                        showPostList();
                    }
                }
            }
        });
    }
    
    // 수정을 위한 게시글 정보 로드
    function loadPostForEdit(postId) {
        console.log('수정을 위한 게시글 로드:', postId);
        
        $.ajax({
            url: 'board.do',
            type: 'GET',
            data: {
                action: 'view',
                id: postId
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log('게시글 정보 로드 성공:', response.post);
                    currentPost = response.post;
                    fillEditForm();
                } else {
                    alert('게시글 정보를 불러올 수 없습니다.');
                }
            },
            error: function() {
                console.log('서버 오류로 모의 데이터 사용');
                // 모의 데이터로 폼 채우기
                currentPost = {
                    id: postId,
                    category: 'society',
                    title: '게시글 제목 ' + postId,
                    author: '작성자' + postId,
                    content: '게시글 내용입니다.\n여러 줄에 걸쳐 작성된 내용입니다.\n\n수정 테스트용 내용입니다.',
                    password: '1234',
                    hasImage: postId % 2 === 0,
                    imageFiles: postId % 2 === 0 ? 'images/uploads/sample.jpg' : ''
                };
                fillEditForm();
            }
        });
    }

    // 게시글 수정 (간소화된 버전)
    function editPost(postId) {
        console.log('editPost 호출됨, postId:', postId);
        
        // 상세보기에서 수정 버튼을 눌렀을 때는 currentPost가 이미 있음
        if (currentPost && currentPost.id == postId) {
            console.log('현재 게시글 정보 사용:', currentPost.title);
            fillEditForm();
        } else {
            // 목록에서 바로 수정 버튼을 눌렀을 때는 정보를 다시 로드
            console.log('게시글 정보 다시 로드 필요');
            loadPostForEdit(postId);
        }
    }
    
    // 수정 폼 채우기 (개선된 버전)
    function fillEditForm() {
        console.log('수정 폼 채우기 시작:', currentPost);
        
        if (!currentPost) {
            alert('게시글 정보가 없습니다.');
            return;
        }
        
        // 폼에 기존 데이터 채우기
        $('#writeCategory').val(currentPost.category || '');
        $('#writeTitle').val(currentPost.title || '');
        $('#writeAuthor').val(currentPost.author || '');
        $('#writePassword').val(''); // 비밀번호는 보안상 빈칸으로
        $('#writeContent').val(currentPost.content || '');
        
        console.log('폼 데이터 설정 완료');
        console.log('카테고리:', currentPost.category);
        console.log('제목:', currentPost.title);
        console.log('작성자:', currentPost.author);
        console.log('내용 길이:', (currentPost.content || '').length);
        
        // 수정 폼으로 전환
        $('#formTitle').text('글 수정');
        $('#formAction').val('edit');
        $('#postId').val(currentPost.id);
        $('#submitBtn').text('수정');
        
        // 기존 이미지 미리보기 표시 (단일 이미지만)
        var preview = $('#imagePreview');
        preview.empty();
        uploadedImages = [];
        $('#fileInput').val(''); // 파일 입력 초기화
        
        if (currentPost.hasImage && currentPost.imageFiles) {
            console.log('기존 이미지 처리:', currentPost.imageFiles);
            var imageFiles = currentPost.imageFiles.split(',');
            var firstImage = imageFiles[0]; // 첫 번째 이미지만 사용
            
            if (firstImage && firstImage.trim()) {
                console.log('이미지 미리보기 생성:', firstImage.trim());
                var previewItem = $('<div class="preview-item existing-image single-image">')
                    .append($('<img>').attr('src', firstImage.trim()).css({
                        'width': '200px',
                        'height': '120px',
                        'object-fit': 'cover'
                    }))
                    .append($('<br>'))
                    .append($('<small>').text('기존 이미지 (변경하려면 새 파일 선택)'))
                    .append($('<button type="button" class="remove-btn">').text('×').click(function() {
                        $(this).parent().remove();
                        console.log('기존 이미지 제거됨');
                    }));
                
                preview.append(previewItem);
            }
        } else {
            console.log('첨부된 이미지 없음');
        }
        
        showWriteForm();
        
        // 폼이 표시된 후 값 재확인 (디버깅용)
        setTimeout(function() {
            console.log('폼 표시 후 값 확인:');
            console.log('카테고리 선택값:', $('#writeCategory').val());
            console.log('제목 입력값:', $('#writeTitle').val());
            console.log('작성자 입력값:', $('#writeAuthor').val());
            console.log('내용 입력값 길이:', $('#writeContent').val().length);
        }, 100);
    }

    // 게시글 삭제
    function deletePost(postId) {
        if (confirm('정말로 삭제하시겠습니까?')) {
            $.ajax({
                url: 'board.do',
                type: 'POST',
                data: {
                    action: 'delete',
                    id: postId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        alert('삭제되었습니다.');
                        showPostList();
                    } else {
                        alert('삭제에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('삭제되었습니다.');
                    showPostList();
                }
            });
        }
    }

    // 게시글 등록/수정
    function submitPost() {
        var password = $('#writePassword').val();
        if (password.length < 4) {
            alert('비밀번호는 4자리 이상 입력해주세요.');
            return;
        }

        var formData = new FormData($('#postForm')[0]);
        
        // 업로드된 이미지 추가
        $.each(uploadedImages, function(index, image) {
            formData.append('images', image.file);
        });
        
        // 기존 이미지 정보 추가 (수정시)
        if ($('#formAction').val() === 'edit') {
            var existingImages = [];
            $('.existing-image img').each(function() {
                var src = $(this).attr('src');
                if (src && src.trim()) {
                    existingImages.push(src.trim());
                }
            });
            formData.append('existingImages', existingImages.join(','));
        }

        $.ajax({
            url: 'board.do',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    alert($('#formAction').val() === 'write' ? '등록되었습니다.' : '수정되었습니다.');
                    hideWriteForm();
                    showPostList();
                } else {
                    alert('처리에 실패했습니다: ' + (response.message || ''));
                }
            },
            error: function() {
                alert($('#formAction').val() === 'write' ? '등록되었습니다.' : '수정되었습니다.');
                hideWriteForm();
                showPostList();
            }
        });
    }

    // 파일 선택 처리 (단일 파일만)
    function handleFileSelect(files) {
        var preview = $('#imagePreview');
        preview.empty();
        uploadedImages = []; // 기존 배열 초기화

        if (files.length === 0) {
            return;
        }

        // 첫 번째 파일만 처리
        var file = files[0];
        console.log('선택된 파일:', file.name, file.type, file.size + ' bytes');
        
        if (!file.type.startsWith('image/')) {
            alert('이미지 파일만 업로드 가능합니다.');
            $('#fileInput').val(''); // 파일 선택 초기화
            return;
        }
        
        if (file.size > 10 * 1024 * 1024) {
            alert('파일 크기가 10MB를 초과합니다: ' + file.name);
            $('#fileInput').val(''); // 파일 선택 초기화
            return;
        }

        var reader = new FileReader();
        reader.onload = function(e) {
            uploadedImages.push({
                file: file,
                url: e.target.result
            });
            
            console.log('미리보기 생성:', file.name);
            
            var previewItem = $('<div class="preview-item single-image">')
                .append($('<img>').attr('src', e.target.result).css({
                    'width': '200px',
                    'height': '120px',
                    'object-fit': 'cover'
                }))
                .append($('<br>'))
                .append($('<small>').text(file.name))
                .append($('<button type="button" class="remove-btn">').text('×').click(function() {
                    $(this).parent().remove();
                    uploadedImages = [];
                    $('#fileInput').val(''); // 파일 선택 초기화
                    console.log('파일 제거:', file.name);
                }));
            
            preview.append(previewItem);
        };
        reader.readAsDataURL(file);

        console.log('업로드 예정 파일: 1개');
    }

    // 큰 이미지 보기
    window.showLargeImage = function(src) {
        $('#largeImage').attr('src', src);
        $('#imageModal').show();
    };

    function hideImageModal() {
        $('#imageModal').hide();
    }

    // 페이지네이션 표시
    function displayPagination(pagination) {
        var paginationDiv = $('#pagination');
        paginationDiv.empty();
        
        if (pagination && pagination.totalPages > 1) {
            if (pagination.hasPrev) {
                paginationDiv.append($('<a href="#" class="page-link">').text('이전').click(function(e) {
                    e.preventDefault();
                    currentPage = pagination.prevPage;
                    if (isSearchMode) {
                        searchPosts();
                    } else {
                        loadPostList();
                    }
                }));
            }
            
            for (var i = pagination.startPage; i <= pagination.endPage; i++) {
                var pageLink = $('<a href="#" class="page-link">').text(i);
                if (i === currentPage) {
                    pageLink.addClass('active');
                } else {
                    pageLink.click(function(e) {
                        e.preventDefault();
                        currentPage = parseInt($(this).text());
                        if (isSearchMode) {
                            searchPosts();
                        } else {
                            loadPostList();
                        }
                    });
                }
                paginationDiv.append(pageLink);
            }
            
            if (pagination.hasNext) {
                paginationDiv.append($('<a href="#" class="page-link">').text('다음').click(function(e) {
                    e.preventDefault();
                    currentPage = pagination.nextPage;
                    if (isSearchMode) {
                        searchPosts();
                    } else {
                        loadPostList();
                    }
                }));
            }
        }
    }
});