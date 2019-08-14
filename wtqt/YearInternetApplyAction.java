package com.yinhai.nethall.company.yearApply.action;

import com.yinhai.nethall.company.yearApply.service.YearInternetApplyService;
import com.yinhai.nethall.nethallcommon.action.NetHallBaseAction;
import com.yinhai.nethall.nethallcommon.domain.Irac01Domain;
import com.yinhai.nethall.nethallcommon.service.BaseCommService;
import com.yinhai.nethall.nethallcommon.utils.ExcelReportUtil;
import com.yinhai.nethall.nethallcommon.utils.RqReportUtil;
import com.yinhai.nethall.nethallcommon.utils.XmlConverUtil;
import com.yinhai.nethall.transfer.service.PensionTrunService;
import com.yinhai.sysframework.app.domain.Key;
import com.yinhai.sysframework.dto.ParamDTO;
import com.yinhai.sysframework.menu.IMenu;
import com.yinhai.sysframework.persistence.PageBean;
import com.yinhai.sysframework.print.ColumnInfo;
import com.yinhai.sysframework.print.SaveAsInfo;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.sysframework.util.WebUtil;
import com.yinhai.yhcip.print.domain.ExcelPrintDomain;
import com.yinhai.yhcip.print.util.ExcelFileUtils;
import com.yinhai.yhcip.print.util.TxtFileUtils;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

@SuppressWarnings("unchecked")
@Namespace("/nethall/company/yearApply")
@Action(value = "yearInternetApplyAction",
    results = {@Result(name = "success", location = "/nethall/company/yearApply/yearInternetApply.jsp"),
        @Result(name = "yearApplyInfo", location = "/nethall/company/yearApply/yearApplyInfo.jsp"),
        @Result(name = "yearApplyUnitInfo", location = "/nethall/company/yearApply/yearApplyUnitInfo.jsp"),
        @Result(name = "yearApplyUnitBtnPanel", location = "/nethall/company/yearApply/yearApplyUnitBtnPanel.jsp"),
        @Result(name = "printhmc", location = "/servlets/rqPdfPrint")})
public class YearInternetApplyAction extends NetHallBaseAction {
  private PensionTrunService pensionTrunService = (PensionTrunService) super.getService("pensionTrunService");
  private YearInternetApplyService service = (YearInternetApplyService) super.getService("yearInternetApplyService");
  private BaseCommService baseCommService = (BaseCommService) super.getService("baseCommService");

  private String colMetaStr = "aab001`单位助记码^yab029`养老个人编号^aac001`个人编号^aac002`社会保障号^aac003`姓名^yac506`原缴费工资^aac040`新缴费工资^aae013`备注";

  private File theFile;
  private String theFileFileName;
  private String theFileContentType;



  public File getTheFile() {
    return theFile;
  }



  public void setTheFile(File theFile) {
    this.theFile = theFile;
  }



  public String getTheFileFileName() {
    return theFileFileName;
  }



  public void setTheFileFileName(String theFileFileName) {
    this.theFileFileName = theFileFileName;
  }



  public String getTheFileContentType() {
    return theFileContentType;
  }



  public void setTheFileContentType(String theFileContentType) {
    this.theFileContentType = theFileContentType;
  }



  public String execute() throws Exception {
    //暂停功能 modify by fenggg at 20180624
		/*if (super.getMsg("10").equals("0")) {
			return SUCCESS;
		}*/
    queryForm();
    return super.SUCCESS;
  }


  /**-------------------------------------<br>
   * @title: confirmTip
   * @description: 确认承诺书
   * @return: java.lang.String
   * @date: 2019/8/6 16:04
   * @A19
   * -------------------------------------<br>
   */
  public String confirmTip() throws Exception{
    ParamDTO dto = getDto();

    /* 查询是否存在承诺书数据 */
    Map inMap = new HashMap();
    inMap.put("aab001", dto.get("aab001"));
    inMap.put("aae001", dto.get("aae001"));
    inMap.put("yae031", "1");
    String xml = service.getConfirmTip(XmlConverUtil.map2Xml(inMap));
    Map map = XmlConverUtil.xml2Map(xml);
    Integer countconfm = Integer.valueOf(map.get("countconfm")+"");
    /* 写入承诺书数据 */
    if (countconfm==0&&"1".equals(dto.get("yae031"))){
      service.insertConfirmTip(XmlConverUtil.map2Xml(inMap));
      countconfm+=1;
    }
    /* 存在未确认的就提示 */
    if(countconfm==0){
      setData("warningTips", "承诺书"); //
    }
    return JSON;
  }



