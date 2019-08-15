package com.yinhai.nethall.company.monthApply.action;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.cxf.common.util.Base64Utility;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;

import com.yinhai.nethall.company.empBusiness.service.InsurancePersonAddDGService;
import com.yinhai.nethall.company.monthApply.service.MonthInternetRegisterService;
import com.yinhai.nethall.nethallcommon.action.NetHallBaseAction;
import com.yinhai.nethall.nethallcommon.domain.Irac01Domain;
import com.yinhai.nethall.nethallcommon.service.BaseCommService;
import com.yinhai.nethall.nethallcommon.utils.RqReportUtil;
import com.yinhai.nethall.nethallcommon.utils.XmlConverUtil;
import com.yinhai.nethall.nethallcommon.utils.YhcipUtil;
import com.yinhai.nethall.transfer.service.PensionTrunService;
import com.yinhai.sysframework.dto.ParamDTO;
import com.yinhai.sysframework.exception.AppException;
import com.yinhai.sysframework.menu.IMenu;
import com.yinhai.sysframework.persistence.PageBean;
import com.yinhai.sysframework.print.ColumnInfo;
import com.yinhai.sysframework.print.SaveAsInfo;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.sysframework.util.WebUtil;
import com.yinhai.yhcip.print.util.ExcelFileUtils;
import com.yinhai.yhcip.print.util.TxtFileUtils;

@Namespace("/nethall/company/monthApply")
@Action(value = "monthInternetRegisterAction", results = {
    @Result(name = "success", location = "/nethall/company/monthApply/monthInternetRegister.jsp"),
    @Result(name = "printhmc", location = "/servlets/rqPdfPrint"),
    @Result(name = "toMirlist", location = "/nethall/company/monthApply/monthInternetRegisterlist.jsp"),
    @Result(name = "toEditPersonalNew", location = "/nethall/company/monthApply/monthInternetRegisterEditNew.jsp"),
    @Result(name = "tip", location = "/nethall/company/monthApply/monthInternetRegisterTip.jsp"),
    @Result(name = "toEditPersonalAdd", location = "/nethall/company/monthApply/monthInternetRegisterEditAdd.jsp"),
    @Result(name = "toEditPersonalContinue", location = "/nethall/company/monthApply/monthInternetRegisterEditContinue.jsp"),
    @Result(name = "toEditPersonalPause", location = "/nethall/company/monthApply/monthInternetRegisterEditPause.jsp"),
    @Result(name = "toEditPersonalRetire", location = "/nethall/company/monthApply/monthInternetRegisterEditRetire.jsp"),
    @Result(name = "toPrint", location = "/servlets/rqPdfPrint"),
    @Result(name = "preview", location = "/nethall/company/monthApply/monthInternetRegisterPreview.jsp")})
public class MonthInternetRegisterAction extends NetHallBaseAction {
  
  private InsurancePersonAddDGService addservice = (InsurancePersonAddDGService) super.getService("insurancePersonAddDGService");
  private MonthInternetRegisterService service = (MonthInternetRegisterService)super.getService("monthInternetRegisterService");
  private BaseCommService baseCommService = (BaseCommService) super.getService("baseCommService");
  private PensionTrunService pensionTrunService = (PensionTrunService)super.getService("pensionTrunService");
  
  
  /**
   * -------------------------------------<br>
   * @Title: initPage
   * @Description: 初始化页面数据
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  public String initPage() throws Exception {
    /* 暂停功能 modify by fenggg at 20180624 */
    if (super.getMsg("8").equals("0")) {
      return SUCCESS;
    }
    super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
    return SUCCESS;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: Monthregister
   * @Description: TODO
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings("rawtypes")
  public String Monthregister() throws Exception {
    String raq = "yuebao";
    Map map = new HashMap();
    RqReportUtil.setReport(raq, map, request);
    return "toPrint";
  }
  
  
   
