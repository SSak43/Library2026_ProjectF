<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, Model.ReserveBean, Model.UsersBean" %>
<%
    // サーブレットから渡されたデータを取得
    List<ReserveBean> reserveList = (List<ReserveBean>) request.getAttribute("reserveList");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    Boolean hasNextPageObj = (Boolean) request.getAttribute("hasNextPage");
    boolean hasNextPage = (hasNextPageObj != null) ? hasNextPageObj : false;
    Boolean hasPrevPageObj = (Boolean) request.getAttribute("hasPrevPage");
    boolean hasPrevPage = (hasPrevPageObj != null) ? hasPrevPageObj : false;
    
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    // 検索状態の復元
    String searchType = (String) request.getAttribute("searchType");
    if (searchType == null) searchType = "all";
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    if (searchKeyword == null) searchKeyword = "";
    
    UsersBean loginUser = null;
    Object loginUserObj = session.getAttribute("loginUser");
    if (loginUserObj == null) loginUserObj = session.getAttribute("user");
    if (loginUserObj == null) loginUserObj = session.getAttribute("login");
    if (loginUserObj != null && loginUserObj instanceof UsersBean) {
        loginUser = (UsersBean) loginUserObj;
    }
%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>予約状況検索</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-04.css">
<script>
function setSearchAction() {
    document.getElementById('formAction').value = 'search';
    document.getElementById('formPage').value = '1'; 
}

function movePage(pageNo) {
    document.getElementById('formAction').value = 'search';
    document.getElementById('formPage').value = pageNo;
    document.getElementById('mainForm').submit();
}

function cancelReserve(reserveId) {
    if (confirm('この予約を取り消しますか？')) {
        document.getElementById('formAction').value = 'cancel';
        document.getElementById('cancelTargetId').value = reserveId;
        document.getElementById('mainForm').submit();
    }
}

function resetForm() {
    // 検索キーワードの入力欄の文字を空にする
    document.getElementsByName('searchKeyword')[0].value = '';
    // 必要であれば選択ボックスも初期状態（すべての項目）に戻す場合は以下も追加
    document.getElementsByName('searchType')[0].value = 'all';
}
</script>
</head>
<body>
<form id="mainForm" action="${pageContext.request.contextPath}/reserveSearch" method="POST">
  <input type="hidden" name="action" id="formAction" value="search">
  <input type="hidden" name="page" id="formPage" value="<%= currentPage %>">
  <input type="hidden" name="cancelTargetId" id="cancelTargetId" value="">
  
  

<div class="page-header">
  <div class="page-title">予約状況検索画面</div>
  <button class="menu-btn" type="button" 
          onclick="location.href='${pageContext.request.contextPath}/ReserveManagement'"
          style="position: absolute; right: 20px; top: 50%; transform: translateY(-50%); padding: 10px 25px; font-size: 0.95rem; cursor: pointer;">
      メニュー
  </button>
</div>

<div class="search-container">
  <table class="search-table">
    <tr>
      <th class="search-col-item border-bottom-gap">検索項目</th>
      <th class="search-col-value border-bottom">検索値</th>
      <td rowspan="2" class="search-col-buttons">
        <button type="submit" class="action-btn" onclick="setSearchAction()">検索</button>
        <button type="button" class="action-btn" onclick="resetForm()">リセット</button>
      </td>
    </tr>
    <tr>
      <td class="search-col-item border-bottom-gap"> 
        <select name="searchType" class="search-select">
          <option value="all" <%= "all".equals(searchType) ? "selected" : "" %>>すべての項目▼</option>
          <option value="userId" <%= "userId".equals(searchType) ? "selected" : "" %>>利用者ID</option>
          <option value="bookId" <%= "bookId".equals(searchType) ? "selected" : "" %>>図書ID</option>
          <option value="title" <%= "title".equals(searchType) ? "selected" : "" %>>書名</option>
          <option value="author" <%= "author".equals(searchType) ? "selected" : "" %>>著者</option>
          <option value="publisher" <%= "publisher".equals(searchType) ? "selected" : "" %>>出版社</option>
        </select>
      </td>
      <td class="search-col-value border-bottom"> 
        <input type="text" name="searchKeyword" class="search-input" value="<%= searchKeyword %>" autocomplete="off">
      </td>
    </tr>
  </table>
