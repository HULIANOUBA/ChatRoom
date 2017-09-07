package cn.hulian.mUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSession;

public class MServletContextListener implements ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		// TODO Auto-generated method stub

		ServletContext sc = arg0.getServletContext();
		Map<String, String> nickname_sessionid = new HashMap<String, String>();
		sc.setAttribute("nickname_sessionid", nickname_sessionid);
		Map<String, List<Map<String, Object>>> allChatMap = new HashMap<String, List<Map<String, Object>>>();
		sc.setAttribute("allChatMap", allChatMap);
	}

}
