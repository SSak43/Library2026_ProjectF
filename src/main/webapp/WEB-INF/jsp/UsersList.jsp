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
<title>利用者情報</title>
</head>
<body>
	<h1>利用者一覧</h1>
	<form action="UsersListServlet" method="GET">
		<!-- 		<p>検索方法：</p> -->
		<!-- 		<input type="radio" name="mode" value="idQuery">利用者ID -->
		<!-- 		<input type="radio" name="mode" value="nameQuery">氏名 -->

		<p>
			利用者IDを入力<br> <input type="text" name="userId"><br>
			<!-- 			利用者氏名を入力<br> -->
			<!-- 			<input type="text" name="userName"> -->
		</p>
		<table border="1">
			<tr>
				<th>区分</th>
				<td><input type="radio" name="cla" value="0">管理者
				</td>
				<td>
		<input type="radio" name="cla" value="1">司書</td>
				<td>
		<input type="radio" name="cla" value="2">利用者
		</td>
			</tr>
		</table>
		<input type="submit" value="表示">
		<input type="reset" value="リセット">
	</form>
	<% 
		// リストが空っぽじゃない（1件以上データがある）時だけ表示する
		if (usersList != null && usersList.size() > 0) { 
			// リストの先頭（0番目）のデータを取り出して、firstUser という名前をつける
			UsersBean usersBean = usersList.get(0);
	%>
	<table border="1">
		<tr>
			<td>氏名</td>
			<td><%=usersBean.getUserName()%></td>
		</tr>
		<tr>
			<td>電話番号</td>
			<td><%=usersBean.getTel()%></td>
		</tr>
		<tr>
			<td>パスワード</td>
			<td><%=usersBean.getPassword()%></td>
		</tr>
	</table>
	<% } %>
	
<!-- 	<table border="1"> -->
<!-- 		<tr> -->
<!-- 			<th>利用者ID</th> -->
<!-- 			<th>氏名</th> -->
<!-- 			<th>電話番号</th> -->
<!-- 			<th>ログインID</th> -->
<!-- 			<th>パスワード</th> -->
<!-- 			<th>区分</th> -->
<!-- 			<th>状態</th> -->
<!-- 			<th>登録日</th> -->
<!-- 			<th>更新日</th> -->
<!-- 		</tr> -->
<%-- 		<% --%>
<!-- // 		if (usersList != null) { -->
<%-- 		%> --%>
<%-- 		<% --%>
<!-- // 		for (UsersBean usersBean : usersList) { -->
<%-- 		%> --%>
<!-- 		<tr> -->
<%-- 			<td><%=usersBean.getUserId()%></td> --%>
<%-- 			<td><%=usersBean.getUserName()%></td> --%>
<%-- 			<td><%=usersBean.getTel()%></td> --%>
<%-- 			<td><%=usersBean.getLoginId()%></td> --%>
<%-- 			<td><%=usersBean.getPassword()%></td> --%>
<%-- 			<td><%=usersBean.getUserClass()%></td> --%>
<%-- 			<td><%=usersBean.getUserStatus()%></td> --%>
<%-- 			<td><%=usersBean.getUserRegist()%></td> --%>
<%-- 			<td><%=usersBean.getUserUpdate()%></td> --%>
<!-- 		</tr> -->
<%-- 		<% --%>
<!-- // 		} -->
<%-- 		%> --%>
<%-- 		<% --%>
<!-- // 		} -->
<%-- 		%> --%>
<!-- 	</table> -->

	
</body>
</html>