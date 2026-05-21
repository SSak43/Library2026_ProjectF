package Servlet;

import java.io.IOException;
import java.util.List;

import Model.UsersBean;
import Model.UsersListLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UsersListServlet
 */
public class UsersListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UsersListServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		String mode = request.getParameter("mode");
		String name = request.getParameter("name");
		
		UsersBean usersBean = new UsersBean();
		UsersListLogic logic = new UsersListLogic();
		List<UsersBean> usersList = null;
		
		
		if(mode == null || name == null || name.isEmpty()) {
			usersBean.setUserName(name);
			usersList = logic.all(usersBean);
		}else if("nameQuery".equals(mode)) {
			usersBean.setUserName(name);
			usersList = logic.name(usersBean);
		}else if("idQuery".equals(mode)) {
			usersBean.setUserId(Integer.parseInt(name));
			usersList = logic.id(usersBean);
		}
		
		HttpSession session = request.getSession();
		session.setAttribute("usersList", usersList);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/UsersList.jsp");
		dispatcher.forward(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
