package Model;
import java.io.Serializable;
import java.sql.Date;

public class UsersBean implements Serializable{
	protected int userId;
	protected String userName;
	protected String tel;
	protected int loginId;
	protected String password;
	protected char userClass;
	protected char userStatus;
	protected Date userRegist;
	protected Date userUpdate;
	
	public UsersBean() {}
	public UsersBean(int userId,String userName,String tel,int loginId,String password,char userClass,char userStatus,Date userRegist,Date userUpdate) {
		this.userId = userId;
		this.userName = userName;
		this.tel = tel;
		this.loginId = loginId;
		this.password = password;
		this.userClass = userClass;
		this.userStatus = userStatus;
		this.userRegist = userRegist;
		this.userUpdate = userUpdate;
	}
	
	public int getUserId();
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getUserName();
	public String getTel();
	public int getLoginId();
	public String getPassword();
	public char getUserClass();
	public char getUserStatus();
	public Date getUserRegist();
	public Date getUserUpdate();
	

}
