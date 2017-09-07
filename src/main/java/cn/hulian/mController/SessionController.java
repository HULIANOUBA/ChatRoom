package cn.hulian.mController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
public class SessionController {

	private static Map<String, String> nickname_sessionid;
	private Map<String,List<Map<String,Object>>> allChatMap;//存储所有私聊对话聊天信息
	private List<Map<String,Object>> singleChatList;//存储单一私聊对话聊天信息
	private static String name="";
	@Autowired
	private HttpSession session;
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "checkSession")
	@ResponseBody
	public String checkSession(@RequestBody String data) {
		String str = "";
		JSONObject jObj = JSONObject.fromObject(data);
		String nickName = jObj.getString("nickName");
		nickname_sessionid = (Map<String, String>) session.getServletContext().getAttribute("nickname_sessionid");
		if (!nickname_sessionid.get(nickName).equals(session.getId()))
			str = "repeat";

		return str;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "saveChatRecord")
	@ResponseBody
	public String saveChatRecord(@RequestBody String data){
		String str="";
		JSONObject jObj=JSONObject.fromObject(data);
		String toName=jObj.getString("toName");
		String from=jObj.getString("from");
		String to=jObj.getString("to");
		String content=jObj.getString("content");
		allChatMap=(Map<String,List<Map<String,Object>>>)session.getServletContext().getAttribute("allChatMap");
		
		Map<String,Object> singleChatMap=new HashMap<String,Object>();
		singleChatMap.put("from", from);
		singleChatMap.put("to", to);
		singleChatMap.put("content", content);
		if(name.equals(toName)){
			if(allChatMap.get(toName)!=null){
				singleChatList=allChatMap.get(toName);
				singleChatList.add(singleChatMap);
				if(singleChatList.size()>=100){
					singleChatList.subList(0, 50).clear();
				}
				allChatMap.put(toName, singleChatList);
				session.getServletContext().setAttribute("allChatMap",allChatMap);
			}else{
				singleChatList=new ArrayList<Map<String,Object>>();
				singleChatList.add(singleChatMap);
				allChatMap.put(toName, singleChatList);
				session.getServletContext().setAttribute("allChatMap",allChatMap);
			}
		}else{
			name=toName;
			if(allChatMap.get(name)!=null){
				singleChatList=allChatMap.get(name);
				singleChatList.add(singleChatMap);
				if(singleChatList.size()>=100){
					singleChatList.subList(0, 50).clear();
				}
				allChatMap.put(name, singleChatList);
				session.getServletContext().setAttribute("allChatMap",allChatMap);
			}else{
				singleChatList=new ArrayList<Map<String,Object>>();
				singleChatList.add(singleChatMap);
				allChatMap.put(name, singleChatList);
				session.getServletContext().setAttribute("allChatMap",allChatMap);
			}
		}

		return str;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "getSingleChatList")
	@ResponseBody
	public String getSingleChatList(@RequestBody String data){
		String str="";
		JSONObject jObj=JSONObject.fromObject(data);
		String toName=jObj.getString("toName");
		allChatMap=(Map<String,List<Map<String,Object>>>)session.getServletContext().getAttribute("allChatMap");
		if(allChatMap.get(toName)!=null){
			singleChatList=allChatMap.get(toName);
			str=JSONArray.fromObject(singleChatList).toString();
		}
		return str;
	}
}
