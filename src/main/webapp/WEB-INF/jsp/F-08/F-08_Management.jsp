<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>

<body>
<%
// ログインユーザーの区分に応じて遷移先URLを決定する処理
UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null) loginUserObj = session.getAttribute("user");
if (loginUserObj == null) loginUserObj = session.getAttribute("login");
if (loginUserObj != null && loginUserObj instanceof UsersBean) {
loginUser = (UsersBean) loginUserObj;
}

String menuUrl = request.getContextPath() + "/home/admin_home.jsp"; // デフォルト
if (loginUser != null) {
String uClass = loginUser.getUserClass();
if ("0".equals(uClass) || "管理者".equals(uClass)) {
menuUrl = request.getContextPath() + "/home/admin_home.jsp";
} else if ("1".equals(uClass) || "司書".equals(uClass)) {
menuUrl = request.getContextPath() + "/home/sisyo_home.jsp";
} else if ("2".equals(uClass) || "利用者".equals(uClass)) {
menuUrl = request.getContextPath() + "/home/riyousyahome.jsp";
}
}
%>
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
        <button class="menu-button header-blue-button" onclick="location.href='<%= menuUrl %>'">メニュー</button>
    </div>

    <!-- メイン枠 -->
    <div class="main-content-base layout-center">
        <!-- リンク群をまとめる枠 -->
        <div class="link-group">
            <a href="${pageContext.request.contextPath}/rentalSearch">貸出状況</a>
            <a href="${pageContext.request.contextPath}/reserveStatusInquiry">予約状況</a>
            <a href="${pageContext.request.contextPath}/userStatus">貸出・予約状況</a>
        </div>
    </div>

</body>
</html>
