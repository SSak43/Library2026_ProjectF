package Dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import Model.LendsBean;

public class LendsDAO extends DAOBase {

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
}