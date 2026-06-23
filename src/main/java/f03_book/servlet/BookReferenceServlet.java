package f03_book.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import Model.BooksBean;
import f03_book.logic.BooksSearchLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class BookReferenceServlet
 */
@WebServlet("/BooksReferenceSearch")
public class BookReferenceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public BookReferenceServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String searchKey = request.getParameter("searchKey");

		BooksBean booksBean = new BooksBean();
		BooksSearchLogic logic = new BooksSearchLogic();
		List<BooksBean> booksList = null;
		
		if (searchKey != null && !searchKey.isEmpty()) {
			// 入力された文字が「すべて数字」ならID検索、それ以外なら書名検索
			if (searchKey.matches("^[0-9]+$")) {
				// 長すぎる数字（NumberFormatException）の発生を完全に防ぐ
				try {
					booksBean.setBookId(Integer.parseInt(searchKey));
					booksList = logic.id(booksBean);
				} catch (NumberFormatException e) {
					// 21億を超えるような長すぎる数字の時は、エラー画面にせず空のリストにする（安全対策）
					booksList = new ArrayList<>();
				}
			} else {
				// 書名としてセットしてロジックを呼び出す
				booksBean.setTitle(searchKey);
				booksList = logic.title(booksBean);
			}
		} else {
			// 何も入力されていない場合は、空のリスト（初期状態用）
			booksList = new ArrayList<>();
		}

		HttpSession session = request.getSession();
		session.setAttribute("booksList", booksList);
		
	
		RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/F-03/bookReference.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}