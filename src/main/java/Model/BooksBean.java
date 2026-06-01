package Model;

import java.sql.Date;

public class BooksBean {
    private int bookId;          // 図書ID
    private String title;        // 書名
    private String writerName;   // 著者
    private String company;      // 出版社
    private String bookClass;    // 分類
    private String bookStatus;   // 状態 (0:貸出可能, 1:貸出中, 2:貸出不可)
    private Date bookRegist;     // 登録日
    private Date bookUpdate;     // 更新日

 

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getWriterName() { return writerName; }
    public void setWriterName(String writerName) { this.writerName = writerName; }

    public String getCompany() { return company; }
    public void setCompany(String company) { this.company = company; }

    public String getBookClass() { return bookClass; }
    public void setBookClass(String bookClass) { this.bookClass = bookClass; }

    public String getBookStatus() { return bookStatus; }
    public void setBookStatus(String bookStatus) { this.bookStatus = bookStatus; }

    public Date getBookRegist() { return bookRegist; }
    public void setBookRegist(Date bookRegist) { this.bookRegist = bookRegist; }

    public Date getBookUpdate() { return bookUpdate; }
    public void setBookUpdate(Date bookUpdate) { this.bookUpdate = bookUpdate; }
}