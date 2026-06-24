<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.UsersBean" %>

<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %> 

<td>${book.bookId}</td>

<td><fmt:formatNumber value="${book.bookId}" pattern="000000" /></td>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>図書検索画面</title>
<style>
/* ページの背景色（ご指定の薄い青色） */
  body {
    background-color: #b4c7e7; /* ページの背景色を薄い青色に設定 */
    padding: 0px; /* 見やすくするための画面端の余白 */
    font-family: sans-serif; /* 全体のフォントをゴシック体（サンセリフ）に設定 */
  }
  
  /* --- 画面上部のヘッダー --- */
  .page-header {
    background-color: #dcdcdc; /* 背景色をグレーに設定 */
    width: 100%; /* 横幅を画面いっぱいに */
    border: 1px solid #8ca1c2; /* 青っぽい枠線 */
    padding: 20px 20px; /* 内側の余白 */
    box-sizing: border-box;
    display: flex; /* 中身を横並びにする設定 */
    align-items: center; /* 縦方向の中央に揃える */
    justify-content: center; /* 横方向の中央に揃える（タイトル用） */
    position: relative; /* メニューボタンを右端に固定するための基準 */
    margin-bottom: 10px; /* 下の検索枠との間隔 */
  }

  /* 「検索画面」のテキスト */
  .page-title {
    font-size: 20px;
    color: #333;
  }

  /* 「メニュー」ボタン */
  .menu-btn {
    position: absolute; /* ヘッダーの中で自由な位置に配置 */
    right: 20px; /* 右から20pxの位置に固定 */
    background-color: #fff; /* 背景を白に */
    border: 1px solid #8ca1c2; /* 青っぽい枠線 */
    padding: 18px 40px; /* ボタンの内側の余白 */
    font-size: 15px;
    cursor: pointer;
  }

  .menu-btn:hover {
    background-color: #f0f0f0; /* マウスオーバーで少し暗くする */
  }

  /* --- 検索エリアのデザイン --- */
  .search-container {
    background-color: #dcdcdc; /* 検索エリア全体の背景色をグレーに設定 */
    width: 100%; /* 検索エリアの横幅を固定 */
    border: 1px solid #8ca1c2; /* 外枠の青っぽい線を設定 */
    border-radius: 8px; /* 角を丸くする設定 */
    padding: 10px 0px; /* 内側の上下に10px、左右に15pxの余白を設定 */
    box-sizing: border-box; /* パディングとボーダーを幅（width）に含める設定 */
    margin-bottom: 20px; /* 下の表との間隔を空けるための余白 */
  }

  .search-table {
    width: 100%; /* 検索用テーブルの横幅をコンテナいっぱいに広げる */
    border-collapse: collapse; /* セル同士の隙間をなくし、境界線を1本にまとめる */
  }

  /* 検索セルの基本設定 */
  .search-table th,
  .search-table td {
    padding: 5px 10px; /* セル内の上下に5px、左右に10pxの余白を設定 */
    text-align: center; /* 文字を中央揃えにする */
    color: #333; /* 文字色を濃いグレー（ほぼ黒）に設定 */
    font-size: 15px; /* 文字の大きさを15pxに設定 */
  }

  .search-table th {
    font-weight: normal; /* 見出しセル（th）の文字の太さを標準（太字にしない）に設定 */
  }

  /* 十字の区切り線（縦） */
  .search-col-item,
  .search-col-value {
    border-right: 1px solid #000;
    border-under: 1px solid #000; /* 右側に1pxの黒い実線を引く */
  }

  /* 十字の区切り線（横） */
  .border-bottom {
    border-bottom: 1px solid #000; /* 下側に1pxの黒い実線を引く */
  }

  /* 各列の幅 */
  .search-col-item { width: 20%; } /* 検索項目の列の幅を全体の25%に設定 */
  .search-col-value { width: 60%; } /* 検索値の列の幅を全体の55%に設定 */
  .search-col-buttons { 
    width: 20%; 
    vertical-align: bottom; /* ★上下中央揃えから「下揃え」に変更 */
    padding-bottom: 8px; /* ★下枠にくっつきすぎないよう、ちょっとだけ隙間を空けて調整 */
  } 

  /* フォーム部品の設定 */
  .search-select {
    font-size: 14px; /* セレクトボックスの文字の大きさを14pxに設定 */
    padding: 4px; /* セレクトボックスの内側の余白を4pxに設定 */
    background-color: transparent; /* セレクトボックスの背景色を透明に設定 */
    border: none; /* セレクトボックスの枠線を非表示設定 */
    cursor: pointer; /* マウスオーバー時にカーソルを指のマークにする */
    width: 38%; /* セレクトボックスの横幅を親要素の90%に設定 */
    box-sizing: border-box; /* パディングとボーダーを幅（width）に含める設定 */
    
    /* ブラウザ標準のプルダウン矢印を非表示にする */
    -webkit-appearance: none; /* Safari/Chrome向けの標準スタイル無効化 */
    -moz-appearance: none; /* Firefox向けの標準スタイル無効化 */
    appearance: none; /* 標準スタイル無効化（プルダウン矢印を消す） */
  }

  .search-input {
    width: 95%; /* 入力欄の横幅を親要素の95%に設定 */
    font-size: 15px; /* 入力欄の文字の大きさを15pxに設定 */
    padding: 3px; /* 入力欄の内側の余白を3pxに設定 */
    border: 1px solid #8ca1c2; /* 入力欄の枠線を青っぽく設定 */
    box-sizing: border-box; /* パディングとボーダーを幅（width）に含める設定 */
  }

  /* Edgeなどのブラウザで入力欄の右端に出る矢印(履歴アイコン等)を消す */
  .search-input::-webkit-calendar-picker-indicator,
  .search-input::-webkit-list-button,
  .search-input::-ms-clear,
  .search-input::-ms-reveal {
    display: none; /* 対象の要素（ブラウザ標準のアイコン等）を非表示にする */
  }

  .action-btn {
    font-size: 14px; /* ボタンの文字の大きさを14pxに設定 */
    padding: 4px 15px; /* ボタンの内側の上下に4px、左右に15pxの余白を設定 */
    margin: 0 4px; /* ボタンの外側の左右に4pxの間隔を空ける */
    background-color: #fff; /* ボタンの背景色を白に設定 */
    border: 1px solid #8ca1c2; /* ボタンの枠線を青っぽく設定 */
    cursor: pointer; /* マウスオーバー時にカーソルを指のマークにする */
  }
  
  .action-btn:hover {
    background-color: #f0f0f0; /* ボタンにマウスを乗せたときの背景色を薄いグレーにする */
  }

	/* --- 左端に少し隙間を空けた下線 --- */
  .border-bottom-gap {
    position: relative; /* 線を配置する基準にする */
    border-bottom: none !important; /* 元の標準の下線を消す */
  }
  
  .border-bottom-gap::after {
    content: "";
    position: absolute;
    bottom: -0.5px; /* 右側のセルの線と高さを合わせる */
    left: 5%; /* ★ここで左端の隙間の幅を調整します（お好みで変更OK） */
    right: 0;
    border-bottom: 1px solid #000; /* 黒い実線を引く */
  }
  
  .search-select option:nth-child(odd) {
    background-color: #ffffff;
  }
  
  .search-select option:nth-child(even) {
    background-color: #f2f2f2;
  }

  /* --- ここから下の表エリアのデザイン --- */
  .table-container {
    background-color: #dcdcdc; /* 表エリア全体の背景色をグレーに設定 */
    padding: 20px; /* 表エリアの内側の余白を上下左右20pxに設定 */
    width: 100%; /* 表エリアの横幅を固定 */
    border: 1px solid #8ca1c2; /* 外枠の青っぽい線を設定 */
    box-sizing: border-box; /* パディングとボーダーを幅（width）に含める設定 */
  }

  /* 上部のメッセージテキスト */
  .result-message {
    font-size: 16px; /* メッセージの文字の大きさを16pxに設定 */
    margin: 0 0 10px 0; /* メッセージの下側に10pxの余白を空ける */
    color: #333; /* 文字色を濃いグレー（ほぼ黒）に設定 */
  }
  
  .custom-table {
    width: 100%; /* 表の横幅をコンテナいっぱいに広げる */
    border-collapse: collapse; /* セル同士の隙間をなくし、境界線を1本にまとめる */
    table-layout: fixed; /* 列幅を固定して、内容によって幅が変わらないようにする */
  }

  /* セルの共通設定 */
  .custom-table th,
  .custom-table td {
    border: 1px solid #000; /* セルを1pxの黒い実線で囲む */
    padding: 4px 8px; /* セル内の上下に4px、左右に8pxの余白を設定 */
    font-size: 14px; /* セル内の文字の大きさを14pxに設定 */
    height: 24px; /* セルの高さを24pxに固定（空行でも高さを維持するため） */
    overflow: hidden; /* セルから内容がはみ出した部分を隠す */
    white-space: nowrap; /* セル内の文字を改行させない */
    text-overflow: ellipsis; /* はみ出した文字の末尾を「...」にして省略表示する */
  }

  .custom-table th {
    background-color: #9e9e9e; /* 見出しセル（th）の背景色を濃いグレーに設定 */
    color: #000; /* 見出しセル（th）の文字色を黒に設定 */
    font-weight: bold; /* 見出しセル（th）の文字を太字にする */
    text-align: center; /* 見出しセル（th）の文字を中央揃えにする */
  }

  .custom-table td {
    background-color: #eeeeee; /* データセル（td）の背景色を薄いグレーに設定 */
    color: #000; /* データセル（td）の文字色を黒に設定 */
    text-align: left; /* データセル（td）の文字を左揃えにする */
  }

	.custom-table tbody tr:nth-child(odd) td {
    background-color: #ffffff;
  }
  
  .custom-table tbody tr:nth-child(even) td {
    background-color: #f2f2f2;
  }

  /* 各列の幅の比率 */
  .col-no { width: 3%; } /* 「No.」列の幅を全体の6%に設定 */
  .col-id { width: 10%; } /* 「図書ID」列の幅を全体の10%に設定 */
  .col-title { width: 51%; } /* 「書名」列の幅を全体の34%に設定 */
  .col-author { width: 10%; } /* 「著者」列の幅を全体の12%に設定 */
  .col-publisher { width: 8%; } /* 「出版社」列の幅を全体の8%に設定 */
  .col-category { width: 8%; } /* 「分類」列の幅を全体の8%に設定 */
  .col-status { width: 8%; } /* 「蔵書状態」列の幅を全体の12%に設定 */
  .col-action { width: 6%; } /* 「操作」列の幅を全体の10%に設定 */

  /* --- 右下のボタンエリア --- */
  .pagination-area {
    display: flex; /* 子要素（ボタン群）をフレックスボックスでレイアウトする */
    justify-content: flex-end; /* ボタン群を右側に寄せる */
  }

  .pagination-buttons {
    display: flex; /* 子要素（各ボタン）をフレックスボックスで横並びにする */
    border: 1px solid #000; /* ボタン群全体を1pxの黒い実線で囲む */
    border-top: none; /* ボタン群の上側の枠線を消す（上の表と一体化させるため） */
    background-color: #eeeeee; /* ボタン群の背景色を薄いグレーに設定 */
  }

  .pagination-buttons button {
    background: transparent; /* 個別のボタンの背景を透明にする（親要素の色を見せる） */
    border: none; /* 個別のボタンの標準の枠線を消す */
    width: 35px; /* 個別のボタンの横幅を35pxに設定 */
    height: 25px; /* 個別のボタンの高さを25pxに設定 */
    cursor: pointer; /* マウスオーバー時にカーソルを指のマークにする */
    font-size: 12px; /* ボタン内の文字（アイコン）の大きさを12pxに設定 */
    display: flex; /* ボタン内の文字をフレックスボックスでレイアウトする */
    align-items: center; /* ボタン内の文字を縦方向の中央に配置する */
    justify-content: center; /* ボタン内の文字を横方向の中央に配置する */
    padding: 0; /* ボタンの内側の余白をなくす */
    color: #000; /* ボタン内の文字色を黒に設定 */
  }

  .pagination-buttons button:first-child {
    border-right: 1px solid #000; /* 最初のボタン（◀）の右側だけに1pxの黒い実線を引いて区切る */
  }

  .pagination-buttons button:hover {
    background-color: #dddddd; /* ボタンにマウスを乗せたときの背景色を少し暗いグレーにする */
  }
