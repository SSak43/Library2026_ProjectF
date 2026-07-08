<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>図書登録入力画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-02.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modal.css">
</head>
<body>

<%

UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null) loginUserObj = session.getAttribute("user");
if (loginUserObj == null) loginUserObj = session.getAttribute("login");
if (loginUserObj != null && loginUserObj instanceof UsersBean) {
    loginUser = (UsersBean) loginUserObj;
}
    // ログインユーザーの区分に応じて遷移先URLを決定
    String menuUrl = request.getContextPath() + "/home/admin_home.jsp"; // デフォルト
    if (loginUser != null) {
        String uClass = loginUser.getUserClass();
        if ("0".equals(uClass) || "管理者".equals(uClass)) {
            menuUrl = request.getContextPath() + "/home/admin_home.jsp";
        } else if ("1".equals(uClass) || "司書".equals(uClass)) {
            menuUrl = request.getContextPath() + "/home/sisyo_home.jsp";
        } else if ("2".equals(uClass) || "利用者".equals(uClass)) {
            menuUrl = request.getContextPath() + "/home/riyousyahome.jsp";
        }
    }
%>

    <div class="header">
        <h1 class="header-title">図書登録入力画面</h1>
        <button class="menu-button" type="button" onclick="location.href='${pageContext.request.contextPath}/BooksMain'">メニュー</button>
    </div>

    <form action="${pageContext.request.contextPath}/BooksRegist" method="post" id="registForm">
    
        <div class="main-content-base layout-top-padding register-main-content">
        
            <div class="register-error-message" id="error-message"></div>
            
            <table class="form-table">
                <tr>
                    <th>書名</th>
                    <td>
                        <input type="text" class="input-field" id="input-title" name="title" autofocus required>
                        <button type="button" class="clear-button" onclick="clearInput('input-title')">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td>
                        <input type="text" class="input-field" id="input-writerName" name="writerName" required>
                        <button type="button" class="clear-button" onclick="clearInput('input-writerName')">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>図書ID</th>
                    <td>
                        <input type="text" class="input-field" value="<fmt:formatNumber value='${latestId + 1}' pattern='000000' />" placeholder="00001" readonly>
                    </td>
                </tr>
                <tr>
                    <th>出版社</th>
                    <td>
                        <input type="text" class="input-field" id="input-company" name="company" required>
                        <button type="button" class="clear-button" onclick="clearInput('input-company')">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>分類</th>
                    <td>
                        <input type="text" class="input-field" id="input-cla" name="cla" required 
					       maxlength="2" inputmode="numeric" pattern="[0-9]{1,2}"
					       oninvalid="this.setCustomValidity('2桁以内の数字で入力してください')" 
					       oninput="this.setCustomValidity('')">
                        <button type="button" class="clear-button" onclick="clearInput('input-cla')">クリア</button>
                    </td>
                </tr>
            </table>

            <div class="bottom-button-container">
                <button type="button" class="register-button" onclick="showConfirmModal()">登録</button>
            </div>

        </div>

        <div id="confirmModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-title">登録確認</div>
                <table class="form-table">
                    <tr><th>書名</th><td><input type="text" class="input-field w-full" id="confirm-title" readonly></td></tr>
                    <tr><th>著者</th><td><input type="text" class="input-field w-full" id="confirm-writerName" readonly></td></tr>
                     <tr><th>出版社</th><td><input type="text" class="input-field w-full" id="confirm-company" readonly></td></tr>                   
                   <tr><th>分類</th><td><input type="text" class="input-field w-full" id="confirm-cla" readonly></td></tr>
                </table>
                
                <div class="modal-buttons">
				    <button type="button" onclick="hideConfirmModal()">戻る</button>
				    <button type="button" onclick="submitForm()">登録</button>
				</div>
            </div>
        </div>

    </form>

    <div id="completeModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">登録完了</div>
    
            <div style="text-align: center; margin: 25px 0; font-size: 1.1rem; line-height: 1.6;">
                <p>図書登録が完了しました。</p>
                <p style="color: #2f5597; font-weight: bold; margin-top: 10px;">
<%--                     登録された図書IDは 「 <c:out value="${registeredBookId}" /> 」 です。 --%>
					登録された図書IDは「<fmt:formatNumber value="${ registeredBookId}" pattern='000000' /> 」
                </p>
            </div>
  
<!--  登録成功モーダル -->
            <div class="modal-buttons">
    <button type="button" onclick="location.href='<%= menuUrl %>'">メニュー</button>
    <button type="button" onclick="location.href='${pageContext.request.contextPath}/BooksRegist'">続けて登録</button>
</div>
        </div>
    </div>

    <script>

    document.addEventListener("DOMContentLoaded", function() {
        // 分類の入力制御（数字のみ2桁、全角数字は半角に自動変換）
        const claInput = document.getElementById('input-cla');
        if (claInput) {
            claInput.addEventListener('input', function() {
                // 1. 全角数字が入力されたら半角に変換する
                let val = this.value.replace(/[０-９]/g, function(s) {
                    return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                });
                // 2. 数字以外の文字（日本語や記号、アルファベット）をすべて強制消去
                this.value = val.replace(/[^0-9]/g, '');
            });
        }
    });


        function showConfirmModal() {
            const form = document.getElementById('registForm');
            const errorMessage = document.getElementById('error-message');

            errorMessage.style.visibility = 'hidden';

            // 未入力チェック
            if (!form.checkValidity()) {
                errorMessage.innerText = "未入力の欄があります。すべての項目に記入してください。";
                errorMessage.style.visibility = 'visible';
                form.reportValidity();
                return;
            }
            const title = document.getElementById('input-title').value.trim();
            const writerName = document.getElementById('input-writerName').value.trim();
            const company = document.getElementById('input-company').value.trim();
            const cla = document.getElementById('input-cla').value.trim();


            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-writerName').value = writerName;
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

        function clearInput(id) {
            document.getElementById(id).value = '';
            document.getElementById(id).focus();
        }
    </script>

    <c:if test="${isSuccess == true}">
        <script>
            document.getElementById('completeModal').style.display = 'flex';
        </script>
    </c:if>

</body>
</html>