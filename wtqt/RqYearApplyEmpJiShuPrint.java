package com.yinhai.nethall.company.yearApply.action;

import com.runqian.report4.dataset.DataSet;
import com.runqian.report4.dataset.IDataSetFactory;
import com.runqian.report4.dataset.Row;
import com.runqian.report4.usermodel.Context;
import com.runqian.report4.usermodel.DataSetConfig;
import com.yinhai.nethall.company.yearApply.service.YearInternetApplyService;
import com.yinhai.nethall.nethallcommon.service.BaseCommService;
import com.yinhai.nethall.nethallcommon.utils.Constant;
import com.yinhai.nethall.nethallcommon.utils.XmlConverUtil;
import com.yinhai.sysframework.dto.ParamDTO;
import com.yinhai.sysframework.util.ValidateUtil;
import com.yinhai.webframework.BaseAction;

import java.util.List;
import java.util.Map;


public class RqYearApplyEmpJiShuPrint extends BaseAction implements IDataSetFactory {
  private YearInternetApplyService service = (YearInternetApplyService) super.getService("yearInternetApplyService");
  private BaseCommService baseCommService = (BaseCommService) super.getService("baseCommService");



  @SuppressWarnings("unchecked")
  public DataSet createDataSet(Context ctx, DataSetConfig arg1, boolean arg2) {
    ParamDTO dto = getDto();
    DataSet gsInfo = new DataSet("ds1");
    gsInfo.addCol("iaz051");   // 1编号
    gsInfo.addCol("time1");    // 2打印时间
    gsInfo.addCol("title");    // 3表头
    gsInfo.addCol("aab004");   // 4单位名称
    gsInfo.addCol("aab001");   // 5单位编号
    gsInfo.addCol("sn");       // 6序号
    gsInfo.addCol("aac003");   // 7姓名
    gsInfo.addCol("aac002");   // 8身份证号码
    gsInfo.addCol("aac009");   // 9户口性质
    gsInfo.addCol("aac040");   // 10申报工资
    gsInfo.addCol("yac004");   // 11养老基数
    gsInfo.addCol("yaa444_02");   // 12失业基数
    gsInfo.addCol("yaa444_04");   // 13工伤基数
    gsInfo.addCol("yaa333_03");   // 14医疗基数
    gsInfo.addCol("yaa333_05");   // 15生育基数
    gsInfo.addCol("aae110");   // 16养老
    gsInfo.addCol("aae210");   // 17失业
    gsInfo.addCol("aae410");   // 18工伤
    gsInfo.addCol("aae310");   // 19医疗
    gsInfo.addCol("aae510");   // 20生育
    gsInfo.addCol("aae311");   // 21大额
    gsInfo.addCol("yae499");   // 22备注
    gsInfo.addCol("No");       // 23申报总结月
    gsInfo.addCol("num_01");   // 24养老保险人数
    gsInfo.addCol("sum_u_01"); // 25养老保险基数汇总
    gsInfo.addCol("num_03");   // 26医疗人数
    gsInfo.addCol("sum_u_03"); // 27医疗保险基数汇总
    gsInfo.addCol("num_02");   // 28失业保险人数
    gsInfo.addCol("sum_u_02"); // 29失业保险基数汇总
    gsInfo.addCol("num_04");   // 30工伤保险人数
    gsInfo.addCol("sum_u_04"); // 31工伤保险基数汇总
    gsInfo.addCol("num_05");   // 32生育保险人数
    gsInfo.addCol("sum_u_05"); // 33生育保险基数汇总
    gsInfo.addCol("name");     // 34申报经办人
    gsInfo.addCol("tel");      // 35联系电话
    gsInfo.addCol("jjglzx");   // 36基金管理中心

    // 取得参数列表并分别取得它的参数名与值,宏与之类似
    Map map = ctx.getParamMap(false);// 获取参数
    // 没有参数，或者参数不全的情况

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
    String empXml = service.getEmpJSInfo(XmlConverUtil.map2Xml(map));
    Map result = XmlConverUtil.xml2Map(empXml);
    List list = (List) result.get("ab05a1List");

    String jjglzx = "";
    String yab003 = getDto().getUserInfo().getOrgId();
    if (yab003.equals(Constant.YAB003_GX)) {
      jjglzx = Constant.JJGLZX_GX;
    } else if (yab003.equals(Constant.YAB003_FD)) {
      jjglzx = Constant.JJGLZX_FD;
    }
    result.put("jjglzx", jjglzx);
    result.put("title", aae001 + "年度单位参保人员缴纳社会保险费基数申报表");
    //针对年审0申报修改
    if (ValidateUtil.isEmpty(list)) {
      Row row = gsInfo.addRow();
      row.setData(1, result.get("iaz051"));     // 1编号
      row.setData(2, result.get("time1"));      // 2打印时间
      row.setData(3, result.get("title"));      // 3表头
      row.setData(4, result.get("aab004"));     // 4单位名称
      row.setData(5, result.get("aab001"));     // 5单位编号
      row.setData(6, "");                    // 6序号
      row.setData(7, "");                    // 7姓名
      row.setData(8, "");                    // 8身份证号码
      row.setData(9, "");                    // 9户口性质
      row.setData(10, "");                   // 10申报工资
      row.setData(11, "");                   // 11养老基数
      row.setData(12, "");                   // 12失业基数
      row.setData(13, "");                   // 13工伤基数
      row.setData(14, "");                   // 14医疗基数
      row.setData(15, "");                   // 15生育基数
      row.setData(16, "");                   // 16养老
      row.setData(17, "");                   // 17失业
      row.setData(18, "");                   // 18工伤
      row.setData(19, "");                   // 19医疗
      row.setData(20, "");                   // 20生育
      row.setData(21, "");                   // 21大额
      row.setData(22, "");                   // 22备注
      row.setData(23, result.get("No"));         // 23申报总结月
      row.setData(24, result.get("num_01"));     // 24养老保险人数
      row.setData(25, result.get("sum_u_01"));   // 25养老保险基数汇总
      row.setData(26, result.get("num_03"));     // 26医疗人数
      row.setData(27, result.get("sum_u_03"));   // 27医疗保险基数汇总
      row.setData(28, result.get("num_02"));     // 28失业保险人数
      row.setData(29, result.get("sum_u_02"));   // 29失业保险基数汇总
      row.setData(30, result.get("num_04"));     // 30工伤保险人数
      row.setData(31, result.get("sum_u_04"));   // 31工伤保险基数汇总
      row.setData(32, result.get("num_05"));     // 32生育保险人数
      row.setData(33, result.get("sum_u_05"));   // 33生育保险基数汇总
      row.setData(34, result.get("name"));       // 34申报经办人
      row.setData(35, result.get("tel"));        // 35联系电话
      row.setData(36, result.get("jjglzx"));     // 36基金管理中心
    } else {
      for (int i = 0; i < list.size(); i++) {
        Map ab05a1 = (Map) list.get(i);
        Row row = gsInfo.addRow();
        row.setData(1, result.get("iaz051"));    // 1编号
        row.setData(2, result.get("time1"));     // 2打印时间
        row.setData(3, result.get("title"));     // 3表头
        row.setData(4, result.get("aab004"));    // 4单位名称
        row.setData(5, result.get("aab001"));    // 5单位编号
        row.setData(6, ab05a1.get("sn"));        // 6序号
        row.setData(7, ab05a1.get("aac003"));    // 7姓名
        row.setData(8, ab05a1.get("aac002"));    // 8身份证号码
        row.setData(9, ab05a1.get("aac009"));    // 9户口性质
        row.setData(10, ab05a1.get("aac040"));   // 10申报工资
        row.setData(11, ab05a1.get("yac004"));   // 11养老基数
        row.setData(12, ab05a1.get("yaa444_02"));   // 12失业基数
        row.setData(13, ab05a1.get("yaa444_04"));   // 13工伤基数
        row.setData(14, ab05a1.get("yaa333_03"));   // 14医疗基数
        row.setData(15, ab05a1.get("yaa333_05"));   // 15生育基数
        row.setData(16, ab05a1.get("aae110"));   // 16养老
        row.setData(17, ab05a1.get("aae210"));   // 17失业
        row.setData(18, ab05a1.get("aae410"));   // 18工伤
        row.setData(19, ab05a1.get("aae310"));   // 19医疗
        row.setData(20, ab05a1.get("aae510"));   // 20生育
        row.setData(21, ab05a1.get("aae311"));   // 21大额
        row.setData(22, ab05a1.get("yae499"));   // 22备注
        row.setData(23, result.get("No"));       // 23申报总结月
        row.setData(24, result.get("num_01"));   // 24养老保险人数
        row.setData(25, result.get("sum_u_01")); // 25养老保险基数汇总
        row.setData(26, result.get("num_03"));   // 26医疗人数
        row.setData(27, result.get("sum_u_03")); // 27医疗保险基数汇总
        row.setData(28, result.get("num_02"));   // 28失业保险人数
        row.setData(29, result.get("sum_u_02")); // 29失业保险基数汇总
        row.setData(30, result.get("num_04"));   // 30工伤保险人数
        row.setData(31, result.get("sum_u_04")); // 31工伤保险基数汇总
        row.setData(32, result.get("num_05"));   // 32生育保险人数
        row.setData(33, result.get("sum_u_05")); // 33生育保险基数汇总
        row.setData(34, result.get("name"));     // 34申报经办人
        row.setData(35, result.get("tel"));      // 35联系电话
        row.setData(36, result.get("jjglzx"));   // 36基金管理中心
      }
    }
    return gsInfo;
  }
}