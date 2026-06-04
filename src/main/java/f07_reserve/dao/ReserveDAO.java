package f07_reserve.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Model.ReserveBean;
import common.DAOBase;

public class ReserveDAO extends DAOBase {

    /**
     * 指定された図書の「現在の予約数」を調べて、次の予約順（RESERVE_NO）を返す
     */
    public int getNextReserveNo(int bookId) {
        int nextNo = 1; // 誰も予約していなければ1番目
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // 現在の最大の予約順を取得
            String sql = "SELECT MAX(RESERVE_NO) AS MAX_NO FROM RESERVE WHERE BOOK_ID = ?";
            PreparedStatement pStmt = conn.prepareStatement(sql);
            pStmt.setInt(1, bookId);
            
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    int maxNo = rs.getInt("MAX_NO");
                    nextNo = maxNo + 1; // 最大値に+1する
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return nextNo;
    }

    /**
     * 予約データをデータベースに登録する
     */
    public boolean registerReserve(ReserveBean reserve) {
        boolean result = false;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            String sql = "INSERT INTO RESERVE (USER_ID, BOOK_ID, RESERVE_DATE, RESERVE_NO, RESERVE_STATUS, RESERVE_REGIST, RESERVE_UPDATE) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pStmt = conn.prepareStatement(sql);
            
            pStmt.setInt(1, reserve.getUserId());
            pStmt.setInt(2, reserve.getBookId());
            pStmt.setDate(3, reserve.getReserveDate());
            pStmt.setInt(4, reserve.getReserveNo());
            pStmt.setString(5, reserve.getReserveStatus());
            pStmt.setDate(6, reserve.getReserveRegist());
            pStmt.setDate(7, reserve.getReserveUpdate());
            
            int insertCount = pStmt.executeUpdate();
            if (insertCount == 1) {
                result = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}