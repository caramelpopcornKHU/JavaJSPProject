<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 세션을 무효화시킵니다.
    session.invalidate();

    // 메인 페이지로 리다이렉트합니다.
    response.sendRedirect("../index.jsp");
%>