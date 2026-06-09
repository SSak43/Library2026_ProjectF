<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ page import="Model.BooksBean, java.util.List" %>
    <%
List<BooksBean> booksList = (List<BooksBean>) session.getAttribute("booksList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>蔵書更新</h1>
	<a href="/Library2026_ProjectF/BooksMain">戻る</a>
	<form action="/Library2026_ProjectF/BooksUpdate" method="GET">
				<input type="text" name="bookId" placeholder="図書IDを入力">
		<input type="submit" value="表示">
	</form>
	<%
		String searchedId = request.getParameter("bookId");
	boolean isIdSearch = (searchedId != null && !searchedId.isEmpty());

	if (isIdSearch && booksList != null && booksList.size() > 0){
		BooksBean booksBean = booksList.get(0);
		
		String bStatus = booksBean.getBookStatus();
		
		String ok = "0".equals(bStatus) ? "<input type='radio' name='status' value='0' checked>" : "<input type='radio' name='status' value='0'>";
		String now = "1".equals(bStatus) ? "<input type='radio' name='status' value='1' checked>" : "<input type='radio' name='status' value='1'>";
		String ng = "2".equals(bStatus) ? "<input type='radio' name='status' value='2' checked>" : "<input type='radio' name='status' value='2'>";
		String statusDisplay = ok + "貸出可" + now + "貸出中" + ng + "貸出不可";
	%>
	
	<form action="/Library2026_ProjectF/BooksUpdate" method="POST">
	<input type="hidden" name="bookId" value="<%= booksBean.getBookId() %>">
			<table border="1">
		<tr>
		<td>書名</td>
		<td><input type="text" name="title" value="<%= booksBean.getTitle() %>"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		<tr>
		<td>著者</td>
		<td><input type="text" name="writerName" value="<%= booksBean.getWriterName() %>"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		<tr>
		<td>出版社</td>
		<td><input type="text" name="company" value="<%= booksBean.getCompany() %>"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>		
		<tr>
		<td>分類</td>
		<td><input type="text" name="cla" value="<%= booksBean.getBookClass() %>"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		</table>
		
				<table><tr><th>貸出状況</th><td><%=statusDisplay %></td></tr></table>
		
		
		<input type="submit" value="登録">
	
	
	</form>
	<% } %>
</body>
</html>