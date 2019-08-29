package com.yinhai.xagxsi.internetaudit.basicbusi.action;

import com.runqian.report4.dataset.DataSet;
import com.runqian.report4.dataset.IDataSetFactory;
import com.runqian.report4.dataset.Row;
import com.runqian.report4.usermodel.Context;
import com.runqian.report4.usermodel.DataSetConfig;
import com.yinhai.sysframework.app.domain.Key;
import com.yinhai.sysframework.dto.ParamDTO;
import com.yinhai.sysframework.persistence.PageBean;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.webframework.BaseAction;
import com.yinhai.xagxsi.common.common.service.BaseCommonService;
import com.yinhai.xagxsi.common.common.util.Constant;
import com.yinhai.xagxsi.common.common.util.DateUtil;
import com.yinhai.xagxsi.common.common.util.ExcelReportUtil;
import com.yinhai.xagxsi.common.common.util.ZIPUtil;
import com.yinhai.xagxsi.internetaudit.audit.service.MonthInternetAuditService;
import com.yinhai.xagxsi.internetaudit.basicbusi.service.YearInternetCenterAuditService;
import com.yinhai.yhcip.print.domain.ExcelPrintDomain;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.Result;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Namespace("/xagxsi/internetaudit/basicbusi")
@Action(value = "yearInternetCenterAuditAction",
    results = {
        @Result(name = "workerInfo", location = "/xagxsi/internetaudit/basicbusi/theYearWorkerInfo.jsp"),
        @Result(name = "wrongWorkerInfo", location = "/xagxsi/internetaudit/basicbusi/theWrongWorkerInfo.jsp"),
        @Result(name = "success", location = "/xagxsi/internetaudit/basicbusi/yearInternetCenterAudit.jsp"),
        @Result(name = "yearAuditInfo", location = "/xagxsi/internetaudit/basicbusi/yearAuditInfo.jsp"),
        @Result(name = "edit", location = "/xagxsi/internetaudit/basicbusi/yearApplyAudit_MsgEdit.jsp"),
        @Result(name = "secondYearAuditInfo", location = "/xagxsi/internetaudit/basicbusi/yearSecondYearAuditInfo.jsp")
    })

public class YearInternetCenterAuditAction extends BaseAction implements IDataSetFactory {

  private YearInternetCenterAuditService yearInternetCenterAuditService = (YearInternetCenterAuditService) super.getService("yearInternetCenterAuditService");
  private MonthInternetAuditService service = (MonthInternetAuditService) super.getService("monthInternetAuditService");
  BaseCommonService baseCommonService = (BaseCommonService) super.getService("baseCommonService");



  /**
   * 打开并初始化单位信息维护审核页面
   *
   * @return
   * @throws Exception
   */
  public String execute() throws Exception {
    ParamDTO dto = getDto();
    String month = DateUtil.getCurMonth();
    String year = month.substring(0, 4);
    dto.put("iaa002", "1");
    dto.put("aae001", year);
    //List list = yearInternetCenterAuditService.getAuditInfo(dto);
    //分页修改
    PageBean list = this.getDao().queryForPageWithCount("auditCon", "yearaudit.getAuditInfo", dto, dto);
    setList("auditCon", list);
    setData("audit_1", "1");
    setData("aae001", year);
    return super.SUCCESS;
  }



  /**
   * 查询单位的申报年审信息
   *
   * @return
   * @throws Exception
   */
  public String queryYearAuditInfo() throws Exception {
    ParamDTO dto = getDto();
    String year = dto.getAsString("aae001");
    String audit = dto.getAsStringArray("audit")[0];//获取页面选中的radio
    dto.put("iaa002", audit);
    dto.put("aae001", year);
    if (audit.equals("0")) {
      //List list = this.getDao().queryForList("yearaudit.getUnapplyInfo", dto);
      //分页修改
      PageBean list = this.getDao().queryForPageWithCount("auditCon", "yearaudit.getUnapplyInfo", dto, dto);
      setList("auditCon", list);
    } else {
      //List list = yearInternetCenterAuditService.getAuditInfo(dto);
      //分页修改
      PageBean list = this.getDao().queryForPageWithCount("auditCon", "yearaudit.getAuditInfo", dto, dto);
      setList("auditCon", list);
    }
    //添加是否为重点审核单位
    Integer o = (Integer) this.getDao().queryForObject("yearaudit.getIrad54Count", dto);
    if (o > 0) {
      setMsg("该单位是重点审核单位需要提供资料！");
    }
    Integer p = (Integer) this.getDao().queryForObject("yearaudit.getIrad54Count_1", dto);
    if (p > 0) {
      setMsg("该单位基数降低比例过高！");
    }
    setData("aae001", year);
    return JSON;
  }



  //查询通过的单位
  public String queryYearAuditOK() throws Exception {
    ParamDTO dto = getDto();
    String year = dto.getAsString("aae001");
    dto.put("iaa002", "2");
    dto.put("aae001", year);
    //List list = yearInternetCenterAuditService.getAuditInfo(dto);
    //分页修改
    PageBean list = this.getDao().queryForPageWithCount("auditCon", "yearaudit.getAuditInfo", dto, dto);
    setList("auditCon", list);
    setData("audit_1", "2");
    setData("aae001", year);
    return JSON;
  }



