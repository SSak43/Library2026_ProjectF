<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>図書データ参照画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-02.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/update.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">図書データ参照画面</h1>
        <button class="menu-button header-blue-button" type="button" onclick="location.href='${pageContext.request.contextPath}/BooksMain'">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding register-main-content">
        
        <c:set var="isSearch" value="${not empty param.searchKey}" />
        <c:set var="isFound" value="${not empty booksList}" />
        <c:if test="${isFound}">
            <c:set var="b" value="${booksList[0]}" />
        </c:if>
            
        <div class="register-error-message" id="error-message" style="min-height: 1.5em; visibility: ${isSearch && !isFound ? 'visible' : 'hidden'};">
            該当する図書は存在しません
        </div>

        <%-- 検索フォーム (6桁チェック付き) --%>
        <form method="GET" action="${pageContext.request.contextPath}/BooksReferenceSearch" id="searchForm" onsubmit="return validateSearch(event)">
            <div class="id-search-group" style="display: flex; gap: 10px; margin-bottom: 20px; justify-content: center;">
                <input type="text" class="input-field" id="search-key" name="searchKey" value="${param.searchKey}" placeholder="図書IDまたは書名入力" required autofocus oninput="this.setCustomValidity('')">
                <button type="submit" class="header-blue-button">表示</button>
            </div>
        </form>
            
        <%-- データ表示エリア (すべてreadonly / disabled) --%>
        <div id="displayForm">
            <table class="form-table">
                <tr>
                    <th>図書ID</th>
                    <td>
                        <input type="text" class="input-field input-readonly-id" value="<c:if test='${isFound}'><fmt:formatNumber value='${b.bookId}' pattern='000000' /></c:if>" readonly placeholder="IDを表示します">
                    </td>
                </tr>
                <tr>
                    <th>書名</th>
                    <td>
                        <input type="text" class="input-field" value="${isFound ? b.title : ''}" readonly placeholder="${!isFound ? 'IDまたは書名を入力して検索してください' : ''}">
                    </td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td>
                        <input type="text" class="input-field" value="${isFound ? b.writerName : ''}" readonly>
                    </td>
                </tr>
                <tr>
                    <th>会社名</th>
                    <td>
                        <input type="text" class="input-field" value="${isFound ? b.company : ''}" readonly>
                    </td>
                </tr>
                <tr>
                    <th>分類</th>
                    <td>
                        <input type="text" class="input-field" value="${isFound ? b.bookClass : ''}" readonly>
                    </td>
                </tr>
                <tr>
                    <th>状態</th>
                    <td>
                        <div class="category-options">
                            <label><input type="radio" name="status" value="0" ${isFound && b.bookStatus == '0' ? 'checked' : ''} disabled> 貸出可能</label>
                            <label><input type="radio" name="status" value="1" ${isFound && b.bookStatus == '1' ? 'checked' : ''} disabled> 貸出中</label>
                            <label><input type="radio" name="status" value="2" ${isFound && b.bookStatus == '2' ? 'checked' : ''} disabled> 貸出不可</label>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const searchInput = document.getElementById('search-key');

            // 検索バーの全角数字 ➡️ 半角自動置換
            if (searchInput) {
                searchInput.addEventListener('input', function(e) {
                    searchInput.value = searchInput.value.replace(/[０-９]/g, function(s) {
                        return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                    });
                });
            }
        });

        // 検索ボタンを押したときの桁数チェック
        function validateSearch(event) {
            var input = document.getElementById('search-key');
            var val = input.value.trim();

            // 数字のみの場合のチェック
            if (/^[0-9]+$/.test(val)) {
                if (val.length !== 6) {
                    input.setCustomValidity('図書IDを検索する場合は、6桁の数字（例: 000001）を入力してください。');
                    input.reportValidity();
                    event.preventDefault();
                    return false;
                }
            }
            return true;
        }
    </script>
</body>
</html>