<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書システム - 貸出入力画面</title>
    <style>
        /* 簡単なレイアウト用のCSS */
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 200px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; position: relative; min-height: 450px; }
        .error { color: red; font-weight: bold; text-align: center; margin-bottom: 10px; }
        .success { color: green; font-weight: bold; text-align: center; margin-bottom: 10px; }
        table { width: 80%; border-collapse: collapse; margin-bottom: 20px; background: white; }
        table, th, td { border: 1px solid #666; }
        th, td { padding: 10px; text-align: left; }
        th { background: #e0e0e0; width: 20%; }
        .btn-right { position: absolute; bottom: 20px; right: 20px; padding: 10px 30px; font-size: 16px; }
        
        /* ★ポップアップ（モーダル）のCSS */
        .modal-overlay {
            display: none; /* 最初は非表示 */
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5); /* 背景を暗く半透明に */
            z-index: 1000; justify-content: center; align-items: center;
        }
        .modal-content {
            background: #d3d3d3; border: 3px solid #666; padding: 20px; width: 500px;
            box-shadow: 5px 5px 15px rgba(0,0,0,0.3);
        }
        .modal-title { text-align: center; font-weight: bold; margin-bottom: 15px; font-size: 18px; }
        .modal-buttons { display: flex; justify-content: space-around; margin-top: 20px; }
        .modal-buttons button { padding: 8px 25px; font-size: 14px; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">貸出入力画面</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        <div class="error"><c:out value="${errorMessage}" /></div>
        <div class="success"><c:out value="${successMessage}" /></div>

        <form id="lendForm" action="lending" method="post">
            <input type="hidden" id="hdnUserId" name="userId" value="${selectedUser != null ? selectedUser.userId : ''}">
            <input type="hidden" id="hdnBookId" name="bookId" value="${selectedBook != null ? selectedBook.bookId : ''}">
            <input type="hidden" id="actionField" name="action" value="">

            <div style="margin-bottom: 10px;">
                <input type="text" id="inputUserId" placeholder="利用者ID入力" value="${selectedUser != null ? selectedUser.userId : ''}">
                <button type="button" onclick="submitSearch('searchUser')">表示</button>
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
                <input type="text" id="inputBookId" placeholder="図書ID入力" value="${selectedBook != null ? selectedBook.bookId : ''}">
                <button type="button" onclick="submitSearch('searchBook')">表示</button>
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

            <button type="button" class="btn-right" onclick="openConfirmationModal()">登録</button>
        </form>
    </div>

    <div id="confirmModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-title">確認画面</div>
            <table style="width: 100%;">
                <tr>
                    <th style="width: 30%;">利用者ID</th>
                    <td><span id="popUserId"></span></td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td><span id="popUserName"></span></td>
                </tr>
                <tr>
                    <th>図書ID</th>
                    <td><span id="popBookId"></span></td>
                </tr>
                <tr>
                    <th>書名</th>
                    <td><span id="popBookTitle"></span></td>
                </tr>
            </table>
            <div class="modal-buttons">
                <button type="button" onclick="closeConfirmationModal()">戻る</button>
                <button type="button" onclick="submitRegister()" style="background: #fff; font-weight: bold;">確定</button>
            </div>
        </div>
    </div>

    <script>
        // 「表示」ボタンが押されたときの処理
        function submitSearch(actionType) {
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
                alert("利用者と図書をそれぞれ検索して表示させてから、登録を行ってください。");
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