  //查询未通过的单位
  public String queryYearAuditNO() throws Exception {
    ParamDTO dto = getDto();
    String year = dto.getAsString("aae001");
    dto.put("iaa002", "3");
    dto.put("aae001", year);
    //List list = yearInternetCenterAuditService.getAuditInfo(dto);
    //分页修改
    PageBean list = this.getDao().queryForPageWithCount("auditCon", "yearaudit.getAuditInfo", dto, dto);
    setList("auditCon", list);
    setData("audit_1", "1");
    setData("aae001", year);
    return JSON;
  }



  /**
   * 单位人员明细
   *
   * @return
   * @throws Exception
   */
  public String queryTheWorkInfo() throws Exception {
    queryTheWork();
    return "workerInfo";
  }



  public String queryTheWork() throws Exception {
    ParamDTO dto = getDto();
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    if ("".equals(dto.get("aab001")) || dto.get("aab001") == null) {
      writeFailure("没有找到单位助记码！");
    }
    if (dto.get("aae001") == null) {
      writeFailure("没有找到年度！");
    }
    setData("aab001_1", dto.getAsString("aab001"));
    setData("aae001_1", dto.getAsString("aae001"));
    setData("iaa011_1", dto.getAsString("iaa011"));
    //基数调低人员
    Integer i = (Integer) this.getDao().queryForObject("yearaudit.getAb05a1_2", dto);
    //身份证不匹配人员
    Integer j = (Integer) this.getDao().queryForObject("yearaudit.queryTmp_ac02_yanglid", dto);
    //养老对账单位
    Integer k = (Integer) this.getDao().queryForObject("yearaudit.queryTmp_ab01", dto);
    String tip = "";
    String tip_i = "</br>该单位存在基数调低的人员！";
    String tip_j = "</br>该单位存在<font color=red >养老系统</font>和<font color=red >医疗系统</font>身份证号码不同的人员！！待信息核对确认好后再进行年审审核！";
    String tip_k = "</br><font color=red >年审通过后告知该单位到611室优先核对养老！</font>";
    if (i > 0) {
      tip = tip + tip_i;
    }
    if (j > 0) {
      tip = tip + tip_j;
    }
    if (k > 0) {
      tip = tip + tip_k;
    }
    Map map = (Map) this.getDao().queryForObject("yearaudit.queryIrad51_1", dto);
    if (ValidateUtil.isEmpty(map)) {
      setMsg("没有找到单位年申报记录！");
    } else {
      if (((String) map.get("iaa002")).equals("2") || ((String) map.get("iaa002")).equals("3")) {
        setDisabled("partok");
        setDisabled("partAlr");
      }
    }
    //特殊事项备案
    HashMap map1 = new HashMap();
    map1.put("aab001", dto.getAsString("aab001"));
	/*	List tsbzs = this.getDao().queryForList("irab01.getDWBZ",map1);
		if (!ValidateUtil.isEmpty(tsbzs)){
			HashMap tsbz = (HashMap)tsbzs.get(0);
			setMsg(tip+"</br>单位"+(String)tsbz.get("aab001")+"存在特殊备案:"+(String)tsbz.get("aae013"));
		}*/

    List list = this.getDao().queryForList("yearaudit.getAb05a1_1", dto);
    List list1 = this.getDao().queryForList("yearaudit.getTMP_ac42_1", dto);
    List list2 = this.getDao().queryForList("yearaudit.getAb08_1", dto);
    List list3 = this.getDao().queryForList("yearaudit.getTmp_ac02_yanglid", dto);
    List list4 = this.getDao().queryForList("yearaudit.getac01a1", dto);
    List list5 = this.getDao().queryForList("yearaudit.getAb05a1_6", dto);
    Map m1 = new HashMap();
    m1.put("aab001", dto.getAsString("aab001"));
    m1.put("yae031", "1");
    m1.put("aae041", dto.getAsString("aae001") + "01");
    List list6 = this.getDao().queryForList("yearaudit.getIrad51a1", m1);
    setList("grid1", list);
    setList("grid2", list1);
    setList("grid3", list2);
    setList("grid4", list3);
    setList("grid5", list4);
    setList("grid6", list5);
    setList("grid7", list6);
    return JSON;
  }



  /**
   * 查看个人补差信息
   *
   * @return
   * @throws Exception
   */
  public String perInfo() throws Exception {
    ParamDTO dto = getDto();
    dto.put("yae092", dto.getUserInfo().getUserId());
    dto.put("yab139", dto.getUserInfo().getOrgId());
    String aac040 = dto.getAsString("aac040");
    if (aac040.equals("null")) {
      setSuccess(false);
      setMsg("新工资未填写，填写后再查看！");
      return JSON;
    }
    setData("aae001_2", dto.getAsString("aae001"));
    dto.put("aae001", dto.getAsString("aae001"));
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    List infoList = yearInternetCenterAuditService.getPerInfo(dto);
    setList("personalInfo", infoList);

    return "yearAuditInfo";
  }



