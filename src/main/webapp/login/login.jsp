<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>図書システム - ログイン</title>
    <link rel="stylesheet" href="/Library2026_ProjectF/login/login.css">
</head>
<body>

    <header class="header">
        図書システム
    </header>

    <div class="main-container">
        <div class="login-panel">
            <h2 class="login-title">ログイン</h2>

            <div class="error-container">
                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null && !errorMessage.isEmpty()) {
                %>
                    <p class="error-message"><%= errorMessage %></p>
                <%
                    }
                %>
            </div>

            <form action="/Library2026_ProjectF/login" method="post">
                <div class="form-group">
				    <label for="login_id">ID</label>
				    <input type="text" id="login_id" name="login_id" class="form-control" required autofocus maxlength="6" pattern="[0-9]{6}" 
				           oninvalid="this.setCustomValidity('6桁の数字（例: 123456）を入力してください')" 
				           oninput="checkNumberOnly(this)">
				</div>
				    <div class="form-group">
                    <label for="password">パスワード</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>

                <button type="submit" class="btn-login">ログイン</button>
            </form>
        </div>
    </div>

    <%
        String systemError = (String) request.getAttribute("systemError");
        if (systemError != null && !systemError.isEmpty()) {
    %>
    <div class="modal-overlay" id="systemErrorModal">
        <div class="modal-content">
            <p class="modal-text">予期せぬシステムエラーが発生しました。</p>
            <p class="modal-text">しばらく時間をおいてから再度お試しください。</p>
            <div class="modal-actions">
                <button type="button" class="btn-confirm" onclick="document.getElementById('systemErrorModal').style.display='none'">確認</button>
            </div>
        </div>
    </div>
    <%
        }
    %>
    
    <script>
    // 全角数字を半角にしつつ、数字以外なら「吹き出し」で警告を出す関数
    function checkNumberOnly(inputElement) {
        // ① 全角数字を半角に自動変換
        var converted = inputElement.value.replace(/[０-９]/g, function(s) {
            return String.fromCharCode(s.charCodeAt(0) - 0xFEE0);
        });

        // ② 半角数字「以外」の文字が含まれているかチェック
        if (/[^0-9]/.test(converted)) {
            // ★あの吹き出しメッセージを設定して、即座に表示させる
            inputElement.setCustomValidity('数字のみ入力可能です');
            inputElement.reportValidity();
            
            // 数字以外の文字を強制的に消去して元に戻す
            inputElement.value = converted.replace(/[^0-9]/g, '');
        } else {
            // 正常な数字のみの場合は、吹き出しのエラー状態を解除する
            inputElement.setCustomValidity('');
            inputElement.value = converted;
        }
    }
</script>

</body>
</html>