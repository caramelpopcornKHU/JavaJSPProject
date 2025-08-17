<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<script>
    // 로그인 실패 시 URL에 error=1이 있으면 알림을 띄움
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('error')) {
            alert("아이디 또는 비밀번호가 일치하지 않습니다.");
        }
    }
</script>
</head>
<body>
    <h2>로그인</h2>
    <form action="foodloginProc.jsp" method="post">
        <table>
            <tr>
                <td>아이디</td>
                <td><input type="text" name="id" required></td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td><input type="password" name="password" required></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="로그인">
                </td>
            </tr>
        </table>
    </form>
    <br>
    <a href="foodregister.jsp">회원가입 하러가기</a>
</body>
</html>