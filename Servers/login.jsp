<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>LX Chat 로그인</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f0f2f5; }
    .login-container { padding: 40px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; }
    h1 { color: #333; }
    input[type="text"] { width: 250px; padding: 10px; margin-top: 20px; border: 1px solid #ddd; border-radius: 4px; }
    input[type="submit"] { width: 100%; padding: 10px; margin-top: 20px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; }
    input[type="submit"]:hover { background-color: #0056b3; }
</style>
</head>
<body>
    <div class="login-container">
        <h1>LX 아카데미 채팅</h1>
        <form action="login" method="post">
            <input type="text" name="userId" placeholder="cmd > ipconfig 의 IPv4 주소를 입력하세요" required>
            <br>
            <input type="submit" value="채팅 시작하기">
        </form>
    </div>
</body>
</html>