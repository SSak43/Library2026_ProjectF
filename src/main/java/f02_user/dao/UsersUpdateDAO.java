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

public class UsersUpdateDAO extends DAOBase{
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
public boolean add(UsersBean usersBean) {
		//		List<UsersBean> usersList = new ArrayList<>();

		LocalDate today = LocalDate.now();
		java.sql.Date sqlDate = java.sql.Date.valueOf(today);
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "UPDATE USERS SET USER_NAME = ?,TEL = ?,PASSWORD = ?,USER_CLASS = ?,USER_STATUS = ?,USER_UPDATE = ? WHERE USER_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setString(1, usersBean.getUserName());
			pStmt.setString(2, usersBean.getTel());
			pStmt.setString(3, hashPassword(usersBean.getPassword()));
			pStmt.setString(4, usersBean.getUserClass());
			pStmt.setString(5, usersBean.getUserStatus());
			pStmt.setDate(6, sqlDate);
			pStmt.setInt(7, usersBean.getUserId());

			int result = pStmt.executeUpdate();

			return result > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// ★クラスの末尾などに追加するハッシュ化メソッド
	private String hashPassword(String password) {
		if (password == null) {
			return "";
		}
		try {
			// SHA-256 という安全な規格を使ってハッシュ化を準備
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));

			// バイトデータを16進数の文字列に変換する
			StringBuilder sb = new StringBuilder();
			for (byte b : hash) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString(); // 64文字の暗号化された文字列が返ります

		} catch (Exception e) {
			e.printStackTrace();
			return password;
		}
	}
} // クラスの閉じ括弧
