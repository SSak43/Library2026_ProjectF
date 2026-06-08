package Model;

import java.io.Serializable;

public class RentalBean implements Serializable {
	private static final long serialVersionUID = 1L;

	private String bookId;
	private String title;
	private String loanDate;
	private String returnDeadline;
	private String userId; 
	
	public RentalBean() {}

	public String getBookId() { return bookId; }
	public void setBookId(String bookId) { this.bookId = bookId; }

	public String getTitle() { return title; }
	public void setTitle(String title) { this.title = title; }

	public String getLoanDate() { return loanDate; }
	public void setLoanDate(String loanDate) { this.loanDate = loanDate; }

	public String getReturnDeadline() { return returnDeadline; }
	public void setReturnDeadline(String returnDeadline) { this.returnDeadline = returnDeadline; }

	// 💡 追加した userId のゲッターとセッター
	public String getUserId() { return userId; }
	public void setUserId(String userId) { this.userId = userId; }
}