  /**
   * 页面初始化时的判断！
   *
   * @return
   * @throws Exception
   */
  public String queryForm() throws Exception {
    ParamDTO dto = getDto();
    Map inMap = new HashMap();
    /* 经办人编号 */
    inMap.put("yae092", dto.getUserInfo().getUserId());
    inMap.put("yab139", dto.getUserInfo().getOrgId());

    /* 单位信息校验 */
    String xml = baseCommService.getAab001ByYae092(dto.getUserInfo().getUserId());
    Map out = XmlConverUtil.xml2Map(xml);
    if (out.get("prm_sign").equals("1")) {
      setMsg((String) out.get("prm_msg"), "error");
      super.setDisabled("save,save2,preview,dcqb,print1,print2,print3,print4");
      return JSON;
    }
    String aab001 = (String) out.get("aab001");
    Map map = new HashMap();
    map.putAll(inMap);
    map.put("aab001", aab001);
    xml = baseCommService.getIrab01ByAab001(XmlConverUtil.map2Xml(map));
    setData(XmlConverUtil.xml2Map(xml), false);
    map.put("yab139", dto.getUserInfo().getOrgId());

    /* 年审效验 */
    String outXml = service.checkYearApply(XmlConverUtil.map2Xml(map));
    Map outMap = XmlConverUtil.xml2Map(outXml);
    setData("xx01", outMap.get("xx01"));  //省社平下线
    setData("sx01", outMap.get("sx01"));  //省社平上线
    setData("xx03", outMap.get("xx03"));  //市社平下线
    setData("sx03", outMap.get("sx03"));  //市社平上线
    String aae001 = (String) outMap.get("aae001");
    String msg = (String) outMap.get("msg");
    String disabledBtn = (String) outMap.get("disabledBtn");
    setData("aae001", aae001);  // 年审年度是从AB02AAE042 和 IRAB08 来的
    if (ValidateUtil.isNotEmpty(msg)) {
      setMsg(msg);
    }
    setDisabled(disabledBtn);
    return JSON;
  }



  /**
   * 查询人员基数信息
   *
   * @return
   * @throws Exception
   */
  public String queryDetail() throws Exception {
    ParamDTO dto = getDto();
    HashMap map = new HashMap();
    map.put("yae092", dto.getUserInfo().getUserId());
    map.put("aab001", dto.getAsString("aab001"));
    Map m = new HashMap();
    IMenu menu = WebUtil.getCurrentMenu(request);
    String url = menu.getUrl();
    m.put("aab001", dto.getAsString("aab001"));
    m.put("url", url);
    String xmlab01t2 = pensionTrunService.queryAb01t2(XmlConverUtil.map2Xml(m));
    Map dwbaList = XmlConverUtil.xml2Map(xmlab01t2);
    if (!ValidateUtil.isEmpty(dwbaList)) {
      List YLlistab01t1 = (List) dwbaList.get("YLlistab01t1");
      Map mp = (Map) YLlistab01t1.get(0);
      String aae013 = (String) mp.get("aae013");
      setMsg("你单位此功能已暂时冻结无法操作 原因:" + aae013, "error");
      super.setDisabled("applyBtn");
      return JSON;
    }
    map.put("aae001", dto.getAsString("aae001"));
    Integer start = dto.getStart("sucGrid") == null ? Integer.valueOf(0) : dto.getStart("sucGrid");
    Integer limit = dto.getLimit("sucGrid") == null ? Integer.valueOf(0) : dto.getLimit("sucGrid");
    //查询单位人员信息
    String outXml = service.queryEmps(XmlConverUtil.map2XmlWithPage(map, start, start + limit));
    PageBean list1 = XmlConverUtil.xml2PageBean(outXml);
    setList("sucGrid", list1);
    return JSON;
  }



