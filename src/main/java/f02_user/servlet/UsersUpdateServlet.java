package f02_user.servlet;

import java.io.IOException;
import java.util.List;

import Model.UsersBean;
import f02_user.logic.UsersUpdateLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UsersUpdateServlet
 */
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
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("userId");
//		String name = request.getParameter("userName");
		String cla = request.getParameter("cla");
		
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
		dispatcher.forward(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
