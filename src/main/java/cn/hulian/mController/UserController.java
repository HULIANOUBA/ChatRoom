package cn.hulian.mController;

import java.io.File;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.hulian.mDao.IUserMapper;
import cn.hulian.mEntity.User;
import cn.hulian.mUtil.ApplicationContextHelper;
import net.sf.json.JSONObject;

@Controller
public class UserController {

	@Autowired
	private HttpServletRequest request;
	
	@RequestMapping(value="updateUser")
	@ResponseBody
	public String updateUser(@RequestParam String oldNickname,@RequestParam String nickName,@RequestParam(value="avatar") MultipartFile file){
		String str="";
		int i=0;
		String realPicPath="";
		IUserMapper iUserMapper=ApplicationContextHelper.getApplicationContext().getBean(IUserMapper.class);
		if(file!=null && !file.isEmpty()){
			String fileName = file.getOriginalFilename();
			String extensionName = fileName.substring(fileName.lastIndexOf(".") + 1);
			String newFileName = String.valueOf(System.currentTimeMillis()) + "." + extensionName;
			String savePicPath = request.getSession().getServletContext().getRealPath("/uploadPic/avatar")+ "\\" +newFileName;
			File picDir = new File(savePicPath);
			if (!picDir.exists()) {
				picDir.mkdirs();
			}
			try {
				file.transferTo(new File(savePicPath));
			} catch (Exception e) {
				e.getStackTrace();
			}
			 realPicPath = "http://192.168.1.164:8080/ChatRoom/uploadPic/avatar/" + newFileName;
		}else{
			 realPicPath=iUserMapper.queryAvatarUrlByNickname(oldNickname).toString();
		}
			User user=new User(nickName, realPicPath, oldNickname);
			i=iUserMapper.updateUser(user);
			if(i>0){
				request.getSession().setAttribute("nickName", nickName);
				str=JSONObject.fromObject(user).toString();
			}
			else
				str="f";
		
		return str;
	}
	
	@RequestMapping(value="queryAvatarUrlByNickname")
	@ResponseBody
	public String queryAvatarUrl(@RequestBody String data){
		
		IUserMapper iUserMapper=ApplicationContextHelper.getApplicationContext().getBean(IUserMapper.class);
		JSONObject jObj=JSONObject.fromObject(data);
		String nickName=jObj.getString("nickName");
		return iUserMapper.queryAvatarUrlByNickname(nickName).toString();
	}
	
}
