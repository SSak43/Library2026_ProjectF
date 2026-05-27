<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>図書システム - ログイン</title>
    <link rel="stylesheet" href="login.css">
</head>
<body>

    <header class="header">
        図書システム
    </header>

    <div class="main-container">
        <div class="login-panel">
            <h2 class="login-title">ログイン</h2>

            <div class="error-container">
                <%
                    // サーブレット等から受け取ったエラーメッセージがある場合のみ表示
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                    <p class="error-message"><%= errorMessage %></p>
                <%
                    }
                %>
            </div>

            <form action="login" method="post">
                <div class="form-group">
                    <label for="id">ID</label>
                    <input type="text" id="id" name="id" class="form-control">
                </div>

                <div class="form-group">
                    <label for="password">パスワード</label>
                    <input type="password" id="password" name="password" class="form-control">
                </div>

                <button type="submit" class="btn-login">ログイン</button>
            </form>
        </div>
    </div>

</body>
</html>