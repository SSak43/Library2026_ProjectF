package f03_book.servlet;

import java.io.IOException;
import java.util.List;

import Model.BooksBean;
import f03_book.logic.BooksSearchLogic;
import f03_book.logic.BooksUpdateLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class BooksUpdateServlet
 */
@WebServlet("/BooksUpdate")
public class BooksUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BooksUpdateServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
		RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/book/BooksUpdate.jsp");
		dispatcher.forward(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 入力データ受け取る
		String id = request.getParameter("bookId");
		String title = request.getParameter("title");
		String name = request.getParameter("writerName");
		String company = request.getParameter("company");
		String cla = request.getParameter("cla");
		String status = request.getParameter("status");
		
		//　受け取ったデータをセット
		BooksBean booksBean = new BooksBean();
		booksBean.setBookId(Integer.parseInt(id));
		booksBean.setTitle(title);
		booksBean.setWriterName(name);
		booksBean.setCompany(company);
		booksBean.setBookClass(cla);
		booksBean.setBookStatus(status);

		//データベースへ登録
		BooksUpdateLogic logic = new BooksUpdateLogic();
		boolean Add = logic.update(booksBean);

		if (Add) {
			response.sendRedirect("/Library2026_ProjectF/BooksMain");
		} else {
			request.setAttribute("errorMsg", "登録に失敗しました");
		}

	}

}
