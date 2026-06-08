package f02_user.servlet;

import java.io.IOException;
import java.util.List;

import Model.UsersBean;
import f02_user.logic.UsersSearchLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UsersSearchServlet
 */
@WebServlet("/UsersSearch")
public class UsersSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UsersSearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("userId");
//		String name = request.getParameter("userName");
		String cla = request.getParameter("cla");
		
		UsersBean usersBean = new UsersBean();
		UsersSearchLogic logic = new UsersSearchLogic();
		List<UsersBean> usersList = null;

		
		if (id != null && !id.isEmpty()) {
	        try {
	            usersBean.setUserId(Integer.parseInt(id));
	            usersList = logic.id(usersBean);
	        } catch (NumberFormatException e) {
	            // IDに数字以外が入った場合の安全対策として全件表示にする
	            usersList = logic.all(usersBean);
	        }
	    }// 2. クラス欄に入力がある場合（nullではなく、空文字でもない）
	    else if (cla != null && !cla.isEmpty()) {
	        usersBean.setUserClass(cla);
	        usersList = logic.userClass(usersBean);
	    } 
	    // 3. どちらも空っぽの場合
	    else {
	        usersList = logic.all(usersBean);
	    }
		
//		if(id == null || name == null || name.isEmpty()) {
//			usersBean.setUserName(name);
//			usersList = logic.all(usersBean);
//		}else if("userName".equals(name)) {
//			usersBean.setUserName(name);
//			usersList = logic.name(usersBean);
//		}else if("userName".equals(id)) {
//			usersBean.setUserId(Integer.parseInt(id));
//			usersList = logic.id(usersBean);
//		}
		
		HttpSession session = request.getSession();
		session.setAttribute("usersList", usersList);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/user/UsersList.jsp");
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
