<%@ page import="java.sql.*, java.io.File, org.apache.commons.fileupload.disk.DiskFileItemFactory, java.util.List, org.apache.commons.fileupload.servlet.ServletFileUpload, org.apache.commons.fileupload.FileItem" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    response.setCharacterEncoding("UTF-8");

    // 파일 업로드 경로 설정
    String uploadPath = application.getRealPath("/") + "uploads";
    File uploadDir = new File(uploadPath);

    // 디렉토리 존재 여부 확인 후 생성
    if (!uploadDir.exists()) {
        uploadDir.mkdir(); // 디렉토리 생성
    }

    // 데이터베이스 연결 설정
    String dbUrl = "jdbc:mysql://localhost:3306/SchoolApp?characterEncoding=UTF-8";
    String dbUser = "root";
    String dbPassword = "tiger123";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null; // 쿼리 수행 결과 확인용

    try {
        // 데이터베이스 연결
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // 업로드된 파일 저장 및 폼 데이터 처리
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = upload.parseRequest(request);

        String title = null;
        String content = null;
        String parentUser = null;
        String filePath = null;

        for (FileItem item : items) {
            if (item.isFormField()) {
                // 폼 데이터 처리
                if (item.getFieldName().equals("title")) {
                    title = item.getString("UTF-8");
                } else if (item.getFieldName().equals("content")) {
                    content = item.getString("UTF-8");
                } else if (item.getFieldName().equals("parent_user")) {
                    parentUser = item.getString("UTF-8");
                }
            } else {
                // 파일 업로드 처리
                if (!item.getName().isEmpty()) {
                    String fileName = new File(item.getName()).getName();

                    // 파일 이름 디코딩 (한글 처리)
                    fileName = new String(fileName.getBytes("ISO-8859-1"), "UTF-8");

                    // 파일 경로 설정
                    filePath = uploadPath + File.separator + fileName;

                    // 파일 저장
                    File file = new File(filePath);
                    item.write(file);
                }
            }
        }

        // DB에 데이터 저장
        String sql = "INSERT INTO Notices (title, content, file_path, parent_user) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); // 생성된 ID 반환
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setString(3, filePath != null ? filePath : ""); // 파일 경로가 없으면 빈 문자열 저장
        pstmt.setString(4, parentUser);

        int affectedRows = pstmt.executeUpdate(); // 실행 결과 확인

        if (affectedRows > 0) {
            // INSERT 성공 -> 생성된 ID 가져오기
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                int noticeId = rs.getInt(1); // 생성된 Notice의 ID
                // 성공적으로 추가되면 상세 페이지로 리다이렉트
                response.sendRedirect("noticeDetail.jsp?id=" + noticeId);
            }
        } else {
            // INSERT 실패 시 에러 출력
            out.println("<h1>알림장을 저장하지 못했습니다.</h1>");
            out.println("<a href='noticeList.jsp'>목록으로 돌아가기</a>");
        }
    } catch (Exception e) {
        // 예외 처리
        e.printStackTrace();
        out.println("<h1>오류 발생: " + e.getMessage() + "</h1>");
    } finally {
        // 리소스 정리
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
