<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>返却期限超過の貸出一覧</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-09.css?v=2">
</head>
<body>
<div class="header">
  <h1 class="header-title">返却期限超過の貸出一覧</h1>
  <button type="button" class="menu-button" onclick="goToMenu()">メニュー</button>
</div>

<div class="search-container">
  <form action="" method="post" id="searchForm">
    <table class="search-table">
      <tr>
        <th class="search-col-item border-bottom-gap">検索項目</th>
        <th class="search-col-value border-bottom">検索値</th>
        <td rowspan="2" class="search-col-buttons">
          <button type="submit" class="action-btn">検索</button>
          <button type="button" class="action-btn" onclick="location.href=''">条件クリア</button>
        </td>
      </tr>
      <tr>
        <td class="search-col-item border-bottom-gap"> 
          <select class="search-select" name="searchType">
            <option value="all" ${param.searchType == 'all' ? 'selected' : ''}>すべての項目▼</option>
            <option value="bookId" ${param.searchType == 'bookId' ? 'selected' : ''}>図書ID</option>
            <option value="title" ${param.searchType == 'title' ? 'selected' : ''}>書名</option>
            <option value="userId" ${param.searchType == 'userId' ? 'selected' : ''}>利用者ID</option>
          </select>
        </td>
        <td class="search-col-value border-bottom"> 
          <input type="text" class="search-input" name="keyword" value="<c:out value='${param.keyword}'/>" autocomplete="off">
        </td>
      </tr>
    </table>
  </form>
</div>

<div class="table-container">
  <p class="result-message">
    <c:if test="${pageContext.request.method == 'POST'}">
        「<c:out value="${param.keyword}"/>」の検索結果（※現在はデモ表示です）
    </c:if>
  </p>
  
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-no">No.</th>
        <th class="col-book-id">図書ID</th>
        <th class="col-title">書名</th>
        <th class="col-user-id text-center">利用者ID</th>
        <th class="col-return-date text-center">返却日</th>
        <th class="col-action text-center">操作</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>00001</td>
        <td>重要なことは問い続けること...</td>
        <td class="text-center">U12345</td>
        <td class="text-center">2026/06/10</td>
        <td class="text-center"><button type="button" class="action-btn">返却</button></td>
      </tr>
      <c:forEach begin="2" end="10" var="i">
        <tr>
            <td>${i}</td><td></td><td></td>
            <td class="text-center"></td>
            <td class="text-center"></td>
            <td class="text-center"></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div class="pagination-area">
    <div class="pagination-buttons">
      <button type="button">◀</button>
      <button type="button">▶</button>
    </div>
  </div>
</div>

<script>
  function goToMenu() {
    window.location.href = 'F-3.bookManagement.jsp';
  }
</script>
</body>
</html>