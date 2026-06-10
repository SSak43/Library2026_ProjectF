<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者データ参照画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-02.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者データ参照画面</h1>
        <button class="menu-button header-blue-button" type="button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding register-main-content">
        
        <c:set var="isSearch" value="${not empty param.searchKey}" />
        <c:set var="isFound" value="${not empty usersList}" />
        <c:if test="${isFound}">
            <c:set var="u" value="${usersList[0]}" />
        </c:if>
        
        <div class="register-error-message" id="error-message" style="min-height: 1.5em; visibility: ${isSearch && !isFound ? 'visible' : 'hidden'};">
            該当する利用者は存在しません
        </div>

        <form method="GET" action="${pageContext.request.contextPath}/UsersSearch" id="searchForm">
            <div class="id-search-group" style="display: flex; gap: 10px; margin-bottom: 20px; justify-content: center;">
                <input type="text" class="input-field" id="search-key" name="searchKey" value="${param.searchKey}" placeholder="利用者IDまたは氏名入力" required style="width: 250px;">
                <button type="submit" class="header-blue-button">表示</button>
            </div>
        </form>

        <div id="displayArea" style="display: flex; flex-direction: column; flex-grow: 1;">
            
            <div class="category-group">
                <div class="category-label">区分</div>
                <div class="category-options">
                    <label><input type="radio" name="cla" value="0" ${isFound && u.userClass == '0' ? 'checked' : ''} disabled> 管理者</label>
                    <label><input type="radio" name="cla" value="1" ${isFound && u.userClass == '1' ? 'checked' : ''} disabled> 司書</label>
                    <label><input type="radio" name="cla" value="2" ${isFound && u.userClass == '2' ? 'checked' : ''} disabled> 利用者</label>
                </div>
            </div>

            <table class="form-table">
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field" id="display-name" value="${isFound ? u.userName : ''}" placeholder="${!isFound ? 'IDまたは氏名を入力してください' : ''}" readonly>
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field" id="display-tel" value="${isFound ? u.tel : ''}" placeholder="${!isFound ? 'IDまたは氏名を入力してください' : ''}" readonly>
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="text" class="input-field" id="display-pass" value="${isFound ? '********' : ''}" placeholder="${!isFound ? 'IDまたは氏名を入力してください' : ''}" readonly>
                    </td>
                </tr>
            </table>

            <div class="bottom-actions" style="margin-top: 20px;">
                <div class="category-group" style="margin-bottom: 0;">
                    <div class="category-label">利用</div>
                    <div class="category-options">
                        <label><input type="radio" name="status" value="0" ${isFound && u.userStatus == '0' ? 'checked' : ''} disabled> 可</label>
                        <label><input type="radio" name="status" value="1" ${isFound && u.userStatus == '1' ? 'checked' : ''} disabled> 不可</label>
                    </div>
                </div>
                <button type="button" class="btn-back-management" onclick="location.href='${pageContext.request.contextPath}/home/userManagement.jsp'">戻る</button>
            </div>
        </div>

    </div>
</body>

<script>
// 全角数字（０〜９）を半角数字（0~9）に自動置換
        document.addEventListener("DOMContentLoaded", function() {
            const searchInput = document.getElementById('search-key');
            if (searchInput) {
                searchInput.addEventListener('input', function(e) {
                    searchInput.value = searchInput.value.replace(/[０-９]/g, function(s) {
                        return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                    });
                });
            }
        });

       
        
    </script>
</html>