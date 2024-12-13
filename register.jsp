<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
</head>
<body>
    <h1>회원가입</h1>
    <form action="registerProcess.jsp" method="post">
        <label for="username">아이디:</label><br>
        <input type="text" id="username" name="username" required><br><br>

        <label for="password">비밀번호:</label><br>
        <input type="password" id="password" name="password" required><br><br>

        <label for="role">사용자 유형:</label><br>
        <select id="role" name="role" required>
            <option value="1">교사</option>
            <option value="2">학부모</option>
            <option value="3">원장</option>
        </select><br><br>

        <button type="submit">회원가입</button>
    </form>
</body>
</html>
