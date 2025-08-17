<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판</title>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <!-- 배너 영역 -->
        <div class="banner-section">
            <img src="banner.png" alt="게시판 배너" class="banner-image" id="bannerImage" 
                 onerror="this.style.display='none'; this.parentElement.classList.add('no-image');">
        </div>
        
        <!-- 글쓰기 버튼 -->
        <div class="header">
            <button type="button" class="btn" id="btnWrite">새 글 쓰기</button>
            <button type="button" class="btn" id="btnRefresh">목록 새로고침</button>
        </div>
        
        <!-- 검색 영역 -->
        <div class="search-area">
            <input type="text" id="searchInput" placeholder="제목, 내용, 작성자로 검색..." style="width: 300px; padding: 5px;">
            <button type="button" class="btn" id="btnSearch">검색</button>
        </div>
        
        <!-- 카테고리 네비게이션 -->
        <div class="category-nav">
            <strong>카테고리:</strong>
            <a href="#" class="category-link active" data-category="all">전체</a>
            <a href="#" class="category-link" data-category="politics">정치</a>
            <a href="#" class="category-link" data-category="economy">경제</a>
            <a href="#" class="category-link" data-category="society">사회</a>
            <a href="#" class="category-link" data-category="culture">문화</a>
        </div>
        
        <!-- 게시글 목록 -->
        <div id="boardList">
            <table>
                <thead>
                    <tr>
                        <th class="num">번호</th>
                        <th class="thumbnail">사진</th>
                        <th class="category-col">분류</th>
                        <th class="title">제목</th>
                        <th class="author">작성자</th>
                        <th class="date">날짜</th>
                        <th class="views">조회</th>
                        <th class="actions">관리</th>
                    </tr>
                </thead>
                <tbody id="boardTableBody">
                    <!-- jQuery AJAX로 로드됩니다 -->
                </tbody>
            </table>
        </div>
        
        <!-- 페이징 -->
        <div class="pagination" id="pagination">
            <!-- jQuery로 생성됩니다 -->
        </div>
        
        <!-- 게시글 상세보기 -->
        <div class="view-container" id="postView">
            <div class="view-header">
                <div class="view-title" id="postTitle"></div>
                <div class="view-info" id="postInfo"></div>
            </div>
            <div class="view-content" id="postContent"></div>
            <div class="view-footer">
                <button type="button" class="btn" id="btnList">목록으로</button>
                <button type="button" class="btn" id="btnEdit">수정</button>
                <button type="button" class="btn" id="btnDelete">삭제</button>
            </div>
        </div>
        
        <!-- 글쓰기 폼 -->
        <div class="form-container" id="writeForm">
            <h2 id="formTitle">글쓰기</h2>
            <form id="postForm" enctype="multipart/form-data">
                <input type="hidden" id="postId" name="id">
                <input type="hidden" id="formAction" name="action" value="write">
                
                <table class="form-table">
                    <tr>
                        <th>카테고리</th>
                        <td>
                            <select name="category" id="writeCategory" required>
                                <option value="">선택하세요</option>
                                <option value="politics">정치</option>
                                <option value="economy">경제</option>
                                <option value="society">사회</option>
                                <option value="culture">문화</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>제목</th>
                        <td><input type="text" name="title" id="writeTitle" size="50" required></td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td><input type="text" name="author" id="writeAuthor" size="20" required></td>
                    </tr>
                    <tr>
                        <th>비밀번호</th>
                        <td>
                            <input type="password" name="password" id="writePassword" size="20" required>
                            <small>(수정/삭제용, 4자리 이상)</small>
                        </td>
                    </tr>
                    <tr>
                        <th>내용</th>
                        <td><textarea name="content" id="writeContent" required></textarea></td>
                    </tr>
                    <tr>
                        <th>사진첨부</th>
                        <td>
                            <input type="file" name="images" id="fileInput" accept="image/*">
                            <small>이미지 파일 1개만 업로드 가능 (최대 10MB)</small>
                            <div id="imagePreview" class="image-preview"></div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <button type="submit" class="btn" id="submitBtn">등록</button>
                            <button type="button" class="btn" id="cancelBtn">취소</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
    
    <!-- 비밀번호 확인 모달 -->
    <div class="modal" id="passwordModal">
        <div class="modal-content">
            <div class="modal-header">비밀번호 확인</div>
            <form id="passwordForm">
                <table style="width: 100%;">
                    <tr>
                        <th style="width: 100px;">비밀번호</th>
                        <td><input type="password" id="modalPassword" style="width: 100%;" required></td>
                    </tr>
                </table>
                <div class="modal-footer">
                    <button type="submit" class="btn">확인</button>
                    <button type="button" class="btn" id="passwordCancel">취소</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- 이미지 확대 모달 -->
    <div class="modal" id="imageModal">
        <div class="modal-content" style="width: 80%; max-width: 800px;">
            <div class="modal-header">이미지 보기</div>
            <div style="text-align: center;">
                <img id="largeImage" style="max-width: 100%; max-height: 500px;">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn" id="imageClose">닫기</button>
            </div>
        </div>
    </div>

    <script src="js/board.js"></script>
</body>
</html>