  /**
   * 审核更新个人补差信息
   *
   * @return
   * @throws Exception
   */
  public String updatePerInfo() throws Exception {
    ParamDTO dto = getDto();
    List keys = getModified("personalInfo");
    if (ValidateUtil.isEmpty(keys)) {
      setSuccess(false);
      setMsg("数据没有改动！");
      return JSON;
    }
    if (keys != null && keys.size() > 0) {
      for (int i = 0; i < keys.size(); i++) {
        Key key = (Key) keys.get(i);
        ParamDTO dto1 = new ParamDTO();
        dto1.putAll(key);
        dto1.put("aae001", dto.get("aae001_2"));
        yearInternetCenterAuditService.updatePerInfo(dto1);
      }
      setMsg("更新成功!");
    }
    return JSON;
  }



  /**
   * 年申报审核[人员 全部通过]
   *
   * @return
   * @throws Exception
   */
  public String perAllok() throws Exception {
    ParamDTO dto = getDto();
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    dto.put("yae092", dto.getUserInfo().getUserId());
    dto.put("iaa018", "2");
    List list = this.getDao().queryForList("yearaudit.getAb05a1_1", dto);
		/*if(ValidateUtil.isEmpty(list)){
			super.setMsg("没有申报人员信息数据!");
			return JSON;
		}*/
    String msg = yearInternetCenterAuditService.updatePass(dto);
    if (ValidateUtil.isEmpty(msg)) {
      setMsg("审核完成！");
    } else {
      setMsg(msg);
    }
    setDisabled("partok,partAlr");
    return JSON;
  }



  /**
   * 年申报审核[人员 全部打回]
   *
   * @return
   * @throws Exception
   */
  public String perAllNO() throws Exception {
    ParamDTO dto = getDto();
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    dto.put("yae092", dto.getUserInfo().getUserId());
    dto.put("iaa018", "3");

    List list = this.getDao().queryForList("yearaudit.getAb05a1_1", dto);
		/*if(ValidateUtil.isEmpty(list)){
			super.setMsg("没有申报人员信息数据!");
			return JSON;
		}*/
    String msg = yearInternetCenterAuditService.updateNoPass(dto);
    if (ValidateUtil.isEmpty(msg)) {
      setMsg("审核完成！");
    } else {
      setMsg(msg);
    }
    setDisabled("partok,partAlr");
    return JSON;
  }



  /**
   * 审核回退
   *
   * @return
   * @throws Exception
   */
  public String rollBackAudit() throws Exception {
    ParamDTO dto = getDto();
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    String msg = yearInternetCenterAuditService.removeAudit(dto);
    if (ValidateUtil.isEmpty(msg)) {
      setMsg("审核回退完成！");
    } else {
      setMsg(msg);
    }
    return JSON;
  }



  /**
   * 年审补差
   *
   * @return
   * @throws Exception
   */

  public String yearSalaryBc() throws Exception {
    ParamDTO dto = getDto();
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    Map map = (Map) this.getDao().queryForObject("yearaudit.queryIrad51_1", dto);
    String yae092 = dto.getUserInfo().getUserId();
    dto.put("yae092", yae092);
    String aae001 = (String) dto.get("aae001");
    dto.put("aae001", Integer.valueOf(aae001));
    if (!dto.getAsString("iaa002").equals("2")) {
      setMsg("审核未通过，不能进行补差操作！");
      return JSON;
    }
    String msg = "";
    if (ValidateUtil.isEmpty(map)) {
      setMsg("没有找到单位年申报记录！");
    } else {
      String iaa002 = (String) map.get("iaa002");
      String iaa006 = (String) map.get("iaa006");
      if (iaa002.equals("2") && iaa006.equals("1")) {
        setMsg("已经做过年审补差操作！");
        return JSON;
      }
      if (iaa002.equals("2") && iaa006.equals("0")) {
        msg = yearInternetCenterAuditService.insertYearSalaryBc(dto);
        if (ValidateUtil.isEmpty(msg)) {
          setMsg("年审补差完成！");

        } else {
          setMsg(msg);
        }
      }

    }
    return JSON;
  }



