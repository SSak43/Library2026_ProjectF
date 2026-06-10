package f02_user.servlet;

import java.io.IOException;
import java.util.List;

import Model.UsersBean;
import f02_user.logic.UsersUpdateLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UsersUpdateServlet
 */
@WebServlet("/UsersUpdate")
public class UsersUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UsersUpdateServlet() {
		super();
	}

	/**
	 * 初期表示 ＆ 利用者IDでの検索処理 (GET)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("userId");

		UsersBean usersBean = new UsersBean();
		UsersUpdateLogic logic = new UsersUpdateLogic();
		List<UsersBean> usersList = null;

		if (id != null && !id.isEmpty()) {
			try {
				usersBean.setUserId(Integer.parseInt(id));
				usersList = logic.id(usersBean);
				
				if (usersList == null || usersList.isEmpty()) {
					// IDが見つからない場合のエラーメッセージ
					request.setAttribute("errorMessage", "この利用者IDは存在しません");
				} else {
					// 見つかった場合はデータをリクエストとセッションに保存（パスワード維持のため）
					request.setAttribute("usersList", usersList);
					HttpSession session = request.getSession();
					session.setAttribute("usersList", usersList);
				}
			} catch (NumberFormatException e) {
				request.setAttribute("errorMessage", "無効なID形式です");
			}
		}


		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/userUpdate.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 *  更新実行処理 (POST)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		UsersUpdateLogic logic = new UsersUpdateLogic();
		
		// 画面からの入力データを受け取る
		String id = request.getParameter("userId");
		String cla = request.getParameter("cla");
		String name = request.getParameter("userName");
		String tel = request.getParameter("Tel");
		String pass = request.getParameter("Password");
		String status = request.getParameter("status");
		
		// 受け取ったデータをBeanにセット
		UsersBean usersBean = new UsersBean();
		usersBean.setUserId(Integer.parseInt(id));
		usersBean.setUserClass(cla);
		usersBean.setUserName(name);
		usersBean.setTel(tel);
		usersBean.setUserStatus(status);

		// パスワード欄が空欄の場合の処理
		if (pass == null || pass.isEmpty()) {
			HttpSession session = request.getSession();
			List<UsersBean> usersList = (List<UsersBean>) session.getAttribute("usersList");
			
			if (usersList != null && !usersList.isEmpty()) {
				// 変更前のハッシュ化済みのパスワードをそのままセットして維持
				usersBean.setPassword(usersList.get(0).getPassword());
			}
		} else {
			// 新しいパスワードが入力されている場合はハッシュ化してセット
			usersBean.setPassword(logic.hash(pass));
		}

		// データベースの更新を実行
		boolean isSuccess = logic.update(usersBean);
		request.setAttribute("isSuccess", isSuccess);

		if (!isSuccess) {
			request.setAttribute("errorMessage", "更新に失敗しました。再度やり直してください。");
		} else {
			// 更新成功時は古いセッション情報をクリア
			HttpSession session = request.getSession();
			session.removeAttribute("usersList");
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/userUpdate.jsp");
		dispatcher.forward(request, response);
	}
}