package f09_over.dao;

public class OverDAO extends DAOBase{
	public List<BooksBean> findByBookId(BooksBean booksBean){
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		}catch(ClassNotFoundException e) {
			throw new IllegalStateException("JDBCドライバを読み込めません");
		}
		try(Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS)){
			String sql = "SELECT * FROM LENDS WHERE RETURN_LINE > "
		}
	}

}
