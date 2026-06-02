package f06_return.servlet;

import java.io.IOException;
import java.util.List;

import Model.ReserveBean;
import f07_reserve.dao.ReserveSearchDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        String message = "";

        // 取り消し処理が呼ばれた場合
        if ("cancel".equals(action)) {
            String reserveIdStr = request.getParameter("cancelReserveId");
            if (reserveIdStr != null) {
                try {
                    int reserveId = Integer.parseInt(reserveIdStr);
                    if (dao.cancelReserve(reserveId)) {
                        message = "予約の取り消しが完了しました。";
                    } else {
                        message = "予約の取り消しに失敗しました。";
                    }
                } catch (NumberFormatException e) {
                    message = "エラー：不正な予約IDです。";
                }
            }
        }

        // 検索処理
        String searchCategory = request.getParameter("searchCategory");
        String searchKeyword = request.getParameter("searchKeyword");
        
        // 初回アクセス時はデフォルトで "all" をセット
        if (searchCategory == null) {
            searchCategory = "all";
            searchKeyword = "";
        }

        // DBから予約状況を取得（検索）
        List<ReserveBean> reserveList = dao.searchReserves(searchCategory, searchKeyword);

        if ("search".equals(action) && reserveList.isEmpty()) {
            message = "該当する予約情報が見つかりませんでした。";
        }

        // JSPへデータを渡す
        request.setAttribute("reserveList", reserveList);
        request.setAttribute("searchCategory", searchCategory);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("message", message);

        // JSPへフォワード
        request.getRequestDispatcher("/WEB-INF/jsp/reserve/reserveSearch.jsp").forward(request, response);
    }
}