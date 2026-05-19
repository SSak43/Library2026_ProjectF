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
	
	public int getUserId() {return userId;}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getUserName() {return userName;}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getTel(){return tel;}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public int getLoginId(){return loginId;}
	public void setLoginId(int loginId) {
		this.loginId = loginId;
	}
	public String getPassword(){return password;}
	public void setPassword(String password) {
		this.password = password;
	}
	public char getUserClass(){return userClass;}
	public void setUserClass(char userClass) {
		this.userClass = userClass;
	}
	public char getUserStatus(){return userStatus;}
	public void setUserStatus(char userStatus) {
		this.userStatus = userStatus;
	}
	public Date getUserRegist(){return userRegist;}
	public void setUserRegist(Date userRegist) {
		this.userRegist = userRegist;
	}
	public Date getUserUpdate(){return userUpdate;}
	public void setUserUpdate(Date userUpdate) {
		this.userUpdate = userUpdate;
	}

}
