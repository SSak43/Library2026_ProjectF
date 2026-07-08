package f08_inquiry.servlet;

import java.io.IOException;
import java.util.ArrayList;
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
		//役職判定。取得できなければ役職の初期値は2(=利用者)		
		if(userObj != null) {
			usersBean = (UsersBean) userObj;
			String userClass = usersBean.getUserClass();
			if(userClass != null && !userClass.isEmpty()) {
				roleType = Integer.parseInt(userClass);
			}
		}
		
		ReserveStatusInquiryDAO dao = new ReserveStatusInquiryDAO();
		List<ReserveBean> reserveList = null;

		if (request.getParameter("page") != null) {
			reserveList = (List<ReserveBean>) session.getAttribute("sessionReserveList");
			
			// 検索キーワードなどもセッションから復元して入力欄を維持する
			request.setAttribute("searchCategory", session.getAttribute("sessionSearchCategory"));
			request.setAttribute("searchKeyword", session.getAttribute("sessionSearchKeyword"));
		} 
		// 初期表示の場合
		else {
			if (roleType != 2) {
			    // 管理者は全ユーザーのデータを検索
			   reserveList = dao.searchReserves("all","");
			} else {
			    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
			    int userId = usersBean.getUserId(); 
			   reserveList = dao.searchReservesByUserId(userId,"all","");
			}
			request.setAttribute("searchCategory", "all");
			request.setAttribute("searchKeyword", "");
		}
		session.setAttribute("sessionReserveList", reserveList);
		
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");

		
		pagingAndForward(request,response, reserveList);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		Object userObj = session.getAttribute("loginUser");
		
		UsersBean usersBean = null;
		int roleType = 2;
		//役職判定。取得できなければ役職の初期値は2(=利用者)
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
		
		if(searchCategory == null) searchCategory = "all";
		if(searchKeyword == null) searchKeyword = "";
		
		if (roleType != 2) {
		    // 管理者は全ユーザーのデータを検索
		   reserveList = dao.searchReserves(searchCategory, searchKeyword);
		} else {
		    // 一般ユーザーは自分のログインIDに紐づくデータだけ検索
		    int userId = usersBean.getUserId(); 
		   reserveList = dao.searchReservesByUserId(userId,searchCategory, searchKeyword);
		}	

		
		session.setAttribute("sessionReserveList", reserveList);
		session.setAttribute("sessionSearchCategory", searchCategory);
		session.setAttribute("sessionSearchKeyword", searchKeyword);

		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

		pagingAndForward(request, response, reserveList);
	}
	private void pagingAndForward(HttpServletRequest request, HttpServletResponse response, 
			List<ReserveBean> reserveList) throws ServletException, IOException {
		
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

		// --- 予約状況 (reserveList) のページング処理 ---
		int totalReserves = (reserveList != null) ? reserveList.size() : 0;
		int maxPageReserve = (int) Math.ceil((double) totalReserves / pageSize);
		if (maxPageReserve == 0) maxPageReserve = 1;

		int reserveFrom = (currentPage - 1) * pageSize;
		int reserveTo = Math.min(reserveFrom + pageSize, totalReserves);
		
		List<ReserveBean> pagedReserveList = new ArrayList<>();
		if (reserveList != null && reserveFrom <= totalReserves) {
			pagedReserveList = reserveList.subList(reserveFrom, reserveTo);
		}

		int maxPage = maxPageReserve;

		// 2. 切り出した5件のデータと、ページ情報をリクエスト属性にセット
		request.setAttribute("reserveList", pagedReserveList);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("maxPage", maxPage);

		// 3. JSPへフォワード
		request.getRequestDispatcher("/WEB-INF/jsp/F-08/reserveInquiry.jsp").forward(request, response);
	}
}