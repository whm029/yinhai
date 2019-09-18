package com.yinhai.gxdatasync.test;

import com.yinhai.gxdatasync.util.GXDataSyncConstant;
import org.apache.cxf.binding.soap.SoapMessage;
import org.apache.cxf.binding.soap.interceptor.AbstractSoapInterceptor;
import org.apache.cxf.helpers.DOMUtils;
import org.apache.cxf.interceptor.Fault;
import org.apache.cxf.phase.Phase;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import javax.xml.namespace.QName;

import org.apache.cxf.binding.soap.SoapHeader;
import org.apache.cxf.headers.Header;

import java.util.List;

/**
 * 使用拦截器在客户端添加Header(用户名密码)
 */
public class HeaderInterceptor extends AbstractSoapInterceptor {

  String wsAddress = GXDataSyncConstant.YHWEBSERVICEADDRESS;



  public HeaderInterceptor() {
    super(Phase.WRITE);
  }



  @Override
  public void handleMessage(SoapMessage soapMessage) throws Fault {

    String userid = "admin";
    String password = "admin";

    QName qname = new QName("RequestSOAPHeader");
    Document doc = DOMUtils.createDocument();

    Element spId = doc.createElement("tns:spId"); // 自定义节点spId
    spId.setTextContent(userid); // 给spId节点设置文本内容
    Element spPwd = doc.createElement("tns:spPwd"); // 自定义节点spPwd
    spPwd.setTextContent(password); // 给spPwd节点设置文本内容

    Element root = doc.createElementNS(wsAddress, "tns:RequestSOAPHeader");
    root.appendChild(spId);
    root.appendChild(spPwd);
    SoapHeader head = new SoapHeader(qname, root);
    List<Header> headers = soapMessage.getHeaders();
    headers.add(head);
    System.out.println(">>>>>添加header完成<<<<<<<");
  }
}
