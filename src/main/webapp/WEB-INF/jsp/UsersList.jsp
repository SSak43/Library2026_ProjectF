<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="Model.UsersBean, java.util.List" %>
    <%
    	List<UsersBean> usersList = (List<UsersBean>) session.getAttribute("usersList");
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>利用者情報</title>
</head>
<body> 
	<h1>利用者一覧</h1>
	<form action="UsersListServlet" method="GET">
		<p>検索方法：</p>
		<input type="radio" name="mode" value="idQuery">利用者ID
		<input type="radio" name="mode" value="nameQuery">氏名
		
		<p>
			キーワード：（氏名の一部、利用者IDを入力してください）<br>
			<input type="text" name="name">
		</p>
		<input type="submit" value="検索">
		<input type="reset" value="リセット">
	</form>
	<table border="1">
		<tr><th>利用者ID</th><th>氏名</th><th>電話番号</th><th>ログインID</th><th>パスワード</th><th>区分</th><th>状態</th><th>登録日</th><th>更新日</th></tr>
		<% if (usersList != null){ %><% for (UsersBean usersBean : usersList){ %>
		<tr><td><%=usersBean.getUserId() %></td><td><%=usersBean.getUserName() %></td><td><%=usersBean.getTel() %></td><td><%=usersBean.getLoginId() %></td><td><%=usersBean.getPassword() %></td><td><%=usersBean.getUserClass() %></td><td><%=usersBean.getUserStatus() %></td><td><%=usersBean.getUserRegist() %></td><td><%=usersBean.getUserUpdate() %></td></tr>
		<% } %><% } %>
	</table>
	
	
</body>
</html>