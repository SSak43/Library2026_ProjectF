package Model;

import java.util.List;

import Dao.UsersSearchDAO;

public class UsersSearchLogic {
	public List<UsersBean> all(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByAll(usersBean);
	}
	
//	public List<UsersBean> name(UsersBean usersBean){
//		UsersSearchDAO dao = new UsersSearchDAO();
//		return dao.findByName(usersBean);
//	}

	public List<UsersBean> userClass(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByClass(usersBean);
	}

	public List<UsersBean> id(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findById(usersBean);
	}
}
