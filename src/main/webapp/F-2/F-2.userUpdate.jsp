<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>更新入力画面</title>
    <!-- 外部の共通CSSファイルを読み込む -->
    <link rel="stylesheet" href="F-2.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">更新入力画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- 共通ベースクラス(main-content-base) ＋ 上詰め・余白ありレイアウトクラス(layout-top-padding) -->
    <div class="main-content-base layout-top-padding">
        
        <div class="error-message" id="error-message">
            この利用者IDは存在しません
        </div>

        <!-- ▼ 検索(表示)用フォーム ▼ -->
        <form method="POST" action="F-3.userUpdate.jsp" id="searchForm" onsubmit="searchUser(); return false;">
            <div class="id-search-group">
                <input type="text" class="input-field" id="search-id" name="searchId" placeholder="利用者ID入力">
                <!-- 検索などの実行ボタンは submit -->
                <button type="submit" class="btn">表示</button>
            </div>
        </form>

        <!-- ▼ 更新データの送信フォーム ▼ -->
        <form method="POST" action="F-3.userUpdate.jsp" id="inputForm" style="display: flex; flex-direction: column; flex-grow: 1;">
            
            <div class="category-group">
                <div class="category-label">区分</div>
                <div class="category-options">
                    <label><input type="radio" name="category" value="admin"> 管理者</label>
                    <label><input type="radio" name="category" value="librarian"> 司書</label>
                    <label><input type="radio" name="category" value="user" checked> 利用者</label>
                </div>
            </div>

            <table class="form-table">
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-name" name="userName">
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-tel" name="userTel">
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="text" class="input-field-update" id="input-pass" name="userPass">
                    </td>
                </tr>
            </table>

            <!-- 画面下部のアクションエリア（「利用」ラジオボタンと「登録」ボタン） -->
            <div class="bottom-actions">
                <div class="category-group" style="margin-bottom: 0;">
                    <div class="category-label">利用</div>
                    <div class="category-options">
                        <label><input type="radio" name="status" value="available" checked> 可</label>
                        <label><input type="radio" name="status" value="unavailable"> 不可</label>
                    </div>
                </div>
                
                <!-- 確認モーダルを開くトリガー -->
                <button type="button" class="btn btn-register" onclick="showConfirmModal()">登録</button>
            </div>
        </form>


        <!-- 1. 確認画面モーダル -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">確認画面</h2>
                
                <!-- ▼ 実際に更新処理(実行)を行うボタンのフォーム ▼ -->
                <form method="POST" action="F-3.userUpdate.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
                    <table class="confirm-table">
                        <tr>
                            <th>氏名</th>
                            <td><input type="text" class="confirm-input" id="confirm-name" name="confirmName" readonly></td>
                        </tr>
                        <tr>
                            <th>電話番号</th>
                            <td><input type="text" class="confirm-input" id="confirm-tel" name="confirmTel" readonly></td>
                        </tr>
                        <tr>
                            <th>パスワード</th>
                            <td><input type="text" class="confirm-input" id="confirm-pass" name="confirmPass" readonly></td>
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
                <div class="complete-message">登録が完了しました</div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="hideCompleteModal()">メニュー</button>
                    <button type="button" class="btn" onclick="hideCompleteModal()">続けて登録</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面切り替え用のJavaScript -->
    <script>
        // 【モック用】「表示」ボタンを押したときの挙動
        function searchUser() {
            const searchId = document.getElementById('search-id').value;
            const errorMessage = document.getElementById('error-message');
            
            if (!searchId || searchId.trim() === '') {
                // IDが空の場合はエラーメッセージを表示
                errorMessage.style.display = 'block';
                // 入力欄をクリア
                document.getElementById('input-name').value = '';
                document.getElementById('input-tel').value = '';
                document.getElementById('input-pass').value = '';
            } else {
                // 何か入力されている場合はエラーを隠してダミーデータを表示
                errorMessage.style.display = 'none';
                document.getElementById('input-name').value = '鑓野　雄大';
                document.getElementById('input-tel').value = '080-6285-3965';
                document.getElementById('input-pass').value = 'Rki +81 9463-4985';
            }
        }

        function showConfirmModal() {
            // 入力された値を取得して確認画面へセット
            const inputName = document.getElementById('input-name').value;
            const inputTel = document.getElementById('input-tel').value;
            const inputPass = document.getElementById('input-pass').value;

            document.getElementById('confirm-name').value = inputName;
            document.getElementById('confirm-tel').value = inputTel;
            document.getElementById('confirm-pass').value = inputPass;

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
        }
    </script>
</body>
</html>