<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>更新画面</title>
    <!-- 絶対パス表記、キャッシュバスター、極限透過対応版 -->
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
            width: 18% !important; /* 見出し列を18%に固定 */
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
        
        /* 共通テキスト入力フィールド自体を確実に100%幅で表示（文字サイズを 1.2rem、パディングを 10px 14px に調整） */
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
        
        /* 入力できない非活性（disabled）時のボックスをグレーの塗りつぶし状態にするガード */
        .input-flex-container .input-field:disabled {
            background-color: #b0b0b0 !important;
            color: #555 !important;
            border: 1.5px solid #777 !important;
            cursor: not-allowed;
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
        <h1 class="header-title">更新画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツエリア (上下左右中央配置) -->
    <div class="main-content-base layout-center">
        
        <!-- コンテナの最大幅上限を 1300px に引き上げ、圧倒的なワイドサイズを実現 -->
        <div style="width: 95%; max-width: 1300px; padding: 10px; display: flex; flex-direction: column;">
            
            <div class="error-message" id="error-message" style="margin-bottom: 20px; text-align: center;">
                入力されていない必須項目があります
            </div>

            <!-- ① 上部：図書ID検索バー (競合するクラス名を完全排除し、直接透過レイアウトを適用。幅を350pxに絶対固定) -->
            <div style="padding: 0 !important; display: flex !important; gap: 20px !important; align-items: center !important; width: 100% !important; margin-bottom: 25px !important; flex-shrink: 0 !important; background: transparent !important; background-color: transparent !important; border: none !important; box-shadow: none !important;">
                <div style="display: flex !important; gap: 20px !important; align-items: center !important; width: 100% !important; background: transparent !important; background-color: transparent !important; border: none !important;">
                    <!-- 入力欄の幅を 350px に絶対固定して左寄せ配置。縮むのを強力に防ぎます -->
                    <input type="text" class="input-field id-search-field-compact" id="search-book-id" name="searchBookId" placeholder="図書IDを入力してください " style="width: 350px !important; flex-shrink: 0 !important; padding: 10px 14px !important; font-size: 1.2rem !important;">
                    <button type="button" class="btn" onclick="searchBookById();" style="padding: 10px 30px; font-size: 1.15rem; flex-shrink: 0; background-color: #fff !important; border: 1.5px solid #666 !important;">検索</button>
                </div>
            </div>

            <!-- 更新用フォーム (大元が縮むバグを防ぐため、width: 100% を強制指定) -->
            <form method="POST" action="F-3.bookUpdate.jsp" id="bookUpdateForm" style="display: flex; flex-direction: column; background: transparent !important; width: 100% !important;" onsubmit="return false;">
                
                <!-- ② 中央：すべての行にリセットボタンがある5項目横長フォーム (初期状態はすべて非活性: disabled) -->
                <!-- つぶれ防止のためのスマート＆絶対安定設計を採用 -->
                <table class="form-table" style="width: 100%; margin-bottom: 25px; background: transparent !important;">
                    
                    <!-- 1行目: 書名 -->
                    <tr>
                        <th style="width: 18%;">書名</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-title" name="bookTitle" placeholder="図書IDで検索してください" disabled>
                                <button type="button" class="btn" id="btn-reset-title" onclick="clearField('reg-title');" disabled>リセット</button>
                            </div>
                        </td>
                    </tr>
                    
                    <!-- 2行目: 著者 -->
                    <tr>
                        <th>著者</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-author" name="bookAuthor" placeholder="図書IDで検索してください" disabled>
                                <button type="button" class="btn" id="btn-reset-author" onclick="clearField('reg-author');" disabled>リセット</button>
                            </div>
                        </td>
                    </tr>
                    
                    <!-- 3行目: 出版社 -->
                    <tr>
                        <th>出版社</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-publisher" name="bookPublisher" placeholder="図書IDで検索してください" disabled>
                                <button type="button" class="btn" id="btn-reset-publisher" onclick="clearField('reg-publisher');" disabled>リセット</button>
                            </div>
                        </td>
                    </tr>
                    
                    <!-- 4行目: 分類 -->
                    <tr>
                        <th>分類</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-classification" name="bookClassification" placeholder="図書IDで検索してください" disabled>
                                <button type="button" class="btn" id="btn-reset-classification" onclick="clearField('reg-classification');" disabled>リセット</button>
                            </div>
                        </td>
                    </tr>
                    
                    <!-- 5行目: 蔵書状態 -->
                    <tr>
                        <th>蔵書状態</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="reg-status" name="bookStatus" placeholder="図書IDで検索してください" disabled>
                                <button type="button" class="btn" id="btn-reset-status" onclick="clearField('reg-status');" disabled>リセット</button>
                            </div>
                        </td>
                    </tr>
                    
                </table>

                <!-- ③ 下部：共通デザインに合わせた右下の「更新」ボタン (初期状態は非活性) -->
                <div style="display: flex; justify-content: flex-end; padding-top: 15px; background: transparent !important;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="validateAndConfirm();" style="padding: 12px 65px; font-size: 1.2rem; background-color: #fff !important;" disabled>更新</button>
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
                <div class="book-id-display" id="generated-id-display" style="font-size: 1.45rem; text-align: center; margin-bottom: 20px; font-weight: bold; color: #111;">図書ID: B0001</div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="goToMenu()">メニュー</button>
                    <button type="button" class="btn" onclick="resetAndContinue()">続けて更新</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面操作スクリプト -->
    <script>
        const bookDatabaseMock = {
            "B0001": { title: "赤朽葉家の伝説", author: "桜庭一樹", publisher: "講談社", classification: "小説", status: "貸出可能" },
            "B0002": { title: "人間失格", author: "太宰治", publisher: "新潮社", classification: "文学", status: "貸出可能" },
            "B0003": { title: "ノルウェイの森 (上)", author: "村上春樹", publisher: "講談社", classification: "小説", status: "修理中" },
            "B0004": { title: "ノルウェイの森 (下)", author: "村上春樹", publisher: "講談社", classification: "小説", status: "貸出可能" },
            "B0005": { title: "容疑者Xの献身", author: "東野圭吾", publisher: "小学館", classification: "ミステリー", status: "貸出不可" }
        };

        // 入力フォーム全体の活性/非活性状態を切り替える補助関数
        function setFormDisabledState(disabled) {
            // 各入力欄
            document.getElementById('reg-title').disabled = disabled;
            document.getElementById('reg-author').disabled = disabled;
            document.getElementById('reg-publisher').disabled = disabled;
            document.getElementById('reg-classification').disabled = disabled;
            document.getElementById('reg-status').disabled = disabled;

            // プレースホルダーの文字も優しく切り替え
            const placeholderText = disabled ? "図書IDで検索してください" : "情報を入力してください";
            document.getElementById('reg-title').placeholder = placeholderText;
            document.getElementById('reg-author').placeholder = placeholderText;
            document.getElementById('reg-publisher').placeholder = placeholderText;
            document.getElementById('reg-classification').placeholder = disabled ? "図書IDで検索してください" : "分類を入力してください";
            document.getElementById('reg-status').placeholder = placeholderText;

            // 各リセットボタン
            document.getElementById('btn-reset-title').disabled = disabled;
            document.getElementById('btn-reset-author').disabled = disabled;
            document.getElementById('btn-reset-publisher').disabled = disabled;
            document.getElementById('btn-reset-classification').disabled = disabled;
            document.getElementById('btn-reset-status').disabled = disabled;

            // 更新ボタン
            document.getElementById('btn-submit').disabled = disabled;
        }

        function searchBookById() {
            const searchInput = document.getElementById('search-book-id');
            if (!searchInput) {
                console.error("入力エレメント(search-book-id)が見つかりません");
                return;
            }
            
            const searchId = searchInput.value.trim().toUpperCase();
            const errorMessage = document.getElementById('error-message');

            if (searchId === '') {
                errorMessage.innerText = "図書IDを入力してください";
                errorMessage.style.display = 'block';
                setFormDisabledState(true); // 空欄検索時はロック
                return;
            }

            const bookData = bookDatabaseMock[searchId];
            if (bookData) {
                // ロックを解除して値をセット
                setFormDisabledState(false);
                
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
                setFormDisabledState(true); // 検索失敗時は再びロック
            }
        }

        function clearField(fieldId) {
            document.getElementById(fieldId).value = '';
            document.getElementById('error-message').style.display = 'none';
        }

        function clearAllFields() {
            document.getElementById('reg-title').value = '';
            document.getElementById('reg-author').value = '';
            document.getElementById('reg-publisher').value = '';
            document.getElementById('reg-classification').value = '';
            document.getElementById('reg-status').value = '';
        }

        function validateAndConfirm() {
            const searchInput = document.getElementById('search-book-id');
            const searchId = searchInput ? searchInput.value.trim().toUpperCase() : '';
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

            document.getElementById('confirm-id').value = searchId;
            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-author').value = author;
            document.getElementById('confirm-publisher').value = publisher;
            document.getElementById('confirm-classification').value = classification;
            document.getElementById('confirm-status').value = status;

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        function showCompleteModal() {
            const searchInput = document.getElementById('search-book-id');
            const searchId = searchInput ? searchInput.value.trim().toUpperCase() : 'B0001';
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('generated-id-display').innerText = "図書ID: " + searchId;
            document.getElementById('completeModal').style.display = 'flex';
        }

        function goToMenu() {
            window.location.href = 'F-3.bookManagement.jsp';
        }

        function resetAndContinue() {
            document.getElementById('completeModal').style.display = 'none';
            const searchInput = document.getElementById('search-book-id');
            if (searchInput) searchInput.value = '';
            clearAllFields();
            setFormDisabledState(true); // 初期ロック状態に戻す
        }
    </script>
</body>
</html>