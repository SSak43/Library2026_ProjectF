package f08_inquiry.servlet;

import java.io.IOException;
import java.util.List;

import Model.RentalBean;
import Model.UsersBean;
import f08_inquiry.dao.RentalSearchDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/rentalSearch")
public class RentalSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 最初画面を開いたとき（URL直接入力やメニューからの遷移）
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("usersBean");
		UsersBean usersBean = new UsersBean();
		int roleType = 2;
		
		if(userObj != null) {
			String userClass = usersBean.getUserClass();
			if (userClass != null && !userClass.isEmpty()) {
	            roleType = Integer.parseInt(userClass);
	        }
		}
		
		request.setAttribute("roleType", roleType);
		
		// 初期表示は条件なしで全件検索（貸出日の早い順）
		RentalSearchDAO dao = new RentalSearchDAO();
		List<RentalBean> rentalList = dao.searchRentals("all", "");

		request.setAttribute("rentalList", rentalList);
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");

		request.getRequestDispatcher("/WEB-INF/jsp/F-08/F-08.jsp").forward(request, response);
	}

	// 「表示」ボタンが押されたとき
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		

		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("usersBean");
		UsersBean usersBean = new UsersBean();
		int roleType = 2;
		
		if(userObj != null) {
			String userClass = usersBean.getUserClass();
			if (userClass != null && !userClass.isEmpty()) {
	            roleType = Integer.parseInt(userClass);
	        }
		}
		String action = request.getParameter("action");
		String searchCategory = request.getParameter("searchCategory");
		String searchKeyword = request.getParameter("searchKeyword");
		
		RentalSearchDAO dao = new RentalSearchDAO();
		List<RentalBean> rentalList;	
		request.setAttribute("roleType", roleType);
				// 権限によってDAOの呼び出し方を変えるイメージ
		if (roleType != 2) {
		    // 管理者は全件検索
		   rentalList = dao.searchRentals(searchCategory, searchKeyword);
		} else {
		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
		    int userId = usersBean.getUserId(); 
		   rentalList = dao.searchRentalsByUserId(userId, searchCategory, searchKeyword);
		}


		if (searchCategory == null && rentalList == null) searchCategory = "all";
		if (searchKeyword == null && rentalList == null) searchKeyword = "";


		// 画面に入力値を残すために再セット
		request.setAttribute("rentalList", rentalList);
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

		request.getRequestDispatcher("/WEB-INF/jsp/F-08/F-08.jsp").forward(request, response);
	}
}