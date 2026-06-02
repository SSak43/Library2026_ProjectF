<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>蔵書検索画面</title>
    <!-- F-3用の共通CSSファイルを読み込む -->
    <link rel="stylesheet" href="f3-style.css">
</head>
<body>

    <div class="header">
        <h1 class="header-title">蔵書検索画面</h1>
        <button type="button" class="menu-button">メニュー</button>
    </div>

    <div class="main-content-base layout-top-padding">
        
        <!-- ▼ 検索条件の送信フォーム ▼ -->
        <form method="POST" action="F-3.bookSearch.jsp" id="searchForm" onsubmit="executeSearch(); return false;" style="display: flex; flex-direction: column;">
            
            <table class="form-table">
                <tr>
                    <th>タイトル</th>
                    <td>
                        <input type="text" class="input-field" id="search-title" name="searchTitle" placeholder="タイトルを入力">
                        <button type="button" class="btn" onclick="document.getElementById('search-title').value=''">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>著者</th>
                    <td>
                        <input type="text" class="input-field" id="search-author" name="searchAuthor" placeholder="著者名を入力">
                        <button type="button" class="btn" onclick="document.getElementById('search-author').value=''">クリア</button>
                    </td>
                </tr>
                <tr>
                    <th>ISBN</th>
                    <td>
                        <input type="text" class="input-field" id="search-isbn" name="searchIsbn" placeholder="ISBNを入力">
                        <button type="button" class="btn" onclick="document.getElementById('search-isbn').value=''">クリア</button>
                    </td>
                </tr>
            </table>

            <!-- 検索を実行するボタン (submit) -->
            <button type="submit" class="btn btn-search">検索</button>
        </form>

        <!-- ▼ 検索結果一覧エリア (初期状態では非表示) ▼ -->
        <div class="search-results-area" id="searchResultsArea">
            <table class="results-table">
                <thead>
                    <tr>
                        <th class="col-id">図書ID</th>
                        <th class="col-isbn">ISBN</th>
                        <th class="col-title">タイトル</th>
                        <th class="col-author">著者</th>
                        <th class="col-pub">出版社</th>
                        <th class="col-btn"></th>
                    </tr>
                </thead>
                <tbody id="resultsBody">
                    <!-- ここに検索結果がJavaScriptで動的に追加されます -->
                </tbody>
            </table>

            <!-- ページネーション -->
            <div class="pagination">
                <button type="button" class="pagination-btn" onclick="changePage(-1)">&#9664;</button> <!-- 左矢印 -->
                <span class="pagination-info">1 / 2</span>
                <button type="button" class="pagination-btn" onclick="changePage(1)">&#9654;</button> <!-- 右矢印 -->
            </div>
        </div>

    </div>

    <!-- 画面操作用のJavaScript -->
    <script>
        // 【モック用】「検索」ボタンを押したときの挙動
        function executeSearch() {
            // 検索結果エリアを表示する
            document.getElementById('searchResultsArea').style.display = 'flex';
            
            // 1ページ目のダミーデータを表示
            loadPage1();
        }

        // ダミーデータ：1ページ目
        function loadPage1() {
            const tbody = document.getElementById('resultsBody');
            tbody.innerHTML = `
                <tr>
                    <td>10001</td>
                    <td>978-4-06-213962-4</td>
                    <td>赤朽葉家の伝説</td>
                    <td>桜庭一樹</td>
                    <td>講談社</td>
                    <td style="text-align: center;"><button type="button" class="btn-detail">詳細</button></td>
                </tr>
                <tr>
                    <td>10002</td>
                    <td>978-4-04-106526-5</td>
                    <td>砂糖菓子の弾丸は撃ちぬけない</td>
                    <td>桜庭一樹</td>
                    <td>角川文庫</td>
                    <td style="text-align: center;"><button type="button" class="btn-detail">詳細</button></td>
                </tr>
                <tr>
                    <td>10003</td>
                    <td>978-4-488-45001-4</td>
                    <td>私の男</td>
                    <td>桜庭一樹</td>
                    <td>文春文庫</td>
                    <td style="text-align: center;"><button type="button" class="btn-detail">詳細</button></td>
                </tr>
                <tr>
                    <td>10004</td>
                    <td>978-4-06-276606-6</td>
                    <td>GOSICK -ゴシック-</td>
                    <td>桜庭一樹</td>
                    <td>角川文庫</td>
                    <td style="text-align: center;"><button type="button" class="btn-detail">詳細</button></td>
                </tr>
            `;
            document.querySelector('.pagination-info').textContent = "1 / 2";
        }

        // ダミーデータ：2ページ目
        function loadPage2() {
            const tbody = document.getElementById('resultsBody');
            tbody.innerHTML = `
                <tr>
                    <td>10005</td>
                    <td>978-4-10-128453-6</td>
                    <td>少女七竈と七人の可愛そうな大人</td>
                    <td>桜庭一樹</td>
                    <td>新潮文庫</td>
                    <td style="text-align: center;"><button type="button" class="btn-detail">詳細</button></td>
                </tr>
                <tr>
                    <td>10006</td>
                    <td>978-4-16-778403-4</td>
                    <td>ファミリーポートレイト</td>
                    <td>桜庭一樹</td>
                    <td>文春文庫</td>
                    <td style="text-align: center;"><button type="button" class="btn-detail">詳細</button></td>
                </tr>
            `;
            document.querySelector('.pagination-info').textContent = "2 / 2";
        }

        // ページ切り替えのモック処理
        let currentPage = 1;
        function changePage(direction) {
            currentPage += direction;
            if (currentPage < 1) currentPage = 1;
            if (currentPage > 2) currentPage = 2; // 今回は2ページまでの想定

            if (currentPage === 1) {
                loadPage1();
            } else if (currentPage === 2) {
                loadPage2();
            }
        }
    </script>
</body>
</html>