</style>
</head>
<body>
<%
// ログインユーザーの区分に応じて遷移先URLを決定する処理
UsersBean loginUser = null;
Object loginUserObj = session.getAttribute("loginUser");
if (loginUserObj == null) loginUserObj = session.getAttribute("user");
if (loginUserObj == null) loginUserObj = session.getAttribute("login");
if (loginUserObj != null && loginUserObj instanceof UsersBean) {
loginUser = (UsersBean) loginUserObj;
}

String menuUrl = request.getContextPath() + "/home/admin_home.jsp"; // デフォルト
if (loginUser != null) {
String uClass = loginUser.getUserClass();
if ("0".equals(uClass) || "管理者".equals(uClass)) {
menuUrl = request.getContextPath() + "/home/admin_home.jsp";
} else if ("1".equals(uClass) || "司書".equals(uClass)) {
menuUrl = request.getContextPath() + "/home/sisyo_home.jsp";
} else if ("2".equals(uClass) || "利用者".equals(uClass)) {
menuUrl = request.getContextPath() + "/home/riyousyahome.jsp";
}
}
%>

<div class="page-header">
  <div class="page-title">検索画面</div>
  
  <button class="menu-btn" type="button" 
            onclick="location.href='<%= menuUrl %>'"
            style="position: absolute; right: 20px; top: 50%; transform: translateY(-50%); padding: 10px 25px; font-size: 0.95rem; cursor: pointer;">
        メニュー
    </button>
  
