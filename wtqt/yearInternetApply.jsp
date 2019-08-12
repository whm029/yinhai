<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ taglib prefix="ta" tagdir="/WEB-INF/tags/tatags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>社会保险年审核申报</title>
  <%@ include file="/ta/inc.jsp" %>
</head>
<body oncontextmenu="self.event.returnValue=false">
<ta:pageloading/>
<ta:form id="form1" fit="true" methord="post" enctype="multipart/form-data">
  <ta:fieldset cols="3" key="单位信息">
    <ta:text id="aab001" key="社保助记码" maxLength="10" required="true" readOnly="true"/>
    <ta:text id="aab004" key="单位名称" span="2" readOnly="true"/>
    <ta:text id="aab005" key="单位电话" readOnly="true"/>
    <ta:text id="aae006" key="地址" span="2" readOnly="true"/>
    <ta:text id="aae001" key="年度" required="true" readOnly="true" maxLength="6"/>
    <ta:text id="aab016" key="专管员" readOnly="true"/>
    <ta:text id="aab019" key="单位类型" display="false"/>
    <ta:number id="sx01" key="养老上限基数" display="false"/>
    <ta:number id="xx01" key="养老下限基数" display="false"/>
    <ta:number id="sx03" key="医疗上限基数" display="false"/>
    <ta:number id="xx03" key="医疗下限基数" display="false"/>
  </ta:fieldset>

  <ta:buttonLayout align="left">
    <ta:button id="queryBtn" key="查&nbsp;&nbsp;&nbsp;&nbsp;询" isShowIcon="true" onClick="query();" icon="icon-search"/>
    <ta:button id="exportBtn" key="导出年申报模板" hotKey="e" isShowIcon="true" onClick="myExport();" icon="icon-download"/>
    <input type="file" name="theFile" style="background-color: buttonface; height: 22px; margin-top: 1px; width: 200px" id="theFile"/>
    <ta:button id="importBtn" key="导入年申报信息" isShowIcon="true" onClick="fnImport();" icon="xui-icon-tableGo"/>
    <ta:button id="retainBtn" key="页面信息暂存" onClick="fnRetain();" isShowIcon="true" icon="icon-save"/>
    <ta:button id="delBtn" key="清空填报数据" isShowIcon="true" onClick="fnDelete();" icon="icon-no"/>
    <ta:button id="viewBtn" key="年审信息预览" onClick="fnView();" isShowIcon="true" icon="icon-search"/>
    <ta:button id="applyBtn" key="提交年审申报" isShowIcon="true" onClick="fnApply();" icon="icon-ok"/>
    <ta:button id="cancelBtn" key="撤销年审申报" isShowIcon="true" onClick="fnCancel();" icon="icon-no"/>
    <ta:button id="printBtn1" key="打印基数申报表" isShowIcon="true" onClick="fnPrint();" icon="icon-print"/>
    <ta:button id="printBtn2" key="打印基数申报汇总表" isShowIcon="true" onClick="fnPrint1();" icon="icon-print"/>
    <ta:button id="printBtn3" key="打印地税补差申报表" isShowIcon="true" onClick="fnprintBCDetail();" icon="icon-print"/>
    <ta:button id="printBtn4" key="打印自筹补差申报表" isShowIcon="true" onClick="fnprintBCDetail2();" icon="icon-print"/>
    <ta:button id="printBtn5" key="导出补差明细excel" isShowIcon="true" onClick="fnexcBCDetail();" icon="icon-print"/>

  </ta:buttonLayout>
  <ta:tabs id="tabs" fit="true" heightDiff="0">
    <ta:tab id="tab1" key="年审申报信息">
      <ta:datagrid id="sucGrid" fit="true" columnFilter="true">
        <ta:datagridItem id="rownum" key="序号" width="50" align="center" dataAlign="center"/>
        <ta:datagridItem id="ck" key="查看" width="40" align="center" click="fnInfo" icon="icon-search"/>

        <ta:datagridItem id="iaa002" key="审核标志" width="70" align="center" dataAlign="left" collection="IAA002"/>
        <ta:datagridItem id="yab029" key="养老个人编号" width="95" align="center" dataAlign="left"/>
        <ta:datagridItem id="aac001" key="个人编号" width="85" align="center" dataAlign="left"/>
        <ta:datagridItem id="aac003" key="姓名" width="70" align="center" dataAlign="left" showDetailed="true"/>
        <ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
        <ta:datagridItem id="aac009" key="户口性质" width="75" align="center" dataAlign="left" collection="AAC009"/>

        <ta:datagridItem id="aac040" key="新缴费工资" width="90" align="center" dataAlign="left" showDetailed="true" dataType="Number">
          <ta:datagridEditor type="number" precition="2" onChange="jishu"/>
        </ta:datagridItem>

        <ta:datagridItem id="yac004" key="新养老基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yaa333_02" key="新工伤基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yaa333_04" key="新失业基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yaa333_03" key="新医疗基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yaa333_05" key="新生育基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>

        <ta:datagridItem id="yac506" key="原缴费工资" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yac507" key="原养老基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yac508_02" key="原工伤基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yac508_04" key="原失业基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yac508_03" key="原医疗基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>
        <ta:datagridItem id="yac508_05" key="原生育基数" width="80" align="center" dataAlign="left" showDetailed="true" dataType="Number"/>

        <ta:datagridItem id="aae110" key="养老" width="40" align="center" collection="AAE140"/>
        <ta:datagridItem id="aae210" key="失业" width="40" align="center" collection="AAE140"/>
        <ta:datagridItem id="aae310" key="医疗" width="40" align="center" collection="AAE140"/>
        <ta:datagridItem id="aae410" key="工伤" width="40" align="center" collection="AAE140"/>
        <ta:datagridItem id="aae510" key="生育" width="40" align="center" collection="AAE140"/>
        <ta:datagridItem id="aae311" key="大额" width="40" align="center" collection="AAE140"/>
        <ta:datagridItem id="yae110" key="养老备注" width="105" align="left" showDetailed="true"/>
        <ta:datagridItem id="yae310" key="医疗备注" width="105" align="left" showDetailed="true"/>
        <ta:datagridItem id="yae210" key="失业备注" width="105" align="left" showDetailed="true"/>
        <ta:datagridItem id="yae410" key="工伤备注" width="105" align="left" showDetailed="true"/>
        <ta:datagridItem id="yae510" key="生育备注" width="105" align="left" showDetailed="true"/>
        <ta:datagridItem id="aae013" key="备注" width="105" align="left" showDetailed="true" hiddenColumn="false"/>
        <ta:dataGridToolPaging url="yearInternetApplyAction!queryDetail.do" submitIds="form1" showButton="true" showCount="true" selectExpButtons="1" pageSize="100">
        </ta:dataGridToolPaging>
      </ta:datagrid>
    </ta:tab>
  </ta:tabs>

  <ta:box id="tips" cssStyle="display:none;width:400px;height:220px;padding:10px 10px 0px 0px;" cols="1">
    <ta:textarea id="warningTips" labelWidth="0" readOnly="true" height="220px"/>
  </ta:box>
  <ta:text id="yae031" display="false"/>
