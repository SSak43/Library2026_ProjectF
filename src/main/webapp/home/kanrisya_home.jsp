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
            <a href="kensaku.html" class="menu-link" style="font-size: 40px;">図書検索</a>
            <a href="yoyaku.html" class="menu-link" style="font-size: 40px;">予約処理</a>
            <a href="syoukai.html" class="menu-link" style="font-size: 40px;">貸出状況照会</a>
            <a href="zousyo.html" class="menu-link" style="font-size: 40px;">蔵書管理</a>
            <a href="kasidasi.html" class="menu-link" style="font-size: 40px;">貸出処理</a>
            <a href="henkyaku.html" class="menu-link" style="font-size: 40px;">返却処理</a>
            <a href="entai.html" class="menu-link" style="font-size: 40px;">延滞一覧</a>
            <a href="dassyu.html" class="menu-link" style="font-size: 40px;">ダッシュボード</a>
            <a href="riyousya.html" class="menu-link" style="font-size: 40px;">利用者管理</a>
            <a href="masuta.html" class="menu-link" style="font-size: 40px;">マスタ管理</a>
        </div>
    </main>
</body>
</html>