<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean, java.util.List"%>
<%
List<UsersBean> usersList = (List<UsersBean>) session.getAttribute("usersList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>利用者登録</title>
</head>
<body>
	<h1>利用者登録</h1>
	<a href="UsersMainServlet">戻る</a>
	<form action="UsersRegistServlet" method="POST">
		<table border="1">
			<tr>
				<th>区分</th>
				<td><input type="radio" name="cla" value="0">管理者</td>
				<td><input type="radio" name="cla" value="1">司書</td>
				<td><input type="radio" name="cla" value="2">利用者</td>
			</tr>
		</table>
	</form>
</body>
</html>