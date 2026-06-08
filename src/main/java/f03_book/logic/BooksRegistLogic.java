package f03_book.logic;

import Model.BooksBean;
import f03_book.dao.BooksRegistDAO;

public class BooksRegistLogic {
	public boolean add(BooksBean booksBean){
		BooksRegistDAO dao = new BooksRegistDAO();
		return dao.add(booksBean);
	}
	public int getLatestId() {
		BooksRegistDAO dao = new BooksRegistDAO();
		return dao.getMaxBookId();
	}
}
