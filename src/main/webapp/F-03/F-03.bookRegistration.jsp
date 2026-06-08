<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>蔵書登録入力画面</title>
    <!-- F-3用の共通CSSファイルを読み込む -->
    <link rel="stylesheet" href="F-03.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">蔵書登録入力画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding">
        
        <div class="error-message" id="error-message">
            利用できない文字が含まれています。使用可能文字（大小英数字、記号）
        </div>

        <!-- データの送信を想定したフォーム -->
        <form method="POST" action="F-3.bookRegistration.jsp" id="inputForm" style="display: flex; flex-direction: column; flex-grow: 1;">
            
            <table class="form-table">
                <tr>
                    <th>ISBN</th>
                    <td>
                        <input type="text" class="input-field" id="input-isbn" name="bookIsbn">
                        <button type="button" class="btn" onclick="document.getElementById('input-isbn').value=''">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>タイトル</th>
                    <td>
                        <input type="text" class="input-field" id="input-title" name="bookTitle">
                        <button type="button" class="btn" onclick="document.getElementById('input-title').value=''">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td>
                        <input type="text" class="input-field" id="input-author" name="bookAuthor">
                        <button type="button" class="btn" onclick="document.getElementById('input-author').value=''">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>出版社</th>
                    <td>
                        <input type="text" class="input-field" id="input-publisher" name="bookPublisher">
                        <button type="button" class="btn" onclick="document.getElementById('input-publisher').value=''">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>出版日</th>
                    <td>
                        <input type="text" class="input-field" id="input-date" name="bookDate" placeholder="YYYY/MM/DD">
                        <button type="button" class="btn" onclick="document.getElementById('input-date').value=''">クリア</button>
                    </td>
                </tr>
            </table>

            <button type="button" class="btn btn-register" onclick="showConfirmModal()">登録</button>
        </form>


        <!-- 1. 確認画面モーダル -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">確認画面</h2>
                
                <!-- 登録実行用のフォーム -->
                <form method="POST" action="F-3.bookRegistration.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
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
                        <!-- 何かを「実行」する確定ボタンは submit -->
                        <button type="submit" class="btn">確定</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 2. 完了画面モーダル -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="complete-message">登録が完了しました</div>
                
                <!-- 最終的に振り当てられた図書IDを表示する領域 -->
                <div class="book-id-display">
                    図書ID　<span id="generated-book-id">00000</span>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn" onclick="hideCompleteModal()">メニュー</button>
                    <button type="button" class="btn" onclick="hideCompleteModal()">続けて登録</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面操作用のJavaScript -->
    <script>
        function showConfirmModal() {
            const isbn = document.getElementById('input-isbn').value;
            const errorMessage = document.getElementById('error-message');
            
            // ISBNに半角英数字・記号・スペース以外の文字が含まれているかチェック
            const invalidRegex = /[^\x20-\x7E]/;
            
            if (invalidRegex.test(isbn) && isbn !== "") {
                errorMessage.style.display = 'block';
            } else {
                errorMessage.style.display = 'none';
                
                // 入力値をセット
                document.getElementById('confirm-isbn').value = isbn;
                document.getElementById('confirm-title').value = document.getElementById('input-title').value;
                document.getElementById('confirm-author').value = document.getElementById('input-author').value;
                document.getElementById('confirm-publisher').value = document.getElementById('input-publisher').value;
                document.getElementById('confirm-date').value = document.getElementById('input-date').value;

                document.getElementById('confirmModal').style.display = 'flex';
            }
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }
        
        function showCompleteModal() {
            document.getElementById('confirmModal').style.display = 'none';
            
            // サーバーから付与された図書IDをシミュレート（ランダムな5桁の数字など）
            const dummyId = Math.floor(Math.random() * 90000) + 10000;
            document.getElementById('generated-book-id').textContent = dummyId;

            document.getElementById('completeModal').style.display = 'flex';
        }
        
        function hideCompleteModal() {
            document.getElementById('completeModal').style.display = 'none';
            // 「続けて登録」などを押した場合に入力欄をクリアする処理を追加してもよいです
            document.getElementById('inputForm').reset();
        }
    </script>
</body>
</html>