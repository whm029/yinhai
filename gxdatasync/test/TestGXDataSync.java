package com.yinhai.gxdatasync.test;

import com.yinhai.common.webservice.security.AddSoapHeader;
import com.yinhai.gxdatasync.server.GXDataSyncCallService;
import com.yinhai.gxdatasync.util.GXDataSyncConstant;
import com.yinhai.gxdatasync.util.GxDataSyncUtil;
import org.apache.cxf.jaxws.JaxWsProxyFactoryBean;
import org.apache.cxf.interceptor.Interceptor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


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


		String wsAddress = GXDataSyncConstant.YHWEBSERVICEADDRESS;
		JaxWsProxyFactoryBean jaxWsProxyFactoryBean = new JaxWsProxyFactoryBean();

		/* 添加拦截器 start*/
		ArrayList<Interceptor> list = new ArrayList<Interceptor>();
		list.add(new HeaderInterceptor()); // 添加soap header
		//list.add(new org.apache.cxf.interceptor.LoggingOutInterceptor()); // 添加soap消息日志打印
		jaxWsProxyFactoryBean.setOutInterceptors(list);
		/* 添加过滤器 end*/
		jaxWsProxyFactoryBean.setServiceClass(GXDataSyncCallService.class);
		jaxWsProxyFactoryBean.setAddress(wsAddress);

		GXDataSyncCallService callService = (GXDataSyncCallService)jaxWsProxyFactoryBean.create();

		Map inMap = new HashMap<String,String>();
		inMap.put("loginid","899999");
		inMap.put("password","000000");

 		String inXml = GxDataSyncUtil.mapToXmlTest(inMap);
		String output = callService.gxDataSyncWSCall(GXDataSyncConstant.SERVICE_YHWS001,inXml);
		System.out.println(output);


	}

}
