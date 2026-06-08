package f08_inquiry.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.ReserveBean;
import common.DAOBase;

public class ReserveStatusInquiryDAO extends DAOBase {

	public List<ReserveBean> searchReserves(String category, String keyword) {
		List<ReserveBean> list = new ArrayList<>();
		
		// 基本となるテーブル結合SQL文
		StringBuilder sql = new StringBuilder(
			"SELECT R.BOOK_ID, B.TITLE, R.RESERVE_DATE, U.USER_NAME " +
			"FROM RESERVE R " +
			"JOIN BOOKS B ON R.BOOK_ID = B.BOOK_ID " +
			"JOIN USERS U ON R.USER_ID = U.USER_ID WHERE 1=1 "
		);

		boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
		String targetKeyword = hasKeyword ? keyword.trim() : "";

		// カテゴリーに応じてSQLのWHERE句を動的に追加
		if (hasKeyword) {
			switch (category) {
				case "bookId":
					sql.append("AND R.BOOK_ID = ? ");
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
				case "bookClass":
					sql.append("AND B.BOOK_CLASS LIKE ? ");
					break;
				case "userId":
					sql.append("AND R.USER_ID = ? ");
					break;
				case "all":
				default:
					sql.append("AND (R.BOOK_ID LIKE ? OR B.TITLE LIKE ? OR B.WRITER_NAME LIKE ? OR B.COMPANY LIKE ? OR R.USER_ID LIKE ?) ");
					break;
			}
		}

		sql.append("ORDER BY R.RESERVE_DATE ASC");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
			 PreparedStatement ps = conn.prepareStatement(sql.toString())) {

			// プレースホルダー (?) への値のセット
			if (hasKeyword) {
				if ("bookId".equals(category) || "userId".equals(category)) {
					try {
						ps.setInt(1, Integer.parseInt(targetKeyword));
					} catch (NumberFormatException e) {
						ps.setInt(1, -1); // 数値変換できない場合は該当なしにする
					}
				} else if ("all".equals(category)) {
					String likeStr = "%" + targetKeyword + "%";
					ps.setString(1, likeStr);
					ps.setString(2, likeStr);
					ps.setString(3, likeStr);
					ps.setString(4, likeStr);
					ps.setString(5, likeStr);
				} else {
					ps.setString(1, "%" + targetKeyword + "%");
				}
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					ReserveBean bean = new ReserveBean();
					bean.setBookId(rs.getInt("BOOK_ID"));
					bean.setTitle(rs.getString("TITLE"));
					bean.setReserveDate(rs.getDate("RESERVE_DATE"));
					bean.setUserName(rs.getString("USER_NAME"));
					list.add(bean);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
}