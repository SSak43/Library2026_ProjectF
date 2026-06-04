package f03_book.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import Model.BooksBean;
import common.DAOBase;

public class BooksRegistDAO extends DAOBase {
	
	public int getMaxBookId() {
	    int maxId = 0;
	    
	    // ※テーブル名（users）やカラム名（user_id）は、ご自身のデータベースに合わせてください

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
		    String sql = "SELECT MAX(BOOK_ID) AS max_id FROM books"; 
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

	
	
	public boolean add(BooksBean booksBean) {
		//		List<UsersBean> usersList = new ArrayList<>();

		LocalDate today = LocalDate.now();
		java.sql.Date sqlDate = java.sql.Date.valueOf(today);
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "INSERT INTO BOOKS (TITLE,WRITER_NAME,COMPANY,BOOK_CLASS,BOOK_STATUS,BOOK_REGIST_BOOK_UPDATE) VALUES(?,?,?,?,?,?,?)";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setString(1, booksBean.getTitle());
			pStmt.setString(2, booksBean.getWriterName());
			pStmt.setString(3, booksBean.getCompany());
			pStmt.setString(4, booksBean.getBookClass());
			pStmt.setString(5, booksBean.getBookStatus());
			pStmt.setDate(6, sqlDate);
			pStmt.setDate(7, sqlDate);

			int result = pStmt.executeUpdate();
			return result > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}