</div>

<div class="search-container">
  <form action="booksSearch" method="post" id="searchForm">
    <input type="hidden" name="page" id="pageInput" value="${currentPage != null ? currentPage : 1}">
    
    <table class="search-table">
      <tr>
        <th class="search-col-item border-bottom-gap">検索項目</th>
        <th class="search-col-value border-bottom">検索値</th>
        <td rowspan="2" class="search-col-buttons">
          <button type="submit" class="action-btn" onclick="document.getElementById('pageInput').value=1;">検索</button>
          <button type="button" class="action-btn" onclick="location.href='booksSearch'">リセット</button>
        </td>
      </tr>
      <tr>
        <td class="search-col-item border-bottom-gap"> 
          <select class="search-select" name="searchType">
            <option value="all" ${searchType == 'all' ? 'selected' : ''}>すべての項目▼</option>
            <option value="bookId" ${searchType == 'bookId' ? 'selected' : ''}>図書ID</option>
            <option value="title" ${searchType == 'title' ? 'selected' : ''}>書名</option>
            <option value="writer" ${searchType == 'writer' ? 'selected' : ''}>著者</option>
            <option value="company" ${searchType == 'company' ? 'selected' : ''}>出版社</option>
          </select>
        </td>
        <td class="search-col-value border-bottom"> 
          <input type="text" class="search-input" name="keyword" value="<c:out value='${keyword}'/>" autocomplete="off"autofocus>
        </td>
      </tr>
    </table>
  </form>
