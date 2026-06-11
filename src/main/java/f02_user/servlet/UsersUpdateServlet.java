package f02_user.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;
import f02_user.logic.UsersUpdateLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class UsersUpdateServlet
 */
@WebServlet("/UsersUpdate")
public class UsersUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public UsersUpdateServlet() {
		super();
	}

	/**
	 * 初期表示 ＆ 利用者IDでの検索処理 (GET)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		// ⭕ パラメータ名を searchKey に統一して受け取る
		String searchKey = request.getParameter("searchKey");
		
		UsersBean usersBean = new UsersBean();
		UsersUpdateLogic logic = new UsersUpdateLogic();
		List<UsersBean> usersList = null;

		if (searchKey != null && !searchKey.isEmpty()) {
			// ⭕ 入力された文字が「すべて数字」ならID検索、それ以外なら氏名検索
			if (searchKey.matches("^[0-9]+$")) {
				usersBean.setUserId(Integer.parseInt(searchKey));
				usersList = logic.id(usersBean); // 既存のID検索メソッド
			} else {
				usersBean.setUserName(searchKey);
				usersList = logic.name(usersBean); // 下記②でLogicに追加するメソッド
			}
		} else {
			// 初期表示時（検索前）は空のリスト
			usersList = new ArrayList<>();
		}
		
		HttpSession session = request.getSession();
		session.setAttribute("usersList", usersList);
		
	
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/userUpdate.jsp");
		dispatcher.forward(request, response);
	}
	

	/**
	 *  更新実行処理 (POST)
	 */
	@SuppressWarnings("unchecked")
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		UsersUpdateLogic logic = new UsersUpdateLogic();
		
		// 画面からの入力データを受け取る
		String id = request.getParameter("userId");
		String cla = request.getParameter("cla");
		String name = request.getParameter("userName");
		String tel = request.getParameter("Tel");
		String pass = request.getParameter("Password");
		String status = request.getParameter("status");
		
		// 受け取ったデータをBeanにセット
		UsersBean usersBean = new UsersBean();
		int targetUserId = Integer.parseInt(id); // 更新対象の正しいID
		usersBean.setUserId(targetUserId);
		usersBean.setUserClass(cla);
		usersBean.setUserName(name);
		usersBean.setTel(tel);
		usersBean.setUserStatus(status);

		// パスワード欄が空欄の場合の処理
		if (pass == null || pass.isEmpty()) {
			HttpSession session = request.getSession();
			@SuppressWarnings("unchecked")
			List<UsersBean> usersList = (List<UsersBean>) session.getAttribute("usersList");
			
			String originalPassword = null;
			if (usersList != null) {
				// ⭕ セッション内のリストから、画面から送られてきた targetUserId と一致するBeanを正確に探す
				for (UsersBean u : usersList) {
					if (u.getUserId() == targetUserId) {
						originalPassword = u.getPassword();
						break;
					}
				}
			}
			
			// 万が一セッションから見つからない場合は、DAOを介してDBから最新のパスワードを取り直す（安全対策）
			if (originalPassword == null) {
				f02_user.dao.UsersSearchDAO searchDao = new f02_user.dao.UsersSearchDAO();
				UsersBean searchParam = new UsersBean();
				searchParam.setUserId(targetUserId);
				List<UsersBean> dbResult = searchDao.findById(searchParam);
				if (dbResult != null && !dbResult.isEmpty()) {
					originalPassword = dbResult.get(0).getPassword();
				}
			}
			
			usersBean.setPassword(originalPassword);
		} else {
			// 新しいパスワードが入力されている場合はハッシュ化してセット
			usersBean.setPassword(logic.hash(pass));
		}

		// データベースの更新を実行
		boolean isSuccess = logic.update(usersBean);
		request.setAttribute("isSuccess", isSuccess);

		if (!isSuccess) {
			request.setAttribute("errorMessage", "データベースの更新に失敗しました。");
		}
		
		// 更新後は、セッション情報を一度クリアするか、再取得してJSPへ戻す
		RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/F-02/userUpdate.jsp");
		dispatcher.forward(request, response);
	}
	}