  /**
   * 暂存方法
   *
   * @return
   * @throws Exception
   */
  public String save() throws Exception {
    ParamDTO dto1 = getDto();
    String yab003 = dto1.getUserInfo().getOrgId();
    String aae001 = dto1.getAsString("aae001");
    String aab001 = dto1.getAsString("aab001");
    List keys = getModified("sucGrid");
    if (ValidateUtil.isEmpty(keys)) {
      setSuccess(false);
      setMsg("数据没有做修改！");
      return JSON;
    }
    if (keys != null && keys.size() > 0) {
      for (int i = 0; i < keys.size(); i++) {
        Key key = (Key) keys.get(i);
        ParamDTO dto = new ParamDTO();
        dto.put("aae001", aae001);
        dto.put("yab003", yab003);
        dto.putAll(key);
        service.updateYac004(XmlConverUtil.map2Xml(dto));
      }
      setMsg("暂存成功!");
    }
    return JSON;
  }



  /**
   * 提交年审信息
   *
   * @return
   * @throws Exception
   */
  @SuppressWarnings("rawtypes")
  public String apply() throws Exception {
    ParamDTO dto = getDto();
    dto.put("yae092", dto.getUserInfo().getUserId());
    String yab003 = dto.getUserInfo().getOrgId();
    String aae001 = dto.getAsString("aae001");
    List keys = getModified("sucGrid");
    /* 判断提交年审养老新基数有没有为null的，防止浏览器没有生成养老新基数 */
    if (keys != null && keys.size() > 0) {
      int cs = 0;
      for (int i = 0; i < keys.size(); i++) {
        Key yac004 = (Key) keys.get(i);
        String yljs = yac004.getAsBigDecimal("yac004").toString();
        if (ValidateUtil.isEmpty(yljs)) {
          cs++;
        }
      }
      if (cs > 0) {
        setMsg("养老新基数可以为0但是不可以为空,请更换谷歌浏览器重新填写数据提交,也可以拨打82227993电话咨询！", "error");
        return JSON;
      }
    }
    /* 页面取得的数据 */
    if (keys != null && keys.size() > 0) {
      for (int i = 0; i < keys.size(); i++) {
        Key key = (Key) keys.get(i);
        ParamDTO dto1 = new ParamDTO();
        dto1.put("aae001", aae001);
        dto1.put("yab003", yab003);
        dto1.putAll(key);
        service.updateYac004(XmlConverUtil.map2Xml(dto1)); //更新ac01k8的基数Yac004
        /* 调用养老接口写入 */
        key.put("aac040", key.getAsBigDecimal("yac004"));
        baseCommService.insertYLINFOBy11(XmlConverUtil.map2Xml(key));
      }
    }
    /* 检查是否能提交申请 */
    String outXml = service.checkIsApply(XmlConverUtil.map2Xml(dto));
    Map outMap = XmlConverUtil.xml2Map(outXml);
    String prm_sign = (String) outMap.get("prm_sign");
    if (prm_sign.equals("1")) {
      setMsg((String) outMap.get("prm_msg"), "error");
      return JSON;
    }
    /* 提交年度基数申报 */
    outXml = service.updateApply(XmlConverUtil.map2Xml(dto));
    outMap = XmlConverUtil.xml2Map(outXml);
    String msg = (String) outMap.get("ErrorMsg");
    if (!ValidateUtil.isEmpty(msg)) {
      setMsg(msg, "error");
      return JSON;
    }
    /* 查询单位当年1月基数是否降低了35%以上,如果是写入到Irad54 */

    /* 回显 */
    queryDetail();
    /* 是否为重点审核单位 */
    String year_0 = String.valueOf(Integer.valueOf(aae001) - 1);
    int j = service.getIrad54Count(XmlConverUtil.map2Xml(dto));
        j = service.getIrad54_1Count(XmlConverUtil.map2Xml(dto));

    if (j == 0) {
      //setMsg("已提交年审信息，请进行年审业务预约，并打印相关报表、携带相关资料，到社保中心审核! </br>社保中心审核通过前如发现有误，可自行撤销提交，修改正确后再次提交办理。" +
      //    "</br>年缴费基数申报审核通过后不能再次进行人员基数变更操作，人员缴费基数标准即不可变更，请各单位认真确认后提交审核！");
      setMsg("已提交年审信息，请等待社保中心审核! </br>社保中心审核通过前如发现有误，可自行撤销提交，修改正确后再次提交办理。" +
          "</br>年缴费基数申报审核通过后不能再次进行人员基数变更操作，人员缴费基数标准即不可变更，请各单位认真确认后提交审核！");
    } else {
      setMsg("已提交年审信息，请进行年审业务预约，并打印相关报表、携带相关资料，到社保中心审核!</br>" +
          "特别提示：你单位" + aae001 + "年度基数年审需加报" + year_0 + "年度会计资料：①" + year_0 + "年1月、" + year_0 + "年12月和提交基数申报时近一个月（例如5月前来办理，可提供4月或3月的装订成册的全部会计凭证（提供原件、复印涉及工资发放情况的凭证页）;" +
          "②上述会计凭证中涉及的工资发放明细表（原件、复印件）;" +
          "③" + year_0 + "年全年应付职工薪酬明细账（或应付工资及应付福利费明细账）（原件、复印件）。" +
          "以上资料的复印件均需加盖公章。 </br>社保中心审核通过前如发现有误，可自行撤销提交，修改正确后再次提交办理。" +
          "年缴费基数申报审核通过后不能再次进行人员基数变更操作，人员缴费基数标准即不可变更，请各单位认真确认后提交审核！");

    }
    setDisabled("exportBtn,importBtn,retainBtn,applyBtn,printBtn3,printBtn4,printBtn5,delBtn");
    setEnable("cancelBtn");
    return JSON;
  }



