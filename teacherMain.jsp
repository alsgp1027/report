<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.servlet.http.*" %>
<%
    // 쿠키에서 role 값 읽기
    Cookie[] cookies = request.getCookies();
    String role = null;
    String username = null;

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("role".equals(cookie.getName())) {
                role = cookie.getValue();
            }
            if ("username".equals(cookie.getName())) {
                username = cookie.getValue();
            }
        }
    }

    // 권한 확인 (교사/원장만 접근 가능)
    if (role == null || !"1".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>교사/원장 메인 페이지</title>
</head>
<body>
    <h1>안녕하세요, <%= username %>님!</h1>
    <button onclick="location.href='notice.jsp'">알림장 작성</button>
    <button onclick="location.href='noticeList.jsp'">작성된 알림장 리스트 보기</button>
</body>
</html>