  /**
   * 根据险种导出单位基数信息excel
   */
  public String excExport() throws Exception {
    HttpServletRequest request = ServletActionContext.getRequest();
    HttpServletResponse response = ServletActionContext.getResponse();
    ParamDTO dto = getDto();
    Map unitJsHz;//单位月基数总和
    List unitJS;//单位基数汇总
    List employees;//单位人员名单
    List employeeYD;//每月申报人员明细
    String aae140 = request.getParameter("aae140");
    dto.put("aae140", aae140);
    String xz = "";
    if (aae140.equals("01")) {
      xz = "职工养老";
    }
    String currentTime = com.yinhai.sysframework.util.DateUtil.getCurrentTime();
    //zip打包的目录
    String zipPath = "D:/tempexcel/" + currentTime + ".zip";
    //批量生成文件存放的目录
    String filePath = "D:/tempexcel/" + currentTime + "/";
    File file = new File(filePath);
    if (!file.mkdirs()) {
      setMsg("临时文件创建出错了");
      return JSON;
    }
    List keys = getSelected("auditCon");
    if (keys.size() > 200) {
      setMsg("勾选超过200条");
      return JSON;
    }
    String aab001 = "";
    String aab004 = "";
    ByteArrayOutputStream bos = null;
    OutputStream out = null;
    //String destFileName = null;
    String fileName = null;
    for (int i = 0; i < keys.size(); i++) {
      Key key = (Key) keys.get(i);
      aab001 = key.getAsString("aab001");
      dto.put("aab001", aab001);
      dto.put("yae092", key.getAsString("yae092"));
      Map result = (Map) this.getDao().queryForObject("yearaudit.queryUnitInfo", dto);
      result.put("xz", xz);
      aab004 = (String) result.get("aab004");
      dto.put("aab001", aab001);
      String month = DateUtil.getCurMonth();
      String year = month.substring(0, 4);
      dto.put("aae001", year);
      fileName = aab001.concat(aab004).concat(xz + year + "年度基数申报名单.xls");

      if (aae140.equals("01")) {
        employees = this.getDao().queryForList("yearaudit.queryab05a1", dto);
        unitJS = this.getDao().queryForList("yearaudit.queryUnitJS", dto);
        employeeYD = this.getDao().queryForList("yearaudit.getIrac01", dto);
        unitJsHz = (Map) this.getDao().queryForObject("yearaudit.querySumJS", dto);

      } else {
        employees = this.getDao().queryForList("yearaudit.queryab05a1", dto);
        unitJS = this.getDao().queryForList("yearaudit.queryUnitJS_1", dto);
        employeeYD = this.getDao().queryForList("yearaudit.getAc08", dto);
        unitJsHz = (Map) this.getDao().queryForObject("yearaudit.querySumJS_1", dto);
      }


      // 打印数据准备
      String templateFileName = "UnitYearAuditExcel";//模板名

      ExcelPrintDomain print;
      print = new ExcelPrintDomain(request.getSession().getServletContext());
      print.setDomaina(result);//单位信息
      print.setDomainb(unitJsHz);
      print.setLista(employees);
      print.setListb(unitJS);
      print.setListc(employeeYD);

      Map beans = new HashMap();
      beans.put("print", print);
      try {
        bos = ExcelReportUtil.excelSinglePrint2OutputStreamTemplate(templateFileName, beans);
        out = new FileOutputStream(filePath + new String(fileName.getBytes("GBK")) + ".xls");
        ExcelReportUtil.excelSinglePrint2OutputStreamByDbTemplate(templateFileName, beans, out);
        bos.writeTo(out);
        out.flush();
      } catch (Exception ex) {
        ex.printStackTrace();
      } finally {
        if (out != null) {
          out.close();
        }
        if (bos != null) {
          bos.close();
        }
      }
    }
    YearInternetCenterAuditAction.expZIP(filePath, zipPath, response);
    return null;

  }



  //工具方法，用于打包指定文件夹成zip文件，然后输入到客户端
  public static void expZIP(String filePath, String zipPath, HttpServletResponse response) throws Exception {
    ZIPUtil.getInstance().createZipFile(filePath, zipPath);
    // 输出到客户端
    String CONTENT_TYPE = "application/octet-stream";
    response.reset();
    response.setContentType(CONTENT_TYPE);
    response.setHeader("Content-Type", CONTENT_TYPE);

    // 设置下载文件时提示的文件名
    response.setHeader("Content-Disposition", "attachment; filename=" + new File(zipPath).getName());


    InputStream instr = new FileInputStream(new File(zipPath));
    OutputStream outstr = response.getOutputStream();
    byte[] bufb = new byte[2048];

    int jx = 0;
    while (0 < (jx = instr.read(bufb, 0, 2048)))
      outstr.write(bufb, 0, jx);
    instr.close();
    outstr.flush();
    outstr.close();
  }



  //批量更新基数降低补差数据
  public String updateJSC() throws Exception {
    ParamDTO dto = getDto();
    String aab001 = dto.getAsString("aab001");
    String iaa011 = dto.getAsString("iaa011");
    if (iaa011.equals("A05")) {
      dto.put("yab019", "1");
    }
    if (iaa011.equals("A16")) {
      dto.put("yab019", "2");
    }
    List list0 = this.getDao().queryForList("yearaudit.getJSJD", dto);
    if (list0.size() == 0) {
      setMsg(aab001 + "单位下没有其他基数降低的人员！");
      return JSON;
    } else {
      yearInternetCenterAuditService.updateTMP(dto);
      setMsg(aab001 + "单位下人员补差基数调整完成，请预览！");
    }
    setData("aab001_1", dto.getAsString("aab001"));
    setData("aae001_1", dto.getAsString("aae001"));
    setData("iaa011_1", dto.getAsString("iaa011"));
    List list = this.getDao().queryForList("yearaudit.getAb05a1_1", dto);
    List list1 = this.getDao().queryForList("yearaudit.getTMP_ac42_1", dto);
    List list2 = this.getDao().queryForList("yearaudit.getAb08_1", dto);
    List list3 = this.getDao().queryForList("yearaudit.getTmp_ac02_yanglid", dto);

    setList("grid1", list);
    setList("grid2", list1);
    setList("grid3", list2);
    setList("grid4", list3);
    return JSON;
  }



  /**
   * 发送短消息
   *
   * @return
   * @throws Exception
   */
  public String getMessageInfo() throws Exception {
    ParamDTO dto = this.getDto();
    dto.put("yae092", dto.getUserInfo().getUserId());
    List list = (List) super.request.getSession().getAttribute("auditConlst");
    dto.put("list", list);
    String msg = service.saveMessageInfo(dto);
    if (ValidateUtil.isNotEmpty(msg)) {
      this.setMsg(msg);
      return JSON;
    }
    this.setMsg("短消息发送成功!");
    return JSON;
  }



