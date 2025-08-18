package com.food;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.annotation.Resource;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.sql.DataSource;

/**
 * 즐겨찾기 추가 서블릿
 * 원래 JSP(스크립틀릿) 로직을 서블릿으로 이전.
 * - 세션에서 userId 확인
 * - restaurantId 파라미터 확인
 * - favorites 중복 체크 후 INSERT
 * - 결과는 alert + history.back()
 */
@WebServlet("/favorites/add")
public class FavoriteAddServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // JNDI로 DataSource 주입 (Tomcat context.xml에 name="jdbc/FromJ" 설정 필요)
    @Resource(name = "jdbc/FromJ")
    private DataSource injectedDs;

    // 주입 실패 대비용 루ック업
    private DataSource lookupDs() throws NamingException {
        InitialContext ic = new InitialContext();
        return (DataSource) ic.lookup("java:comp/env/jdbc/FromJ");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 원래 페이지가 GET을 쓰고 있었으면 GET도 처리
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        final PrintWriter out = response.getWriter();

        // 1) 로그인 사용자 확인
        HttpSession session = request.getSession(false);
        String memberId = (session != null) ? (String) session.getAttribute("userId") : null;

        if (memberId == null || memberId.trim().isEmpty()) {
            // 컨텍스트 경로 고려하여 로그인 페이지로 리다이렉트
            String loginPath = request.getContextPath() + "/loginfood/foodlogin.jsp";
            response.sendRedirect(loginPath);
            return;
        }

        // 2) 식당 ID 파라미터 확인
        String restaurantId = request.getParameter("restaurantId");
        if (restaurantId == null || restaurantId.trim().isEmpty()) {
            out.println("<script>alert('식당 정보가 없습니다.'); history.back();</script>");
            return;
        }

        // 3) DataSource 준비
        DataSource ds = injectedDs;
        if (ds == null) {
            try {
                ds = lookupDs();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>alert('DB 연결 설정 오류입니다.'); history.back();</script>");
                return;
            }
        }

        // 4) 중복 체크 후 INSERT
        String checkSql  = "SELECT 1 FROM favorites WHERE member_id = ? AND restaurant_id = ? LIMIT 1";
        String insertSql = "INSERT INTO favorites (member_id, restaurant_id) VALUES (?, ?)";

        try (
            Connection conn = ds.getConnection();
            PreparedStatement chk = conn.prepareStatement(checkSql)
        ) {
            // 중복 확인
            chk.setString(1, memberId);
            chk.setString(2, restaurantId);
            try (ResultSet rs = chk.executeQuery()) {
                if (rs.next()) {
                    out.println("<script>alert('이미 즐겨찾기에 추가된 맛집입니다.'); history.back();</script>");
                    return;
                }
            }

            // INSERT
            try (PreparedStatement ins = conn.prepareStatement(insertSql)) {
                ins.setString(1, memberId);
                ins.setString(2, restaurantId);
                ins.executeUpdate();
            }

            out.println("<script>alert('즐겨찾기에 추가되었습니다!'); history.back();</script>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('처리 중 오류가 발생했습니다.'); history.back();</script>");
        }
    }
}
