package Servlet; 

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 現在のセッションを取得（存在しない場合は null が返るように false を指定）
		HttpSession session = request.getSession(false);
		
		// 2. セッションが存在していれば、破棄する（ここでログイン情報がリセットされます）
		if (session != null) {
			session.invalidate();
		}
		
		// 3. ログイン画面へリダイレクト
		response.sendRedirect("login.jsp");
	}
}