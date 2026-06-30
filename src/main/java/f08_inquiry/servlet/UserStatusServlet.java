package f08_inquiry.servlet;

import java.io.IOException;
import java.util.List;

import Model.RentalBean;
import Model.ReserveBean;
import Model.UsersBean;
import f08_inquiry.dao.UserStatusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/userStatus")
public class UserStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		if(request.getParameter("userId") != null) {
			execute(request,response);
			return;
		}
		
		HttpSession session = request.getSession();
		
		Object userObj = session.getAttribute("loginUser");
		
		UsersBean usersBean = new UsersBean();
		int roleType = 2;
		
		if(userObj != null) {
			usersBean = (UsersBean) userObj;
			String userClass = usersBean.getUserClass();
			if (userClass != null && !userClass.isEmpty()) {
	            roleType = Integer.parseInt(userClass);
	        }
		}
		
		request.setAttribute("roleType", roleType);
		
		// 初期表示は条件なしで全件検索（貸出日の早い順）
		UserStatusDAO dao = new UserStatusDAO();
		List<RentalBean> rentalList;
		List<ReserveBean> reserveList;
		
		if (roleType != 2) {
		    // 管理者は全件検索
		   rentalList = null;
		} else {
		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
		    String userId = Integer.toString(usersBean.getUserId()); 
			rentalList = dao.getUserRentals(userId);
			reserveList = dao.getUserReserves(userId);

			request.setAttribute("rentalList", rentalList);
			request.setAttribute("reserveList", reserveList);
		}

		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");

		request.getRequestDispatcher("/WEB-INF/jsp/F-08/allInquiry.jsp").forward(request, response);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		execute(request, response);
	}

	private void execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		// ① まず詳細ボタンや検索バーから送られてきた「userId」を取得する
		String userId = request.getParameter("userId");

		HttpSession session = request.getSession();
		UsersBean loginUser = (UsersBean) session.getAttribute("loginUser");

		// ② もし上の「userId」が空っぽだった場合のみ、バックアップとしてログイン情報等から取得する
		if (userId == null || userId.trim().isEmpty()) {
			if (loginUser != null) {
				userId = (String) session.getAttribute("userId");
			}
		}

		// ③ それでも空（初回直接アクセスなど）の場合は空文字にする
		if (userId == null) {
			userId = "";
		}

		UserStatusDAO dao = new UserStatusDAO();

		// IDが決まったら、そのユーザーのデータを各5件ずつ取得
		if (!userId.isEmpty()) {
			List<RentalBean> rentalList = dao.getUserRentals(userId);
			List<ReserveBean> reserveList = dao.getUserReserves(userId);

			request.setAttribute("rentalList", rentalList);
			request.setAttribute("reserveList", reserveList);
		}

		// 画面上の「利用者ID」テキストボックスに渡す値をセット
		request.setAttribute("targetUserId", userId);

		// JSPへフォワード
		request.getRequestDispatcher("/WEB-INF/jsp/F-08/allInquiry.jsp").forward(request, response);
	}
}