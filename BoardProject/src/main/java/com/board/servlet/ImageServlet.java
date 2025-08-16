package com.board.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/images/*")  // 이 어노테이션이 web.xml 대신 역할함
public class ImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // URL에서 파일 경로 추출
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // uploads/파일명 형태로 경로 정리
        String fileName = pathInfo.substring(1); // 맨 앞의 / 제거
        if (!fileName.startsWith("uploads/")) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // 실제 파일 경로
        String realPath = getServletContext().getRealPath("/images/" + fileName);
        File file = new File(realPath);
        
        System.out.println("요청된 이미지: " + fileName);
        System.out.println("실제 파일 경로: " + realPath);
        System.out.println("파일 존재 여부: " + file.exists());
        
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // 파일 확장자에 따른 Content-Type 설정
        String contentType = getContentType(fileName);
        response.setContentType(contentType);
        
        // 캐시 설정
        response.setHeader("Cache-Control", "public, max-age=3600");
        response.setDateHeader("Expires", System.currentTimeMillis() + 3600000);
        
        // 파일 내용을 응답으로 전송
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
    
    private String getContentType(String fileName) {
        String extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        switch (extension) {
            case "jpg":
            case "jpeg":
                return "image/jpeg";
            case "png":
                return "image/png";
            case "gif":
                return "image/gif";
            case "webp":
                return "image/webp";
            default:
                return "application/octet-stream";
        }
    }
}