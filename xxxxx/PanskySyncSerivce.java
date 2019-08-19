package com.yinhai.nethall.nethallcommon.service;

import com.alibaba.fastjson.JSONObject;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public interface PanskySyncSerivce {

  /**-------------------------------------<br>
   * @title: sayHiPanSky
   * @description: 测试给长天提供的接口
   * @return: java.lang.String
   * @date: 2019/8/19 11:11
   * @A19
   * -------------------------------------<br>
   */
@WebMethod(action="http://service.nethallcommon.nethall.yinhai.com/wsPSSyncSerivce")
  public String sayHiPanSky(String name) throws Exception;





}