  public String messageInfo() throws Exception {
    return "edit";
  }



  public String message() throws Exception {
    List list = getSelected("auditCon");
    this.request.getSession().setAttribute("auditConlst", list);
    return JSON;
  }



  /**
   * 查询审核备注
   *
   * @return
   * @throws Exception
   */
  public String querySHBZ() throws Exception {
    ParamDTO dto = getDto();
    List list = this.getDao().queryForList("yearaudit.queryIrad53", dto);
    setList("bzList", list);
    if (list.size() == 0) {
      setMsg("无备注记录！", "warning");
    }
    return JSON;
  }



  /**
   * 保存审核备注
   *
   * @return
   * @throws Exception
   */
  public String saveSHBZ() throws Exception {
    ParamDTO dto = getDto();
    yearInternetCenterAuditService.saveShbz(dto);
    querySHBZ();
    setMsg("信息保存成功！");
    setData("aae013", "");
    return JSON;
  }



  /**
   * 删除审核备注
   *
   * @return
   * @throws Exception
   */
  public String deleteSHBZ() throws Exception {
    ParamDTO dto = getDto();
    yearInternetCenterAuditService.deleteShbz(dto);
    querySHBZ();
    setMsg("信息删除成功！");
    setData("aae013", "");
    return JSON;
  }



