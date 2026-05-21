package Model;

import java.util.List;

import Dao.UsersDAO;

public class UsersListLogic {
	public List<UsersBean> all(UsersBean usersBean){
		UsersDAO dao = new UsersDAO();
		return dao.findByAll(usersBean);
	}
	
	public List<UsersBean> name(UsersBean usersBean){
		UsersDAO dao = new UsersDAO();
		return dao.findByName(usersBean);
	}
	
	public List<UsersBean> id(UsersBean usersBean){
		UsersDAO dao = new UsersDAO();
		return dao.findById(usersBean);
	}
}
