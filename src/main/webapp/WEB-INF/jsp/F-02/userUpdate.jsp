<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者データ更新入力画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-02.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/update.css">
    <style>
        /* ⭕「パスワード」という文字が確認画面で一行に収まるように小さく調整 */
        .confirm-password-label {
            font-size: 0.85rem !important;
            white-space: nowrap;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者データ更新入力画面</h1>
        <button class="menu-button header-blue-button" type="button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding register-main-content">
        
        <div class="register-error-message" id="error-message" style="min-height: 1.5em; visibility: ${not empty errorMessage ? 'visible' : 'hidden'};">
            <c:out value="${errorMessage}" />
        </div>

        <form method="GET" action="${pageContext.request.contextPath}/UsersUpdate" id="searchForm">
            <div class="id-search-group" style="display: flex; gap: 10px; margin-bottom: 20px; justify-content: center;">
                <input type="text" class="input-field" id="search-id" name="userId" value="${param.userId}" placeholder="利用者ID入力" required style="width: 200px;">
                <button type="submit" class="header-blue-button">表示</button>
            </div>
        </form>

        <c:set var="isFound" value="${not empty usersList}" />
        <c:if test="${isFound}">
            <c:set var="u" value="${usersList[0]}" />
        </c:if>
            
        <form action="${pageContext.request.contextPath}/UsersUpdate" method="post" id="updateForm">
            <input type="hidden" name="userId" value="${u.userId}">

            <table class="form-table ${!isFound ? 'form-table-locked' : 'form-table-active'}">
                <tr>
                    <th>利用者ID</th>
                    <td>
                        <input type="text" class="input-field input-readonly-id" id="input-id" value="${isFound ? u.userId : ''}" readonly placeholder="IDを表示します">
                    </td>
                </tr>
                <tr>
                    <th>区分</th>
                    <td>
                        <div class="category-options">
                            <label><input type="radio" name="cla" value="0" ${u.userClass == '0' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 管理者</label>
                            <label><input type="radio" name="cla" value="1" ${u.userClass == '1' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 司書</label>
                            <label><input type="radio" name="cla" value="2" ${u.userClass == '2' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 利用者</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-name" name="userName" value="${isFound ? u.userName : ''}" placeholder="${!isFound ? 'IDを入力してください' : ''}" required ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-name')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-tel" name="Tel" value="${isFound ? u.tel : ''}" placeholder="${!isFound ? 'IDを入力してください' : ''}" required ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-tel')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="password" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-pass" name="Password" placeholder="${isFound ? '変更する場合のみ入力' : 'IDを入力してください'}" ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-pass')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>状態</th>
                    <td>
                        <div class="category-options">
                            <label><input type="radio" name="status" value="0" ${u.userStatus == '0' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 有効</label>
                            <label><input type="radio" name="status" value="1" ${u.userStatus == '1' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 無効</label>
                        </div>
                    </td>
                </tr>
            </table>

            <div class="bottom-button-container">
                <button type="button" class="update-submit-button" onclick="showConfirmModal()" ${!isFound ? 'disabled' : ''}>変更確認</button>
            </div>

            <div id="confirmModal" class="modal-overlay">
                <div class="modal-content">
                    <div class="modal-title">更新確認</div>
            
                    <table class="form-table">
                        <tr><th>利用者ID</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-id" readonly></td></tr>
                        <tr><th>区分</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-cla" readonly></td></tr>
                        <tr><th>氏名</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-name" readonly></td></tr>
                        <tr><th>電話番号</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-tel" readonly></td></tr>
                        <tr><th class="confirm-password-label">パスワード</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-pass" readonly></td></tr>
                        <tr><th>状態</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-status" readonly></td></tr>
                    </table>
          
                    <div class="modal-buttons-right">
                        <button type="button" class="modal-action-button" onclick="hideConfirmModal()">戻る</button>
                        <button type="button" class="modal-action-button" onclick="submitForm()">更新</button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <c:if test="${isSuccess == true}">
        <div id="completeModal" class="modal-overlay" style="display: flex;">
            <div class="modal-content" style="height: 300px; display: flex; flex-direction: column; justify-content: center; position: relative;">
                <div style="text-align: center; font-size: 1.8rem; letter-spacing: 0.1em;">
                    更新が完了しました。
                </div>

                <div class="modal-buttons-right" style="position: absolute; bottom: 20px; right: 20px; margin-top: 0;">
                    <button type="button" class="modal-action-button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">
                        メニュー
                    </button>
                    <button type="button" class="modal-action-button" style="width: 120px;" onclick="location.href='${pageContext.request.contextPath}/UsersUpdate'">
                        続けて更新
                    </button>
                </div>
            </div>
        </div>
    </c:if>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const telInput = document.getElementById('input-tel');
            const nameInput = document.getElementById('input-name');
            
            if (nameInput) {
                nameInput.addEventListener('input', function(e) {
                    let cleanVal = this.value.replace(/[^a-zA-Z0-9\sぁ-んァ-ヶ一-龠々ーａ-ｚＡ-Ｚ]/g, ''); 
                    cleanVal = cleanVal.replace(/[0-9０-９]/g, '');
                    this.value = cleanVal;
                });
            }

            if (telInput) {
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
            }
        });

        function clearInput(id) {
            document.getElementById(id).value = '';
            document.getElementById(id).focus();
        }

        function showConfirmModal() {
            const claInput = document.querySelector('input[name="cla"]:checked');
            const statusInput = document.querySelector('input[name="status"]:checked');
            const form = document.getElementById('updateForm');
            const errorMessage = document.getElementById('error-message');

            errorMessage.style.visibility = 'hidden';

            if (!form.checkValidity()) {
                errorMessage.innerText = "未入力の欄があります。すべての項目に記入してください。";
                errorMessage.style.visibility = 'visible';
                form.reportValidity();
                return;
            }

            const name = document.getElementById('input-name').value.trim();
            const tel = document.getElementById('input-tel').value.trim();
            const pass = document.getElementById('input-pass').value.trim();

            const nameRegex = /^[ぁ-んァ-ヶ一-龠々ーa-zA-Zａ-ｚＡ-Ｚ\s ]+$/;
            if (!nameRegex.test(name)) {
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

            if (pass.length > 0) {
                const invalidRegex = /[^\x21-\x7E]/;
                if (invalidRegex.test(pass)) {
                    errorMessage.innerText = "パスワードに利用できない文字（全角文字やスペース）が含まれています。";
                    errorMessage.style.visibility = 'visible';
                    return; 
                } 
            }
            
            document.getElementById('confirm-id').value = document.getElementById('input-id').value;
            document.getElementById('confirm-cla').value = claInput.parentElement.textContent.trim();
            document.getElementById('confirm-name').value = name;
            document.getElementById('confirm-tel').value = tel;
            document.getElementById('confirm-pass').value = pass === "" ? "（変更なし）" : "********";
            document.getElementById('confirm-status').value = statusInput.parentElement.textContent.trim();

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }
        
        function submitForm() {
            document.getElementById('updateForm').submit();
        }
    </script>
</body>
</html>