  public DataSet createDataSet(Context arg0, DataSetConfig arg1, boolean arg2) {
    ParamDTO dto = getDto();
    DataSet gsInfo = new DataSet("ds1");
    HashMap map = (HashMap) arg0.getAllParamMap();
    gsInfo.addCol("iaz051");//1编号
    gsInfo.addCol("time1");//2打印时间
    gsInfo.addCol("jjglzx");//3表头
    gsInfo.addCol("title");//4表头

    gsInfo.addCol("aab004");//5单位名称
    gsInfo.addCol("aab001");//6
    gsInfo.addCol("aae006");//7
    gsInfo.addCol("aae007");//8
    gsInfo.addCol("aab020"); //9
    gsInfo.addCol("aab003"); // 10
    gsInfo.addCol("aab013"); // 11
    gsInfo.addCol("aab016"); // 12
    gsInfo.addCol("yab390"); // 13
    gsInfo.addCol("aae001"); // 14
    gsInfo.addCol("cbrs"); // 15
    //养老
    gsInfo.addCol("yjsh0101");//16
    gsInfo.addCol("yjsh0102");//17
    gsInfo.addCol("yjsh0103");//18
    gsInfo.addCol("yjsh0104");//19
    gsInfo.addCol("yjsh0105");//20
    gsInfo.addCol("yjsh0106");//21
    gsInfo.addCol("yjsh0107");//22
    gsInfo.addCol("yjsh0108");//23
    gsInfo.addCol("yjsh0109");//24
    gsInfo.addCol("xjsh0101");//25
    gsInfo.addCol("xjsh0102");//26
    gsInfo.addCol("xjsh0103");//27
    gsInfo.addCol("xjsh0104");//28
    gsInfo.addCol("xjsh0105");//29
    gsInfo.addCol("xjsh0106");//30
    gsInfo.addCol("xjsh0107");//31
    gsInfo.addCol("xjsh0108");//32
    gsInfo.addCol("xjsh0109");//33
    //失业
    gsInfo.addCol("yjsh0201");//34
    gsInfo.addCol("yjsh0202");//35
    gsInfo.addCol("yjsh0203");//36
    gsInfo.addCol("yjsh0204");//37
    gsInfo.addCol("yjsh0205");//38
    gsInfo.addCol("yjsh0206");//39
    gsInfo.addCol("yjsh0207");//40
    gsInfo.addCol("yjsh0208");//41
    gsInfo.addCol("yjsh0209");//42
    gsInfo.addCol("xjsh0201");//43
    gsInfo.addCol("xjsh0202");//44
    gsInfo.addCol("xjsh0203");//45
    gsInfo.addCol("xjsh0204");//46
    gsInfo.addCol("xjsh0205");//47
    gsInfo.addCol("xjsh0206");//48
    gsInfo.addCol("xjsh0207");//49
    gsInfo.addCol("xjsh0208");//50
    gsInfo.addCol("xjsh0209");//51
    //医疗
    gsInfo.addCol("yjsh0301");//52
    gsInfo.addCol("yjsh0302");//53
    gsInfo.addCol("yjsh0303");//54
    gsInfo.addCol("yjsh0304");//55
    gsInfo.addCol("yjsh0305");//56
    gsInfo.addCol("yjsh0306");//57
    gsInfo.addCol("yjsh0307");//58
    gsInfo.addCol("yjsh0308");//59
    gsInfo.addCol("yjsh0309");//60
    gsInfo.addCol("xjsh0301");//61
    gsInfo.addCol("xjsh0302");//62
    gsInfo.addCol("xjsh0303");//63
    gsInfo.addCol("xjsh0304");//64
    gsInfo.addCol("xjsh0305");//65
    gsInfo.addCol("xjsh0306");//66
    gsInfo.addCol("xjsh0307");//67
    gsInfo.addCol("xjsh0308");//68
    gsInfo.addCol("xjsh0309");//69
    //工伤
    gsInfo.addCol("yjsh0401");//70
    gsInfo.addCol("yjsh0402");//71
    gsInfo.addCol("yjsh0403");//72
    gsInfo.addCol("yjsh0404");//73
    gsInfo.addCol("yjsh0405");//74
    gsInfo.addCol("yjsh0406");//75
    gsInfo.addCol("yjsh0407");//76
    gsInfo.addCol("yjsh0408");//77
    gsInfo.addCol("yjsh0409");//78
    gsInfo.addCol("xjsh0401");//79
    gsInfo.addCol("xjsh0402");//80
    gsInfo.addCol("xjsh0403");//81
    gsInfo.addCol("xjsh0404");//82
    gsInfo.addCol("xjsh0405");//83
    gsInfo.addCol("xjsh0406");//84
    gsInfo.addCol("xjsh0407");//85
    gsInfo.addCol("xjsh0408");//86
    gsInfo.addCol("xjsh0409");//87
    //生育
    gsInfo.addCol("yjsh0501");//88
    gsInfo.addCol("yjsh0502");//89
    gsInfo.addCol("yjsh0503");//90
    gsInfo.addCol("yjsh0504");//91
    gsInfo.addCol("yjsh0505");//92
    gsInfo.addCol("yjsh0506");//93
    gsInfo.addCol("yjsh0507");//94
    gsInfo.addCol("yjsh0508");//95
    gsInfo.addCol("yjsh0509");//96
    gsInfo.addCol("xjsh0501");//97
    gsInfo.addCol("xjsh0502");//98
    gsInfo.addCol("xjsh0503");//99
    gsInfo.addCol("xjsh0504");//100
    gsInfo.addCol("xjsh0505");//101
    gsInfo.addCol("xjsh0506");//102
    gsInfo.addCol("xjsh0507");//103
    gsInfo.addCol("xjsh0508");//104
    gsInfo.addCol("xjsh0509");//105

    gsInfo.addCol("aae001");//106
    gsInfo.addCol("jzyd_01");//107
    gsInfo.addCol("jszc01");//108
    gsInfo.addCol("bajszc01");//109
    gsInfo.addCol("tqjs01");//110
    gsInfo.addCol("ksyd_02");//111
    gsInfo.addCol("jzyd_02");//112
    gsInfo.addCol("jszc02");//113
    gsInfo.addCol("jszc0220");//114
    gsInfo.addCol("ksyd_03");//115
    gsInfo.addCol("jzyd_03");//116
    gsInfo.addCol("jszc03");//117
    gsInfo.addCol("jszc05");//118
    gsInfo.addCol("jzyd_04");//119
    gsInfo.addCol("jszc04");//120
    gsInfo.addCol("aae001");//121
    gsInfo.addCol("aae001");//122
    gsInfo.addCol("ksyd_04");//123
    // 取得参数列表并分别取得它的参数名与值,宏与之类似
    if (map == null || map.get("aab001") == null) {
      setMsg("单位ID为空,请确认传输参数是否正确!", "error");
      return gsInfo;
    }
    if (map == null || map.get("aae001") == null) {
      setMsg("单位申报年度为空,请确认传输参数是否正确!", "error");
      return gsInfo;
    }

    String aae001 = (String) map.get("aae001");

    //获取单位信息
    Map result = yearInternetCenterAuditService.getUnitJSInfo(map);

    String jjglzx = "";
    String yab003 = getDto().getUserInfo().getOrgId();
    if (yab003.equals(Constant.YAB003_GX)) {
      jjglzx = Constant.JJGLZX_GX;
    } else if (yab003.equals(Constant.YAB003_FD)) {
      jjglzx = Constant.JJGLZX_FD;
    }
    result.put("jjglzx", jjglzx);
    result.put("title", aae001 + "年度社会保险缴费基数申报汇总表");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Row row = gsInfo.addRow();
    row.setData(1, result.get("iaz051"));//1编号
    row.setData(2, sdf.format(result.get("time1")));//2打印时间
    row.setData(3, result.get("jjglzx"));//3表头
    row.setData(4, result.get("title"));//4表头

    row.setData(5, result.get("aab004"));//5单位名称
    row.setData(6, result.get("aab001"));//6
    row.setData(7, result.get("aae006"));//7
    row.setData(8, result.get("aae007"));//8
    row.setData(9, result.get("aab020")); //9
    row.setData(10, result.get("aab003")); // 10
    row.setData(11, result.get("aab013")); // 11
    row.setData(12, result.get("aab016")); // 12
    row.setData(13, result.get("yab390")); // 13
    row.setData(14, result.get("aae001")); // 14
    row.setData(15, result.get("cbrs")); // 15

    row.setData(16, result.get("yjsh0101"));//16
    row.setData(17, result.get("yjsh0102"));//17
    row.setData(18, result.get("yjsh0103"));//18
    row.setData(19, result.get("yjsh0104"));//19
    row.setData(20, result.get("yjsh0105"));//20
    row.setData(21, result.get("yjsh0106"));//21
    row.setData(22, result.get("yjsh0107"));//22
    row.setData(23, result.get("yjsh0108"));//23
    row.setData(24, result.get("yjsh0109"));//24
    row.setData(25, result.get("xjsh0101"));//25
    row.setData(26, result.get("xjsh0102"));//26
    row.setData(27, result.get("xjsh0103"));//27
    row.setData(28, result.get("xjsh0104"));//28
    row.setData(29, result.get("xjsh0105"));//29
    row.setData(30, result.get("xjsh0106"));//30
    row.setData(31, result.get("xjsh0107"));//31
    row.setData(32, result.get("xjsh0108"));//32
    row.setData(33, result.get("xjsh0109"));//33

    row.setData(34, result.get("yjsh0201"));//34
    row.setData(35, result.get("yjsh0202"));//35
    row.setData(36, result.get("yjsh0203"));//36
    row.setData(37, result.get("yjsh0204"));//37
    row.setData(38, result.get("yjsh0205"));//38
    row.setData(39, result.get("yjsh0206"));//39
    row.setData(40, result.get("yjsh0207"));//40
    row.setData(41, result.get("yjsh0208"));//41
    row.setData(42, result.get("yjsh0209"));//42
    row.setData(43, result.get("xjsh0201"));//43
    row.setData(44, result.get("xjsh0202"));//44
    row.setData(45, result.get("xjsh0203"));//45
    row.setData(46, result.get("xjsh0204"));//46
    row.setData(47, result.get("xjsh0205"));//47
    row.setData(48, result.get("xjsh0206"));//48
    row.setData(49, result.get("xjsh0207"));//49
    row.setData(50, result.get("xjsh0208"));//50
    row.setData(51, result.get("xjsh0209"));//51

    row.setData(52, result.get("yjsh0301"));//52
    row.setData(53, result.get("yjsh0302"));//53
    row.setData(54, result.get("yjsh0303"));//54
    row.setData(55, result.get("yjsh0304"));//55
    row.setData(56, result.get("yjsh0305"));//56
    row.setData(57, result.get("yjsh0306"));//57
    row.setData(58, result.get("yjsh0307"));//58
    row.setData(59, result.get("yjsh0308"));//59
    row.setData(60, result.get("yjsh0309"));//60
    row.setData(61, result.get("xjsh0301"));//61
    row.setData(62, result.get("xjsh0302"));//62
    row.setData(63, result.get("xjsh0303"));//63
    row.setData(64, result.get("xjsh0304"));//64
    row.setData(65, result.get("xjsh0305"));//65
    row.setData(66, result.get("xjsh0306"));//66
    row.setData(67, result.get("xjsh0307"));//67
    row.setData(68, result.get("xjsh0308"));//68
    row.setData(69, result.get("xjsh0309"));//69

    row.setData(70, result.get("yjsh0401"));//70
    row.setData(71, result.get("yjsh0402"));//71
    row.setData(72, result.get("yjsh0403"));//72
    row.setData(73, result.get("yjsh0404"));//73
    row.setData(74, result.get("yjsh0405"));//74
    row.setData(75, result.get("yjsh0406"));//75
    row.setData(76, result.get("yjsh0407"));//76
    row.setData(77, result.get("yjsh0408"));//77
    row.setData(78, result.get("yjsh0409"));//78
    row.setData(79, result.get("xjsh0401"));//79
    row.setData(80, result.get("xjsh0402"));//80
    row.setData(81, result.get("xjsh0403"));//81
    row.setData(82, result.get("xjsh0404"));//82
    row.setData(83, result.get("xjsh0405"));//83
    row.setData(84, result.get("xjsh0406"));//84
    row.setData(85, result.get("xjsh0407"));//85
    row.setData(86, result.get("xjsh0408"));//86
    row.setData(87, result.get("xjsh0409"));//87

    row.setData(88, result.get("yjsh0501"));//88
    row.setData(89, result.get("yjsh0502"));//89
    row.setData(90, result.get("yjsh0503"));//90
    row.setData(91, result.get("yjsh0504"));//91
    row.setData(92, result.get("yjsh0505"));//92
    row.setData(93, result.get("yjsh0506"));//93
    row.setData(94, result.get("yjsh0507"));//94
    row.setData(95, result.get("yjsh0508"));//95
    row.setData(96, result.get("yjsh0509"));//96
    row.setData(97, result.get("xjsh0501"));//97
    row.setData(98, result.get("xjsh0502"));//98
    row.setData(99, result.get("xjsh0503"));//99
    row.setData(100, result.get("xjsh0504"));//100
    row.setData(101, result.get("xjsh0505"));//101
    row.setData(102, result.get("xjsh0506"));//102
    row.setData(103, result.get("xjsh0507"));//103
    row.setData(104, result.get("xjsh0508"));//104
    row.setData(105, result.get("xjsh0509"));//105

    row.setData(106, result.get("aae001"));//106
    row.setData(107, result.get("jzyd_01"));//107
    row.setData(108, result.get("jszc01"));//108
    row.setData(109, result.get("bajszc01"));//109
    row.setData(110, result.get("tqjs01"));//110
    row.setData(111, result.get("ksyd_02"));//111
    row.setData(112, result.get("jzyd_02"));//112
    row.setData(113, result.get("jszc02"));//113
    row.setData(114, result.get("jszc0220"));//114
    row.setData(115, result.get("ksyd_03"));//115
    row.setData(116, result.get("jzyd_03"));//116
    row.setData(117, result.get("jszc03"));//117
    row.setData(118, result.get("jszc05"));//118
    row.setData(119, result.get("jzyd_04"));//119
    row.setData(120, result.get("jszc04"));//120
    row.setData(121, result.get("aae001"));//121
    row.setData(122, result.get("aae001"));//122
    row.setData(123, result.get("ksyd_04"));//123
    return gsInfo;
  }



