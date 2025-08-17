<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script>
    function validateForm() {
        var pw1 = document.getElementById("password").value;
        var pw2 = document.getElementById("password_check").value;

        if (pw1 !== pw2) {
            alert("비밀번호가 일치하지 않습니다.");
            return false; // 폼 제출을 막음
        }
        return true; // 폼 제출을 허용
    }
</script>
</head>
<body>
    <h2>맛집 즐겨찾기 회원가입</h2>
    <form action="foodregisterProc.jsp" method="post" onsubmit="return validateForm();">
        <table>
            <tr>
                <td>아이디</td>
                <td><input type="text" name="id" required></td>
            </tr>
            <tr>
                <td>비밀번호</td>
                <td><input type="password" name="password" id="password" required></td>
            </tr>
            <tr>
                <td>비밀번호 확인</td>
                <td><input type="password" name="password_check" id="password_check" required></td>
            </tr>
            <tr>
                <td>이름</td>
                <td><input type="text" name="name" required></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="가입하기">
                    <input type="reset" value="다시작성">
                </td>
            </tr>
        </table>
    </form>
    <br>
    <a href="foodlogin.jsp">로그인 페이지로 돌아가기</a>
</body>
</html>