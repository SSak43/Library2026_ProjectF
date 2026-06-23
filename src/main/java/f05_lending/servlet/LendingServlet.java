package f05_lending.servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import Model.BooksBean;
import Model.LendsBean;
import Model.UsersBean;
import f02_user.dao.UsersSearchDAO;
import f03_book.dao.BooksSearchDAO;
import f05_lending.dao.LendsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/lending")
public class LendingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeLending(request, response);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeLending(request, response);
	}

	private void executeLending(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action"); 
		String userIdStr = request.getParameter("userId");
		String bookIdStr = request.getParameter("bookId");

		// 検索画面から遷移してきた場合、自動的に「図書の表示ボタン」が押されたのと同じ処理にする
		if ((action == null || action.isEmpty()) && bookIdStr != null) {
			action = "searchBook";
		}

		String errorMessage = "";
		String successMessage = "";

		UsersBean selectedUser = null;
		BooksBean selectedBook = null;
		int activeLendsCount = 0;

		// ==========================================
		// 1. 利用者情報の取得とバリデーション
		// ==========================================
		if (userIdStr != null && !userIdStr.isEmpty()) {
			try {
				int userId = Integer.parseInt(userIdStr);
				
				
				UsersBean searchUser = new UsersBean();
				searchUser.setUserId(userId);
				UsersSearchDAO userDAO = new UsersSearchDAO();
				List<UsersBean> userList = userDAO.findById(searchUser); // リストで受け取る

				if (userList != null && !userList.isEmpty()) {
					selectedUser = userList.get(0); // 1件目を取得
					
					// 貸出冊数の確認
					LendsDAO lendsDAO = new LendsDAO();
					activeLendsCount = lendsDAO.countActiveLends(userId);
					
					if ("searchUser".equals(action) && activeLendsCount >= 5) {
						errorMessage = "この利用者は既に5冊借りているため、新しく貸出できません。";
					}
				} else if ("searchUser".equals(action)) {
					errorMessage = "該当する利用者が見つかりません。";
				}
			} catch (NumberFormatException e) {
				if ("searchUser".equals(action)) {
					errorMessage = "利用者IDは数字で入力してください。";
				}
			}
		} else if ("searchUser".equals(action)) {
			errorMessage = "利用者IDを入力してください。";
		}

		// ==========================================
		// 2. 図書情報の取得とバリデーション
		// ==========================================
		if (bookIdStr != null && !bookIdStr.isEmpty()) {
			try {
				int bookId = Integer.parseInt(bookIdStr);
				
				BooksBean searchBook = new BooksBean();
				searchBook.setBookId(bookId);
				BooksSearchDAO booksDAO = new BooksSearchDAO();
				List<BooksBean> bookList = booksDAO.findById(searchBook); 

				if (bookList != null && !bookList.isEmpty()) {
					selectedBook = bookList.get(0); 

					// ⭕ 【修正ポイント】「図書の表示ボタン」を押した時だけでなく、
					// 貸出可能な図書が選ばれていれば「常に」日付を計算して維持する
					if (!"0".equals(selectedBook.getBookStatus())) {
						if ("searchBook".equals(action)) {
							errorMessage = "この図書は現在貸出できません。(貸出中または貸出不可)";
						}
						selectedBook = null;
					} else {
						// 常に14日後の返却期限を計算してJSPへ渡す
						LocalDate today = LocalDate.now();
						LocalDate returnLine = today.plusDays(14);
						request.setAttribute("returnLine", Date.valueOf(returnLine));
					}
					
				} else if ("searchBook".equals(action)) {
					errorMessage = "該当する図書が見つかりません。";
				}
			} catch (NumberFormatException e) {
				if ("searchBook".equals(action)) {
					errorMessage = "図書IDは数字で入力してください。";
				}
			}
		} else if ("searchBook".equals(action)) {
			errorMessage = "図書IDを入力してください。";
		}

		// ==========================================
		// 3. 確定登録時の最終バリデーション
		// ==========================================
		if ("register".equals(action)) {
			if (selectedUser == null) {
				errorMessage = "利用者を検索して確定させてください。";
			} else if (activeLendsCount >= 5) {
				errorMessage = "この利用者は既に5冊借りているため、新しく貸出できません。";
			} else if (selectedBook == null) {
				errorMessage = "図書を検索して確定させてください。";
			} else if (!"0".equals(selectedBook.getBookStatus())) {
				errorMessage = "この図書は現在貸出できません。";
			}
		}

		// ==========================================
		// 4. データベースへの登録処理
		// ==========================================
		if ("register".equals(action) && errorMessage.isEmpty()) {
			LendsBean lend = new LendsBean();
			lend.setUserId(selectedUser.getUserId());
			lend.setBookId(selectedBook.getBookId());

			LocalDate today = LocalDate.now();
			LocalDate returnLine = today.plusDays(14);

			lend.setLendDate(Date.valueOf(today));
			lend.setReturnLine(Date.valueOf(returnLine));
			lend.setLendRegist(Date.valueOf(today));
			lend.setLendUpdate(Date.valueOf(today));

			LendsDAO lendsDAO = new LendsDAO();
			boolean isSuccess = lendsDAO.registerLend(lend);

			if (isSuccess) {
				successMessage = "貸出登録が完了しました！（返却期限: " + returnLine + "）";
				// 登録成功後は画面をリセット
				selectedUser = null;
				selectedBook = null;
				activeLendsCount = 0;
			} else {
				errorMessage = "貸出登録に失敗しました。システム管理者に連絡してください。";
			}
		}

		// ==========================================
		// 5. 画面（JSP）へ引き渡すデータの格納と遷移
		// ==========================================
		request.setAttribute("selectedUser", selectedUser);
		request.setAttribute("selectedBook", selectedBook);
		request.setAttribute("activeLendsCount", activeLendsCount);
		request.setAttribute("errorMessage", errorMessage);
		request.setAttribute("successMessage", successMessage);

		
		request.getRequestDispatcher("/WEB-INF/jsp/F-05/lending.jsp").forward(request, response);
	}
}