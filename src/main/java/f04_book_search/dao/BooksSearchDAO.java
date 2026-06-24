package f04_book_search.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.BooksBean;
import common.DAOBase;

public class BooksSearchDAO extends DAOBase {

    /**
     * 検索条件とページ数を指定して、図書を10件取得する
     * @param searchType 検索項目（all, bookId, title, writer, company, class）
     * @param keyword 検索キーワード
     * @param page 現在のページ番号（1〜）
     * @return 該当する図書のリスト（最大10件）
     */
    public List<BooksBean> searchBooks(String searchType, String keyword, int page) {
        List<BooksBean> bookList = new ArrayList<>();
        
        // 1ページあたりの表示件数
        int limit = 10;
        // スキップする件数の計算（1ページ目は0件、2ページ目は10件スキップ）
        int offset = (page - 1) * limit;

        // ベースとなるSQL文
        StringBuilder sql = new StringBuilder("SELECT * FROM BOOKS ");
        List<Object> params = new ArrayList<>();

     // キーワードが入力されている場合の絞り込み条件（WHERE句の組み立て）
        if (keyword != null && !keyword.trim().isEmpty()) {
            if ("all".equals(searchType)) {
                // 「すべて」の場合は図書ID（6桁化）、タイトル、著者名、出版社で部分一致検索
                sql.append("WHERE LPAD(BOOK_ID, 6, '0') LIKE ? OR TITLE LIKE ? OR WRITER_NAME LIKE ? OR COMPANY LIKE ? ");
                params.add("%" + keyword + "%"); // 図書ID用
                params.add("%" + keyword + "%"); // タイトル用
                params.add("%" + keyword + "%"); // 著者名用
                params.add("%" + keyword + "%"); // 出版社用
            } else if ("bookId".equals(searchType)) {
                sql.append("WHERE BOOK_ID = ? ");
                try {
                    params.add(Integer.parseInt(keyword));
                } catch (NumberFormatException e) {
                    params.add(-1); // 数字以外が入力されたらヒットしないようにする
                }
            } else if ("title".equals(searchType)) {
                sql.append("WHERE TITLE LIKE ? ");
                params.add("%" + keyword + "%");
            } else if ("writer".equals(searchType)) {
                sql.append("WHERE WRITER_NAME LIKE ? ");
                params.add("%" + keyword + "%");
            } else if ("company".equals(searchType)) {
                sql.append("WHERE COMPANY LIKE ? ");
                params.add("%" + keyword + "%");
            } else if ("class".equals(searchType)) {
                sql.append("WHERE BOOK_CLASS = ? ");
                params.add(keyword);
            }
        }

        // 並び替えとページネーション（LIMIT, OFFSET）を追加
        sql.append("ORDER BY BOOK_ID ASC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        // --- データベース接続と実行 ---
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("JDBCドライバを読み込めません");
        }

        try (Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)) {
            PreparedStatement pStmt = conn.prepareStatement(sql.toString());
            
            // パラメータのセット
            for (int i = 0; i < params.size(); i++) {
                pStmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pStmt.executeQuery()) {
                while (rs.next()) {
                    BooksBean book = new BooksBean();
                    book.setBookId(rs.getInt("BOOK_ID"));
                    book.setTitle(rs.getString("TITLE"));
                    book.setWriterName(rs.getString("WRITER_NAME"));
                    book.setCompany(rs.getString("COMPANY"));
                    book.setBookClass(rs.getString("BOOK_CLASS"));
                    book.setBookStatus(rs.getString("BOOK_STATUS"));
                    book.setBookRegist(rs.getDate("BOOK_REGIST"));
                    book.setBookUpdate(rs.getDate("BOOK_UPDATE"));
                    
                    bookList.add(book);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookList;
    }
}