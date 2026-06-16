<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>返却画面</title>
    <!-- 専用スタイルシート「f06-style.css」を読み込み、キャッシュバスターを強力に付与 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-06.css">    
    <!-- 【キャッシュ破壊・枠線黒化強制上書き】JSP直書きスタイル -->
    <style type="text/css">
        /* 1. メインコンテンツ領域の外枠を100%絶対に「黒枠」へ強制上書き */
        .main-content-base {
            background-color: #d9d9d9 !important; /* メインコンテンツ全体はグレー背景 */
            border: 1.5px solid #000000 !important; /* 絶対に黒枠にする指定 */
        }
        
        /* 2. 送信フォーム全体の背景透過処理 */
        form, .form-table, .form-table tr, .form-table th, .form-table td {
            background: transparent !important;
            background-color: transparent !important; /* テーブルとセル内を完全に透明化 */
            box-shadow: none !important;
        }
        
        /* 3. 返却ボタンの枠線も絶対に「黒」へ強制上書き */
        .btn-register, #btn-submit {
            border: 1.5px solid #000000 !important;
            font-weight: bold !important;
        }
    </style>
</head>
<body>

    <!-- ヘッダー -->
    <div class="header">
        <h1 class="header-title">返却画面</h1>
        <button type="button" class="menu-button" onclick="goToMenu()">メニュー</button>
    </div>

    <!-- メインコンテンツエリア (上下左右中央配置) -->
    <!-- HTMLタグ自体にインラインで最も優先度の高い直接黒枠を付与 -->
    <div class="main-content-base layout-center" id="return-main-base" style="border: 1.5px solid #000000 !important; background-color: #d9d9d9 !important;">
        
        <!-- コンテナの最大幅上限を 1300px に引き上げ、圧倒的なワイドサイズを実現 -->
        <div style="width: 95%; max-width: 1300px; padding: 10px; display: flex; flex-direction: column;">

            <div class="error-message" id="error-message" style="margin-bottom: 20px; text-align: center;">
                該当する貸出情報が見つかりませんでした
            </div>

            <!-- ① 上部：図図書ID検索バー (他と完全に等しい高さ・パディングを維持し、横の長さだけを500pxに綺麗に左寄せ) -->
            <div style="padding: 0 !important; display: flex !important; gap: 20px !important; align-items: center !important; width: 100% !important; margin-bottom: 25px !important; flex-shrink: 0 !important; background: transparent !important; background-color: transparent !important; border: none !important; box-shadow: none !important;">
                <div style="display: flex !important; gap: 20px !important; align-items: center !important; background: transparent !important; background-color: transparent !important; border: none !important;">
                    <input type="text" id="search-id" name="searchId" placeholder="図書IDを入力してください (例: B0001)" style="width: 500px !important; height: auto !important; padding: 10px 14px !important; font-size: 1.2rem !important; border: 1.5px solid #666 !important; background-color: #fff !important; box-sizing: border-box !important; outline: none !important; flex-shrink: 0 !important;">
                    <button type="button" class="btn" style="padding: 12px 30px !important; font-size: 1.25rem !important; flex-shrink: 0 !important; background-color: #fff !important; border: 1.5px solid #000000 !important;" onclick="searchLoanBook();">表示</button>
                </div>
            </div>

            <!-- 返却用フォーム -->
            <form method="POST" action="return.jsp" id="returnForm" style="display: flex; flex-direction: column; background: transparent !important; width: 100% !important;" onsubmit="return false;">
                
                <!-- ② 中央：4項目（書名、氏名、貸出日、返却日）横長フォームテーブル -->
                <table class="form-table" style="width: 100%; margin-bottom: 25px; background: transparent !important; border: 1.5px solid #000000 !important;">
                    <!-- 1行目: 書名 (常に編集不可のグレーアウト読取専用) -->
                    <tr>
                        <th style="width: 18%; border-right: 1.5px solid #000000 !important; border-bottom: 1.5px solid #000000 !important;">書名</th>
                        <td style="border-bottom: 1.5px solid #000000 !important;">
                            <div class="input-flex-container">
                                <input type="text" class="input-field-update" id="input-title" name="bookTitle" readonly placeholder="図書IDを表示してください">
                            </div>
                        </td>
                    </tr>
                    <!-- 2行目: 氏名 (常に編集不可のグレーアウト読取専用) -->
                    <tr>
                        <th style="border-right: 1.5px solid #000000 !important; border-bottom: 1.5px solid #000000 !important;">氏名</th>
                        <td style="border-bottom: 1.5px solid #000000 !important;">
                            <div class="input-flex-container">
                                <input type="text" class="input-field-update" id="input-user-name" name="userName" readonly placeholder="図書IDを表示してください">
                            </div>
                        </td>
                    </tr>
                    <!-- 3行目: 貸出日 (常に編集不可のグレーアウト読取専用) -->
                    <tr>
                        <th style="border-right: 1.5px solid #000000 !important; border-bottom: 1.5px solid #000000 !important;">貸出日</th>
                        <td style="border-bottom: 1.5px solid #000000 !important;">
                            <div class="input-flex-container">
                                <input type="text" class="input-field-update" id="input-loan-date" name="loanDate" readonly placeholder="図書IDを表示してください">
                            </div>
                        </td>
                    </tr>
                    <!-- 4行目: 返却日 (常に編集不可のグレーアウト読取専用) -->
                    <tr>
                        <th style="border-right: 1.5px solid #000000 !important; border-bottom: 1.5px solid #000000 !important;">返却日</th>
                        <td style="border-bottom: 1.5px solid #000000 !important;">
                            <div class="input-flex-container">
                                <input type="text" class="input-field-update" id="input-return-date" name="returnDate" readonly placeholder="図書IDを表示してください">
                            </div>
                        </td>
                    </tr>
                </table>

                <!-- ③ 下部：F-03規格に完全に統一した右下の「返却」ボタン (初期状態は非活性) -->
                <div style="display: flex; justify-content: flex-end; padding-top: 15px; background: transparent !important;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="showConfirmModal()" disabled style="padding: 12px 65px !important; font-size: 1.25rem !important; background-color: #fff !important; text-align: center; border: 1.5px solid #000000 !important; font-weight: bold !important; flex-shrink: 0 !important;">返却</button>
                </div>

            </form>
        </div>


        <!-- 1. 確認画面モーダル (ポップアップ) -->
        <div class="modal-overlay" id="confirmModal">
            <div class="modal-content" style="border: 1.5px solid #000000 !important;">
                <h2 class="modal-title"></h2>
                <form method="POST" action="return.jsp" id="executeForm" onsubmit="showCompleteModal(); return false;">
                    <table class="confirm-table" style="border-top: 1.5px solid #000000 !important; border-bottom: 1.5px solid #000000 !important;">
                        <tr>
                            <th style="width: 30%; border-right: 1.5px solid #000000 !important;">図書ID</th>
                            <td><input type="text" class="confirm-input" id="confirm-id" name="confirmId" readonly></td>
                        </tr>
                        <tr>
                            <th style="border-right: 1.5px solid #000000 !important;">書名</th>
                            <td><input type="text" class="confirm-input" id="confirm-title" name="confirmTitle" readonly></td>
                        </tr>
                        <tr>
                            <th style="border-right: 1.5px solid #000000 !important;">氏名</th>
                            <td><input type="text" class="confirm-input" id="confirm-user-name" name="confirmUserName" readonly></td>
                        </tr>
                        <tr>
                            <th style="border-right: 1.5px solid #000000 !important;">貸出日</th>
                            <td><input type="text" class="confirm-input" id="confirm-loan-date" name="confirmLoanDate" readonly></td>
                        </tr>
                        <tr>
                            <th style="border-right: 1.5px solid #000000 !important;">返却日</th>
                            <td><input type="text" class="confirm-input" id="confirm-return-date" name="confirmReturnDate" readonly></td>
                        </tr>
                    </table>
                    <div class="modal-actions">
                        <button type="button" class="btn" style="padding: 12px 30px !important; font-size: 1.15rem !important; text-align: center; border: 1.5px solid #000000 !important;" onclick="hideConfirmModal()">戻る</button>
                        <button type="submit" class="btn" style="padding: 12px 30px !important; font-size: 1.15rem !important; text-align: center; border: 1.5px solid #000000 !important;">確定</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 2. 完了画面モーダル (ポップアップ) -->
        <div class="modal-overlay" id="completeModal">
            <div class="modal-content" style="border: 1.5px solid #000000 !important;">
                <div class="complete-message" id="complete-message-text">更新が完了しました</div>
                <div class="modal-actions">
                    <button type="button" class="btn" style="padding: 12px 30px !important; font-size: 1.15rem !important; text-align: center; border: 1.5px solid #000000 !important;" onclick="goToMenu()">メニュー</button>
                    <button type="button" class="btn" style="padding: 12px 30px !important; font-size: 1.15rem !important; text-align: center; border: 1.5px solid #000000 !important;" onclick="hideCompleteModal()">続けて更新</button>
                </div>
            </div>
        </div>

    </div>

    <!-- 画面制御・【最優先JavaScript枠線黒化エンジン】 -->
    <script>
        // 【絶対的最終解決策】ブラウザのキャッシュやCSS定義に関わらず、読み込み完了後にJavaScriptでDOMを強制黒化
        function forceBlackBorders() {
            try {
                // 1. メインボックスの外枠を強制書き換え
                const mainBase = document.getElementById('return-main-base');
                if (mainBase) {
                    mainBase.style.setProperty('border', '1.5px solid #000000', 'important');
                }
                
                // 2. フォームテーブルの枠線を強制書き換え
                const formTables = document.querySelectorAll('.form-table');
                formTables.forEach(tbl => {
                    tbl.style.setProperty('border', '1.5px solid #000000', 'important');
                });

                // 3. テーブル内セルの境界線をすべて強制書き換え
                const thElements = document.querySelectorAll('.form-table th');
                thElements.forEach(th => {
                    th.style.setProperty('border-right', '1.5px solid #000000', 'important');
                    th.style.setProperty('border-bottom', '1.5px solid #000000', 'important');
                });
                const tdElements = document.querySelectorAll('.form-table td');
                tdElements.forEach(td => {
                    td.style.setProperty('border-bottom', '1.5px solid #000000', 'important');
                });
                
                // 4. ボタンの境界線を強制書き換え
                const submitBtn = document.getElementById('btn-submit');
                if (submitBtn) {
                    submitBtn.style.setProperty('border', '1.5px solid #000000', 'important');
                }
            } catch (e) {
                console.error("黒枠強制適用中にエラーが発生しました", e);
            }
        }

        // 複数の読込イベントフェーズで確実に発火させる
        window.addEventListener('DOMContentLoaded', forceBlackBorders);
        window.addEventListener('load', forceBlackBorders);
        // 保険として読み込み直後にも即座に実行
        setTimeout(forceBlackBorders, 50);
        setTimeout(forceBlackBorders, 500);

        // デモ用のデータベース (貸出中の図書情報)
        const loanDatabaseMock = {
            "B0001": { title: "赤朽葉家の伝説", userName: "鑓野 雄大", loanDate: "2026/06/01", returnDate: "2026/06/15" },
            "B0002": { title: "人間失格", userName: "山田 花子", loanDate: "2026/06/05", returnDate: "2026/06/19" },
            "B0003": { title: "ノルウェイの森 (上)", userName: "佐藤 太郎", loanDate: "2026/06/10", returnDate: "2026/06/24" },
            "B0004": { title: "ノルウェイの森 (下)", userName: "佐藤 太郎", loanDate: "2026/06/10", returnDate: "2026/06/24" },
            "B0005": { title: "容疑者Xの献身", userName: "鈴木 一郎", loanDate: "2026/06/12", returnDate: "2026/06/26" }
        };

        // 【表示】ボタンを押した時の動作
        function searchLoanBook() {
            const searchId = document.getElementById('search-id').value.trim().toUpperCase();
            const errorMessage = document.getElementById('error-message');
            
            const inputTitle = document.getElementById('input-title');
            const inputUserName = document.getElementById('input-user-name');
            const inputLoanDate = document.getElementById('input-loan-date');
            const inputReturnDate = document.getElementById('input-return-date');
            const btnSubmit = document.getElementById('btn-submit');
            
            if (searchId === '') {
                errorMessage.innerText = "図書IDを入力してください";
                errorMessage.style.display = 'block';
                resetFields();
                return;
            }

            const loanData = loanDatabaseMock[searchId];
            if (loanData) {
                errorMessage.style.display = 'none';
                
                // 各読取専用フィールドに値をセット
                inputTitle.value = loanData.title;
                inputUserName.value = loanData.userName;
                inputLoanDate.value = loanData.loanDate;
                inputReturnDate.value = loanData.returnDate;
                
                // 返却ボタンを活性化
                btnSubmit.disabled = false;
            } else {
                errorMessage.innerText = "該当する貸出情報が見つかりませんでした (デモ対応ID: B0001 〜 B0005)";
                errorMessage.style.display = 'block';
                resetFields();
            }
        }

        // 入力値をリセットし、初期非活性（ロック）状態にする補助関数
        function resetFields() {
            document.getElementById('input-title').value = '';
            document.getElementById('input-user-name').value = '';
            document.getElementById('input-loan-date').value = '';
            document.getElementById('input-return-date').value = '';
            
            document.getElementById('btn-submit').disabled = true;
        }

        // 確認モーダルの表示
        function showConfirmModal() {
            document.getElementById('confirm-id').value = document.getElementById('search-id').value.trim().toUpperCase();
            document.getElementById('confirm-title').value = document.getElementById('input-title').value;
            document.getElementById('confirm-user-name').value = document.getElementById('input-user-name').value;
            document.getElementById('confirm-loan-date').value = document.getElementById('input-loan-date').value;
            document.getElementById('confirm-return-date').value = document.getElementById('input-return-date').value;

            document.getElementById('confirmModal').style.display = 'flex';
        }

        function hideConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }
        
        // 完了モーダルの表示（書名を動的に埋め込み）
        function showCompleteModal() {
            const bookTitle = document.getElementById('input-title').value;
            const completeMessageElement = document.getElementById('complete-message-text');
            
            if (completeMessageElement) {
                completeMessageElement.innerText = "「" + bookTitle + "」の返却が完了しました";
            }
            
            document.getElementById('confirmModal').style.display = 'none';
            document.getElementById('completeModal').style.display = 'flex';
        }
        
        // メニュー遷移処理は、F-03の仕様と完全に一致した命名に維持
        function goToMenu() {
            window.location.href = 'F-3.bookManagement.jsp';
        }

        function hideCompleteModal() {
            document.getElementById('completeModal').style.display = 'none';
            document.getElementById('returnForm').reset();
            resetFields();
            document.getElementById('search-id').value = '';
        }
    </script>
</body>
</html>