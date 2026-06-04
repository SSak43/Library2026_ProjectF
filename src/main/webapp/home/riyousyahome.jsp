<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者メニュー画面</title>
    <link rel="stylesheet" href="riyousyahome.css">
</head>
<body>
    <!-- ヘッダー -->
    <header class="header">
        <div class="header-title">利用者メニュー画面</div>
        <!-- ログアウトしてログイン画面に戻る（プレビュー用に拡張子を.htmlにしています） -->
        <form action="logout" method="post">
    <button type="submit" class="logout-btn">ログアウト</button>
</form>
    </header>

    <!-- メイン領域 -->
    <main class="main-container">
        <!-- ログインパネルのスタイルを流用した大きなパネル -->
        <div class="menu-panel">
            <a href="kensaku.html" class="menu-link" style="font-size: 40px;">図書検索</a>
            <a href="yoyaku.html" class="menu-link" style="font-size: 40px;">予約処理</a>
            <a href="syoukai.html" class="menu-link" style="font-size: 40px;">貸出状況照会</a>
        </div>
    </main>
</body>
</html>