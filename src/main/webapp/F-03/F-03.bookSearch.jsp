<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>検索入力画面</title>
    <!-- 絶対パス表記に刷新し、キャッシュバスターパラメータ付きに更新 -->
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/F-03.css">
</head>
<body>

    <!-- 共通ヘッダー -->
    <div class="header">
        <h1 class="header-title">検索入力画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <!-- メインコンテンツベース -->
    <div class="main-content-base layout-top-padding">
        
        <!-- 上部：横長1行スリムカプセル型フォーム -->
        <div class="search-box-container">
            <form method="POST" action="F-3.searchInput.jsp" id="searchForm" onsubmit="performSearch(); return false;">
                <div class="search-form-row">
                    <!-- 1. 検索項目のプルダウン -->
                    <select class="search-select" id="searchCategory" name="searchCategory">
                        <option value="all">すべての項目</option>
                        <option value="title">書名</option>
                        <option value="author">著者名</option>
                        <option value="publisher">出版社</option>
                    </select>
                    
                    <!-- 2. 検索キーワード入力欄 -->
                    <input type="text" class="search-input" id="searchKeyword" name="searchKeyword" placeholder="検索キーワードを入力してください">
                    
                    <!-- 3. アクションボタンのグループ -->
                    <div class="search-btn-group">
                        <button type="button" class="search-btn" onclick="clearSearch();">リセット</button>
                        <button type="submit" class="search-btn search-btn-primary">検索</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- 下部：検索枠（検索前から枠付きで綺麗に大きく表示されます） -->
        <div class="search-results-area">
            
            <!-- ① 〇〇件の図書が見つかりました、を表示するお知らせヘッダー -->
            <div class="results-header-info" id="resultsHeaderInfo">
                検索結果: 0件の図書が見つかりました
            </div>
            
            <!-- ② データ部分だけが綺麗にスクロールするスクロール可能エリア -->
            <div class="table-scroll-container">
                <table class="results-table" id="resultsTable">
                    <thead>
                        <tr>
                            <th class="col-no">No.</th>
                            <th class="col-id">図書ID</th>
                            <th class="col-title">書名</th>
                            <th class="col-author">著者</th>
                            <th class="col-pub">出版社</th>
                            <th class="col-class">分類</th>
                            <th class="col-status">蔵書状態</th>
                            <th class="col-action">操作</th>
                        </tr>
                    </thead>
                    <tbody id="resultsBody">
                        <!-- 初期状態のプレースホルダー -->
                        <tr id="empty-message-row">
                            <td colspan="8" class="no-data-row" style="text-align: center; vertical-align: middle; height: 260px;">
                                検索条件を入力して「検索」を押してください。
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- ③ 【三角のみ・右下密着配置】下部に常に固定されるページネーションナビゲーション -->
            <div class="pagination-container">
                <!-- ◀ ボタン（枠なし・右寄せ・間隔なし） -->
                <button type="button" class="pagination-btn" id="prevPageBtn" onclick="changePage(-1);" disabled>&#9664;</button>
                <!-- ▶ ボタン（枠なし・右寄せ・間隔なし） -->
                <button type="button" class="pagination-btn" id="nextPageBtn" onclick="changePage(1);" disabled>&#9654;</button>
            </div>

        </div>

    </div>

    <!-- 動的なページネーションシミュレーションスクリプト -->
    <script>
        // 大量のデモ用データベース (ページネーション動作検証のために15件のデータを格納)
        const mockDatabase = [
            { id: "B0001", title: "赤朽葉家の伝説", author: "桜庭一樹", publisher: "講談社", classification: "小説", status: "貸出可能" },
            { id: "B0002", title: "人間失格", author: "太宰治", publisher: "新潮社", classification: "文学", status: "貸出可能" },
            { id: "B0003", title: "ノルウェイの森 (上)", author: "村上春樹", publisher: "講談社", classification: "小説", status: "修理中" },
            { id: "B0004", title: "ノルウェイの森 (下)", author: "村上春樹", publisher: "講談社", classification: "小説", status: "貸出可能" },
            { id: "B0005", title: "容疑者Xの献身", author: "東野圭吾", publisher: "小学館", classification: "ミステリー", status: "貸出不可" },
            { id: "B0006", title: "こころ", author: "夏目漱石", publisher: "岩波書店", classification: "文学", status: "貸出可能" },
            { id: "B0007", title: "銀河鉄道の夜", author: "宮沢賢治", publisher: "角川書店", classification: "児童書", status: "貸出可能" },
            { id: "B0008", title: "羅生門", author: "芥川龍之介", publisher: "青空文庫", classification: "文学", status: "修理中" },
            { id: "B0009", title: "走れメロス", author: "太宰治", publisher: "角川書店", classification: "文学", status: "貸出可能" },
            { id: "B0010", title: "坊っちゃん", author: "夏目漱石", publisher: "新潮社", classification: "文学", status: "貸出可能" },
            { id: "B0011", title: "雪国", author: "川端康成", publisher: "新潮社", classification: "文学", status: "貸出不可" },
            { id: "B0012", title: "吾輩は猫である", author: "夏目漱石", publisher: "講談社", classification: "文学", status: "貸出可能" },
            { id: "B0013", title: "斜陽", author: "太宰治", publisher: "新潮社", classification: "文学", status: "修理中" },
            { id: "B0014", title: "蜘蛛の糸", author: "芥川龍之介", publisher: "角川書店", classification: "文学", status: "貸出可能" },
            { id: "B0015", title: "細雪", author: "谷崎潤一郎", publisher: "新潮社", classification: "文学", status: "貸出可能" }
        ];

        // ページネーション用ステート
        let currentResults = [];
        let currentPage = 1;
        const itemsPerPage = 10; // 1ページあたり最大10件表示

        // 検索を実行するメイン関数
        function performSearch() {
            const category = document.getElementById("searchCategory").value;
            const keyword = document.getElementById("searchKeyword").value.trim().toLowerCase();
            
            // 検索・絞り込み処理
            if (keyword === "") {
                currentResults = mockDatabase;
            } else {
                currentResults = mockDatabase.filter(book => {
                    if (category === "all") {
                        return book.title.toLowerCase().includes(keyword) || 
                               book.author.toLowerCase().includes(keyword) || 
                               book.publisher.toLowerCase().includes(keyword) ||
                               book.classification.toLowerCase().includes(keyword) ||
                               book.status.toLowerCase().includes(keyword) ||
                               book.id.toLowerCase().includes(keyword);
                    } else if (category === "title") {
                        return book.title.toLowerCase().includes(keyword);
                    } else if (category === "author") {
                        return book.author.toLowerCase().includes(keyword);
                    } else if (category === "publisher") {
                        return book.publisher.toLowerCase().includes(keyword);
                    }
                    return false;
                });
            }

            // 総件数表示のアップデート
            document.getElementById("resultsHeaderInfo").innerText = `検索結果: ${currentResults.length}件の図書が見つかりました`;

            // 1ページ目にリセットして再描画
            currentPage = 1;
            renderTable();
        }

        // テーブルとページネーションボタンをレンダリングする関数
        function renderTable() {
            const resultsBody = document.getElementById("resultsBody");
            resultsBody.innerHTML = "";

            if (currentResults.length === 0) {
                resultsBody.innerHTML = `
                    <tr>
                        <td colspan="8" class="no-data-row" style="text-align: center; vertical-align: middle; height: 260px;">
                            該当する図書が見つかりませんでした。
                        </td>
                    </tr>
                `;
                updatePaginationControls(0);
                return;
            }

            // 現在のページの切り出し範囲を算出
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const pageItems = currentResults.slice(startIndex, endIndex);

            // 切り出したデータを行として挿入
            pageItems.forEach((book, index) => {
                const row = document.createElement("tr");
                const globalNo = startIndex + index + 1; // ページをまたいでも正しい通し番号を出力
                row.innerHTML = `
                    <td class="cell-no">${globalNo}</td>
                    <td>${book.id}</td>
                    <td>${book.title}</td>
                    <td>${book.author}</td>
                    <td>${book.publisher}</td>
                    <td>${book.classification}</td>
                    <td>${book.status}</td>
                    <td class="cell-action">
                        <button type="button" class="btn-detail-view" onclick="viewDetail('${book.id}')">詳細</button>
                    </td>
                `;
                resultsBody.appendChild(row);
            });

            updatePaginationControls(currentResults.length);
        }

        // ページネーションのボタンと表記を更新する関数
        function updatePaginationControls(totalItems) {
            const totalPages = Math.max(1, Math.ceil(totalItems / itemsPerPage));
            
            const prevBtn = document.getElementById("prevPageBtn");
            const nextBtn = document.getElementById("nextPageBtn");

            // 前のページボタンの制御
            prevBtn.disabled = (currentPage === 1);

            // 次のページボタンの制御
            nextBtn.disabled = (currentPage === totalPages);
        }

        // ページを切り替える関数
        function changePage(direction) {
            const totalPages = Math.ceil(currentResults.length / itemsPerPage);
            const targetPage = currentPage + direction;

            if (targetPage >= 1 && targetPage <= totalPages) {
                currentPage = targetPage;
                renderTable();
                
                // 切り替え時にスクロール位置を最上部に戻す
                document.querySelector(".table-scroll-container").scrollTop = 0;
            }
        }

        // フォームのリセットと初期化
        function clearSearch() {
            document.getElementById("searchForm").reset();
            currentResults = [];
            currentPage = 1;
            
            document.getElementById("resultsHeaderInfo").innerText = "検索結果: 0件の図書が見つかりました";
            
            const resultsBody = document.getElementById("resultsBody");
            resultsBody.innerHTML = `
                <tr id="empty-message-row">
                    <td colspan="8" class="no-data-row" style="text-align: center; vertical-align: middle; height: 260px;">
                        検索条件を入力して「検索」を押してください。
                    </td>
                </tr>
            `;

            updatePaginationControls(0);
        }

        // 「詳細」ボタン動作
        function viewDetail(bookId) {
            console.log("図書ID: " + bookId + " の詳細表示処理");
        }
    </script>
</body>
</html>