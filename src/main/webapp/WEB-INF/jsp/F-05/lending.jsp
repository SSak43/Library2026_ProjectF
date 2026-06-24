<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書システム - 貸出入力画面</title>
    <link rel="stylesheet" href="/Library2026_ProjectF/css/lending/lending.css">
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
        <h1 class="header-title">貸出入力画面</h1>
        <button class="menu-button" type="button" onclick="location.href='<%= menuUrl %>'">メニュー</button>
    </div>

    <div class="main-box">
        <div class="error"><c:out value="${errorMessage}" /></div>
        
 <!-- 登録完了モーダル -->
            <div id="completeModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">登録完了</div>
    
            <div style="text-align: center; margin: 30px 0; font-size: 1.1rem; line-height: 1.6;">
                <p style="color: #2f5597; font-weight: bold;">
                    <c:out value="${successMessage}" />
                </p>
            </div>
  
            <div class="modal-buttons">
                <button type="button" class="modal-action-button" 
                        onclick="location.href='<%= menuUrl %>'">メニュー</button>
                <button type="button" class="modal-action-button" style="width: auto; font-size: 0.9rem;" 
                        onclick="location.href='${pageContext.request.contextPath}/lending'">続けて登録</button>
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

        <form id="lendForm" action="lending" method="post">
            <input type="hidden" id="hdnUserId" name="userId" value="${selectedUser != null ? selectedUser.userId : ''}">
            <input type="hidden" id="hdnBookId" name="bookId" value="${selectedBook != null ? selectedBook.bookId : ''}">
            <input type="hidden" id="actionField" name="action" value="">

            <div style="margin-bottom: 10px;">
			    <input type="text" id="inputUserId" placeholder="利用者ID入力" 
			           value="${not empty param.userId ? param.userId : (selectedUser != null ? String.format('%06d', selectedUser.userId) : '')}" 
			           class="input-field" autofocus required 
			           maxlength="6" pattern="[0-9]{6}" 
			           oninvalid="this.setCustomValidity('6桁の数字（例: 000001）を入力してください')" 
			           oninput="this.setCustomValidity('')">
			           
			    <button type="button" onclick="submitSearch('searchUser')" style="padding: 5px 20px; font-size: 1rem; background-color: #fff; border:1px solid;">表示</button>
			</div>
            <table>
                <tr>
                    <th>氏名</th>
                    <td id="txtUserName"><c:out value="${selectedUser.userName}" /></td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td><c:out value="${selectedUser.tel}" /></td>
                </tr>
                <tr>
                    <th>現在の貸出数</th>
                    <td>現在 <span style="font-weight: bold;"><c:out value="${activeLendsCount}" /></span> 冊 / 上限 5 冊</td>
                </tr>
            </table>

            <div style="margin-bottom: 10px;">
			    <input type="text" id="inputBookId" name="bookId" placeholder="図書IDを入力" 
			           value="${not empty param.bookId ? param.bookId : inputBookId}" 
			           class="input-field" required 
			           maxlength="6" pattern="[0-9]{6}" 
			           oninvalid="this.setCustomValidity('6桁の数字（例: 123456）を入力してください')" 
			           oninput="this.setCustomValidity('')">
			           
			    <button type="button" onclick="submitSearch('searchBook')" style="padding: 5px 20px; font-size: 1rem; background-color: #fff; border:1px solid;">表示</button>
			</div>

            <table>
                <tr>
                    <th>書名</th>
                    <td id="txtBookTitle"><c:out value="${selectedBook.title}" /></td>
                </tr>
                <tr>
                    <th>著者名</th>
                    <td><c:out value="${selectedBook.writerName}" /></td>
                </tr>
                <tr>
                    <th>状態</th>
                    <td>
                        <c:choose>
                            <c:when test="${selectedBook.bookStatus == '0'}">貸出可能</c:when>
                            <c:when test="${selectedBook.bookStatus == '1'}">貸出中</c:when>
                            <c:when test="${selectedBook.bookStatus == '2'}">貸出不可</c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>返却期限予定日</th>
                    <td><c:if test="${selectedBook != null}">貸出日から14日間</c:if></td>
                </tr>
            </table>
            <button type="button" class="btn-right" onclick="openConfirmationModal()"${empty selectedUser || empty selectedBook ? 'disabled' : ''}>登録</button>
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
                <button type="button" onclick="submitRegister()">確定</button>
            </div>
        </div>
    </div>

    <script>
        // 「表示」ボタンが押されたときの処理
        function submitSearch(actionType) {
            
            // 入力チェック（6桁かどうかなど）を満たしていない場合は、吹き出しを出して処理を止める
            if (actionType === 'searchUser') {
                if (!document.getElementById('inputUserId').reportValidity()) return;
            } else if (actionType === 'searchBook') {
                if (!document.getElementById('inputBookId').reportValidity()) return;
            }

            // 入力欄の最新の値を、送信用の隠しフィールド(hidden)に移し替える
            document.getElementById('hdnUserId').value = document.getElementById('inputUserId').value;
            document.getElementById('hdnBookId').value = document.getElementById('inputBookId').value;
            
            // アクション（searchUser または searchBook）をセットしてServletへ送信
            document.getElementById('actionField').value = actionType;
            document.getElementById('lendForm').submit();
        }

        // 「登録」ボタンが押されたときにポップアップを開く処理
        function openConfirmationModal() {
            var userName = document.getElementById('txtUserName').innerText.trim();
            var bookTitle = document.getElementById('txtBookTitle').innerText.trim();


            
            // 両方のデータが正しく表示されているかチェック
            if (userName === "" || bookTitle === "") {
             	document.getElementById('actionField').value = 'rend';
            	document.getElementById('lendForm').submit();
                return;
            }
            
            // ポップアップ内のスパンタグに、現在の画面の値をコピーする
            document.getElementById('popUserId').innerText = document.getElementById('inputUserId').value;
            document.getElementById('popUserName').innerText = userName;
            document.getElementById('popBookId').innerText = document.getElementById('inputBookId').value;
            document.getElementById('popBookTitle').innerText = bookTitle;
            
            // ポップアップを画面に表示する（flexにすることで中央揃えになる）
            document.getElementById('confirmModal').style.display = 'flex';
        }

        // ポップアップの「戻る」が押されたときの処理
        function closeConfirmationModal() {
            // 単に非表示にするだけ（入力値はそのまま残る）
            document.getElementById('confirmModal').style.display = 'none';
        }

        // ポップアップの「確定」が押されたときの処理
        function submitRegister() {
            // アクションに 'register' をセットして、本当のデータ送信を行う
            document.getElementById('actionField').value = 'register';
            document.getElementById('lendForm').submit();
        }
    </script>
</body>
</html>