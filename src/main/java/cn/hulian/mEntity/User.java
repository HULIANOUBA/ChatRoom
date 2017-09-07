package cn.hulian.mEntity;

public class User {

	private Integer u_id;
	private String u_name;
	private String u_password;
	private String u_sex;
	private String u_avatarurl;
	private String u_oldname;

	public Integer getU_id() {
		return u_id;
	}

	public void setU_id(Integer u_id) {
		this.u_id = u_id;
	}

	public String getU_name() {
		return u_name;
	}

	public void setU_name(String u_name) {
		this.u_name = u_name;
	}

	public String getU_password() {
		return u_password;
	}

	public void setU_password(String u_password) {
		this.u_password = u_password;
	}

	public String getu_sex() {
		return u_sex;
	}

	public void setu_sex(String u_sex) {
		this.u_sex = u_sex;
	}

	public String getU_avatarurl() {
		return u_avatarurl;
	}

	public void setU_avatarurl(String u_avatarurl) {
		this.u_avatarurl = u_avatarurl;
	}

	public String getu_oldname() {
		return u_oldname;
	}

	public void setu_oldname(String u_oldname) {
		this.u_oldname = u_oldname;
	}

	public User() {
		super();
	}

	public User(String u_name, String u_password, String u_sex, String u_avatarurl, String u_oldname) {
		super();
		this.u_name = u_name;
		this.u_password = u_password;
		this.u_sex = u_sex;
		this.u_avatarurl = u_avatarurl;
		this.u_oldname = u_oldname;
	}

	public User(Integer u_id, String u_name, String u_password, String u_sex, String u_avatarurl, String u_oldname) {
		super();
		this.u_id = u_id;
		this.u_name = u_name;
		this.u_password = u_password;
		this.u_sex = u_sex;
		this.u_avatarurl = u_avatarurl;
		this.u_oldname = u_oldname;
	}

	public User(String u_name, String u_password) {
		super();
		this.u_name = u_name;
		this.u_password = u_password;
	}

	public User(String u_name, String u_avatarurl, String u_oldname) {
		super();
		this.u_name = u_name;
		this.u_avatarurl = u_avatarurl;
		this.u_oldname = u_oldname;
	}

}
