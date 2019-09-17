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

public class AuthInterceptor extends AbstractPhaseInterceptor<SoapMessage> {
  public AuthInterceptor(){
    //super表示显示调用父类有参数的构造器。
    //显示调用父类构造器，程序将不会隐式调用父类无参的构造器。
    //---父类构造器里方法AbstractPhaseInterceptor(String phase)
    //---phase是指一个拦截阶段
    //---CXF文档里有Phase类，这个类里有各个阶段
    super(Phase.PRE_INVOKE);//该拦截器将会在"调用之前"拦截Soap消息。
  }
  //实现自己的拦截器时，需要实现handleMessage方法。
  //handleMessage方法中的形参就是被拦截到的Soap消息。
  //一旦程序获得了Soap消息，剩下的事情就可以解析Soap消息，或修改Soap消息。
  @Override
  public void handleMessage(SoapMessage msg) throws Fault {
    //下面代码显示"调用之前"成功拦截了信息
    System.out.println("----------------"+ msg);
    //得到Soap消息的所有Header
    List<Header> headers = new ArrayList<Header>();
    try {
      headers = msg.getHeaders();
    } catch (Exception e) {
      throw new Fault(new IllegalArgumentException("没有Header，禁止调用！"));
    }
    //如果根本没有Header
    if(headers == null || headers.size() < 1 ){
      throw new Fault(new IllegalArgumentException("没有Header，禁止调用！"));
    }
    System.out.println("headers" + headers);
    //假如要求第一个Header携带了用户名、密码信息
    Header firstHeader = headers.get(0);
    Element ele = (Element)firstHeader.getObject();
    NodeList userIds = ele.getElementsByTagName("wsse:Username");
    NodeList passwords = ele.getElementsByTagName("wsse:Password");
    if(userIds == null || userIds.getLength() != 1){
      throw new Fault(new IllegalArgumentException("用户名格式不正确！"));
    }
    if(passwords == null || passwords.getLength() != 1){
      throw new Fault(new IllegalArgumentException("密码格式不正确！"));
    }
    System.out.println("userIds" + userIds);
    System.out.println("passwords" + passwords);
    //得到userId元素里的文本内容，以该内容作为用户名
    String userId = userIds.item(0).getTextContent();
    String password = passwords.item(0).getTextContent();
    //实际项目中，是去查询数据库，该用户名、密码是否被授权访问该Web Service。
    if(!"admin".equals(userId) || !"admin".equals(password)){
      throw new Fault(new IllegalArgumentException("用户名、密码不正确！"));
    }
  }
}