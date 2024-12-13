<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String commentId = request.getParameter("comment_id");
    String noticeId = request.getParameter("notice_id");

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
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // 댓글 작성자 확인
        String sql = "SELECT user FROM Comments WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, commentId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String commentUser = rs.getString("user");

            if (username.equals(commentUser) || "1".equals(role)) { // 본인 또는 교사/원장만 삭제 가능
                sql = "DELETE FROM Comments WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, commentId);
                pstmt.executeUpdate();
            }
        }

        response.sendRedirect("noticeDetail.jsp?id=" + noticeId);
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
