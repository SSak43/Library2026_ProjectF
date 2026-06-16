<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>貸出状況</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-08.css">
</head>
<body>
<div class="page-header">
  <div class="page-title">貸出状況</div>
  <button type="button" class="menu-btn">メニュー</button>
</div>

<div class="search-container">
  <table class="search-table">
    <tr>
      <th class="search-col-item">利用者ID</th>
      <td class="search-col-value">
        <input type="text" class="search-input" autocomplete="off">
      </td>
      <td class="search-col-buttons">
        <button type="button" class="action-btn">表示</button>
        <button type="button" class="action-btn">リセット</button>
      </td>
    </tr>
  </table>
</div>

<div class="table-container">
  <p class="result-message">1件の貸出図書が見つかりました。</p>
  
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-no">No.</th>
        <th class="col-id">図書ID</th>
        <th class="col-title">書名</th>
        <th class="col-author">貸出日</th>
        <th class="col-publisher">返却期限</th>
        <th class="col-action">操作</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1</td>
        <td>00009</td>
        <td>企画と提案</td>
        <td>2026/05/21</td>
        <td>2026/06/04</td>
        <td class="col-action-cell"><button type="button" class="detail-btn">詳細</button></td>
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