  /**
   * 撤销提交年审信息
   *
   * @return
   * @throws Exception
   */
  public String cancel() throws Exception {
    ParamDTO dto = getDto();
    dto.put("yae092", dto.getUserInfo().getUserId());
    service.updateCancel(XmlConverUtil.map2Xml(dto));
    queryDetail();
    setMsg("已撤销提交，修改正确后再次提交年审信息。");
    setEnable("exportBtn,importBtn,retainBtn,applyBtn,delBtn");
    setDisabled("printBtn1,printBtn2,printBtn3,printBtn4,printBtn5,cancelBtn");
    return JSON;
  }



  /**
   * 查看个人补差缴费信息
   *
   * @return
   */
  public String perInfo() throws Exception {
    ParamDTO dto = getDto();
    dto.put("yae092", dto.getUserInfo().getUserId());
    dto.put("yab139", dto.getUserInfo().getOrgId());
    String aac040 = dto.getAsString("aac040");

    if (ValidateUtil.isEmpty(aac040)) {
      setSuccess(false);
      setMsg("新工资未填写，填写后再查看！");
      return JSON;
    }
    String infoXml = service.getPerInfo(XmlConverUtil.map2Xml(dto));
    List infoList = XmlConverUtil.xml2List(infoXml);
    setList("personalInfo", infoList);
    return "yearApplyInfo";
  }



  /**
   * 年审信息预览
   *
   * @return
   * @throws Exception
   */
  public String perView() throws Exception {
    ParamDTO dto = getDto();
    dto.put("yae092", dto.getUserInfo().getUserId());
    dto.put("yab139", dto.getUserInfo().getOrgId());
    String infoXml = service.getPerView(XmlConverUtil.map2Xml(dto));
    List infoList = XmlConverUtil.xml2List(infoXml);
    setList("unitInfo", infoList);
    setData("aae001_1", dto.getAsString("aae001"));
    setData("aab001_1", dto.getAsString("aab001"));
    return "yearApplyUnitInfo";
  }



