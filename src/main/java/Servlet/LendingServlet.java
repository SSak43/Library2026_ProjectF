package Servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import Dao.BooksSearchDAO;
import Dao.LendsDAO;
import Dao.UsersSearchDAO;
import Model.BooksBean;
import Model.LendsBean;
import Model.UsersBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/lending")
public class LendingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 各ボタン（表示、登録）や図書検索からの遷移を受け付ける
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeLending(request, response);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		executeLending(request, response);
	}

	private void executeLending(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		// 1. 画面から送られてきたパラメータを取得
		String action = request.getParameter("action"); // ボタンの識別（searchUser, searchBook, register）
		String userIdStr = request.getParameter("userId");
		String bookIdStr = request.getParameter("bookId");

		// メッセージ用変数
		String errorMessage = "";
		String successMessage = "";

		// 画面に表示する用のデータ箱
		UsersBean selectedUser = null;
		BooksBean selectedBook = null;
		int activeLendsCount = 0; // 現在の貸出数

		// 2. 【状態保持ロジック】すでにIDが存在していれば、DBから最新情報を引いてきて保持する
		// これにより、利用者検索をした時も図書情報が消えずに残ります
		if (userIdStr != null && !userIdStr.trim().isEmpty()) {
			try {
				int userId = Integer.parseInt(userIdStr);
				UsersSearchDAO userDAO = new UsersSearchDAO();
				UsersBean searchParam = new UsersBean();
				searchParam.setUserId(userId);
				
				List<UsersBean> userList = userDAO.findById(searchParam);
				if (userList != null && !userList.isEmpty()) {
					selectedUser = userList.get(0);
					// 現在借りている冊数をカウント
					LendsDAO lendsDAO = new LendsDAO();
					activeLendsCount = lendsDAO.countActiveLends(userId);
				} else if ("searchUser".equals(action)) {
					errorMessage = "該当する利用者が存在しません。";
				}
			} catch (NumberFormatException e) {
				if ("searchUser".equals(action)) errorMessage = "利用者IDは数字で入力してください。";
			}
		}

		if (bookIdStr != null && !bookIdStr.trim().isEmpty()) {
			try {
				int bookId = Integer.parseInt(bookIdStr);
				BooksSearchDAO bookDAO = new BooksSearchDAO();
				// 前回作成したsearchBooksを「図書IDの完全一致」として利用
				List<BooksBean> bookList = bookDAO.searchBooks("bookId", String.valueOf(bookId), 1);
				
				if (bookList != null && !bookList.isEmpty()) {
					selectedBook = bookList.get(0);
					
					// 「図書表示」ボタンを押した時だけ、貸出可能チェックを行う
					if ("searchBook".equals(action) && !"0".equals(selectedBook.getBookStatus())) {
						errorMessage = "この図書は現在貸出できません（貸出中または貸出不可）。";
						selectedBook = null; // 画面に表示させない
					}
				} else if ("searchBook".equals(action)) {
					errorMessage = "該当する図書が存在しません。";
				}
			} catch (NumberFormatException e) {
				if ("searchBook".equals(action)) errorMessage = "図書IDは数字で入力してください。";
			}
		}

		// 3. 「登録」ボタンが押されたときの貸出登録処理
		if ("register".equals(action)) {
			if (selectedUser == null) {
				errorMessage = "利用者を検索して確定させてください。";
			} else if (selectedBook == null) {
				errorMessage = "図書を検索して確定させてください。";
			} else {
				// 貸出データの作成
				LendsBean lend = new LendsBean();
				lend.setUserId(selectedUser.getUserId());
				lend.setBookId(selectedBook.getBookId());
				
				// 日付の計算（本日貸出、返却期限は14日後）
				LocalDate today = LocalDate.now();
				LocalDate returnLine = today.plusDays(14); // 2週間後
				
				lend.setLendDate(Date.valueOf(today));
				lend.setReturnLine(Date.valueOf(returnLine));
				lend.setLendRegist(Date.valueOf(today));
				lend.setLendUpdate(Date.valueOf(today));
				
				// データベースに登録
				LendsDAO lendsDAO = new LendsDAO();
				boolean isSuccess = lendsDAO.registerLend(lend);
				
				if (isSuccess) {
					successMessage = "貸出登録が完了しました！（返却期限: " + returnLine + "）";
					// 登録が成功したら、入力・選択状態をきれいにリセットする
					selectedUser = null;
					selectedBook = null;
					activeLendsCount = 0;
				} else {
					errorMessage = "貸出登録に失敗しました。システム管理者に連絡してください。";
				}
			}
		}

		// 4. JSP（画面）に表示データを送る
		request.setAttribute("selectedUser", selectedUser);
		request.setAttribute("selectedBook", selectedBook);
		request.setAttribute("activeLendsCount", activeLendsCount);
		request.setAttribute("errorMessage", errorMessage);
		request.setAttribute("successMessage", successMessage);

		// 5. 貸出画面（JSP）へ進む
		request.getRequestDispatcher("/lending.jsp").forward(request, response);
	}
}