<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%
    // 현재 로그인된 사용자 정보 확인
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

    // DB에서 사용자 정보 가져오기
    String url = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "tiger123";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String password = "";
    String role = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        String sql = "SELECT password, role FROM Users WHERE username = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            password = rs.getString("password");
            role = rs.getString("role");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h1>오류 발생: " + e.getMessage() + "</h1>");
        return;
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
</head>
<body>
    <h1>회원정보 수정</h1>
    <form action="updateAccountProcess.jsp" method="post">
        <label for="username">아이디:</label><br>
        <input type="text" id="username" name="username" value="<%= username %>" readonly><br><br>

        <label for="password">비밀번호:</label><br>
        <input type="password" id="password" name="password" value="<%= password %>" required><br><br>

        <label for="role">권한:</label><br>
        <select id="role" name="role" required>
            <option value="1" <%= "1".equals(role) ? "selected" : "" %>>교사</option>
            <option value="2" <%= "2".equals(role) ? "selected" : "" %>>학부모</option>
            <option value="3" <%= "3".equals(role) ? "selected" : "" %>>원장</option>
        </select><br><br>

        <button type="submit">수정</button>
    </form>
</body>
</html>
