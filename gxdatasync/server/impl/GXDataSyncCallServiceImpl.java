package com.yinhai.gxdatasync.server.impl;

import com.yinhai.gxdatasharing.util.GxDataSharingConstant;
import com.yinhai.gxdatasync.server.GXDataSyncCallService;
import com.yinhai.gxdatasync.util.GXDataSyncConstant;
import com.yinhai.gxdatasync.util.GxDataSyncUtil;
import com.yinhai.sysframework.dto.PrcDTO;
import com.yinhai.sysframework.exception.AppException;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.xagxsi.common.common.service.impl.BaseCommonServiceImpl;
import com.yinhai.xagxsi.common.common.util.StringUtil;

import javax.jws.WebService;
import java.util.List;
import java.util.Map;

@WebService
public class GXDataSyncCallServiceImpl extends BaseCommonServiceImpl implements GXDataSyncCallService {

  /**
   * @description: 高新服务端接口
   * @title: gxDataSyncWSCall
   * @return: java.lang.String
   * @date: 2019/9/14 22:14
   * @A19
   */
  @Override
  public String gxDataSyncWSCall(String jybh, String inXml) {

    StringBuffer result = new StringBuffer(GXDataSyncConstant.XMLHEADER);
    Map<String, String> inMap = null;

    Map jylshMap = (Map) dao.queryForObject("baseComm.queryAAE790");

    /* 交易编号非空判断 */
    if (ValidateUtil.isEmpty(jybh)) {
      result.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("交易编号为空，请检查!").append("</message></result>");
      return result.toString();
    }
    /* 传入参数非空判断 */
    if (ValidateUtil.isEmpty(inXml)) {
      result.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("传入参数为空，请检查!").append("</message></result>");
      return result.toString();
    }
    /* 判断解析入参是否成功 */
    try {
      inMap = GxDataSyncUtil.xmlToMap(inXml);
    } catch (Exception e) {
      result.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("XML字符串解析出错!").append(e.getMessage()).append("</message></result>");
      return result.toString();
    }
    /* 再次判断解析后是否有参数 */
    if (ValidateUtil.isEmpty(inMap)) {
      result.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("传入参数为空，请检查!").append("</message></result>");
      return result.toString();
    }
    /* 交易 */
    inMap.put("jylsh", jylshMap.get("aae790") + "");
    if (GXDataSyncConstant.SERVICE_YHWS001.equals(jybh)) {
      result.append(this.serviceYHWS001(jybh, inMap));
    } else if (GXDataSyncConstant.SERVICE_YHWS002.equals(jybh)) {
      //result.append(serviceYHWS002(jybh,paramList));
    } else {
      result.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("交易编号不存在，请检查!").append("</message></result>");
    }
    inMap.put("jybh", jybh);
    inMap.put("qqbw", inXml);
    inMap.put("fhbw", result.toString());
    this.callLog(inMap);
    return result.toString();
  }


  /**
   * @description: 调用修改密码方法
   * @title: serviceYHWS001
   * @return: java.lang.String
   * @date: 2019/9/24 0:01
   * @A19
   */
  public String serviceYHWS001(String jybh, Map<String, String> inMap) {
    StringBuffer sb = new StringBuffer();
    String result = "";
    try {
      Integer i = modifyPassword(inMap); // 执行修改密码
      if (i == 1) {
        sb.append("<result><code>").append(GXDataSyncConstant.NOERROR).append("</code><message>").append(GXDataSyncConstant.SERVICE_YHWS001).append("交易完成!").append("</message></result>");
        result = sb.toString();
      } else {
        sb.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("交易无效!").append("</message></result>");
      }
    } catch (Exception e) { // 校验出现异常返回失败gxXml
      sb.append("<result><code>").append(GXDataSyncConstant.ERROR).append("</code><message>").append("返回失败:").append(e).append("</message></result>");
      result = sb.toString();
    }
    return result;
  }



  /**
   * @description: 修改网厅用户密码
   * @title: modifyPassword
   * @return: java.lang.Integer
   * @date: 2019/9/19 1:57
   * @A19
   */
  public Integer modifyPassword(Map<String, String> inMap) {
    inMap.put("pwdjm", StringUtil.omlx_liangxian_omlx(inMap.get("password"))); //密码加密
    dao.insert("gxDataSync.insertPwdModifyLog", inMap); //写密码日志
    Integer i = dao.update("gxDataSync.updateXagxwtUserPwd", inMap); //修改密码
    return i;
  }



  /**
   * @description: 接口调用日志
   * @title: callLog
   * @return: void
   * @date: 2019/9/23 23:58
   * @A19
   */
  public void callLog(Map<String, String> inMap) {
    dao.insert("gxDataSync.insertYHJKlog", inMap); //写密码日志
  }
}
