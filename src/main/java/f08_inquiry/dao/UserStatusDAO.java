package f08_inquiry.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import Model.RentalBean;
import Model.ReserveBean;
import common.DAOBase;

public class UserStatusDAO extends DAOBase {

	// ① 貸出状況を5件取得（LENDSテーブルの設計書に合わせて修正）
	public List<RentalBean> getUserRentals(String userId) {
		List<RentalBean> list = new ArrayList<>();
		
		// 💡 設計書通り LENDS テーブル、LEND_DATE、RETURN_LINE に変更
		String sql = "SELECT LPAD(L.BOOK_ID, 6, '0') AS BOOK_ID_STR, B.TITLE, " +
					 "DATE_FORMAT(L.LEND_DATE, '%Y/%m/%d') AS LOAN_DATE_STR, " +
					 "DATE_FORMAT(L.RETURN_LINE, '%Y/%m/%d') AS RETURN_DEADLINE_STR " +
					 "FROM LENDS L JOIN BOOKS B ON L.BOOK_ID = B.BOOK_ID " +
					 "WHERE L.USER_ID = ? AND L.RETURN_DATE IS NULL ORDER BY L.LEND_DATE DESC LIMIT 5";

		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			try {
				ps.setInt(1, Integer.parseInt(userId));
			} catch (NumberFormatException e) {
				ps.setInt(1, -1); // 変換できなければ存在しないID(-1)にして安全に空の結果を返す
			}

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					RentalBean bean = new RentalBean();
					bean.setBookId(rs.getString("BOOK_ID_STR"));
					bean.setTitle(rs.getString("TITLE"));
					// SQLのAS句で名前をつけているので、取得時のキーはそのまま
					bean.setLoanDate(rs.getString("LOAN_DATE_STR"));
					bean.setReturnDeadline(rs.getString("RETURN_DEADLINE_STR"));
					list.add(bean);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// ② 予約状況を5件取得
	public List<ReserveBean> getUserReserves(String userId) {
		List<ReserveBean> list = new ArrayList<>();
		String sql =
				"SELECT R.RESERVE_ID, LPAD(R.BOOK_ID, 6, '0') AS BOOK_ID_STR, B.TITLE, R.RESERVE_DATE, " +
				 "DATE_FORMAT(R.RESERVE_DATE, '%Y/%m/%d') AS RESERVE_DATE_STR, U.USER_NAME " +
				 "FROM RESERVE R JOIN BOOKS B ON R.BOOK_ID = B.BOOK_ID " +
				 "JOIN USERS U ON R.USER_ID = U.USER_ID " +
				 "WHERE R.USER_ID = ? AND R.RESERVE_STATUS = '0' AND R.DELETE_FLAG = '0' AND B.DELETE_FLAG = '0' AND U.DELETE_FLAG = '0' " +
				 "ORDER BY R.RESERVE_DATE DESC ";

		try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			
			try {
				ps.setInt(1, Integer.parseInt(userId));
			} catch (NumberFormatException e) {
				ps.setInt(1, -1);
			}
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					ReserveBean bean = new ReserveBean();
					bean.setReserveId(rs.getInt("RESERVE_ID"));
					bean.setBookId(Integer.parseInt(rs.getString("BOOK_ID_STR")));
					bean.setTitle(rs.getString("TITLE"));
					bean.setReserveDate(rs.getDate("RESERVE_DATE"));
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