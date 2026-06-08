<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>貸出情報照会</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home/riyousyahome.css">
</head>
<body>
    <header class="header">
        <div class="header-title">貸出情報照会</div>
        <form action="/Library2026_ProjectF/logout" method="post" style="margin-left: auto;">
            <button type="submit" class="btn-logout">メニュー</button>
        </form>
    </header>

    <main class="main-container">

        <div class="menu-panel">
            <a href="${pageContext.request.contextPath}/booksSearch" class="menu-link" style="font-size: 40px;">予約登録</a>
            <a href="${pageContext.request.contextPath}/reserveBook" class="menu-link" style="font-size: 40px;">照会・取り消し</a>
        </div>
    </main>
</body>
</html>