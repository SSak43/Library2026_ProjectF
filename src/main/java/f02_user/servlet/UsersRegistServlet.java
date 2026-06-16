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

	// 初期表示処理
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		UsersRegistLogic logic = new UsersRegistLogic();
		int latestId = logic.getLatestId();

		request.setAttribute("latestId", latestId);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/user_register.jsp");
		dispatcher.forward(request, response);
	}

	//  登録実行処理
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String cla = request.getParameter("cla");
		String name = request.getParameter("userName");
		String tel = request.getParameter("Tel");
		String pass = request.getParameter("Password");
		
		UsersBean usersBean = new UsersBean();
		usersBean.setUserClass(cla);
		usersBean.setUserName(name);
		usersBean.setTel(tel);
		usersBean.setPassword(pass);

		UsersRegistLogic logic = new UsersRegistLogic();
		boolean isSuccess = logic.add(usersBean);
		
		int latestId = logic.getLatestId();
		
		request.setAttribute("latestId", latestId);
		request.setAttribute("isSuccess", isSuccess);
		
		//登録されたIDは○○ですの処理
		
		if (!isSuccess) {
		    request.setAttribute("errorMessage", "登録に失敗しました。システム管理者にお問い合わせください。");
		} else {
		    
			request.setAttribute("registeredUserId", latestId);
		}
		

		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/user_register.jsp");
		dispatcher.forward(request, response);
	}
}