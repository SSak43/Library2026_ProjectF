<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ page import="Model.UsersBean"%>
<%
//ログインユーザーの区分に応じて遷移先URLを決定する処理
UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null)
	loginUserObj = session.getAttribute("user");
if (loginUserObj == null)
	loginUserObj = session.getAttribute("login");
if (loginUserObj != null && loginUserObj instanceof UsersBean) {
	loginUser = (UsersBean) loginUserObj;
}
String uClass = loginUser.getUserClass();
%>


<td>${reserve.reserveId }</td>

<td><fmt:formatNumber value="${reserve.reserveId}" pattern="000000" /></td>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>予約状況</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/F-08.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/home.css">
</head>
<body>
	<div class="header">
		<h1 class="header-title">予約状況</h1>
		<button class="menu-button" type="button"
			onclick="location.href='${pageContext.request.contextPath}/InquiryManagementServlet'">メニュー</button>
	</div>
	<!-- 新しく追加した検索エリア -->
	<div class="search-container">
		<form action="${pageContext.request.contextPath}/reserveStatusInquiry"
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
							<%
							if (!"2".equals(uClass)) {
							%>
							<option value="userId"
								${searchCategory == 'userId' ? 'selected' : ''}>利用者ID</option>
							<option value="name"
								${searchCategory == 'name' ? 'selected' : ''}>利用者氏名</option>
							<%
							}
							%>
							<!--           <option>著者</option> -->
							<!--           <option>出版社</option> -->
					</select></td>

					<td class="search-col-value border-bottom"><c:choose>
							<%-- 【ID検索の場合】 6桁数字制限の属性を付与 --%>
							<c:when
								test="${searchCategory == 'bookId' || searchCategory == 'userId'}">
								<input type="text" class="search-input" name="searchKeyword"
									value="<c:out value='${param.searchKeyword}'/>"
									autocomplete="off" autofocus inputmode="numeric" maxlength="6"
									pattern="[0-9]{6}" placeholder="6桁の数字を入力"
									oninvalid="this.setCustomValidity('6桁の数字（例: 123456）を入力してください')"
									oninput="this.setCustomValidity('')">
							</c:when>

							<%-- 【それ以外の場合】 制限なし --%>
							<c:otherwise>
								<input type="text" class="search-input" name="searchKeyword"
									value="<c:out value='${param.searchKeyword}'/>"
									autocomplete="off" autofocus placeholder="キーワードを入力">
							</c:otherwise>
						</c:choose></td>
				</tr>
			</table>
		</form>
	</div>

	<!-- 既存の表エリア -->
	<div class="table-container">
		<p class="result-message">
			<c:choose>
				<c:when test="${reserveList.size() > 0}">
     		   ${currentPage}ページ目：${reserveList.size()}件の図書を表示しています。
     			 </c:when>
				<c:otherwise>
       		 条件に一致する図書が見つかりませんでした。
     		 </c:otherwise>
			</c:choose>
		</p>

		<table class="custom-table">
			<thead>
				<tr>
					<th class="col-no">No.</th>
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
					<fmt:formatNumber value="${reserve.bookId}" pattern="000000"
						var="fmtBookId" />
					<%-- 							<fmt:formatNumber value="${sessionScope.loginUser.userId}" pattern="000000" var="fmtUserId" /> --%>
					<fmt:formatNumber value="${reserve.userId}" pattern="000000"
						var="fmtUserId" />
					<tr>
						<td>${((currentPage != null ? currentPage : 1) - 1) * 10 + status.count}</td>
						<%-- 						<td><c:out value="${reserve.lendId}" /></td> --%>
						<td><c:out value="${fmtBookId}" /></td>
						<td><c:out value="${reserve.title}" /></td>
						<td><c:out value="${reserve.reserveDate}" /></td>
						<td><c:out value="${reserve.userName}" /></td>
						<%-- 						<td><c:out value="${book.bookClass}" /></td> --%>


						<td class="col-action-cell">


							<form action="${pageContext.request.contextPath}/userStatus">
								<input type="hidden" name="action" value="searchBook"> <input
									type="hidden" name="bookId" value="${fmtBookId}"> <input
									type="hidden" name="userId" value="${fmtUserId}">
								<button type="submit" class="action-btn">詳細</button>
							</form>
						</td>
					</tr>
				</c:forEach>
				<!-- 取得件数が10件未満の場合、デザイン維持のために空行を追加 -->
				<c:if test="${empty reserveList || reserveList.size() < 10}">
					<c:forEach
						begin="${empty reserveList ? 1 : reserveList.size() + 1}" end="10"
						var="i">
						<tr>
							<td>${(currentPage != null ? currentPage - 1 : 0) * 10 + i}</td>
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