<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ page import="Model.UsersBean"%>
<%
// ログインユーザーの区分に応じて遷移先URLを決定する処理
UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null)
	loginUserObj = session.getAttribute("user");
if (loginUserObj == null)
	loginUserObj = session.getAttribute("login");
if (loginUserObj != null && loginUserObj instanceof UsersBean) {
	loginUser = (UsersBean) loginUserObj;
}

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
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>返却期限超過の貸出一覧</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/F-09.css?v=2">
</head>
<body>
	<div class="header">
		<h1 class="header-title">返却期限超過の貸出一覧</h1>
		<button class="menu-button header-blue-button"
			onclick="location.href='<%=menuUrl%>'">メニュー</button>
	</div>

	<div class="search-container">
		<form action="" method="post" id="searchForm">
			<table class="search-table">
				<tr>
					<th class="search-col-item border-bottom-gap">検索項目</th>
					<th class="search-col-value border-bottom">検索値</th>
					<td rowspan="2" class="search-col-buttons">
						<button type="submit" class="action-btn">検索</button>
						<button type="button" class="action-btn"
							onclick="location.href=''">条件クリア</button>
					</td>
				</tr>
				<tr>
					<td class="search-col-item border-bottom-gap"><select
						class="search-select" name="searchType">
							<option value="all"
								${param.searchType == 'all' ? 'selected' : ''}>すべての項目▼</option>
							<option value="bookId"
								${param.searchType == 'bookId' ? 'selected' : ''}>図書ID</option>
							<option value="title"
								${param.searchType == 'title' ? 'selected' : ''}>書名</option>
							<option value="userId"
								${param.searchType == 'userId' ? 'selected' : ''}>利用者ID</option>
					</select></td>
					<td class="search-col-value border-bottom"><input type="text"
						class="search-input" name="keyword"
						value="<c:out value='${param.keyword}'/>" autocomplete="off">
					</td>
				</tr>
			</table>
		</form>
	</div>

	<div class="table-container">
		<p class="result-message">
			<c:if test="${pageContext.request.method == 'POST'}">
        「<c:out value="${param.keyword}" />」の検索結果（※現在はデモ表示です）
    </c:if>
		</p>

		<table class="custom-table">
			<thead>
				<tr>
					<th class="col-no">No.</th>
					<th class="col-book-id">図書ID</th>
					<th class="col-title">書名</th>
					<th class="col-user-id text-center">利用者ID</th>
					<th class="col-return-line text-center">返却期限</th>
					<th class="col-action text-center">操作</th>
				</tr>
			</thead>
			<tbody>
				<!-- Servletから受け取った図書リストをループで表示 -->
				<c:forEach var="rental" items="${rentalList}" varStatus="status">
					<fmt:formatNumber value="${rental.bookId}" pattern="000000"
						var="fmtBookId" />
					<%-- 							<fmt:formatNumber value="${sessionScope.loginUser.userId}" pattern="000000" var="fmtUserId" /> --%>
					<fmt:formatNumber value="${rental.userId}" pattern="000000"
						var="fmtUserId" />
					<tr>
						<td>${((currentPage != null ? currentPage : 1) - 1) * 10 + status.count}</td>
						<%-- 						<td><c:out value="${rental.lendId}" /></td> --%>
						<td><c:out value="${fmtBookId}" /></td>
						<td><c:out value="${rental.title}" /></td>
						<td><c:out value="${fmtUserId}" /></td>
						<td><c:out value="${rental.returnDeadline}" /></td>
						<%-- 						<td><c:out value="${book.bookClass}" /></td> --%>


						<td class="col-action-cell">
							<form action="${pageContext.request.contextPath}/returnBook">
								<input type="hidden" name="action" value="searchBook"> <input
									type="hidden" name="bookId" value="${fmtBookId}"> <input
									type="hidden" name="userId" value="${fmtUserId}">
								<button type="submit" class="action-btn">返却</button>
							</form>
						</td>
					</tr>
				</c:forEach>

				<!-- 取得件数が10件未満の場合、デザイン維持のために空行を追加 -->
				<c:if test="${empty rentalList || rentalList.size() < 10}">
					<c:forEach begin="${empty rentalList ? 1 : rentalList.size() + 1}"
						end="10" var="i">
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

	<script>
		function goToMenu() {
			window.location.href = 'F-3.bookManagement.jsp';
		}
	</script>
</body>
</html>