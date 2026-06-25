package f09_over.servlet;

import java.io.IOException;
import java.util.List;

import Model.RentalBean;
import f09_over.dao.OverDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
		OverDAO dao = new OverDAO();
		List<RentalBean> rentalList = dao.searchOver("all", "");
		
		request.setAttribute("rentalList", rentalList);
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");
		
		request.getRequestDispatcher("/WEB-INF/jsp/F-09/overduelist.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String action = request.getParameter("action");
		String searchCategory = request.getParameter("searchCategory");
		String searchKeyword = request.getParameter("searchKeyword");

		if (searchCategory == null) searchCategory = "all";
		if (searchKeyword == null) searchKeyword = "";

		OverDAO dao = new OverDAO();
		List<RentalBean> rentalList = dao.searchOver(searchCategory, searchKeyword);

		// 画面に入力値を残すために再セット
		request.setAttribute("rentalList", rentalList);
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

		request.getRequestDispatcher("/WEB-INF/jsp/F-09/overduelist.jsp").forward(request, response);
	}

}
