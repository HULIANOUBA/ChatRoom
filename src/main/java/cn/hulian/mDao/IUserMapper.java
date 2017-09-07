package cn.hulian.mDao;

import cn.hulian.mEntity.User;

public interface IUserMapper {
	
       String queryAvatarUrlByNickname(String nickName);
       int updateUser(User u);
}
