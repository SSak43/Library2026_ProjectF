package f02_user.logic;

import Model.UsersBean;
import f02_user.dao.UsersRegistDAO;

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
