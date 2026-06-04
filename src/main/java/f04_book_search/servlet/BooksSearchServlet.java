package f04_book_search.servlet;

import java.io.IOException;
import java.util.List;

import Model.BooksBean;
import f04_book_search.dao.BooksSearchDAO;
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
		String pageStr = request.getParameter("page");

		// 初回アクセス時や、未入力時のデフォルト値を設定
		if (searchType == null || searchType.isEmpty()) {
			searchType = "all"; // デフォルトは「すべて」
		}
		if (keyword == null) {
			keyword = "";
		}

		// ページ番号の処理（指定がなければ1ページ目）
		int page = 1;
		if (pageStr != null && !pageStr.isEmpty()) {
			try {
				page = Integer.parseInt(pageStr);
			} catch (NumberFormatException e) {
				page = 1; // 数字以外が送られてきたら1ページ目にする
			}
		}

		// 2. DAOを使ってDBから図書リストを取得（1ページあたり最大10件）
		BooksSearchDAO dao = new BooksSearchDAO();
		List<BooksBean> bookList = dao.searchBooks(searchType, keyword, page);

		// 3. ページ送り（ページネーション）のための判定
		// 10件ぴったり取れた場合、次のページにもデータがある「可能性」がある
		boolean hasNextPage = (bookList.size() == 10);
		// 2ページ目以降なら「前へ」ボタンを表示できる
		boolean hasPrevPage = (page > 1);

		// 4. JSP（画面）に渡すデータを箱（request）に詰める
		request.setAttribute("bookList", bookList);       // 検索結果のリスト
		request.setAttribute("searchType", searchType);   // 選択されていたプルダウンの値
		request.setAttribute("keyword", keyword);         // 入力されていたキーワード
		request.setAttribute("currentPage", page);        // 現在のページ番号
		request.setAttribute("hasNextPage", hasNextPage); // 「次へ」ボタンを出すかどうかのフラグ
		request.setAttribute("hasPrevPage", hasPrevPage); // 「前へ」ボタンを出すかどうかのフラグ

		// 5. 検索画面（JSP）へ遷移して表示させる
		request.getRequestDispatcher("/WEB-INF/jsp/serach/serach.jsp").forward(request, response);
	}
}