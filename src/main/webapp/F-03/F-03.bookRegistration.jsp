<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登録画面</title>
    <!-- 絶対パス・キャッシュバスター・極限透過対応版 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-03.css">
    
    <!-- 【強制透過スタイル上書き】JSP側からセルの白塗りを強制的に破壊するスタイルブロック -->
    <style type="text/css">
        .main-content-base, .layout-center {
            background-color: #d9d9d9 !important; /* メインコンテンツ全体はグレー背景 */
        }
        form, .form-table, .form-table tr, .form-table th, .form-table td {
            background: transparent !important;
            background-color: transparent !important; /* テーブルとセル内を完全に透明化 */
            box-shadow: none !important;
        }
        .input-field, .btn, .btn-register {
            /* 入力ボックスとボタン自体のみ白背景を維持します */
        }
    </style>
</head>
<body>

    <!-- ヘッダー -->
    <div class="header">
        <h1 class="header-title">登録画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツエリア (上下左右完全に中央配置) -->
    <div class="main-content-base layout-center">
        
        <!-- 横幅を極限まで引き伸ばしたコンテナ (max-width: 1300px の限界ワイド仕様) -->
        <div style="width: 95% !important; max-width: 1300px !important; padding: 10px; display: flex; flex-direction: column; background: transparent !important; border: none !important;">
            
            <div class="error-message" id="error-message" style="margin-bottom: 25px; text-align: center;">
                入力されていない必須項目があります
            </div>

            <!-- 登録用フォーム -->
            <form method="POST" action="F-3.bookRegistration.jsp" id="bookRegistrationForm" style="display: flex; flex-direction: column; background: transparent !important;" onsubmit="return false;">
                
                <table class="form-table" style="width: 100% !important; margin-bottom: 30px; background: transparent !important;">
                    <!-- 1行目: 書名 & 個別リセット -->
                    <tr>
                        <th style="width: 18%;">書名</th>
                        <td>
                            <div style="display: flex; gap: 20px; width: 100%; align-items: center; background: transparent !important;">
                                <input type="text" class="input-field" id="reg-title" name="bookTitle" placeholder="書名を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-title');" style="padding: 12px 30px; font-size: 1.25rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 2行目: 著者 & 個別リセット -->
                    <tr>
                        <th>著者</th>
                        <td>
                            <div style="display: flex; gap: 20px; width: 100%; align-items: center; background: transparent !important;">
                                <input type="text" class="input-field" id="reg-author" name="bookAuthor" placeholder="著者名を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-author');" style="padding: 12px 30px; font-size: 1.25rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 3行目: 出版社 & 個別リセット -->
                    <tr>
                        <th>出版社</th>
                        <td>
                            <div style="display: flex; gap: 20px; width: 100%; align-items: center; background: transparent !important;">
                                <input type="text" class="input-field" id="reg-publisher" name="bookPublisher" placeholder="出版社名を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-publisher');" style="padding: 12px 30px; font-size: 1.25rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 4行目: 分類 & 個別リセット -->
                    <tr>
                        <th>分類</th>
                        <td>
                            <div style="display: flex; gap: 20px; width: 100%; align-items: center; background: transparent !important;">
                                <input type="text" class="input-field" id="reg-classification" name="bookClassification" placeholder="分類を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-classification');" style="padding: 12px 30px; font-size: 1.25rem; flex-shrink: 0;">リセット</button>
                            </div>
                        </td>
                    </tr>
                </table>

                <!-- 右端には「登録」ボタンだけを配置 -->
                <div style="display: flex; justify-content: flex-end; background: transparent !important;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="validateAndConfirm();" style="padding: 14px 85px; font-size: 1.35rem;">登録</button>
                </div>

            </form>
        </div>


        <!-- 1. 確認画面モーダル (ポップアップ) -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">登録確認</h2>
                <form method="POST" action="F-3.bookRegistration.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
                    <table class="confirm-table">
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
                    </table>
                    <div class="modal-actions">
                        <button type="button" class="btn" onclick="hideConfirmModal()">戻る</button>
                        <button type="submit" class="btn">確定</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 2. 完了画面モーダル (ポップアップ) -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="complete-message">登録が完了しました</div>
                <div class="book-id-display" id="generated-id-display" style="font-size: 1.45rem; text-align: center; margin-bottom: 20px; font-weight: bold; color: #111;">図書ID: B0016</div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="goToMenu()">メニュー</button>
                    <button type="button" class="btn" onclick="resetAndContinue()">続けて登録</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面操作スクリプト -->
    <script>
        function clearField(fieldId) {
            document.getElementById(fieldId).value = '';
            document.getElementById('error-message').style.display = 'none';
        }

        function validateAndConfirm() {
            const title = document.getElementById('reg-title').value.trim();
            const author = document.getElementById('reg-author').value.trim();
            const publisher = document.getElementById('reg-publisher').value.trim();
            const classification = document.getElementById('reg-classification').value.trim();
            const errorMessage = document.getElementById('error-message');

            if (title === '' || author === '' || publisher === '' || classification === '') {
                errorMessage.style.display = 'block';
                return;
            }

            errorMessage.style.display = 'none';

            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-author').value = author;
            document.getElementById('confirm-publisher').value = publisher;
            document.getElementById('confirm-classification').value = classification;

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        function showCompleteModal() {
            document.getElementById('confirmModal').style.display = 'none';
            const randomId = "B" + Math.floor(1000 + Math.random() * 9000);
            document.getElementById('generated-id-display').innerText = "図書ID: " + randomId;

            document.getElementById('completeModal').style.display = 'flex';
        }

        function goToMenu() {
            window.location.href = 'F-3.bookManagement.jsp';
        }

        function resetAndContinue() {
            document.getElementById('completeModal').style.display = 'none';
            document.getElementById('bookRegistrationForm').reset();
        }
    </script>
</body>
</html>