  /**
   * 文件导入并更新
   *
   * @return
   * @throws Exception
   */
  public String importExcel() throws Exception {
    ParamDTO dto = getDto();
    String aae011 = dto.getUserInfo().getUserId();
    String aab001 = dto.getAsString("aab001");
    String aae001 = dto.getAsString("aae001");
    dto.put("yae092", aae011);
    dto.put("aab001", aab001);
    dto.put("aae001", aae001);
    dto.put("iaa002", "0");
    if (aab001 == null || aab001 == "") {
      setMsg("单位信息有误！");
      return SUCCESS;
    }

    List list = null;
    if (theFile == null) {
      setMsg("请先上传文件！");
      queryForm();
      queryDetail();
      return SUCCESS;
    }
    // 获得上传的文件流
    InputStream fin = new FileInputStream(theFile.getPath());
    // 判断文件类型，调用相应的工具类的方法
    if (getTheFileFileName().indexOf(".xls") > 0) {
      // 获得excel文件中的数据
      list = ExcelFileUtils
          .getExcelInputStream2ObjectList(
              fin,
              "aab001,yab029,aac001,aac002,aac003,yac506,aac040",
              "com.yinhai.nethall.nethallcommon.domain.Irac01Domain",
              true);
    } else {
      setMsg("文件格式只能为.xls（03版excel）！", "error");
      queryForm();
      queryDetail();
      return SUCCESS;
    }

    if (list.size() < 1) {
      setMsg("模版中没有有效数据，请仔细检查！");
      queryForm();
      queryDetail();
      return SUCCESS;
    }
    List ab05a1List = new ArrayList();
    //将domain转成map
    for (int i = 0; i < list.size(); i++) {
      Irac01Domain domain = (Irac01Domain) list.get(i);
      Map map = new HashMap();
      map = domain.toMap();
      map.put("aae001", aae001);
      ab05a1List.add(map);
    }
    dto.put("ab05a1List", ab05a1List);
    String outXml = service.updatePLab05a1(XmlConverUtil.map2Xml(dto));
    Map result = XmlConverUtil.xml2Map(outXml);
    String msg = (String) result.get("message");
    if (ValidateUtil.isNotEmpty(msg)) {
      queryForm();
      queryDetail();
      setMsg(msg);
      return SUCCESS;
    } else {
      setMsg("数据导入成功!");
    }
		/*try{
		// 删除零时文件
		theFile.delete();
		// 关闭流
		fin.close();
		}catch(IOException e){
			e.printStackTrace();
		}*/
    /*
     * 2017-12-07 质检平台 要求修改
     */
    // 删除零时文件
    theFile.delete();
    // 关闭流
    fin.close();
    queryForm();
    queryDetail();
    return SUCCESS;
  }



