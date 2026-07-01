package f02_user.dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;
import common.DAOBase;

/**
 * USERSテーブル（利用者情報）に対する更新処理（および特定のユーザー検索）を担当するDAOクラス。
 * データベースへの接続やSQLの実行をここで行います。
 */
public class UsersUpdateDAO extends DAOBase{
	
	/**
	 * 【ID検索】
	 * 更新対象となる特定の利用者IDを指定して、現在の登録情報を取得します。
	 * @param usersBean 検索したい「利用者ID（UserId）」がセットされたBean
	 * @return 条件に一致した利用者情報のリスト（基本的には1件だけ格納されます）
	 */
	public List<UsersBean> findById(UsersBean usersBean) {
		// 検索結果を格納するための空のリストを用意
		List<UsersBean> usersList = new ArrayList<>();
		
		// 1. データベース接続用ドライバの読み込み
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		// 2. データベースへの接続
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// USER_IDが完全一致するレコードを取得するSQL
			String sql = "SELECT * FROM USERS WHERE USER_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// ? の部分に、検索条件として渡された利用者IDをセット
			pStmt.setInt(1, usersBean.getUserId());

			// 3. SQLの実行と結果の取得
			try (ResultSet rs = pStmt.executeQuery()) {
				// 取得したレコードが存在する限りループしてBeanにセット
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
	 * 【情報更新】
	 * 入力された情報をもとに、指定された利用者の情報をデータベース上で上書き（UPDATE）します。
	 * @param usersBean 画面で入力された更新後の情報（氏名、電話番号など）が詰まったBean
	 * @return 更新が成功した場合は true、失敗した場合は false
	 */
	public boolean add(UsersBean usersBean) {
		// ※メソッド名は「add」ですが、SQL文の通り「更新（UPDATE）」の処理を行っています。

		// 更新日として、プログラムを実行した「現在の日付」を取得する準備
		LocalDate today = LocalDate.now();
		java.sql.Date sqlDate = java.sql.Date.valueOf(today);
		
		// 1. データベース接続用ドライバの読み込み
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		// 2. データベースへの接続
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// 3. 実行するSQL文の準備（指定されたUSER_IDの情報を一括で書き換える）
			String sql = "UPDATE USERS SET USER_NAME = ?,TEL = ?,PASSWORD = ?,USER_CLASS = ?,USER_STATUS = ?,USER_UPDATE = ? WHERE USER_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			
			// ? の部分に、Beanから取り出した新しい値を順番にセットしていく
			pStmt.setString(1, usersBean.getUserName());
			pStmt.setString(2, usersBean.getTel());
			pStmt.setString(3, usersBean.getPassword()); // （ハッシュ化済みのパスワードが入る想定）
			pStmt.setString(4, usersBean.getUserClass());
			pStmt.setString(5, usersBean.getUserStatus());
			pStmt.setDate(6, sqlDate); // 上で作成した「今日の日付」を更新日としてセット
			pStmt.setInt(7, usersBean.getUserId()); // どの利用者を更新するかの目印（WHERE条件用）

			// 4. SQLの実行（書き換えた行数が result に入る）
			int result = pStmt.executeUpdate();

			// 更新された行数が0より大きい（つまり1件以上更新された）なら成功として true を返す
			return result > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			// 万が一エラーが起きた場合は失敗として false を返す
			return false;
		}
	}

	/**
	 * 【パスワードの暗号化（ハッシュ化）】
	 * 入力されたパスワードの文字列を、データベースに保存するための安全な暗号（SHA-256形式）に変換します。
	 * @param password 画面で入力されたそのままのパスワード文字列
	 * @return 暗号化された64文字の文字列（エラー時は元の文字列を返します）
	 */
	public String hashPassword(String password) {
		// パスワードが空っぽの場合は何もせず空文字を返す
		if (password == null) {
			return "";
		}
		
		try {
			// SHA-256 という安全な規格を使ってハッシュ化（暗号化）の準備をする
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			
			// パスワードの文字列をコンピュータが扱いやすいバイトデータに変換し、暗号化を実行
			byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));

			// バイトデータを16進数（0〜9とa〜fの組み合わせ）の文字列に変換する
			StringBuilder sb = new StringBuilder();
			for (byte b : hash) {
				sb.append(String.format("%02x", b)); // 2桁ずつキレイに繋げる
			}
			// 最終的な暗号化された文字列（64文字）を返す
			return sb.toString(); 

		} catch (Exception e) {
			e.printStackTrace();
			// 何らかの理由で暗号化に失敗した場合は、万が一のために元のパスワードをそのまま返す
			return password;
		}
	}
} // クラスの閉じ括弧