</div>

<div class="table-container">
  <p class="result-message">
    <c:choose>
      <c:when test="${bookList.size() > 0}">
        ${currentPage}ページ目：${bookList.size()}件の図書を表示しています。
      </c:when>
      <c:otherwise>
        条件に一致する図書が見つかりませんでした。
      </c:otherwise>
    </c:choose>
  </p>
  
  <table class="custom-table">
    <thead>
      <tr>
        <th class="col-no">No.</th>
        <th class="col-id">図書ID</th>
        <th class="col-title">書名</th>
        <th class="col-author">著者</th>
        <th class="col-publisher">出版社</th>
        <th class="col-category">分類</th>
        <th class="col-status">蔵書状態</th>
        <th class="col-action">操作</th>
      </tr>
    </thead>
    <tbody>
      <!-- Servletから受け取った図書リストをループで表示 -->
      <c:forEach var="book" items="${bookList}" varStatus="status">
        <tr>
          <td>${(currentPage - 1) * 10 + status.count}</td>
          <td><fmt:formatNumber value="${book.bookId}" pattern="000000" /></td>
          <td><c:out value="${book.title}" /></td>
          <td><c:out value="${book.writerName}" /></td>
          <td><c:out value="${book.company}" /></td>
          <td><c:out value="${book.bookClass}" /></td>
          
          <!-- 蔵書状態を数値から文字に変換して表示 -->
          <td>
            <c:choose>
              <c:when test="${book.bookStatus == '0'}">貸出可能</c:when>
              <c:when test="${book.bookStatus == '1'}">貸出中</c:when>
              <c:when test="${book.bookStatus == '2'}">貸出不可</c:when>
              <c:otherwise><c:out value="${book.bookStatus}" /></c:otherwise>
            </c:choose>
          </td>
          
          <td style="text-align: right; vertical-align: middle; padding: 5px 18px 5px 0;">
            <c:if test="${book.bookStatus == '0'}">
			    <fmt:formatNumber value="${book.bookId}" pattern="000000" var="fmtBookId" />
			    <fmt:formatNumber value="${sessionScope.loginUser.userId}" pattern="000000" var="fmtUserId" />
			    
			    <form action="${pageContext.request.contextPath}/lending" method="post" style="display:inline;">
			        <input type="hidden" name="action" value="searchBook">
			        <input type="hidden" name="bookId" value="${fmtBookId}">
			        <input type="hidden" name="userId" value="${fmtUserId}">
			        <button type="submit" class="action-btn">貸出</button>
			    </form>
			</c:if>
          </td>
        </tr>
      </c:forEach>
      
      <!-- 取得件数が10件未満の場合、デザイン維持のために空行を追加 -->
      <c:if test="${empty bookList || bookList.size() < 10}">
        <c:forEach begin="${empty bookList ? 1 : bookList.size() + 1}" end="10" var="i">
          <tr>
            <td>${(currentPage != null ? currentPage - 1 : 0) * 10 + i}</td>
            <td></td><td></td><td></td><td></td><td></td><td></td><td></td>
          </tr>
        </c:forEach>
      </c:if>
    </tbody>
  </table>

  <div class="pagination-area">
    <div class="pagination-buttons">
      <c:choose>
        <c:when test="${hasPrevPage}">
          <button type="button" onclick="changePage(${currentPage - 1})">◀</button>
        </c:when>
        <c:otherwise>
          <button type="button" disabled style="color:#ccc; cursor:default;">◀</button>
        </c:otherwise>
      </c:choose>
      
      <c:choose>
        <c:when test="${hasNextPage}">
          <button type="button" onclick="changePage(${currentPage + 1})">▶</button>
        </c:when>
        <c:otherwise>
          <button type="button" disabled style="color:#ccc; cursor:default;">▶</button>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>

<script>
function changePage(page) {
  // 隠しフィールドにページ番号をセットして検索フォームを送信
  document.getElementById('pageInput').value = page;
  document.getElementById('searchForm').submit();
}
</script>
</body>
</html>