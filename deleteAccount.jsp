<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    Cookie[] cookies = request.getCookies();
    String username = null;

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("username".equals(cookie.getName())) {
                username = cookie.getValue();
                break;
            }
        }
    }

    if (username == null) {
        out.println("<h1>로그인이 필요합니다.</h1>");
        out.println("<a href='login.jsp'>로그인 하러 가기</a>");
        return;
    }

    String url = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "tiger123"; // 비밀번호가 없으면 공백으로 둡니다.

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        String sql = "DELETE FROM Users WHERE username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);

        int rows = pstmt.executeUpdate();

        if (rows > 0) {
            out.println("<h1>회원탈퇴가 완료되었습니다.</h1>");
            out.println("<a href='login.jsp'>메인 페이지로 가기</a>");
        } else {
            out.println("<h1>회원탈퇴 실패</h1>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h1>오류 발생: " + e.getMessage() + "</h1>");
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
