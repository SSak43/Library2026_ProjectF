<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者登録入力画面</h1>
        <button class="menu-button" type="button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
    </div>

    <form action="${pageContext.request.contextPath}/UsersRegist" method="post" id="registForm">

        <div class="main-content-base layout-top-padding register-main-content">
    
            <div class="register-error-message" id="error-message" style="min-height: 1.5em; visibility: hidden;"></div>

            <fmt:formatNumber value="${latestId + 1}" pattern="00000" var="formattedId" />

            <table class="form-table">
                <tr>
                    <th>区分</th>
                    <td>
                        <div class="category-options">
                            <label><input type="radio" name="cla" value="0"> 管理者</label>
                            <label><input type="radio" name="cla" value="1"> 司書</label>
                            <label><input type="radio" name="cla" value="2"> 利用者</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field" id="input-name" name="userName" autofocus required>
                        <button type="button" class="clear-button" onclick="clearInput('input-name')" tabindex="-1">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field" id="input-tel" name="Tel" required>
                        <button type="button" class="clear-button" onclick="clearInput('input-tel')" tabindex="-1">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>利用者ID</th>
                    <td>
                        <input type="text" class="input-field" value="${formattedId}" placeholder="00001" readonly>
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="password" class="input-field" id="input-pass" name="Password" required>
                        <button type="button" class="clear-button" onclick="clearInput('input-pass')" tabindex="-1">クリア</button>
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
      
                <div class="modal-buttons-right">
                    <button type="button" class="cancel-button modal-action-button" onclick="hideConfirmModal()">戻る</button>
                    <button type="button" class="submit-button modal-action-button" onclick="submitForm()">登録</button>
                </div>
            </div>
        </div>

    </form>

    <div id="completeModal" class="modal-overlay">
    <div class="modal-content" style="height: 300px; display: flex; flex-direction: column; justify-content: center; position: relative;">
        <div style="text-align: center; font-size: 1.8rem; letter-spacing: 0.1em;">
            登録が完了しました。
        </div>

        <div style="position: absolute; bottom: 65px; left: 50%; transform: translateX(-50%); font-size: 0.9rem; color: #666;">
            登録ID: <fmt:formatNumber value="${latestId}" pattern="00000" />
        </div>

        <div style="position: absolute; bottom: 20px; right: 20px; display: flex; gap: 15px;">
            <button type="button" class="submit-button" 
                    style="border: 1px solid #2f5597; background-color: white; padding: 8px 25px; font-size: 1rem;" 
                    onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">
                メニュー
            </button>
            <button type="button" class="submit-button" 
                    style="border: 1px solid #2f5597; background-color: white; padding: 8px 25px; font-size: 1rem;" 
                    onclick="location.href='${pageContext.request.contextPath}/UsersRegist'">
                続けて登録
            </button>
        </div>
    </div>
</div>

    <script>
    document.addEventListener("DOMContentLoaded", function() {
        const telInput = document.getElementById('input-tel');
        const nameInput = document.getElementById('input-name');
        
        // 氏名のリアルタイム入力制御
        nameInput.addEventListener('input', function(e) {
            let cleanVal = this.value.replace(/[^a-zA-Z0-9\sぁ-んァ-ヶ一-龠々ーａ-ｚＡ-Ｚ]/g, ''); 
            cleanVal = cleanVal.replace(/[0-9０-９]/g, '');
            this.value = cleanVal;
        });

        // 電話番号のリアルタイム入力制御（数字とハイフン自動挿入）
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

    // 各項目のクリア機能
    function clearInput(id) {
        document.getElementById(id).value = '';
        document.getElementById(id).focus();
    }

    // 登録確認ボタンが押されたときのバリデーション
    function showConfirmModal() {
        const claInput = document.querySelector('input[name="cla"]:checked');
        const form = document.getElementById('registForm');
        const errorMessage = document.getElementById('error-message');

        errorMessage.style.visibility = 'hidden';

        // 1. 必須入力（未入力）チェック
        if (!form.checkValidity()) {
            errorMessage.innerText = "未入力の欄があります。すべての項目に記入してください。";
            errorMessage.style.visibility = 'visible';
            form.reportValidity();
            return;
        }

        const name = document.getElementById('input-name').value.trim();
        const tel = document.getElementById('input-tel').value.trim();
        const pass = document.getElementById('input-pass').value.trim();

        // 2. 氏名の文字種チェック
        const nameRegex = /^[ぁ-んァ-ヶ一-龠々ーa-zA-Zａ-ｚＡ-Ｚ\s ]+$/;
        if (!nameRegex.test(name)) {
            errorMessage.innerText = "氏名には数字や記号は使用できません。";
            errorMessage.style.visibility = 'visible';
            return;
        }

        // 3. 電話番号の形式チェック
        const telRegex = /^[0-9-]+$/;
        if (!telRegex.test(tel)) {
            errorMessage.innerText = "電話番号は数字（ハイフン含む）のみで入力してください。";
            errorMessage.style.visibility = 'visible';
            return;
        }

        // 4. パスワードのチェック（全角文字に加え、トラブルになりやすい「スペース」も禁止に改良）
        const invalidRegex = /[^\x21-\x7E]/;
        if (invalidRegex.test(pass)) {
            errorMessage.innerText = "パスワードに利用できない文字（全角文字やスペース）が含まれています。使用可能文字：半角の英数字・記号";
            errorMessage.style.visibility = 'visible';
            return; 
        } 
        
        // 確認画面（モーダル）へ値をセットして表示
        document.getElementById('confirm-cla').value = claInput.parentElement.textContent.trim();
        document.getElementById('confirm-name').value = name;
        document.getElementById('confirm-tel').value = tel;
        document.getElementById('confirm-pass').value = pass;

        document.getElementById('confirmModal').style.display = 'flex';
    }

    // 確認画面を閉じる
    function hideConfirmModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }
    
    // サーブレットへフォームを送信
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