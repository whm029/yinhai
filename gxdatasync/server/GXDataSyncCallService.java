package com.yinhai.gxdatasync.server;

import javax.jws.WebService;


@WebService
public interface GXDataSyncCallService {

	/**-------------------------------------<br>
	 * @title: gxDataSyncWSCall
	 * @description: 高新服务端接口
	 * @return: java.lang.String
	 * @date: 2019/9/14 22:14
	 * @A19
	 * -------------------------------------<br>
	 */
	 String gxDataSyncWSCall(String jybh, String inXml);
}
