<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>図書データ更新入力画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-02.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/update.css">
    <style>
        /* 確認画面で「パスワード」ラベルが一行に収まるように小さく調整 */
        .confirm-password-label {
            font-size: 0.85rem !important;
            white-space: nowrap;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1 class="header-title">図書データ更新入力画面</h1>
        <button class="menu-button header-blue-button" type="button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding register-main-content">
        
        <c:set var="isSearch" value="${not empty param.searchKey}" />
        <c:set var="isFound" value="${not empty booksList}" />
        <c:if test="${isFound}">
            <c:set var="b" value="${booksList[0]}" />
        </c:if>
            
        <div class="register-error-message" id="error-message" style="min-height: 1.5em; visibility: ${isSearch && !isFound ? 'visible' : 'hidden' || not empty errorMessage ? 'visible' : 'hidden'};">
            <c:choose>
                <c:when test="${isSearch && !isFound}">該当する利用者は存在しません</c:when>
                <c:otherwise><c:out value="${errorMessage}" /></c:otherwise>
            </c:choose>
        </div>

        <form method="GET" action="${pageContext.request.contextPath}/BooksUpdate" id="searchForm">
            <div class="id-search-group" style="display: flex; gap: 10px; margin-bottom: 20px; justify-content: center;"">
                <input type="text" class="input-field" id="search-key" name="searchKey" value="${param.searchKey}" placeholder="利用者IDまたは書名入力" required autofocus>
                <button type="submit" class="header-blue-button">表示</button>
            </div>
        </form>
            
        <form action="${pageContext.request.contextPath}/BooksUpdate" method="post" id="updateForm">
            <input type="hidden" name="bookId" value="${b.bookId}">

            <table class="form-table ${!isFound ? 'form-table-locked' : 'form-table-active'}">
                <tr>
                    <th>利用者ID</th>
                    <td>
                        <input type="text" class="input-field input-readonly-id" id="input-id" value="${isFound ? b.bookId : ''}" readonly placeholder="IDを表示します">
                    </td>
                </tr>
                <tr>
                    <th>書名</th>
                    <td>
                        <input type="text" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-title" name="title" value="${isFound ? b.title : ''}" placeholder="${!isFound ? 'IDまたは書名を入力してください' : ''}" required ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-title')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td>
                        <input type="text" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-writerName" name="writerName" value="${isFound ? b.writerName : ''}" placeholder="${!isFound ? 'IDまたは書名を入力してください' : ''}" required ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-writerName')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>会社名</th>
                    <td>
                        <input type="text" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-company" name="company" value="${isFound ? b.company : ''}" placeholder="${!isFound ? 'IDまたは書名を入力してください' : ''}" required ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-company')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>分類</th>
                    <td>
                        <input type="text" class="input-field ${!isFound ? 'input-field-locked' : 'input-field-active'}" id="input-bookClass" name="bookClass" value="${isFound ? b.bookClass : ''}" placeholder="${!isFound ? 'IDまたは書名を入力してください' : ''}" required ${!isFound ? 'disabled' : ''}>
                        <button type="button" class="clear-button" onclick="clearInput('input-bookClass')" tabindex="-1" ${!isFound ? 'disabled' : ''}>クリア</button>
                    </td>
                </tr>                <tr>
                    <th>状態</th>
                    <td>
                        <div class="category-options">
                            <label><input type="radio" name="status" value="0" ${isFound && b.bookStatus == '0' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 貸出可能</label>
                            <label><input type="radio" name="status" value="1" ${isFound && b.bookStatus == '1' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 貸出中</label>
                            <label><input type="radio" name="status" value="2" ${isFound && b.bookStatus == '2' ? 'checked' : ''} ${!isFound ? 'disabled' : ''}> 貸出不可</label>
                        </div>
                    </td>
                </tr>
            </table>

            <div class="bottom-button-container">
            
                <button type="button" class="update-submit-button" onclick="showConfirmModal()" ${!isFound ? 'disabled' : ''}>登録</button>
            </div>

            <div id="confirmModal" class="modal-overlay">
                <div class="modal-content">
                    <div class="modal-title">更新確認</div>
            
                    <table class="form-table">
                        <tr><th>図書ID</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-id" readonly></td></tr>
                        <tr><th>書名</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-title" readonly></td></tr>
                        <tr><th>著者</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-writerName" readonly></td></tr>
                        <tr><th>会社名</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-company" readonly></td></tr>
                        <tr><th>分類</th><td><input type="text" class="input-field w-full confirm-modal-field" id="confirm-bookClass" readonly></td></tr>
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
                    <button type="button" class="modal-action-button" style="width: 120px;" onclick="location.href='${pageContext.request.contextPath}/BooksUpdate'">
                        続けて更新
                    </button>
                </div>
            </div>
        </div>
    </c:if>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
//             const telInput = document.getElementById('input-tel');
            const titleInput = document.getElementById('input-title');
            const nameInput = document.getElementById('input-writerName');
            const companyInput = document.getElementById('input-company');
            const claInput = document.getElementById('input-bookClass');
            const searchInput = document.getElementById('search-key');

         // 検索バーの全角数字 ➡️ 半角自動置換
            if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            searchInput.value = searchInput.value.replace(/[０-９]/g, function(s) {
                return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
            });
        });
    }
            

