package Model;

import java.sql.Date;

public class ReserveBean {
    private int reserveId;        // 予約ID
    private int userId;           // 利用者ID
    private int bookId;           // 図書ID
    private Date reserveDate;     // 予約日
    private int reserveNo;        // 予約順
    private String reserveStatus; // 状態 (0:予約可能, 1:予約不可)
    private Date reserveRegist;   // 登録日
    private Date reserveUpdate;   // 更新日

    // 画面表示用（テーブルにはない項目）
    private String userName;      // 利用者氏名
    private String title;         // 書名
    private String writerName;    // 著者名
    private String bookStatusStr; // 貸出状態（「貸出可能」などの表示用文字列）

    // ==========================================
    // ゲッター と セッター
    // ==========================================
    public int getReserveId() { return reserveId; }
    public void setReserveId(int reserveId) { this.reserveId = reserveId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public Date getReserveDate() { return reserveDate; }
    public void setReserveDate(Date reserveDate) { this.reserveDate = reserveDate; }

    public int getReserveNo() { return reserveNo; }
    public void setReserveNo(int reserveNo) { this.reserveNo = reserveNo; }

    public String getReserveStatus() { return reserveStatus; }
    public void setReserveStatus(String reserveStatus) { this.reserveStatus = reserveStatus; }

    public Date getReserveRegist() { return reserveRegist; }
    public void setReserveRegist(Date reserveRegist) { this.reserveRegist = reserveRegist; }

    public Date getReserveUpdate() { return reserveUpdate; }
    public void setReserveUpdate(Date reserveUpdate) { this.reserveUpdate = reserveUpdate; }

    // 表示用のゲッター・セッター
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getWriterName() { return writerName; }
    public void setWriterName(String writerName) { this.writerName = writerName; }

    public String getBookStatusStr() { return bookStatusStr; }
    public void setBookStatusStr(String bookStatusStr) { this.bookStatusStr = bookStatusStr; }
}