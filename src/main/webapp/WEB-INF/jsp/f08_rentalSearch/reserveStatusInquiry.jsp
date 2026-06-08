<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>予約状況</title>
    <style>
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 70px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; min-height: 500px; }
        
        .search-area { background: #e0e0e0; padding: 10px; border: 1px solid #666; border-radius: 5px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .search-area select, .search-area input[type="text"] { padding: 5px; }
        .search-area input[type="text"] { width: 300px; }
        
        .count-message { margin-bottom: 10px; font-size: 14px; color: #333; }
        
        /* 一覧テーブル */
        table { width: 100%; border-collapse: collapse; background: white; text-align: center; }
        th, td { border: 1px solid #666; padding: 8px; height: 35px; /* 空行でも高さを維持 */ }
        th { background: #e0e0e0; }
        
        .detail-btn { cursor: pointer; padding: 2px 10px; background: #fff; border: 1px solid #666; }
        
        /* 💡 ページングボタンをテーブル右下に密着させるスタイル */
        .paging-area { display: flex; justify-content: flex-end; margin-top: 0; }
        .paging-btn { padding: 5px 15px; background: #fff; border: 1px solid #666; border-top: none; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">予約状況</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        
        <form id="searchForm" action="reserveStatusInquiry" method="post">
            <input type="hidden" name="action" id="actionField" value="search">

            <div class="search-area">
                <select name="searchCategory">
                    <option value="all" ${searchCategory == 'all' ? 'selected' : ''}>すべての項目</option>
                    <option value="bookId" ${searchCategory == 'bookId' ? 'selected' : ''}>図書ID</option>
                    <option value="title" ${searchCategory == 'title' ? 'selected' : ''}>書名</option>
                    <option value="writerName" ${searchCategory == 'writerName' ? 'selected' : ''}>著者</option>
                    <option value="company" ${searchCategory == 'company' ? 'selected' : ''}>出版社</option>
                    <option value="bookClass" ${searchCategory == 'bookClass' ? 'selected' : ''}>分類</option>
                    <option value="userId" ${searchCategory == 'userId' ? 'selected' : ''}>利用者ID</option>
                </select>
                
                <input type="text" name="searchKeyword" value="${searchKeyword}" placeholder="検索キーワードを入力">
                
                <button type="button" onclick="submitSearch()">表示</button>
                <button type="button" onclick="resetForm()">リセット</button>
            </div>

            <div class="count-message">
                <c:choose>
                    <c:when test="${not empty reserveList}">
                        ${reserveList.size()} 件の予約図書が見つかりました。
                    </c:when>
                    <c:otherwise>
                        0 件の予約図書が見つかりました。
                    </c:otherwise>
                </c:choose>
            </div>

            <table>
                <tr>
                    <th style="width: 5%;">No.</th>
                    <th style="width: 15%;">図書ID</th>
                    <th style="width: 40%;">書名</th>
                    <th style="width: 15%;">予約日</th>
                    <th style="width: 15%;">利用者名</th>
                    <th style="width: 10%;">操作</th>
                </tr>
                
                <c:forEach begin="0" end="9" var="i">
                    <c:set var="res" value="${reserveList[i]}" />
                    
                    <tr>
                        <td>${i + 1}</td>
                        <c:choose>
                            <c:when test="${not empty res}">
                                <td><fmt:formatNumber value="${res.bookId}" pattern="00000" /></td>
                                <td style="text-align: left; padding-left: 10px;"><c:out value="${res.title}" /></td>
                                <td><fmt:formatDate value="${res.reserveDate}" pattern="yyyy/MM/dd" /></td>
                                <td><c:out value="${res.userName}" /></td>
                                <td>
                                    <button type="button" class="detail-btn" onclick="location.href='userStatus?userId=${res.userId}'">詳細</button>
                                </td>
                            </c:when>
                            <c:otherwise>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
            </table>
            
            <div class="paging-area">
                <button type="button" class="paging-btn">◀</button>
                <button type="button" class="paging-btn">▶</button>
            </div>
            
        </form>
    </div>

    <script>
        function submitSearch() {
            document.getElementById('actionField').value = 'search';
            document.getElementById('searchForm').submit();
        }

        function resetForm() {
            window.location.href = 'reserveStatusInquiry';
        }
    </script>
</body>
</html>