</div>

<div class="table-container">
  <p class="result-message">
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
      <span style="color: #ff0000; font-weight: bold;"><%= errorMessage %></span>
    <% } else if (successMessage != null && !successMessage.isEmpty()) { %>
      <span style="color: #008000; font-weight: bold;"><%= successMessage %></span>
    <% } else if (reserveList != null) { %>
      <%= reserveList.size() %>件の予約情報が見つかりました。
    <% } %>
  </p>
  
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-id">図書ID</th>
        <th class="col-category">氏名</th>
        <th class="col-title">書名</th>
        <th class="col-author">著者</th>
        <th class="col-publisher">予約日</th>
        <th class="col-status">予約順</th>
        <th class="col-action">取り消し</th>
      </tr>
    </thead>
    <tbody>
    <% 
    int count = 0;
    if (reserveList != null) {
        for (ReserveBean reserve : reserveList) {
            count++;
            
            // 権限とIDを確実に文字列に変換してチェックするロジック
            boolean showCancelButton = false;
            if (loginUser != null) {
                String uClass = loginUser.getUserClass();
                if (uClass == null) uClass = "";
                
                // 管理者("0") または 司書("1") の場合はすべて表示
                if ("0".equals(uClass) || "1".equals(uClass) || "管理者".equals(uClass) || "司書".equals(uClass)) {
                    showCancelButton = true;
                } 
                // 利用者の場合は、予約データのユーザーIDと自分のユーザーIDが【完全に一致する場合のみ】表示
                else {
                    String rUserId = String.valueOf(reserve.getUserId());
                    String lUserId = String.valueOf(loginUser.getUserId());
                    if (rUserId.trim().equals(lUserId.trim())) {
                        showCancelButton = true;
                    }
                }
            }
    %>
      <tr>
        <td class="col-id"><%= String.format("%05d", reserve.getBookId()) %></td>
        <td class="col-category"><%= reserve.getUserName() %></td>
        <td class="col-title"><%= reserve.getTitle() %></td>
        <td class="col-author"><%= reserve.getWriterName() %></td>
        <td class="col-publisher"><%= reserve.getReserveDate() %></td>
        <td class="col-status"><%= Integer.parseInt(String.valueOf(reserve.getReserveNo()).trim()) + 1 %></td>
        <td class="col-action" style="text-align: center;">
          <% if (showCancelButton) { %>
            <button type="button" class="action-btn" style="color: #ff0000; padding: 2px 8px; font-size: 13px;" onclick="cancelReserve('<%= reserve.getReserveId() %>')">取り消し</button>
          <% } %>
        </td>
      </tr>
    <% 
          }
      }
      for (int i = count; i < 10; i++) {
    %>
      <tr>
        <td class="col-id"></td>
        <td class="col-category"></td>
        <td class="col-title"></td>
        <td class="col-author"></td>
        <td class="col-publisher"></td>
        <td class="col-status"></td>
        <td class="col-action"></td>
      </tr>
    <% 
      } 
    %>
    </tbody>
  </table>

  <div class="pagination-area">
    <div class="pagination-buttons">
      <button type="button" <%= hasPrevPage ? "" : "disabled style='cursor: default; opacity: 0.5;'" %> onclick="movePage(<%= currentPage - 1 %>)">◀</button>
      <button type="button" <%= hasNextPage ? "" : "disabled style='cursor: default; opacity: 0.5;'" %> onclick="movePage(<%= currentPage + 1 %>)">▶</button>
    </div>
  </div>
</div>
</form>
</body>
</html>