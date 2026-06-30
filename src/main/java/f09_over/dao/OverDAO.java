package f09_over.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Model.RentalBean;
import common.DAOBase;

public class OverDAO extends DAOBase {
	public List<RentalBean> searchOver(String category, String keyword) {
		List<RentalBean> list = new ArrayList<>();

		StringBuilder sql = new StringBuilder(
				"SELECT LPAD(L.BOOK_ID, 6, '0') AS BOOK_ID_STR, B.TITLE, " +
						"DATE_FORMAT(L.LEND_DATE, '%Y/%m/%d') AS LEND_DATE_STR, " +
						"DATE_FORMAT(L.RETURN_LINE, '%Y/%m/%d') AS RETURN_LINE_STR, " +
						"LPAD(L.USER_ID, 6, '0') AS USER_ID_STR, U.USER_NAME " +
						"FROM LENDS L " +
						"JOIN BOOKS B ON L.BOOK_ID = B.BOOK_ID " +
						"JOIN USERS U ON L.USER_ID = U.USER_ID " +
						"WHERE 1=1 AND L.RETURN_DATE IS NULL AND L.RETURN_LINE < CURRENT_DATE ");
		if (keyword != null && !keyword.trim().isEmpty()) {
			switch (category) {
			case "bookId":
				sql.append("AND LPAD(L.BOOK_ID, 6, '0') LIKE ? ");
				break;
			case "title":
				sql.append("AND B.TITLE LIKE ? ");
				break;
			case "writerName":
				sql.append("AND B.WRITER_NAME LIKE ? ");
				break;
			case "company":
				sql.append("AND B.COMPANY LIKE ? ");
				break;
			case "userId":
				sql.append("AND LPAD(L.USER_ID, 6, '0') LIKE ? ");
				break;
			case "name":
				sql.append("AND U.USER_NAME LIKE ? ");
				break;
			case "bookClass":
				sql.append("AND B.BOOK_CLASS LIKE ? ");
				break;
			case "all":
			default:
				sql.append(
						"AND (LPAD(L.BOOK_ID, 6, '0') LIKE ? OR B.TITLE LIKE ? OR B.WRITER_NAME LIKE ? OR B.COMPANY LIKE ? OR B.BOOK_CLASS LIKE ? OR LPAD(L.USER_ID, 6, '0') LIKE ? OR U.USER_NAME LIKE ?) ");
				break;
			}
		}
		
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
						for(int i=1; i<=7; i++) ps.setString(i, searchWord);
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

						bean.setUserId(rs.getString("USER_ID_STR"));
						bean.setUserName(rs.getString("USER_NAME"));
						
						list.add(bean);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

			return list;
		}
}