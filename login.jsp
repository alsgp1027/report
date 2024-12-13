<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
</head>
<body>
    <h1>로그인</h1>
    <form action="loginProcess.jsp" method="post">
        <label for="username">아이디:</label><br>
        <input type="text" id="username" name="username" required><br><br>

        <label for="password">비밀번호:</label><br>
        <input type="password" id="password" name="password" required><br><br>

        <button type="submit">로그인</button>
    </form>

    <!-- 회원가입 버튼 -->
    <form action="register.jsp" method="get">
        <button type="submit">회원가입</button>
    </form>
</body>
</html>
