<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %> <%-- jBCrypt 라이브러리 import --%>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 클라이언트가 보낸 데이터 받기
    String id = request.getParameter("id");
    String password = request.getParameter("password");
    String name = request.getParameter("name");

    // 2. 비밀번호 암호화
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    // 3. 데이터베이스 연결 정보 (자신의 정보로 수정)
    String dbURL = "jdbc:mysql://localhost:3306/your_db_name?serverTimezone=UTC";
    String dbID = "root";
    String dbPassword = "rootroot";
    
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // 4. SQL 쿼리 실행 (PreparedStatement로 SQL Injection 방어)
        String sql = "INSERT INTO members (id, password, name) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.setString(2, hashedPassword); // 암호화된 비밀번호를 저장
        pstmt.setString(3, name);
        
        pstmt.executeUpdate();

        // 5. 성공 시 로그인 페이지로 이동
        out.println("<script>alert('회원가입이 완료되었습니다. 로그인 해주세요.'); location.href='foodlogin.jsp';</script>");

    } catch (SQLIntegrityConstraintViolationException e) {
        // 아이디 중복 예외 처리
        out.println("<script>alert('이미 사용 중인 아이디입니다.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('회원가입 중 오류가 발생했습니다.'); history.back();</script>");
    } finally {
        if(pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if(conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>