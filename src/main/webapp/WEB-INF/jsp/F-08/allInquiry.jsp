<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean"%>
<!DOCTYPE html>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%-- <% --%>
<!-- // //ログインユーザーの区分に応じて遷移先URLを決定する処理 -->
<!-- // UsersBean loginUser = null; -->
<!-- // Object loginUserObj = session.getAttribute("loginUser"); -->
<!-- // if (loginUserObj == null) -->
<!-- // 	loginUserObj = session.getAttribute("user"); -->
<!-- // if (loginUserObj == null) -->
<!-- // 	loginUserObj = session.getAttribute("login"); -->
<!-- // if (loginUserObj != null && loginUserObj instanceof UsersBean) { -->
<!-- // 	loginUser = (UsersBean) loginUserObj; -->
<!-- // } -->
<!-- // String uClass = loginUser.getUserClass(); -->
<%-- %> --%>
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
String userClassStr = "";
String uClass = loginUser.getUserClass();
if (loginUser != null) {
	userClassStr = uClass;
	if ("0".equals(uClass) || "管理者".equals(uClass)) {
		menuUrl = request.getContextPath() + "/home/admin_home.jsp";
	} else if ("1".equals(uClass) || "司書".equals(uClass)) {
		menuUrl = request.getContextPath() + "/home/sisyo_home.jsp";
	} else if ("2".equals(uClass) || "利用者".equals(uClass)) {
		menuUrl = request.getContextPath() + "/home/riyousyahome.jsp";
	}
}
pageContext.setAttribute("currentUserClass", userClassStr);
%>

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
<script>
window.addEventListener('DOMContentLoaded', () => {
    // クラス名「search-input」が付いた入力欄を取得
    const searchInput = document.querySelector('.search-input');
    
    if (searchInput) {
        // 一度フォーカスを当てる
        searchInput.focus();
        
        // 入力されている文字の長さを取得
        const len = searchInput.value.length;
        
        // カーソルの選択範囲を開始位置・終了位置ともに末尾に設定する
        searchInput.setSelectionRange(len, len);
    }
});

function clearForm(button) {
    // ボタンから見て一番近い <form> 要素を取得
    const form = button.closest('form');
    
    // フォーム内のテキスト入力欄をすべて空にする
    const inputs = form.querySelectorAll('.search-input');
    inputs.forEach(input => {
        input.value = '';
    });
    
    // セレクトボックスを一番上の項目（すべての項目）に戻す
    const select = form.querySelector('.search-select');
    if (select) {
        select.selectedIndex = 0;
    }
}
</script>
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
						<button type="button" class="action-btn" onclick="clearForm(this)">リセット</button>
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
						</c:choose>
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
					<fmt:formatNumber value="${rental.bookId}" pattern="000000"
						var="fmtBookId" />
					<fmt:formatNumber value="${sessionScope.loginUser.userId}"
						pattern="000000" var="fmtUserId" />
					<tr>
						<td>${((currentPageRental != null ? currentPageRental : 1) - 1) * 5 + status.count}</td>
						<%-- 						<td><c:out value="${rental.lendId}" /></td> --%>
						<td><c:out value="${fmtBookId}" /></td>
						<td><c:out value="${rental.title}" /></td>
						<td><c:out value="${rental.loanDate}" /></td>
						<td><c:out value="${rental.returnDeadline}" /></td>
						<%-- 						<td><c:out value="${book.bookClass}" /></td> --%>


						<td class="col-action-cell">
