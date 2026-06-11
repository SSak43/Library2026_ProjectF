<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登録画面</title>
    <!-- 絶対パス・キャッシュバスター・極限透過対応版 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-03.css">
    
    <!-- 【強制透過＆潰れバグ永久追放スタイル上書き】JSP側から完璧にセルの幅を制御するスタイルブロック -->
    <style type="text/css">
        .main-content-base, .layout-center {
            background-color: #d9d9d9 !important; /* メインコンテンツ全体はグレー背景 */
        }
        form, .form-table, .form-table tr, .form-table th, .form-table td {
            background: transparent !important;
            background-color: transparent !important; /* テーブルとセル内を完全に透明化 */
            box-shadow: none !important;
        }
        /* テーブルの幅計算のバグを防ぎ、しっかりと引き伸ばす */
        .form-table {
            width: 100% !important;
            table-layout: fixed !important;
            border-collapse: collapse !important;
            border: 1.5px solid #000 !important;
        }
        .form-table th {
            width: 18% !important; /* 見出し列を18%に固定（更新画面と完全同期） */
            font-size: 1.35rem !important; /* 文字をほんの少し小さくして確実に収める */
            font-weight: bold !important;
            border-bottom: 1.5px solid #000 !important;
            border-right: 1.5px solid #000 !important;
            padding: 12px 15px !important;
            color: #111 !important;
        }
        /* tdを標準のテーブルセルに強制リセットし、残りの82%の幅を確保 */
        .form-table td {
            display: table-cell !important;
            width: 82% !important;
            vertical-align: middle !important;
            padding: 12px 15px !important; /* セル内余白を適正化し、縦横の縮み・潰れを物理的に防ぐ */
            border-bottom: 1.5px solid #000 !important;
        }
        
        /* 入力ボックスとボタンを確実に美しく一列に収める、100%幅フレックスコンテナ */
        .input-flex-container {
            display: flex !important;
            width: 100% !important;
            align-items: center !important;
            gap: 15px !important;
            background: transparent !important;
        }
        
        /* 共通テキスト入力フィールド自体を確実に100%幅で表示（文字サイズ1.2rem、パディング10px 14px） */
        .input-flex-container .input-field {
            flex: 1 1 auto !important; /* 残りのスペースをすべて占有して引き伸ばす */
            width: 100% !important;
            min-width: 0 !important; /* フレックスボックス内で要素が極小に潰れるのを防ぐCSSの最重要ルール */
            padding: 10px 14px !important; /* 余白を少しスマートにして確実に収める */
            font-size: 1.2rem !important;  /* 文字サイズを1.2remに微調整（見やすさは維持） */
            border: 1.5px solid #666 !important;
            background-color: #fff !important;
            box-sizing: border-box !important;
            outline: none !important;
        }
        
       
        .input-flex-container .btn {
            flex-shrink: 0 !important;
            padding: 10px 20px !important;
            font-size: 1.1rem !important;
            background-color: #fff !important;
            border: 1.5px solid #666 !important;
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

            <!-- 登録用フォーム (インライン指定で白化バグを永久に遮断) -->
            <form method="POST" action="F-3.bookRegistration.jsp" id="bookRegistrationForm" style="display: flex; flex-direction: column; background: transparent !important; width: 100% !important;" onsubmit="return false;">
                
                <table class="form-table" style="width: 100% !important; margin-bottom: 30px; background: transparent !important;">
                    <!-- 1行目: 書名 & 個別リセット -->
                    <tr>
                        <th style="width: 18%;">書名</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-title" name="bookTitle" placeholder="書名を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-title');">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 2行目: 著者 & 個別リセット -->
                    <tr>
                        <th>著者</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-author" name="bookAuthor" placeholder="著者名を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-author');">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 3行目: 出版社 & 個別リセット -->
                    <tr>
                        <th>出版社</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-publisher" name="bookPublisher" placeholder="出版社名を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-publisher');">リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 4行目: 分類 & 個別リセット -->
                    <tr>
                        <th>分類</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-classification" name="bookClassification" placeholder="分類を入力してください">
                                <button type="button" class="btn" onclick="clearField('reg-classification');">リセット</button>
                            </div>
                        </td>
                    </tr>
                </table>

                <!-- 右端には「登録」ボタンだけを配置 -->
                <div style="display: flex; justify-content: flex-end; background: transparent !important;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="validateAndConfirm();" style="padding: 12px 65px; font-size: 1.2rem; background-color: #fff !important;">登録</button>
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
        // 各行の個別フィールド用リセット関数
        function clearField(fieldId) {
            document.getElementById(fieldId).value = '';
            document.getElementById('error-message').style.display = 'none';
        }

        // バリデーションチェック & 確認モーダルの表示
        function validateAndConfirm() {
            const title = document.getElementById('reg-title').value.trim();
            const author = document.getElementById('reg-author').value.trim();
            const publisher = document.getElementById('reg-publisher').value.trim();
            const classification = document.getElementById('reg-classification').value.trim();
            const errorMessage = document.getElementById('error-message');

            // すべての入力項目が必須となる簡易バリデーション
            if (title === '' || author === '' || publisher === '' || classification === '') {
                errorMessage.style.display = 'block';
                return;
            }

            // エラーを非表示に
            errorMessage.style.display = 'none';

            // 確認画面に入力値を複製
            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-author').value = author;
            document.getElementById('confirm-publisher').value = publisher;
            document.getElementById('confirm-classification').value = classification;

            // 確認モーダルを表示
            document.getElementById('confirmModal').style.display = 'flex';
        }

        // 確認モーダルを閉じる
        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // 完了モーダルを表示
        function showCompleteModal() {
            document.getElementById('confirmModal').style.display = 'none';
            const randomId = "B" + Math.floor(1000 + Math.random() * 9000);
            document.getElementById('generated-id-display').innerText = "図書ID: " + randomId;

            document.getElementById('completeModal').style.display = 'flex';
        }

        // メニュー画面に戻る
        function goToMenu() {
            window.location.href = 'F-3.bookManagement.jsp';
        }

        // 続けて登録するための初期化
        function resetAndContinue() {
            document.getElementById('completeModal').style.display = 'none';
            document.getElementById('bookRegistrationForm').reset();
        }
    </script>
</body>
</html>