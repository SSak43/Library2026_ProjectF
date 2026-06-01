<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>図書システム - 予約登録</title>
    <style>
        body { font-family: sans-serif; background-color: #b0c4de; margin: 0; padding: 200px 20px 20px 20px; }
        .header { position: absolute; top: 0; left: 0; width: 100%; height: 50px; background: #e0e0e0; display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #666; }
        .main-box { background: #d3d3d3; border: 2px solid #666; padding: 20px; position: relative; min-height: 450px; }
        .error { color: red; font-weight: bold; text-align: center; margin-bottom: 10px; }
        .success { color: green; font-weight: bold; text-align: center; margin-bottom: 10px; }
        table { width: 80%; border-collapse: collapse; margin-bottom: 20px; background: white; }
        table, th, td { border: 1px solid #666; }
        th, td { padding: 10px; text-align: left; }
        th { background: #e0e0e0; width: 20%; }
        .input-group { margin-bottom: 10px; }
        .readonly-input { width: 90%; background-color: #c0c0c0; border: 1px solid #666; padding: 5px; color: #555; pointer-events: none; }
        .btn-right { position: absolute; bottom: 20px; right: 20px; padding: 10px 30px; font-size: 16px; }
    </style>
</head>
<body>

    <div class="header">
        <div style="margin-left: 20px; font-weight: bold;">予約登録入力画面</div>
        <button type="button" style="margin-right: 20px;" onclick="location.href='menu.jsp'">メニュー</button>
    </div>

    <div class="main-box">
        <div class="error"><c:out value="${errorMessage}" /></div>
        <div class="success"><c:out value="${successMessage}" /></div>

        <form id="reserveForm" action="reserveBook" method="post">
            <input type="hidden" id="actionField" name="action" value="">

            <div class="input-group">
                <input type="text" name="userId" placeholder="利用者IDを入力" value="${inputUserId}">
                <button type="button" onclick="submitAction('searchUser')">表示</button>
            </div>
            <table>
                <tr>
                    <th>氏名</th>
                    <td><input type="text" class="readonly-input" value="${selectedUser != null ? selectedUser.userName : ''}" readonly></td>
                </tr>
            </table>

            <br>

            <div class="input-group">
                <input type="text" name="bookId" placeholder="図書IDを入力" value="${inputBookId}">
                <button type="button" onclick="submitAction('searchBook')">表示</button>
            </div>
            <table>
                <tr>
                    <th>書名</th>
                    <td><input type="text" class="readonly-input" value="${selectedBook != null ? selectedBook.title : ''}" readonly></td>
                </tr>
                <tr>
                    <th>著者名</th>
                    <td><input type="text" class="readonly-input" value="${selectedBook != null ? selectedBook.writerName : ''}" readonly></td>
                </tr>
                <tr>
                    <th>貸出状態</th>
                    <td><input type="text" class="readonly-input" value="${displayBookStatus}" readonly></td>
                </tr>
            </table>

            <button type="button" class="btn-right" onclick="submitAction('register')">登録</button>
        </form>
    </div>

    <script>
        function submitAction(actionType) {
            document.getElementById('actionField').value = actionType;
            document.getElementById('reserveForm').submit();
        }
    </script>
</body>
</html>