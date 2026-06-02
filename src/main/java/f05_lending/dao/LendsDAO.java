package f05_lending.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

import Model.LendsBean;
import common.DAOBase;

public class LendsDAO extends DAOBase {

    // ==========================================
    // 貸出処理用のメソッド
    // ==========================================

    /**
     * 現在借りている（まだ返却していない）本の数を取得する
     */
    public int countActiveLends(int userId) {
        int count = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // RETURN_DATEがNULL（未返却）のものをカウント
            String sql = "SELECT COUNT(*) AS CNT FROM LENDS WHERE USER_ID = ? AND RETURN_DATE IS NULL";
            PreparedStatement pStmt = conn.prepareStatement(sql);
            pStmt.setInt(1, userId);
            
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("CNT");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    /**
     * 貸出情報を登録し、図書の状態を貸出中に更新する
     */
    public boolean registerLend(LendsBean lend) {
        boolean result = false;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // オートコミットをオフにする（トランザクション開始）
            conn.setAutoCommit(false);
            
            try {
                // ① LENDSテーブルへのINSERT
                String sql1 = "INSERT INTO LENDS (USER_ID, BOOK_ID, LEND_DATE, RETURN_LINE, LEND_REGIST, LEND_UPDATE) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pStmt1 = conn.prepareStatement(sql1);
                pStmt1.setInt(1, lend.getUserId());
                pStmt1.setInt(2, lend.getBookId());
                pStmt1.setDate(3, lend.getLendDate());
                pStmt1.setDate(4, lend.getReturnLine());
                pStmt1.setDate(5, lend.getLendRegist());
                pStmt1.setDate(6, lend.getLendUpdate());
                
                int insertCount = pStmt1.executeUpdate();

                // ② BOOKSテーブルのBOOK_STATUSを '1'（貸出中）にUPDATE
                String sql2 = "UPDATE BOOKS SET BOOK_STATUS = '1' WHERE BOOK_ID = ?";
                PreparedStatement pStmt2 = conn.prepareStatement(sql2);
                pStmt2.setInt(1, lend.getBookId());
                
                int updateCount = pStmt2.executeUpdate();

                // 両方成功したらコミット（確定）
                if (insertCount == 1 && updateCount == 1) {
                    conn.commit();
                    result = true;
                } else {
                    conn.rollback(); // 失敗したら元に戻す
                }
                
            } catch (SQLException e) {
                // エラーが起きたらロールバック（元に戻す）
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return result;
    }


    // ==========================================
    // 返却処理用のメソッド（新しく追加された部分）
    // ==========================================

    /**
     * 【返却用】図書IDから「現在貸出中（未返却）」の貸出情報を、書名・氏名付きで取得する
     */
    public LendsBean findActiveLendByBookId(int bookId) {
        LendsBean lend = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            // 3つのテーブルを結合して、RETURN_DATE が NULL（未返却）のものを探す
            String sql = "SELECT L.LEND_ID, L.USER_ID, L.BOOK_ID, L.LEND_DATE, B.TITLE, U.USER_NAME " +
                         "FROM LENDS L " +
                         "JOIN BOOKS B ON L.BOOK_ID = B.BOOK_ID " +
                         "JOIN USERS U ON L.USER_ID = U.USER_ID " +
                         "WHERE L.BOOK_ID = ? AND L.RETURN_DATE IS NULL";
            
            PreparedStatement pStmt = conn.prepareStatement(sql);
            pStmt.setInt(1, bookId);
            
            try (ResultSet rs = pStmt.executeQuery()) {
                if (rs.next()) {
                    lend = new LendsBean();
                    lend.setLendId(rs.getInt("LEND_ID"));
                    lend.setUserId(rs.getInt("USER_ID"));
                    lend.setBookId(rs.getInt("BOOK_ID"));
                    lend.setLendDate(rs.getDate("LEND_DATE"));
                    lend.setTitle(rs.getString("TITLE"));        // 書名をセット
                    lend.setUserName(rs.getString("USER_NAME")); // 利用者氏名をセット
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lend;
    }

    /**
     * 【返却用】返却処理を実行する（LENDSの返却日更新 ＆ BOOKSの状態を貸出可能に）
     */
    public boolean executeReturn(int lendId, int bookId) {
        boolean result = false;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            conn.setAutoCommit(false); // トランザクション開始
            
            try {
                Date today = Date.valueOf(LocalDate.now());

                // ① LENDSテーブルの返却日(RETURN_DATE)と更新日を更新
                String sql1 = "UPDATE LENDS SET RETURN_DATE = ?, LEND_UPDATE = ? WHERE LEND_ID = ?";
                PreparedStatement pStmt1 = conn.prepareStatement(sql1);
                pStmt1.setDate(1, today);
                pStmt1.setDate(2, today);
                pStmt1.setInt(3, lendId);
                int count1 = pStmt1.executeUpdate();

                // ② BOOKSテーブルの状態(BOOK_STATUS)を '0'（貸出可能）に戻す
                String sql2 = "UPDATE BOOKS SET BOOK_STATUS = '0' WHERE BOOK_ID = ?";
                PreparedStatement pStmt2 = conn.prepareStatement(sql2);
                pStmt2.setInt(1, bookId);
                int count2 = pStmt2.executeUpdate();

                if (count1 == 1 && count2 == 1) {
                    conn.commit(); // どちらも成功したら確定
                    result = true;
                } else {
                    conn.rollback();
                }
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
}