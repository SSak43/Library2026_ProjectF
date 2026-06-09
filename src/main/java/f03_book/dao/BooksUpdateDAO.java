package f03_book.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import Model.BooksBean;
import common.DAOBase;

public class BooksUpdateDAO extends DAOBase{
	public List<BooksBean> findById(BooksBean booksBean){
		List<BooksBean> booksList = new ArrayList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
			String sql = "SELECT * FROM BOOKS WHERE BOOK_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setInt(1, booksBean.getBookId());
			
			try(ResultSet rs = pStmt.executeQuery()){
				while(rs.next()) {
					BooksBean b = new BooksBean();
					b.setBookId(rs.getInt("BOOK_ID"));
					b.setTitle(rs.getString("TITLE"));
					b.setWriterName(rs.getString("WRITER_NAME"));
					b.setCompany(rs.getString("COMPANY"));
					b.setBookClass(rs.getString("BOOK_CLASS"));
					b.setBookStatus(rs.getString("BOOK_STATUS"));
					b.setBookRegist(rs.getDate("BOOK_REGIST"));
					b.setBookUpdate(rs.getDate("BOOK_UPDATE"));
					booksList.add(b);
				}
			}
			
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return booksList;
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
			String sql = "UPDATE BOOKS SET TITLE = ?,WRITER_NAME = ?,COMPANY = ?,BOOK_CLASS = ?,BOOK_STATUS = ?,BOOK_UPDATE = ? WHERE BOOK_ID = ?";
			PreparedStatement pStmt = conn.prepareStatement(sql);
			pStmt.setString(1, booksBean.getTitle());
			pStmt.setString(2, booksBean.getWriterName());
			pStmt.setString(3, booksBean.getCompany());
			pStmt.setString(4, booksBean.getBookClass());
			pStmt.setString(5, booksBean.getBookStatus());
			pStmt.setDate(6, sqlDate);
			pStmt.setInt(7, booksBean.getBookId());

			int result = pStmt.executeUpdate();
			return result > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}
