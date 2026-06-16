package f07_reserve.servlet;

import java.io.IOException;
import java.util.List;

import Model.ReserveBean;
import Model.UsersBean;
import f07_reserve.dao.ReserveSearchDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; 

@WebServlet("/reserveSearch")
public class ReserveSearchServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeProcess(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        executeProcess(request, response);
    }

    private void executeProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        ReserveSearchDAO dao = new ReserveSearchDAO();
        
        String successMessage = "";
        String errorMessage = "";

        // ① 取り消し処理
        if ("cancel".equals(action)) {
            String reserveIdStr = request.getParameter("cancelTargetId");
            if (reserveIdStr != null && !reserveIdStr.isEmpty()) {
                try {
                    int reserveId = Integer.parseInt(reserveIdStr);
                    if (dao.cancelReserve(reserveId)) {
                        successMessage = "予約の取り消しが完了しました。";
                    } else {
                        errorMessage = "予約の取り消しに失敗しました。";
                    }
                } catch (NumberFormatException e) {
                    errorMessage = "エラー：不正な予約IDです。";
                }
            }
        }

        // ② 検索条件の取得（新しいドロップダウン対応）
        HttpSession session = request.getSession();
        String searchType = request.getParameter("searchType");
        String searchKeyword = request.getParameter("searchKeyword");

        // 初回アクセス時の処理
        if (searchType == null && searchKeyword == null) {
            Object loginUserObj = session.getAttribute("loginUser");
            if (loginUserObj == null) loginUserObj = session.getAttribute("user"); 
            if (loginUserObj == null) loginUserObj = session.getAttribute("login"); 
            
            if (loginUserObj != null && loginUserObj instanceof UsersBean) {
                UsersBean loginUser = (UsersBean) loginUserObj;
                String uClass = loginUser.getUserClass();
                
                // 利用者(権限2)の場合は、検索項目を「利用者ID」、検索値を「自分のID」に初期セットする
                if ("利用者".equals(uClass) || "2".equals(uClass) || "user".equals(uClass) || uClass == null || uClass.isEmpty()) {
                    searchType = "userId";
                    searchKeyword = String.valueOf(loginUser.getUserId());
                } else {
                    searchType = "all";
                    searchKeyword = "";
                }
            } else {
                searchType = "all";
                searchKeyword = "";
            }
        }

        if (searchType == null) searchType = "all";
        if (searchKeyword == null) searchKeyword = "";

        // ③ ページ番号の処理
        String pageStr = request.getParameter("page");
        int page = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1; 
            }
        }

        // ④ DAOを使ってDBから予約リストを検索・取得
        List<ReserveBean> reserveList = dao.searchReserves(searchType, searchKeyword, page);

        // ⑤ ページ送り判定
        boolean hasNextPage = (reserveList.size() == 10);
        boolean hasPrevPage = (page > 1);

        if ("search".equals(action) && reserveList.isEmpty()) {
            errorMessage = "該当する予約情報が見つかりませんでした。";
        }

        // ⑥ JSPにデータを渡す
        request.setAttribute("searchType", searchType); 
        request.setAttribute("searchKeyword", searchKeyword); 
        request.setAttribute("reserveList", reserveList);
        request.setAttribute("currentPage", page);
        request.setAttribute("hasNextPage", hasNextPage);
        request.setAttribute("hasPrevPage", hasPrevPage);
        request.setAttribute("successMessage", successMessage);
        request.setAttribute("errorMessage", errorMessage);

        request.getRequestDispatcher("/WEB-INF/jsp/F-07/reserveSearch.jsp").forward(request, response);
    }
}