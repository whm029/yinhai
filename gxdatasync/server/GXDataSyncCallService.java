package com.yinhai.gxdatasync.server;

import javax.jws.WebParam;
import javax.jws.WebService;


@WebService(targetNamespace = "ws.com/")
public interface GXDataSyncCallService {


  /**
   * @description: 高新服务端接口
   * @title: gxDataSyncWSCall
   * @return: java.lang.String
   * @date: 2019/9/14 22:14
   * @A19
   */
  String gxDataSyncWSCall(@WebParam(name = "jybh") String jybh, @WebParam(name = "inXml") String inXml);
}