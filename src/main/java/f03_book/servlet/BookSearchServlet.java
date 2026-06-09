package f03_book.servlet;

import java.io.IOException;
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
 * Servlet implementation class BookSearchServlet
 */
@WebServlet("/BooksSearch")
public class BookSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	
	public BookSearchServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String id = request.getParameter("bookId");

		BooksBean booksBean = new BooksBean();
		BooksSearchLogic logic = new BooksSearchLogic();
		List<BooksBean> booksList = null;

		if (id != null && !id.isEmpty()) {
			//			try {
			booksBean.setBookId(Integer.parseInt(id));
			booksList = logic.id(booksBean);
			//			}
		}

		HttpSession session = request.getSession();
		session.setAttribute("booksList", booksList);
		RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/book/BooksSearch.jsp");
		dispatcher.forward(request,response);

	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
