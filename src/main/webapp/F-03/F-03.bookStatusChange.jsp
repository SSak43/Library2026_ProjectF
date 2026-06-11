<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>状態変更画面</title>
    <!-- 絶対パス表記、キャッシュバスター、極限透過対応版 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-03.css">
    
    <!-- 【強制透過＆潰れバグ永久追放スタイル上書き】JSP側から完璧にセルの幅と状態変化を制御するスタイルガード -->
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
        .input-flex-container .input-field, .input-flex-container .input-field-update, .input-flex-container .select-field {
            flex: 1 1 auto !important; /* 残りのスペースをすべて占有して引き伸ばす */
            width: 100% !important;
            min-width: 0 !important; /* フレックスボックス内で要素が極小に潰れるのを防ぐCSSの最重要ルール */
            padding: 10px 14px !important; /* 余白を少しスマートにして確実に収める */
            font-size: 1.2rem !important;  /* 文字サイズを1.2remに微調整（見やすさは維持） */
            border: 1.5px solid #666 !important;
            box-sizing: border-box !important;
            outline: none !important;
        }
        
        /* 入力欄の活性時の白背景 */
        .input-flex-container .input-field, .input-flex-container .select-field {
            background-color: #fff !important;
        }

        /* 入力できない非活性（disabled/readonly）時のボックスをグレーの塗りつぶし状態にするガード */
        .input-flex-container .input-field:disabled, .input-flex-container .input-field-update, .input-flex-container .select-field:disabled {
            background-color: #b0b0b0 !important;
            color: #555 !important;
            border: 1.5px solid #777 !important;
            cursor: not-allowed;
        }
        
        /* ボタンが絶対に縮まないように保護 */
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
        <h1 class="header-title">状態変更画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツエリア (上下左右中央配置) -->
    <div class="main-content-base layout-center">
        
        <!-- コンテナの最大幅上限を 1300px に引き上げ、圧倒的なワイドサイズを実現 -->
        <div style="width: 95%; max-width: 1300px; padding: 10px; display: flex; flex-direction: column;">

            <div class="error-message" id="error-message" style="margin-bottom: 20px; text-align: center;">
                この図書IDは存在しません
            </div>

            <!-- ① 上部：図書ID検索バー (白枠問題を物理的に解決するため、競合するクラス名を完全排除して直接透過レイアウトを適用) -->
            <div style="padding: 0 !important; display: flex !important; gap: 20px !important; align-items: center !important; width: 100% !important; margin-bottom: 25px !important; flex-shrink: 0 !important; background: transparent !important; background-color: transparent !important; border: none !important; box-shadow: none !important;">
                <div style="display: flex !important; gap: 20px !important; align-items: center !important; width: 100% !important; background: transparent !important; background-color: transparent !important; border: none !important;">
                    <input type="text" class="input-field id-search-field-compact" id="search-id" name="searchId" placeholder="図書IDを入力してください " style="width: 350px !important; flex-shrink: 0 !important; padding: 10px 14px !important; font-size: 1.2rem !important;">
                    <button type="button" class="btn" style="padding: 10px 30px; font-size: 1.15rem; flex-shrink: 0; background-color: #fff !important; border: 1.5px solid #666 !important;" onclick="searchBook();">表示</button>
                </div>
            </div>

            <!-- 送信フォーム (中央寄せ用レイアウトにフィット) -->
            <form method="POST" action="F-3.bookStatusChange.jsp" id="bookStatusForm" style="display: flex; flex-direction: column; background: transparent !important; width: 100% !important;" onsubmit="return false;">
                
                <!-- ② 中央：4項目になった横長フォームテーブル -->
                <table class="form-table" style="width: 100%; margin-bottom: 25px; background: transparent !important;">
                    <!-- 1行目: 書名 (右側にリセットボタンを配置。活性・非活性を動的制御できるよう、input-fieldクラスに切り替え) -->
                    <tr>
                        <th style="width: 18%;">書名</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field" id="input-title" name="bookTitle" placeholder="図書IDを表示してください" disabled>
                                <button type="button" class="btn" id="btn-reset-title" onclick="clearField('input-title');" disabled>リセット</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 2行目: 貸出状況 (編集不可) -->
                    <tr>
                        <th>貸出状況</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field-update" id="input-loan-status" name="bookLoanStatus" readonly placeholder="図書IDを表示してください">
                            </div>
                        </td>
                    </tr>
                    <!-- 3行目: 予約状況 (編集不可) -->
                    <tr>
                        <th>予約状況</th>
                        <td>
                            <div class="input-flex-container">
                                <input type="text" class="input-field-update" id="input-reserve-status" name="bookReserveStatus" readonly placeholder="図書IDを表示してください">
                            </div>
                        </td>
                    </tr>
                    <!-- 4行目: 本の状態 (編集可) -->
                    <tr>
                        <th>本の状態</th>
                        <td>
                            <div class="input-flex-container">
                                <select class="select-field" id="input-status" name="bookStatus" disabled style="max-width: 450px !important;">
                                    <option value="" id="status-placeholder" selected>図書IDを表示してください</option>
                                    <option value="貸出可能">貸出可能</option>
                                    <option value="貸出不可">貸出不可</option>
                                    <option value="修理中">修理中</option>
                                </select>
                            </div>
                        </td>
                    </tr>
                </table>

                <!-- ③ 下部：共通デザインに合わせた右下の「変更」ボタン -->
                <div style="display: flex; justify-content: flex-end; padding-top: 15px; background: transparent !important;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="showConfirmModal()" disabled style="padding: 12px 65px; font-size: 1.2rem; background-color: #fff !important;">変更</button>
                </div>

            </form>
        </div>


        <!-- 1. 確認画面モーダル -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content">
                <h2 class="modal-title">確認画面</h2>
                <form method="POST" action="F-3.bookStatusChange.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
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
                            <th>貸出状況</th>
                            <td><input type="text" class="confirm-input" id="confirm-loan-status" name="confirmLoanStatus" readonly></td>
                        </tr>
                        <tr>
                            <th>予約状況</th>
                            <td><input type="text" class="confirm-input" id="confirm-reserve-status" name="confirmReserveStatus" readonly></td>
                        </tr>
                        <tr>
                            <th>本の状態</th>
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

        <!-- 2. 完了画面モーダル -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content">
                <div class="complete-message">更新が完了しました</div>
                <div class="modal-actions">
                    <button type="button" class="btn" onclick="goToMenu()">メニュー</button>
                    <button type="button" class="btn" onclick="hideCompleteModal()">続けて更新</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面制御用のJavaScript -->
    <script>
        const bookDatabaseMock = {
            "B0001": { title: "赤朽葉家の伝説", loan: "貸出中", reserve: "あり（1人）", status: "貸出可能" },
            "B0002": { title: "人間失格", loan: "貸出可能", reserve: "なし", status: "貸出可能" },
            "B0003": { title: "ノルウェイの森 (上)", loan: "貸出中", reserve: "あり（2人）", status: "修理中" },
            "B0004": { title: "ノルウェイの森 (下)", loan: "貸出可能", reserve: "なし", status: "貸出可能" },
            "B0005": { title: "容疑者Xの献身", loan: "貸出中", reserve: "なし", status: "貸出不可" }
        };

        function clearField(fieldId) {
            document.getElementById(fieldId).value = '';
            document.getElementById('error-message').style.display = 'none';
        }

        // 【表示】ボタンを押した時の動作
        function searchBook() {
            const searchId = document.getElementById('search-id').value.trim().toUpperCase();
            const errorMessage = document.getElementById('error-message');
            
            const inputTitle = document.getElementById('input-title');
            const btnResetTitle = document.getElementById('btn-reset-title');
            const inputLoanStatus = document.getElementById('input-loan-status');
            const inputReserveStatus = document.getElementById('input-reserve-status');
            const inputStatus = document.getElementById('input-status');
            const btnSubmit = document.getElementById('btn-submit');
            const statusPlaceholder = document.getElementById('status-placeholder');
            
            if (searchId === '') {
                errorMessage.innerText = "図書IDを入力してください";
                errorMessage.style.display = 'block';
                resetFields();
                return;
            }

            const bookData = bookDatabaseMock[searchId];
            if (bookData) {
                errorMessage.style.display = 'none';
                
                // 書名とリセットボタンを活性化
                inputTitle.disabled = false;
                btnResetTitle.disabled = false;
                inputTitle.placeholder = "書名を入力してください";
                
                // 値をセット
                inputTitle.value = bookData.title;
                inputLoanStatus.value = bookData.loan;
                inputReserveStatus.value = bookData.reserve;
                
                // 本の状態と変更ボタンを活性化
                inputStatus.disabled = false;
                btnSubmit.disabled = false;
                
                if (statusPlaceholder) {
                    statusPlaceholder.disabled = true;
                    statusPlaceholder.style.display = 'none';
                }
                inputStatus.value = bookData.status;
            } else {
                errorMessage.innerText = "該当する図書が見つかりませんでした (デモ対応ID: B0001 〜 B0005)";
                errorMessage.style.display = 'block';
                resetFields();
            }
        }

        // 入力値をリセットし、初期非活性（ロック）状態にする補助関数
        function resetFields() {
            const inputTitle = document.getElementById('input-title');
            const btnResetTitle = document.getElementById('btn-reset-title');
            
            // 書名とリセットボタンを非活性化
            inputTitle.disabled = true;
            btnResetTitle.disabled = true;
            inputTitle.value = '';
            inputTitle.placeholder = "図書IDを表示してください";

            document.getElementById('input-loan-status').value = '';
            document.getElementById('input-reserve-status').value = '';
            
            const inputStatus = document.getElementById('input-status');
            inputStatus.disabled = true;
            inputStatus.value = "";
            
            const statusPlaceholder = document.getElementById('status-placeholder');
            if (statusPlaceholder) {
                statusPlaceholder.disabled = false;
                statusPlaceholder.style.display = 'block';
                inputStatus.value = "";
            }
            
            document.getElementById('btn-submit').disabled = true;
        }

        function showConfirmModal() {
            const title = document.getElementById('input-title').value.trim();
            const errorMessage = document.getElementById('error-message');

            // 書名が空欄だった場合のバリデーションチェックを追加
            if (title === '') {
                errorMessage.innerText = "書名を入力してください";
                errorMessage.style.display = 'block';
                return;
            }

            errorMessage.style.display = 'none';

            document.getElementById('confirm-id').value = document.getElementById('search-id').value.trim().toUpperCase();
            document.getElementById('confirm-title').value = title;
            document.getElementById('confirm-loan-status').value = document.getElementById('input-loan-status').value;
            document.getElementById('confirm-reserve-status').value = document.getElementById('input-reserve-status').value;
            document.getElementById('confirm-status').value = document.getElementById('input-status').value;

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }
        
        function showCompleteModal() {
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('completeModal').style.display = 'flex';
        }
        
        function goToMenu() {
            window.location.href = 'F-3.bookManagement.jsp';
        }

        function hideCompleteModal() {
            document.getElementById('completeModal').style.display = 'none';
            document.getElementById('bookStatusForm').reset();
            resetFields();
            document.getElementById('search-id').value = '';
        }
    </script>
</body>
</html>