package f08_inquiry.servlet;

import java.io.IOException;
import java.util.List;

import Model.ReserveBean;
import f08_inquiry.dao.ReserveStatusInquiryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reserveStatusInquiry")
public class ReserveStatusInquiryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ReserveStatusInquiryDAO dao = new ReserveStatusInquiryDAO();
		// 初期表示は全件表示
		List<ReserveBean> reserveList = dao.searchReserves("all", "");

		request.setAttribute("reserveList", reserveList);
		request.setAttribute("searchCategory", "all");
		request.setAttribute("searchKeyword", "");

		request.getRequestDispatcher("/WEB-INF/jsp/f08_rentalSearch/reserveStatusInquiry.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String searchCategory = request.getParameter("searchCategory");
		String searchKeyword = request.getParameter("searchKeyword");
		
		if (searchCategory == null) searchCategory = "all";
		if (searchKeyword == null) searchKeyword = "";

		ReserveStatusInquiryDAO dao = new ReserveStatusInquiryDAO();
		List<ReserveBean> reserveList = dao.searchReserves(searchCategory, searchKeyword);

		request.setAttribute("reserveList", reserveList);
		request.setAttribute("searchCategory", searchCategory);
		request.setAttribute("searchKeyword", searchKeyword);

		request.getRequestDispatcher("/WEB-INF/jsp/f08_rentalSearch/reserveStatusInquiry.jsp").forward(request, response);
	}
}