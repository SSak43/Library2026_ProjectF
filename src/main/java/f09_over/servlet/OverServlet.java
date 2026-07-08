package f09_over.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import Model.RentalBean;
import f09_over.dao.OverDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class OverServlet
 */
@WebServlet("/Over")
public class OverServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OverServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session = request.getSession();
		OverDAO dao = new OverDAO();
		List<RentalBean> rentalList = dao.searchOver("all", "");		//ページを開いた最初は全検索
		
		session.setAttribute("sessionReserveList", rentalList);
		
		request.setAttribute("rentalList", rentalList);					//検索結果をrentalListへ当てはめる
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");
		
		pagingAndForward(request,response, rentalList);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		
		String searchCategory = request.getParameter("searchCategory");	//カテゴリーを取得
		String searchKeyword = request.getParameter("searchKeyword");	//キーワードを取得

		if (searchCategory == null) searchCategory = "all";				//カテゴリーがもし取得できなければすべて
		if (searchKeyword == null) searchKeyword = "";					//キーワードが取得できなければ空白

		OverDAO dao = new OverDAO();
		List<RentalBean> rentalList = dao.searchOver(searchCategory, searchKeyword);	//daoでカテゴリーとキーワードを引数に探す
		
		session.setAttribute("sessionReserveList", rentalList);
		session.setAttribute("sessionSearchCategory", searchCategory);
		session.setAttribute("sessionSearchKeyword", searchKeyword);
		// 画面に入力値を残すために再セット
		request.setAttribute("rentalList", rentalList);
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

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
		request.getRequestDispatcher("/WEB-INF/jsp/F-09/overduelist.jsp").forward(request, response);
	}
}
