<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.BooksBean, java.util.List"%>
<%
List<BooksBean> booksList = (List<BooksBean>) session.getAttribute("booksList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/Library2026_ProjectF/css/home.css">
</head>
<body>
	<div class="header">
		<h1 class="header-title">蔵書検索画面</h1>
		<button class="menu-button" type="button"
			onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
		<!-- 		<a href="/Library2026_ProjectF/BooksMain">戻る</a> -->
	</div>
	<form action="${pageContext.request.contextPath}/BooksSearch" method="GET" id="searchForm">
				<input type="text" name="bookId" placeholder="図書IDを入力">
		<input type="submit" value="表示">
	</form>
	
	<%
		String searchedId = request.getParameter("bookId");
	boolean isIdSearch = (searchedId != null && !searchedId.isEmpty());

	if (isIdSearch && booksList != null && booksList.size() > 0){
		BooksBean booksBean = booksList.get(0);
		
		String bStatus = booksBean.getBookStatus();
		
		String ok = "0".equals(bStatus) ? "<span style='color:blue;'>■</span>" : "□";
		String now = "1".equals(bStatus) ? "<span style='color:blue;'>■</span>" : "□";
		String ng = "2".equals(bStatus) ? "<span style='color:blue;'>■</span>" : "□";
		String statusDisplay = ok + "貸出可" + now + "貸出中" + ng + "貸出不可";
	%>
	
	<table>
	<tr><td>書名</td><td><%=booksBean.getTitle() %></td></tr>
	<tr><td>著者</td><td><%=booksBean.getWriterName() %></td></tr>
	<tr><td>出版社</td><td><%=booksBean.getCompany() %></td></tr>
	<tr><td>分類</td><td><%=booksBean.getBookClass() %></td></tr>	
	</table>
	
	<table><tr><td>貸出状況</td><td><%=statusDisplay %></td></tr></table>
		<% } %>
</body>
</html>