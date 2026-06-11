<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書予約状況照会・取消</title>
    <style>
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 70px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; min-height: 500px; }
        
        /* 検索バー周り */
        .search-area { background: #e0e0e0; padding: 10px; border: 1px solid #666; border-radius: 5px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .search-area select, .search-area input[type="text"] { padding: 5px; }
        .search-area input[type="text"] { width: 300px; }
        
        .message { color: red; font-weight: bold; margin-bottom: 10px; }
        
        /* テーブル周り */
        table { width: 100%; border-collapse: collapse; background: white; text-align: center; }
        th, td { border: 1px solid #666; padding: 8px; }
        th { background: #e0e0e0; }
        
        .cancel-btn { color: red; cursor: pointer; padding: 2px 10px; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">図書予約状況照会・取消</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        
        <div class="message"><c:out value="${message}" /></div>

        <form id="searchForm" action="reserveSearch" method="post">
            <input type="hidden" name="action" id="actionField" value="search">
            <input type="hidden" name="cancelReserveId" id="cancelTargetId" value="">

            <div class="search-area">
                <select name="searchCategory">
                    <option value="all" ${searchCategory == 'all' ? 'selected' : ''}>すべての項目</option>
                    <option value="bookId" ${searchCategory == 'bookId' ? 'selected' : ''}>図書ID</option>
                    <option value="title" ${searchCategory == 'title' ? 'selected' : ''}>書名</option>
                    <option value="writerName" ${searchCategory == 'writerName' ? 'selected' : ''}>著者</option>
                    <option value="company" ${searchCategory == 'company' ? 'selected' : ''}>出版社</option>
                    <option value="bookClass" ${searchCategory == 'bookClass' ? 'selected' : ''}>分類</option>
                </select>
                
                <input type="text" name="searchKeyword" value="${searchKeyword}" placeholder="検索キーワードを入力">
                
                <button type="button" onclick="submitSearch()">検索</button>
                <button type="button" onclick="resetForm()">リセット</button>
            </div>

            <table>
                <tr>
                    <th>図書ID</th>
                    <th>氏名</th>
                    <th>書名</th>
                    <th>著者</th>
                    <th>予約日</th>
                    <th>予約順</th>
                    <th>取り消し</th>
                </tr>
                
                <c:choose>
                    <c:when test="${not empty reserveList}">
                        <c:forEach var="res" items="${reserveList}">
                            <tr>
                                <td><c:out value="${res.bookId}" /></td>
                                <td><c:out value="${res.userName}" /></td>
                                <td><c:out value="${res.title}" /></td>
                                <td><c:out value="${res.writerName}" /></td>
                                <td><c:out value="${res.reserveDate}" /></td>
                                <td><c:out value="${res.reserveNo}" /></td>
                                <td>
                                    <button type="button" class="cancel-btn" onclick="submitCancel('${res.reserveId}')">取り消し</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7">予約データがありません</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </table>
            
        </form>
    </div>

    <script>
        // 検索ボタン用
        function submitSearch() {
            document.getElementById('actionField').value = 'search';
            document.getElementById('searchForm').submit();
        }

        // リセットボタン用（トップに遷移し直す）
        function resetForm() {
            window.location.href = 'reserveSearch';
        }

        // 取り消しボタン用
        function submitCancel(reserveId) {
            if(confirm("この予約を取り消してもよろしいですか？")) {
                document.getElementById('actionField').value = 'cancel';
                document.getElementById('cancelTargetId').value = reserveId;
                document.getElementById('searchForm').submit();
            }
        }
    </script>
</body>
</html>