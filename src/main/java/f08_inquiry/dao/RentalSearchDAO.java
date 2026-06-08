package f08_inquiry.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Model.RentalBean;
import common.DAOBase; 

public class RentalSearchDAO extends DAOBase {

	public List<RentalBean> searchRentals(String category, String keyword) {
		List<RentalBean> list = new ArrayList<>();
	
		StringBuilder sql = new StringBuilder(
			"SELECT LPAD(L.BOOK_ID, 5, '0') AS BOOK_ID_STR, B.TITLE, " +
			"DATE_FORMAT(L.LEND_DATE, '%Y/%m/%d') AS LEND_DATE_STR, " +
			"DATE_FORMAT(L.RETURN_LINE, '%Y/%m/%d') AS RETURN_LINE_STR, " +
			"L.USER_ID " + 
			"FROM LENDS L JOIN BOOKS B ON L.BOOK_ID = B.BOOK_ID WHERE 1=1 "
		);

		if (keyword != null && !keyword.trim().isEmpty()) {
			switch (category) {
				case "bookId": sql.append("AND L.BOOK_ID LIKE ? "); break;
				case "title": sql.append("AND B.TITLE LIKE ? "); break;
				case "writerName": sql.append("AND B.WRITER_NAME LIKE ? "); break;
				case "company": sql.append("AND B.COMPANY LIKE ? "); break;
				case "bookClass": sql.append("AND B.BOOK_CLASS LIKE ? "); break;
				case "all":
				default:
					sql.append("AND (L.BOOK_ID LIKE ? OR B.TITLE LIKE ? OR B.WRITER_NAME LIKE ? OR B.COMPANY LIKE ? OR B.BOOK_CLASS LIKE ?) ");
					break;
			}
		}

		// 貸出日の早い順
		sql.append("ORDER BY L.LEND_DATE ASC");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
			 PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			if (keyword != null && !keyword.trim().isEmpty()) {
				String searchWord = "%" + keyword + "%";
				if ("all".equals(category)) {
					for(int i=1; i<=5; i++) ps.setString(i, searchWord);
				} else {
					ps.setString(1, searchWord);
				}
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					RentalBean bean = new RentalBean();
					bean.setBookId(rs.getString("BOOK_ID_STR"));
					bean.setTitle(rs.getString("TITLE"));
					bean.setLoanDate(rs.getString("LEND_DATE_STR"));
					bean.setReturnDeadline(rs.getString("RETURN_LINE_STR"));
					
		
					bean.setUserId(rs.getString("USER_ID"));
					
					list.add(bean);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
}