package f03_book.servlet;

import java.io.IOException;

import Model.BooksBean;
import f03_book.logic.BooksRegistLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class BooksRegistServlet
 */
@WebServlet("/BooksRegist")
public class BooksRegistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BooksRegistServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. Logicを呼び出して最新のIDを取得する
		BooksRegistLogic logic = new BooksRegistLogic();
		int latestId = logic.getLatestId();

		// 2. 取得したIDを request にセットしてJSPに渡す
		request.setAttribute("latestId", latestId);

		// 3. 登録画面（JSP）へフォワード
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-03/book_register.jsp");
		dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 入力データ受け取る
		String title = request.getParameter("title");
		String name = request.getParameter("writerName");
		String company = request.getParameter("company");
		String cla = request.getParameter("cla");
		//　受け取ったデータをセット
		BooksBean booksBean = new BooksBean();
		booksBean.setTitle(title);
		booksBean.setWriterName(name);
		booksBean.setCompany(company);
		booksBean.setBookClass(cla);

		//データベースへ登録
		BooksRegistLogic logic = new BooksRegistLogic();
		boolean isSuccess = logic.add(booksBean);

		int latestId = logic.getLatestId();
		
		request.setAttribute("latestId", latestId);
		request.setAttribute("isSuccess",isSuccess);
		
		
		if (!isSuccess) {
		    request.setAttribute("errorMessage", "登録に失敗しました。システム管理者にお問い合わせください。");
		} else {
		    
			request.setAttribute("registeredBookId", latestId);
		}
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-03/book_register.jsp");
		dispatcher.forward(request, response);
	}


}