  @SuppressWarnings("unchecked")
  public String yearSalaryFSSJ() throws Exception {
    ParamDTO dto = getDto();
    String aab001 = dto.getAsString("aab001");
    //查询养老单位编号
    String dwbh = (String) getDao().queryForObject("yearaudit.getdwbh", aab001);
    dto.put("dwbh", dwbh);
    String aae001 = dto.getAsString("aae001");//年度
    //查询 ab05a1表 循环调接口
    List list = getDao().queryForList("yearaudit.queryAb05a1", dto);
    if (ValidateUtil.isEmpty(list)) {
      setMsg("没有单位基数数据");
      return JSON;
    }
    Map m = new HashMap();
    String msg02 = "";
    for (int i = 0; i < list.size(); i++) {
      m = (Map) list.get(i);
      boolean YLres = yearInternetCenterAuditService.checkYLServiceResult(m);
      if (YLres) {
        continue;
      }
      String aac001 = (String) m.get("aac001");
      dto.put("aac001", aac001);
      //根据单位编号和个人编号查询提前结算数据
      //如果有则跳过
      Map m1 = new HashMap();
      m1.put("aac001", aac001);
      m1.put("aab001", aab001);
      m1.put("yae031", "1");
      m1.put("aae041", aae001 + "01");
      Map irad5a1 = (Map) getDao().queryForObject("yearaudit.queryirad51a1", m1);
      if (!ValidateUtil.isEmpty(irad5a1)) {
        continue;
      }
      //查询对应的养老个人编号
      String grbh = (String) getDao().queryForObject("yearaudit.getgrbh", aac001);
      dto.put("grbh", grbh);
      String aac002 = (String) m.get("aac002");
      dto.put("aac002", aac002);
      String aac003 = (String) m.get("aac003");
      dto.put("aac003", aac003);
			/*BigDecimal yac004_b=(BigDecimal) m.get("yac004");//新养老缴费基数
			Double yac004=yac004_b.doubleValue();
			dto.put("yac004", yac004);*/
      BigDecimal aac040_b = (BigDecimal) m.get("yac004");//新养老缴费基数
      Double aac040 = aac040_b.doubleValue();
      if (aac040 != 0) { //设定为新的养老基数不为空的情况下才给养老写数据
        dto.put("aac040", aac040);
        dto.put("aae011", dto.getUserInfo().getName());
        Map xmlMap = baseCommonService.insertYLINFOBy11(dto);
        if (!ValidateUtil.isEmpty(xmlMap)) {
          if (!xmlMap.get("jyjgfhbs").equals("0")) {
            msg02 = msg02.concat("###").concat("身份证号为：" + m.get("aac002") + "人员").concat(xmlMap.get("errorMsg") + "") + "</br>";
          }
        }
        dto.remove("grbh");
      }
    }
    setMsg("发送养老数据完成" + msg02);
    return JSON;
  }



