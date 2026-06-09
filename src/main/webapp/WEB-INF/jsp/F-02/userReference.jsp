<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>参照画面</title>
    <link rel="stylesheet" href="F-02.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">参照画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding">
        
        <div class="error-message" id="error-message">
            この利用者IDは存在しません
        </div>

        <form method="POST" action="F-4.userReference.jsp" id="searchForm" onsubmit="searchUser(); return false;">
            <div class="id-search-group">
                <input type="text" class="input-field" id="search-id" name="searchId" placeholder="利用者ID入力">
                <button type="submit" class="btn">表示</button>
            </div>
        </form>

        <div id="displayArea" style="display: flex; flex-direction: column; flex-grow: 1;">
            
            <div class="category-group">
                <div class="category-label">区分</div>
                <div class="category-options">
                    <label><input type="radio" name="category" id="cat-admin" disabled> 管理者</label>
                    <label><input type="radio" name="category" id="cat-librarian" disabled> 司書</label>
                    <label><input type="radio" name="category" id="cat-user" disabled> 利用者</label>
                </div>
            </div>

            <table class="form-table">
                <tr>
                    <th>氏名</th>
                    <td>
                        <input type="text" class="input-field-update" id="display-name" readonly>
                    </td>
                </tr>
                <tr>
                    <th>電話番号</th>
                    <td>
                        <input type="text" class="input-field-update" id="display-tel" readonly>
                    </td>
                </tr>
                <tr>
                    <th>パスワード</th>
                    <td>
                        <input type="text" class="input-field-update" id="display-pass" readonly>
                    </td>
                </tr>
            </table>

            <div class="bottom-actions">
                <div class="category-group" style="margin-bottom: 0;">
                    <div class="category-label">利用</div>
                    <div class="category-options">
                        <label><input type="radio" name="status" id="stat-available" disabled> 可</label>
                        <label><input type="radio" name="status" id="stat-unavailable" disabled> 不可</label>
                    </div>
                </div>
                </div>
        </div>

    </div>

    <script>
        // 【モック用】「表示」ボタンを押したときの挙動
        function searchUser() {
            const searchId = document.getElementById('search-id').value;
            const errorMessage = document.getElementById('error-message');
            
            if (!searchId || searchId.trim() === '') {
                // IDが空の場合はエラーメッセージを表示し、各項目をクリア
                errorMessage.style.display = 'block';
                
                document.getElementById('display-name').value = '';
                document.getElementById('display-tel').value = '';
                document.getElementById('display-pass').value = '';
                
                // ラジオボタンのチェックを外す
                document.getElementById('cat-admin').checked = false;
                document.getElementById('cat-librarian').checked = false;
                document.getElementById('cat-user').checked = false;
                document.getElementById('stat-available').checked = false;
                document.getElementById('stat-unavailable').checked = false;
            } else {
                // IDが入力されている場合はエラーを隠してダミーデータをセット
                errorMessage.style.display = 'none';
                
                // テキスト情報
                document.getElementById('display-name').value = '鑓野　雄大';
                document.getElementById('display-tel').value = '080-6285-3965';
                document.getElementById('display-pass').value = 'Rki +81 9463-4985';
                
                // ラジオボタン（区分と利用状況）にチェックを入れる
                document.getElementById('cat-user').checked = true;
                document.getElementById('stat-available').checked = true;
            }
        }
    </script>
</body>
</html>