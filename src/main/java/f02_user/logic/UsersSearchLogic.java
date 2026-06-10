package f02_user.logic;

import java.util.List;

import Model.UsersBean;
import f02_user.dao.UsersSearchDAO;

public class UsersSearchLogic {
	public List<UsersBean> all(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByAll(usersBean);
	}
	
	public List<UsersBean> name(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByName(usersBean);
	}

	public List<UsersBean> userClass(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByClass(usersBean);
	}

	public List<UsersBean> id(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findById(usersBean);
	}
}