//             if (telInput) {
//                 telInput.addEventListener('input', function(e) {
//                     let val = this.value.replace(/[０-９]/g, function(s) {
//                         return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
//                     });
//                     let rawStr = val.replace(/[^0-9]/g, '');
//                     let formatted = '';
//                     if (rawStr.length > 7) {
//                         formatted = rawStr.substring(0, 3) + '-' + rawStr.substring(3, 7) + '-' + rawStr.substring(7, 11);
//                     } else if (rawStr.length > 3) {
//                         formatted = rawStr.substring(0, 3) + '-' + rawStr.substring(3);
//                     } else {
//                         formatted = rawStr;
//                     }
//                     this.value = formatted;
//                 });
//             }
        });

        function clearInput(id) {
            document.getElementById(id).value = '';
            document.getElementById(id).focus();
        }

        function showConfirmModal() {
//             const claInput = document.querySelector('input[name="cla"]:checked');
            const statusInput = document.querySelector('input[name="status"]:checked');
            const form = document.getElementById('updateForm');
            const errorMessage = document.getElementById('error-message');

            // JavaScript側での初期化時はvisibilityを固定せず、JSTL側のエラー文言があれば残す
            errorMessage.style.visibility = 'hidden';

            if (!form.checkValidity()) {
                errorMessage.innerText = "未入力の欄があります。すべての項目に記入してください。";
                errorMessage.style.visibility = 'visible';
                form.reportValidity();
                return;
            }

            const title = document.getElementById('input-title').value.trim();
            const writerName = document.getElementById('input-writerName').value.trim();
            const company = document.getElementById('input-company').value.trim();
            const bookClass = document.getElementById('input-bookClass').value.trim();

//             const nameRegex = /^[ぁ-んァ-ヶ一-龠々ーa-zA-Zａ-ｚＡ-Ｚ\s ]+$/;
//             if (!nameRegex.test(name)) {
//                 errorMessage.innerText = "氏名には数字や記号は使用できません。";
//                 errorMessage.style.visibility = 'visible';
//                 return;
//             }

//             const telRegex = /^[0-9-]+$/;
//             if (!telRegex.test(tel)) {
//                 errorMessage.innerText = "電話番号は数字（ハイフン含む）のみで入力してください。";
//                 errorMessage.style.visibility = 'visible';
//                 return;
//             }
// 			const telDigits = tel.replace(/[^0-9]/g, ''); 
            
//             // 数字が10桁未満、または12桁以上の場合はエラー（一般的な固定電話は10桁、携帯は11桁）
//             if (telDigits.length < 10 || telDigits.length > 11) {
//                 errorMessage.innerText = "電話番号の桁数が足りないか、正しくありません（10桁または11桁で入力してください）。";
//                 errorMessage.style.visibility = 'visible';
//                 // 入力欄にフォーカスを当てて、どこがダメだったか分かりやすくする
//                 document.getElementById('input-tel').focus();
//                 return;
//             }

//             if (pass.length > 0) {
//                 const invalidRegex = /[^\x21-\x7E]/;
//                 if (invalidRegex.test(pass)) {
//                     errorMessage.innerText = "パスワードに利用できない文字（全角文字やスペース）が含まれています。";
//                     errorMessage.style.visibility = 'visible';
//                     return; 
//                 } 
//             }
            
//             document.getElementById('confirm-id').value = document.getElementById('input-id').value;
//             document.getElementById('confirm-bookClass').value = claInput.parentElement.textContent.trim();
//             document.getElementById('confirm-name').value = name;
//             document.getElementById('confirm-tel').value = tel;
//             document.getElementById('confirm-pass').value = pass === "" ? "（変更なし）" : "********";
            document.getElementById('confirm-id').value = document.getElementById('input-id').value;
            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-writerName').value = writerName;
            document.getElementById('confirm-company').value = company;
            document.getElementById('confirm-bookClass').value = bookClass;
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