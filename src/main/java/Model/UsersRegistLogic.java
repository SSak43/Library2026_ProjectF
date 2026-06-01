package Model;

import java.util.List;

import Dao.UsersRegistDAO;

public class UsersRegistLogic {
	public List<UsersBean> add(UsersBean usersBean){
		UsersRegistDAO dao = new UsersRegistDAO();
		return dao.add(usersBean);
	}
	public int getLatestId() {
	    UsersRegistDAO dao = new UsersRegistDAO();
	    return dao.getMaxUserId();
	}
}
