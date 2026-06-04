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

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UsersUpdateServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("userId");
		//		String name = request.getParameter("userName");

		UsersBean usersBean = new UsersBean();
		UsersUpdateLogic logic = new UsersUpdateLogic();
		List<UsersBean> usersList = null;

		if (id != null && !id.isEmpty()) {
			try {
				usersBean.setUserId(Integer.parseInt(id));
				usersList = logic.id(usersBean);
			} catch (NumberFormatException e) {
				//後ほどエラー文追加
			}
		}

		HttpSession session = request.getSession();
		session.setAttribute("usersList", usersList);
		RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/UsersUpdate.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 入力データ受け取る
		String id = request.getParameter("userId");
		String cla = request.getParameter("cla");
		String name = request.getParameter("userName");
		String tel = request.getParameter("Tel");
		String pass = request.getParameter("Password");
		String status = request.getParameter("status");

		//　受け取ったデータをセット
		UsersBean usersBean = new UsersBean();
		usersBean.setUserId(Integer.parseInt(id));
		usersBean.setUserClass(cla);
		usersBean.setUserName(name);
		usersBean.setTel(tel);
		usersBean.setPassword(pass);
		usersBean.setUserStatus(status);

		//データベースへ登録
		UsersUpdateLogic logic = new UsersUpdateLogic();
		boolean update = logic.update(usersBean);

		if (update) {
			response.sendRedirect("/Library2026_ProjectF/UsersMain");
		} else {
			request.setAttribute("errorMsg", "登録に失敗しました");
		}
	}

}
