package Model;

import Dao.UsersRegistDAO;

public class UsersRegistLogic {
	public boolean add(UsersBean usersBean){
		UsersRegistDAO dao = new UsersRegistDAO();
		return dao.add(usersBean);
	}
	public int getLatestId() {
	    UsersRegistDAO dao = new UsersRegistDAO();
	    return dao.getMaxUserId();
	}
}
//更新用