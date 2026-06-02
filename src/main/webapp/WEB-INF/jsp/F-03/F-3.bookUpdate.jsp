<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>蔵書更新入力画面</title>
    <!-- F-3用の共通CSSファイルを読み込む -->
    <link rel="stylesheet" href="f3-style.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">蔵書更新入力画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding">
        
        <div class="error-message" id="error-message">
            この図書IDは存在しません
        </div>

        <!-- ▼ 検索(表示)用フォーム ▼ -->
        <form method="POST" action="F-3.bookUpdate.jsp" id="searchForm" onsubmit="searchBook(); return false;">
            <div class="id-search-group">
                <input type="text" class="input-field" id="search-id" name="searchId" placeholder="図書ID入力">
                <!-- 検索などの実行ボタンは submit -->
                <button type="submit" class="btn">表示</button>
            </div>
        </form>

        <!-- ▼ 更新データの送信フォーム ▼ -->
        <form method="POST" action="F-3.bookUpdate.jsp" id="inputForm" style="display: flex; flex-direction: column; flex-grow: 1;">
            
            <table class="form-table">
                <tr>
                    <th>ISBN</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-isbn" name="bookIsbn">
                    </td>
                </tr>
                <tr>
                    <th>タイトル</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-title" name="bookTitle">
                    </td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-author" name="bookAuthor">
                    </td>
                </tr>
                <tr>
                    <th>出版社</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-publisher" name="bookPublisher">
                    </td>
                </tr>
                <tr>
                    <th>出版日</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-date" name="bookDate">
                    </td>
                </tr>
            </table>

            <button type="button" class="btn btn-register" onclick="showConfirmModal()">登録</button>
        </form>


        <!-- 1. 確認画面モーダル -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">確認画面</h2>
                
                <!-- ▼ 実際に更新処理(実行)を行うボタンのフォーム ▼ -->
                <form method="POST" action="F-3.bookUpdate.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
                    <table class="confirm-table">
                        <tr>
                            <th>ISBN</th>
                            <td><input type="text" class="confirm-input" id="confirm-isbn" name="confirmIsbn" readonly></td>
                        </tr>
                        <tr>
                            <th>タイトル</th>
                            <td><input type="text" class="confirm-input" id="confirm-title" name="confirmTitle" readonly></td>
                        </tr>
                        <tr>
                            <th>著者</th>
                            <td><input type="text" class="confirm-input" id="confirm-author" name="confirmAuthor" readonly></td>
                        </tr>
                        <tr>
                            <th>出版社</th>
                            <td><input type="text" class="confirm-input" id="confirm-publisher" name="confirmPublisher" readonly></td>
                        </tr>
                        <tr>
                            <th>出版日</th>
                            <td><input type="text" class="confirm-input" id="confirm-date" name="confirmDate" readonly></td>
                        </tr>
                    </table>
                    
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="hideConfirmModal()">戻る</button>
                        <!-- 更新を実行する確定ボタンは submit -->
                        <button type="submit" class="btn">確定</button>
                    </div>
                </form>

            </div>
        </div>

        <!-- 2. 完了画面モーダル -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="complete-message" style="margin: 50px 0;">更新が完了しました</div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="hideCompleteModal()">メニュー</button>
                    <!-- 画像通り「続けて更新」としています -->
                    <button type="button" class="btn" onclick="hideCompleteModal()">続けて更新</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面操作用のJavaScript -->
    <script>
        // 【モック用】「表示」ボタンを押したときの挙動
        function searchBook() {
            const searchId = document.getElementById('search-id').value;
            const errorMessage = document.getElementById('error-message');
            
            if (!searchId || searchId.trim() === '') {
                // IDが空の場合はエラーメッセージを表示し、各項目をクリア
                errorMessage.style.display = 'block';
                
                document.getElementById('input-isbn').value = '';
                document.getElementById('input-title').value = '';
                document.getElementById('input-author').value = '';
                document.getElementById('input-publisher').value = '';
                document.getElementById('input-date').value = '';
            } else {
                // 何か入力されている場合はエラーを隠してダミーデータをセット
                errorMessage.style.display = 'none';
                
                // 画像通りのダミーデータ
                document.getElementById('input-isbn').value = '978-4-06-213962-4';
                document.getElementById('input-title').value = '赤朽葉家の伝説';
                document.getElementById('input-author').value = '桜庭一樹';
                document.getElementById('input-publisher').value = '講談社';
                document.getElementById('input-date').value = '2006/12/15';
            }
        }

        function showConfirmModal() {
            // 入力された値を取得して確認画面へセット
            document.getElementById('confirm-isbn').value = document.getElementById('input-isbn').value;
            document.getElementById('confirm-title').value = document.getElementById('input-title').value;
            document.getElementById('confirm-author').value = document.getElementById('input-author').value;
            document.getElementById('confirm-publisher').value = document.getElementById('input-publisher').value;
            document.getElementById('confirm-date').value = document.getElementById('input-date').value;

            // モーダルを表示
            document.getElementById('confirmModal').style.display = 'flex';
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }
        
        function showCompleteModal() {
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('completeModal').style.display = 'flex';
        }
        
        function hideCompleteModal() {
            document.getElementById('completeModal').style.display = 'none';
            // リセット処理
            document.getElementById('searchForm').reset();
            document.getElementById('inputForm').reset();
        }
    </script>
</body>
</html>