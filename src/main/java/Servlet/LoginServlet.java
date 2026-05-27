package Servlet;

import java.io.IOException;

import Dao.UsersSearchDAO;
import Model.UsersBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// GETリクエスト（直接URLを叩かれたとき）はログイン画面を表示
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}

	// POSTリクエスト（ログインボタンが押されたとき）
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 画面から送られたIDとパスワードを取得
		String idStr = request.getParameter("id");
		String password = request.getParameter("password");

		// エラーメッセージ用変数
		String errorMessage = "";

		if (idStr != null && !idStr.isEmpty() && password != null && !password.isEmpty()) {
			try {
				int userId = Integer.parseInt(idStr);

				// 2. DAOを使ってDBに照会
				UsersSearchDAO dao = new UsersSearchDAO();
				UsersBean loginUser = dao.authenticate(userId, password);

				// 3. 認証結果の判定
				if (loginUser != null) {
					// ログイン成功！
					
					// 念のため、利用停止状態('1'等)じゃないかチェックするならここに入れます
					if("1".equals(loginUser.getUserStatus())) {
						errorMessage = "このアカウントは現在利用停止中です。";
					} else {
						// セッション（サーバー側の一時記憶）にユーザー情報を保存
						HttpSession session = request.getSession();
						session.setAttribute("loginUser", loginUser);

						// メニュー画面へリダイレクト（URLを /menu に変更させる）
						response.sendRedirect("menu");
						return; // これ以降の処理をしないためにreturn
					}
				} else {
					// ログイン失敗（IDかパスワードが違う）
					errorMessage = "IDまたはパスワードが間違っています。";
				}
			} catch (NumberFormatException e) {
				errorMessage = "IDは数字で入力してください。";
			}
		} else {
			errorMessage = "IDとパスワードを入力してください。";
		}

		// エラーがあった場合はメッセージをセットしてlogin.jspに戻す
		request.setAttribute("errorMessage", errorMessage);
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}
}