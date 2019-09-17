package com.yinhai.gxdatasync.test;

import com.yinhai.gxdatasync.server.GXDataSyncCallService;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;


/**
 * @author 
 * 测试类，客户端其他的类，通过apache-cxf-2.2.5\bin下的wsdl2java.bat生成
 * 
 * dos切换到apache-cxf-2.2.5\bin下wsdl2java.bat所在目录
 * 输入
 * wsdl2java 加上空格 加上wsdl的url
 * 回车
 * GxDataSharingServiceCall
 */
public class TestGXDataSync {
	@SuppressWarnings("unchecked")
	public static void main(String[] args) throws Exception {


		String wSAddress = "http://127.0.0.1:8066/xagxsi/services/gxDataSyncCallService?wsdl";
		JaxWsProxyFactoryBean jaxWsProxyFactoryBean = new JaxWsProxyFactoryBean();
		jaxWsProxyFactoryBean.setServiceClass(GXDataSyncCallService.class);
		jaxWsProxyFactoryBean.setAddress(wSAddress);
		GXDataSyncCallService dataService = (GXDataSyncCallService)jaxWsProxyFactoryBean.create();
		String result = dataService.gxDataSyncWSCall("111","2222");
		System.out.println(result);


	}

}
