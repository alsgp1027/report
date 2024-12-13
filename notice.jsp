<%@ page import="java.sql.*, javax.servlet.http.*, java.io.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // DB에서 학부모 목록 가져오기
    String url = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "tiger123";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        String sql = "SELECT username FROM Users WHERE role = '2'"; // 학부모(role=2) 목록 가져오기
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>알림장 작성</title>
</head>
<body>
    <h1>방명록 작성</h1>
    <form action="saveNotice.jsp" method="post" enctype="multipart/form-data">
        <label for="title">제목:</label><br>
        <input type="text" id="title" name="title" required><br><br>

        <label for="content">내용:</label><br>
        <textarea id="content" name="content" rows="10" cols="30" required></textarea><br><br>

        <label for="parent_user">학부모 지정 (선택 사항):</label><br>
        <select id="parent_user" name="parent_user">
            <option value="">전체 학부모</option>
            <% while (rs.next()) { %>
                <option value="<%= rs.getString("username") %>"><%= rs.getString("username") %></option>
            <% } %>
        </select><br><br>

        <label for="file">파일 업로드 (선택 사항):</label><br>
        <input type="file" id="file" name="file"><br><br>

        <button type="submit">작성하기</button>
    </form>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
