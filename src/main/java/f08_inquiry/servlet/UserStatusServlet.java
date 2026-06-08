package f08_inquiry.servlet;

import java.io.IOException;
import java.util.List;

import Model.RentalBean;
import Model.ReserveBean;
import f08_inquiry.dao.UserStatusDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/userStatus")
public class UserStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		execute(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		execute(request, response);
	}
	
	private void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		// ① まず詳細ボタンや検索バーから送られてきた「userId」を取得する
		String userId = request.getParameter("userId");
		
		// ② もし上の「userId」が空っぽだった場合のみ、バックアップとしてログイン情報等から取得する
		if (userId == null || userId.trim().isEmpty()) {
			HttpSession session = request.getSession();
			// ※セッションに保存されているログインユーザーIDの属性名（"userId" や "loginUser" など）に合わせてください
			userId = (String) session.getAttribute("userId"); 
		}
		
		// ③ それでも空（初回直接アクセスなど）の場合は空文字にする
		if (userId == null) {
			userId = "";
		}
		
		UserStatusDAO dao = new UserStatusDAO();
		
		// IDが決まったら、そのユーザーのデータを各5件ずつ取得
		if (!userId.isEmpty()) {
			List<RentalBean> rentalList = dao.getUserRentals(userId);
			List<ReserveBean> reserveList = dao.getUserReserves(userId);
			
			request.setAttribute("rentalList", rentalList);
			request.setAttribute("reserveList", reserveList);
		}
		
		// 画面上の「利用者ID」テキストボックスに渡す値をセット
		request.setAttribute("targetUserId", userId);
		
		// JSPへフォワード
		request.getRequestDispatcher("/WEB-INF/jsp/f08_rentalSearch/userStatus.jsp").forward(request, response);
	}
}