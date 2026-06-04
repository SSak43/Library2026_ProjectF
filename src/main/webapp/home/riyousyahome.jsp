<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者メニュー画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home/riyousyahome.css">
</head>
<body>
    <header class="header">
        <div class="header-title">利用者メニュー画面</div>
        <form action="/Library2026_ProjectF/logout" method="post" style="margin-left: auto;">
            <button type="submit" class="btn-logout">ログアウト</button>
        </form>
    </header>

    <main class="main-container">
<<<<<<< HEAD
        <!-- ログインパネルのスタイルを流用した大きなパネル -->
=======
>>>>>>> branch 'master' of https://github.com/SSak43/Library2026_ProjectF.git
        <div class="menu-panel">
            <a href="${pageContext.request.contextPath}/booksSearch" class="menu-link" style="font-size: 40px;">図書検索</a>
            <a href="${pageContext.request.contextPath}/reserveBook" class="menu-link" style="font-size: 40px;">予約処理</a>
            <a href="${pageContext.request.contextPath}/reserveBook" class="menu-link" style="font-size: 40px;">貸出状況照会</a>
        </div>
    </main>
</body>
</html>