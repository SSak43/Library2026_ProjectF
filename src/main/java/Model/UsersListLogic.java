package Model;

import java.util.List;

import Dao.UsersDAO;

public class UsersListLogic {
	public List<UsersBean> name(UsersBean usersBean){
		UsersDAO dao = new UsersDAO();
		return dao.findByName(usersBean);
	}
}
