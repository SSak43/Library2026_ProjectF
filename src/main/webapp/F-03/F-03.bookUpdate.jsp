<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>更新画面</title>
    <!-- キャッシュバスターを更新 -->
    <link class="style-link" rel="stylesheet" href="F-03.css?v=20260608_id_search_left_aligned">
</head>
<body>

    <!-- ヘッダー -->
    <div class="header">
        <h1 class="header-title">更新画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツエリア (グレー背景＋青枠) -->
    <div class="main-content-base layout-top-padding">
        
        <!-- 横幅を極限まで引き伸ばした中央寄りのレイアウト全体コンテナ -->
        <div style="width: 95%; max-width: 1000px; margin: 0 auto; display: flex; flex-direction: column; flex-grow: 1;">
            
            <div class="error-message" id="error-message" style="margin-bottom: 20px; text-align: center;">
                入力されていない必須項目があります
            </div>

            <!-- ① 上部：図書ID検索バー (入力欄を左寄せコンパクトに制御) -->
            <div class="id-search-bar">
                <span class="id-search-label">図書ID</span>
                <div class="id-search-input-wrapper">
                    <!-- id-search-field-compact クラスを適用して、幅をスリムに左寄せ配置 -->
                    <input type="text" class="input-field id-search-field-compact" id="search-book-id" placeholder="図書IDを入力してください (例: B0001)">
                    <button type="button" class="btn" onclick="searchBookById();" style="padding: 6px 30px; font-size: 1.1rem; flex-shrink: 0;">検索</button>
                </div>
            </div>

            <!-- 更新用フォーム (最下部までflexで引き伸ばしてボタンを右下に固定配置) -->
            <form method="POST" action="F-3.bookUpdate.jsp" id="bookUpdateForm" style="display: flex; flex-direction: column; flex-grow: 1;" onsubmit="return false;">
                
                <!-- ② 中央：5項目になった横長入力フォームテーブル -->
                <table class="form-table" style="width: 100%; margin-bottom: 25px;">
                    <!-- 1行目: 書名 -->
                    <tr>
                        <th style="width: 15%;">書名</th>
                        <td>
                            <div style="display: flex; gap: 15px; width: 100%; align-items: center;">
                                <input type="text" class="input-field" id="reg-title" name="bookTitle" placeholder="図書IDで検索するか、入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-title');" style="padding: 6px 20px; font-size: 1.1rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 2行目: 著者 -->
                    <tr>
                        <th>著者</th>
                        <td>
                            <div style="display: flex; gap: 15px; width: 100%; align-items: center;">
                                <input type="text" class="input-field" id="reg-author" name="bookAuthor" placeholder="図書IDで検索するか、入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-author');" style="padding: 6px 20px; font-size: 1.1rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 3行目: 出版社 -->
                    <tr>
                        <th>出版社</th>
                        <td>
                            <div style="display: flex; gap: 15px; width: 100%; align-items: center;">
                                <input type="text" class="input-field" id="reg-publisher" name="bookPublisher" placeholder="図書IDで検索するか、入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-publisher');" style="padding: 6px 20px; font-size: 1.1rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 4行目: 分類 -->
                    <tr>
                        <th>分類</th>
                        <td>
                            <div style="display: flex; gap: 15px; width: 100%; align-items: center;">
                                <input type="text" class="input-field" id="reg-classification" name="bookClassification" placeholder="図書IDで検索するか、入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-classification');" style="padding: 6px 20px; font-size: 1.1rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 5行目: 蔵書状態 -->
                    <tr>
                        <th>蔵書状態</th>
                        <td>
                            <div style="display: flex; gap: 15px; width: 100%; align-items: center;">
                                <input type="text" class="input-field" id="reg-status" name="bookStatus" placeholder="図書IDで検索するか、入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-status');" style="padding: 6px 20px; font-size: 1.1rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                </table>

                <!-- ③ 下部：共通デザインに合わせた最右下固定の「更新」ボタン -->
                <div style="display: flex; justify-content: flex-end; margin-top: auto; padding-top: 15px;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="validateAndConfirm();" style="padding: 10px 50px;">更新</button>
                </div>

            </form>
        </div>


        <!-- 確認画面モーダル (ポップアップ) -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">更新確認</h2>
                <form method="POST" action="F-3.bookUpdate.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
                    <table class="confirm-table">
                        <tr>
                            <th style="width: 30%;">図書ID</th>
                            <td><input type="text" class="confirm-input" id="confirm-id" name="confirmId" readonly></td>
                        </tr>
                        <tr>
                            <th>書名</th>
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
                            <th>分類</th>
                            <td><input type="text" class="confirm-input" id="confirm-classification" name="confirmClassification" readonly></td>
                        </tr>
                        <tr>
                            <th>蔵書状態</th>
                            <td><input type="text" class="confirm-input" id="confirm-status" name="confirmStatus" readonly></td>
                        </tr>
                    </table>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="hideConfirmModal()">戻る</button>
                        <button type="submit" class="btn">確定</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 完了画面モーダル (ポップアップ) -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="complete-message">更新が完了しました</div>
                <div class="book-id-display" id="generated-id-display">図書ID: B0001</div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="goToMenu()">メニュー</button>
                    <button type="button" class="btn" onclick="resetAndContinue()">続けて更新</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面操作スクリプト -->
    <script>
        // デモ用のデータベース
        const bookDatabaseMock = {
            "B0001": { title: "赤朽葉家の伝説", author: "桜庭一樹", publisher: "講談社", classification: "小説", status: "貸出可能" },
            "B0002": { title: "人間失格", author: "太宰治", publisher: "新潮社", classification: "文学", status: "貸出可能" },
            "B0003": { title: "ノルウェイの森 (上)", author: "村上春樹", publisher: "講談社", classification: "小説", status: "修理中" },
            "B0004": { title: "ノルウェイの森 (下)", author: "村上春樹", publisher: "講談社", classification: "小説", status: "貸出可能" },
            "B0005": { title: "容疑者Xの献身", author: "東野圭吾", publisher: "小学館", classification: "ミステリー", status: "貸出不可" }
        };

        // 図書IDで本を検索してフォームに自動入力する関数
        function searchBookById() {
            const searchId = document.getElementById('search-book-id').value.trim().toUpperCase();
            const errorMessage = document.getElementById('error-message');

            if (searchId === '') {
                errorMessage.innerText = "図書IDを入力してください";
                errorMessage.style.display = 'block';
                return;
            }

            const bookData = bookDatabaseMock[searchId];
            if (bookData) {
                document.getElementById('reg-title').value = bookData.title;
                document.getElementById('reg-author').value = bookData.author;
                document.getElementById('reg-publisher').value = bookData.publisher;
                document.getElementById('reg-classification').value = bookData.classification;
                document.getElementById('reg-status').value = bookData.status;

                errorMessage.style.display = 'none';
            } else {
                errorMessage.innerText = "該当する図書が見つかりませんでした (デモ対応ID: B0001 〜 B0005)";
                errorMessage.style.display = 'block';
                clearAllFields();
            }
        }

        // 各行の個別フィールド用リセット関数
        function clearField(fieldId) {
            document.getElementById(fieldId).value = '';
            document.getElementById('error-message').style.display = 'none';
        }

        // 全フィールドクリア
        function clearAllFields() {
            document.getElementById('reg-title').value = '';
            document.getElementById('reg-author').value = '';
            document.getElementById('reg-publisher').value = '';
            document.getElementById('reg-classification').value = '';
            document.getElementById('reg-status').value = '';
        }

        // バリデーションチェック & 確認モーダルの表示
        function validateAndConfirm() {
            const searchId = document.getElementById('search-book-id').value.trim().toUpperCase();
            const title = document.getElementById('reg-title').value.trim();
            const author = document.getElementById('reg-author').value.trim();
            const publisher = document.getElementById('reg-publisher').value.trim();
            const classification = document.getElementById('reg-classification').value.trim();
            const status = document.getElementById('reg-status').value.trim();
            const errorMessage = document.getElementById('error-message');

            if (searchId === '') {
                errorMessage.innerText = "図書IDを入力して検索を行ってください";
                errorMessage.style.display = 'block';
                return;
            }

            if (title === '' || author === '' || publisher === '' || classification === '' || status === '') {
                errorMessage.innerText = "入力されていない必須項目があります";
                errorMessage.style.display = 'block';
                return;
            }

            errorMessage.style.display = 'none';

            // 確認画面に入力値を複製
            document.getElementById('confirm-id').value = searchId;
            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-author').value = author;
            document.getElementById('confirm-publisher').value = publisher;
            document.getElementById('confirm-classification').value = classification;
            document.getElementById('confirm-status').value = status;

            // 確認モーダルを表示
            document.getElementById('confirmModal').style.display = 'flex';
        }

        // 確認モーダルを閉じる
        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // 完了モーダルを表示
        function showCompleteModal() {
            const searchId = document.getElementById('search-book-id').value.trim().toUpperCase();
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('generated-id-display').innerText = "図書ID: " + searchId;
            document.getElementById('completeModal').style.display = 'flex';
        }

        // メニュー画面に戻る
        function goToMenu() {
            window.location.href = 'F-3.bookManagement.jsp';
        }

        // 続けて更新するための初期化
        function resetAndContinue() {
            document.getElementById('completeModal').style.display = 'none';
            document.getElementById('search-book-id').value = '';
            clearAllFields();
        }
    </script>
</body>
</html>