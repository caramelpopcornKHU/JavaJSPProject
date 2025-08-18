package com.board.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.board.dao.BoardDAO;
import com.board.vo.BoardVO;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

@WebServlet("*.do")
@MultipartConfig(
    maxFileSize = 10485760,      // 10MB
    maxRequestSize = 52428800,   // 50MB
    fileSizeThreshold = 1048576  // 1MB
)
public class BoardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BoardDAO boardDAO;
    private Gson gson;
    
    @Override
    public void init() throws ServletException {
        super.init();
        boardDAO = new BoardDAO();
        gson = new Gson();
        
        // 프로젝트 소스 폴더에 직접 이미지 저장
        String projectPath = getServletContext().getRealPath("/");
        String uploadPath = projectPath + "images" + File.separator + "uploads" + File.separator;
        
        System.out.println("프로젝트 경로: " + projectPath);
        System.out.println("업로드 경로: " + uploadPath);
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("폴더 생성 결과: " + created);
            System.out.println("폴더 절대 경로: " + uploadDir.getAbsolutePath());
        }
        
        // 실제 소스 폴더에도 생성 (개발용)
        try {
            String sourcePath = System.getProperty("user.dir") + File.separator + 
                               "src" + File.separator + "main" + File.separator + 
                               "webapp" + File.separator + "images" + File.separator + "uploads";
            File sourceDir = new File(sourcePath);
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
                System.out.println("소스 폴더에도 생성: " + sourcePath);
            }
        } catch (Exception e) {
            System.out.println("소스 폴더 생성 실패: " + e.getMessage());
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        String command = requestURI.substring(contextPath.length());
        
        String action = request.getParameter("action");
        
        try {
            if ("/board.do".equals(command)) {
                if ("list".equals(action)) {
                    handleList(request, response);
                } else if ("view".equals(action)) {
                    handleView(request, response);
                } else if ("write".equals(action)) {
                    handleWrite(request, response);
                } else if ("edit".equals(action)) {
                    handleEdit(request, response);
                } else if ("delete".equals(action)) {
                    handleDelete(request, response);
                } else if ("checkPassword".equals(action)) {
                    handleCheckPassword(request, response);
                } else if ("search".equals(action)) {
                    handleSearch(request, response);
                } else {
                    // 기본적으로 index.jsp로 포워딩
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/ESJ.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                RequestDispatcher dispatcher = request.getRequestDispatcher("/ESJ.jsp");
                dispatcher.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String category = request.getParameter("category");
        String pageStr = request.getParameter("page");
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int pageSize = 10;
        int offset = (page - 1) * pageSize;
        
        List<BoardVO> posts = boardDAO.selectList(category, offset, pageSize);
        int totalCount = boardDAO.getTotalCount(category);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        // JSON 배열로 변환하면서 추가 정보 포함
        JsonArray postsArray = new JsonArray();
        for (BoardVO post : posts) {
            JsonObject postObj = new JsonObject();
            postObj.addProperty("id", post.getId());
            postObj.addProperty("category", post.getCategory() != null ? post.getCategory() : "");
            postObj.addProperty("categoryName", post.getCategoryName());
            postObj.addProperty("title", post.getTitle() != null ? post.getTitle() : "");
            postObj.addProperty("author", post.getAuthor() != null ? post.getAuthor() : "");
            postObj.addProperty("content", post.getContent() != null ? post.getContent() : "");
            postObj.addProperty("regDate", post.getFormattedDate());
            postObj.addProperty("views", post.getViews());
            postObj.addProperty("hasImage", post.getHasImage());
            postObj.addProperty("imageFiles", post.getImageFiles() != null ? post.getImageFiles() : "");
            postsArray.add(postObj);
        }
        
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.add("posts", postsArray);
        
        JsonObject pagination = new JsonObject();
        pagination.addProperty("currentPage", page);
        pagination.addProperty("totalPages", totalPages);
        pagination.addProperty("totalCount", totalCount);
        pagination.addProperty("hasPrev", page > 1);
        pagination.addProperty("hasNext", page < totalPages);
        pagination.addProperty("prevPage", page - 1);
        pagination.addProperty("nextPage", page + 1);
        pagination.addProperty("startPage", Math.max(1, page - 2));
        pagination.addProperty("endPage", Math.min(totalPages, page + 2));
        
        result.add("pagination", pagination);
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
    }
    
    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idStr = request.getParameter("id");
        
        try {
            int id = Integer.parseInt(idStr);
            boardDAO.updateViews(id);
            BoardVO post = boardDAO.selectOne(id);
            
            JsonObject result = new JsonObject();
            if (post != null) {
                result.addProperty("success", true);
                
                JsonObject postObj = new JsonObject();
                postObj.addProperty("id", post.getId());
                postObj.addProperty("category", post.getCategory() != null ? post.getCategory() : "");
                postObj.addProperty("categoryName", post.getCategoryName());
                postObj.addProperty("title", post.getTitle() != null ? post.getTitle() : "");
                postObj.addProperty("author", post.getAuthor() != null ? post.getAuthor() : "");
                postObj.addProperty("content", post.getContent() != null ? post.getContent() : "");
                postObj.addProperty("regDate", post.getFormattedDate());
                postObj.addProperty("views", post.getViews());
                postObj.addProperty("hasImage", post.getHasImage());
                postObj.addProperty("imageFiles", post.getImageFiles() != null ? post.getImageFiles() : "");
                postObj.addProperty("password", post.getPassword() != null ? post.getPassword() : "");
                
                result.add("post", postObj);
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "게시글을 찾을 수 없습니다.");
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            
        } catch (NumberFormatException e) {
            JsonObject result = new JsonObject();
            result.addProperty("success", false);
            result.addProperty("message", "잘못된 게시글 번호입니다.");
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
        }
    }
    
    private void handleWrite(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        String category = request.getParameter("category");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String password = request.getParameter("password");
        String content = request.getParameter("content");
        
        // 파일 업로드 처리
        List<String> imageFiles = processFileUpload(request);
        
        BoardVO board = new BoardVO();
        board.setCategory(category);
        board.setTitle(title);
        board.setAuthor(author);
        board.setPassword(password);
        board.setContent(content);
        board.setImageFiles(String.join(",", imageFiles));
        
        int result = boardDAO.insert(board);
        
        JsonObject jsonResult = new JsonObject();
        if (result > 0) {
            jsonResult.addProperty("success", true);
            jsonResult.addProperty("message", "게시글이 등록되었습니다.");
        } else {
            jsonResult.addProperty("success", false);
            jsonResult.addProperty("message", "게시글 등록에 실패했습니다.");
        }
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(jsonResult));
    }
    
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        String idStr = request.getParameter("id");
        String category = request.getParameter("category");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String password = request.getParameter("password");
        String content = request.getParameter("content");
        String existingImages = request.getParameter("existingImages");
        
        try {
            int id = Integer.parseInt(idStr);
            
            // 기존 게시글 가져오기
            BoardVO existingPost = boardDAO.selectOne(id);
            if (existingPost == null) {
                JsonObject jsonResult = new JsonObject();
                jsonResult.addProperty("success", false);
                jsonResult.addProperty("message", "게시글을 찾을 수 없습니다.");
                
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print(gson.toJson(jsonResult));
                return;
            }
            
            // 새 파일 업로드 처리
            List<String> newImageFiles = processFileUpload(request);
            
            // 최종 이미지 파일 목록 생성
            String finalImageFiles = "";
            
            // 기존 이미지 추가
            if (existingImages != null && !existingImages.trim().isEmpty()) {
                finalImageFiles = existingImages;
            }
            
            // 새로운 이미지가 있으면 추가
            if (!newImageFiles.isEmpty()) {
                if (!finalImageFiles.isEmpty()) {
                    finalImageFiles += "," + String.join(",", newImageFiles);
                } else {
                    finalImageFiles = String.join(",", newImageFiles);
                }
            }
            
            BoardVO board = new BoardVO();
            board.setId(id);
            board.setCategory(category);
            board.setTitle(title);
            board.setAuthor(author);
            board.setPassword(password);
            board.setContent(content);
            board.setImageFiles(finalImageFiles);
            
            int result = boardDAO.updateWithImages(board);
            
            JsonObject jsonResult = new JsonObject();
            if (result > 0) {
                jsonResult.addProperty("success", true);
                jsonResult.addProperty("message", "게시글이 수정되었습니다.");
            } else {
                jsonResult.addProperty("success", false);
                jsonResult.addProperty("message", "게시글 수정에 실패했습니다.");
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(jsonResult));
            
        } catch (NumberFormatException e) {
            JsonObject jsonResult = new JsonObject();
            jsonResult.addProperty("success", false);
            jsonResult.addProperty("message", "잘못된 게시글 번호입니다.");
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(jsonResult));
        }
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idStr = request.getParameter("id");
        
        try {
            int id = Integer.parseInt(idStr);
            
            // 기존 이미지 파일들 삭제
            BoardVO post = boardDAO.selectOne(id);
            if (post != null && post.getImageFiles() != null && !post.getImageFiles().isEmpty()) {
                String[] files = post.getImageFiles().split(",");
                String uploadPath = getServletContext().getRealPath("/images/uploads/");
                for (String fileName : files) {
                    if (fileName != null && !fileName.trim().isEmpty()) {
                        // 상대 경로에서 파일명만 추출
                        String actualFileName = fileName.trim();
                        if (actualFileName.startsWith("images/uploads/")) {
                            actualFileName = actualFileName.substring("images/uploads/".length());
                        }
                        File file = new File(uploadPath + actualFileName);
                        if (file.exists()) {
                            boolean deleted = file.delete();
                            System.out.println("파일 삭제: " + file.getAbsolutePath() + " - " + deleted);
                        }
                    }
                }
            }
            
            int result = boardDAO.delete(id);
            
            JsonObject jsonResult = new JsonObject();
            if (result > 0) {
                jsonResult.addProperty("success", true);
                jsonResult.addProperty("message", "게시글이 삭제되었습니다.");
            } else {
                jsonResult.addProperty("success", false);
                jsonResult.addProperty("message", "게시글 삭제에 실패했습니다.");
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(jsonResult));
            
        } catch (NumberFormatException e) {
            JsonObject jsonResult = new JsonObject();
            jsonResult.addProperty("success", false);
            jsonResult.addProperty("message", "잘못된 게시글 번호입니다.");
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(jsonResult));
        }
    }
    
    private void handleCheckPassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String idStr = request.getParameter("id");
        String password = request.getParameter("password");
        
        try {
            int id = Integer.parseInt(idStr);
            BoardVO post = boardDAO.selectOne(id);
            
            JsonObject result = new JsonObject();
            if (post != null && post.getPassword() != null && post.getPassword().equals(password)) {
                result.addProperty("success", true);
                result.addProperty("message", "비밀번호가 일치합니다.");
            } else {
                result.addProperty("success", false);
                result.addProperty("message", "비밀번호가 일치하지 않습니다.");
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
            
        } catch (NumberFormatException e) {
            JsonObject result = new JsonObject();
            result.addProperty("success", false);
            result.addProperty("message", "잘못된 게시글 번호입니다.");
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(gson.toJson(result));
        }
    }
    
    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String pageStr = request.getParameter("page");
        
        if (keyword == null || keyword.trim().isEmpty()) {
            // 검색어가 없으면 일반 목록 처리
            handleList(request, response);
            return;
        }
        
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        int pageSize = 10;
        int offset = (page - 1) * pageSize;
        
        List<BoardVO> posts = boardDAO.searchPosts(keyword, category, offset, pageSize);
        int totalCount = boardDAO.getSearchCount(keyword, category);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        
        JsonArray postsArray = new JsonArray();
        for (BoardVO post : posts) {
            JsonObject postObj = new JsonObject();
            postObj.addProperty("id", post.getId());
            postObj.addProperty("category", post.getCategory() != null ? post.getCategory() : "");
            postObj.addProperty("categoryName", post.getCategoryName());
            postObj.addProperty("title", post.getTitle() != null ? post.getTitle() : "");
            postObj.addProperty("author", post.getAuthor() != null ? post.getAuthor() : "");
            postObj.addProperty("content", post.getContent() != null ? post.getContent() : "");
            postObj.addProperty("regDate", post.getFormattedDate());
            postObj.addProperty("views", post.getViews());
            postObj.addProperty("hasImage", post.getHasImage());
            postObj.addProperty("imageFiles", post.getImageFiles() != null ? post.getImageFiles() : "");
            postsArray.add(postObj);
        }
        
        JsonObject result = new JsonObject();
        result.addProperty("success", true);
        result.add("posts", postsArray);
        result.addProperty("keyword", keyword);
        
        JsonObject pagination = new JsonObject();
        pagination.addProperty("currentPage", page);
        pagination.addProperty("totalPages", totalPages);
        pagination.addProperty("totalCount", totalCount);
        pagination.addProperty("hasPrev", page > 1);
        pagination.addProperty("hasNext", page < totalPages);
        pagination.addProperty("prevPage", page - 1);
        pagination.addProperty("nextPage", page + 1);
        pagination.addProperty("startPage", Math.max(1, page - 2));
        pagination.addProperty("endPage", Math.min(totalPages, page + 2));
        
        result.add("pagination", pagination);
        
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
    }
    
    private List<String> processFileUpload(HttpServletRequest request) 
            throws IOException, ServletException {
        List<String> uploadedFiles = new ArrayList<>();
        
        String projectPath = getServletContext().getRealPath("/");
        String uploadPath = projectPath + "images" + File.separator + "uploads" + File.separator;
        
        System.out.println("파일 업로드 시작");
        System.out.println("업로드 경로: " + uploadPath);
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            System.out.println("업로드 중 폴더 생성: " + created);
        }
        
        try {
            Collection<Part> parts = request.getParts();
            System.out.println("전체 Part 개수: " + parts.size());
            
            for (Part part : parts) {
                System.out.println("Part 이름: " + part.getName() + ", 크기: " + part.getSize());
                
                // images 이름의 Part만 처리하고, 크기가 0보다 큰 것만
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = extractFileName(part);
                    System.out.println("처리할 파일: " + fileName + " (크기: " + part.getSize() + " bytes)");
                    
                    if (fileName != null && !fileName.trim().isEmpty()) {
                        // 파일 확장자 검증
                        String lowerFileName = fileName.toLowerCase();
                        if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg") || 
                            lowerFileName.endsWith(".png") || lowerFileName.endsWith(".gif") ||
                            lowerFileName.endsWith(".webp")) {
                            
                            String uniqueFileName = generateUniqueFileName(fileName);
                            String fullPath = uploadPath + uniqueFileName;
                            
                            System.out.println("저장할 파일명: " + uniqueFileName);
                            System.out.println("저장할 전체 경로: " + fullPath);
                            
                            // 중복 확인
                            String relativePath = "images/uploads/" + uniqueFileName;
                            if (uploadedFiles.contains(relativePath)) {
                                System.out.println("중복 파일 건너뜀: " + relativePath);
                                continue;
                            }
                            
                            // 파일 저장 시도
                            try {
                                part.write(fullPath);
                                System.out.println("part.write() 완료");
                                
                                // 파일이 실제로 저장되었는지 확인
                                File savedFile = new File(fullPath);
                                if (savedFile.exists() && savedFile.length() > 0) {
                                    System.out.println("✓ 파일 저장 성공!");
                                    System.out.println("  - 저장된 크기: " + savedFile.length() + " bytes");
                                    uploadedFiles.add(relativePath);
                                    
                                    // 소스 폴더에도 복사 (개발용)
                                    copyToSourceFolder(savedFile, uniqueFileName);
                                    
                                } else {
                                    System.err.println("✗ 파일 저장 실패 또는 빈 파일: " + fullPath);
                                }
                            } catch (Exception writeEx) {
                                System.err.println("파일 쓰기 오류: " + writeEx.getMessage());
                                writeEx.printStackTrace();
                            }
                        } else {
                            System.err.println("지원하지 않는 파일 형식: " + fileName);
                        }
                    } else {
                        System.out.println("파일명이 비어있음");
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("파일 업로드 처리 중 오류: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("최종 업로드된 파일 목록 (" + uploadedFiles.size() + "개): " + uploadedFiles);
        return uploadedFiles;
    }
    
    // 소스 폴더에도 파일 복사 (개발용)
    private void copyToSourceFolder(File sourceFile, String fileName) {
        try {
            String sourceFolderPath = System.getProperty("user.dir") + File.separator + 
                                     "src" + File.separator + "main" + File.separator + 
                                     "webapp" + File.separator + "images" + File.separator + "uploads";
            
            File sourceFolder = new File(sourceFolderPath);
            if (!sourceFolder.exists()) {
                sourceFolder.mkdirs();
            }
            
            File destFile = new File(sourceFolder, fileName);
            java.nio.file.Files.copy(sourceFile.toPath(), destFile.toPath(), 
                                   java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            
            System.out.println("소스 폴더에도 복사 완료: " + destFile.getAbsolutePath());
        } catch (Exception e) {
            System.out.println("소스 폴더 복사 실패: " + e.getMessage());
        }
    }
    
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }
    
    private String generateUniqueFileName(String originalFileName) {
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = originalFileName.substring(dotIndex);
            originalFileName = originalFileName.substring(0, dotIndex);
        }
        
        // 파일명 정리 (한글, 특수문자 처리)
        String cleanFileName = originalFileName.replaceAll("[^a-zA-Z0-9]", "_");
        if (cleanFileName.length() > 20) {
            cleanFileName = cleanFileName.substring(0, 20);
        }
        
        return cleanFileName + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + extension;
    }
}