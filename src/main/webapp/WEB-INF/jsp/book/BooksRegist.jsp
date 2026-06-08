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
<h1>図書登録</h1>
	<a href="/Library2026_ProjectF/BooksMain">戻る</a>
	<form action="/Library2026_ProjectF/BooksRegist" method="POST">
		<table border="1">
		<tr>
		<td>書名</td>
		<td><input type="text" name="title"</td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		<tr>
		<td>著者</td>
		<td><input type="text" name="writerName"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		<tr>
		<td>出版社</td>
		<td><input type="text" name="company"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>		
		<tr>
		<td>分類</td>
		<td><input type="text" name="cla"></td>		
		<td><input type="reset" value="リセット"></td>
		</tr>
		</table>
		<input type="submit" value="登録">
	</form>
</body>
</html>