package com.yinhai.nethall.nethallcommon.service.impl;

import com.yinhai.nethall.nethallcommon.service.PanskySyncSerivce;
import com.yinhai.nethall.nethallcommon.utils.XmlConverUtil;

import javax.jws.WebService;
import java.util.HashMap;
import java.util.Map;


//http://localhost:8068/yhwtqt/services/wsPSSyncSerivce?wsdl


@WebService(targetNamespace = "http://impl.service.nethallcommon.nethall.yinhai.com/", endpointInterface="com.yinhai.nethall.nethallcommon.service.PanskySyncSerivce",serviceName = "psSyncService")
public class PanskySyncSerivceImpl implements PanskySyncSerivce {

  @Override
  public String sayHiPanSky(String name) throws Exception {
    Map map = new HashMap();
    map.put("username","ek");
    map.put("password","111");
    return  XmlConverUtil.map2Xml(map);
  }
}


