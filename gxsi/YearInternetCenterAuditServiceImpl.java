package com.yinhai.xagxsi.internetaudit.basicbusi.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.yinhai.sysframework.app.domain.Key;
import com.yinhai.sysframework.dto.ParamDTO;
import com.yinhai.sysframework.dto.PrcDTO;
import com.yinhai.sysframework.exception.AppException;
import com.yinhai.sysframework.service.BaseService;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.xagxsi.internetaudit.basicbusi.service.YearInternetCenterAuditService;

public class YearInternetCenterAuditServiceImpl extends BaseService implements YearInternetCenterAuditService {

  public List getAuditInfo(ParamDTO dto) {
    return dao.queryForList("yearaudit.getAuditInfo", dto);
  }



  public List getPerInfo(ParamDTO dto) throws Exception {
    List list = dao.queryForList("yearaudit.getTMP_ac42", dto);
    return list;
  }



  public String updatePass(ParamDTO dto) throws Exception {
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", dto.getAsString("aab001"));
    prcDto.put("prm_aae001", dto.getAsInteger("aae001"));
    prcDto.put("prm_iaa018", dto.getAsString("iaa018"));
    prcDto.put("prm_yae092", dto.getAsString("yae092"));
    prcDto.put("prm_iaa011", dto.getAsString("iaa011"));
    prcDto.put("prm_yab019", dto.getAsString("yab019"));
    dao.callPrc("yearaudit.yearApply_prc_YearInternetAudit", prcDto);
    return prcDto.getErrorMsg();
  }



  public String updateNoPass(ParamDTO dto) throws Exception {
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", dto.getAsString("aab001"));
    prcDto.put("prm_aae001", dto.getAsInteger("aae001"));
    prcDto.put("prm_iaa018", dto.getAsString("iaa018"));
    prcDto.put("prm_yae092", dto.getAsString("yae092"));
    prcDto.put("prm_iaa011", dto.getAsString("iaa011"));
    prcDto.put("prm_yab019", dto.getAsString("yab019"));
    dao.callPrc("yearaudit.yearApply_prc_YearInternetAudit", prcDto);

    if(ValidateUtil.isEmpty(prcDto.get("ErrorMsg"))) {
      Map map = new HashMap();
      String cwzl = dto.getAsString("cwzl");
      if("0".equals(cwzl)){
        map.put("iaa011","A05-2"); //需要携带资料的打回
      }else if("1".equals(cwzl)){
        map.put("iaa011","A05-3"); //一般的打回
      }
      map.put("aab001",dto.getAsString("aab001"));
      map.put("aee011",dto.getAsString("yae092"));
      map.put("aae001",dto.getAsString("aae001"));
      map.put("aae013",dto.getAsString("aae013_1"));
      dao.insert("yearaudit.insertIrad54",map);
    }
    return prcDto.getErrorMsg();
  }



  /**
   * 更新补差金额
   */
  public void updatePerInfo(ParamDTO dto) throws Exception {
    int i = 0;
    i = dao.update("yearaudit.updateTmp_ac42", dto);
    i = dao.update("yearaudit.updateYae001", dto);
    if (i < 0) {
      throw new AppException("更新失败");
    }
  }



  public String insertYearSalaryBc(ParamDTO dto) throws Exception {
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", dto.getAsString("aab001"));
    prcDto.put("prm_aae001", dto.getAsInteger("aae001"));
    prcDto.put("prm_yae092", dto.getAsString("yae092"));
    prcDto.put("prm_iaa011", dto.getAsString("iaa011"));
    prcDto.put("prm_yab019", dto.getAsString("yab019"));
    dao.callPrc("yearaudit.yearApply_prc_YearInternetBC", prcDto);
    return prcDto.getErrorMsg();
  }



  public String removeAudit(ParamDTO dto) throws Exception {
    String aab001 = dto.getAsString("aab001");
    Integer aae001 = dto.getAsInteger("aae001");
    String msg = "";
    if (ValidateUtil.isEmpty(aab001)) {
      msg = "单位编号未获取到！";
      return msg;
    }
    if (ValidateUtil.isEmpty(aae001)) {
      msg = "审核年度未获取到！";
      return msg;
    }
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", aab001);
    prcDto.put("prm_aae001", aae001);
    prcDto.put("prm_iaa011", dto.getAsString("iaa011"));
    prcDto.put("prm_yab019", dto.getAsString("yab019"));
    dao.callPrc("yearaudit.yearApply_prc_YearInternetAuditRB", prcDto);
    msg = prcDto.getErrorMsg();
    return msg;
  }



