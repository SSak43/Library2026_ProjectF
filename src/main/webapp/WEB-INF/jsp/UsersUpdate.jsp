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
<title>利用者情報更新</title>
</head>
<body>
<h1>更新入力画面</h1>
<a href="/Library2026_ProjectF/UsersMain">戻る</a>
	<form action="/Library2026_ProjectF/UsersUpdate" method="GET">
			<input type="text" name="userId" placeholder="利用者IDを入力">
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
			String adminMark = "0".equals(uClass) ? "<input type='radio' name='cla' value='0' checked>" : "<input type='radio' name='cla' value='0'>";
			String libMark   = "1".equals(uClass) ? "<input type='radio' name='cla' value='1' checked>" : "<input type='radio' name='cla' value='1'>";
			String userMark  = "2".equals(uClass) ? "<input type='radio' name='cla' value='2' checked>" : "<input type='radio' name='cla' value='2'>";
					
/* 			String adminMark = "0".equals(uClass) ? "<span style='color:blue;'>■</span>" : "□";
			String libMark   = "1".equals(uClass) ? "<span style='color:blue;'>■</span>" : "□";
			String userMark  = "2".equals(uClass) ? "<span style='color:blue;'>■</span>" : "□"; */
			String classDisplay = adminMark + "管理者 " + libMark + "司書 " + userMark + "利用者";

			// ＝＝＝ 状態の表示文字列を作成（※値はDB設定に合わせて修正してください） ＝＝＝
			String uStatus = usersBean.getUserStatus();
			String normalMark = "0".equals(uStatus) ? "<input type='radio' name='status' value='0' checked>" : "<input type='radio' name='status' value='0'>";
			String stopMark   = "1".equals(uStatus) ? "<input type='radio' name='status' value='1' checked>" : "<input type='radio' name='status' value='1'>";			
			// 			String normalMark = "0".equals(uStatus) ? "<span style='color:green;'>■</span>" : "□";
// 			String stopMark   = "1".equals(uStatus) ? "<span style='color:red;'>■</span>" : "□";
			String statusDisplay = normalMark + "可 " + stopMark + "不可";
	%>
	
	<form action="/Library2026_ProjectF/UsersUpdate" method="POST">
	
	<input type="hidden" name="userId" value="<%= usersBean.getUserId() %>">
	
	<table><tr><th>区分</th><td><%=classDisplay %></td></tr></table>
	
	<table border="1">
		<tr>
			<td>氏名</td>
			<td><input type="text" name="userName" value="<%=usersBean.getUserName()%>"></td>
		</tr>
		<tr>
			<td>電話番号</td>
			<td><input type="text" name="Tel" value="<%=usersBean.getTel()%>"></td>
		</tr>
		<tr>
			<td>パスワード変更</td>
			<td><input type="text" name="Password" placeholder="変更する場合のみ入力"></td>	
		</tr>
	</table>
	
		<table><tr><th>利用</th><td><%=statusDisplay %></td></tr></table>
	
	<% } %>
			<input type="submit" value="登録">
	</form>
</body>
</html>