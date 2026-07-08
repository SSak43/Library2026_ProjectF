package f04_book_search.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import Model.BooksBean;
import f04_book_search.dao.BooksSearchDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/booksSearch")
public class BooksSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// リンクから飛んできた時（ページ送りの「次へ」を押した時など）
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeSearch(request, response);
	}

	// 検索ボタンを押した時
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeSearch(request, response);
	}

	// GETでもPOSTでも同じ検索処理を行うための共通メソッド
	private void executeSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 画面から検索条件を受け取る
		String searchType = request.getParameter("searchType");
		String keyword = request.getParameter("keyword");
//		String pageStr = request.getParameter("page");

		// 初回アクセス時や、未入力時のデフォルト値を設定
		if (searchType == null || searchType.isEmpty()) {
			searchType = "all"; // デフォルトは「すべて」
		}
		if (keyword == null) {
			keyword = "";
		}

		// ページ番号の処理（指定がなければ1ページ目）
//		int page = 1;
//		if (pageStr != null && !pageStr.isEmpty()) {
//			try {
//				page = Integer.parseInt(pageStr);
//			} catch (NumberFormatException e) {
//				page = 1; // 数字以外が送られてきたら1ページ目にする
//			}
//		}

		int currentPage = 1;
		String pageParam = request.getParameter("page");
		if(pageParam != null && !pageParam.isEmpty()) {
			try {
				currentPage = Integer.parseInt(pageParam);
			}catch(NumberFormatException e) {
				currentPage = 1;
			}
		}
		
		// 2. DAOを使ってDBから図書リストを取得
		BooksSearchDAO dao = new BooksSearchDAO();
		List<BooksBean> bookList = dao.searchBooks(searchType, keyword);

		//ページング処理
		int pageSize = 10;
		
		int totalBooks = (bookList != null) ? bookList.size() : 0;
		int maxPageBook = (int) Math.ceil ((double) totalBooks / pageSize);
		if(maxPageBook == 0) maxPageBook = 1;
		
		int bookFrom = (currentPage - 1) * pageSize;
		int bookTo = Math.min(bookFrom + pageSize, totalBooks);
		
		List<BooksBean> pagedBookList = new ArrayList<>();
		if(bookList != null && bookFrom < totalBooks) {
			pagedBookList = bookList.subList(bookFrom, bookTo);
		}
		
		// 4. JSP（画面）に渡すデータを箱（request）に詰める
		request.setAttribute("bookList", pagedBookList);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("maxPage", maxPageBook);
		request.setAttribute("searchType", searchType);
		request.setAttribute("keyword", keyword);

		// 💡 ここから下を追加・確認
		// JSPへ画面をフォワード（移動）させる（JSPのファイル名やフォルダの場所は環境に合わせてください！）
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F04_serch/serach.jsp");
		dispatcher.forward(request, response);
	}
}