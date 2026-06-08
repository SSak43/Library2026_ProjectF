package f02_user.servlet;

import java.io.IOException;

import Model.UsersBean;
import f02_user.logic.UsersRegistLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UsersRegist")
public class UsersRegistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UsersRegistServlet() {
		super();
	}

	// 🛠️ 初期表示処理（最新のIDを取得して画面を開く）
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		UsersRegistLogic logic = new UsersRegistLogic();
		int latestId = logic.getLatestId();

		// 取得した現在の最大IDを登録画面に引き渡す
		request.setAttribute("latestId", latestId);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/user/UsersRegist.jsp");
		dispatcher.forward(request, response);
	}

	// 💾 登録実行処理（JSPの確認モーダルの「登録」が押されたらここに来る）
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		// JSPの各 input / radio の name 属性から値を受け取る
		String cla = request.getParameter("cla");
		String name = request.getParameter("userName");
		String tel = request.getParameter("Tel");
		String pass = request.getParameter("Password");
		
		// 受け取ったデータを作っていただいたBeanにセット
		UsersBean usersBean = new UsersBean();
		usersBean.setUserClass(cla);
		usersBean.setUserName(name);
		usersBean.setTel(tel);
		usersBean.setPassword(pass);

		// データベースへ登録実行
		UsersRegistLogic logic = new UsersRegistLogic();
		boolean isSuccess = logic.add(usersBean);
		
		// 画面を再表示するため、最新のIDをもう一度取得する（登録が成功していれば+1された状態になる）
		int latestId = logic.getLatestId();
		
		// 結果フラグやIDをJSPへ渡す
		request.setAttribute("latestId", latestId);
		request.setAttribute("isSuccess", isSuccess);
		
		if (!isSuccess) {
			request.setAttribute("errorMessage", "登録に失敗しました。システム管理者にお問い合わせください。");
		}

		// 再度、登録画面へフォワード（JSP側の制御で完了モーダルが開きます）
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/user/UsersRegist.jsp");
		dispatcher.forward(request, response);
	}
}