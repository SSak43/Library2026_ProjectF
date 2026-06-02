package f02_user.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import Model.UsersBean;
import common.DAOBase;

public class UsersRegistDAO extends DAOBase {
	public int getMaxUserId() {
	    int maxId = 0;
	    
	    // ※テーブル名（users）やカラム名（user_id）は、ご自身のデータベースに合わせてください

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
		    String sql = "SELECT MAX(USER_ID) AS max_id FROM users"; 
		    PreparedStatement pStmt = conn.prepareStatement(sql);
	         ResultSet rs = pStmt.executeQuery();
	        
	        if (rs.next()) {
	            // AS でつけた max_id という名前で結果を取り出す
	            maxId = rs.getInt("max_id");
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return maxId;
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
			String sql = "INSERT INTO USERS (USER_NAME,TEL,PASSWORD,USER_CLASS,USER_STATUS,USER_REGIST,USER_UPDATE) VALUES(?,?,?,?,?,?,?)";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setString(1, usersBean.getUserName());
			pStmt.setString(2, usersBean.getTel());
			pStmt.setString(3, usersBean.getPassword());
			pStmt.setString(4, usersBean.getUserClass());
			pStmt.setString(5, "0");
			pStmt.setDate(6, sqlDate);
			pStmt.setDate(7, sqlDate);
			
			int result = pStmt.executeUpdate();
			
			return result > 0;
			
//			try (ResultSet rs = pStmt.executeQuery()) {
//				while (rs.next()) {
//					UsersBean u = new UsersBean();
//					u.setUserId(rs.getInt("USER_ID"));
//					u.setUserName(rs.getString("USER_NAME"));
//					u.setTel(rs.getString("TEL"));
//					u.setPassword(rs.getString("PASSWORD"));
//					u.setUserClass(rs.getString("USER_CLASS"));
//					u.setUserStatus(rs.getString("USER_STATUS"));
//					u.setUserRegist(rs.getDate("USER_REGIST"));
//					u.setUserUpdate(rs.getDate("USER_UPDATE"));
//					usersList.add(u);
//				}
//
//			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}