<%-- 							<c:choose>	追加：利用者の場合はボタンを表示 --%>
<%-- 								<c:when test="${uClass == '2'}"> --%>
<!-- 									<span -->
<!-- 										style="display: inline-block; padding: 5px 12px; background-color: #e0e0e0; color: #555; border-radius: 4px; font-size: 0.9rem; font-weight: bold; border: 1px solid #ccc; letter-spacing: 0.05em; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">窓口返却</span> -->
<%-- 								</c:when> --%>
<%-- 								追加：管理者・司書の場合は今まで通り貸出ボタンを表示 --%>
<%-- 								<c:otherwise> --%>
<%-- 									<form action="${pageContext.request.contextPath}/returnBook" --%>
<!-- 										method="post" style="display: inline;"> -->
<!-- 										<input type="hidden" name="action" value="searchBook"> -->
<%-- 										<input type="hidden" name="bookId" value="${fmtBookId}"> --%>
<%-- 										<input type="hidden" name="userId" value="${fmtUserId}"> --%>
<!-- 										<button type="submit" class="action-btn">返却</button> -->
<!-- 									</form> -->
<%-- 								</c:otherwise> --%>
<%-- 							</c:choose> --%>
							
							<% if (!"2".equals(uClass)) { %>
							<form action="${pageContext.request.contextPath}/returnBook">
								<input type="hidden" name="action" value="searchBook"> <input
									type="hidden" name="bookId" value="${fmtBookId}"> <input
									type="hidden" name="userId" value="${fmtUserId}">
								<button type="submit" class="action-btn" style="margin-bottom: 10px;">返却</button>
								<!-- 							</form> -->
								<%
								} else{
								%>
								<span style="display: inline-block; padding: 5px 12px; background-color: #e0e0e0; color: #555; border-radius: 4px; font-size: 0.9rem; font-weight: bold; border: 1px solid #ccc; letter-spacing: 0.05em; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);">窓口返却</span>
								<% } %>
							</td>
					</tr>
				</c:forEach>
				<!-- 取得件数が5件未満の場合、デザイン維持のために空行を追加 -->
				<c:if test="${empty rentalList || rentalList.size() < 5}">
					<c:forEach begin="${empty rentalList ? 1 : rentalList.size() + 1}"
						end="5" var="i">
						<tr>
							<td>${(currentPageRental != null ? currentPageRental - 1 : 0) * 5 + i}</td>
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
		<c:choose>
			<c:when test="${currentPageRental > 1}">
				<button type="button" onclick="location.href='${pageContext.request.contextPath}/userStatus?pageRental=${currentPageRental - 1}&pageReserve=${currentPageReserve}'">◀</button>
			</c:when>
			<c:otherwise>
				<button type="button" disabled style="opacity: 0.5;">◀</button>
			</c:otherwise>
		</c:choose>

		<span style="margin: 0 15px; align-self: center;">${currentPageRental} / ${maxPageRental != null ? maxPageRental : 1}</span>

		<c:choose>
			<c:when test="${currentPageRental < maxPageRental}">
				<button type="button" onclick="location.href='${pageContext.request.contextPath}/userStatus?pageRental=${currentPageRental + 1}&pageReserve=${currentPageReserve}'">▶</button>
			</c:when>
			<c:otherwise>
				<button type="button" disabled style="opacity: 0.5;">▶</button>
			</c:otherwise>
		</c:choose>
	</div>
</div>
		<table class="custom-table">
			<thead>
				<tr>
					<th class="col-no">予約状況</th>
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
					<fmt:formatNumber value="${sessionScope.loginUser.userId}"
						pattern="000000" var="fmtUserId" />
					<tr>
						<td>${((currentPageReserve != null ? currentPageReserve : 1) - 1) * 5 + status.count}</td>
						<%-- 						<td><c:out value="${reserve.lendId}" /></td> --%>
						<td><c:out value="${fmtBookId}" /></td>
						<td><c:out value="${reserve.title}" /></td>
						<td><c:out value="${reserve.reserveDate}" /></td>
						<td><c:out value="${reserve.userName}" /></td>
						<%-- 						<td><c:out value="${book.bookClass}" /></td> --%>


						<td class="col-action-cell">

							<form action="${pageContext.request.contextPath}/reserveSearch"
								method="post" style="display: inline;">
								<input type="hidden" name="action" value="searchBook"> <input
									type="hidden" name="bookId" value="${fmtBookId}"> <input
									type="hidden" name="userId" value="${fmtUserId}">
								<button type="submit" class="action-btn" style="margin-bottom: 5px;">取り消し</button>
							</form>
						</td>
					</tr>
				</c:forEach>
				<!-- 取得件数が5件未満の場合、デザイン維持のために空行を追加 -->
				<c:if test="${empty reserveList || reserveList.size() < 5}">
					<c:forEach
						begin="${empty reserveList ? 1 : reserveList.size() + 1}" end="5"
						var="i">
						<tr>
							<td>${(currentPageReserve != null ? currentPageReserve - 1 : 0) * 5 + i}</td>
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
		<c:choose>
			<c:when test="${currentPageReserve > 1}">
				<button type="button" onclick="location.href='${pageContext.request.contextPath}/userStatus?pageReserve=${currentPageReserve - 1}&pageRental=${currentPageRental}'">◀</button>
			</c:when>
			<c:otherwise>
				<button type="button" disabled style="opacity: 0.5;">◀</button>
			</c:otherwise>
		</c:choose>

		<span style="margin: 0 15px; align-self: center;">${currentPageReserve} / ${maxPageReserve != null ? maxPageReserve : 1}</span>

		<c:choose>
			<c:when test="${currentPageReserve < maxPageReserve}">
				<button type="button" onclick="location.href='${pageContext.request.contextPath}/userStatus?pageReserve=${currentPageReserve + 1}&pageRental=${currentPageRental}'">▶</button>
			</c:when>
			<c:otherwise>
				<button type="button" disabled style="opacity: 0.5;">▶</button>
			</c:otherwise>
		</c:choose>
	</div>
</div>
	</div>
</body>
</html>