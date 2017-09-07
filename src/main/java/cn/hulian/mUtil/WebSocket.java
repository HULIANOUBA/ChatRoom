package cn.hulian.mUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CopyOnWriteArraySet;
import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import net.sf.json.JSONObject;
import cn.hulian.mUtil.GetHttpSessionConfigurator;

@ServerEndpoint(value = "/chat/{nickName}",configurator=GetHttpSessionConfigurator.class)
public class WebSocket {
	private static int onlineCount = 0;
	private static CopyOnWriteArraySet<WebSocket> webSocketSet = new CopyOnWriteArraySet<WebSocket>();
	private Session session;
	private String nickName = "";
	private Map<String, Object> map = null;
	private HttpSession httpSession;
	private static List<String> nickNameList=new ArrayList<String>();
	private static Map<String,Object> sessionMap=new HashMap<String,Object>();
	
	
	@OnOpen
	public void onOpen(@PathParam("nickName")String nickName,EndpointConfig config, Session session) throws IOException {
		System.out.println("已连接");
		httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
		this.session = session;
		this.nickName=nickName;
		webSocketSet.add(this);
		addOnlineCount();
		sessionMap.put(nickName, session);
		map = new HashMap<String, Object>();
		map.put("type", "system");
		map.put("from", nickName);
		map.put("onlineCount", getOnlineCount());
		map.put("content", " 进入聊天室");
		nickNameList.add((String)httpSession.getAttribute("nickName"));
		map.put("nickNameList", nickNameList);
		JSONObject jObj = JSONObject.fromObject(map);
		broadcastMsg(jObj.toString());
	}

	@OnClose
	public void onClose() throws IOException {
	    
		webSocketSet.remove(this);
		subOnlineCount();
		sessionMap.remove(nickName);
		map = new HashMap<String, Object>();
		map.put("type", "system");
		map.put("from",nickName);
		map.put("onlineCount", getOnlineCount());
		map.put("content", " 离开了聊天室");
		
		Iterator<String> i=nickNameList.iterator();
		while(i.hasNext()){
			if(nickName.equals(i.next())){
				i.remove();
				break;
			}
				
			
		}
		map.put("nickNameList", nickNameList);
		JSONObject jObj = JSONObject.fromObject(map);
		broadcastMsg(jObj.toString());
		httpSession.removeAttribute("nickName");
	}
	
	@OnMessage
	public void onMessage(String msg) throws IOException{
		JSONObject jObj = JSONObject.fromObject(msg);
		String type=jObj.getString("type");
		String from=jObj.getString("from");
		String content=jObj.getString("content");
		String to=jObj.getString("to");
		String time=jObj.getString("time");
		
		
		
		map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("from",from);
		map.put("content",content);
		map.put("to", to);
		map.put("time", time);
		JSONObject jObj_1 = JSONObject.fromObject(map);
		
		if(to.equals("public"))
			broadcastMsg(jObj_1.toString());
		else{
			if(from.equals(to)){
				singleSend(jObj_1.toString(),(Session)sessionMap.get(from));
			}else{
			    singleSend(jObj_1.toString(),(Session)sessionMap.get(from));
			    singleSend(jObj_1.toString(),(Session)sessionMap.get(to));
			}
		}
	}
	
	@OnError
	public void onError(Throwable t){
		t.getStackTrace();
	}

	public void broadcastMsg(String msg) throws IOException {
		for (WebSocket client : webSocketSet) {
			client.session.getBasicRemote().sendText(msg);
		}
	}
	public void singleSend(String message, Session session){
        try {
            session.getBasicRemote().sendText(message);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
	public static synchronized int getOnlineCount() {
		return onlineCount;
	}

	public static synchronized void addOnlineCount() {
		WebSocket.onlineCount++;
	}

	public static synchronized void subOnlineCount() {
		WebSocket.onlineCount--;
	}
}
