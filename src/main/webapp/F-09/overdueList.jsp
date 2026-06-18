<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>図書検索</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
</head>
<body>
<div class="page-header">
  <div class="page-title">検索画面</div>
  <button type="button" class="menu-btn">メニュー</button>
</div>
<!-- 検索エリア -->
<div class="search-container">
  <table class="search-table">
    <tr>
      <th class="search-col-item border-bottom-gap">検索項目</th>
      <th class="search-col-value border-bottom">検索値</th>
      <td rowspan="2" class="search-col-buttons">
        <button type="button" class="action-btn">検索</button>
        <button type="button" class="action-btn">リセット</button>
      </td>
    </tr>
    <tr>
      <td class="search-col-item border-bottom-gap"> <select class="search-select">
          <option>すべての項目▼</option>
          <option>図書ID</option>
          <option>書名</option>
          <option>利用者ID</option>
        </select>
      </td>
      <td class="search-col-value border-bottom"> <input type="text" class="search-input" autocomplete="off">
      </td>
    </tr>
  </table>
</div>

<!-- 表エリア -->
<div class="table-container">
  <p class="result-message">1件のデータが見つかりました。</p>
  
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-no">No.</th>
        <th class="col-id">図書ID</th>
        <th class="col-title">書名</th>
        <th class="col-userid">利用者ID</th>
        <th class="col-returndate">返却日</th>
        <th class="col-action">操作</th>
      </tr>
    </thead>
    <tbody>
      <!-- データ行（1行目のみサンプルデータを入力） -->
      <tr>
        <td>1</td>
        <td>00001</td>
        <td>重要なことは問い続けること...</td>
        <td>U00123</td>
        <td>2026/06/30</td>
        <td></td>
      </tr>
      <tr><td>2</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>3</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>4</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>5</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>6</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>7</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>8</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>9</td><td></td><td></td><td></td><td></td><td></td></tr>
      <tr><td>10</td><td></td><td></td><td></td><td></td><td></td></tr>
    </tbody>
  </table>

  <div class="pagination-area">
    <div class="pagination-buttons">
      <button type="button">◀</button>
      <button type="button">▶</button>
    </div>
  </div>
</div>
</body>
</html>