  /**
   * -------------------------------------<br>
   * @Title: queryWaitAllOfForm
   * @Description: 月报数据查询
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String queryWaitAllOfForm() throws Exception {
    super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
    ParamDTO dto = getDto();
    /* 查询校验经办人,单位信息等 */
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId()); // 经办人编号
    inMap.put("yab139", dto.getUserInfo().getOrgId());
    String xml = baseCommService.getAab001ByYae092(dto.getUserInfo().getUserId()); // 单位信息校验
    Map out = XmlConverUtil.xml2Map(xml);
    String aab001 = out.get("aab001").toString();
    String Xml = baseCommService.queryAAC001ErrGX(aab001);
    List gxList = XmlConverUtil.xml2List(Xml);
    if (!ValidateUtil.isEmpty(gxList)) {
      setMsg("你单位存在医疗与养老未匹配人员信息，请至《单位管理》下《未匹配信息查询》功能查看详细信息，并及时变更未匹配信息。");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    if (out.get("prm_sign").equals("1")) {
      setMsg((String) out.get("prm_msg"), "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    /* 当前月之前存在没有人员增减直接核费的月度,补写申报数据 */
    Map ad01Map = new HashMap();
    ad01Map.put("aab001", aab001);
    ad01Map.put("aae011", dto.getUserInfo().getUserId());
    service.insertIrad01(XmlConverUtil.map2Xml(ad01Map));
    /*提示是否有未提交的人员增减*/
    String checkXML = baseCommService.checkMonthApply(XmlConverUtil.map2Xml(ad01Map));
    Map checkMap = XmlConverUtil.xml2Map(checkXML);
    if(!ValidateUtil.isEmpty(checkMap.get("warnmsg"))) {
      setData("warningTips1", checkMap.get("warnmsg"));  
    }
    /* 月报特殊控制 查的表是ab01t1 */
    Map m = new HashMap();
    String aab001Str = dto.getUserInfo().getLoginid();
    IMenu menu = WebUtil.getCurrentMenu(request);
    String menuid = menu.getMenuid().toString();
    String url = menu.getUrl();
    String gnid = menuid;
    m.put("aab001", aab001Str);
    m.put("url", url);
    String xmlab01t2 = pensionTrunService.queryAb01t2(XmlConverUtil.map2Xml(m));
    Map dwbaList = XmlConverUtil.xml2Map(xmlab01t2);
    if (!ValidateUtil.isEmpty(dwbaList)) {
      List YLlistab01t1 = (List) dwbaList.get("YLlistab01t1");
      Map mp = (Map) YLlistab01t1.get(0);
      String aae013 = (String) mp.get("aae013");
      setMsg("你单位此功能已暂时冻结无法操作 原因:" + aae013, "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    /* 年审校验 */
    String output = baseCommService.getYae097(XmlConverUtil.map2Xml(inMap));
    Map outputMap = XmlConverUtil.xml2Map(output);
    outputMap.put("yae097", outputMap.get("iaa100"));
    output = XmlConverUtil.map2Xml(outputMap);
    xml = baseCommService.getYab007(output);
    out = XmlConverUtil.xml2Map(xml);
    if (out.get("prm_yab007").equals("01")) {
      setMsg("该单位【" + (String) out.get("prm_aae001") + "】年度未做年审，请撤销增减信息后进行年审操作或咨询高新社保基金管理中心！", "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    } else if (out.get("prm_yab007").equals("99")) {
      setMsg("当前申报月度为" + outputMap.get("iaa100") + "，【" + (outputMap.get("iaa100") + "").substring(0, 4) + "】年度社平已公布，请先进行年审，年审在【社会保险年度基数申报】模块中操作！", "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    /* 校验月报初始数据 */
    inMap.put("aab001", aab001);
    inMap.put("flag", "1"); // 月度申报标志，基数统计过程使用
    xml = service.getMonthApplyStatus(XmlConverUtil.map2Xml(inMap));
    out = XmlConverUtil.xml2Map(xml);
    String prm_sign = (String) out.get("prm_sign"); // 错误标志：0-无错误，1-有错误
    String prm_flag = (String) out.get("prm_flag"); // 申报状态
    String prm_msg = (String) out.get("prm_msg"); // 消息
    String prm_iaa100 = (String) out.get("prm_iaa100"); // 进入界面显示的申报月度
    inMap.put("iaa100", prm_iaa100);
    setData(inMap, false);
    if (prm_sign.equals("1")) { // 错误标志
      setMsg((String) out.get("prm_msg"), "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    /* 检查是否已经到达月报申报期时间限制 */
    if(ValidateUtil.isNotEmpty(prm_iaa100)) {
      Map iaa100Map = new HashMap();
      iaa100Map.put("iaa100", prm_iaa100);
      String isAllowXML = baseCommService.isAllowMonthApply(XmlConverUtil.map2Xml(iaa100Map));
      Map isAllowMap = XmlConverUtil.xml2Map(isAllowXML);
      String isAllowMsg = isAllowMap.get("msg")+"";
      if(ValidateUtil.isNotEmpty(isAllowMsg)) {
        setMsg(isAllowMsg);
        super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
        return JSON;
      }
    }else {
      setMsg("获取单位申报月度错误,请联系社保中心!", "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    /*首月月报不允许零申报*/
    String xmlXKH = service.checkXKH(XmlConverUtil.map2Xml(out));
    if (ValidateUtil.isNotEmpty(xmlXKH)) {
      Map xkhMap = XmlConverUtil.xml2Map(xmlXKH);
      Double count = Double.valueOf(xkhMap.get("xkh") + "");
      if (null != count && count == 0) { // 整建制转入转出0增减校验
        String output1 = service.getAc02Persons(XmlConverUtil.map2Xml(inMap));
        Map outputMap1 = XmlConverUtil.xml2Map(output1);
        if (Integer.valueOf((String) outputMap1.get("ac02count")) == 0 || outputMap1.get("ac02count") == null) {
          setMsg("首次月报的单位不允许零申报!", "error");
          super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
          return JSON;
        }
      }
    }
    /*查询是否需要工伤调整*/
    Map map = new HashMap();
    map.put("aab001", aab001);
    String gsCount = service.checkGSCount(XmlConverUtil.map2Xml(map));
    if (ValidateUtil.isNotEmpty(gsCount)) {
      Map gsMap = XmlConverUtil.xml2Map(gsCount);
      Integer count = Integer.valueOf(gsMap.get("gscount") + "");
      if (count <= 0 && "201607".equals(prm_iaa100)) {
        setMsg("请先申报工伤等级调整,并审核通过后再做月报!", "error");
        super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
        return JSON;
      }
    }
    /* 限制备案时间是否为当前自然月本月或上月或次月 */
    Map c1InMap = new HashMap();
    c1InMap.put("aab001", aab001);
    c1InMap.put("iaa100", outputMap.get("iaa100"));
    String irac01c1XML = service.queryIrac01c1ForCheck(XmlConverUtil.map2Xml(c1InMap));
    if(ValidateUtil.isNotEmpty(irac01c1XML)) {
      Map msgMap = XmlConverUtil.xml2Map(irac01c1XML);
      if(!ValidateUtil.isEmpty(msgMap.get("msg"))) {
      setMsg("人员: "+msgMap.get("msg")+" 当前养老备案申报月度为 "+outputMap.get("iaa100")+" 不符合备案条件,请撤销该人员的养老未转入备案申请后再进行月申报操作!!","error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
      }
    }
    /* 基数统计列表查询 */
    String dateXml = service.saveStaticDataForMir(XmlConverUtil.map2Xml(inMap));
    Map dateMap = XmlConverUtil.xml2Map(dateXml);
    List dateList = (List) dateMap.get("staticData");
    if (prm_flag.equals("0")) { // prm_flag=0首次进入申报
      super.setData("isregs", "0"); // isregs：0未申报，1已申报
      String tip = "";
      // ---新增条件判断方法，以防增加多次条件判断 start
      String conditionXml = service.checkCondition(XmlConverUtil.map2Xml(inMap));
      Map cond = XmlConverUtil.xml2Map(conditionXml);
      String msgB64 = (String) cond.get("msg"); // 提示语句解码
      if (ValidateUtil.isNotEmpty(msgB64)) {
        tip = new String(Base64Utility.decode(msgB64));
      }
      // ---新增条件判断方法，以防增加多次条件判断 end
      String iaa100s = prm_iaa100.substring(0, 4) + "年" + prm_iaa100.substring(4, 6) + "月";
      String isDisabled = (String) cond.get("isDisabled"); // 是否限制
      super.setList("staticData", dateList);
      if (ValidateUtil.isNotEmpty(isDisabled) && isDisabled.equals("1")) {
        setMsg("<font weight=bold>当前申报的月度为：" + iaa100s + "</font></br>");
        setData("warningTips", tip);
      } else {
        setMsg("<font weight=bold>当前申报的月度为：" + iaa100s + "</font></br>");
        setData("warningTips", tip);
        setEnable("save");
      }
      return JSON;
    }
    if (prm_flag.equals("1")||prm_flag.equals("6")) { // prm_flag=1进入申报 prm_flag=6进入申报
      super.setData("isregs", "0"); // isregs：0未申报，1已申报
      String tip = "";
      // ---新增条件判断方法，以防增加多次条件判断 start
      String conditionXml = service.checkCondition(XmlConverUtil.map2Xml(inMap));
      Map cond = XmlConverUtil.xml2Map(conditionXml);
      String msgB64 = (String) cond.get("msg"); // 提示语句解码
      if (ValidateUtil.isNotEmpty(msgB64)) {
        tip = new String(Base64Utility.decode(msgB64));
      }
      // ---新增条件判断方法，以防增加多次条件判断 end
      
      String iaa100s = prm_iaa100.substring(0, 4) + "年" + prm_iaa100.substring(4, 6) + "月";
      super.setList("staticData", dateList);
      
      String isNoChangeXml = service.isNoChange(XmlConverUtil.map2Xml(inMap));
      Map isNoChange = XmlConverUtil.xml2Map(isNoChangeXml);
      
      String isDisabled = (String) cond.get("isDisabled"); // 是否限制
      if (ValidateUtil.isNotEmpty(isDisabled) && isDisabled.equals("1")) {
        setMsg("<font weight=bold>当前申报的月度为：" + iaa100s + "</font></br>");
        setData("warningTips", tip);
        setDisabled("save");
      } else if (isNoChange.get("isnochangecount").equals("0") && prm_flag.equals("6")){
        setMsg("<font weight=bold>当前申报的月度为：" + iaa100s + "</font></br>");
        setData("warningTips", tip+"<p style=font-size:12px;color:blue;>请检查本期申报人员列表中人员参保信息是否准确无误。若单位本期申报月度存在人员增减变动的，请及时申报并提交人员增减变动。 若单位本期申报月度无人员增减变动的，则不需要申报。</p>");
        setDisabled("save");
      } else if (prm_flag.equals("1")){
        setMsg("<font weight=bold>当前申报的月度为：" + iaa100s + "</font></br>");
        setData("warningTips", tip);
        setEnable("save");
      } else if(prm_flag.equals("6")){
        setMsg(prm_msg);
        setData("warningTips", tip);
        setEnable("save");
      } else {
        setMsg("月报信息查询错误");
        setDisabled("save");
      }
      return JSON;
    }
    if (prm_flag.equals("2")) { // prm_flag=2正在审核中
      setMsg(prm_msg, "warn");
      super.setData("isregs", "1");
      setDisabled("mirtabsidone,mirtabsidtwo");
      super.setList("staticData", dateList);
      return JSON;
    }
    if (prm_flag.equals("3")) { // prm_flag=3审核打回
      setMsg(prm_msg, "warn");
      setEnable("save2");
      super.setData("isregs", "1");
      super.setList("staticData", dateList);
      return JSON;
    }
    if (prm_flag.equals("4")) { // prm_flag=4审核通过
      setMsg(prm_msg);
      super.setData("isregs", "1");
      super.setEnable("dcqb,print1,print2,print3,print4");
      super.setList("staticData", dateList);
      return JSON;
    } 
    if (prm_flag.equals("5")) { // prm_flag=5还未到达申报时间
      setMsg(prm_msg);
      return JSON;
    }
    // super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4,mirtabsidone,mirtabsidtwo,mirtabsidthr,mirtabsidfor");
    // setMsg("您好! 月度缴费申报功能现正在维护中... 请稍后再试! 给您带来不便,敬请谅解!");
    return JSON;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: queryWaitAdd
   * @Description: 增加人员列表
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String queryWaitAdd() throws Exception {
    ParamDTO dto = getDto();
    Integer start = dto.getStart("personalInfoConAdd") == null ? Integer.valueOf(0) : dto.getStart("personalInfoConAdd");
    Integer limit = dto.getLimit("personalInfoConAdd") == null ? Integer.valueOf(0) : dto.getLimit("personalInfoConAdd");
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("iaa001", "1");
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa100", dto.getAsString("iaa100"));
    String isregs = dto.getAsString("isregs");
    String inXml = XmlConverUtil.map2XmlWithPage(inMap, start, start + limit);
    if (ValidateUtil.isEmpty(isregs) || isregs.equals("0")) {
      String outXml = service.queryIRInfoForWaitAll(inXml); // 待申报状态
      super.setList("personalInfoConAdd", XmlConverUtil.xml2PageBean(outXml));
    } else {
      String outXml = service.queryIrac01All(inXml); // 已申报状态
      super.setList("personalInfoConAdd", XmlConverUtil.xml2PageBean(outXml));
    }
    setData("flag_one", "1");
    return JSON;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: queryWaitMinus
   * @Description: 减少人员列表
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String queryWaitMinus() throws Exception {
    ParamDTO dto = getDto();
    Integer start = dto.getStart("personalInfoConMinus") == null ? Integer.valueOf(0) : dto.getStart("personalInfoConMinus");
    Integer limit = dto.getLimit("personalInfoConMinus") == null ? Integer.valueOf(0) : dto.getLimit("personalInfoConMinus");
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("iaa001", "3");
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa100", dto.getAsString("iaa100"));
    String isregs = dto.getAsString("isregs");
    String inXml = XmlConverUtil.map2XmlWithPage(inMap, start, start + limit);
    if (ValidateUtil.isEmpty(isregs) || isregs.equals("0")) {
      // 待申报状态
      String outXml = service.queryIRInfoForWaitAll(inXml);
      super.setList("personalInfoConMinus", XmlConverUtil.xml2PageBean(outXml));
    } else {
      // 已申报状态
      String outXml = service.queryIrac01All(inXml);
      super.setList("personalInfoConMinus", XmlConverUtil.xml2PageBean(outXml));
    }
    setData("flag_two", "1");
    return JSON;
  }
  
  
  /**
   * -------------------------------------<br>
   * @Title: queryWaitAll
   * @Description: 本期可申报人员列表
   * @return: String
   * @date: 2019年3月13日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String queryWaitAll() throws Exception {
    ParamDTO dto = getDto();
    Integer start = dto.getStart("personalInfoConAll") == null ? Integer.valueOf(0) : dto.getStart("personalInfoConAll");
    Integer limit = dto.getLimit("personalInfoConAll") == null ? Integer.valueOf(0) : dto.getLimit("personalInfoConAll");
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("iaa001", "2");
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa100", dto.getAsString("iaa100"));
    String isregs = dto.getAsString("isregs");
    String inXml = XmlConverUtil.map2XmlWithPage(inMap, start, start + limit);
    if (ValidateUtil.isEmpty(isregs) || isregs.equals("0")) {
      // 待申报状态
      String outXml = service.queryIRInfoForWaitAll(inXml);
      super.setList("personalInfoConAll", XmlConverUtil.xml2PageBean(outXml));
    } else {
      // 已申报状态
      String outXml = service.queryIrac01All(inXml);
      super.setList("personalInfoConAll", XmlConverUtil.xml2PageBean(outXml));
    }
    setData("flag_three", "1");
    return JSON;
  }
  
  
  /**
   * -------------------------------------<br>
   * @Title: personInfoConAllDetail
   * @Description: 查询操作记录
   * @return: String
   * @date: 2019年3月18日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String personInfoConAllDetail() throws Exception {
    ParamDTO dto = getDto();
    Integer start = dto.getStart("personInfoConAllDetail") == null ? Integer.valueOf(0) : dto.getStart("personInfoConAllDetail");
    Integer limit = dto.getLimit("personInfoConAllDetail") == null ? Integer.valueOf(0) : dto.getLimit("personInfoConAllDetail");
    Map inMap = new HashMap();
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa100", dto.getAsString("iaa100"));
    String inXml = XmlConverUtil.map2XmlWithPage(inMap, start, start + limit);
    String outXml = service.personInfoConAllDetail(inXml);
    super.setList("personInfoConAllDetail", XmlConverUtil.xml2PageBean(outXml));
    return JSON;
  }
  
  
  /**
   * -------------------------------------<br>
   * @Title: perSubmitInfo
   * @Description: 月申报
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String perSubmitInfo() throws Exception {
    ParamDTO dto = getDto();
    if (ValidateUtil.isEmpty(dto.getAsInteger("iaa100"))) {
      super.setMsg("申报月度不能为空!");
    }
    if (ValidateUtil.isEmpty(dto.getAsString("aab001"))) {
      super.setMsg("单位编号不能为空!");
    }
    String iaa100 = dto.getAsString("iaa100");
    String yab139 = dto.getUserInfo().getOrgId();
    String aab001 = dto.getAsString("aab001");
    String yae092 = dto.getUserInfo().getUserId();
    /* 检查是否已经到达月报申报期时间限制 */
    if(ValidateUtil.isNotEmpty(iaa100)) {
      Map iaa100Map = new HashMap();
      iaa100Map.put("iaa100", iaa100);
      String isAllowXML = baseCommService.isAllowMonthApply(XmlConverUtil.map2Xml(iaa100Map));
      Map isAllowMap = XmlConverUtil.xml2Map(isAllowXML);
      String isAllowMsg = isAllowMap.get("msg")+"";
      if(ValidateUtil.isNotEmpty(isAllowMsg)) {
        setMsg(isAllowMsg);
        super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
        return JSON;
      }
    }else {
      setMsg("获取单位申报月度错误,请联系社保中心!", "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    /* 判断月报是否存在限制条件 */
    Map inMap = new HashMap();
    inMap.put("aab001", aab001);
    inMap.put("yab139", yab139);
    inMap.put("iaa100", iaa100);
    inMap.put("yae092", yae092);
    inMap.put("iaa003", "2");
    inMap.put("iscontinue", "2");// 1-续报，2-申报
    String inMapXml = XmlConverUtil.map2Xml(inMap);
    String conditionXml = service.checkCondition(inMapXml);
    Map cond = XmlConverUtil.xml2Map(conditionXml);
    String isDisabled = (String) cond.get("isDisabled");
    if (ValidateUtil.isNotEmpty(isDisabled) && isDisabled.equals("1")) {
      super.setMsg((String) cond.get("msg"), "warn");
      setDisabled("save");
      return JSON;
    }
    /* 调用养老接口增加二次校验 */
    Map YLmap = new HashMap();
    YLmap.put("aab001", aab001);
    YLmap.put("iaa100", iaa100);
    String ab01Xml = baseCommService.getAb01ByAab001(XmlConverUtil.map2Xml(YLmap)); // 获取单位信息
    Map ab01Map = XmlConverUtil.xml2Map(ab01Xml);
    String aab019 = ab01Map.get("aab019").toString();// 单位类型，新参保续保校验根据单位类型传入参保缴费类别
    YLmap.put("aab019", aab019);
   
    String outputXml = "";
    try {
      outputXml = service.queryIrac01ForYL2(XmlConverUtil.map2Xml(YLmap));// 养老接口二次效验
    } catch (Exception e) {
      throw new AppException("调用养老接口失败,请稍后再试!");
    } 
    
    Map mapyl = XmlConverUtil.xml2Map(outputXml);
    String errorMsg = "";
    List list1 = new ArrayList();
    List list3 = new ArrayList();
    List list10 = new ArrayList();
    // 校验报错
    if (mapyl.get("keySet").equals("jy")) { // jy 是正常单位
      if (!ValidateUtil.isEmpty(mapyl.get("list1"))) {
        list1 = (List) mapyl.get("list1");
        for (int i = 0; i < list1.size(); i++) {
          Map map = (Map) list1.get(i);
          if (!ValidateUtil.isEmpty(map.get("msg"))) {
            String msg = map.get("msg").toString();
            errorMsg = errorMsg + msg + "</br>";
          }
          if (!ValidateUtil.isEmpty(map.get("empMsg"))) {
            String empMsg = map.get("empMsg").toString();
            errorMsg = errorMsg + "<font color=red>" + map.get("empMsg").toString() + "</font>" + "</br>";
          }
        }
      }
      if (!ValidateUtil.isEmpty(mapyl.get("list3"))) {
        list3 = (List) mapyl.get("list3");
        for (int i = 0; i < list3.size(); i++) {
          Map map = (Map) list3.get(i);
          errorMsg = errorMsg + map.get("msg").toString() + "</br>";
        }
      }
      if (!ValidateUtil.isEmpty(mapyl.get("list10"))) {
        list10 = (List) mapyl.get("list10");
        for (int i = 0; i < list10.size(); i++) {
          Map map = (Map) list10.get(i);
          errorMsg = errorMsg + map.get("msg").toString() + "</br>";
        }
      }
      errorMsg = errorMsg + "<font color=red>".concat(mapyl.get("endMsg").toString()) + "</font>";
      setMsg(errorMsg, ERROR);
      return JSON;
    }
    if (mapyl.get("keySet").equals("dy")) { // dy 是初次月报单位
      if (!ValidateUtil.isEmpty(mapyl.get("list1"))) {
        list1 = (List) mapyl.get("list1");
        for (int i = 0; i < list1.size(); i++) {
          Map msg01 = (Map) list1.get(i);
          errorMsg = errorMsg + "<font color=red>" + msg01.get("msg") + "</font>" + "</br>";
        }
        errorMsg = mapyl.get("begin01").toString().concat(errorMsg) + "<br>";
      }
      if (!ValidateUtil.isEmpty(mapyl.get("list3"))) {
        list3 = (List) mapyl.get("list3");
        for (int i = 0; i < list3.size(); i++) {
          Map msg02 = (Map) list3.get(i);
          errorMsg = errorMsg + "<font color=red>" + msg02.get("msg") + "</font>" + "</br>";
        }
        errorMsg = mapyl.get("begin03").toString().concat(errorMsg) + "<br>";
      }
      if (!ValidateUtil.isEmpty(mapyl.get("list10"))) {
        list10 = (List) mapyl.get("list10");
        for (int i = 0; i < list10.size(); i++) {
          Map msg03 = (Map) list10.get(i);
          errorMsg = errorMsg + "<font color=red>" + msg03.get("msg") + "</font>" + "</br>";
        }
        errorMsg = mapyl.get("begin10").toString().concat(errorMsg) + "<br>";
      }
      errorMsg = errorMsg + "<font color=red>".concat(mapyl.get("endMsg").toString()) + "</font>";
      setMsg(errorMsg, ERROR);
      return JSON;
    }
    /* 申报时养老写入备案 */
    Map c1InMap = new HashMap();
    c1InMap.put("aab001", aab001);
    c1InMap.put("iaa100", iaa100);
    String irac01c1XML = service.queryIrac01c1ForCheck(XmlConverUtil.map2Xml(c1InMap));
    if (ValidateUtil.isNotEmpty(irac01c1XML)) {
      List irac01c1List = XmlConverUtil.xml2List(irac01c1XML);
      if (ValidateUtil.isNotEmpty(irac01c1List)) {
        c1InMap.put("aae011", yae092);
        c1InMap.put("list", irac01c1List);
        @SuppressWarnings("unused")
        String resultXml = service.insertIrac01c1ToYLPortAdd(XmlConverUtil.map2Xml(c1InMap));
        // 暂时不做限制
        /* Map msgMap = XmlConverUtil.xml2Map(resultXml);
        if(!ValidateUtil.isEmpty(msgMap.get("fail"))&&"1".equals(msgMap.get("fail"))) {
          super.setMsg(msgMap.get("msg")+"; 请先前往养老未转入备案模块撤销备案申请, 删除备案失败人员, 再次提交备案申请后再进行月报操作!!!");
          return JSON;
        }*/
      }
    }
    /* 调用月申报 */
    String msgXml=service.savePrcMonthInternetRegister(inMapXml);
    Map mapMsg = XmlConverUtil.xml2Map(msgXml);

    //String newEmp = mapMsg.get("newEmp").toString();
    //Integer num = Integer.valueOf((String) mapMsg.get("addMinusCount")); // 增减数量
    //String prm_Flag = mapMsg.get("prm_Flag")+""; //审核类型 统一核费:0 中心核费:1
    
    if (ValidateUtil.isNotEmpty((String) mapMsg.get("ErrorMsg"))) {
      super.setMsg((String) mapMsg.get("ErrorMsg"),"error");
    } else if(ValidateUtil.isEmpty(mapMsg.get("ErrorMsg"))&&!ValidateUtil.isEmpty(mapMsg.get("prm_Flag"))&&mapMsg.get("prm_Flag").equals("0")){
      Map map = new HashMap();
      map.put("iaa100", iaa100);
      map.put("yae092", yae092);
      super.setMsg("本次月报人员增减已成功!");
      /* 刷新基数预览 */
      inMap.put("prm_flag", "1");
      inMap.put("prm_aab001", inMap.get("aab001"));
      inMap.put("prm_iaa100", inMap.get("iaa100"));
      inMap.put("prm_yae092", inMap.get("yae092"));
      String dateXml = service.saveStaticDataForMir(XmlConverUtil.map2Xml(inMap));
      Map dateMap = XmlConverUtil.xml2Map(dateXml);
      List dateList = (List) dateMap.get("staticData");
      super.setList("staticData", dateList);
    } else if(ValidateUtil.isEmpty(mapMsg.get("ErrorMsg"))&&!ValidateUtil.isEmpty(mapMsg.get("prm_Flag"))&&mapMsg.get("prm_Flag").equals("1")){
      Map map = new HashMap();
      map.put("iaa100", iaa100);
      map.put("yae092", yae092);
      Integer num = Integer.valueOf((String) mapMsg.get("addMinusCount"));
      if (num.intValue() == 0) { // 不存在人员增加
        super.setEnable("print1");
        super.setEnable("print2");
        super.setEnable("print3");
        super.setEnable("print4");
        super.setEnable("dcqb");
        super.setMsg("当前申报月度已经经过系统审核计算，可以直接打印表单缴费!");
      } else {
        // String xml = service.insertAi04(inMapXml); //养老接口提取数据
        super.setMsg("人员信息已经处于待审核状态，不能做任何更改，请等待社保基金管理中心审核!");
      }
    }
    super.setDisabled("save");
    super.setDisabled("preview");
    return JSON;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: toEditPersonalNew
   * @Description: 人员新参保打回编辑
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String toEditPersonalNew() throws Exception {
    ParamDTO dto = getDto();
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("yab139", dto.getUserInfo().getOrgId());
    inMap.put("iaa100", dto.getAsString("iaa100"));
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa002", dto.getAsString("iaa002"));
    inMap.put("iac001", dto.getAsString("iac001"));
    String inMapXml = XmlConverUtil.map2Xml(inMap);
    String outXml = service.queryPersonalInfo(inMapXml); // 查询修改的人员信息
    Map irac01Map = XmlConverUtil.xml2Map(outXml);
    super.setData(irac01Map, false);
    super.setReadOnly("aac004,aac006");
    super.setDisabled("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
    super.setHideObj("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
    String ab01Xml = baseCommService.getAb01ByAab001(inMapXml); // 获取单位基本信息
    Map ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String ab02Xml = baseCommService.getAb02ByAab001(inMapXml); // 获取单位参保信息列表
    PageBean ab02PB = XmlConverUtil.xml2PageBean(ab02Xml);
    List ab02List = ab02PB.getList();
    for (int i = 0; i < ab02List.size(); i++) {
      HashMap map3 = (HashMap) ab02List.get(i);
      for (int j = 0; j < map3.size(); j++) {
        String xx = map3.get("aae140").toString();
        setEnable("xzlb_" + xx);
        setShowObj("xzlb_" + xx);
        if (xx.equals("06")) { // 放开机关养老基数填写
          setEnable("yac004");
          this.setRequired("yac004");
        }
        if (xx.equals("08")) { // 新增公务员补助险种
          if (((String) ab01.get("yab275")).equals("01")) { // 根据单位待遇类型判断是否参加公务员补助
            setDisabled("xzlb_" + xx);
            setHideObj("xzlb_" + xx);
          } else {
            setEnable("xzlb_" + xx);
            setShowObj("xzlb_" + xx);
            setRequired("yac200");
          }
        }
      }
    }
    // 根据irac01回写参保信息
    if ("1".equals(irac01Map.get("aae110"))) {
      setData("xzlb_01", "01");
    }
    if ("1".equals(irac01Map.get("aae210"))) {
      setData("xzlb_02", "02");
    }
    if ("1".equals(irac01Map.get("aae310"))) {
      setData("xzlb_03", "03");
    }
    if ("1".equals(irac01Map.get("aae410"))) {
      setData("xzlb_04", "04");
    }
    if ("1".equals(irac01Map.get("aae510"))) {
      setData("xzlb_05", "05");
    }
    if ("1".equals(irac01Map.get("aae311"))) {
      setData("xzlb_07", "07");
    }
    if ("1".equals(irac01Map.get("aae120"))) {
      setData("xzlb_06", "06");
    }
    if ("1".equals(irac01Map.get("aae810"))) {
      setData("xzlb_08", "08");
    }
    if ("1".equals(irac01Map.get("iaa002")) || "2".equals(irac01Map.get("iaa002"))) {
      super.setDisabled("saveBtn");
      super.setReadOnly("panel");
      setDisabled("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
      super.setMsg(super.getCodeDesc("IAA002", irac01Map.get("iaa002").toString(), "") + "信息不能修改!");
    }
    if ("4".equals(irac01Map.get("iaa002")) == false) {
      super.setDisabled("dropBtn");
    }
    // 如果是新开户单位不能放弃操作
    String o = service.queryIrad01Count(inMapXml);
    if (o.equals("1")) {
      // 首次月报
      super.setDisabled("dropBtn");
    }
    // 如果是待申报不能修改保存
    if ("0".equals(irac01Map.get("iaa002")) == true) {
      super.setDisabled("saveBtn");
      super.setReadOnly("panel");
      super.setMsg("还未提交月报，如要修改,请到【人员管理】菜单下对应的【基础业务】功能中删除所录的信息，再重新录入！");
    }
    setReadOnly("xzlb_04");
    return "toEditPersonalNew";
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: updateNewPersonalInfo
   * @Description: 月申报 修改人员信息[新参保信息]
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  public String updateNewPersonalInfo() throws Exception {
    ParamDTO dto = getDto();
    String aae110 = "0", aae120 = "0", aae210 = "0", aae310 = "0", aae410 = "0", aae510 = "0", aae311 = "0", aae810 = "0";
    dto.put("aae110", aae110);
    dto.put("aae120", aae120);
    dto.put("aae210", aae210);
    dto.put("aae310", aae310);
    dto.put("aae410", aae410);
    dto.put("aae510", aae510);
    dto.put("aae311", aae311);
    dto.put("aae810", aae810);
    String[] insurance = dto.getAsStringArray("insurance");
    if (insurance != null) {
      for (int i = 0; i < insurance.length; i++) {
        if ("01".equals(insurance[i])) {
          aae110 = "1";
          dto.put("aae110", aae110);
        }
        if ("06".equals(insurance[i])) {
          aae120 = "1";
          dto.put("aae120", aae120);
        }
        if ("02".equals(insurance[i])) {
          aae210 = "1";
          dto.put("aae210", aae210);
        }
        if ("03".equals(insurance[i])) {
          aae310 = "1";
          dto.put("aae310", aae310);
        }
        if ("04".equals(insurance[i])) {
          aae410 = "1";
          dto.put("aae410", aae410);
        }
        if ("05".equals(insurance[i])) {
          aae510 = "1";
          dto.put("aae510", aae510);
        }
        if ("07".equals(insurance[i])) {
          aae311 = "1";
          dto.put("aae311", aae311);
        }
        if ("08".equals(insurance[i])) {
          aae810 = "1";
          dto.put("aae810", aae810);
        }
      }
    }
    service.updatePersonalInfo(XmlConverUtil.map2Xml(dto));
    super.setMsg("新参保人员信息修改成功!");
    return JSON;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: toEditPersonalAdd
   * @Description: 人员新增险种打回编辑
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String toEditPersonalAdd() throws Exception {
    ParamDTO dto = getDto();
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("yab139", dto.getUserInfo().getOrgId());
    inMap.put("iaa100", dto.getAsString("iaa100"));
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa002", dto.getAsString("iaa002"));
    inMap.put("iac001", dto.getAsString("iac001"));
    String inMapXml = XmlConverUtil.map2Xml(inMap);
    String outXml = service.queryPersonalInfo(inMapXml); // 查询修改的人员信息
    Map irac01Map = XmlConverUtil.xml2Map(outXml);
    super.setData(irac01Map, false);
    inMap.put("aac001", (String) irac01Map.get("aac001"));
    super.setReadOnly("aac004,aac006");
    super.setDisabled("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
    super.setHideObj("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
    String ab01Xml = baseCommService.getAb01ByAab001(inMapXml); // 获取单位基本信息
    Map ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String ab02Xml = baseCommService.getAb02ByAab001(inMapXml); // 获取单位参保信息列表
    PageBean ab02PB = XmlConverUtil.xml2PageBean(ab02Xml);
    List ab02List = ab02PB.getList();
    for (int i = 0; i < ab02List.size(); i++) {
      HashMap map3 = (HashMap) ab02List.get(i);
      for (int j = 0; j < map3.size(); j++) {
        String xx = map3.get("aae140").toString();
        setEnable("xzlb_" + xx);
        setShowObj("xzlb_" + xx);
        if (xx.equals("06")) { // 放开机关养老基数填写
          setEnable("yac004");
          this.setRequired("yac004");
        }
        if (xx.equals("08")) { // 新增公务员补助险种
          if (((String) ab01.get("yab275")).equals("01")) { // 根据单位待遇类型判断是否参加公务员补助
            setDisabled("xzlb_" + xx);
            setHideObj("xzlb_" + xx);
          } else {
            setEnable("xzlb_" + xx);
            setShowObj("xzlb_" + xx);
            setRequired("yac200");
          }
        }

      }
    }
    // 根据irac01回写参保信息
    if ("1".equals(irac01Map.get("aae110"))) {
      setData("xzlb_01", "01");
    }
    if ("1".equals(irac01Map.get("aae210"))) {
      setData("xzlb_02", "02");
    }
    if ("1".equals(irac01Map.get("aae310"))) {
      setData("xzlb_03", "03");
    }
    if ("1".equals(irac01Map.get("aae410"))) {
      setData("xzlb_04", "04");
    }
    if ("1".equals(irac01Map.get("aae510"))) {
      setData("xzlb_05", "05");
    }
    if ("1".equals(irac01Map.get("aae311"))) {
      setData("xzlb_07", "07");
    }
    if ("1".equals(irac01Map.get("aae120"))) {
      setData("xzlb_06", "06");
    }
    if ("1".equals(irac01Map.get("aae810"))) {
      setData("xzlb_08", "08");
    }
    if ("1".equals(irac01Map.get("iaa002")) || "2".equals(irac01Map.get("iaa002"))) {
      super.setDisabled("saveBtn");
      super.setReadOnly("panel");
      setDisabled("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
      super.setMsg(super.getCodeDesc("IAA002", irac01Map.get("iaa002").toString(), "") + "信息不能修改!");
    }
    if ("4".equals(irac01Map.get("iaa002")) == false) {
      super.setDisabled("dropBtn");
    }
    // 如果是新开户单位不能放弃操作
    String o = service.queryIrad01Count(inMapXml);
    if (o.equals("1")) {
      // 首次月报
      super.setDisabled("dropBtn");
    }
    // 如果是待申报不能修改保存
    if ("0".equals(irac01Map.get("iaa002")) == true) {
      super.setDisabled("saveBtn");
      super.setReadOnly("panel");
      super.setMsg("还未提交月报，如要修改,请到【人员管理】菜单下对应的【基础业务】功能中删除所录的信息，再重新录入！");
    }
    List listsi = XmlConverUtil.xml2List(service.getAc02List(XmlConverUtil.map2Xml(inMap)));
    setList("continueGrid", listsi);
    for (int i = 0; i < listsi.size(); i++) {
      Map sidto = (Map) listsi.get(i);
      String aae140 = (String) sidto.get("aae140");
      String aac031 = (String) sidto.get("aac031");
      if (aae140.equals("01")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_01");
        } else {
          setData("xzlb_01", "01");
        }
      }
      if (aae140.equals("02")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_02");
        }
      }
      if (aae140.equals("03")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_03");
        }
      }
      if (aae140.equals("04")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_04");
        }
      }
      if (aae140.equals("05")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_05");
        }
      }
      if (aae140.equals("07")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_07");
        }
      }
      if (aae140.equals("06")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_06");
        }
      }
      if (aae140.equals("08")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_08");
        }
      }
    }
    String aae002 = dto.getAsStringArray("iaa100")[0];
    super.setData("iaa100", aae002);
    //查询人员是否在其他单位参保
    String aae140Count = service.getAae140Count(XmlConverUtil.map2Xml(irac01Map));
    if(Integer.valueOf(aae140Count)>1){
      setMsg("此人在其他单位有险种未做暂停,本单位只能参保工伤险!");
    }
    setReadOnly("xzlb_04");
    return "toEditPersonalAdd";
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: updateAddPersonalInfo
   * @Description: 月申报 修改人员信息[险种新增信息]
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings("rawtypes")
  public String updateAddPersonalInfo() throws Exception {
    ParamDTO dto = getDto();
    String aae110 = "0", aae120 = "0", aae210 = "0", aae310 = "0", aae410 = "0", aae510 = "0", aae311 = "0", aae810 = "0";
    List listsi = XmlConverUtil.xml2List(service.getAc02List(XmlConverUtil.map2Xml(dto)));
    for (int i = 0; i < listsi.size(); i++) {
      Map sidto = (Map) listsi.get(i);
      String aae140 = sidto.get("aae140") + "";
      String aac031 = sidto.get("aac031") + "";
      if (aae140.equals("01")) {
        aae110 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("02")) {
        aae210 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("03")) {
        aae310 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("04")) {
        aae410 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("05")) {
        aae510 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("06")) {
        aae120 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("07")) {
        aae311 = aac031.equals("1") ? "2" : "21";
      }
      if (aae140.equals("08")) {
        aae810 = aac031.equals("1") ? "2" : "21";
      }
    }
    dto.put("aae110", aae110);
    dto.put("aae120", aae120);
    dto.put("aae210", aae210);
    dto.put("aae310", aae310);
    dto.put("aae410", aae410);
    dto.put("aae510", aae510);
    dto.put("aae311", aae311);
    dto.put("aae810", aae810);
    String[] insurance = dto.getAsStringArray("insurance");
    if (insurance != null) {
      for (int i = 0; i < insurance.length; i++) {
        if ("110".equals(insurance[i])) {
          aae110 = "1";
          dto.put("aae110", aae110);
        }
        if ("120".equals(insurance[i])) {
          aae120 = "1";
          dto.put("aae120", aae120);
        }
        if ("210".equals(insurance[i])) {
          aae210 = "1";
          dto.put("aae210", aae210);
        }
        if ("310".equals(insurance[i])) {
          aae310 = "1";
          dto.put("aae310", aae310);
        }
        if ("410".equals(insurance[i])) {
          aae410 = "1";
          dto.put("aae410", aae410);
        }
        if ("510".equals(insurance[i])) {
          aae510 = "1";
          dto.put("aae510", aae510);
        }
        if ("810".equals(insurance[i])) {
          aae810 = "1";
          dto.put("aae810", aae810);
        }
        if ("311".equals(insurance[i])) {
          aae311 = "1";
          dto.put("aae311", aae311);
        }
      }
    }
    service.updatePersonalInfo(XmlConverUtil.map2Xml(dto));
    super.setMsg("险种新增人员信息修改成功!");
    return JSON;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: toEditPersonalContinue
   * @Description: 人员续保打回编辑 
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String toEditPersonalContinue() throws Exception {
    ParamDTO dto = getDto();
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("yab139", dto.getUserInfo().getOrgId());
    inMap.put("iaa100", dto.getAsString("iaa100"));
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa002", dto.getAsString("iaa002"));
    inMap.put("iac001", dto.getAsString("iac001"));
    String inMapXml = XmlConverUtil.map2Xml(inMap);
    // 查询修改的人员信息
    String outXml = service.queryPersonalInfo(inMapXml);
    Map irac01Map = XmlConverUtil.xml2Map(outXml);
    super.setData(irac01Map, false);
    inMap.put("aac001", (String) irac01Map.get("aac001"));
    super.setReadOnly("aac004,aac006");
    super.setDisabled("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
    super.setHideObj("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
    // 获取单位基本信息
    String ab01Xml = baseCommService.getAb01ByAab001(inMapXml);
    Map ab01 = XmlConverUtil.xml2Map(ab01Xml);
    // 获取单位参保信息列表
    String ab02Xml = baseCommService.getAb02ByAab001(inMapXml);
    PageBean ab02PB = XmlConverUtil.xml2PageBean(ab02Xml);
    List ab02List = ab02PB.getList();

    for (int i = 0; i < ab02List.size(); i++) {
      HashMap map3 = (HashMap) ab02List.get(i);
      for (int j = 0; j < map3.size(); j++) {
        String xx = map3.get("aae140").toString();
        setEnable("xzlb_" + xx);
        setShowObj("xzlb_" + xx);
        // 放开机关养老基数填写
        if (xx.equals("06")) {
          setEnable("yac004");
          this.setRequired("yac004");
        }
        // 新增公务员补助险种
        if (xx.equals("08")) {
          // 根据单位待遇类型判断是否参加公务员补助
          if (((String) ab01.get("yab275")).equals("01")) {
            setDisabled("xzlb_" + xx);
            setHideObj("xzlb_" + xx);
          } else {
            setEnable("xzlb_" + xx);
            setShowObj("xzlb_" + xx);
            setRequired("yac200");
          }
        }
      }
    }
    if ("1".equals(irac01Map.get("aae110")) || "10".equals(irac01Map.get("aae110"))) {
      setData("xzlb_01", "01");
    }
    if ("1".equals(irac01Map.get("aae210")) || "10".equals(irac01Map.get("aae210"))) {
      setData("xzlb_02", "02");
    }
    if ("1".equals(irac01Map.get("aae310")) || "10".equals(irac01Map.get("aae310"))) {
      setData("xzlb_03", "03");
    }
    if ("1".equals(irac01Map.get("aae410")) || "10".equals(irac01Map.get("aae410"))) {
      setData("xzlb_04", "04");
    }
    if ("1".equals(irac01Map.get("aae510")) || "10".equals(irac01Map.get("aae510"))) {
      setData("xzlb_05", "05");
    }
    if ("1".equals(irac01Map.get("aae311")) || "10".equals(irac01Map.get("aae311"))) {
      setData("xzlb_07", "07");
    }
    if ("1".equals(irac01Map.get("aae120")) || "10".equals(irac01Map.get("aae120"))) {
      setData("xzlb_06", "06");
    }
    if ("1".equals(irac01Map.get("aae810")) || "10".equals(irac01Map.get("aae810"))) {
      setData("xzlb_08", "08");
    }
    if ("1".equals(irac01Map.get("iaa002")) || "2".equals(irac01Map.get("iaa002"))) {
      super.setDisabled("saveBtn");
      super.setReadOnly("panel");
      setDisabled("xzlb_01,xzlb_06,xzlb_02,xzlb_03,xzlb_04,xzlb_05,xzlb_07,xzlb_08");
      super.setMsg(super.getCodeDesc("IAA002", irac01Map.get("iaa002").toString(), "") + "信息不能修改!");
    }
    if ("4".equals(irac01Map.get("iaa002")) == false) {
      super.setDisabled("dropBtn");
    }
    // 如果是新开户单位不能放弃操作
    String o = service.queryIrad01Count(inMapXml);
    if (o.equals("1")) {
      // 首次月报
      super.setDisabled("dropBtn");
    }
    // 如果是待申报不能修改保存
    if ("0".equals(irac01Map.get("iaa002")) == true) {
      super.setDisabled("saveBtn");
      super.setReadOnly("panel");
      super.setMsg("还未提交月报，如要修改,请到【人员管理】菜单下对应的【基础业务】功能中删除所录的信息，再重新录入！");
    }
    List listsi = XmlConverUtil.xml2List(service.getAc02List(XmlConverUtil.map2Xml(inMap)));
    setList("continueGrid", listsi);
    for (int i = 0; i < listsi.size(); i++) {
      Map sidto = (Map) listsi.get(i);
      String aae140 = (String) sidto.get("aae140");
      String aac031 = (String) sidto.get("aac031");
      if (aae140.equals("01")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_01");
        } else {
          setData("xzlb_01", "01");
        }
      }
      if (aae140.equals("02")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_02");
        }
      }
      if (aae140.equals("03")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_03");
        }
      }
      if (aae140.equals("04")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_04");
        }
      }
      if (aae140.equals("05")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_05");
        }
      }
      if (aae140.equals("07")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_07");
        }
      }
      if (aae140.equals("06")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_06");
        }
      }
      if (aae140.equals("08")) {
        if (aac031.equals("1")) {
          setHideObj("xzlb_08");
        }
      }
    }
    String aae002 = dto.getAsStringArray("iaa100")[0];
    super.setData("iaa100", aae002);
    // 查询人员是否在其他单位参保
    String aae140Count = service.getAae140Count(XmlConverUtil.map2Xml(irac01Map));
    if (Integer.valueOf(aae140Count) > 1) {
      setMsg("此人在其他单位有险种未做暂停,本单位只能参保工伤险!");
    }
    setReadOnly("xzlb_04");
    return "toEditPersonalContinue";
  }

  
  
  /**
   * -------------------------------------<br>
   * @Title: updateConPersonalInfo
   * @Description: 月申报 修改人员信息[续保信息]
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings("rawtypes")
  public String updateConPersonalInfo() throws Exception {
    ParamDTO dto = getDto();
    String aab001_1 = dto.getAsString("aab001");
    String aae110 = "0", aae120 = "0", aae210 = "0", aae310 = "0", aae410 = "0", aae510 = "0", aae311 = "0", aae810 = "0";
    List listsi = XmlConverUtil.xml2List(service.getAc02List(XmlConverUtil.map2Xml(dto)));
    for (int i = 0; i < listsi.size(); i++) {
      Map sidto = (Map) listsi.get(i);
      String aae140 = sidto.get("aae140").toString();
      String aac031 = sidto.get("aac031").toString();
      String aab001 = sidto.get("aab001").toString();
      if (aab001.equals(aab001_1)) {
        if (aae140.equals("01")) {
          aae110 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("02")) {
          aae210 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("03")) {
          aae310 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("04")) {
          aae410 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("05")) {
          aae510 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("06")) {
          aae120 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("08")) {
          aae810 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("07")) {
          aae311 = aac031.equals("1") ? "2" : "21";
        }
      } else {
        if (aae140.equals("01")) {
          aae110 = aac031.equals("1") ? "0" : "21";
        }
        if (aae140.equals("02")) {
          aae210 = aac031.equals("1") ? "0" : "21";
        }
        if (aae140.equals("03")) {
          aae310 = aac031.equals("1") ? "0" : "21";
        }
        if (aae140.equals("04")) {
          aae410 = aac031.equals("1") ? "0" : "21";
        }
        if (aae140.equals("05")) {
          aae510 = aac031.equals("1") ? "0" : "21";
        }
        if (aae140.equals("06")) {
          aae120 = aac031.equals("1") ? "0" : "21";
        }
        if (aae140.equals("08")) {
          aae810 = aac031.equals("1") ? "2" : "21";
        }
        if (aae140.equals("07")) {
          aae311 = aac031.equals("1") ? "0" : "21";
        }
      }
    }
    dto.put("aae110", aae110);
    dto.put("aae120", aae120);
    dto.put("aae210", aae210);
    dto.put("aae310", aae310);
    dto.put("aae410", aae410);
    dto.put("aae510", aae510);
    dto.put("aae810", aae810);
    dto.put("aae311", aae311);
    String[] insurance = dto.getAsStringArray("insurance");
    if (insurance != null) {
      for (int i = 0; i < insurance.length; i++) {
        if ("01".equals(insurance[i])) {
          aae110 = aae110 == "0" ? "1" : "10";
          dto.put("aae110", aae110);
        }
        if ("06".equals(insurance[i])) {
          aae120 = aae120 == "0" ? "1" : "10";
          dto.put("aae120", aae120);
        }
        if ("02".equals(insurance[i])) {
          aae210 = aae210 == "0" ? "1" : "10";
          dto.put("aae210", aae210);
        }
        if ("03".equals(insurance[i])) {
          aae310 = aae310 == "0" ? "1" : "10";
          dto.put("aae310", aae310);
        }
        if ("04".equals(insurance[i])) {
          aae410 = aae410 == "0" ? "1" : "10";
          dto.put("aae410", aae410);
        }
        if ("05".equals(insurance[i])) {
          aae510 = aae510 == "0" ? "1" : "10";
          dto.put("aae510", aae510);
        }
        if ("08".equals(insurance[i])) {
          aae810 = aae810 == "0" ? "1" : "10";
          dto.put("aae810", aae810);
        }
        if ("07".equals(insurance[i])) {
          aae311 = aae311 == "0" ? "1" : "10";
          dto.put("aae311", aae311);
        }
      }
    }
    service.updatePersonalInfo(XmlConverUtil.map2Xml(dto));
    super.setMsg("续保人员信息修改成功!");
    return JSON;
  }
  
  
  /**
   * -------------------------------------<br>
   * @Title: toEditPersonalMinus
   * @Description: 人员减少打回编辑 
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String toEditPersonalMinus() throws Exception {
    ParamDTO dto = getDto();
    Map inMap = new HashMap();
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("yab139", dto.getUserInfo().getOrgId());
    inMap.put("iaa100", dto.getAsString("iaa100"));
    inMap.put("aab001", dto.getAsString("aab001"));
    inMap.put("iaa002", dto.getAsString("iaa002"));
    inMap.put("iac001", dto.getAsString("iac001"));
    String inMapXml = XmlConverUtil.map2Xml(inMap);
    // 查询修改的人员信息
    String outXml = service.queryPersonalInfo(inMapXml);
    Map irac01Map = XmlConverUtil.xml2Map(outXml);
    this.setData("aae015", irac01Map.get("aae015"));
    return JSON;
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: updatePauseInfo
   * @Description: 月申报 修改人员信息[停保信息]
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  public String updatePauseInfo() throws Exception {
    ParamDTO dto = getDto();
    String aab001 = dto.getAsString("aab001");
    String yab003 = dto.getUserInfo().getOrgId();
    String aae011 = dto.getUserInfo().getUserId();
    if (ValidateUtil.isEmpty(dto.getAsString("iac001x"))) {
      throw new AppException("申报人员编号不能为空!");
    }
    dto.put("iac001", dto.getAsString("iac001x"));
    String iaa001x = dto.getAsString("iaa001x");//申报类型
    String iaa001 = dto.getAsString("iaa001");//改成的申报类型
    dto.put("aab001",aab001);
    dto.put("yab003",yab003);
    dto.put("yab139",yab003);
    dto.put("aae011",aae011);
    //Irac01Domain irac01Domain = (Irac01Domain)getDao().queryForObject("irac01.get", dto);
    //dto.put("aac001", irac01Domain.getAac001());
    if(iaa001x.equals(iaa001)){
      service.updatePersonalInfo(XmlConverUtil.map2Xml(dto));
        super.setMsg("人员信息修改成功！");
    }else if(iaa001x.equals("3")&& iaa001.equals("9")){
       //暂停变待退
      service.updatePersonalInfo379(XmlConverUtil.map2Xml(dto));
        super.setMsg("人员信息修改成功！");
    }else if(iaa001x.equals("7")&&iaa001.equals("9")){
      //批量暂停变待退
      service.updatePersonalInfo379(XmlConverUtil.map2Xml(dto));
        super.setMsg("人员信息修改成功！");
    }else if(iaa001x.equals("9")&&iaa001.equals("3")){
      //待退变暂停
      service.updatePersonalInfo93(XmlConverUtil.map2Xml(dto));
      //service.updatePersonalInfo93(dto);
      super.setMsg("人员信息修改成功！");
    }else{
      super.setMsg("人员信息修改有误，业务类型变更有误，请重新编辑！");
      setSuccess(false);
      return JSON;
    }
    return JSON;
  }
  
  

  /**
   * -------------------------------------<br>
   * @Title: getTipWin
   * @Description: 弹出信件内容
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  public String getTipWin() throws Exception{
    return "tip";
  }

  
  
 /**
  * -------------------------------------<br>
  * @Title: dropPersonalInfo
  * @Description: 月申报 放弃缴费
  * @return: String
  * @date: 2019年3月12日
  * @A19
  * -------------------------------------<br>
  */
  public String dropPersonalInfo() throws Exception {
    ParamDTO dto = getDto();
    String xml = service.savedropPersonalInfo(XmlConverUtil.map2Xml(dto));
    super.setMsg("人员放弃月申报成功!");
    return JSON;
  }


  /**
   * -------------------------------------<br>
   * @Title: perSubmitInfoC
   * @Description: 续报
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String perSubmitInfoC() throws Exception {
    ParamDTO dto = getDto();
    if (ValidateUtil.isEmpty(dto.getAsInteger("iaa100"))) {
      super.setMsg("申报月度不能为空!");
    }
    if (ValidateUtil.isEmpty(dto.getAsString("aab001"))) {
      super.setMsg("单位编号不能为空!");
    }
    String iaa100 = dto.getAsString("iaa100");
    String yab139 = dto.getUserInfo().getOrgId();
    String aab001 = dto.getAsString("aab001");
    String yae092 = dto.getUserInfo().getUserId();
    Map inMap = new HashMap();
    inMap.put("aab001", aab001);
    inMap.put("yab139", yab139);
    inMap.put("iaa100", iaa100);
    inMap.put("yae092", yae092);
    inMap.put("iaa003", "2");
    inMap.put("iscontinue", "1");// 1-续报，2-申报
    String inMapXml = XmlConverUtil.map2Xml(inMap);// 参数XML
    String conditionXml = service.checkCondition(inMapXml);
    Map cond = XmlConverUtil.xml2Map(conditionXml);
    String isDisabled = (String) cond.get("isDisabled"); // 是否限制
    String tip = "";
    if (ValidateUtil.isNotEmpty(isDisabled) && isDisabled.equals("1")) {
      String msgB64 = (String) cond.get("msg");
      if (ValidateUtil.isNotEmpty(msgB64)) {
        tip = new String(Base64Utility.decode(msgB64));
      }
      super.setMsg(tip, "warn");
      setDisabled("save2");
      return JSON;
    }
    /* 调用月申报 */
    String msgXml = service.savePrcMonthInternetRegister(inMapXml);
    Map mapMsg = XmlConverUtil.xml2Map(msgXml);
    Integer num = Integer.valueOf((String) mapMsg.get("addMinusCount")); // 增减数量
    if (ValidateUtil.isNotEmpty((String) mapMsg.get("ErrorMsg"))) {
      super.setMsg((String) mapMsg.get("ErrorMsg"));
    } else {
      Map map = new HashMap();
      map.put("iaa100", iaa100);
      map.put("yae092", yae092);
      if (num.intValue() == 0) { // 不存在人员增减
        super.setEnable("print1");
        super.setEnable("print2");
        super.setEnable("print3");
        super.setEnable("print4");
        super.setEnable("dcqb");
        super.setMsg("当前申报月度已经经过系统审核计算，可以直接打印表单缴费!");
      } else {
        // 养老接口提取数据
        // String xml = service.insertAi04(inMapXml);
        super.setMsg("人员信息已经处于待审核状态，不能做任何更改，请等待社保基金管理中心审核!");
      }
    }
    super.setDisabled("save2");
    super.setDisabled("preview");
    return JSON;
  }

  
  
  /**
   * -------------------------------------<br>
   * @Title: autoFill
   * @Description: TODO
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String autoFill() throws Exception {
    ParamDTO dto = getDto();
    String yae181 = dto.getAsString("yae181");
    String aac002 = dto.getAsString("aac002");
    String aab001 = dto.getAsString("aab001");
    if(ValidateUtil.isEmpty(yae181)){
      setMsg("请选择证件类型!");
      return JSON;
    }
    if(aac002.length() == 0){
      setMsg("请输入证件号码！");
      return JSON;
    }
    if("1".equals(yae181)){
      if(aac002.length() != 18){
        setMsg("身份证号不是18位，请确认后再录入","error");
        return JSON;
      }
      Map idMap = new HashMap<String, String>();
      idMap.put("aac002", aac002);
      idMap.put("yae181", "1");
      idMap.put("aab001", aab001);
      String xml = baseCommService.getCheckID(XmlConverUtil.map2Xml(idMap));
      Map prcdto = XmlConverUtil.xml2Map(xml);
      String message = (String)prcdto.get("ErrorMsg");
      if(!ValidateUtil.isEmail(message)){
        setMsg("身份证号不合法!","error");
        return JSON;
      }
      String id18 = (String)prcdto.get("prm_id18");
      if(ValidateUtil.isEmpty(id18)){
        setMsg("身份证号不合法!","error");
        return JSON;
      }
      setData("aac006", YhcipUtil.getBirthdayFromPersonIDCode(id18));
      setData("aac004", YhcipUtil.getGenderFromPersonIDCode(id18));
      setData("aac002",id18);
      String addXml = addservice.getCheckAddID(XmlConverUtil.map2Xml(idMap));
      prcdto = XmlConverUtil.xml2Map(addXml);
      String prm_sign = (String)prcdto.get("prm_sign");
      if(prm_sign.equals("1")){
        setMsg((String)prcdto.get("prm_msg"),"error");
        return JSON;
      }
    }
    else{
      Map idMap = new HashMap<String, String>();
      idMap.put("aac002", aac002);
      idMap.put("yae181", "2");
      String xml = addservice.getCheckAddID(XmlConverUtil.map2Xml(idMap));
      Map prcdto = XmlConverUtil.xml2Map(xml);
      String prm_sign = (String)prcdto.get("prm_sign");
      if(prm_sign.equals("1")){
        setMsg((String)prcdto.get("prm_msg"),"error");
        return JSON;
      }
    }
    return JSON;
  }

  
  
  /**
   * -------------------------------------<br>
   * @Title: getContributionBase
   * @Description: 获取缴费基数
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String getContributionBase() throws Exception {
    ParamDTO dto = getDto();
    Map inMap = new HashMap();
    // 经办人编号
    inMap.put("yae092", dto.getUserInfo().getUserId());
    String aab001 = dto.getAsString("aab001");
    // 获取申报工资设置变量
    String aac040 = dto.getAsString("aac040");
    String aae110 = null;
    String aae120 = null;
    String aae310 = null;
    // 申报月度
    String aae002 = dto.getAsString("iaa100");
    HashMap map03 = new HashMap();
    // 取企业职工养老和机关事业养老
    String[] group = getDto().getAsStringArray("insurance");
    for (int i = 0; i < group.length; i++) {
      String xzlx = group[i];
      if ("01".equals(xzlx)) {
        aae110 = "01";
      }
      if ("06".equals(xzlx)) {
        aae120 = "06";
      }
      if ("03".equals(xzlx)) {
        aae310 = "03";
      }
    }
    map03.put("prm_aac040", aac040);
    map03.put("prm_aae002", aae002);
    map03.put("prm_aab001", aab001);
    map03.put("prm_yab139", dto.getUserInfo().getOrgId());
    if ("03".equals(aae310)) {
      map03.put("prm_aae140", "03");
    } else {
      map03.put("prm_aae140", "04");
    }
    String xml = baseCommService.getYac005(XmlConverUtil.map2Xml(map03));
    Map yac005Map = XmlConverUtil.xml2Map(xml);
    BigDecimal yac005 = BigDecimal.valueOf(Double.valueOf((String) yac005Map.get("yac005")));
    setData("yac005", yac005.setScale(0, BigDecimal.ROUND_HALF_UP));
    if ("01".equals(aae110)) {
      map03.put("prm_aae140", "01");
      xml = baseCommService.getYac005(XmlConverUtil.map2Xml(map03));
      Map yac004Map = XmlConverUtil.xml2Map(xml);
      BigDecimal yac004 = BigDecimal.valueOf(Double.valueOf((String) yac004Map.get("yac005")));
      setData("yac004", yac004.setScale(0, BigDecimal.ROUND_HALF_UP));
    }
    if ("06".equals(aae120)) {
      setData("yac004", aac040);
    }
    if (!("01".equals(aae110)) && !("06".equals(aae120))) {
      setData("yac004", "0");
    }
    return JSON;
  }

  
  
  /**
   * -------------------------------------<br>
   * @Title: exportToExcel
   * @Description: 导出申报人员Excel文件
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String exportToExcel() throws Exception {
    ParamDTO dto = getDto();
    String yae092 = dto.getUserInfo().getUserId();
    Map inMap = new HashMap();
    inMap.put("yae092", yae092);
    inMap.put("iaa100", dto.getAsString("iaa100"));
    String listXml = service.getExpList(XmlConverUtil.map2Xml(inMap));
    List list = XmlConverUtil.xml2List(listXml);
    if (!list.isEmpty()) {
      List dList = new ArrayList();
      for (int i = 0; i < list.size(); i++) {
        Map m = (Map) list.get(i);
        Irac01Domain irac01 = new Irac01Domain();
        irac01.setAac003((String) m.get("aac003"));
        irac01.setAac002((String) m.get("aac002"));
        irac01.setIaa001((String) m.get("iaa001"));
        if (ValidateUtil.isEmpty((String) m.get("aac030"))) {
          irac01.setAac030(null);
        } else {
          irac01.setAac030(Timestamp.valueOf((String) m.get("aac030")));
        }
        if (ValidateUtil.isEmpty((String) m.get("aac040"))) {
          irac01.setAac040(null);
        } else {
          irac01.setAac040(BigDecimal.valueOf(Double.valueOf((String) m.get("aac040"))));
        }
        if (ValidateUtil.isEmpty((String) m.get("yac004"))) {
          irac01.setYac004(null);
        } else {
          irac01.setYac004(BigDecimal.valueOf(Double.valueOf((String) m.get("yac004"))));
        }
        if (ValidateUtil.isEmpty((String) m.get("yac005"))) {
          irac01.setYac005(null);
        } else {
          irac01.setYac005(BigDecimal.valueOf(Double.valueOf((String) m.get("yac005"))));
        }
        irac01.setAae110((String) m.get("aae110"));
        irac01.setAae120((String) m.get("aae120"));
        irac01.setAae210((String) m.get("aae210"));
        irac01.setAae310((String) m.get("aae310"));
        irac01.setAae410((String) m.get("aae410"));
        irac01.setAae510((String) m.get("aae510"));
        irac01.setAae311((String) m.get("aae311"));
        dList.add(m);
      }
      HttpServletResponse response = ServletActionContext.getResponse();
      HttpServletRequest request = ServletActionContext.getRequest();
      String fileName = "";
      fileName = fileName.concat("申报月度为").concat(dto.getAsString("iaa100")).concat("的全体申报人员信息.xls");
      String colMetaStr = "aac003`姓名^aac002`社会保障号码^iaa001`申报类别^aac030`增减时间^aac040`申报工资^yac004`企业养老基数^yac005`其它缴费基数^aae110`企业养老^aae120`机关养老^aae210`失业保险^aae310`基本医疗^aae410`工伤保险^aae510`生育保险^aae311`大额补助^";
      export(request, response, fileName, colMetaStr, dList, Irac01Domain.class);
    } else {
      setMsg("结果为空");
      return null;
    }
    return null;
  }

  
  
  /**
   * -------------------------------------<br>
   * @Title: export
   * @Description: 导出方法
   * @return: void
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  private void export(HttpServletRequest request,
      HttpServletResponse response, String fileName, String colMetaStr,
      List list, Class c) throws Exception {
    fileName = new String(fileName.getBytes("GBK"), "ISO8859-1");
    String CONTENT_TYPE = "application/octet-stream";
    response.setContentType(CONTENT_TYPE);
    response.setHeader("Content-disposition", "attachment;filename=" + fileName);
    if (ValidateUtil.isNotEmpty(list)) {
      SaveAsInfo saveAsInfo = new SaveAsInfo(c);
      saveAsInfo.setDomainList(list);
      saveAsInfo.setFileName(fileName);
      saveAsInfo.setViewTitle(true);
      saveAsInfo.setShowCode(false);
      List columnMetas = new ArrayList();
      ColumnInfo columnMeta = null;
      StringTokenizer entrys = new StringTokenizer(colMetaStr, "^");
      while (entrys.hasMoreTokens()) {
        StringTokenizer items = new StringTokenizer(entrys.nextToken(),
            "`");
        columnMeta = new ColumnInfo();
        columnMeta.setColumnName(items.nextToken());
        columnMeta.setFieldName(columnMeta.getColumnName());
        columnMeta.setTitlecomment(items.nextToken());
        columnMeta.setShowCode(false);
        columnMetas.add(columnMeta);
      }
      saveAsInfo.setColumnList(columnMetas);
      ByteArrayOutputStream bos = null;
      if (fileName.indexOf(".xls") > 0)
        bos = ExcelFileUtils.saveAsDomainListToExcelFile(request,
            response, saveAsInfo);
      else {
        bos = TxtFileUtils.saveAsDomainListToTxtFile(request, response,
            saveAsInfo);
      }
      DataOutputStream out = new DataOutputStream(response
          .getOutputStream());
      bos.writeTo(out);
      out.flush();
      out.close();
      bos.flush();
      bos.close();
    }
  }
  
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: printMonthPayConfirm
   * @Description: 打印缴费申报确认书  润乾Action: RqMonthPayConfirmPrint
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String printMonthPayConfirm() throws Exception{
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String)ab01.get("aab001");
    String iaa100 = request.getParameter("iaa100");
    //润乾报表名称
    String raq = "Month_Pay_Confirm";
    request.setAttribute("raq", raq);
    Map map = new HashMap();
    map.put("aab001",aab001);
    map.put("iaa100",iaa100);
    RqReportUtil.setReport(raq, map, request);
    return "printhmc";
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: printMonthDetail
   * @Description: 打印地税缴费申报表  润乾Action: RqPaymentApplicationPrint
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String printMonthDetail() throws Exception {
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String) ab01.get("aab001");
    String iaa100 = request.getParameter("iaa100");
    String yae010 = request.getParameter("yae010");
    // 润乾报表名称
    String raq = "Payment_Application";
    Map map = new HashMap();
    map.put("aab001", aab001);
    map.put("iaa100", iaa100);
    map.put("yae010", yae010);
    /*打印报表时获得不同征收方式对应的险种*/
    String xml = baseCommService.getAAE140WithAAB033(XmlConverUtil.map2Xml(map));
    map.put("aae140", XmlConverUtil.xml2Map(xml).get("aae140"));
    /*打印报表时获得不同征收方式对应的险种*/
    RqReportUtil.setReport(raq, map, request);
    return "printhmc";
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: printMonthPayBaseData
   * @Description: 打印缴费申报明细表   润乾Action: RqPaymentDetailPrint
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String printMonthPayBaseData() throws Exception {
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String) ab01.get("aab001");
    String iaa100 = request.getParameter("iaa100");
    // 润乾报表名称
    String raq = "Shenbao_Payment_Detail";
    Map map = new HashMap();
    map.put("aab001", aab001);
    map.put("iaa100", iaa100);
    RqReportUtil.setReport(raq, map, request);
    return "printhmc";
  }
  
  
  
  /**
   * -------------------------------------<br>
   * @Title: printAddReduce
   * @Description: 打印增减变动表   润乾Action: RqPersoNumberChangePrint
   * @return: String
   * @date: 2019年3月12日
   * @A19
   * -------------------------------------<br>
   */
  @SuppressWarnings({ "rawtypes", "unchecked" })
  public String printAddReduce() throws Exception {
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String)ab01.get("aab001");
    String iaa100 = request.getParameter("iaa100");
    //润乾报表名称
    String raq = "PersonNumber_Change";
    Map map = new HashMap();
    map.put("aab001",aab001);
    map.put("iaa100",iaa100);
    RqReportUtil.setReport(raq, map, request);      
    return "printhmc";
  }
}
