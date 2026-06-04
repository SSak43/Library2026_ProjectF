package f02_user.logic;

import java.util.List;

import Model.UsersBean;
import f02_user.dao.UsersUpdateDAO;

public class UsersUpdateLogic {
	public List<UsersBean> id(UsersBean usersBean) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.findById(usersBean);
	}

	public boolean update(UsersBean usersBean) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.add(usersBean);
	}
}
