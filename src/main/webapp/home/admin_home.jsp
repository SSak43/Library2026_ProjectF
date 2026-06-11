<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理者メニュー画面</title>
    <link rel="stylesheet" href="riyousyahome.css">
</head>
<body>

    <header class="header">
        <div class="header-title">管理者メニュー画面</div>
        <form action="/Library2026_ProjectF/logout" method="post" style="margin-left: auto;">
            <button type="submit" class="btn-logout">ログアウト</button>
        </form>
    </header>


    <main class="main-container">
    
        <div class="menu-panel">
            <a href="${pageContext.request.contextPath}/booksSearch" class="menu-link" style="font-size: 40px;">図書検索</a>
            <a href="${pageContext.request.contextPath}/ReserveManagement" class="menu-link" style="font-size: 40px;">予約処理</a>
            <a href="${pageContext.request.contextPath}/lending" class="menu-link" style="font-size: 40px;">貸出処理</a>
            <a href="${pageContext.request.contextPath}/returnBook" class="menu-link" style="font-size: 40px;">返却処理</a>
            <a href="${pageContext.request.contextPath}/rentalSearch" class="menu-link" style="font-size: 40px;">貸出状況照会</a>
            <a href="${pageContext.request.contextPath}/BooksMain" class="menu-link" style="font-size: 40px;">蔵書管理</a>
            <a href="${pageContext.request.contextPath}/#" class="menu-link" style="font-size: 40px;">延滞一覧</a>
            <a href="${pageContext.request.contextPath}/UserManagement" class="menu-link" style="font-size: 40px;">利用者管理</a>
            <a href="${pageContext.request.contextPath}/#" class="menu-link" style="font-size: 40px;">ダッシュボード</a>
            <a href="${pageContext.request.contextPath}/#" class="menu-link" style="font-size: 40px;">マスタ管理　</a>
        </div>
    </main>
</body>
</html>