package f02_user.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;
import common.DAOBase;

/**
 * USERSテーブル（利用者情報）に対する検索処理を担当するDAOクラス。
 * データベースへの接続やSQLの実行をここで行います。
 */
public class UsersSearchDAO extends DAOBase {

	/**
	 * 【全件検索】
	 * 登録されているすべての利用者情報を取得します。
	 * * @param usersBean 検索条件（このメソッドでは使用しませんが、他と形を合わせるために用意）
	 * @return 検索結果の利用者リスト（UsersBeanのリスト）
	 */
	public List<UsersBean> findByAll(UsersBean usersBean) {
		// 検索結果を格納するための空のリストを用意
		List<UsersBean> usersList = new ArrayList<>();
		
		// 1. データベース接続用ドライバの読み込み
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		// 2. データベースへの接続（DAOBaseで定義されたURL、ユーザー、パスワードを使用）
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			
			// 3. 実行するSQL文の準備（USERSテーブルの全レコードを取得）
			String sql = "SELECT * FROM USERS";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// 4. SQLの実行と結果の取得
			try (ResultSet rs = pStmt.executeQuery()) {
				
				// 取得したレコードの数だけループを回す
				while (rs.next()) {
					// 1レコード分の情報を格納するUsersBeanを作成
					UsersBean u = new UsersBean();
					
					// データベースから取得した値をBeanにセットしていく
					u.setUserId(rs.getInt("USER_ID"));
					u.setUserName(rs.getString("USER_NAME"));
					u.setTel(rs.getString("TEL"));
					u.setPassword(rs.getString("PASSWORD"));
					u.setUserClass(rs.getString("USER_CLASS"));
					u.setUserStatus(rs.getString("USER_STATUS"));
					u.setUserRegist(rs.getDate("USER_REGIST"));
					u.setUserUpdate(rs.getDate("USER_UPDATE"));
					
					// リストに追加する
					usersList.add(u);
				}
			}
		} catch (SQLException e) {
			// データベース接続やSQL実行でエラーが起きた場合は詳細を出力
			e.printStackTrace();
		}
		// 最終的なリストを返す
		return usersList;
	}

	/**
	 * 【区分（権限）検索】
	 * 利用者の区分（管理者、司書、一般利用者など）を指定して検索します。
	 * * @param usersBean 検索したい「区分（UserClass）」がセットされたBean
	 * @return 条件に一致した利用者リスト
	 */
	public List<UsersBean> findByClass(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// USER_CLASSが一致するレコードだけを取得するSQL
			String sql = "SELECT * FROM USERS WHERE USER_CLASS = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// ? の部分に、検索条件として渡された区分（UserClass）をセット
			pStmt.setString(1, usersBean.getUserClass());

			try (ResultSet rs = pStmt.executeQuery()) {
				while (rs.next()) {
					UsersBean u = new UsersBean();
					u.setUserId(rs.getInt("USER_ID"));
					u.setUserName(rs.getString("USER_NAME"));
					u.setTel(rs.getString("TEL"));
					u.setPassword(rs.getString("PASSWORD"));
					u.setUserClass(rs.getString("USER_CLASS"));
					u.setUserStatus(rs.getString("USER_STATUS"));
					u.setUserRegist(rs.getDate("USER_REGIST"));
					u.setUserUpdate(rs.getDate("USER_UPDATE"));
					usersList.add(u);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usersList;
	}

	/**
	 * 【氏名検索】
	 * 入力されたキーワードが「氏名」に含まれている利用者を検索します（部分一致検索）。
	 * * @param usersBean 検索したい「氏名（UserName）」がセットされたBean
	 * @return 条件に一致した利用者リスト
	 */
	public List<UsersBean> findByName(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// ⭕ 氏名の部分一致（LIKE）で検索するSQL
			String sql = "SELECT * FROM USERS WHERE USER_NAME LIKE ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// 前後に「%」をつけることで、「〜〜（入力文字）〜〜」を含むすべてのデータを対象にする
			pStmt.setString(1, "%" + usersBean.getUserName() + "%");
			
			try (ResultSet rs = pStmt.executeQuery()) {
				while (rs.next()) {
					UsersBean u = new UsersBean();
					u.setUserId(rs.getInt("USER_ID"));
					u.setUserName(rs.getString("USER_NAME"));
					u.setTel(rs.getString("TEL"));
					u.setPassword(rs.getString("PASSWORD"));
					u.setUserClass(rs.getString("USER_CLASS"));
					u.setUserStatus(rs.getString("USER_STATUS"));
					// （※このメソッドのみ登録日・更新日の取得処理が省かれています）
					usersList.add(u);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usersList;
	}

	/**
	 * 【ID検索】
	 * 利用者IDを指定して、特定の1人を検索します。
	 * （※戻り値はリスト形式ですが、基本的には1件だけ入る想定です）
	 * * @param usersBean 検索したい「利用者ID（UserId）」がセットされたBean
	 * @return 条件に一致した利用者リスト
	 */
	public List<UsersBean> findById(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// USER_IDが完全一致するレコードを取得するSQL
			String sql = "SELECT * FROM USERS WHERE USER_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// ? の部分に、検索条件として渡された利用者IDをセット
			pStmt.setInt(1, usersBean.getUserId());

			try (ResultSet rs = pStmt.executeQuery()) {
				while (rs.next()) {
					UsersBean u = new UsersBean();
					u.setUserId(rs.getInt("USER_ID"));
					u.setUserName(rs.getString("USER_NAME"));
					u.setTel(rs.getString("TEL"));
					u.setPassword(rs.getString("PASSWORD"));
					u.setUserClass(rs.getString("USER_CLASS"));
					u.setUserStatus(rs.getString("USER_STATUS"));
					u.setUserRegist(rs.getDate("USER_REGIST"));
					u.setUserUpdate(rs.getDate("USER_UPDATE"));
					usersList.add(u);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usersList;
	}
	
	/**
	 * 【ログイン認証用】
	 * 入力された利用者IDとパスワードの組み合わせが正しいか確認します。
	 * * @param userId 入力された利用者ID
	 * @param password 入力されたパスワード
	 * @return 認証成功時（一致するデータがあった場合）はUsersBean、失敗時はnull
	 */
	public UsersBean authenticate(int userId, String password) {
		UsersBean user = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// IDとパスワードが両方とも完全一致するユーザーを検索
			String sql = "SELECT * FROM USERS WHERE USER_ID = ? AND PASSWORD = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// 1つ目の?にID、2つ目の?にパスワードをセット
			pStmt.setInt(1, userId);
			pStmt.setString(2, password);

			try (ResultSet rs = pStmt.executeQuery()) {
				// ユーザーが見つかった場合のみ、Beansにデータをセットする（一致しなければ null のままになる）
				if (rs.next()) {
					user = new UsersBean();
					user.setUserId(rs.getInt("USER_ID"));
					user.setUserName(rs.getString("USER_NAME"));
					user.setTel(rs.getString("TEL"));
					user.setPassword(rs.getString("PASSWORD"));
					user.setUserClass(rs.getString("USER_CLASS")); // ロール（権限。管理者/司書/利用者など）
					user.setUserStatus(rs.getString("USER_STATUS")); // 利用状態（有効/無効など）
					user.setUserRegist(rs.getDate("USER_REGIST"));
					user.setUserUpdate(rs.getDate("USER_UPDATE"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user; // 見つかればBean、見つからなければnullが返る
	}
}