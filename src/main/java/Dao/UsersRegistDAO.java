package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

import Model.UsersBean;

public class UsersRegistDAO extends DAOBase{
	public List<UsersBean> add(UsersBean usersBean){
		List<UsersBean> usersList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "INSERT INTO USERS (USER_NAME,TEL,LOGIN_ID,PASSWORD,USER_CLASS,USER_STATUS,USER_REGIST,USER_UPDATE) VALUES(?,?,?,?,?,?,?,?)";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setString(1, usersBean.getUserName());
			pStmt.setString(2,usersBean.getTel());
			pStmt.setString(3, sql);

	}
}
