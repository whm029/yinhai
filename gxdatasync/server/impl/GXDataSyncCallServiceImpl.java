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
import java.util.Map;

@WebService
public class GXDataSyncCallServiceImpl extends BaseCommonServiceImpl implements GXDataSyncCallService {

  @Override
  public String gxDataSyncWSCall(String jybh, String inXml) {

    StringBuffer result = new StringBuffer(GXDataSyncConstant.XMLHEADER);
    Map<String, String> paramMap = null;

    //交易编号非空判断
    if (ValidateUtil.isEmpty(jybh)) {
      result.append("<result><code>" + GXDataSyncConstant.ERROR + "</code><message>交易编号为空，请检查</message></result>");
      return result.toString();
    }
    //传入参数非空判断
    if (ValidateUtil.isEmpty(inXml)) {
      result.append("<result><code>" + GXDataSyncConstant.ERROR + "</code><message>传入参数为空，请检查</message></result>");
      return result.toString();
    }

    try {
      paramMap = GxDataSyncUtil.xmlToMap(inXml);
    } catch (Exception e) {
      result.append("<result><code>" + GXDataSyncConstant.ERROR + "</code><message>xml字符串解析出错" + e.getMessage() + "</message></result>");
      return result.toString();
    }

    //再次判断解析后是否有参数
    if (ValidateUtil.isEmpty(paramMap)) {
      result.append("<result><code>" + GXDataSyncConstant.ERROR + "</code><message>传入参数为空，请检查</message></result>");
      return result.toString();
    }

    //判断交易
    if (GXDataSyncConstant.SERVICE_YHWS001.equals(jybh)) {
      result.append(serviceYHWS001(jybh, paramMap));
    } else if (GXDataSyncConstant.SERVICE_YHWS002.equals(jybh)) {
      //result.append(serviceYHWS002(jybh,paramList));
    } else {
      result.append("<result><code>" + GXDataSyncConstant.ERROR + "</code><message>交易编号不存在，请检查</message></result>");
    }

    return result.toString();
  }



  public String serviceYHWS001(String jybh, Map<String, String> paramMap) {


    Integer i = modifyPassword(paramMap);


    String gxXml = "";

    /*String yae099 = (String)((Map) paramList.get(0)).get("yae099");
    //先删除高新临时表数据
    dao.delete("gxdataSharing.delete_tmp_ac01_aae140",yae099);

    //校验第一步：将list插入高新临时表
    dao.insertBatch("gxdataSharing.insert_tmp_ac01_aae140", paramList);
    try {
      //校验第二步：调高新校验过程
      String gxInfo =validateData(jybh,yae099);
      Map map = new HashMap();
      map.put("yae099", yae099);
      //校验完成返回成功gxXml
      if("NOERROR".equals(gxInfo)){
        List list = dao.queryForList("gxdataSharing.query_tmp_ac01_aae140",map);
        gxXml = GxDataSyncUtil.returnToXml("1","返回成功",list);
      }
    } catch (Exception e) {
      //校验出现异常返回失败gxXml
      StringBuffer sb = new StringBuffer();
      sb.append("<result><code>")
          .append("2")
          .append("</code><message>")
          .append("返回失败:")
          .append(e)
          .append("</message>");
      gxXml = sb.toString();
    }*/


    return gxXml;
  }



  /**
   * -------------------------------------<br>
   *
   * @title: modifyPassword
   * @description: 修改网厅用户密码
   * @return: java.lang.Integer
   * @date: 2019/9/19 1:57
   * @A19 -------------------------------------<br>
   */
  public Integer modifyPassword(Map<String, String> inMap) {
    inMap.put("pwdjm", StringUtil.omlx_liangxian_omlx(inMap.get("password"))); //密码加密
    //dao.insert("yhwtuserinfo.insertPwdModifyLog", inMap); //写日志
    Integer i = dao.update("gxDataSync.updateXagxwtUserPwd", inMap); //修改密码
    return i;
  }



  /**
   * -------------------------------------<br>
   *
   * @title: validateData
   * @description: 数据校验
   * @return: java.lang.String
   * @date: 2019/9/19 1:57
   * @A19 -------------------------------------<br>
   */
  private String validateData(String jybh, String yae099) throws Exception {
    String prc_code = "";
    String prc_msg = "";

    //校验交易编号是否为空
    if (ValidateUtil.isEmpty(jybh)) {
      prc_msg = "数据校验，交易编号为空，请检查";
      return prc_msg;
    }

    //调用过程进行数据校验
    PrcDTO prcDTO = new PrcDTO();
    prcDTO.put("prm_jybh", jybh);
    prcDTO.put("prm_yae099", yae099);
    dao.callPrc("gxdataSharing.prc_p_dataValidation", prcDTO);
    //校验结果
    prc_code = prcDTO.getAsString("AppCode");//返回编码
    prc_msg = prcDTO.getAsString("ErrorMsg");//返回信息
    if (!(GxDataSharingConstant.NOERROR).equals(prc_code)) {
      throw new AppException(prc_msg);
    }
    return GxDataSharingConstant.NOERROR;
  }

}