  public String updateTMP(ParamDTO dto) throws Exception {
    List list = dao.queryForList("yearaudit.getJSJD", dto);
    if (list.size() > 0) {
      int i = 0;
      i = dao.update("yearaudit.updateYae001_1", dto);
      i = dao.update("yearaudit.updateTmpac42", dto);
      if (i < 0) {
        throw new AppException("更新失败");
      }
    }
    return null;
  }



  public void saveShbz(ParamDTO dto) {
    String aee011 = dto.getUserInfo().getUserId();
    String yab003 = dto.getUserInfo().getOrgId();
    String iab001 = (String) this.getDao().queryForObject("yearaudit.getSEQ_IAB001", dto);
    dto.put("aee011", aee011);
    dto.put("yab003", yab003);
    dto.put("aab001", dto.getAsString("aab001_1"));
    dto.put("aae001", dto.getAsString("aae001_1"));
    dto.put("iaa011", dto.getAsString("iaa011_1"));
    dto.put("aae013", dto.getAsString("aae013"));
    dto.put("iab001", iab001);
    dao.insert("yearaudit.insertIrad53", dto);
  }



  public void deleteShbz(ParamDTO dto) {
    int i = dao.delete("yearaudit.deleteIrad53", dto);
    if (i == 0) {
      throw new AppException("删除irad53出错！");
    }

  }



