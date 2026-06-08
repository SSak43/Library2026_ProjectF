<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書貸出状況照会</title>
    <style>
        /* reserveSearch.jsp のデザインベース */
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 70px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; min-height: 500px; }
        
        /* 検索エリア */
        .search-area { background: #e0e0e0; padding: 10px; border: 1px solid #666; border-radius: 5px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .search-area select, .search-area input[type="text"] { padding: 5px; }
        .search-area input[type="text"] { width: 300px; }
        
        /* 一覧テーブル */
        table { width: 100%; border-collapse: collapse; background: white; text-align: center; }
        th, td { border: 1px solid #666; padding: 8px; }
        th { background: #e0e0e0; }
        .detail-btn { cursor: pointer; padding: 2px 10px; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">図書貸出状況照会</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        
        <form id="searchForm" action="rentalSearch" method="post">
            <input type="hidden" name="action" id="actionField" value="search">

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
                
                <button type="button" onclick="submitSearch()">表示</button>
            
                <button type="button" onclick="resetForm()">リセット</button>
            </div>

            <table>
                <tr>
                    <th style="width: 5%;">No.</th>
                    <th style="width: 15%;">図書ID</th>
                    <th style="width: 45%;">書名</th>
                    <th style="width: 15%;">貸出日</th>
                    <th style="width: 15%;">返却期限</th>
                    <th style="width: 5%;">操作</th>
                </tr>
                
                <c:choose>
                    <c:when test="${not empty rentalList}">
                        <c:forEach var="ren" items="${rentalList}" varStatus="status">
                            <tr>
                                <td>${status.count}</td> 
                                <td><c:out value="${ren.bookId}" /></td>
                                <td style="text-align: left;"><c:out value="${ren.title}" /></td>
                                <td><c:out value="${ren.loanDate}" /></td>
                                <td><c:out value="${ren.returnDeadline}" /></td>
                                <td>
                                    <button type="button" class="detail-btn" onclick="location.href='userStatus?userId=${ren.userId}'">詳細</button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="6">貸出中のデータがありません</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </table>
            
        </form>
    </div>

    <script>
        // 🔍 表示（検索）ボタン用
        function submitSearch() {
            document.getElementById('actionField').value = 'search';
            document.getElementById('searchForm').submit();
        }

        // 🔄 リセットボタン用
        function resetForm() {
            window.location.href = 'rentalSearch';
        }
    </script>
</body>
</html>