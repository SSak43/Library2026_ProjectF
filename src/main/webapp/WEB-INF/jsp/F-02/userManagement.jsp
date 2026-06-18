<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者管理</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
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

    <div class="header">
        <h1 class="header-title">利用者管理</h1>
        <button class="menu-button header-blue-button" type="button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
    </div>

    <div class="main-content-base layout-center">
        <div class="link-group">
            <a href="${pageContext.request.contextPath}/UsersRegist">利用者登録</a>
            <a href="${pageContext.request.contextPath}/UsersUpdate">更新</a>
            <a href="${pageContext.request.contextPath}/UsersSearch">利用者情報参照</a>
        </div>
    </div>

</body>
</html>