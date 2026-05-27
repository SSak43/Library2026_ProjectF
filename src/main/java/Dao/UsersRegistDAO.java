package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;

public class UsersRegistDAO extends DAOBase {
	public List<UsersBean> add(UsersBean usersBean) {
		List<UsersBean> usersList = new ArrayList<>();

		LocalDate today = LocalDate.now();
		java.sql.Date sqlDate = java.sql.Date.valueOf(today);
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "INSERT INTO USERS (USER_NAME,TEL,PASSWORD,USER_CLASS,USER_STATUS,USER_REGIST,USER_UPDATE) VALUES(?,?,?,?,?,?,?,?)";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setString(1, usersBean.getUserName());
			pStmt.setString(2, usersBean.getTel());
			pStmt.setString(3, usersBean.getPassword());
			pStmt.setString(4, usersBean.getUserClass());
			pStmt.setString(5, usersBean.getUserStatus());
			pStmt.setDate(6, sqlDate);
			pStmt.setDate(7, sqlDate);
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
}