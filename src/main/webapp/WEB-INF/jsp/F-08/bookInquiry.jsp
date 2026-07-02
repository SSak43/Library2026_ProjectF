<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="Model.UsersBean"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%
// ログインユーザーの区分に応じて遷移先URLを決定する処理
UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null) loginUserObj = session.getAttribute("user");
if (loginUserObj == null) loginUserObj = session.getAttribute("login");
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


<td>${lend.lendId}</td>

<td><fmt:formatNumber value="${lend.lendId}" pattern="000000" /></td>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>貸出状況</title>
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
</script>
	<div class="header">
		<h1 class="header-title">貸出状況</h1>
		<button class="menu-button" type="button"
			onclick="location.href='${pageContext.request.contextPath}/InquiryManagementServlet'">メニュー</button>
	</div>
	<!-- 新しく追加した検索エリア -->
	<div class="search-container">
		<form action="${pageContext.request.contextPath}/rentalSearch"
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
				<c:when test="${rentalList.size() > 0}">
     		   ${currentPage}ページ目：${rentalList.size()}件の図書を表示しています。
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
					<th class="col-date">貸出日</th>
					<th class="col-date">返却期限</th>
					<th class="col-action">操作</th>
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
						<td><c:out value="${rental.loanDate}" /></td>
						<td><c:out value="${rental.returnDeadline}" /></td>
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
		<c:choose>
			<c:when test="${currentPage > 1}">
				<button type="button" onclick="location.href='${pageContext.request.contextPath}/userStatus?page=${currentPage - 1}'">◀</button>
			</c:when>
			<c:otherwise>
				<button type="button" disabled style="opacity: 0.5;">◀</button>
			</c:otherwise>
		</c:choose>

		<span style="margin: 0 15px; align-self: center;">${currentPage} / ${maxPage != null ? maxPage : 1}</span>

		<c:choose>
			<c:when test="${currentPage < maxPage}">
				<button type="button" onclick="location.href='${pageContext.request.contextPath}/userStatus?page=${currentPage + 1}'">▶</button>
			</c:when>
			<c:otherwise>
				<button type="button" disabled style="opacity: 0.5;">▶</button>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</body>
</html>