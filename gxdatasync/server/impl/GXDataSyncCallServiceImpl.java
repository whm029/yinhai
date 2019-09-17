package com.yinhai.gxdatasync.server.impl;

import com.yinhai.gxdatasync.server.GXDataSyncCallService;
import com.yinhai.gxdatasync.util.GXDataSyncConstant;
import com.yinhai.gxdatasync.util.GxDataSyncUtil;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.xagxsi.common.common.service.impl.BaseCommonServiceImpl;

import javax.jws.WebService;
import java.util.List;
import java.util.Map;

@WebService
public class GXDataSyncCallServiceImpl extends BaseCommonServiceImpl implements GXDataSyncCallService {

  @Override
  public String gxDataSyncWSCall(String jybh, String inXml) {

    
    /*
    String outStr ="<output><appcode>SUCCESS</appcode><errormsg>NOERROR</errormsg></output>";

    if (GXDataSyncConstant.SERVICE_YHWS001.equals(jybh)) {
      //outStr = save01(inStr);
    } else if (GXDataSyncConstant.SERVICE_YHWS002.equals(jybh)) {
      //outStr = save02(inStr);
    } else if (ValidateUtil.isEmpty(inXml)) {
      outStr = GXDataSyncConstant.XMLHEADER + "<output><appcode>NOSUCCESS</appcode><errormsg>传入参数为空</errormsg></output>";
    } else {
      outStr = GXDataSyncConstant.XMLHEADER + "<output><appcode>NOSUCCESS</appcode><errormsg>交易号不存在</errormsg></output>";
    }
    return outStr;
    */

    StringBuffer output = new StringBuffer(GXDataSyncConstant.XMLHEADER);
    List<Map> paramList = null;

    //交易编号非空判断
    if(ValidateUtil.isEmpty(jybh)){
      output.append("<output><code>NOSUCCESS</code><message>交易编号为空，请检查</message></output>");
      return output.toString();
    }
    //传入参数非空判断
    if(ValidateUtil.isEmpty(inXml)){
      output.append("<output><code>NOSUCCESS</code><message>传入参数为空，请检查</message></output>");
      return output.toString();
    }

    try {
      paramList = GxDataSyncUtil.xmlToList(inXml);
    } catch (Exception e) {
      output.append("<output><code>NOSUCCESS</code><message>xml字符串解析出错"+e.getMessage()+"</message></output>");
      return output.toString();
    }

    //再次判断解析后是否有参数
    if(ValidateUtil.isEmpty(paramList)){
      output.append("<output><code>NOSUCCESS</code><message>传入参数为空，请检查</message></output>");
      return output.toString();
    }

    //判断交易
    if(GXDataSyncConstant.SERVICE_YHWS001.equals(jybh)){
      //output.append(service001(jybh,paramList));
    }else if(GXDataSyncConstant.SERVICE_YHWS002.equals(jybh)){
      //output.append(service001(jybh,paramList));
    }else {
      output.append("<output><code>NOSUCCESS</code><message>交易编号不存在，请检查</message></output>");
    }

    return output.toString();
  }


  /**
   * 单位新参保
   * @param inStr
   * @return
   *//*
	public String save01(String inStr){
		String msg = "";
		String outStr = null;
		Map ae15a1Map = new HashMap();
		try {
			ae15a1Map = newInsertAb01Service.toSave(inStr);
			msg = (String) ae15a1Map.get("errormsg");
			ae15a1Map.put("jybh", "01");
			if(ValidateUtil.isEmpty(msg)){//数据无误，新参保成功
				outStr = XMLHEADER + "<output><appcode>"+ISOK+"</appcode><errormsg>"+ "新参保成功"+"</errormsg></output>";
				ae15a1Map.put("appcode", ISOK);
				ae15a1Map.put("yae031", ISOK);
				railroadCommService.insertAe15a1(ae15a1Map);
			}else{
				outStr = XMLHEADER + "<output><appcode>"+ISNOOK+"</appcode><errormsg>"+ msg+"</errormsg></output>";
				ae15a1Map.put("appcode", ISNOOK);
				ae15a1Map.put("yae031", ISNOOK);
				railroadCommService.insertAe15a1(ae15a1Map);
			}
		} catch (Exception e) {
			outStr = XMLHEADER + "<output><appcode>"+ISNOOK+"</appcode><errormsg>"+ e.getMessage()+"</errormsg></output>";
			ae15a1Map.put("jybh", "01");
			ae15a1Map.put("errormsg", e.getMessage());
			ae15a1Map.put("appcode", ISNOOK);
			ae15a1Map.put("yae031", ISNOOK);
			railroadCommService.insertAe15a1(ae15a1Map);
		}
		return outStr;
	}*/

}