  @SuppressWarnings("unchecked")
  public Map getUnitJSInfo(HashMap map) {
    String year = (String) map.get("aae001");
    String year_0 = String.valueOf(Integer.valueOf(year) - 1);
    //---------------------------------判断
    boolean flag = false;//是否是单养老单位，false-不是，true-是
    Map ab02Count = (Map) dao.queryForObject("yearaudit.ab02Count", map);
    if (ab02Count.get("ab02count").toString().equals("0")) {
      flag = true;
    }
    List list = new ArrayList();
    Map result = (Map) dao.queryForObject("yearaudit.queryUnitInfo_4", map);
    result.put("aae001", year);
    result.put("aae001_0", year_0);
    String aab019 = (String) result.get("aab019");
    map.put("aab019", aab019);
    Map irad51 = (Map) dao.queryForObject("yearaudit.queryIrad51", map);
    String iaz051 = (String) irad51.get("iaz051");
    result.put("time1", irad51.get("aae035"));
    result.put("iaz051", iaz051);//打印编号
    //养老月基数和
    List jsh01 = dao.queryForList("yearaudit.queryUnitJS", map);//单位养老每个月新旧基数
    Map jsh110 = new HashMap();
    String yd = "";
    if (!(jsh01.size() == 0)) {
      for (int i = 0; i < jsh01.size(); i++) {
        jsh110 = (Map) jsh01.get(i);
        yd = (String) jsh110.get("iaa100");
        yd = yd.substring(4);
        if (yd.equals("01")) {
          result.put("yjsh0101", jsh110.get("aab121"));
          result.put("xjsh0101", jsh110.get("xjsh"));
        }
        if (yd.equals("02")) {
          result.put("yjsh0102", jsh110.get("aab121"));
          result.put("xjsh0102", jsh110.get("xjsh"));
        }
        if (yd.equals("03")) {
          result.put("yjsh0103", jsh110.get("aab121"));
          result.put("xjsh0103", jsh110.get("xjsh"));
        }
        if (yd.equals("04")) {
          result.put("yjsh0104", jsh110.get("aab121"));
          result.put("xjsh0104", jsh110.get("xjsh"));
        }
        if (yd.equals("05")) {
          result.put("yjsh0105", jsh110.get("aab121"));
          result.put("xjsh0105", jsh110.get("xjsh"));
        }
        if (yd.equals("06")) {
          result.put("yjsh0106", jsh110.get("aab121"));
          result.put("xjsh0106", jsh110.get("xjsh"));
        }
        if (yd.equals("07")) {
          result.put("yjsh0107", jsh110.get("aab121"));
          result.put("xjsh0107", jsh110.get("xjsh"));
        }
        if (yd.equals("08")) {
          result.put("yjsh0108", jsh110.get("aab121"));
          result.put("xjsh0108", jsh110.get("xjsh"));
        }
        if (yd.equals("09")) {
          result.put("yjsh0109", jsh110.get("aab121"));
          result.put("xjsh0109", jsh110.get("xjsh"));
        }
        if (yd.equals("10")) {
          result.put("yjsh0110", jsh110.get("aab121"));
          result.put("xjsh0110", jsh110.get("xjsh"));
        }
        if (yd.equals("11")) {
          result.put("yjsh0111", jsh110.get("aab121"));
          result.put("xjsh0111", jsh110.get("xjsh"));
        }
        if (yd.equals("12")) {
          result.put("yjsh0112", jsh110.get("aab121"));
          result.put("xjsh0112", jsh110.get("xjsh"));
        }
      }
    }

    //其他险种
    String[] aae140s = {"02", "03", "04", "05"};
    String aae140 = "";
    Map jsh140 = new HashMap();
    for (int i = 0; i < aae140s.length; i++) {
      aae140 = aae140s[i];
      map.put("aae140", aae140);
      String yd1 = "";
      List jsh = dao.queryForList("yearaudit.queryUnitJS_1", map);//单位每个月新旧基数
      if (!(jsh.size() == 0)) {
        for (int j = 0; j < jsh.size(); j++) {
          jsh140 = (Map) jsh.get(j);
          yd1 = (String) jsh140.get("iaa100");
          yd1 = yd1.substring(4);
          if (yd1.equals("01")) {
            result.put("yjsh" + aae140 + "01", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "01", jsh140.get("xjsh"));
          }
          if (yd1.equals("02")) {
            result.put("yjsh" + aae140 + "02", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "02", jsh140.get("xjsh"));
          }
          if (yd1.equals("03")) {
            result.put("yjsh" + aae140 + "03", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "03", jsh140.get("xjsh"));
          }
          if (yd1.equals("04")) {
            result.put("yjsh" + aae140 + "04", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "04", jsh140.get("xjsh"));
          }
          if (yd1.equals("05")) {
            result.put("yjsh" + aae140 + "05", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "05", jsh140.get("xjsh"));
          }
          if (yd1.equals("06")) {
            result.put("yjsh" + aae140 + "06", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "06", jsh140.get("xjsh"));
          }
          if (yd1.equals("07")) {
            result.put("yjsh" + aae140 + "07", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "07", jsh140.get("xjsh"));
          }
          if (yd1.equals("08")) {
            result.put("yjsh" + aae140 + "08", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "08", jsh140.get("xjsh"));
          }
          if (yd1.equals("09")) {
            result.put("yjsh" + aae140 + "09", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "09", jsh140.get("xjsh"));
          }
          if (yd1.equals("10")) {
            result.put("yjsh" + aae140 + "10", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "10", jsh140.get("xjsh"));
          }
          if (yd1.equals("11")) {
            result.put("yjsh" + aae140 + "11", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "11", jsh140.get("xjsh"));
          }
          if (yd1.equals("12")) {
            result.put("yjsh" + aae140 + "12", jsh140.get("aab121"));
            result.put("xjsh" + aae140 + "12", jsh140.get("xjsh"));
          }
        }
      }
    }

    //补差总结
    List jsbcs = dao.queryForList("yearaudit.getJSZC", map);
    Map jsbc = new HashMap();
    for (int i = 0; i < jsbcs.size(); i++) {
      jsbc = (Map) jsbcs.get(i);
      String aae140_1 = (String) jsbc.get("aae140");
      if (aae140_1.equals("01")) {
        result.put("jszc01", jsbc.get("jsbc"));
      }
      if (aae140_1.equals("02")) {
        result.put("jszc02", jsbc.get("jsbc"));
      }
      if (aae140_1.equals("03")) {
        result.put("jszc03", jsbc.get("jsbc"));
      }
      if (aae140_1.equals("04")) {
        result.put("jszc04", jsbc.get("jsbc"));
      }
      if (aae140_1.equals("05")) {
        result.put("jszc05", jsbc.get("jsbc"));
      }
      if (aae140_1.equals("06")) {
        result.put("jszc01", jsbc.get("jsbc"));
      }

    }
    //农民工失业补差
    List sybc = dao.queryForList("yearaudit.getSYBC_01", map);
    if (ValidateUtil.isEmpty(sybc) || (sybc.size() == 0)) {
      result.put("jszc0220", 0);
    } else {
      Map map1 = (Map) sybc.get(0);
      result.put("jszc0220", map1.get("sybc"));
    }

    //起始月度，截止月度
    List aa02a3s = dao.queryForList("yearaudit.getaa02a3_new", map);
    for (int i = 0; i < aa02a3s.size(); i++) {
      Map aa02a3 = (Map) aa02a3s.get(i);
      if (aa02a3.get("aae140").equals("01")) {
        result.put("ksyd_01", aa02a3.get("aae041"));
        result.put("jzyd_01", aa02a3.get("aae042"));
      }
      if (aa02a3.get("aae140").equals("02")) {
        result.put("ksyd_02", aa02a3.get("aae041"));
        result.put("jzyd_02", aa02a3.get("aae042"));
      }
      if (aa02a3.get("aae140").equals("03")) {
        result.put("ksyd_03", aa02a3.get("aae041"));
        result.put("jzyd_03", aa02a3.get("aae042"));
      }
      if (aa02a3.get("aae140").equals("04")) {
        result.put("ksyd_04", aa02a3.get("aae041"));
        result.put("jzyd_04", aa02a3.get("aae042"));
      }
    }
    //1月参保人数
    String cbrs = "";
    if (!flag) {
      cbrs = (String) dao.queryForObject("yearaudit.getCbrs", map);
    }
    //单养老单位
    if (flag) {
      cbrs = (String) dao.queryForObject("yearaudit.getCbrs_1", map);
    }
    result.put("cbrs", cbrs);
    return result;
  }



