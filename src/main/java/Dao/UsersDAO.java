package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;

public class UsersDAO extends DAOBase {
	public List<UsersBean> findByName(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			if (usersBean == null) {
				String sql = "SELECT * FROM USERS WHERE 1 = ?";
				PreparedStatement pStmt = conn.prepareStatement(sql);
				pStmt.setInt(1,1);
				
				try (ResultSet rs = pStmt.executeQuery()) {
					while (rs.next()) {
						UsersBean u = new UsersBean();
						u.setUserId(rs.getInt("USER_ID"));
						u.setUserName(rs.getString("USER_NAME"));
						u.setTel(rs.getString("TEL"));
						u.setLoginId(rs.getInt("LOGIN_ID"));
						u.setPassword(rs.getString("PASSWORD"));
						u.setUserClass(rs.getString("USER_CLASS"));
						u.setUserStatus(rs.getString("USRE_STATUS"));
						u.setUserRegist(rs.getDate("USER_REGIST"));
						u.setUserUpdate(rs.getDate("USER_UPDATE"));

					}
				}
			} else {
				String sql = "SELECT * FROM USERS WHERE NAME LIKE ?";
				PreparedStatement pStmt = conn.prepareStatement(sql);
				pStmt.setString(1, "%" + usersBean.getUserName() + "%");

				try (ResultSet rs = pStmt.executeQuery()) {
					while (rs.next()) {
						UsersBean u = new UsersBean();
						u.setUserId(rs.getInt("USER_ID"));
						u.setUserName(rs.getString("USER_NAME"));
						u.setTel(rs.getString("TEL"));
						u.setLoginId(rs.getInt("LOGIN_ID"));
						u.setPassword(rs.getString("PASSWORD"));
						u.setUserClass(rs.getString("USER_CLASS"));
						u.setUserStatus(rs.getString("USRE_STATUS"));
						u.setUserRegist(rs.getDate("USER_REGIST"));
						u.setUserUpdate(rs.getDate("USER_UPDATE"));

					}
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return usersList;
	}
}
