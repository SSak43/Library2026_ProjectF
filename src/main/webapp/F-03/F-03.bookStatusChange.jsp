<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>状態変更画面</title>
    <!-- 共通のスタイルシートを読み込み -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-03.css">
</head>
<body>

    <!-- ヘッダー -->
    <div class="header">
        <h1 class="header-title">状態変更画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツエリア (上下左右中央配置のために layout-center クラスを適用) -->
    <div class="main-content-base layout-center">
        
        <!-- 中央寄せ用のコンテナ (横の比率 95%, 最大1000px をしっかり維持) -->
        <div style="width: 95%; max-width: 1000px; padding: 10px; display: flex; flex-direction: column;">

            <div class="error-message" id="error-message" style="margin-bottom: 20px; text-align: center;">
                この図書IDは存在しません
            </div>

            <!-- 送信フォーム -->
            <form method="POST" action="F-3.bookStatusChange.jsp" id="bookStatusForm" style="display: flex; flex-direction: column;" onsubmit="return false;">
                
                <table class="form-table" style="width: 100%; margin-bottom: 25px;">
                    <!-- 1行目: 図書IDと表示ボタン -->
                    <tr>
                        <th style="width: 15%;">図書ID</th>
                        <td>
                            <div style="display: flex; gap: 15px; width: 100%; align-items: center;">
                                <input type="text" class="input-field" id="search-id" name="searchId" style="width: 250px; flex-shrink: 0;" placeholder="図書ID入力">
                                <button type="button" class="btn" style="padding: 6px 30px; font-size: 1.1rem; flex-shrink: 0;" onclick="searchBook();">表示</button>
                            </div>
                        </td>
                    </tr>
                    <!-- 2行目: 書名 -->
                    <tr>
                        <th>書名</th>
                        <td><input type="text" class="input-field-update" id="input-title" name="bookTitle" readonly placeholder="図書IDを表示してください"></td>
                    </tr>
                    <!-- 3行目: 貸出状況 -->
                    <tr>
                        <th>貸出状況</th>
                        <td><input type="text" class="input-field-update" id="input-loan-status" name="bookLoanStatus" readonly placeholder="図書IDを表示してください"></td>
                    </tr>
                    <!-- 4行目: 予約状況 -->
                    <tr>
                        <th>予約状況</th>
                        <td><input type="text" class="input-field-update" id="input-reserve-status" name="bookReserveStatus" readonly placeholder="図書IDを表示してください"></td>
                    </tr>
                    <!-- 5行目: 本の状態 (プルダウンのみ) -->
                    <tr>
                        <th>本の状態</th>
                        <td>
                            <select class="select-field" id="input-status" name="bookStatus" disabled style="width: 100%; max-width: 350px;">
                                <option value="" id="status-placeholder" selected>図書IDを表示してください</option>
                                <option value="貸出可能">貸出可能</option>
                                <option value="貸出不可">貸出不可</option>
                                <option value="修理中">修理中</option>
                            </select>
                        </td>
                    </tr>
                </table>

                <!-- 共通デザインに合わせた、コンテナ右下の「変更」ボタン -->
                <div style="display: flex; justify-content: flex-end;">
                    <button type="button" class="btn btn-register" id="btn-submit" onclick="showConfirmModal()" disabled style="padding: 10px 50px;">変更</button>
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
        // デモ用のデータベース
        const bookDatabaseMock = {
            "B0001": { title: "赤朽葉家の伝説", loan: "貸出中", reserve: "あり（1人）", status: "貸出可能" },
            "B0002": { title: "人間失格", loan: "貸出可能", reserve: "なし", status: "貸出可能" },
            "B0003": { title: "ノルウェイの森 (上)", loan: "貸出中", reserve: "あり（2人）", status: "修理中" },
            "B0004": { title: "ノルウェイの森 (下)", loan: "貸出可能", reserve: "なし", status: "貸出可能" },
            "B0005": { title: "容疑者Xの献身", loan: "貸出中", reserve: "なし", status: "貸出不可" }
        };

        // 【表示】ボタンを押した時の動作
        function searchBook() {
            const searchId = document.getElementById('search-id').value.trim().toUpperCase();
            const errorMessage = document.getElementById('error-message');
            
            const inputTitle = document.getElementById('input-title');
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

            // 該当データがあるかチェック
            const bookData = bookDatabaseMock[searchId];
            if (bookData) {
                errorMessage.style.display = 'none';
                
                inputTitle.value = bookData.title;
                inputLoanStatus.value = bookData.loan;
                inputReserveStatus.value = bookData.reserve;
                
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

        // 入力値をリセットする補助関数
        function resetFields() {
            document.getElementById('input-title').value = '';
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

        // 確認モーダルの表示
        function showConfirmModal() {
            document.getElementById('confirm-id').value = document.getElementById('search-id').value.trim().toUpperCase();
            document.getElementById('confirm-title').value = document.getElementById('input-title').value;
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
        
        // メニュー画面に戻る（遷移シミュレート）
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