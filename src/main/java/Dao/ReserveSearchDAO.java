package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.ReserveBean;

public class ReserveSearchDAO extends DAOBase {

    /**
     * 予約状況を検索する（図書検索の条件に合わせる）
     */
    public List<ReserveBean> searchReserves(String category, String keyword) {
        List<ReserveBean> reserveList = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // 基本となるSQL（予約中のもの RESERVE_STATUS = '0' のみ）
            StringBuilder sql = new StringBuilder(
                "SELECT R.RESERVE_ID, R.BOOK_ID, U.USER_NAME, B.TITLE, B.WRITER_NAME, R.RESERVE_DATE, R.RESERVE_NO " +
                "FROM RESERVE R " +
                "JOIN BOOKS B ON R.BOOK_ID = B.BOOK_ID " +
                "JOIN USERS U ON R.USER_ID = U.USER_ID " +
                "WHERE R.RESERVE_STATUS = '0' "
            );

            // キーワードがある場合、条件を追加
            boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
            if (hasKeyword) {
                if ("bookId".equals(category)) {
                    sql.append("AND B.BOOK_ID = ? ");
                } else if ("title".equals(category)) {
                    sql.append("AND B.TITLE LIKE ? ");
                } else if ("writerName".equals(category)) {
                    sql.append("AND B.WRITER_NAME LIKE ? ");
                } else if ("company".equals(category)) {
                    sql.append("AND B.COMPANY LIKE ? ");
                } else if ("bookClass".equals(category)) {
                    sql.append("AND B.BOOK_CLASS = ? ");
                } else {
                    // 「すべての項目」の場合
                    sql.append("AND (B.BOOK_ID = ? OR B.TITLE LIKE ? OR B.WRITER_NAME LIKE ? OR B.COMPANY LIKE ?) ");
                }
            }

            // 指定通り「図書IDの昇順」、その中で「予約順の昇順」
            sql.append("ORDER BY B.BOOK_ID ASC, R.RESERVE_NO ASC");

            PreparedStatement pStmt = conn.prepareStatement(sql.toString());

            // パラメータのセット
            if (hasKeyword) {
                if ("bookId".equals(category) || "bookClass".equals(category)) {
                    pStmt.setString(1, keyword);
                } else if ("all".equals(category)) {
                    pStmt.setString(1, keyword);
                    pStmt.setString(2, "%" + keyword + "%");
                    pStmt.setString(3, "%" + keyword + "%");
                    pStmt.setString(4, "%" + keyword + "%");
                } else {
                    // あいまい検索
                    pStmt.setString(1, "%" + keyword + "%");
                }
            }

            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    ReserveBean rb = new ReserveBean();
                    rb.setReserveId(rs.getInt("RESERVE_ID"));
                    rb.setBookId(rs.getInt("BOOK_ID"));
                    rb.setUserName(rs.getString("USER_NAME"));
                    rb.setTitle(rs.getString("TITLE"));
                    rb.setWriterName(rs.getString("WRITER_NAME"));
                    rb.setReserveDate(rs.getDate("RESERVE_DATE"));
                    rb.setReserveNo(rs.getInt("RESERVE_NO"));
                    reserveList.add(rb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reserveList;
    }

    /**
     * 予約を取り消す（RESERVE_STATUS を '1' に更新）
     */
    public boolean cancelReserve(int reserveId) {
        boolean result = false;
        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            String sql = "UPDATE RESERVE SET RESERVE_STATUS = '1' WHERE RESERVE_ID = ?";
            PreparedStatement pStmt = conn.prepareStatement(sql);
            pStmt.setInt(1, reserveId);
            
            if (pStmt.executeUpdate() == 1) {
                result = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}