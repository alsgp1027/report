<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
	request.setCharacterEncoding("UTF-8");
    String noticeId = request.getParameter("notice_id");
    String content = request.getParameter("content");

    // 쿠키에서 사용자 정보 가져오기
    Cookie[] cookies = request.getCookies();
    String username = null;
    String role = null;

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("username".equals(cookie.getName())) {
                username = cookie.getValue();
            }
            if ("role".equals(cookie.getName())) {
                role = cookie.getValue();
            }
        }
    }

    String url = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "tiger123";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        String sql = "INSERT INTO Comments (notice_id, user, role, content) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, noticeId);
        pstmt.setString(2, username);
        pstmt.setString(3, role);
        pstmt.setString(4, content);
        pstmt.executeUpdate();

        response.sendRedirect("noticeDetail.jsp?id=" + noticeId);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
