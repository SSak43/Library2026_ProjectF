package f07_reserve.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.ReserveBean;
import common.DAOBase;

public class ReserveSearchDAO extends DAOBase {

    /**
     * 検索タイプとキーワードを指定して予約状況を取得する
     */
    public List<ReserveBean> searchReserves(String searchType, String searchKeyword) {
        List<ReserveBean> reserveList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // ベースとなるSQL（※論理削除されていないデータのみ取得するように修正）
            StringBuilder sql = new StringBuilder(
                "SELECT R.RESERVE_ID, R.USER_ID, U.USER_NAME, R.BOOK_ID, B.TITLE, B.WRITER_NAME, R.RESERVE_DATE, R.RESERVE_NO " +
                "FROM RESERVE R " +
                "JOIN BOOKS B ON R.BOOK_ID = B.BOOK_ID " +
                "JOIN USERS U ON R.USER_ID = U.USER_ID " +
                "WHERE R.RESERVE_STATUS = '0' " +
                "AND R.DELETE_FLAG = '0' AND B.DELETE_FLAG = '0' AND U.DELETE_FLAG = '0' "
            );
            
            List<Object> params = new ArrayList<>();

            // ★キーワードが入力されている場合のみ絞り込み（空欄なら全て表示される）
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String kw = searchKeyword.trim();
                
                // 数値型のID検索
                if ("userId".equals(searchType) || "bookId".equals(searchType)) {
                    try {
                        int id = Integer.parseInt(kw);
                        if ("userId".equals(searchType)) {
                            sql.append("AND R.USER_ID = ? ");
                        } else {
                            sql.append("AND R.BOOK_ID = ? ");
                        }
                        params.add(id);
                    } catch (NumberFormatException e) {
                        sql.append("AND 1 = 0 "); // 数字以外が入力されたらヒットさせない
                    }
                } 
                // 文字列型のあいまい検索
                else if ("title".equals(searchType)) {
                    sql.append("AND B.TITLE LIKE ? ");
                    params.add("%" + kw + "%");
                } else if ("author".equals(searchType)) {
                    sql.append("AND B.WRITER_NAME LIKE ? ");
                    params.add("%" + kw + "%");
                } else if ("publisher".equals(searchType)) {
                    sql.append("AND B.COMPANY LIKE ? "); // DBに合わせてCOMPANYに修正
                    params.add("%" + kw + "%");
                } 
                // 「すべての項目」の場合（全カラムに対してOR検索）
                else {
                    sql.append("AND (R.USER_ID LIKE ? OR R.BOOK_ID LIKE ? OR B.TITLE LIKE ? OR B.WRITER_NAME LIKE ? OR B.COMPANY LIKE ?) ");
                    params.add("%" + kw + "%");
                    params.add("%" + kw + "%");
                    params.add("%" + kw + "%");
                    params.add("%" + kw + "%");
                    params.add("%" + kw + "%");
                }
            }

            // 並び替え
            sql.append("ORDER BY R.RESERVE_ID ASC");
            
            PreparedStatement pStmt = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < params.size(); i++) {
                pStmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    ReserveBean rb = new ReserveBean();
                    rb.setReserveId(rs.getInt("RESERVE_ID"));
                    rb.setUserId(rs.getInt("USER_ID"));
                    rb.setUserName(rs.getString("USER_NAME"));
                    rb.setBookId(rs.getInt("BOOK_ID"));
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
     * 予約の取り消しと順位繰り上げ
     */
    public boolean cancelReserve(int reserveId) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pStmtSelect = null;
        PreparedStatement pStmtCancel = null;
        PreparedStatement pStmtUpdateNo = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
            conn.setAutoCommit(false);

            String sqlSelect = "SELECT BOOK_ID, RESERVE_NO FROM RESERVE WHERE RESERVE_ID = ?";
            pStmtSelect = conn.prepareStatement(sqlSelect);
            pStmtSelect.setInt(1, reserveId);
            rs = pStmtSelect.executeQuery();

            int bookId = -1;
            int currentReserveNo = -1;
            if (rs.next()) {
                bookId = rs.getInt("BOOK_ID");
                currentReserveNo = rs.getInt("RESERVE_NO");
            }

            if (bookId != -1 && currentReserveNo != -1) {
                // キャンセル時は論理削除（DELETE_FLAG='1'）にせず、予約ステータスを'1'(完了/取消)にします
                String sqlCancel = "UPDATE RESERVE SET RESERVE_STATUS = '1', RESERVE_NO = 0 WHERE RESERVE_ID = ?";
                pStmtCancel = conn.prepareStatement(sqlCancel);
                pStmtCancel.setInt(1, reserveId);
                pStmtCancel.executeUpdate();

                String sqlUpdateNo = "UPDATE RESERVE SET RESERVE_NO = RESERVE_NO - 1 "
                                   + "WHERE BOOK_ID = ? AND RESERVE_STATUS = '0' AND RESERVE_NO > ?";
                pStmtUpdateNo = conn.prepareStatement(sqlUpdateNo);
                pStmtUpdateNo.setInt(1, bookId);
                pStmtUpdateNo.setInt(2, currentReserveNo);
                pStmtUpdateNo.executeUpdate();

                conn.commit();
                result = true;
            }
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pStmtSelect != null) pStmtSelect.close(); } catch (SQLException e) {}
            try { if (pStmtCancel != null) pStmtCancel.close(); } catch (SQLException e) {}
            try { if (pStmtUpdateNo != null) pStmtUpdateNo.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return result;
    }
}