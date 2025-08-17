<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. 세션에서 현재 로그인한 사용자 ID 가져오기
    String memberId = (String) session.getAttribute("userId");

    // 2. 로그인이 안된 경우, 로그인 페이지로 보내기
    if (memberId == null) {
        response.sendRedirect("/loginfood/foodlogin.jsp");
        return; // 아래 코드 실행 방지
    }

    // 3. 지도에서 보낸 식당 ID 받기
    String restaurantId = request.getParameter("restaurantId");

    // DB 연결 정보
    String dbURL = "jdbc:mysql://localhost:3306/your_db_name?serverTimezone=UTC";
    String dbID = "your_db_id";
    String dbPassword = "your_db_password";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        
        // 4. 이미 즐겨찾기에 추가했는지 확인 (중복 방지)
        String checkSql = "SELECT * FROM favorites WHERE member_id = ? AND restaurant_id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, memberId);
        pstmt.setString(2, restaurantId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 이미 즐겨찾기에 있는 경우
            out.println("<script>alert('이미 즐겨찾기에 추가된 맛집입니다.'); history.back();</script>");
        } else {
            // 5. 즐겨찾기에 없는 경우, DB에 INSERT
            pstmt.close(); // 이전 pstmt 닫기
            String insertSql = "INSERT INTO favorites (member_id, restaurant_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, memberId);
            pstmt.setString(2, restaurantId);
            pstmt.executeUpdate();
            
            out.println("<script>alert('즐겨찾기에 추가되었습니다!'); history.back();</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('처리 중 오류가 발생했습니다.'); history.back();</script>");
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException ex) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if(conn != null) try { conn.close(); } catch(SQLException ex) {}
    }
%>