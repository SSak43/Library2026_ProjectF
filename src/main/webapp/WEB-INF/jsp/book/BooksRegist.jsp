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
<title>図書登録</title>
</head>
<body>
	<form action="/Library2026_ProjectF/BooksRegist" method="POST">
		<table border="1">
		<tr>
		<td>書名</td>
		<td></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		<tr>
		<td>著者</td>
		<td></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		<tr>
		<td>出版社</td>
		<td></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>		
		<tr>
		<td>分類</td>
		<td></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		</table>
	</form>
</body>
</html>