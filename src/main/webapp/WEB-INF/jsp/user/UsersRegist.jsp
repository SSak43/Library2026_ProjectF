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
	<a href="/Library2026_ProjectF/UsersMain">戻る</a>
	<form action="/Library2026_ProjectF/UsersRegist" method="POST">
		<table border="1">
			<tr>
				<th>区分</th>
				<td><input type="radio" name="cla" value="0">管理者</td>
				<td><input type="radio" name="cla" value="1">司書</td>
				<td><input type="radio" name="cla" value="2">利用者</td>
			</tr>
		</table>
<%
    // Servletから送られてきた最新IDを受け取る（念のためnullチェック）
    Integer latestId = (Integer) request.getAttribute("latestId");
    if (latestId == null) {
        latestId = 0; // 万が一取得できなかった場合は0にしておく
    }
    // 次に割り当てられる予定のIDを計算しておく
    int nextId = latestId + 1;
%>
		<table>
			<tr>
				<td>氏名</td>
				<td><input type="text" name="userName"></td>
			</tr>
			<tr>
				<td>電話番号</td>
				<td><input type="text" name="Tel"></td>
			</tr>
			<tr>
				<td>利用者ID</td>
				<td><%= nextId %></td>
			</tr>
			<tr>
				<td>パスワード</td>
				<td><input type="text" name="Password"></td>
			</tr>
		</table>
		<input type="submit" value="登録">

	</form>
</body>
</html>