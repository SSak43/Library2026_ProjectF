package Model;
import java.io.Serializable;
import java.sql.Date;

public class UsersBean implements Serializable{
	protected int userId;
	protected String userName;
	protected String tel;
	protected String password;
	protected String userClass;
	protected String userStatus;
	protected Date userRegist;
	protected Date userUpdate;
	
	public UsersBean() {}
	public UsersBean(int userId,String userName,String tel,String password,String userClass,String userStatus,Date userRegist,Date userUpdate) {
		this.userId = userId;
		this.userName = userName;
		this.tel = tel;
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
	public String getPassword(){return password;}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUserClass(){return userClass;}
	public void setUserClass(String userClass) {
		this.userClass = userClass;
	}
	public String getUserStatus(){return userStatus;}
	public void setUserStatus(String userStatus) {
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
