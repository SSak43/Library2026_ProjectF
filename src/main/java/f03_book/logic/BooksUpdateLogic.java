package f03_book.logic;

import java.util.List;

import Model.BooksBean;
import f03_book.dao.BooksUpdateDAO;

public class BooksUpdateLogic {
	public List<BooksBean> id(BooksBean booksBean) {
		BooksUpdateDAO dao = new BooksUpdateDAO();
		return dao.findById(booksBean);
	}

	public boolean update(BooksBean booksBean) {
		BooksUpdateDAO dao = new BooksUpdateDAO();
		return dao.add(booksBean);
	}

}
