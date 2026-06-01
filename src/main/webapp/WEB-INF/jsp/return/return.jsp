<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書システム - 返却画面</title>
    <style>
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 200px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; position: relative; min-height: 350px; }
        .error { color: red; font-weight: bold; text-align: center; margin-bottom: 10px; }
        .success { color: green; font-weight: bold; text-align: center; margin-bottom: 10px; }
        table { width: 80%; border-collapse: collapse; margin-bottom: 20px; background: white; }
        table, th, td { border: 1px solid #666; }
        th, td { padding: 10px; text-align: left; }
        th { background: #e0e0e0; width: 20%; }
        .btn-right { position: absolute; bottom: 20px; right: 20px; padding: 10px 30px; font-size: 16px; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">返却画面</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        <div class="error"><c:out value="${errorMessage}" /></div>
        <div class="success"><c:out value="${successMessage}" /></div>

        <form id="returnForm" action="returnBook" method="post">
            <input type="hidden" name="lendId" value="${activeLend != null ? activeLend.lendId : ''}">
            <input type="hidden" id="actionField" name="action" value="">

            <div style="margin-bottom: 10px;">
                <input type="text" name="bookId" id="bookIdInput" placeholder="図書ID入力" value="${inputBookId}">
                <button type="button" onclick="submitAction('search')">表示</button>
            </div>

            <table>
                <tr>
                    <th>書名</th>
                    <td><c:out value="${activeLend.title}" /></td>
                </tr>
                <tr>
                    <th>氏名</th>
                    <td><c:out value="${activeLend.userName}" /></td>
                </tr>
                <tr>
                    <th>貸出日</th>
                    <td><c:out value="${activeLend.lendDate}" /></td>
                </tr>
                <tr>
                    <th>返却日</th>
                    <td><c:if test="${activeLend != null}"><c:out value="${today}" /></c:if></td>
                </tr>
            </table>

            <button type="button" class="btn-right" onclick="submitAction('return')">登録</button>
        </form>
    </div>

    <script>
        function submitAction(actionType) {
            if (actionType === 'return') {
                var lendId = document.getElementsByName('lendId')[0].value;
                if (lendId === "") {
                    alert("図書を検索して表示させてから、登録を行ってください。");
                    return;
                }
            }
            document.getElementById('actionField').value = actionType;
            document.getElementById('returnForm').submit();
        }
    </script>
</body>
</html>