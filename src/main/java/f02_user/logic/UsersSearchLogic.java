package f02_user.logic;

import java.util.List;

import Model.UsersBean;
import f02_user.dao.UsersSearchDAO;

/**
 * 利用者検索やログイン認証に関する処理（DAOへの橋渡し）を行うロジッククラス。
 */
public class UsersSearchLogic {
	
	/**
	 * 【全件検索】
	 * 登録されているすべての利用者情報を取得します。
	 */
	public List<UsersBean> all(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByAll(usersBean);
	}
	
	/**
	 * 【氏名検索】
	 * 氏名（部分一致）で利用者を検索します。
	 */
	public List<UsersBean> name(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByName(usersBean);
	}

	/**
	 * 【区分検索】
	 * 利用者の区分（管理者、司書、利用者など）を指定して検索します。
	 */
	public List<UsersBean> userClass(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findByClass(usersBean);
	}

	/**
	 * 【ID検索】
	 * 指定した利用者IDと完全一致するユーザーを1件検索します。
	 */
	public List<UsersBean> id(UsersBean usersBean){
		UsersSearchDAO dao = new UsersSearchDAO();
		return dao.findById(usersBean);
	}
}