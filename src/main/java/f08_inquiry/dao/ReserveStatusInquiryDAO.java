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
				"SELECT R.BOOK_ID, B.TITLE, R.RESERVE_DATE, U.USER_NAME, U.USER_ID " +
						"FROM RESERVE R " +
						"JOIN BOOKS B ON R.BOOK_ID = B.BOOK_ID " +
						"JOIN USERS U ON R.USER_ID = U.USER_ID WHERE 1=1 ");

		boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
		String targetKeyword = hasKeyword ? keyword.trim() : "";

		boolean isAllSearch = false;
		// カテゴリーに応じてSQLのWHERE句を動的に追加
		if (hasKeyword) {
			switch (category) {
			case "bookId":
				sql.append("AND R.BOOK_ID = ? ");
				break;
			case "title":
				sql.append("AND B.TITLE LIKE ? ");
				break;
			case "userId":
				sql.append("AND R.USER_ID = ? ");
				break;
			case "userName":
				sql.append("AND U.USER_NAME LIKE ? ");
				break;
			case "all":
			default:
				sql.append("AND (LPAD(R.BOOK_ID, 6, '0') LIKE ? OR B.TITLE LIKE ? OR LPAD(R.USER_ID, 6, '0') LIKE ? OR U.USER_NAME LIKE ?) ");
				isAllSearch = true;
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
				if (isAllSearch) {
					String likeStr = "%" + targetKeyword + "%";
					for (int i = 1; i <= 4; i++)
						ps.setString(i, likeStr);
				} else if ("bookId".equals(category) || "userId".equals(category)) {
					try {
						ps.setInt(1, Integer.parseInt(targetKeyword));
					} catch (NumberFormatException e) {
						ps.setInt(1, -1); // 数値変換できない場合は該当なしにする
					}
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
					bean.setUserId(rs.getInt("USER_ID"));
					bean.setUserName(rs.getString("USER_NAME"));
					list.add(bean);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	public List<ReserveBean> searchReservesByUserId(int userId, String category, String keyword) {
		List<ReserveBean> list = new ArrayList<>();

		// 基本となるテーブル結合SQL文
		StringBuilder sql = new StringBuilder(
				"SELECT R.BOOK_ID, B.TITLE, R.RESERVE_DATE, U.USER_NAME, U.USER_ID " +
						"FROM RESERVE R " +
						"JOIN BOOKS B ON R.BOOK_ID = B.BOOK_ID " +
						"JOIN USERS U ON R.USER_ID = U.USER_ID WHERE 1=1 AND R.USER_ID = ? ");

		boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
		String targetKeyword = hasKeyword ? keyword.trim() : "";

		boolean isAllSearch = false;
		// カテゴリーに応じてSQLのWHERE句を動的に追加
		if (hasKeyword) {
			switch (category) {
			case "bookId":
				sql.append("AND R.BOOK_ID = ? ");
				break;
			case "title":
				sql.append("AND B.TITLE LIKE ? ");
				break;
			case "all":
			default:
				sql.append("AND (LPAD(R.BOOK_ID, 6, '0') LIKE ? OR B.TITLE LIKE ?) ");
				isAllSearch = true;
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

			ps.setInt(1, userId);
			
			// プレースホルダー (?) への値のセット
			if (hasKeyword) {
				if (isAllSearch) {
					String likeStr = "%" + targetKeyword + "%";
					for (int i = 2; i <= 3; i++) ps.setString(i, likeStr);
				} else if ("bookId".equals(category)) {
					try {
						ps.setInt(2, Integer.parseInt(targetKeyword));
					} catch (NumberFormatException e) {
						ps.setInt(2, -1); // 数値変換できない場合は該当なしにする
					}
				} else {
					ps.setString(2, "%" + targetKeyword + "%");
				}
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					ReserveBean bean = new ReserveBean();
					bean.setBookId(rs.getInt("BOOK_ID"));
					bean.setTitle(rs.getString("TITLE"));
					bean.setReserveDate(rs.getDate("RESERVE_DATE"));
					bean.setUserId(rs.getInt("USER_ID"));
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