package cn.hulian.mDao;

import cn.hulian.mEntity.User;

public interface ILoginMapper {

	String queryNickname(String nickName);
	int insertUser(User u);
	String queryPassword(String nickName);
}
