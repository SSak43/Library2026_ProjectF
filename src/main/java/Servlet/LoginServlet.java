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
				String hashedPassword = Util.PasswordUtil.hashSHA256(password);

				// 2. DAOを使ってDBに照会（平文ではなく、ハッシュ化済みのものを渡す）
				UsersSearchDAO dao = new UsersSearchDAO();
				UsersBean loginUser = dao.authenticate(userId, hashedPassword);

				// 3. 認証結果の判定
				if (loginUser != null) {
					
					// 念のため、利用停止状態('1'等)じゃないかチェックするならここに入れます
					if("1".equals(loginUser.getUserStatus())) {
						errorMessage = "このアカウントは現在利用停止中です。";
					} else {
						// セッション（サーバー側の一時記憶）にユーザー情報を保存
						HttpSession session = request.getSession();
						session.setAttribute("loginUser", loginUser);
						
						// 権限（USER_CLASS）を取得して、遷移先を分岐させる
						String userClass = loginUser.getUserClass();
						
						if ("0".equals(userClass)) {
							// 管理者の場合：管理者メニューへ
							response.sendRedirect("admin_home.jsp");
							
						} else if ("1".equals(userClass)) {
							// 司書の場合：業務メニューへ
							response.sendRedirect("sisyo_home.jsp");
							
						} else if ("2".equals(userClass)) {
							// 利用者の場合：マイページへ
							response.sendRedirect("riyousyahome.jsp");
							
						} else {
							// 想定外のエラー時
							response.sendRedirect("error.jsp"); 
						}
						
						return; 
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