package Servlet;

import java.io.IOException;
import java.time.LocalDate;

import Dao.LendsDAO;
import Model.LendsBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/returnBook")
public class ReturnServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeReturnProcess(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeReturnProcess(request, response);
	}

	private void executeReturnProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action"); // search または return
		String bookIdStr = request.getParameter("bookId");

		String errorMessage = "";
		String successMessage = "";
		LendsBean activeLend = null;

		LendsDAO dao = new LendsDAO();

		// 図書IDが入力されている場合の検索処理
		if (bookIdStr != null && !bookIdStr.trim().isEmpty()) {
			try {
				int bookId = Integer.parseInt(bookIdStr);
				activeLend = dao.findActiveLendByBookId(bookId);

				if (activeLend == null && "search".equals(action)) {
					errorMessage = "指定された図書IDは貸出中ではないか、存在しません。";
				}
			} catch (NumberFormatException e) {
				if ("search".equals(action)) errorMessage = "図書IDは数字で入力してください。";
			}
		}

		// 「登録（返却確定）」ボタンが押されたとき
		if ("return".equals(action)) {
			String lendIdStr = request.getParameter("lendId");
			if (lendIdStr != null && bookIdStr != null) {
				int lendId = Integer.parseInt(lendIdStr);
				int bookId = Integer.parseInt(bookIdStr);
				
				boolean isSuccess = dao.executeReturn(lendId, bookId);
				if (isSuccess) {
					successMessage = "返却登録が完了しました。";
					activeLend = null; // 終わったら画面をクリア
				} else {
					errorMessage = "返却処理に失敗しました。";
				}
			} else {
				errorMessage = "返却する対象が表示されていません。";
			}
		}

		// 画面へデータを渡す
		request.setAttribute("activeLend", activeLend);
		request.setAttribute("today", LocalDate.now()); // 返却日として今日の日付を渡す
		request.setAttribute("errorMessage", errorMessage);
		request.setAttribute("successMessage", successMessage);
		request.setAttribute("inputBookId", bookIdStr);

		request.getRequestDispatcher("/return.jsp").forward(request, response);
	}
}