<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>利用者登録入力画面</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/F-02.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者登録入力画面</h1>
        <button class="menu-button" type="button" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <form action="UsersRegist" method="post" id="registForm">

        <div class="main-content-base layout-top-padding">
            
            <div class="error-message" id="error-message" style="${not empty errorMessage ? 'display: block;' : ''}">
                <c:choose>
                    <c:when test="${not empty errorMessage}">
                        <c:out value="${errorMessage}" />
                    </c:when>
                    <c:otherwise>
                        利用できない文字が含まれています。使用可能文字（大小英数字、記号）
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="category-group">
                <div class="category-label">区分</div>
                <div class="category-options">
                    <label><input type="radio" name="cla" value="管理者" checked> 管理者</label>
                    <label><input type="radio" name="cla" value="司書"> 司書</label>
                    <label><input type="radio" name="cla" value="利用者"> 利用者</label>
                </div>
            </div>

            <table class="form-table">
                <tr>
                    <th>利用者ID</th>
                    <td>
                        <input type="text" class="id-field" value="<fmt:formatNumber value="${latestId + 1}" pattern="00000" />" readonly>
                    </td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field" id="input-name" name="userName" required>
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field" id="input-tel" name="Tel" required>
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="password" class="input-field" id="input-pass" name="Password" required>
                    </td>
                </tr>
            </table>

            <div class="bottom-button-container">
                <button type="button" class="register-button" onclick="showConfirmModal()">登録確認</button>
            </div>

        </div>

        <div id="confirmModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-title">登録確認</div>
                <table class="form-table">
                    <tr><th>氏名</th><td><input type="text" class="input-field" id="confirm-name" readonly></td></tr>
                    <tr><th>電話番号</th><td><input type="text" class="input-field" id="confirm-tel" readonly></td></tr>
                    <tr><th>パスワード</th><td><input type="text" class="input-field" id="confirm-pass" readonly></td></tr>
                </table>
                <div class="modal-buttons">
                    <button type="button" class="cancel-button" onclick="hideConfirmModal()">戻る</button>
                    <button type="button" class="submit-button" onclick="submitForm()">登録</button>
                </div>
            </div>
        </div>

    </form>

    <div id="completeModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">登録完了</div>
            <div style="text-align: center; margin: 20px 0;">
                登録が完了しました。
            </div>
            <div class="modal-buttons" style="justify-content: center;">
                <button type="button" class="submit-button" onclick="location.href='menu.jsp'">メニューへ</button>
            </div>
        </div>
    </div>

    <script>
        function showConfirmModal() {
            const tel = document.getElementById('input-tel').value;
            const pass = document.getElementById('input-pass').value;
            const errorMessage = document.getElementById('error-message');
            
            const invalidRegex = /[^\\x20-\\x7E]/;
            
            if (invalidRegex.test(tel) || invalidRegex.test(pass)) {
                errorMessage.innerText = "利用できない文字が含まれています。使用可能文字（大小英数字、記号）";
                errorMessage.style.display = 'block';
            } else {
                errorMessage.style.display = 'none';
                
                const inputName = document.getElementById('input-name').value;
                document.getElementById('confirm-name').value = inputName;
                document.getElementById('confirm-tel').value = tel;
                document.getElementById('confirm-pass').value = pass;

                document.getElementById('confirmModal').style.display = 'flex';
            }
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