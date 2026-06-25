package f07_reserve.servlet;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import Model.BooksBean;
import Model.ReserveBean;
import Model.UsersBean;
import f02_user.dao.UsersSearchDAO;
import f04_book_search.dao.BooksSearchDAO;
import f07_reserve.dao.ReserveDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reserveBook")
public class ReserveServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeReserveProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeReserveProcess(request, response);
    }

    private void executeReserveProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        String bookIdStr = request.getParameter("bookId");

        String errorMessage = "";
        String successMessage = "";

        UsersBean selectedUser = null;
        BooksBean selectedBook = null;
        String displayBookStatus = "";
        int reserveCount = 0;

        // 利用者情報の検索・保持
        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdStr);
                UsersSearchDAO userDAO = new UsersSearchDAO();
                UsersBean searchParam = new UsersBean();
                searchParam.setUserId(userId);
                List<UsersBean> userList = userDAO.findById(searchParam);
                
                if (userList != null && !userList.isEmpty()) {
                    selectedUser = userList.get(0);
                } else if ("searchUser".equals(action)) {
                    errorMessage = "該当する利用者が存在しません。";
                }
            } catch (NumberFormatException e) {
                if ("searchUser".equals(action)) errorMessage = "利用者IDは数字で入力してください。";
            }
        }

     // 図書情報の検索・保持
        if (bookIdStr != null && !bookIdStr.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                BooksSearchDAO bookDAO = new BooksSearchDAO();
                List<BooksBean> bookList = bookDAO.searchBooks("bookId", String.valueOf(bookId), 1);
                
                if (bookList != null && !bookList.isEmpty()) {
                    selectedBook = bookList.get(0);
                    // 貸出状態を文字に変換して表示用に保持
                    switch(selectedBook.getBookStatus()) {
                        case "0": displayBookStatus = "貸出可能"; break;
                        case "1": displayBookStatus = "貸出中"; break;
                        case "2": displayBookStatus = "貸出不可"; break;
                    }
                    
                    // ReserveDAOを使って現在の予約数を取得する
                    ReserveDAO countDao = new ReserveDAO();
                    reserveCount = countDao.getReserveCountByBookId(selectedBook.getBookId());
                    
                } else if ("searchBook".equals(action)) {
                    errorMessage = "該当する図書が存在しません。";
                }
            } catch (NumberFormatException e) {
                if ("searchBook".equals(action)) errorMessage = "図書IDは数字で入力してください。";
            }
        }

        // 「登録」ボタンが押された時の処理
        if ("register".equals(action)) {
            if (selectedUser == null) {
                errorMessage = "利用者を検索して確定させてください。";
            } else if (selectedBook == null) {
                errorMessage = "図書を検索して確定させてください。";
            } else {
                ReserveDAO reserveDAO = new ReserveDAO();

                // 💡ここに追加：すでに予約済みかチェックする
                if (reserveDAO.checkDuplicateReserve(selectedUser.getUserId(), selectedBook.getBookId())) {
                    errorMessage = "すでにこの本は予約済みです。";
                } else {
                    // まだ予約していない場合のみ、登録処理へ進む
                    ReserveBean reserve = new ReserveBean();
                    Date today = Date.valueOf(LocalDate.now());
                    
                    reserve.setUserId(selectedUser.getUserId());
                    reserve.setBookId(selectedBook.getBookId());
                    reserve.setReserveDate(today);
                    // 現在の予約状況から「何番目か」を取得
                    reserve.setReserveNo(reserveDAO.getNextReserveNo(selectedBook.getBookId()));
                    reserve.setReserveStatus("0"); // 0:予約可能として登録
                    reserve.setReserveRegist(today);
                    reserve.setReserveUpdate(today);

                    if (reserveDAO.registerReserve(reserve)) {
                        successMessage = "予約登録が完了しました！（予約順: " + reserve.getReserveNo() + "番目）";
                        // 完了後は画面をリセット
                        selectedUser = null;
                        selectedBook = null;
                        displayBookStatus = "";
                    } else {
                        errorMessage = "予約登録に失敗しました。";
                    }
                }
            }
        }

        // JSPにデータを渡す
        request.setAttribute("selectedUser", selectedUser);
        request.setAttribute("selectedBook", selectedBook);
        request.setAttribute("displayBookStatus", displayBookStatus);
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("successMessage", successMessage);
        request.setAttribute("inputUserId", userIdStr);
        request.setAttribute("inputBookId", bookIdStr);
        request.setAttribute("reserveCount", reserveCount);

     
        request.getRequestDispatcher("/WEB-INF/jsp/F-07/reserve.jsp").forward(request, response);
    }
}