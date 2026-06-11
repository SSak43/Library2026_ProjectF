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

public class UsersSearchDAO extends DAOBase {

	public List<UsersBean> findByAll(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "SELECT * FROM USERS";
			PreparedStatement pStmt = conn.prepareStatement(sql);
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

	public List<UsersBean> findByClass(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "SELECT * FROM USERS WHERE USER_CLASS = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
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
					usersList.add(u);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usersList;
	}

	public List<UsersBean> findById(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "SELECT * FROM USERS WHERE USER_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
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
	 * ログイン認証用メソッド
	 * @param userId 入力された利用者ID
	 * @param password 入力されたパスワード
	 * @return 認証成功時はUsersBean、失敗時はnull
	 */
	public UsersBean authenticate(int userId, String password) {
		UsersBean user = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			// IDとパスワードが完全一致するユーザーを検索
			String sql = "SELECT * FROM USERS WHERE USER_ID = ? AND PASSWORD = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setInt(1, userId);
			pStmt.setString(2, password);

			try (ResultSet rs = pStmt.executeQuery()) {
				// ユーザーが見つかった場合のみ、Beansにデータをセットする
				if (rs.next()) {
					user = new UsersBean();
					user.setUserId(rs.getInt("USER_ID"));
					user.setUserName(rs.getString("USER_NAME"));
					user.setTel(rs.getString("TEL"));
					user.setPassword(rs.getString("PASSWORD"));
					user.setUserClass(rs.getString("USER_CLASS")); // ロール（権限）
					user.setUserStatus(rs.getString("USER_STATUS")); // 利用状態
					user.setUserRegist(rs.getDate("USER_REGIST"));
					user.setUserUpdate(rs.getDate("USER_UPDATE"));
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return user; // 見つからなければnullが返る
	}
}
