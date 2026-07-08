package f08_inquiry.servlet;

import java.io.IOException;
import java.util.ArrayList;
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
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("loginUser");

		UsersBean usersBean = new UsersBean();
		int roleType = 2;

		//役職判定。取得できなければ役職の初期値は2(=利用者)
		if (userObj != null) {
			usersBean = (UsersBean) userObj;
			String userClass = usersBean.getUserClass();
			if (userClass != null && !userClass.isEmpty()) {
				roleType = Integer.parseInt(userClass);
			}
		}

		request.setAttribute("roleType", roleType);

		// 初期表示は条件なしで全件検索（貸出日の早い順）
		RentalSearchDAO dao = new RentalSearchDAO();
		List<RentalBean> rentalList = null;

		if (request.getParameter("page") != null) {
			rentalList = (List<RentalBean>) session.getAttribute("sessionRentalList");

			// 検索キーワードなどもセッションから復元して入力欄を維持する
			request.setAttribute("searchCategory", session.getAttribute("sessionSearchCategory"));
			request.setAttribute("searchKeyword", session.getAttribute("sessionSearchKeyword"));
		}
		// 初期表示の場合
		else {
					if (roleType != 2) {
					    // 管理者は全ユーザーのデータを検索
					   rentalList = dao.searchRentals("all","");
					} else {
					    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
					    int userId = usersBean.getUserId(); 
					   rentalList = dao.searchRentalsByUserId(userId,"all","");
					}
			request.setAttribute("searchCategory", "all");
			request.setAttribute("searchKeyword", "");
		}

		session.setAttribute("sessionRentalList",rentalList);
		
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");

		pagingAndForward(request,response, rentalList);
	}

	// 「表示」ボタンが押されたとき
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("loginUser");
		UsersBean usersBean = null;
		int roleType = 2;

		//役職判定。取得できなければ役職の初期値は2(=利用者)
		if (userObj != null) {
			usersBean = (UsersBean) userObj;
			String userClass = usersBean.getUserClass();
			if (userClass != null && !userClass.isEmpty()) {
				roleType = Integer.parseInt(userClass);
			}
		}

		String searchCategory = request.getParameter("searchCategory");
		String searchKeyword = request.getParameter("searchKeyword");

		RentalSearchDAO dao = new RentalSearchDAO();
		List<RentalBean> rentalList;
		request.setAttribute("roleType", roleType);
		// 権限によってDAOの呼び出し方を変えるイメージ
		if (searchCategory == null)
			searchCategory = "all";
		if (searchKeyword == null)
			searchKeyword = "";

		if (roleType != 2) {
			// 管理者は全ユーザーのデータを検索
			rentalList = dao.searchRentals(searchCategory, searchKeyword);
		} else {
			// 一般ユーザーは自分のログインIDに紐づくデータだけ検索
			int userId = usersBean.getUserId();
			rentalList = dao.searchRentalsByUserId(userId, searchCategory, searchKeyword);
		}

		session.setAttribute("sessionReserveList", rentalList);
		session.setAttribute("sessionSearchCategory", searchCategory);
		session.setAttribute("sessionSearchKeyword", searchKeyword);
		
		// 画面に入力値を残すために再セット
		request.setAttribute("rentalList", rentalList);
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

//		request.getRequestDispatcher("/WEB-INF/jsp/F-08/bookInquiry.jsp").forward(request, response);

		pagingAndForward(request,response, rentalList);
	}
	private void pagingAndForward(HttpServletRequest request, HttpServletResponse response, 
			List<RentalBean> rentalList) throws ServletException, IOException {
		
		// 1. 現在のページ番号を取得 (リクエストになければ1ページ目とする)
		int currentPage = 1;
		String pageParam = request.getParameter("page");
		if (pageParam != null && !pageParam.isEmpty()) {
			try {
				currentPage = Integer.parseInt(pageParam);
			} catch (NumberFormatException e) {
				currentPage = 1;
			}
		}
		
		int pageSize = 10; // 1ページあたりの件数

		// --- 貸出状況 (rentalList) のページング処理 ---
		int totalRentals = (rentalList != null) ? rentalList.size() : 0;
		int maxPageRental = (int) Math.ceil((double) totalRentals / pageSize);
		if (maxPageRental == 0) maxPageRental = 1;

		int rentalFrom = (currentPage - 1) * pageSize;
		int rentalTo = Math.min(rentalFrom + pageSize, totalRentals);
		
		List<RentalBean> pagedRentalList = new ArrayList<>();
		if (rentalList != null && rentalFrom < totalRentals) {
			pagedRentalList = rentalList.subList(rentalFrom, rentalTo);
		}

		int maxPage = maxPageRental;

		// 2. 切り出した5件のデータと、ページ情報をリクエスト属性にセット
		request.setAttribute("rentalList", pagedRentalList);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("maxPage", maxPage);

		// 3. JSPへフォワード
		request.getRequestDispatcher("/WEB-INF/jsp/F-08/bookInquiry.jsp").forward(request, response);
	}
}