  @Override
  public boolean checkYLServiceResult(Map m) {
    boolean res = false;
    Integer newEmp = (Integer) dao.queryForObject("yearaudit.checkYLServiceResult", m);
    if (newEmp > 0) {
      res = true;
    } else {
      res = false;
    }
    return res;
  }



  @Override
  public void saveTransferBC(Map m) {

    dao.update("yearaudit.updateIrac01d1", m);
  }



  @Override
  public void removeAb05a1(ParamDTO dto) {
    dao.insert("yearaudit.InsertAb05a1Memo", dto);
    int rows = dao.delete("yearaudit.delAb05a1", dto);
    if (rows < 1) {
      throw new AppException("删除申报基数失败");
    }
  }



  /**
   * 二次补差
   *
   * @param dto
   */
  public String yearSecondSalaryBc(ParamDTO dto) throws Exception {
    PrcDTO prcDto = new PrcDTO();
    String aee011 = dto.getUserInfo().getUserId();
    String yab003 = dto.getUserInfo().getOrgId();

    //查询补差人员列表
    //List keys = dao.queryForList("yearaudit.checkYLServiceResult", m);

    //循环调用养老接口写入基数
		/*for (int i = 0; i < keys.size(); i++) {
			Key key = (Key) keys.get(i);
			ParamDTO dto1 = new ParamDTO();
			dto1.put("aae001", aae001);
			dto1.put("yab003", yab003);
			dto1.putAll(key);
			service.updateYac004(XmlConverUtil.map2Xml(dto1));
			
			//调用养老接口写入
			key.put("aac040", key.getAsBigDecimal("yac004"));
			baseCommService.insertYLINFOBy11(XmlConverUtil.map2Xml(key));
		}*/

    //二次补差
    prcDto.put("prm_aae001", dto.getAsInteger("aae001"));
    prcDto.put("prm_type", "2");
    prcDto.put("prm_aae011", aee011);
    prcDto.put("prm_yab139", yab003);
    dao.callPrc("yearaudit.yearApply_prc_YearSecondInternetBC", prcDto);
    return prcDto.getErrorMsg();
  }
}
