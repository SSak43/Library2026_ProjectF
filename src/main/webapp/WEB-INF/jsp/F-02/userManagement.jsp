<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者管理</h1>
        <button class="menu-button" type="button" onclick="location.href='${pageContext.request.contextPath}/admin_home.jsp'">メニュー</button>
    </div>

    <div class="main-content-base layout-center">
        <div class="link-group">
            <a href="${pageContext.request.contextPath}/UsersRegist">利用者登録</a>
            <a href="${pageContext.request.contextPath}/#">更新</a>
            <a href="${pageContext.request.contextPath}/#">利用者情報参照</a>
        </div>
    </div>

</body>
</html>