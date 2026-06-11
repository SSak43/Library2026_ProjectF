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
	
	public String hash(String pass) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.hashPassword(pass);
	}
	
	public List<UsersBean> name(UsersBean usersBean){
		// 
		f02_user.dao.UsersSearchDAO searchDao = new f02_user.dao.UsersSearchDAO();
		return searchDao.findByName(usersBean);
	}
	
}