  /**
   * 跳转二次补差页面
   *
   * @return
   * @throws Exception
   */
  public String toQuerySecondYearAuditInfo() throws Exception {

    return "secondYearAuditInfo";
  }



  /**
   * 查询待二次补差单位
   *
   * @return
   * @throws Exception
   */
  public String querySecondYearAuditInfo() throws Exception {
    ParamDTO dto = getDto();
    String year = dto.getAsString("aae001");
    String yab139 = dto.getUserInfo().getYab003();
    String aab001 = dto.getAsString("aab001");
    String audit = "";

    if (!ValidateUtil.isEmpty(dto.getAsStringArray("audit"))) {

      audit = dto.getAsStringArray("audit")[0];//获取页面选中的radio
      if (audit.equals("0")) {
        dto.put("audit", audit);
      }

      if (audit.equals("1")) {
        dto.put("audit", audit);
      }
    }

    dto.put("aae001", year);
    dto.put("yab139", yab139);
    dto.put("beginDate", "2018-02-11");
    dto.put("aab001", aab001);

    PageBean list = this.getDao().queryForPageWithCount("auditConList", "yearaudit.getSecondUnapplyInfo", dto, dto);
    setList("auditConList", list);
    setData("aae001", year);
    return JSON;
  }



  /**
   * 二次补差 yearSecondSalaryBc
   *
   * @return
   * @throws Exception
   */
  public String yearSecondSalaryBc() throws Exception {
    ParamDTO dto = getDto();
    String iaa011 = dto.getAsString("iaa011");

    String msg = yearInternetCenterAuditService.yearSecondSalaryBc(dto);
    if (ValidateUtil.isEmpty(msg)) {
      setMsg("年审补差完成！");

    } else {
      setMsg(msg);
    }
    return JSON;
  }
}

