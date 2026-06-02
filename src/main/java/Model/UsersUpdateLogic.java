package Model;

import java.util.List;

import Dao.UsersUpdateDAO;

public class UsersUpdateLogic {
	public List<UsersBean> id(UsersBean usersBean) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.findById(usersBean);
	}
}
