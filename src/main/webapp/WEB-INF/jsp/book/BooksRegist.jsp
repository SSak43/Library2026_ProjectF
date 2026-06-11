<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="Model.BooksBean, java.util.List"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>図書登録</title>
<link rel="stylesheet" href="/Library2026_ProjectF/css/home.css">
<link rel="stylesheet" href="/Library2026_ProjectF/css/F-03.css">
<link rel="stylesheet" href="/Library2026_ProjectF/css/register.css">
</head>
<body>
	<div class="header">
		<h1 class="header-title">図書登録入力画面</h1>
		<button class="menu-button" type="button"
			onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
		<!-- 		<a href="/Library2026_ProjectF/BooksMain">戻る</a> -->
	</div>
	<form action="${pageContext.request.contextPath}/BooksRegist"
		method="post" id="registForm">

		<div
			class="main-content-base layout-top-padding register-main-content">

			<div class="register-error-message" id="error-message"></div>

			<table class="form-table">
				<tr>
					<th>書名</th>
					<td><input type="text" class="input-field" id="input-title"
						name="title" autofocus required>
						<button type="button" class="clear-button"
							onclick="clearInput('input-title')" tabindex="-1">クリア</button></td>
				</tr>
				<tr>
					<th>著者</th>
					<td><input type="text" class="input-field"
						id="input-writerName" name="writerName" required>
						<button type="button" class="clear-button"
							onclick="clearInput('input-writerName')" tabindex="-1">クリア</button></td>
				</tr>
				<tr>
					<th>出版社</th>
					<td><input type="text" class="input-field" id="input-company"
						name="company" required>
						<button type="button" class="clear-button"
							onclick="clearInput('input-company')" tabindex="-1">クリア</button></td>
				</tr>
				<tr>
					<th>分類</th>
					<td><input type="text" class="input-field" id="input-cla"
						name="cla" required>
						<button type="button" class="clear-button"
							onclick="clearInput('input-cla')" tabindex="-1">クリア</button></td>
				</tr>
			</table>
			<div class="bottom-button-container">
				<button type="button" class="register-button"
					onclick="showConfirmModal()">登録</button>
			</div>

		</div>
		<div id="confirmModal" class="modal-overlay">
			<div class="modal-content">
				<div class="modal-title">登録確認</div>
				<table class="form-table">
					<tr>
						<th>書名</th>
						<td><input type="text" class="input-field w-full"
							id="confirm-title" readonly></td>
					</tr>
					<tr>
						<th>著者</th>
						<td><input type="text" class="input-field w-full"
							id="confirm-writerName" readonly></td>
					</tr>
					<tr>
						<th>出版社</th>
						<td><input type="text" class="input-field w-full"
							id="confirm-company" readonly></td>
					</tr>
					<tr>
						<th>分類</th>
						<td><input type="text" class="input-field w-full"
							id="confirm-cla" readonly></td>
					</tr>
				</table>

				<div class="modal-buttons-right">
					<button type="button" class="cancel-button modal-action-button"
						onclick="hideConfirmModal()">戻る</button>
					<button type="button" class="submit-button modal-action-button"
						onclick="submitForm()">登録</button>
				</div>
			</div>
		</div>

	</form>

	<div id="completeModal" class="modal-overlay">
		<div class="modal-content">
			<div class="modal-title">登録完了</div>
			<div style="text-align: center; margin: 20px 0;">登録が完了しました。</div>
			<div class="modal-buttons" style="justify-content: center;">
				<button type="button" class="submit-button"
					style="border: 1px solid #2f5597; background-color: white; padding: 8px 25px; font-size: 1rem;"
					onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">
					メニュー</button>
				<button type="button" class="submit-button"
					style="border: 1px solid #2f5597; background-color: white; padding: 8px 25px; font-size: 1rem;"
					onclick="location.href='${pageContext.request.contextPath}/UsersRegist'">
					続けて登録</button>
			</div>
		</div>
	</div>

	<script>
		function showConfirmModal() {
			const errorMessage = document.getElementById('error-message');
			const form = document.getElementById('registForm');
			errorMessage.style.visibility = 'hidden';

			// 未入力チェック（HTMLのrequired属性の検証）
			if (!form.checkValidity()) {
				errorMessage.innerText = "未入力の欄があります。すべての項目に記入してください。";
				errorMessage.style.visibility = 'visible';
				form.reportValidity();
				return;
			}

			// 入力値の取得（文字の種類の制限は行いません）
			const writerName = document.getElementById('input-writerName').value.trim();
			const title = document.getElementById('input-title').value.trim();
			const company = document.getElementById('input-company').value.trim();
			const cla = document.getElementById('input-cla').value.trim();

			// 値をセットして確認画面を表示
			document.getElementById('confirm-writerName').value = writerName;
			document.getElementById('confirm-title').value = title;
			document.getElementById('confirm-company').value = company;
			document.getElementById('confirm-cla').value = cla;

			document.getElementById('confirmModal').style.display = 'flex';
		}

		function hideConfirmModal() {
			document.getElementById('confirmModal').style.display = 'none';
		}

		function submitForm() {
			document.getElementById('registForm').submit();
		}
	</script>

	<c:if test="${isSuccess == true}">
		<script>
			document.getElementById('completeModal').style.display = 'flex';
		</script>
	</c:if>



	</form>
</body>
</html>