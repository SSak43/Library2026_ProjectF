<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>検索入力画面</title>
    <link rel="stylesheet" href="F-03.css">
</head>
<body>

    <!-- 共通ヘッダー -->
    <div class="header">
        <h1 class="header-title">検索入力画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツベース -->
    <div class="main-content-base layout-top-padding">
        
        <!-- 上部：カプセル型検索入力フォーム -->
        <div class="search-box-container">
            <form method="POST" action="F-3.searchInput.jsp" id="searchForm" onsubmit="performSearch(); return false;" style="display: flex; flex-direction: column; gap: 20px;">
                
                <!-- 1段目：検索項目のプルダウン -->
                <div>
                    <select class="search-select" id="searchCategory" name="searchCategory">
                        <option value="all">すべての項目</option>
                        <option value="title">書名</option>
                        <option value="author">著者名</option>
                        <option value="publisher">出版社</option>
                        <option value="isbn">ISBN</option>
                    </select>
                </div>
                
                <!-- 2段目：検索キーワード入力欄 -->
                <div>
                    <input type="text" class="search-input" id="searchKeyword" name="searchKeyword" placeholder="検索キーワードを入力してください">
                </div>
                
                <!-- 3段目：アクションボタン -->
                <div class="search-box-actions">
                    <button type="button" class="search-btn" onclick="clearSearch();">リセット</button>
                    <button type="submit" class="search-btn search-btn-primary">検索</button>
                </div>
                
            </form>
        </div>

        <!-- 下部：検索結果一覧表示テーブル（最初から空で表示） -->
        <div class="search-results-area">
            <table class="results-table" id="resultsTable">
                <thead>
                    <tr>
                        <th class="col-id">図書ID</th>
                        <th class="col-isbn">ISBN</th>
                        <th class="col-title">書名</th>
                        <th class="col-author">著者</th>
                        <th class="col-pub">出版社</th>
                    </tr>
                </thead>
                <tbody id="resultsBody">
                    <!-- 初期状態はデータがないためメッセージを1行表示 -->
                    <tr id="empty-message-row">
                        <td colspan="5" class="no-data-row" style="text-align: center;">検索条件を入力して「検索」を押してください。</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>

    <!-- フロントエンドでの簡易検索動作シミュレーション用のJavaScript -->
    <script>
        // ダミーデータ（本来はサーバーサイドJSP処理等でDBから取得する部分）
        const mockDatabase = [
            { id: "B0001", isbn: "978-4-06-213962-4", title: "赤朽葉家の伝説", author: "桜庭一樹", publisher: "講談社" },
            { id: "B0002", isbn: "978-4-10-120313-3", title: "人間失格", author: "太宰治", publisher: "新潮社" },
            { id: "B0003", isbn: "978-4-06-275685-2", title: "ノルウェイの森 (上)", author: "村上春樹", publisher: "講談社" },
            { id: "B0004", isbn: "978-4-06-275686-9", title: "ノルウェイの森 (下)", author: "村上春樹", publisher: "講談社" },
            { id: "B0005", isbn: "978-4-09-408594-5", title: "容疑者Xの献身", author: "東野圭吾", publisher: "小学館" }
        ];

        // 検索を実行する関数
        function performSearch() {
            const category = document.getElementById("searchCategory").value;
            const keyword = document.getElementById("searchKeyword").value.trim().toLowerCase();
            const resultsBody = document.getElementById("resultsBody");
            
            // 検索キーワードがない場合は全件、またはフィルタリング
            let filteredResults = [];
            
            if (keyword === "") {
                // キーワード空欄時は動作確認用に全件表示
                filteredResults = mockDatabase;
            } else {
                filteredResults = mockDatabase.filter(book => {
                    if (category === "all") {
                        return book.title.toLowerCase().includes(keyword) || 
                               book.author.toLowerCase().includes(keyword) || 
                               book.publisher.toLowerCase().includes(keyword) ||
                               book.isbn.includes(keyword) ||
                               book.id.toLowerCase().includes(keyword);
                    } else if (category === "title") {
                        return book.title.toLowerCase().includes(keyword);
                    } else if (category === "author") {
                        return book.author.toLowerCase().includes(keyword);
                    } else if (category === "publisher") {
                        return book.publisher.toLowerCase().includes(keyword);
                    } else if (category === "isbn") {
                        return book.isbn.includes(keyword);
                    }
                    return false;
                });
            }

            // テーブル中身を再描画
            resultsBody.innerHTML = "";

            if (filteredResults.length === 0) {
                resultsBody.innerHTML = `
                    <tr>
                        <td colspan="5" class="no-data-row" style="text-align: center;">該当する図書が見つかりませんでした。</td>
                    </tr>
                `;
            } else {
                filteredResults.forEach(book => {
                    const row = document.createElement("tr");
                    row.innerHTML = `
                        <td>${book.id}</td>
                        <td>${book.isbn}</td>
                        <td>${book.title}</td>
                        <td>${book.author}</td>
                        <td>${book.publisher}</td>
                    `;
                    resultsBody.appendChild(row);
                });
            }
        }

        // 検索フォームをリセットし、テーブルを初期状態に戻す関数
        function clearSearch() {
            document.getElementById("searchForm").reset();
            const resultsBody = document.getElementById("resultsBody");
            resultsBody.innerHTML = `
                <tr id="empty-message-row">
                    <td colspan="5" class="no-data-row" style="text-align: center;">検索条件を入力して「検索」を押してください。</td>
                </tr>
            `;
        }
    </script>
</body>
</html>