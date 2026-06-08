<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>蔵書管理</title>
    <!-- F-3用のCSSファイルを読み込む -->
    <link rel="stylesheet" href="F-03.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">蔵書管理</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メイン枠 -->
    <div class="main-content-base layout-center">
        <!-- リンク群をまとめる枠 -->
        <div class="link-group">
            <a href="F-03.bookRegistration.jsp">登録</a>
            <a href="F-03.bookUpdate.jsp">更新</a>
            <a href="F-03.bookSearch.jsp">検索</a>
            <a href="F-03.bookStatusChange.jsp">状態変更</a>
        </div>
    </div>

</body>
</html>