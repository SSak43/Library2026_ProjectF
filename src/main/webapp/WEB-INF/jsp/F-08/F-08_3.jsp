<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>貸出・予約状況</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/F-08.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
	<div class="header">
		<h1 class="header-title">貸出・予約状況</h1>
		<button class="menu-button" type="button"
			onclick="location.href='${pageContext.request.contextPath}/InquiryManagementServlet'">メニュー</button>
</div>
<!-- 新しく追加した検索エリア -->
<div class="search-container">
		<form action="${pageContext.request.contextPath}/userStatus"
			method="post" id="searchForm">
			<table class="search-table">
				<tr>
					<th class="search-col-item border-bottom-gap">検索項目</th>
					<th class="search-col-value border-bottom">検索値</th>
					<td rowspan="2" class="search-col-buttons">
						<button type="submit" class="action-btn">検索</button>
						<button type="button" class="action-btn">リセット</button>
					</td>
				</tr>
				<tr>
					<td class="search-col-item border-bottom-gap"><select
						class="search-select" name="searchCategory">
							<option value="all" ${searchCategory == 'all' ? 'selected' : ''}>すべての項目▼</option>
							<option value="bookId"
								${searchCategory == 'bookId' ? 'selected' : ''}>図書ID</option>
							<option value="title"
								${searchCategory == 'title' ? 'selected' : ''}>書名</option>
							<option value="userId"
								${searchCategory == 'userId' ? 'selected' : ''}>利用者ID</option>
							<option value="name"
								${searchCategory == 'name' ? 'selected' : ''}>利用者氏名</option>
							<!--           <option>著者</option> -->
							<!--           <option>出版社</option> -->
					</select></td>
					<td class="search-col-value border-bottom"><input type="text"
						class="search-input" name="searchKeyword"
						value="<c:out value='${keyword}'/>" autocomplete="off">
				</tr>
			</table>
		</form>
</div>

<!-- 既存の表エリア -->
<div class="table-container">
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-no">貸出状況</th>
        <th class="col-id">図書ID</th>
        <th class="col-title">書名</th>
        <th class="col-date">貸出日</th>
        <th class="col-date">返却期限</th>
        <th class="col-action">操作</th>
      </tr>
    </thead>
    <tbody>
				<c:forEach var="rental" items="${rentalList}" varStatus="status">
					<tr>
						<td>${((currentPage != null ? currentPage : 1) - 1) * 5 + status.count}</td>
						<%-- 						<td><c:out value="${rental.lendId}" /></td> --%>
						<td><c:out value="${rental.bookId}" /></td>
						<td><c:out value="${rental.title}" /></td>
						<td><c:out value="${rental.loanDate}" /></td>
						<td><c:out value="${rental.returnDeadline}" /></td>
						<%-- 						<td><c:out value="${book.bookClass}" /></td> --%>


						<td class="col-action-cell">
							<fmt:formatNumber value="${rental.bookId}" pattern="000000" var="fmtBookId" /> <fmt:formatNumber
								value="${sessionScope.loginUser.userId}" pattern="000000"
								var="fmtUserId" />

							<form action="${pageContext.request.contextPath}/returnBook">
								<input type="hidden" name="action" value="searchBook"> <input
									type="hidden" name="bookId" value="${fmtBookId}"> <input
									type="hidden" name="userId" value="${fmtUserId}">
								<button type="submit" class="action-btn">返却</button>
							</form></td>
					</tr>
				</c:forEach>
				<!-- 取得件数が5件未満の場合、デザイン維持のために空行を追加 -->
				<c:if test="${empty rentalList || rentalList.size() < 5}">
					<c:forEach begin="${empty rentalList ? 1 : rentalList.size() + 1}"
						end="5" var="i">
						<tr>
							<td>${(currentPage != null ? currentPage - 1 : 0) * 5 + i}</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</c:forEach>
				</c:if>
    </tbody>
  </table>
  
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-no">予約状況状況</th>
        <th class="col-id">図書ID</th>
        <th class="col-title">書名</th>
        <th class="col-date">予約日</th>
        <th class="col-name">利用者名</th>
        <th class="col-action">操作</th>
      </tr>
    </thead>
    <tbody>
				<!-- Servletから受け取った図書リストをループで表示 -->
				<c:forEach var="reserve" items="${reserveList}" varStatus="status">
					<tr>
						<td>${((currentPage != null ? currentPage : 1) - 1) * 5 + status.count}</td>
						<%-- 						<td><c:out value="${reserve.lendId}" /></td> --%>
						<td><c:out value="${reserve.bookId}" /></td>
						<td><c:out value="${reserve.title}" /></td>
						<td><c:out value="${reserve.reserveDate}" /></td>
						<td><c:out value="${reserve.userName}" /></td>
						<%-- 						<td><c:out value="${book.bookClass}" /></td> --%>


						<td class="col-action-cell">
							<fmt:formatNumber value="${reserve.bookId}" pattern="000000" var="fmtBookId" />
							<fmt:formatNumber value="${sessionScope.loginUser.userId}" pattern="000000" var="fmtUserId" />

			    <form action="${pageContext.request.contextPath}/reserveSearch" method="post" style="display:inline;">
			        <input type="hidden" name="action" value="searchBook">
			        <input type="hidden" name="bookId" value="${fmtBookId}">
			        <input type="hidden" name="userId" value="${fmtUserId}">
			        <button type="submit" class="action-btn">取り消し</button>
			    </form>
						</td>
					</tr>
				</c:forEach>
				<!-- 取得件数が5件未満の場合、デザイン維持のために空行を追加 -->
				<c:if test="${empty reserveList || reserveList.size() < 5}">
					<c:forEach begin="${empty reserveList ? 1 : reserveList.size() + 1}"
						end="5" var="i">
						<tr>
							<td>${(currentPage != null ? currentPage - 1 : 0) * 5 + i}</td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</c:forEach>
				</c:if>
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