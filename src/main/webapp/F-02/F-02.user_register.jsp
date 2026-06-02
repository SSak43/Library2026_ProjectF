<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>利用者登録入力画面</title>
    <!-- 外部の共通CSSファイルを読み込む -->
    <link rel="stylesheet" href="F-02.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">利用者登録入力画面</h1>
        <button class="menu-button">メニュー</button>
    </div>

    <!-- 共通ベースクラス(main-content-base) ＋ 上詰め・余白ありレイアウトクラス(layout-top-padding) -->
    <div class="main-content-base layout-top-padding">
        
        <div class="error-message" id="error-message">
            利用できない文字が含まれています。使用可能文字（大小英数字、記号）
        </div>

        <div class="category-group">
            <div class="category-label">区分</div>
            <div class="category-options">
                <label><input type="radio" name="category"> 管理者</label>
                <label><input type="radio" name="category"> 司書</label>
                <label><input type="radio" name="category"> 利用者</label>
            </div>
        </div>

        <table class="form-table">
            <tr>
                <th>氏名</th>
                <td>
                    <input type="text" class="input-field" id="input-name">
                    <button class="btn" onclick="document.getElementById('input-name').value=''">クリア</button>
                </td>
            </tr>
            <tr>
                <th>電話番号</th>
                <td>
                    <input type="text" class="input-field" id="input-tel">
                    <button class="btn" onclick="document.getElementById('input-tel').value=''">クリア</button>
                </td>
            </tr>
            <tr>
                <th>利用者ID</th>
                <td>
                    <input type="text" class="input-field" value="00001" readonly>
                </td>
            </tr>
            <tr>
                <th>パスワード</th>
                <td>
                    <input type="text" class="input-field" id="input-pass">
                    <button class="btn" onclick="document.getElementById('input-pass').value=''">クリア</button>
                </td>
            </tr>
        </table>

        <!-- class="btn" (共通) と class="btn-register" (固有) を組み合わせる -->
        <button class="btn btn-register" onclick="showConfirmModal()">登録</button>


        <!-- 1. 確認画面モーダル -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">確認画面</h2>
                <table class="confirm-table">
                    <tr>
                        <th>氏名</th>
                        <td><input type="text" class="confirm-input" id="confirm-name" readonly></td>
                    </tr>
                    <tr>
                        <th>電話番号</th>
                        <td><input type="text" class="confirm-input" id="confirm-tel" readonly></td>
                    </tr>
                    <tr>
                        <th>利用者ID</th>
                        <td><input type="text" class="confirm-input" value="00001" readonly></td>
                    </tr>
                    <tr>
                        <th>パスワード</th>
                        <td><input type="text" class="confirm-input" id="confirm-pass" readonly></td>
                    </tr>
                </table>
                <div class="modal-actions">
                    <button class="btn" onclick="hideConfirmModal()">戻る</button>
                    <button class="btn" onclick="showCompleteModal()">確定</button>
                </div>
            </div>
        </div>

        <!-- 2. 完了画面モーダル -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="complete-message">登録が完了しました</div>
                <div class="modal-actions">
                    <button class="btn" onclick="hideCompleteModal()">メニュー</button>
                    <button class="btn" onclick="hideCompleteModal()">続けて登録</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面切り替え用のJavaScript -->
    <script>
        function showConfirmModal() {
            const tel = document.getElementById('input-tel').value;
            const pass = document.getElementById('input-pass').value;
            const errorMessage = document.getElementById('error-message');
            
            const invalidRegex = /[^\x20-\x7E]/;
            
            if (invalidRegex.test(tel) || invalidRegex.test(pass)) {
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
        
        function showCompleteModal() {
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('completeModal').style.display = 'flex';
        }
        
        function hideCompleteModal() {
            document.getElementById('completeModal').style.display = 'none';
        }
    </script>
</body>
</html>