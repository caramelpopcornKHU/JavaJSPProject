<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 클라이언트가 보낸 데이터 받기
    String id = request.getParameter("id");
    String password = request.getParameter("password");

    // 2. DB 연결 정보
    String dbURL = "jdbc:mysql://localhost:3306/your_db_name?serverTimezone=UTC";
    String dbID = "root";
    String dbPassword = "rootroot";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // 3. 아이디를 기준으로 DB에서 사용자 정보 조회
        String sql = "SELECT password FROM members WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 4. 아이디가 존재할 경우, 암호화된 비밀번호를 가져옴
            String dbHashedPassword = rs.getString("password");

            // 5. 입력된 비밀번호와 DB의 암호화된 비밀번호를 비교
            if (BCrypt.checkpw(password, dbHashedPassword)) {
                // 비밀번호 일치 -> 로그인 성공
                // 세션에 로그인 정보 기록
                session.setAttribute("userId", id);
                
                // 메인 페이지로 이동 (프로젝트 구조에 맞게 경로 수정 필요)
                response.sendRedirect("../index.jsp"); 
            } else {
                // 비밀번호 불일치
                response.sendRedirect("foodlogin.jsp?error=1");
            }
        } else {
            // 아이디 존재하지 않음
            response.sendRedirect("foodlogin.jsp?error=1");
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("foodlogin.jsp?error=1");
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException ex) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if(conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>