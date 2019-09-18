package com.yinhai.gxdatasync.util;

import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.headers.Header;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.phase.AbstractPhaseInterceptor;
import org.apache.cxf.phase.Phase;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.List;

/**
 * 使用拦截器在服务端校验Header(用户名密码)
 */
public class AuthInterceptor extends AbstractPhaseInterceptor<SoapMessage> {

  public AuthInterceptor() {
    /*
    super表示显式调用父类有参数的构造器,显示调用父类构造器,程序将不会隐式调用父类无参的构造器。
    父类构造器里方法AbstractPhaseInterceptor(String phase),phase是指一个拦截阶段,CXF文档里有Phase类,这个类里有各个阶段
    */
    super(Phase.PRE_INVOKE);//该拦截器将会在"调用之前"拦截Soap消息。
  }



  /*
  实现自己的拦截器时,需要实现handleMessage方法,handleMessage方法中的形参就是被拦截到的Soap消息,获得Soap消息,剩下的事情就可以解析Soap消息,或修改Soap消息
  */
  @Override
  public void handleMessage(SoapMessage soapMessage) throws Fault {

    List<Header> headers = new ArrayList<Header>(); // 得到Soap消息的所有Header
    try {
      headers = soapMessage.getHeaders();
    } catch (Exception e) {
      throw new Fault(new IllegalArgumentException("获取Header失败，禁止调用！"));
    }
    if (headers == null || headers.size() < 1) { //如果根本没有Header
      throw new Fault(new IllegalArgumentException("没有Header，禁止调用！"));
    }

    Header firstHeader = headers.get(0); //假如要求第一个Header携带了用户名密码信息
    Element ele = (Element) firstHeader.getObject();
    NodeList spId = ele.getElementsByTagName("tns:spId");
    NodeList spPwd = ele.getElementsByTagName("tns:spPwd");

    if (spId == null || spId.getLength() != 1) {
      throw new Fault(new IllegalArgumentException("用户名格式不正确！"));
    }
    if (spPwd == null || spPwd.getLength() != 1) {
      throw new Fault(new IllegalArgumentException("密码格式不正确！"));
    }
    String userid = spId.item(0).getTextContent(); // 获取spId元素里的文本内容,以该内容作为用户名
    String password = spPwd.item(0).getTextContent(); // 获取spPwd元素里的文本内容,以该内容作为密码

    if (!"admin".equals(userid) || !"admin".equals(password)) { // 验证用户名密码是否正确
      throw new Fault(new IllegalArgumentException("用户名、密码不正确！"));
    }
  }
}