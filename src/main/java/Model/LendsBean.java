package Model;

import java.sql.Date;

public class LendsBean {
    private int lendId;          // 貸出ID
    private int userId;          // 利用者ID
    private int bookId;          // 図書ID
    private Date lendDate;       // 貸出日
    private Date returnLine;     // 返却期限
    private Date returnDate;     // 返却日
    private Date lendRegist;     // 登録日
    private Date lendUpdate;     // 更新日

    // ゲッターとセッター
    public int getLendId() { return lendId; }
    public void setLendId(int lendId) { this.lendId = lendId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public Date getLendDate() { return lendDate; }
    public void setLendDate(Date lendDate) { this.lendDate = lendDate; }

    public Date getReturnLine() { return returnLine; }
    public void setReturnLine(Date returnLine) { this.returnLine = returnLine; }

    public Date getReturnDate() { return returnDate; }
    public void setReturnDate(Date returnDate) { this.returnDate = returnDate; }

    public Date getLendRegist() { return lendRegist; }
    public void setLendRegist(Date lendRegist) { this.lendRegist = lendRegist; }

    public Date getLendUpdate() { return lendUpdate; }
    public void setLendUpdate(Date lendUpdate) { this.lendUpdate = lendUpdate; }
}