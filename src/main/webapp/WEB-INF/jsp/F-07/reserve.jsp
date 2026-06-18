<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>図書予約登録画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-02.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/update.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">図書予約登録画面</h1>
        <button class="menu-button" type="button" onclick="location.href='${pageContext.request.contextPath}/home/admin_home.jsp'">メニュー</button>
    </div>

    <form action="${pageContext.request.contextPath}/reserveBook" method="post" id="reserveForm">
        <input type="hidden" name="action" id="actionField" value="">
		<input type="hidden" id="book-status" value="${selectedBook != null ? selectedBook.bookStatus : ''}">

        <div class="main-content-base layout-top-padding register-main-content">
    
            <div class="register-error-message" id="error-message" style="min-height: 1.5em; <c:if test='${not empty errorMessage}'>visibility: visible;</c:if>">
                <c:out value="${errorMessage}" />
            </div>
            
<!-- 登録完了モーダル -->
            <div id="completeModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">登録完了</div>
    
            <div style="text-align: center; margin: 30px 0; font-size: 1.1rem; line-height: 1.6;">
                <p style="color: #2f5597; font-weight: bold;">
                    <c:out value="${successMessage}" />
                </p>
            </div>
  
            <div class="modal-buttons-right">
                
                <button type="button" class="modal-action-button" style="width: 100px;" 
                        onclick="location.href='${pageContext.request.contextPath}/ReserveManagement'">メニュー</button>
                <button type="button" class="modal-action-button" style="width: 100px; font-size: 0.9rem;" 
                        onclick="location.href='${pageContext.request.contextPath}/reserveBook'">続けて登録</button>
            </div>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                document.getElementById('completeModal').style.display = 'flex';
            });
        </script>
    </c:if>
            <table class="form-table">
                <tr>
                    <th>利用者ID</th>
                    <td>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <input type="text" class="input-field" name="userId" id="input-user-id" placeholder="利用者IDを入力" value="${inputUserId}" style="width: 200px;" required>
                            <button type="button" class="clear-button" style="padding: 5px 20px; font-size: 1rem;" onclick="submitAction('searchUser')">表示</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field w-full" id="input-user-name" value="${selectedUser != null ? selectedUser.userName : ''}" style="background-color: #f5f5f5;" readonly>
                    </td>
                </tr>
                <tr>
                    <th>図書ID</th>
                    <td>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <input type="text" class="input-field" name="bookId" id="input-book-id" placeholder="図書IDを入力" value="${inputBookId}" style="width: 200px;" required>
                            <button type="button" class="clear-button" style="padding: 5px 20px; font-size: 1rem;" onclick="submitAction('searchBook')">表示</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>書名</th>
                    <td>
                        <input type="text" class="input-field w-full" id="input-book-title" value="${selectedBook != null ? selectedBook.title : ''}" style="background-color: #f5f5f5;" readonly>
                    </td>
                </tr>
                <tr>
                    <th>著者名</th>
                    <td>
                        <input type="text" class="input-field w-full" id="input-book-writer" value="${selectedBook != null ? selectedBook.writerName : ''}" style="background-color: #f5f5f5;" readonly>
                    </td>
                </tr>
                <tr>
                    <th>貸出状態</th>
                    <td>
                        <input type="text" class="input-field w-full" value="${displayBookStatus}" style="background-color: #f5f5f5;" readonly>
                    </td>
                </tr>
            </table>

            <div class="bottom-button-container" style="gap: 20px; margin-top: 30px;">
                <button type="button" class="clear-button" style="width: 140px; padding: 8px 0;" onclick="location.href='${pageContext.request.contextPath}/ReserveManagement'">戻る</button>
                
                <button type="button" class="register-button" 
                        onclick="showConfirmModal()" 
                        ${(selectedUser == null || selectedBook == null) ? 'disabled style="background-color: #cccccc; border-color: #999999; color: #777777; cursor: not-allowed;"' : ''}>
                    登録
                </button>
            </div>
        </div>
    </form>

    <div id="confirmModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">予約登録確認</div>
    
            <table class="form-table">
                <tr>
                    <th>利用者ID</th>
                    <td><input type="text" class="input-field w-full confirm-modal-field" id="modal-user-id" readonly></td>
                </tr>
                <tr>
                    <th>利用者名</th>
                    <td><input type="text" class="input-field w-full confirm-modal-field" id="modal-user-name" readonly></td>
                </tr>
                <tr>
                    <th>図書ID</th>
                    <td><input type="text" class="input-field w-full confirm-modal-field" id="modal-book-id" readonly></td>
                </tr>
                <tr>
                    <th>図書名</th>
                    <td><input type="text" class="input-field w-full confirm-modal-field" id="modal-book-title" readonly></td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td><input type="text" class="input-field w-full confirm-modal-field" id="modal-book-writer" readonly></td>
                </tr>
            </table>
  
            <div class="modal-buttons-right">
                <button type="button" class="modal-action-button" onclick="hideConfirmModal()">戻る</button>
                <button type="button" class="modal-action-button" onclick="submitForm()">登録</button>
            </div>
        </div>
    </div>

    <script>
        // フォームを送信する関数
        function submitAction(actionType) {
            document.getElementById('actionField').value = actionType;
            document.getElementById('reserveForm').submit();
        }

        // モーダルを表示し、入力されている値をセットする関数
        function showConfirmModal() {
            // --- エラーチェック処理 ---
            const errorMessage = document.getElementById('error-message');
            const bookStatus = document.getElementById('book-status').value;
            
            // 貸出不可（ステータスが '2'）の場合はエラーを出して処理を止める
            if (bookStatus === '2') {
                errorMessage.innerText = "この図書は予約できません。";
                errorMessage.style.visibility = 'visible';
                return;
            }
            errorMessage.style.visibility = 'hidden';

            // --- モーダルへの値のセット処理 ---
            document.getElementById('modal-user-id').value = document.getElementById('input-user-id').value;
            document.getElementById('modal-user-name').value = document.getElementById('input-user-name').value;
            document.getElementById('modal-book-id').value = document.getElementById('input-book-id').value;
            document.getElementById('modal-book-title').value = document.getElementById('input-book-title').value;
            document.getElementById('modal-book-writer').value = document.getElementById('input-book-writer').value;
            
            document.getElementById('confirmModal').style.display = 'flex';
        }

        // モーダルを閉じる関数
        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // モーダルの「登録」ボタンを押したときの処理
        function submitForm() {
            submitAction('register');
        }

        // 全角数字から半角への自動変換
        document.addEventListener("DOMContentLoaded", function() {
            const ids = ['input-user-id', 'input-book-id'];
            ids.forEach(id => {
                const element = document.getElementById(id);
                if (element) {
                    element.addEventListener('input', function(e) {
                        element.value = element.value.replace(/[０-９]/g, function(s) {
                            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
                        });
                    });
                }
            });
        });
   
</script>

</body>
</html>