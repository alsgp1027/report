<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.*" %>
<%
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("role".equals(cookie.getName()) || "username".equals(cookie.getName())) {
                Cookie deleteCookie = new Cookie(cookie.getName(), null);
                deleteCookie.setMaxAge(0);
                response.addCookie(deleteCookie);
            }
        }
    }
    response.sendRedirect("login.jsp"); // 로그인 페이지로 이동
%>