  /**
   * 年审信息预览导出数据
   *
   * @return
   * @throws Exception
   */
  @SuppressWarnings("rawtypes")
  public String excExport() throws Exception {
    List employeeYD;//每月申报人员明细
    List unitJS;//单位基数汇总
    //Map unitJsHz ;//单位月基数总和
    List employees;//单位人员名单
    HttpServletResponse response = ServletActionContext.getResponse();
    HttpServletRequest request = ServletActionContext.getRequest();
    Map param = new HashMap();
    param.put("yae092", getDto().getUserInfo().getUserId());
    String aae140 = request.getParameter("aae140");
    String year = request.getParameter("aae001");
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(param));
    Map ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String) ab01.get("aab001");
    param.put("aae001", year);
    param.put("aae140", aae140);
    param.put("aab001", aab001);
    String xz = "";
    if (aae140.equals("01")) {
      xz = "职工养老";
    }
    if (aae140.equals("02")) {
      xz = "职工失业";
    }
    if (aae140.equals("03")) {
      xz = "职工医疗";
    }
    if (aae140.equals("04")) {
      xz = "职工工伤";
    }
    if (aae140.equals("05")) {
      xz = "职工生育";
    }
    if (aae140.equals("06")) {
      xz = "机关养老";
    }
    if (aae140.equals("07")) {
      xz = "大病补充";
    }
    String outXml = service.getYearApplyExportData(XmlConverUtil.map2Xml(param));  //年审信息预览导出数据
    Map result = XmlConverUtil.xml2Map(outXml);
    result.put("xz", xz);
    String aab004 = (String) result.get("aab004");
    employees = (List) result.get("employees");
    unitJS = (List) result.get("unitJS");
    employeeYD = (List) result.get("employeeYD");
    String fileName = aab001.concat(aab004).concat(xz + year + "年度基数申报名单.xls");

    // 打印数据准备
    String templateFileName = "UnitYearAuditExcel";//模板名
    String destFileName = new String(fileName.getBytes("GBK"), "ISO-8859-1");//ISO-8859-1
    ExcelPrintDomain print = new ExcelPrintDomain(request.getSession().getServletContext());
    print.setDomaina(result);//单位信息
    print.setDomainb(result);
    print.setLista(employees);
    print.setListb(unitJS);
    print.setListc(employeeYD);

    Map beans = new HashMap();
    beans.put("print", print);
    // 输出文件
    response.setContentType("*/*");
    response.setHeader("Content-disposition", "attachment; filename=" + destFileName);
    OutputStream out = response.getOutputStream();
    try {
      ExcelReportUtil.excelSinglePrint2OutputStreamByDbTemplate(templateFileName, beans, out);
      out.close();
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    return null;
  }



  /**
   * 导出单位员工年审核申报表
   *
   * @return
   * @throws Exception
   */
  public String exportData() throws Exception {
    ParamDTO dto = getDto();
    Map map = new HashMap();
    String aab001 = dto.getAsString("aab001");
    String aae001 = dto.getAsString("aae001");
    map.put("aab001", aab001);
    map.put("aae001", aae001);

    String listXml = service.getExportData(XmlConverUtil.map2Xml(map));
    List worker = XmlConverUtil.xml2List(listXml);
    HttpServletResponse response = ServletActionContext.getResponse();

    if (!worker.isEmpty()) {

      String fileName = aab001 + "单位员工年审核申报表.xls";

      export(request, response, fileName, colMetaStr, worker, Irac01Domain.class);
    } else {
      setMsg("结果为空");
      return "success";
    }
    return null;
  }



  private void export(HttpServletRequest request,
                      HttpServletResponse response, String fileName, String colMetaStr,
                      List list, Class c) throws Exception {

    fileName = new String(fileName.getBytes("GBK"), "ISO8859-1");
    String CONTENT_TYPE = "application/octet-stream";
    response.setContentType(CONTENT_TYPE);
    response.setHeader("Content-disposition", "attachment;filename="
        + fileName);
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
        columnMetas.add(columnMeta);
      }

      saveAsInfo.setColumnList(columnMetas);
      ByteArrayOutputStream bos = null;
      // 根据文件类型，调用不同的工具类方法
      if (fileName.indexOf(".xls") > 0)
        bos = ExcelFileUtils.saveAsDomainListToExcelFile(request, response, saveAsInfo);
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



  //导出明细按钮板
  public String btnPanel() throws Exception {
    ParamDTO dto = getDto();
    String aab001 = dto.getAsString("aab001");
    String aae001 = dto.getAsString("aae001");
    setData("aab001_1", aab001);
    setData("aae001_1", aae001);
    return "yearApplyUnitBtnPanel";
  }



  //导出补差明细excel
  public String exportBCDetail() throws Exception {
    List bclist;//每月人员补差明细
    HttpServletResponse response = ServletActionContext.getResponse();
    HttpServletRequest request = ServletActionContext.getRequest();
    ParamDTO dto = getDto();
    String aae140 = request.getParameter("aae140");
    String year = request.getParameter("aae001");
    String yae092 = dto.getUserInfo().getUserId();
    dto.put("yae092", yae092);
    dto.put("aae140", aae140);
    String xz = "";
    if (aae140.equals("01")) {
      xz = "职工养老";
    }
    if (aae140.equals("02")) {
      xz = "职工失业";
    }
    if (aae140.equals("03")) {
      xz = "职工医疗";
    }
    if (aae140.equals("04")) {
      xz = "职工工伤";
    }
    if (aae140.equals("05")) {
      xz = "职工生育";
    }
    if (aae140.equals("06")) {
      xz = "机关养老";
    }
    if (aae140.equals("07")) {
      xz = "大病补充";
    }
    String unitInfoXml = service.queryUnitInfo(XmlConverUtil.map2Xml(dto));
    Map result = XmlConverUtil.xml2Map(unitInfoXml);
    result.put("xz", xz);
    String aab001 = (String) result.get("aab001");
    String aab004 = (String) result.get("aab004");
    dto.put("aab001", aab001);
    dto.put("aae001", year);
    String fileName = aab001.concat(aab004).concat(xz + year + "年度基数申报月补差明细表.xls");
    String bclistXml = service.queryBcList(XmlConverUtil.map2Xml(dto));

    bclist = XmlConverUtil.xml2List(bclistXml);
    // 打印数据准备
    String templateFileName = "BCDetailExcel";//模板名

    String destFileName = new String(fileName.getBytes("GBK"), "ISO-8859-1");//ISO-8859-1
    ExcelPrintDomain print = new ExcelPrintDomain(request.getSession().getServletContext());
    print.setDomaina(result);//单位信息
    print.setLista(bclist);
    Map beans = new HashMap();
    beans.put("print", print);
    // 输出文件
    response.setContentType("*/*");
    response.setHeader("Content-disposition", "attachment; filename=" + destFileName);
    OutputStream out = response.getOutputStream();
    try {
      ExcelReportUtil.excelSinglePrint2OutputStreamByDbTemplate(templateFileName, beans, out);
      out.close();
    } catch (Exception ex) {
      ex.printStackTrace();
    }

    return null;
  }



  /**
   * 基数申报表打印
   *
   * @return
   * @throws Exception
   */
  public String printEmpJS() throws Exception {
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String) ab01.get("aab001");
    String aae001 = request.getParameter("aae001");

    //润乾报表名称
    String raq = "YearApplyEmpJiShu";
    Map map = new HashMap();
    map.put("aab001", aab001);
    map.put("aae001", aae001);
    if (ValidateUtil.isEmpty(request.getParameter("yab019"))) {
      map.put("yab019", "1");
    } else {
      map.put("yab019", request.getParameter("yab019"));
    }
    RqReportUtil.setReport(raq, map, request);
    return "printhmc";
  }



  /**
   * 基数汇总表打印
   *
   * @return
   * @throws Exception
   */
  public String printUnitJSH() throws Exception {
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String) ab01.get("aab001");
    String aae001 = request.getParameter("aae001");
    //润乾报表名称
    String raq = "YearApplyUnitJS";
    Map map = new HashMap();
    map.put("aab001", aab001);
    map.put("aae001", aae001);
    RqReportUtil.setReport(raq, map, request);
    return "printhmc";
  }



  /**
   * 补差申报表
   *
   * @return
   * @throws Exception
   */
  public String printBCDetail() throws Exception {
    Map ab01 = new HashMap();
    ab01.put("yae092", getDto().getUserInfo().getUserId());
    String ab01Xml = baseCommService.getAb01ByYae092(XmlConverUtil.map2Xml(ab01));
    ab01 = XmlConverUtil.xml2Map(ab01Xml);
    String aab001 = (String) ab01.get("aab001");
    String aae001 = request.getParameter("aae001");
    String yae010 = request.getParameter("yae010");
    //润乾报表名称
    String raq = "YearAuditBC";
    Map map = new HashMap();
    map.put("aab001", aab001);
    map.put("aae001", aae001);
    map.put("yae010", yae010);

    /*打印报表时获得不同征收方式对应的险种*/
    String xml = baseCommService.getAAE140WithAAB033(XmlConverUtil.map2Xml(map));
    map.put("aae140", XmlConverUtil.xml2Map(xml).get("aae140"));
    /*打印报表时获得不同征收方式对应的险种*/

    RqReportUtil.setReport(raq, map, request);
    return "printhmc";
  }



  /**
   * 信息清除
   *
   * @return
   * @throws Exception
   */
  public String clear() throws Exception {
    ParamDTO dto = getDto();
    dto.put("aae011", dto.getUserInfo().getUserId());
    String xml = service.deleteClear(XmlConverUtil.map2Xml(dto));
    Map map = XmlConverUtil.xml2Map(xml);
    if (!ValidateUtil.isEmpty(map)) {
      if (map.get("flag").equals("1")) {
        setMsg(map.get("msg") + "", "warn");
        return JSON;
      }
    }
    setList("sucGrid", new ArrayList());
    setMsg("数据清除成功！");
    return JSON;
  }
}