package f08_inquiry.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import Model.RentalBean;
import Model.ReserveBean;
import Model.UsersBean;
import f08_inquiry.dao.RentalSearchDAO;
import f08_inquiry.dao.ReserveStatusInquiryDAO;
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
		
//		execute(request,response);
	    
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
		
		List<RentalBean> rentalList = null;
		List<ReserveBean> reserveList = null;

		if (request.getParameter("pageRental") != null || request.getParameter("pageReserve") != null) {
			rentalList = (List<RentalBean>) session.getAttribute("sessionRentalList");
			reserveList = (List<ReserveBean>) session.getAttribute("sessionReserveList");
			
			// 検索キーワードなどもセッションから復元して入力欄を維持する
			request.setAttribute("searchCategory", session.getAttribute("sessionSearchCategory"));
			request.setAttribute("searchKeyword", session.getAttribute("sessionSearchKeyword"));
		} 
		// 初期表示の場合
		else {
			UserStatusDAO dao = new UserStatusDAO();
			if (roleType == 2) {
				String userId = Integer.toString(usersBean.getUserId()); 
				rentalList = dao.getUserRentals(userId);
				reserveList = dao.getUserReserves(userId);
			}
			request.setAttribute("searchCategory", "all");
			request.setAttribute("searchKeyword", "");
		}
		
//		if (roleType != 2) {
//		    // 管理者は全件検索
//		   rentalList = null;
//		} else {
//		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
//		    String userId = Integer.toString(usersBean.getUserId()); 
//			rentalList = dao.getUserRentals(userId);
//			reserveList = dao.getUserReserves(userId);
//		}

		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");
//		request.getRequestDispatcher("/WEB-INF/jsp/F-08/allInquiry.jsp").forward(request, response);
		pagingAndForward(request, response, rentalList,reserveList);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
//		execute(request,response);
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
		RentalSearchDAO rndao = new RentalSearchDAO();
		ReserveStatusInquiryDAO rsdao = new ReserveStatusInquiryDAO();
		List<RentalBean> rentalList;
		List<ReserveBean> reserveList;
		request.setAttribute("roleType", roleType);
		
		if(searchCategory == null) searchCategory = "all";
		if(searchKeyword == null) searchKeyword = "";
		
		if (roleType != 2) {
		    // 管理者は全件検索
			rentalList = rndao.searchRentals(searchCategory,searchKeyword);
		   reserveList = rsdao.searchReserves(searchCategory, searchKeyword);
		   
		} else {
		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
		    int userId = usersBean.getUserId();
		    rentalList = rndao.searchRentalsByUserId(userId, searchCategory, searchKeyword);
		   reserveList = rsdao.searchReservesByUserId(userId,searchCategory, searchKeyword);
		}	
//		request.setAttribute("rentalList", rentalList);
//		request.setAttribute("reserveList", reserveList);
		session.setAttribute("sessionRentalList", rentalList);
		session.setAttribute("sessionReserveList", reserveList);
		session.setAttribute("sessionSearchCategory", searchCategory);
		session.setAttribute("sessionSearchKeyword", searchKeyword);
		
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

//		request.getRequestDispatcher("/WEB-INF/jsp/F-08/allInquiry.jsp").forward(request, response);
		pagingAndForward(request, response, rentalList, reserveList);

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
		List<RentalBean> rentalList = new ArrayList();
		List<ReserveBean> reserveList = new ArrayList();
		
		// IDが決まったら、そのユーザーのデータを各5件ずつ取得
		if (!userId.isEmpty()) {
			rentalList = dao.getUserRentals(userId);
			reserveList = dao.getUserReserves(userId);

//			request.setAttribute("rentalList", rentalList);
//			request.setAttribute("reserveList", reserveList);
		}
		session.setAttribute("sessionRentalList", rentalList);
		session.setAttribute("sessionReserveList", reserveList);
		// 画面上の「利用者ID」テキストボックスに渡す値をセット
		request.setAttribute("targetUserId", userId);

		// JSPへフォワード
//		request.getRequestDispatcher("/WEB-INF/jsp/F-08/allInquiry.jsp").forward(request, response);
		pagingAndForward(request, response, rentalList, reserveList);
	}
	private void pagingAndForward(HttpServletRequest request, HttpServletResponse response, 
			List<RentalBean> rentalList, List<ReserveBean> reserveList) throws ServletException, IOException {
		
		// 1. 現在のページ番号を取得 (リクエストになければ1ページ目とする)
		int currentPageRental = 1;
		int currentPageReserve = 1;
		String pageRen = request.getParameter("pageRental");
		String pageRes = request.getParameter("pageReserve");
		if (pageRen != null && !pageRen.isEmpty()) {
			try {
				currentPageRental = Integer.parseInt(pageRen);
			} catch (NumberFormatException e) {
				currentPageRental = 1;
			}
		}
		if (pageRes != null && !pageRes.isEmpty()) {
			try {
				currentPageReserve = Integer.parseInt(pageRes);
			} catch (NumberFormatException e) {
				currentPageReserve = 1;
			}
		}
		
		int pageSize = 5; // 1ページあたりの件数

		// --- 貸出状況 (rentalList) のページング処理 ---
		int totalRentals = (rentalList != null) ? rentalList.size() : 0;
		int maxPageRental = (int) Math.ceil((double) totalRentals / pageSize);
		if (maxPageRental == 0) maxPageRental = 1;
		
		if (currentPageRental > maxPageRental) currentPageRental = maxPageRental;
		if (currentPageRental < 1) currentPageRental = 1;

		int rentalFrom = (currentPageRental - 1) * pageSize;
		int rentalTo = Math.min(rentalFrom + pageSize, totalRentals);
		
		List<RentalBean> pagedRentalList = new ArrayList<>();
		if (rentalList != null && rentalFrom < totalRentals) {
			pagedRentalList = rentalList.subList(rentalFrom, rentalTo);
		}

		// --- 予約状況 (reserveList) のページング処理 ---
		int totalReserves = (reserveList != null) ? reserveList.size() : 0;
		int maxPageReserve = (int) Math.ceil((double) totalReserves / pageSize);
		if (maxPageReserve == 0) maxPageReserve = 1;
		
		if (currentPageReserve > maxPageReserve) currentPageReserve = maxPageReserve;
		if (currentPageReserve < 1) currentPageReserve = 1;

		int reserveFrom = (currentPageReserve - 1) * pageSize;
		int reserveTo = Math.min(reserveFrom + pageSize, totalReserves);
		
		List<ReserveBean> pagedReserveList = new ArrayList<>();
		if (reserveList != null && reserveFrom < totalReserves) {
			pagedReserveList = reserveList.subList(reserveFrom, reserveTo);
		}

		// 全体の最大ページ数を決定 (貸出か予約、どちらか大きい方)
//		int maxPage = Math.max(maxPageRental, maxPageReserve);

		// 2. 切り出した5件のデータと、ページ情報をリクエスト属性にセット
		request.setAttribute("rentalList", pagedRentalList);
		request.setAttribute("reserveList", pagedReserveList);
		request.setAttribute("currentPageRental", currentPageRental);
		request.setAttribute("currentPageReserve", currentPageReserve);
		request.setAttribute("maxPageRental", maxPageRental);
		request.setAttribute("maxPageReserve",maxPageReserve);

		// 3. JSPへフォワード
		request.getRequestDispatcher("/WEB-INF/jsp/F-08/allInquiry.jsp").forward(request, response);
	}
}