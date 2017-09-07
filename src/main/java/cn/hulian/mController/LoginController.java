package cn.hulian.mController;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import cn.hulian.mDao.ILoginMapper;
import cn.hulian.mEntity.User;
import cn.hulian.mUtil.ApplicationContextHelper;

@Controller
public class LoginController{

	
	private static Map<String,String> nickname_sessionid;
	/*private static Map<HttpSession,String> session_sessionid;*/
	
	@RequestMapping(value="signup")
	@ResponseBody
	public String signup(@RequestParam String signupName,@RequestParam String signupPassword,@RequestParam String sex){
		ILoginMapper iLoginMapper=ApplicationContextHelper.getApplicationContext().getBean(ILoginMapper.class);
		String str="";
		int i=0;
		String avatarurl="";
		if(sex.equals("male"))
			avatarurl="http://192.168.1.164:8080/ChatRoom/uploadPic/avatar/male.jpg";
		if(sex.equals("female"))
			avatarurl="http://192.168.1.164:8080/ChatRoom/uploadPic/avatar/female.jpg";
		if(iLoginMapper.queryNickname(signupName)==null){
			User u=new User(signupName, signupPassword, sex, avatarurl,signupName);
			i=iLoginMapper.insertUser(u);
			if(i>0)
				str="s";
			else
				str="f";
		}else{
			str="repeat";
		}
		return str;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="login")
	@ResponseBody
	public String login(@RequestParam String loginName,@RequestParam String loginPassword,HttpSession httpSession){
		ILoginMapper iLoginMapper=ApplicationContextHelper.getApplicationContext().getBean(ILoginMapper.class);
		String str="";
		if(iLoginMapper.queryPassword(loginName)==null){
			str="f";
			return str;
		}
		else{
			if(iLoginMapper.queryPassword(loginName).equals(loginPassword))
			{
				nickname_sessionid=(Map<String,String>)httpSession.getServletContext().getAttribute("nickname_sessionid");
				/*session_sessionid=(Map<HttpSession,String>)httpSession.getServletContext().getAttribute("session_sessionid");*/
				sessionHandler(loginName,httpSession);//Î¨Ò»µÇÂ½´¦Àí
				httpSession.setAttribute("nickName", loginName);
				nickname_sessionid.put(loginName,httpSession.getId());
				/*session_sessionid.put(httpSession, httpSession.getId());*/

				str="s";
				
			}
			else
			    str="f";
		}
		return str;
	}
	
	
	public void sessionHandler(String nickName,HttpSession session){
		if(nickname_sessionid.get(nickName)!=null){
	        	session.removeAttribute("nickName");
	        	nickname_sessionid.remove(nickName);
			
		}
	}

	
}