</ta:form>
</body>
</html>
<script type="text/javascript">
  $(document).ready(function () {
    $("body").taLayout();
    init();
  });

  //页面初始化
  function init(){
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    Base.submit("form1","yearInternetApplyAction!confirmTip.do",null,null,true,function(){
      var warningTips = Base.getValue("warningTips");
      if(warningTips != "" && warningTips != null ){
        tipsOpen(warningTips);
      }
    });
  }

  //提示信息弹出框
  function tipsOpen(warningTips){
    var title = "年审承诺书";
    var html = "<div style='display:block;'>"+warningTips+"</div>";
    var $w = $(html);
    $w.appendTo($("body"));
    $w.dialog({
      title:title,
      width:480,
      height:680,
      modal:true,
      dialogClass:"no-close",
      buttonsAlgin:'center',
      buttons:[{
        text:'同意',
        handler:function(){
          $w.dialog('destroy');
          $w.remove();
          Base.setValue("yae031","1")
          Base.submit("form1","yearInternetApplyAction!confirmTip.do");
        }
      }, {
        text:'不同意',
        handler:function(){
          $w.dialog('destroy');
          $w.remove();
          Base.setDisabled("exportBtn,importBtn,retainBtn,viewBtn,applyBtn,queryBtn,save,save2,preview,dcqb,print1,print2,print3,print4");
        }
      }]
    });
    $w.find('.dialog-button button:first').delay(100).focus();
    $('.panel-tool-close').hide();
  }


  //打印基数表
  function fnPrint() {
    var aab001 = Base.getValue("aab001");
    var aae001 = Base.getValue("aae001");
    var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printEmpJS.do?aab001=" + aab001 + "&aae001=" + aae001;
    open(url);
  }

  //打印基数汇总表
  function fnPrint1() {
    var aab001 = Base.getValue("aab001");
    var aae001 = Base.getValue("aae001");
    var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printUnitJSH.do?aab001=" + aab001 + "&aae001=" + aae001;
    open(url);
  }

  //调保底封顶方法
  function jishu(data, value) {

    var xx01 = Base.getValue("xx01");//省社平下线
    var sx01 = Base.getValue("sx01");//省社平上线
    var xx03 = Base.getValue("xx03");//市社平下线
    var sx03 = Base.getValue("sx03");//市社平上线
    var rownum = data.item.rownum;
    var aac001 = data.item.aac001;
    var aac002 = data.item.aac002;
    var aac040 = Math.round(data.item.aac040);
    var aae110 = data.item.aae110;
    var aae210 = data.item.aae210;
    var aae310 = data.item.aae310;
    var aae410 = data.item.aae410;
    var aae510 = data.item.aae510;
    var aae013 = data.item.aae013;
    var yac506 = data.item.yac506;
    var yac507 = data.item.yac507;
    var yac508 = data.item.yac508;
    var yac004 = 0; //新养老基数
    var yac005 = 0; //原工伤缴费工资
    var yaa333_02 = 0; //新失业基数
    var yaa333_04 = 0; //新工伤基数
    var yaa333_03 = 0; //新医疗基数
    var yaa333_05 = 0; //新生育基数

    if(aac040<1800){
      Base.alert("最低工资不能低于1800!");
      Base.setGridCellData("sucGrid", rownum, data.cell, "");
      return;
    }
    // 单养老的
    if (((aae110 == '2') || (aae110 == '21') || (aae110 == '备案'))&&(((aae210 == null) || (aae210 == '')) && ((aae310 == null) || (aae310 == '')) && ((aae410 == null) || (aae410 == '')) && ((aae510 == null) || (aae510 == '')))) {
      if (aac040 > xx01) {
        if (aac040 > sx01) {
          yac004 = sx01;
        } else {
          yac004 = aac040;
        }
      } else {
        yac004 = xx01;
      }
    }
    // 非单养老 有省社平险种 并且有养老险种的
    else if(((aae110 == '2') || (aae110 == '21') || (aae110 == '备案')) && ((aae210 == '2') || (aae210 == '21') || (aae410 == '2') || (aae410 == '21'))) {
      if (aac040 >= xx01) {
        if (aac040 >= xx03) {
          if (aac040 >= sx01) {
            if (aac040 >= sx03) {
              yac004 = sx01;
              yaa333_02 = sx01;
              yaa333_04 = sx01;
              yaa333_03 = sx03;
              yaa333_05 = sx03;
              //yac005 = sx03;
            } else {
              yac004 = sx01;
              yaa333_02 = sx01;
              yaa333_04 = sx01;
              yaa333_03 = aac040;
              yaa333_05 = aac040;
              //yac005 = aac040;
            }
          } else {
            yac004 = aac040;
            yaa333_02 = aac040;
            yaa333_04 = aac040;
            yaa333_03 = aac040;
            yaa333_05 = aac040;
            //yac005 = aac040;
          }
        } else {
          yac004 = aac040;
          yaa333_02 = aac040;
          yaa333_04 = aac040;
          yaa333_03 = xx03;
          yaa333_05 = xx03;
          //yac005 = xx03;
        }
      } else {
        yac004 = xx01;
        yaa333_02 = xx01;
        yaa333_04 = xx01;
        yaa333_03 = xx03;
        yaa333_05 = xx03;
        //yac005 = xx03;
      }

    // 非单养老 有省社平险种 没有养老险种的
    } else if(((aae110 == '') || (aae110 == null)) && ((aae210 == '2') || (aae210 == '21') || (aae410 == '2') || (aae410 == '21'))) {
      if (aac040 >= xx01) {
        if (aac040 >= xx03) {
          if (aac040 >= sx01) {
            if (aac040 >= sx03) {
              yaa333_02 = sx01;
              yaa333_04 = sx01;
              yaa333_03 = sx03;
              yaa333_05 = sx03;
              //yac005 = sx03;
            } else {
              yaa333_02 = sx01;
              yaa333_04 = sx01;
              yaa333_03 = aac040;
              yaa333_05 = aac040;
              //yac005 = aac040;
            }
          } else {
            yaa333_02 = aac040;
            yaa333_04 = aac040;
            yaa333_03 = aac040;
            yaa333_05 = aac040;
            //yac005 = aac040;
          }
        } else {
          yaa333_02 = aac040;
          yaa333_04 = aac040;
          yaa333_03 = xx03;
          yaa333_05 = xx03;
          //yac005 = xx03;
        }
      } else {
        yaa333_02 = xx01;
        yaa333_04 = xx01;
        yaa333_03 = xx03;
        yaa333_05 = xx03;
        //yac005 = xx03;
      }

    // 非单养老只有市社平险种的
    } else {
      if (aac040 > xx03) {
        if (aac040 > sx03) {
          yaa333_03 = sx03;
          yaa333_05 = sx03;
          //yac005 = sx03;
        } else {
          yaa333_03 = aac040;
          yaa333_05 = aac040;
          //yac005 = aac040;
        }
      } else {
        yaa333_03 = xx03;
        yaa333_05 = xx03;
        yac005 = xx03;
      }
    }


    if (aae013 == "1") {
      Base.alert("该人员为到龄退休年限不足继续缴费人员！");
      Base.setGridCellData("sucGrid", rownum, data.cell, aac040); //新缴费工资
      Base.setGridCellData("sucGrid", rownum, data.cell + 1, yac004); //新养老基数
      Base.setGridCellData("sucGrid", rownum, data.cell + 2, yac508); //原其他基数
      return;
    }
    if (aae013 == "2") {
      Base.alert("该人员已经办理过养老保险提前结算，不能修改基数！");
      Base.setGridCellData("sucGrid", rownum, data.cell, yac506); //原缴费工资
      Base.setGridCellData("sucGrid", rownum, data.cell + 1, yac507); //原养老基数
      Base.setGridCellData("sucGrid", rownum, data.cell + 2, yac508); //原其他基数
      return;
    }
    Base.setGridCellData("sucGrid", rownum, data.cell + 1, yac004); //新养老基数
    Base.setGridCellData("sucGrid", rownum, data.cell + 2, yaa333_02); //新工伤基数
    Base.setGridCellData("sucGrid", rownum, data.cell + 3, yaa333_04); //新失业基数
    Base.setGridCellData("sucGrid", rownum, data.cell + 4, yaa333_03); //新医疗基数
    Base.setGridCellData("sucGrid", rownum, data.cell + 5, yaa333_05); //新生育基数
    //Base.setGridCellData("sucGrid", rownum, data.cell + 2, yac005); //原工伤缴费工资
  }

  //预览单个人员的补缴差额
  function fnInfo(o) {
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    var aae110 = Base.getValue('aae110');
    Base.openWindow("perInfo", "人员险种补差信息", "yearInternetApplyAction!perInfo.do", {
      "dto['aac001']": o.aac001,
      "dto['aac040']": o.aac040,
      "dto['aab001']": aab001,
      "dto['aae001']": aae001,
      "dto['aae110']": aae110
    }, 1000, 350, null, null, true, null, null);
  }

  //提交年审申报信息
  function fnApply() {
    Base.submit("form1,sucGrid", "yearInternetApplyAction!apply.do", null);
  }

  //删除页面暂存信息
  function fnDelete() {
    Base.confirm('已填报数据将被全部清除，不可恢复，请确认！', function (yes) {
      if (yes) {
        Base.submit("form1,sucGrid", "yearInternetApplyAction!clear.do", null);
      }
    });
  }

  //撤销申报信息
  function fnCancel() {
    Base.submit("form1,sucGrid", "yearInternetApplyAction!cancel.do", null);
  }

  //暂存
  function fnRetain() {
    Base.submit("form1,sucGrid", "yearInternetApplyAction!save.do", null);
  }

  //预览
  function fnView() {
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    Base.openWindow("perInfo", "单位险种补差信息", "yearInternetApplyAction!perView.do", {
      "dto['aab001']": aab001,
      "dto['aae001']": aae001
    }, 900, 350, null, null, true, null, null);
  }

  //显示按钮板（导出补差明细excel）
  function fnexcBCDetail() {
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    Base.openWindow('perInfo', "单位险种实际补差信息", "yearInternetApplyQueryAction!btnPanel.do", {
      "dto['aab001']": aab001,
      "dto['aae001']": aae001
    }, 550, 380, null, null, true);
  }

  //导出
  function myExport() {
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    Base.submitForm('form1', null, false, 'yearInternetApplyAction!exportData.do', {
      "dto['aab001']": aab001,
      "dto['aae001']": aae001
    });
    Base.hideMask();
  }

  //导入
  function fnImport() {
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    Base.submitForm('form1', null, false, 'yearInternetApplyAction!importExcel.do', {
      "dto['aab001']": aab001,
      "dto['aae001']": aae001
    });
  }

  //页面初始查询
  function query() {
    Base.submit("form1", "yearInternetApplyAction!queryDetail.do", null);
  }

  //打印补差申报表
  function fnprintBCDetail() {
    var yae010 = "3";
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printBCDetail.do?aab001=" + aab001 + "&aae001=" + aae001 + "&yae010=" + yae010;
    open(url);
  }

  function fnprintBCDetail2() {
    var yae010 = "1";
    var aab001 = Base.getValue('aab001');
    var aae001 = Base.getValue('aae001');
    var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printBCDetail.do?aab001=" + aab001 + "&aae001=" + aae001 + "&yae010=" + yae010;
    open(url);
  }
</script>
<%@ include file="/ta/incfooter.jsp" %>