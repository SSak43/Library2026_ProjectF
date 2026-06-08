<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者管理</title>
    <!-- 外部の共通CSSファイルを読み込む -->
    <link rel="stylesheet" href="F-02.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者管理</h1>
        <button class="menu-button">メニュー</button>
    </div>

    <!-- 共通ベースクラス(main-content-base) ＋ 中央寄せレイアウトクラス(layout-center) -->
    <div class="main-content-base layout-center">
        <div class="link-group">
            <a href="F-2.user_register.jsp">利用者登録</a>
            <a href="F-2.userUpdate.jsp">更新</a>
            <a href="F-2.userReference.jsp">利用者情報参照</a>
        </div>
    </div>

</body>
</html>