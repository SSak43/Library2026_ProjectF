package f02_user.logic;

import Model.UsersBean;
import f02_user.dao.UsersRegistDAO;

/**
 * 利用者の新規登録に関する処理（DAOへの橋渡し）を行うロジッククラス。
 */
public class UsersRegistLogic {
	
	/**
	 * 受け取った利用者情報をデータベースに登録します。
	 */
	public boolean add(UsersBean usersBean){
		UsersRegistDAO dao = new UsersRegistDAO();
		return dao.add(usersBean);
	}
	
	/**
	 * 現在登録されている最新（最大）の利用者IDを取得します。
	 */
	public int getLatestId() {
	    UsersRegistDAO dao = new UsersRegistDAO();
	    return dao.getMaxUserId();
	}
}