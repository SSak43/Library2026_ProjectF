package f02_user.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;
import f02_user.logic.UsersSearchLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UsersSearchServlet
 */
@WebServlet("/UsersSearch")
public class UsersSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UsersSearchServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		// ⭕ 画面の入力欄（name="searchKey"）から値を受け取る
		String searchKey = request.getParameter("searchKey");
		
		UsersBean usersBean = new UsersBean();
		UsersSearchLogic logic = new UsersSearchLogic();
		List<UsersBean> usersList = null;

		if (searchKey != null && !searchKey.isEmpty()) {
			// 入力された文字が「すべて数字」ならID検索、それ以外なら氏名検索
			if (searchKey.matches("^[0-9]+$")) {
				usersBean.setUserId(Integer.parseInt(searchKey));
				usersList = logic.id(usersBean);
			} else {
				// ⭕ 氏名としてセットしてロジックを呼び出す
				usersBean.setUserName(searchKey);
				usersList = logic.name(usersBean); // ②でこのメソッドを有効化します
			}
		} else {
			// 何も入力されていない場合は、全件ではなく空のリスト（初期状態用）
			usersList = new ArrayList<>();
		}
	
		
//		if(id == null || name == null || name.isEmpty()) {
//			usersBean.setUserName(name);
//			usersList = logic.all(usersBean);
//		}else if("userName".equals(name)) {
//			usersBean.setUserName(name);
//			usersList = logic.name(usersBean);
//		}else if("userName".equals(id)) {
//			usersBean.setUserId(Integer.parseInt(id));
//			usersList = logic.id(usersBean);
//		}
		
		HttpSession session = request.getSession();
		session.setAttribute("usersList", usersList);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/userReference.jsp");
		dispatcher.forward(request, response);
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
