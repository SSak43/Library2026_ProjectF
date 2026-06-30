<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書システム - 返却入力画面</title>
    <link rel="stylesheet" href="/Library2026_ProjectF/css/lending/lending.css">
    <link rel="stylesheet" href="/Library2026_ProjectF/css/modal.css">
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
        <h1 class="header-title">返却入力画面</h1>
        <button class="menu-button" type="button" onclick="location.href='<%= menuUrl %>'">メニュー</button>
    </div>

    <div class="main-box">
        <div class="error" id="error-message"><c:out value="${errorMessage}" /></div>
        
        <div id="completeModal" class="modal-overlay">
            <div class="modal-content">
                <div class="modal-title">返却完了</div>
        
                <div style="text-align: center; margin: 30px 0; font-size: 1.1rem; line-height: 1.6;">
                    <p style="color: #2f5597; font-weight: bold;">
                        <c:out value="${successMessage}" />
                    </p>
                </div>
      
                <div class="modal-buttons">
                    <button class="menu-button" type="button" onclick="location.href='<%= menuUrl %>'">メニュー</button>
                    <button type="button" class="modal-action-button" style="width: auto; font-size: 0.9rem;" 
                            onclick="location.href='${pageContext.request.contextPath}/returnBook'">続けて返却</button>
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

        <form id="returnForm" action="returnBook" method="post">
            <input type="hidden" id="actionField" name="action" value="">
            <input type="hidden" id="hdnLendId" name="lendId" value="${activeLend != null ? activeLend.lendId : ''}">
            <input type="hidden" id="hdnBookId" name="bookId" value="${inputBookId}">

            <div style="margin-bottom: 10px;">
			    <input type="text" id="inputBookId" name="bookId" placeholder="図書IDを入力" 
			           value="${inputBookId}" 
			           class="input-field" required 
			           maxlength="6" pattern="[0-9]{6}" 
			           oninvalid="this.setCustomValidity('6桁の数字（例: 123456）を入力してください')" 
			           oninput="this.setCustomValidity('')">
			           
			    <button type="button" onclick="submitSearch('searchBook')" style="padding: 5px 20px; font-size: 1rem; background-color: #fff; border:1px solid;">表示</button>
			</div>
            
            <table>
                <tr>
                    <th style="width: 30%;">利用者ID</th>
                    <td id="txtUserId"><c:out value="${activeLend.userId}" /></td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td id="txtUserName"><c:out value="${activeLend.userName}" /></td>
                </tr>
                <tr>
                    <th>書名</th>
                    <td id="txtBookTitle"><c:out value="${activeLend.title}" /></td>
                </tr>
                <tr>
                    <th>貸出日</th>
                    <td id="txtLendDate"><c:out value="${activeLend.lendDate}" /></td>
                </tr>
                <tr>
                    <th>返却期限</th>
                    <td id="txtReturnLine"><c:out value="${activeLend.returnLine}" /></td>
                </tr>
            </table>

            <button type="button" class="btn-right" onclick="openConfirmationModal()" style="margin-top: 20px;" ${empty activeLend ? 'disabled' : ''}>返却</button>
        </form>
    </div>

    <div id="confirmModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">確認画面</div>
            <table style="width:100%;">
                <tr>
                    <th style="width:30%;">利用者ID</th>
                    <td class="input-field w-full"><span id="popUserId"></span></td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td class="input-field w-full"><span id="popUserName"></span></td>
                </tr>
                <tr>
                    <th>図書ID</th>
                    <td class="input-field w-full"><span id="popBookId"></span></td>
                </tr>
                <tr>
                    <th>書名</th>
                    <td class="input-field w-full"><span id="popBookTitle"></span></td>
                </tr>
            </table>
            <div class="modal-buttons">
                <button type="button" onclick="closeConfirmationModal()">戻る</button>
                <button type="button" onclick="submitReturn()">確定</button>
            </div>
        </div>
    </div>

    <script>
 // 「表示」ボタンが押されたときの処理
    function submitSearch(actionType) {
            var errorMsg = document.getElementById('error-message');
            if (errorMsg) errorMsg.innerText = ""; // 画面上のテキストエラーを一度クリア

            if (actionType === 'searchBook') {
                // 吹き出し（HTML5バリデーション）のチェック
                if (!document.getElementById('inputBookId').reportValidity()) {
                    return; // エラーがあればここでストップ（吹き出しが出る）
                }
            }

            // 入力欄の最新の値を、送信用の隠しフィールド(hidden)に移し替える
            document.getElementById('hdnBookId').value = document.getElementById('inputBookId').value;
            
            // アクションをセットして返却フォーム（returnForm）をServletへ送信
            document.getElementById('actionField').value = actionType;
            document.getElementById('returnForm').submit();
        }

    function openConfirmationModal() {
        var errorMsg = document.getElementById('error-message');
        if (errorMsg) errorMsg.innerText = ""; // エラーをクリア

        // 1. 最新のテキストボックスの図書IDを取得
        var currentBookId = document.getElementById('inputBookId').value.trim();

        // 2. 図書IDが空、または6桁の数字じゃない場合は、エラーを表示してポップアップを開かせない
        if (currentBookId === "") {
            if (errorMsg) errorMsg.innerText = "図書IDを入力してください。";
            return;
        }
        if (!/^[0-9]{6}$/.test(currentBookId)) {
            if (errorMsg) errorMsg.innerText = "図書IDは6桁の数字（例: 000001）で入力してください。";
            return;
        }

        // --- ここから下は元の処理 ---
        var userId = document.getElementById('txtUserId').innerText.trim();
        var userName = document.getElementById('txtUserName').innerText.trim();
        var bookTitle = document.getElementById('txtBookTitle').innerText.trim();

        if (userName === "" || bookTitle === "") {
            document.getElementById('actionField').value = 'searchBook'; // アクションをsearchBookに合わせておきます
            document.getElementById('returnForm').submit();
            return;
        }
        
        // 最新の図書IDを、送信用の隠しフィールド(hidden)にも念のため上書き
        document.getElementById('hdnBookId').value = currentBookId;

        document.getElementById('popUserId').innerText = userId;
        document.getElementById('popUserName').innerText = userName;
        document.getElementById('popBookId').innerText = currentBookId; // 最新のIDを表示
        document.getElementById('popBookTitle').innerText = bookTitle;
        
        document.getElementById('confirmModal').style.display = 'flex';
    }

    function closeConfirmationModal() {
        document.getElementById('confirmModal').style.display = 'none';
    }

    // ポップアップの「確定」が押されたときの処理
    function submitReturn() {
        document.getElementById('actionField').value = 'return'; // サーブレットに送るアクション名
        document.getElementById('returnForm').submit();
    }
    </script>
</body>
</html>