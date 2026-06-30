<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者登録入力画面</title>
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
        <h1 class="header-title">利用者登録入力画面</h1>
        <button class="menu-button" type="button" onclick="location.href='${pageContext.request.contextPath}/UserManagement'">メニュー</button>
    </div>

    <form action="${pageContext.request.contextPath}/UsersRegist" method="post" id="registForm">

        <div class="main-content-base layout-top-padding register-main-content">
            
            <div class="register-error-message" id="error-message"></div>

            <table class="form-table">
                <tr>
                    <th>区分</th>
                    <td>
                        <div class="category-options">
						    <label><input type="radio" name="cla" value="1" required> 管理者</label>
						    <label><input type="radio" name="cla" value="2" required> 司書</label>
						    <label><input type="radio" name="cla" value="0" required> 利用者</label>
						</div>
                    </td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field" id="input-name" name="userName" autofocus required>
                        <button type="button" class="clear-button" onclick="clearInput('input-name')">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field" id="input-tel" name="Tel" required>
                        <button type="button" class="clear-button" onclick="clearInput('input-tel')">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>利用者ID</th>
                    <td>
                        <input type="text" class="input-field" value="<fmt:formatNumber value='${latestId + 1}' pattern='000000' />" placeholder="000001" readonly>
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="text" class="input-field" id="input-pass" name="Password" required>
                        <button type="button" class="clear-button" onclick="clearInput('input-pass')">クリア</button>
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
                    <tr><th>区分</th><td><input type="text" class="input-field w-full" id="confirm-cla" readonly></td></tr>
                    <tr><th>氏名</th><td><input type="text" class="input-field w-full" id="confirm-name" readonly></td></tr>
                    <tr><th>電話番号</th><td><input type="text" class="input-field w-full" id="confirm-tel" readonly></td></tr>
                    <tr>
                        <th class="password-label">パスワード</th>
                        <td><input type="text" class="input-field w-full" id="confirm-pass" readonly></td>
                    </tr>
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
                <p>利用者登録が完了しました。</p>
                <p style="color: #2f5597; font-weight: bold; margin-top: 10px;">
                    登録されたユーザーIDは 「 <c:out value="${registeredUserId}" /> 」 です。
                </p>
            </div>
  
<!--  登録成功モーダル -->
           <div class="modal-buttons">
			    <button type="button" onclick="location.href='<%= menuUrl %>'">メニュー</button>
			    <button type="button" onclick="location.href='${pageContext.request.contextPath}/UsersRegist'">続けて登録</button>
			</div>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const telInput = document.getElementById('input-tel');
            const nameInput = document.getElementById('input-name');
            
            // 氏名の入力制御（日本語・英字・スペースは自由、数字と記号だけを自動消去）
				nameInput.addEventListener('input', function(e) {
				    // 「\p{L}（すべての文字）」と「\p{Z}（すべてのスペース）」以外をすべて消去
				    this.value = this.value.replace(/[^\p{L}\p{Z}]/gu, '');
				});

            // 電話番号の入力制御
            telInput.addEventListener('input', function(e) {
                let val = this.value.replace(/[０-９]/g, function(s) {
                    return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                });
                
                let rawStr = val.replace(/[^0-9]/g, '');

                let formatted = '';
                if (rawStr.length > 7) {
                    formatted = rawStr.substring(0, 3) + '-' + rawStr.substring(3, 7) + '-' + rawStr.substring(7, 11);
                } else if (rawStr.length > 3) {
                    formatted = rawStr.substring(0, 3) + '-' + rawStr.substring(3);
                } else {
                    formatted = rawStr;
                }
                
                this.value = formatted;
            });
        });

        function clearInput(id) {
            document.getElementById(id).value = '';
            document.getElementById(id).focus();
        }

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

            const claInput = document.querySelector('input[name="cla"]:checked');

            if (!claInput) {
                errorMessage.innerText = "区分を選択してください。";
                errorMessage.style.visibility = 'visible';
                return;
            }
            
            const name = document.getElementById('input-name').value.trim();
            const tel = document.getElementById('input-tel').value.trim();
            const pass = document.getElementById('input-pass').value.trim();

            if (/[^\p{L}\p{Z}]/u.test(name)) {
                errorMessage.innerText = "氏名には数字や記号は使用できません。";
                errorMessage.style.visibility = 'visible';
                return;
            }

            const telRegex = /^[0-9-]+$/;
            if (!telRegex.test(tel)) {
                errorMessage.innerText = "電話番号は数字（ハイフン含む）のみで入力してください。";
                errorMessage.style.visibility = 'visible';
                return;
            }

            // パスワードの全角文字チェック
            const invalidRegex = /[^\x20-\x7E]/; 
            if (invalidRegex.test(pass)) {
                errorMessage.innerText = "パスワードに利用できない文字が含まれています。使用可能文字（大小英数字、記号）";
                errorMessage.style.visibility = 'visible';
                return; 
            } 
            
            // 値をセットして確認画面を表示
            let claLabel = "";
				if (claInput.value === "1") {
				    claLabel = "管理者";
				} else if (claInput.value === "2") {
				    claLabel = "司書";
				} else {
				    claLabel = "利用者";
				}
				document.getElementById('confirm-cla').value = claLabel;
            document.getElementById('confirm-name').value = name;
            document.getElementById('confirm-tel').value = tel;
            document.getElementById('confirm-pass').value = pass;

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

</body>
</html>