<%@ page import="java.sql.*, javax.servlet.http.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    // 한글 인코딩 처리
    request.setCharacterEncoding("UTF-8");

    // 요청 파라미터와 사용자 정보 가져오기
    String noticeId = request.getParameter("id"); // 게시물 ID

    Cookie[] cookies = request.getCookies();
    String currentUser = null;
    String currentRole = null;

    // 쿠키에서 사용자 정보 추출
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("username".equals(cookie.getName())) {
                currentUser = cookie.getValue();
            }
            if ("role".equals(cookie.getName())) {
                currentRole = cookie.getValue(); // 1: 교사/원장, 2: 학부모
            }
        } 
    }

    // DB 연결 정보
    String url = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "tiger123";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // 게시물 정보 가져오기
        String sql = "SELECT title, content, created_at, parent_user, file_path FROM Notices WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, noticeId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            String title = rs.getString("title");
            String content = rs.getString("content");
            String createdAt = rs.getString("created_at");
            String parentUser = rs.getString("parent_user");
            String filePath = rs.getString("file_path");

            // 파일 확장자 확인
            String fileExtension = "";
            if (filePath != null && !filePath.isEmpty()) {
                fileExtension = filePath.substring(filePath.lastIndexOf(".") + 1).toLowerCase();
            }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시물 상세보기</title>
</head>
<body>
    <h1><%= title %></h1>
    <p><strong>내용:</strong> <%= content %></p>
    <p><strong>작성일:</strong> <%= createdAt %></p>

    <!-- 첨부파일 표시 -->
    <% if (filePath != null && !filePath.isEmpty()) { %>
        <% if ("jpg".equals(fileExtension) || "jpeg".equals(fileExtension) || "png".equals(fileExtension) || "gif".equals(fileExtension)) { %>
            <p><strong>첨부 이미지:</strong></p>
            <img src="<%= request.getContextPath() + "/uploads/" + new java.io.File(filePath).getName() %>" alt="첨부 이미지" style="max-width: 500px; max-height: 500px;">
        <% } else { %>
            <p><strong>첨부파일:</strong> 
                <a href="<%= request.getContextPath() + "/uploads/" + new java.io.File(filePath).getName() %>" target="_blank">파일 다운로드</a>
            </p>
        <% } %>
    <% } else { %>
        <p><strong>첨부파일:</strong> 없음</p>
    <% } %>

    <!-- 수정 및 삭제 버튼: 교사/원장 권한일 경우에만 표시 -->
    <% if ("1".equals(currentRole)) { %>
        <!-- 수정 버튼 -->
        <form action="editNotice.jsp" method="get">
            <input type="hidden" name="id" value="<%= noticeId %>">
            <button type="submit">수정</button>
        </form>

        <!-- 삭제 버튼 -->
        <form action="deleteNotice.jsp" method="post">
            <input type="hidden" name="id" value="<%= noticeId %>">
            <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
        </form>
    <% } %>

    <!-- 댓글 작성 -->
    <h2>댓글 작성</h2>
    <form action="addComment.jsp" method="post">
        <input type="hidden" name="notice_id" value="<%= noticeId %>">
        <textarea name="content" rows="4" cols="50" required></textarea><br>
        <button type="submit">댓글 작성</button>
    </form>

    <!-- 댓글 목록 -->
    <h2>댓글 목록</h2>
    <table border="1" cellpadding="10">
        <thead>
            <tr>
                <th>작성자</th>
                <th>댓글</th>
                <th>작성일</th>
                <th>대댓글</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <%
                // 댓글 목록 가져오기
                sql = "SELECT * FROM Comments WHERE notice_id = ? ORDER BY parent_id, created_at";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, noticeId);
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    int commentId = rs.getInt("id");
                    String commentUser = rs.getString("user"); // 댓글 작성자 이름
                    String commentContent = rs.getString("content");
                    String commentCreatedAt = rs.getString("created_at");
                    int parentId = rs.getInt("parent_id");
            %>
            <tr>
                <td><%= commentUser %></td>
                <td>
                    <% if (parentId != 0) { %>
                        &emsp;&emsp;↳ <%= commentContent %> <!-- 대댓글 들여쓰기 -->
                    <% } else { %>
                        <%= commentContent %>
                    <% } %>
                </td>
                <td><%= commentCreatedAt %></td>
                <td>
                    <!-- 대댓글 작성 -->
                    <form action="addReply.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="notice_id" value="<%= noticeId %>">
                        <input type="hidden" name="parent_id" value="<%= commentId %>">
                        <textarea name="content" rows="2" cols="30" placeholder="대댓글 작성" required></textarea><br>
                        <button type="submit">대댓글 작성</button>
                    </form>
                </td>
                <td>
                    <!-- 댓글 삭제 -->
                    <% if (currentUser != null && (currentUser.equals(commentUser) || "1".equals(currentRole))) { %>
                    <form action="deleteComment.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="comment_id" value="<%= commentId %>">
                        <input type="hidden" name="notice_id" value="<%= noticeId %>">
                        <button type="submit">삭제</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>
<%
        } else {
            out.println("<h1>게시물을 찾을 수 없습니다.</h1>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h1>오류 발생: " + e.getMessage() + "</h1>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
