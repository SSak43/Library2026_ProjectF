<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>F-08_メニュー</title>
    <!-- F-3用のCSSファイルを読み込む -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-03.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">貸出状況照会</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メイン枠 -->
    <div class="main-content-base layout-center">
        <!-- リンク群をまとめる枠 -->
        <div class="link-group">
            <a href="F-08.jsp">貸出状況</a>
            <a href="F-08_1.jsp">予約状況</a>
        </div>
    </div>

</body>
</html>
