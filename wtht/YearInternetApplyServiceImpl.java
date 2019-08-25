package com.yinhai.nethall.company.yearApply.service.impl;


import com.yinhai.nethall.company.yearApply.service.YearInternetApplyService;
import com.yinhai.nethall.nethallcommon.utils.XmlConverUtil;
import com.yinhai.sysframework.dto.PrcDTO;
import com.yinhai.sysframework.exception.AppException;
import com.yinhai.sysframework.persistence.PageBean;
import com.yinhai.sysframework.service.WsBaseService;
import com.yinhai.sysframework.util.ValidateUtil;
import org.apache.cxf.common.util.Base64Exception;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SuppressWarnings("unchecked")
public class YearInternetApplyServiceImpl extends WsBaseService implements YearInternetApplyService {

  /**
   * 年审页面初始化检查
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String checkYearApply(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", map.get("aab001"));
    prcDto.put("prm_yab139", map.get("yab139"));
    dao.callPrc("yearApply.prc_p_checkInfoByYear", prcDto);
    map.put("aae002", prcDto.getAsString("prm_aae002"));
    map.put("aae001", prcDto.getAsString("prm_aae001"));
    map.put("xx01", prcDto.getAsString("prm_dxby01"));
    map.put("sx01", prcDto.getAsString("prm_gxby01"));
    map.put("xx03", prcDto.getAsString("prm_dxby03"));
    map.put("sx03", prcDto.getAsString("prm_gxby03"));
    map.put("xx60", prcDto.getAsString("prm_dxby60"));
    map.put("sx60", prcDto.getAsString("prm_gxby60"));
    map.put("disabledBtn", prcDto.getAsString("prm_disabledBtn"));
    map.put("msg", prcDto.getAsString("prm_msg"));
    return XmlConverUtil.map2Xml(map);
  }



  /**
   * 查询人员基数信息
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String queryEmps(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    //---------------------------------判断
    boolean flag = false;//是否是单养老单位，false-不是，true-是
    Map ab02Count = (Map) dao.queryForObject("yearApply.ab02Count", map);
    if (ab02Count.get("ab02count").toString().equals("0")) {
      flag = true;
    }
    //----------------------------------
    String aab001 = (String) map.get("aab001");
    String yae092 = (String) map.get("yae092");
    String aae001 = (String) map.get("aae001");
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", aab001);
    prcDto.put("prm_yae092", yae092);
    prcDto.put("prm_aae001", aae001);
    List l = dao.queryForList("yearApply.getCount", map); //查询ac01k8是否有数据
    Map map1 = (Map) l.get(0);
    PageBean ab05a1s;
    if (map1.get("ab05a1count").equals("0")) { //ac01k8没数据则先生成数据 并查询
      if (!flag) { //非单养老单位生成数据
        dao.callPrc("yearApply.yearApply_prc_queryjishu", prcDto);
      }
      if (flag) { //单养老单位生成数据
        dao.callPrc("yearApply.yearApply_prc_YLqueryjishu", prcDto);
      }
      ab05a1s = dao.queryForPageWithCount("yearApply.getAb05a1", map, Integer.parseInt((String) map.get("startrow")), Integer.parseInt((String) map.get("endrow")));
    } else { //ac01k8已有数据则直接查询
      ab05a1s = dao.queryForPageWithCount("yearApply.getAb05a1", map, Integer.parseInt((String) map.get("startrow")), Integer.parseInt((String) map.get("endrow")));
    }


    List list = ab05a1s.getList();
    for (int i = 0; i < list.size(); i++) {
      map = (HashMap) list.get(i);
      map.put("rownum", i + 1);

      /*
      String aac001 = (String) map.get("aac001");
      String aae001_b = aae001 + "01";
      String aae001_e = aae001 + "12";
      map.put("aae001_b", aae001_b);
      map.put("aae001_e", aae001_e);

      Integer ac02_zy = (Integer) dao.queryForObject("yearApply.getac02_zy", aac001);//判断是否为到龄年限不足继续缴费
      if (ac02_zy > 0) {
        map.put("aae013_1", "1");  //写1的挪到过程中了
      }
      Integer Irad51a1_1 = (Integer) dao.queryForObject("yearApply.getIrad51a1_1", map);//判断是否办理过养老保险提前结算.且没有续回原单位
      if (Irad51a1_1 > 0) {
        aae013_1 = "2"; //写2的挪到过程中了
      }
      Integer Irad51a1_2 = (Integer) dao.queryForObject("yearApply.getIrad51a1_2", map);//判断是否办理过养老保险提前结算.且续回原单位
      if (Irad51a1_2 > 0) {
        aae013_1 = "22"; //写22是为了排序,页面不显示了也不用写了 过程中还写了一条21的 是记录结算月份的, 这里21 是续回来的月份要补差的
      }
      dao.update("yearApply.updateAb05a1_1", map);
      */
    }
    ab05a1s.setList(list);

    return XmlConverUtil.PageBean2Xml(ab05a1s);
  }



  /**
   * 更新基数
   *
   * @param map2Xml
   * @throws AppException
   */
  public String updateYac004(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer aae001 = Integer.valueOf(map.get("aae001")+"");
    BigDecimal aac040 = BigDecimal.valueOf(Double.valueOf((String) map.get("aac040")));
    if (aae001 >= 2019) {
      PrcDTO prcDto = new PrcDTO();
      prcDto.put("prm_aab001", map.get("aab001"));
      prcDto.put("prm_aac001", map.get("aac001"));
      prcDto.put("prm_aae001", aae001);
      prcDto.put("prm_aac040", aac040);
      dao.callPrc("yearApply.yearApply_prc_UpdateAc01k8", prcDto);
    } else {
      int i = dao.update("yearApply.updateAb05a1", map);
      if (i < 0) {
        throw new AppException("更新失败");
      }
    }
    return null;
  }



  @Override
  public String getfile(String map2Xml) throws AppException {
    Map<String, String> map = null;
    map = XmlConverUtil.xml2Map(map2Xml);
		/*List list = dao.queryForList("iraa05.getYab109", map);
		if(ValidateUtil.isEmpty(list)){
			throw new AppException("获取登录部门编号异常!");
		}
		Map map1 = (Map)list.get(0);
		String yab109 = (String)map1.get("yab109");
		if(yab109.equalsIgnoreCase("0101")){
			map.put("filetype", "1");		
		}else if(yab109.equalsIgnoreCase("0103")){
			map.put("filetype", "3");
		}else if(yab109.equalsIgnoreCase("0104")){
			//失业稳岗补贴用户
			map.put("filetype", "4");
		}else if(yab109.equalsIgnoreCase("0105")){
			//建筑项目参工伤用户
			map.put("filetype", "5");
		}*/
    List file_list = dao.queryForList("wt_file.getFileInfo", map);
    return XmlConverUtil.list2Xml(file_list);
  }



  @Override
  public String queryByPage(String map2XmlWithPage) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2XmlWithPage);
    PageBean pageBean = dao.queryForPageWithCount("baseComm.queryIRAC08A3INFOS", map, Integer.parseInt((String) map.get("startrow")), Integer.parseInt((String) map.get("endrow")));
    return XmlConverUtil.PageBean2Xml(pageBean);
  }



  /**
   * 检查能否提交申请
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String checkIsApply(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String prm_sign = "0";//0-无错误，1-有错误
    String prm_msg = "";//错误消息
    Integer i = (Integer) dao.queryForObject("yearApply.get51count", map);
    if (i > 0) {
      prm_sign = "1";
      prm_msg = "已有申报记录，不能重复申报！";
    }
    map.put("prm_sign", prm_sign);
    map.put("prm_msg", prm_msg);
    return XmlConverUtil.map2Xml(map);
  }



  /**
   * 年度基数申报
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String updateApply(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String aab001 = (String) map.get("aab001");
    String yae092 = (String) map.get("yae092");
    Integer aae001 = Integer.valueOf((String) map.get("aae001"));
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", aab001);
    prcDto.put("prm_yae092", yae092);
    prcDto.put("prm_aae001", aae001);
    dao.callPrc("yearApply.yearApply_prc_yearInternetApply", prcDto);
    return XmlConverUtil.map2Xml(prcDto);
  }



  /**
   * 年审申请撤销
   *
   * @param map2Xml
   * @throws AppException
   */
  public String updateCancel(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String aab001 = (String) map.get("aab001");
    String yae092 = (String) map.get("yae092");
    Integer aae001 = Integer.valueOf((String) map.get("aae001"));
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", aab001);
    prcDto.put("prm_yae092", yae092);
    prcDto.put("prm_aae001", aae001);
    dao.callPrc("yearApply.yearApply_prc_RByearInternetApply", prcDto);
    return XmlConverUtil.map2Xml(prcDto);
  }



  /**
   * 查看个人补差缴费信息
   *
   * @param map2Xml
   * @return
   * @throws AppException
   * @throws Base64Exception
   */
  public String getPerInfo(String map2Xml) throws Exception {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String aab001 = (String) map.get("aab001");
    String aac001 = (String) map.get("aac001");
    BigDecimal aac040 = BigDecimal.valueOf(Double.valueOf((String) map.get("aac040")));
    Integer aae001 = Integer.valueOf((String) map.get("aae001"));
    String yae092 = (String) map.get("yae092");
    String yab139 = (String) map.get("yab139");
    String yab019 = "1";
    map.put("yab019", yab019);
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", aab001);
    prcDto.put("prm_aac001", aac001);
    prcDto.put("prm_aac040", aac040);
    prcDto.put("prm_aae001", aae001);
    prcDto.put("prm_aae011", yae092);
    prcDto.put("prm_yab139", yab139);
    prcDto.put("prm_yab019", "1");//业务类型标志 1-一般企业，2-机关养老险种
    Integer i = (Integer) dao.queryForObject("yearApply.getBCCount", map);
    int j = i;
    if (j == 0) {
      dao.callPrc("yearApply.yearApply_prc_YearSalaryAdjustPaded", prcDto);
    }
    List list = dao.queryForList("yearApply.getTMP_ac42", map);
    return XmlConverUtil.list2Xml(list);
  }



  /**
   * 年审信息预览
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getPerView(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String aab001 = (String) map.get("aab001");
    String aac001 = (String) map.get("aac001");
    BigDecimal aac040 = new BigDecimal(0);
    Integer aae001 = Integer.valueOf((String) map.get("aae001"));
    String yae092 = (String) map.get("yae092");
    String yab139 = (String) map.get("yab139");
    String yab019 = "1";
    map.put("yab019", yab019);
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", aab001);
    prcDto.put("prm_aac001", aac001);
    prcDto.put("prm_aac040", aac040);
    prcDto.put("prm_aae001", aae001);
    prcDto.put("prm_aae011", yae092);
    prcDto.put("prm_yab139", yab139);
    prcDto.put("prm_yab019", "1");//业务类型标志 1-一般企业，2-机关养老险种
    Integer i = (Integer) dao.queryForObject("yearApply.getBCCount", map);
    int j = i;
    if (j == 0) {
      dao.callPrc("yearApply.yearApply_prc_YearSalaryAdjustPaded", prcDto);
    }
    List list = dao.queryForList("yearApply.getTMP_ac42_ab01", map);
    return XmlConverUtil.list2Xml(list);
  }



  /**
   * 批量更新工资
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String updatePLab05a1(String map2Xml) throws AppException {
    Map inMap = XmlConverUtil.xml2Map(map2Xml);
    String aab001 = inMap.get("aab001") + "";
    List list = (List) inMap.get("ab05a1List");
    String aaz002 = (String) dao.queryForObject("yearApply.getSEQ_AAZ002");
    for (int i = 0; i < list.size(); i++) {
      int flag = 1;
      Map map = (Map) list.get(i);
      map.put("aaz002", aaz002);
      String aae001 = map.get("aae001").toString();
      if (map.get("aab001") == "" || map.get("aab001") == null) {
        flag = 0;
      }
      if (map.get("aac001") == "" || map.get("aac001") == null) {
        flag = 0;
      }
      if (map.get("aac003") == "" || map.get("aac003") == null) {
        flag = 0;
      }
      if (map.get("aac002") == "" || map.get("aac002") == null) {
        flag = 0;
      }
      if (map.get("aac040") == null) {
        map.put("aac040", 0);
      }
      String aac001 = (String) map.get("aac001");
      String aae013 = "";
      String aae001_b = aae001 + "01";
      String aae001_e = aae001 + "12";
      map.put("aae001_b", aae001_b);
      map.put("aae001_e", aae001_e);
      map.put("aab001", aab001);
      Integer ac02_zy = (Integer) dao.queryForObject("yearApply.getac02_zy", aac001);//判断是否为到龄年限不足继续缴费
      if (ac02_zy > 0) {
        aae013 = "1";
      }
      Integer Irad51a1 = (Integer) dao.queryForObject("yearApply.getIrad51a1", map);//判断是否办理过养老保险提前结算
      if (Irad51a1 > 0) {
        aae013 = "2";
      }
      map.put("aae013", aae013);
      dao.insert("yearApply.insertAc40", map);
    }
    for (int i = 0; i < list.size(); i++) {
      Map map1 = (HashMap) list.get(i);
      map1.put("rownum", i + 1);
      String aac001 = (String) map1.get("aac001");
      String aae013 = "";
      String aae001 = map1.get("aae001") + "";
      String aae001_b = aae001 + "01";
      String aae001_e = aae001 + "12";
      map1.put("aae001_b", aae001_b);
      map1.put("aae001_e", aae001_e);
      Integer ac02_zy = (Integer) dao.queryForObject("yearApply.getac02_zy", aac001);//判断是否为到龄年限不足继续缴费
      if (ac02_zy > 0) {
        aae013 = "1";
      }
      Integer Irad51a1 = (Integer) dao.queryForObject("yearApply.getIrad51a1", map1);//判断是否办理过养老保险提前结算
      if (Irad51a1 > 0) {
        aae013 = "2";
      }
      map1.put("aae013", aae013);
      //	dao.update("yearApply.updateAb05a1_1",map1);
    }
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", (String) inMap.get("aab001"));
    prcDto.put("prm_aaz002", aaz002);
    prcDto.put("prm_yae092", (String) inMap.get("yae092"));
    prcDto.put("prm_aae001", (String) inMap.get("aae001"));
    prcDto.put("prm_iaa011", "A05");//企业基数申报
    prcDto.put("prm_yab019", "1");//类型标志
    dao.callPrc("yearApply.yearApply_prc_UpdateAb05a1", prcDto);
    String message = prcDto.getErrorMsg();
    Map result = new HashMap();
    result.put("message", message);
    return XmlConverUtil.map2Xml(result);
  }



  /**
   * 导出人员excel
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getExportData(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    List worker = dao.queryForList("yearApply.getExportData", map);
    List list = new ArrayList();
    for (int i = 0; i < worker.size(); i++) {
      Map mm = (Map) worker.get(i);
      mm.put("aae001", map.get("aae001"));
      Integer count = (Integer) dao.queryForObject("yearApply.getIrac01c1Count", mm);
      if (count > 0) {
        mm.put("aae013", "养老未转入备案");
      }
      list.add(mm);
    }
    return XmlConverUtil.list2Xml(list);
  }



  @Override
  public String get51count_1(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer recordData = (Integer) dao.queryForObject("yearApply.get51count_1", map);
    return recordData.toString();
  }



  @Override
  public String getAb05a1(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    PageBean pageBean = dao.queryForPageWithCount("yearApply.getAb05a1", map, Integer.parseInt((String) map.get("startrow")), Integer.parseInt((String) map.get("endrow")));
    return XmlConverUtil.PageBean2Xml(pageBean);
  }



  /**
   * 查询单位信息
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String queryUnitInfo(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Map result = (Map) dao.queryForObject("yearApply.queryUnitInfo", map);
    if (ValidateUtil.isEmpty(result)) {
      Map mapTemp = new HashMap();
      mapTemp.put("keySet", "isNull");
      return XmlConverUtil.map2Xml(mapTemp);
    }
    result.put("keySet", "isNotNull");
    return XmlConverUtil.map2Xml(result);

  }



  /**
   * 查询险种实际补差list
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String queryBcList(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    List bclist = dao.queryForList("yearApply.zcmx", map);
    return XmlConverUtil.list2Xml(bclist);
  }



  /**
   * 查询人员基数申报信息
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getEmpJSInfo(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String yab019 = (String) map.get("yab019");
    HashMap unitInfo = (HashMap) dao.queryForObject("baseComm.getIrab01", map);
    //---------------------------------判断
    boolean flag = false;//是否是单养老单位，false-不是，true-是
    Map ab02Count = (Map) dao.queryForObject("yearApply.ab02Count", map);
    if (ab02Count.get("ab02count").toString().equals("0")) {
      flag = true;
    }
    Map irad51 = new HashMap();
    List list = new ArrayList();
    if (yab019.equals("1")) {
      if (flag) {
        list = dao.queryForList("yearApply.getEmpJSYL", map);
      } else {
        list = dao.queryForList("yearApply.getEmpJS", map);
      }
      irad51 = (Map) dao.queryForObject("yearApply.queryIrad51", map);
    }
    if (yab019.equals("2")) {
      irad51 = (Map) dao.queryForObject("yearApply.queryIrad51_2", map);
      list = dao.queryForList("yearApply.getEmpJS_2", map);
    }

    String iaz051 = (String) irad51.get("iaz051");
    unitInfo.put("time1", Date.valueOf((String) irad51.get("aae035").toString().substring(0, 10)));
    unitInfo.put("iaz051", iaz051);
    unitInfo.put("ab05a1List", list);
    List ab08s = new ArrayList();
    //年审时最大做账期
    String no = "";
    if (flag) {
      no = (String) dao.queryForObject("yearApply.getMaxYae097ByIrab08", map);
    } else {
      no = (String) dao.queryForObject("yearApply.getMaxYae097ByAb02", map);
    }
    if (no == "" || no == null) {
      throw new AppException("获取单位最大做账期号异常！");
    }
    map.put("aae003", no);
    if (!flag) {
      ab08s = dao.queryForList("yearApply.getAb08_1", map);
    }
    if (flag) {
      ab08s = dao.queryForList("yearApply.getIrab08", map);
    }
    unitInfo.put("No", no);
    for (int i = 0; i < ab08s.size(); i++) {
      Map mapT = (Map) ab08s.get(i);
      String aae140 = (String) mapT.get("aae140");
      if (aae140.equals("01")) {
        unitInfo.put("num_01", mapT.get("yae231"));
        unitInfo.put("sum_u_01", mapT.get("aab121"));
      }
      if (aae140.equals("02")) {
        unitInfo.put("num_02", mapT.get("yae231"));
        unitInfo.put("sum_u_02", mapT.get("aab121"));
      }
      if (aae140.equals("03")) {
        unitInfo.put("num_03", mapT.get("yae231"));
        unitInfo.put("sum_u_03", mapT.get("aab121"));
      }
      if (aae140.equals("04")) {
        unitInfo.put("num_04", mapT.get("yae231"));
        unitInfo.put("sum_u_04", mapT.get("aab121"));
      }
      if (aae140.equals("05")) {
        unitInfo.put("num_05", mapT.get("yae231"));
        unitInfo.put("sum_u_05", mapT.get("aab121"));
      }
      if (aae140.equals("06")) {
        unitInfo.put("num_01", mapT.get("yae231"));
        unitInfo.put("sum_u_01", mapT.get("aab121"));
      }
    }
    return XmlConverUtil.map2Xml(unitInfo);
  }



  /**
   * 查询单位基数汇总信息
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getUnitJSInfo(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String year = (String) map.get("aae001");
    String year_0 = String.valueOf(Integer.valueOf(year) - 1);
    //---------------------------------判断
    boolean flag = false;//是否是单养老单位，false-不是，true-是
    Map ab02Count = (Map) dao.queryForObject("yearApply.ab02Count", map);
    if (ab02Count.get("ab02count").toString().equals("0")) {
      flag = true;
    }
    List list = new ArrayList();
    Map result = (Map) dao.queryForObject("yearApply.queryUnitInfo_2", map);
    result.put("aae001", year);
    result.put("aae001_0", year_0);
    String aab019 = (String) result.get("aab019");
    map.put("aab019", aab019);
    Map irad51 = (Map) dao.queryForObject("yearApply.queryIrad51", map);
    String iaz051 = (String) irad51.get("iaz051");
    result.put("time1", Date.valueOf((String) irad51.get("aae035").toString().substring(0, 10)));
    result.put("iaz051", iaz051);//打印编号
    //养老月基数和
    List jsh01 = dao.queryForList("yearApply.queryUnitJS", map);//单位养老每个月新旧基数
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
      List jsh = dao.queryForList("yearApply.queryUnitJS_1", map);//单位每个月新旧基数
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
    List jsbcs = dao.queryForList("yearApply.getJSZC", map);
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
    List sybc = dao.queryForList("yearApply.getSYBC_01", map);
    if (ValidateUtil.isEmpty(sybc) || (sybc.size() == 0)) {
      result.put("jszc0220", 0);
    } else {
      Map map1 = (Map) sybc.get(0);
      result.put("jszc0220", map1.get("sybc"));
    }

    //起始月度，截止月度
    List aa02a3s = dao.queryForList("yearApply.getaa02a3_new", map);
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
      cbrs = (String) dao.queryForObject("yearApply.getCbrs", map);
    }
    //单养老单位
    if (flag) {
      cbrs = (String) dao.queryForObject("yearApply.getCbrs_1", map);
    }
    result.put("cbrs", cbrs);
    //单位提前结算人数
    Integer tqjs01 = (Integer) dao.queryForObject("yearApply.irad51a1Count", map);
    if (tqjs01 > 0) {
      result.put("tqjs01", tqjs01);
    }
    Map bajszc01 = new HashMap();
    if (flag) {
      bajszc01 = (Map) dao.queryForObject("yearApply.tmp_ac42Ba", map);
    } else {
      bajszc01 = (Map) dao.queryForObject("yearApply.tmp_ac42Ba", map);
    }
    if (!ValidateUtil.isEmpty(bajszc01)) {
      result.putAll(bajszc01);
    }
    return XmlConverUtil.map2Xml(result);
  }



  /**
   * 查询年审单位信息
   *
   * @param xml
   * @return
   * @throws AppException
   */
  public String getWorkerInfo(String xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(xml);
    Map bamap = new HashMap();
    Map unitInfo = (HashMap) dao.queryForObject("monthApply.getWorkerInfor", map);
    String aae003 = (String) dao.queryForObject("yearApply.getNSYD", map);
    unitInfo.put("aae003", aae003);
    boolean flag = false;//是否是单养老单位，false-不是，true-是
    Map ab02Count = (Map) dao.queryForObject("yearApply.ab02Count", map);
    String aab019 = unitInfo.get("aab019") + "";
    if (ab02Count.get("ab02count").toString().equals("0")) {
      flag = true;
    }
    if (!flag) {
      bamap = (Map) dao.queryForObject("yearApply.irac01c1Ba", map);
      unitInfo.putAll(bamap);
    } else {
      bamap = (Map) dao.queryForObject("yearApply.irac01c1Ba", map);
      unitInfo.putAll(bamap);
    }
    return XmlConverUtil.map2Xml(unitInfo);
  }



  /**
   * 查询年审补差数据
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getInsPayBCInfo(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    List list = dao.queryForList("yearApply.getInsPayInfo", map);
    List YLmaps = dao.queryForList("yearApply.getYLInsInfo", map);
    if (!ValidateUtil.isEmpty(YLmaps)) {
      for (int i = 0; i < YLmaps.size(); i++) {
        list.add(i, YLmaps.get(i));
      }
    }
    return XmlConverUtil.list2Xml(list);
  }



  /**
   * 获取补差工伤比例
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getAla080(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    List ala080 = dao.queryForList("yearApply.getAla080", map);
    if (ala080.size() == 0) {
      return "";
    } else {
      Map map2 = (Map) ala080.get(0);
      String ala080str = (String) map2.get("ala080");
      return ala080str;
    }
  }



  /**
   * 查询预览导出数据
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getYearApplyExportData(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    String aae140 = (String) map.get("aae140");
    Map result = (Map) dao.queryForObject("yearApply.queryUnitInfo_2", map);
    List employeeYD;//每月申报人员明细
    List unitJS;//单位基数汇总
    Map unitJsHz;//单位月基数总和
    Map unitJsBa = new HashMap();//单位备案基数总和
    List employees;//单位人员名单
    List irac01c1;
    boolean flag = false;//是否是单养老单位，false-不是，true-是
    Map ab02Count = (Map) dao.queryForObject("yearApply.ab02Count", map);
    if (ab02Count.get("ab02count").toString().equals("0")) {
      flag = true;
    }
    if (flag) {
      irac01c1 = dao.queryForList("yearApply.queryIrac01c1", map);
      employees = dao.queryForList("yearApply.queryab05a1", map);
      unitJS = dao.queryForList("yearApply.queryUnitJS", map);
      employeeYD = dao.queryForList("yearApply.getIrac01ForBa", map);
      unitJsHz = (Map) dao.queryForObject("yearApply.querySumJS", map);
      unitJsBa = (Map) dao.queryForObject("yearApply.querySumJSDBa", map);
      if (!ValidateUtil.isEmpty(irac01c1)) {
        employees.addAll(irac01c1);
      }
    } else {
      if (aae140.equals("01")) {
        irac01c1 = dao.queryForList("yearApply.queryIrac01c1", map);
        employees = dao.queryForList("yearApply.queryab05a1", map);
        unitJS = dao.queryForList("yearApply.queryUnitJS", map);
        employeeYD = dao.queryForList("yearApply.getIrac01", map);
        unitJsHz = (Map) dao.queryForObject("yearApply.querySumJS", map);
        unitJsBa = (Map) dao.queryForObject("yearApply.querySumJSBa", map);
        if (!ValidateUtil.isEmpty(irac01c1)) {
          employees.addAll(irac01c1);
        }
      } else {
        employees = dao.queryForList("yearApply.queryab05a1", map);
        if (aae140.equals("06")) {
          unitJS = dao.queryForList("yearApply.queryUnitJS_2", map);
        } else {
          unitJS = dao.queryForList("yearApply.queryUnitJS_1", map);
        }
        employeeYD = dao.queryForList("yearApply.getAc08", map);
        unitJsHz = (Map) dao.queryForObject("yearApply.querySumJS_1", map);
      }
    }
    result.putAll(unitJsHz);
    if (!ValidateUtil.isEmpty(unitJsBa)) {
      result.putAll(unitJsBa);
      result.put("barssm", "其中未转入备案人员人数");
      result.put("bajssm", "其中未转入备案人员基数差");
    }
    result.put("employees", employees);
    result.put("employeeYD", employeeYD);
    result.put("unitJS", unitJS);
    return XmlConverUtil.map2Xml(result);
  }



  //调用养老接口传入养老数据
  @Override
  public String insertYLJK(String map2Xml) throws AppException {
    return null;
  }



  @Override
  public int getIrad54Count(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer i = (Integer) dao.queryForObject("yearApply.getIrad54Count", map);
    if (i == 0) {
      return 0;
    }
    return 1;
  }



  @Override
  public int getIrad54_1Count(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer i = (Integer) dao.queryForObject("yearApply.getIrad54_1Count", map);
    if (i == 0) {
      return 0;
    }
    return 1;
  }



  @Override
  public String deleteClear(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    PrcDTO prcDto = new PrcDTO();
    prcDto.put("prm_aab001", map.get("aab001") + "");
    prcDto.put("prm_aae001", map.get("aae001") + "");
    prcDto.put("prm_aae011", map.get("aae011") + "");
    dao.callPrc("yearApply.prc_YearSalaryClear", prcDto);
    map.clear();
    map.put("flag", prcDto.getAsString("prm_flag"));
    map.put("msg", prcDto.getAsString("ErrorMsg"));
    return XmlConverUtil.map2Xml(map);
  }



  @Override
  public int getIrad56Count(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer i = (Integer) dao.queryForObject("yearApply.getIrad56Count", map);
    if (i == 0) {
      return 0;
    }
    return 1;
  }



  /**
   * 查询二次补差明细list
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String querySecondBcList(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    List bclist = dao.queryForList("yearApply.zcmx1", map);
    return XmlConverUtil.list2Xml(bclist);
  }



  /**
   * 查询年审二次补差数据
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  public String getInsPaySecondBCInfo(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer aae003 = 0;
    if (ValidateUtil.isEmpty(map.get("aae003"))) {
      aae003 = (Integer) dao.queryForObject("yearApply.getAAE003", map);
      map.put("aae003", aae003);
    }
    List list = dao.queryForList("yearApply.getInsPayInfo1", map);
    List YLmaps = dao.queryForList("yearApply.getYLInsInfo1", map);
    if (!ValidateUtil.isEmpty(YLmaps)) {
      for (int i = 0; i < YLmaps.size(); i++) {
        list.add(i, YLmaps.get(i));
      }
    }
    return XmlConverUtil.list2Xml(list);
  }



  /**
   * 查询二次补差人员列表
   *
   * @param map2Xml
   * @return
   * @throws AppException
   */
  @Override
  public String getAc02List(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    PageBean pageBean = dao.queryForPageWithCount("yearApply.getAc02List", map, Integer.parseInt((String) map.get("startrow")), Integer.parseInt((String) map.get("endrow")));
    return XmlConverUtil.PageBean2Xml(pageBean);
  }



  @Override
  public String getConfirmTip(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer i = (Integer) dao.queryForObject("yearApply.getYearApplyConfirm", map);
    map.put("countconfm",i);
    return XmlConverUtil.map2Xml(map);
  }



  @Override
  public String insertConfirmTip(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    dao.insert("yearApply.insertYearApplyConfirm", map);
    return null;
  }



  @Override
  public String checkAac040(String map2Xml) throws AppException {
    Map map = XmlConverUtil.xml2Map(map2Xml);
    Integer i = (Integer) dao.queryForObject("yearApply.checkAac040", map);
    map.put("countaac040",i);
    return XmlConverUtil.map2Xml(map);
  }
}