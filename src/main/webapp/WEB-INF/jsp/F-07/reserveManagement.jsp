<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>貸出情報照会</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home/riyousyahome.css">
</head>
<body>

<%

UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null) loginUserObj = session.getAttribute("user");
if (loginUserObj == null) loginUserObj = session.getAttribute("login");
if (loginUserObj != null && loginUserObj instanceof UsersBean) {
    loginUser = (UsersBean) loginUserObj;
}
    // ログインユーザーの区分に応じて遷移先URLを決定
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
    <header class="header">
    <div class="header-title">予約画面</div>
    <form style="margin-left: auto;">
        <button type="button" class="btn-logout" 
                onclick="location.href='<%= menuUrl %>'">
            メニュー
        </button>
    </form>
</header>

    <main class="main-container">

        <div class="menu-panel">
            <a href="${pageContext.request.contextPath}/reserveBook" class="menu-link" style="font-size: 40px;">予約登録</a>
            <a href="${pageContext.request.contextPath}/reserveSearch" class="menu-link" style="font-size: 40px;">照会・取り消し</a>
        </div>
    </main>
</body>
</html>