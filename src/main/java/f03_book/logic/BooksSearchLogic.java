package f03_book.logic;

import java.util.List;

import Model.BooksBean;
import f03_book.dao.BooksSearchDAO;

public class BooksSearchLogic {
	public List<BooksBean> id(BooksBean booksBean){
		BooksSearchDAO dao = new BooksSearchDAO();
		return dao.findById(booksBean);
	}
	
	public List<BooksBean> title(BooksBean booksBean){
		BooksSearchDAO dao = new BooksSearchDAO();
		return dao.findByTitle(booksBean);
		
	}
}
