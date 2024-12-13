<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 목록</title>
</head>
<body>
    <h1>방명록 목록</h1>

    <!-- 작성하기 버튼 (교사, 원장만 표시) -->
    <%
        Cookie[] cookies = request.getCookies();
        String role = null;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("role".equals(cookie.getName())) {
                    role = cookie.getValue();
                }
            }
        }

        if ("1".equals(role)) { // 교사, 원장만 작성 버튼 표시
    %>
        <form action="notice.jsp" method="get" style="display:inline;">
            <button type="submit">작성하기</button>
        </form>
    <% } %>
    
     <!-- 로그아웃 버튼 -->
    <form action="logout.jsp" method="post" style="display:inline;">
        <button type="submit">로그아웃</button>
    </form>


    <table border="1" cellpadding="10">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <%
                String url = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
                String dbUser = "root";
                String dbPassword = "tiger123";

                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, dbUser, dbPassword);

                    String sql = "SELECT id, title, parent_user, created_at FROM Notices ORDER BY created_at DESC";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String title = rs.getString("title");
                        String parentUser = rs.getString("parent_user");
                        String createdAt = rs.getString("created_at");
            %>
            <tr>
                <td><%= id %></td>
                <td><a href="noticeDetail.jsp?id=<%= id %>"><%= title %></a></td>
                <td><%= (parentUser != null && !parentUser.isEmpty()) ? parentUser : "작성자 없음" %></td>
                <td><%= createdAt %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='4'>오류 발생: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                }
            %>
        </tbody>
    </table>
</body>
</html>
