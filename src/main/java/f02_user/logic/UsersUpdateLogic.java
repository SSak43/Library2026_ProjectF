package f02_user.logic;

import java.util.List;

import Model.UsersBean;
import f02_user.dao.UsersUpdateDAO;

/**
 * 利用者情報の更新に関する処理（DAOへの橋渡し）を行うロジッククラス。
 */
public class UsersUpdateLogic {
	
	/**
	 * 【ID検索】
	 * 更新対象となる特定のユーザーをIDで検索して取得します。
	 */
	public List<UsersBean> id(UsersBean usersBean) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.findById(usersBean);
	}

	/**
	 * 【情報更新】
	 * 変更されたユーザー情報をデータベースに上書き保存します。
	 */
	public boolean update(UsersBean usersBean) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.add(usersBean);
	}
	
	/**
	 * 【パスワードのハッシュ化】
	 * 入力されたパスワードを安全な形式（SHA-256）に暗号化します。
	 */
	public String hash(String pass) {
		UsersUpdateDAO dao = new UsersUpdateDAO();
		return dao.hashPassword(pass);
	}
	
	/**
	 * 【氏名検索】
	 * 氏名（部分一致）で利用者を検索します。
	 * （※このメソッドのみ、検索用のUsersSearchDAOを利用しています）
	 */
	public List<UsersBean> name(UsersBean usersBean){
		// 
		f02_user.dao.UsersSearchDAO searchDao = new f02_user.dao.UsersSearchDAO();
		return searchDao.findByName(usersBean);
	}
	
}