<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>貸出・予約状況</title>
    <style>
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 70px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; min-height: 500px; }
        
        .search-area { background: #e0e0e0; padding: 10px; border: 1px solid #666; border-radius: 5px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .search-label { background: #ccc; padding: 5px 15px; font-weight: bold; border: 1px solid #666; }
        .search-area input[type="text"] { width: 300px; padding: 5px; }
        
        /* テーブル共通設定 */
        table { width: 100%; border-collapse: collapse; background: white; text-align: center; margin-bottom: 20px; }
        th, td { border: 1px solid #666; padding: 8px; height: 35px; }
        th { background: #a9a9a9; } /* モックに合わせた濃いめのグレー */
        
        .action-btn { cursor: pointer; padding: 2px 10px; background: #fff; border: 1px solid #666; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">貸出・予約状況</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        
        <form id="searchForm" action="userStatus" method="post">
            <div class="search-area">
                <div class="search-label">利用者ID</div>
                <input type="text" name="userId" value="${targetUserId}" placeholder="利用者IDを入力">
                <button type="submit">表示</button>
                <button type="button" onclick="location.href='userStatus'">クリア</button>
            </div>
        </form>

        <table>
            <tr>
                <th style="width: 10%;">貸出状況</th>
                <th style="width: 15%;">図書ID</th>
                <th style="width: 35%;">書名</th>
                <th style="width: 15%;">貸出日</th>
                <th style="width: 15%;">返却期限</th>
                <th style="width: 10%;">操作</th>
            </tr>
            <c:forEach begin="0" end="4" var="i">
                <c:set var="ren" value="${rentalList[i]}" />
                <tr>
                    <td>${i + 1}</td>
                    <c:choose>
                        <c:when test="${not empty ren}">
                            <td><fmt:formatNumber value="${ren.bookId}" pattern="00000" /></td>
                            <td style="text-align: left; padding-left: 10px;"><c:out value="${ren.title}" /></td>
                            <td><fmt:formatDate value="${ren.loanDate}" pattern="yyyy/MM/dd" /></td>
                            <td><fmt:formatDate value="${ren.returnDeadline}" pattern="yyyy/MM/dd" /></td>
                            <td><button type="button" class="action-btn" onclick="location.href='returnProcess?bookId=${ren.bookId}'">返却</button></td>
                        </c:when>
                        <c:otherwise>
                            <td></td><td></td><td></td><td></td><td></td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
        </table>

        <table>
            <tr>
                <th style="width: 10%;">予約状況</th>
                <th style="width: 15%;">図書ID</th>
                <th style="width: 35%;">書名</th>
                <th style="width: 15%;">予約日</th>
                <th style="width: 15%;">利用者名</th>
                <th style="width: 10%;">操作</th>
            </tr>
            <c:forEach begin="0" end="4" var="i">
                <c:set var="res" value="${reserveList[i]}" />
                <tr>
                    <td>${i + 1}</td>
                    <c:choose>
                        <c:when test="${not empty res}">
                            <td><fmt:formatNumber value="${res.bookId}" pattern="00000" /></td>
                            <td style="text-align: left; padding-left: 10px;"><c:out value="${res.title}" /></td>
                            <td><fmt:formatDate value="${res.reserveDate}" pattern="yyyy/MM/dd" /></td>
                            <td><c:out value="${res.userName}" /></td>
                            <td><button type="button" class="action-btn" onclick="location.href='reserveCancel?reserveId=${res.reserveId}'">取り消し</button></td>
                        </c:when>
                        <c:otherwise>
                            <td></td><td></td><td></td><td></td><td></td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
        </table>

    </div>
</body>
</html>