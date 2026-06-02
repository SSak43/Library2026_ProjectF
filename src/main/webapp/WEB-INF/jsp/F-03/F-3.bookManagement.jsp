<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>蔵書管理</title>
    <!-- 新しく作成したF-3用のCSSファイルを読み込む -->
    <link rel="stylesheet" href="f3-style.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">蔵書管理</h1>
        <!-- 画面移動のみのボタンなので type="button" とします -->
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- 共通ベースクラス(main-content-base) ＋ 中央寄せレイアウトクラス(layout-center) -->
    <div class="main-content-base layout-center">
        <!-- リンク群をまとめる枠 -->
        <div class="link-group">
            <a href="F-3.bookSearch.jsp">登録</a>
            <a href="F-3.bookUpdate.jsp">更新</a>
            <a href="F-3.bookSearch.jsp">検索</a>
            <a href="F-3.bookStatusChange.jsp">状態変更</a>
        </div>
    </div>

</body>
</html>