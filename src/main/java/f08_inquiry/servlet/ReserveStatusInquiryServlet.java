package f08_inquiry.servlet;

import java.io.IOException;
import java.util.List;

import Model.ReserveBean;
import Model.UsersBean;
import f08_inquiry.dao.ReserveStatusInquiryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reserveStatusInquiry")
public class ReserveStatusInquiryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("loginUser");
		
		UsersBean usersBean = null;
		int roleType = 2;
		
		if(userObj != null) {
			usersBean = (UsersBean) userObj;
			String userClass = usersBean.getUserClass();
			if(userClass != null && !userClass.isEmpty()) {
				roleType = Integer.parseInt(userClass);
			}
		}
		
		ReserveStatusInquiryDAO dao = new ReserveStatusInquiryDAO();
		List<ReserveBean> reserveList;
		if (roleType != 2) {
		    // 管理者は全件検索
		   reserveList = dao.searchReserves("all","");
		} else {
		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
		    int userId = usersBean.getUserId(); 
		   reserveList = dao.searchReservesByUserId(userId,"all","");
		}
		request.setAttribute("reserveList", reserveList);
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");

		request.getRequestDispatcher("/WEB-INF/jsp/F-08/F-08_1.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("loginUser");
		
		UsersBean usersBean = null;
		int roleType = 2;
		
		if(userObj != null) {
			usersBean = (UsersBean) userObj;
			String userClass = usersBean.getUserClass();
			if(userClass != null && !userClass.isEmpty()) {
				roleType = Integer.parseInt(userClass);
			}
		}
		
		String searchCategory = request.getParameter("searchCategory");
		String searchKeyword = request.getParameter("searchKeyword");

		ReserveStatusInquiryDAO dao = new ReserveStatusInquiryDAO();
		List<ReserveBean> reserveList;
		request.setAttribute("roleType", roleType);
		if (roleType != 2) {
		    // 管理者は全件検索
		   reserveList = dao.searchReserves("all","");
		} else {
		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
		    int userId = usersBean.getUserId(); 
		   reserveList = dao.searchReservesByUserId(userId,"all","");
		}	

		request.setAttribute("reserveList", reserveList);
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

		request.getRequestDispatcher("/WEB-INF/jsp/F-08/F-08_1.jsp").forward(request, response);
	}
}