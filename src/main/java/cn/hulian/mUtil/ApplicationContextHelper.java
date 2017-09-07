package cn.hulian.mUtil;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class ApplicationContextHelper implements ApplicationContextAware {

	private static ApplicationContext mApplicationContext;

	@Override
	public void setApplicationContext(ApplicationContext mApplicationContext) throws BeansException {
		// TODO Auto-generated method stub
		this.mApplicationContext = mApplicationContext;
	}

	public static ApplicationContext getApplicationContext() {
		return mApplicationContext;
	}
}
