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
	<h1>利用者一覧</h1><a href="UsersMainServlet">戻る</a>
	<form action="UsersSearchServlet" method="GET">
		<!-- 		<p>検索方法：</p> -->
		<!-- 		<input type="radio" name="mode" value="idQuery">利用者ID -->
		<!-- 		<input type="radio" name="mode" value="nameQuery">氏名 -->


			<input type="text" name="userId" placeholder="利用者IDを入力">
			
<!-- 			氏名での検索 -->
			<!-- 			利用者氏名を入力<br> -->
			<!-- 			<input type="text" name="userName"> -->
			
<!-- 			区分ごとでの検索 -->
<!-- 		<table border="1"> -->
<!-- 			<tr> -->
<!-- 				<th>区分</th> -->
<!-- 				<td><input type="radio" name="cla" value="0">管理者 -->
<!-- 				</td> -->
<!-- 				<td> -->
<!-- 		<input type="radio" name="cla" value="1">司書</td> -->
<!-- 				<td> -->
<!-- 		<input type="radio" name="cla" value="2">利用者 -->
<!-- 		</td> -->
<!-- 			</tr> -->
<!-- 		</table> -->

		<input type="submit" value="表示">



	</form>
	<% 
		// URLパラメータから userId を取得し、入力されているかチェック
		String searchedId = request.getParameter("userId");
		boolean isIdSearch = (searchedId != null && !searchedId.isEmpty());

		// ID検索がされていて、かつ結果が1件以上ある時だけ表示
		if (isIdSearch && usersList != null && usersList.size() > 0) { 
			UsersBean usersBean = usersList.get(0);
			
			// ＝＝＝ 区分の表示文字列を作成 ＝＝＝
			String uClass = usersBean.getUserClass();
			// 三項演算子（条件 ? trueの時 : falseの時）を使ってシンプルに記述
			String adminMark = "0".equals(uClass) ? "<span style='color:blue;'>■</span>" : "□";
			String libMark   = "1".equals(uClass) ? "<span style='color:blue;'>■</span>" : "□";
			String userMark  = "2".equals(uClass) ? "<span style='color:blue;'>■</span>" : "□";
			String classDisplay = adminMark + "管理者 " + libMark + "司書 " + userMark + "利用者";

			// ＝＝＝ 状態の表示文字列を作成（※値はDB設定に合わせて修正してください） ＝＝＝
			String uStatus = usersBean.getUserStatus();
			String normalMark = "0".equals(uStatus) ? "<span style='color:green;'>■</span>" : "□";
			String stopMark   = "1".equals(uStatus) ? "<span style='color:red;'>■</span>" : "□";
			String statusDisplay = normalMark + "可 " + stopMark + "不可";
	%>
	
	<table><tr><th>区分</th><td><%=classDisplay %></td></tr></table>
	
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
	
		<table><tr><th>利用</th><td><%=statusDisplay %></td></tr></table>
	
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
<!-- 更新用 -->

	
</body>
</html>