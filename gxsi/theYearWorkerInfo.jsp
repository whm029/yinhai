<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ taglib prefix="ta" tagdir="/WEB-INF/tags/tatags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<%@ include file="/ta/inc.jsp"%>
	</head>
	<body oncontextmenu="self.event.returnValue=false"  >
<ta:pageloading />
<ta:form id="businessform">
	<ta:buttonLayout align="left" >
		<ta:button id="partok" icon="icon-save" key="全部通过" onClick="perbatchok();" asToolBarItem="true" cssStyle="border: 1px outset buttonshadow;"/>
		<ta:button id="partAlr" icon="icon-back" key="全部打回" onClick="fnshbz();" asToolBarItem="true" cssStyle="border: 1px outset buttonshadow;"/>
		<ta:button id="htBtn" icon="icon-back" key="审核回退" onClick="perbatchback();" asToolBarItem="true" cssStyle="border: 1px outset buttonshadow;" disabled="true"/>
		<ta:button id="remove" icon="icon-reload" key="关闭" onClick="cancel();" asToolBarItem="true" cssStyle="border: 1px outset buttonshadow;"/>
		<ta:button id="printBtn1" icon="icon-print" key="预览单位汇总表" onClick="fnPrint();" asToolBarItem="true" cssStyle="border: 1px outset buttonshadow;"/>
		<ta:button id="Btn1" key="批量更新基数调低人员补差" onClick="fnPLgengxin();" asToolBarItem="true" cssStyle="border: 1px outset buttonshadow;" disabled="true"/>
	</ta:buttonLayout>
	<ta:text id="aab001_1" key="单位编号" display="false"/>
	<ta:text id="aae001_1" key="年度" display="false"/>
	<ta:text id="iaa011_1" key="业务类型" display="false"/>

		<ta:tabs cssStyle="height:440px" >
			<ta:tab key="单位人员基数信息">
				<ta:datagrid id="grid1" fit="true" columnFilter="true" haveSn="true" height="440px" >
					<ta:datagridItem id="ck" key="查看" width="40" align="center" click="fnInfo" icon="icon-search"/>
					<ta:datagridItem id="yae001" key="是否修改补差" width="40" showDetailed="true" />
					<ta:datagridItem id="iaa002" key="审核标志" collection="IAA002" width="70"/>
					<ta:datagridItem id="yab029" key="养老个人编号" width="95" align="center"/>
					<ta:datagridItem id="aac001" key="个人编号" width="85" align="center"/>
					<ta:datagridItem id="aab001" key="单位编号" width="100" align="center" hiddenColumn="true"/>
					<ta:datagridItem id="aac003" key="姓名" width="70" align="center" showDetailed="true"/>
					<ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aac040" key="新缴费工资" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" sortable="true"/>							
					<ta:datagridItem id="yac004" key="新养老基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yaa333" key="新其他基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yac506" key="原缴费工资" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yac507" key="原养老基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yac508" key="原其他基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="aae110" key="养老" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae210" key="失业" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae310" key="医疗" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae410" key="工伤" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae510" key="生育" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae311" key="大额" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="yae110" key="养老备注" width="105" align="left" showDetailed="true" />
					<ta:datagridItem id="yae310" key="医疗备注" width="105" align="left" showDetailed="true" />
					<ta:datagridItem id="yae210" key="失业备注" width="105" align="left" showDetailed="true" />
					<ta:datagridItem id="yae410" key="工伤备注" width="105" align="left" showDetailed="true" />
					<ta:datagridItem id="yae510" key="生育备注" width="105" align="left" showDetailed="true" />			
					<ta:datagridItem id="yab019" key="业务类型" width="105" align="left" hiddenColumn="true"/>			
				</ta:datagrid>				
			</ta:tab>

			<ta:tab key="单位补差信息">
				<ta:panel height="270px" key="单位月补差信息">
				<ta:datagrid id="grid2" fit="true" haveSn="true">	
					<ta:datagridItem id="aab001" key="单位编号" width="80px"/>
					<ta:datagridItem id="aae140" key="险种" width="80px" collection="AAE140_A"/>	
					<ta:datagridItem id="jszc" key="合计基数差额" dataType="Number" width="120px" dataAlign="right"/>		
					<ta:datagridItem id="yac401" key="1月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac402" key="2月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac403" key="3月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac404" key="4月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac405" key="5月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac406" key="6月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac407" key="7月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac408" key="8月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac409" key="9月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac410" key="10月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac411" key="11月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="yac412" key="12月补差金额" dataType="Number" width="100px" dataAlign="right"/>	
					<ta:datagridItem id="aae013" key="备注" width="80px" showDetailed="true"/>		
				</ta:datagrid>	
			  </ta:panel>
			  <ta:panel height="270px" key="单位月申报汇总">
			   	<ta:datagrid id="grid3" haveSn="true" forceFitColumns="true">	
			    <ta:datagridItem id="aab001" key="单位编号" width="90px"/>
			    <ta:datagridItem id="aae140" key="险种" width="100px" collection="AAE140_A"/>	
					<ta:datagridItem id="yae231" key="申报单位人数" dataType="Number" width="120px" dataAlign="right"/>
					<ta:datagridItem id="aab121" key="申报单位基数" dataType="Number" width="120px" dataAlign="right"/>
			    </ta:datagrid>
				</ta:panel>
			</ta:tab>

			<ta:tab key="养老系统和医疗系统身份证号码不同的人员信息">
				<ta:datagrid id="grid4" fit="true" columnFilter="true" haveSn="true" height="600px" forceFitColumns="true">
					<ta:datagridItem id="aac001" key="个人编号" width="85" align="center"/>
					<ta:datagridItem id="aab001" key="单位编号" width="85" align="center"/>
					<ta:datagridItem id="aac003" key="姓名" width="70" align="center" showDetailed="true"/>
					<ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aab004" key="单位名称" width="260" align="center" dataAlign="left" showDetailed="true"/>							
					<ta:datagridItem id="yab029" key="养老单位编号" width="100" align="center" dataAlign="left" showDetailed="true"/>			
				</ta:datagrid>				
			</ta:tab>

			<ta:tab key="经办系统中无养老编号的人员信息">
				<ta:datagrid id="grid5" fit="true" columnFilter="true" haveSn="true" height="600px" forceFitColumns="true">
					<ta:datagridItem id="aac001" key="个人编号" width="85" align="center"/>
					<ta:datagridItem id="aab001" key="单位编号" width="85" align="center"/>
					<ta:datagridItem id="aac003" key="姓名" width="70" align="center" showDetailed="true"/>
					<ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aab004" key="单位名称" width="260" align="center" dataAlign="left" showDetailed="true"/>							
					<ta:datagridItem id="yab029" key="养老单位编号" width="100" align="center" dataAlign="left" showDetailed="true"/>			
				</ta:datagrid>				
			</ta:tab>

			<ta:tab key="基数降低人员信息">
				<ta:datagrid id="grid6" fit="true" columnFilter="true" haveSn="true" height="600px">
					<ta:datagridItem id="ck" key="查看" width="40" align="center" click="fnInfo" icon="icon-search" hiddenColumn="true"/>
					<ta:datagridItem id="yae001" key="是否修改补差" width="40" showDetailed="true" />
					<ta:datagridItem id="iaa002" key="审核标志" collection="IAA002" width="70"/>
					<ta:datagridItem id="yab029" key="养老个人编号" width="95" align="center"/>
					<ta:datagridItem id="aac001" key="个人编号" width="85" align="center"/>
					<ta:datagridItem id="aab001" key="单位编号" width="100" align="center" hiddenColumn="true"/>
					<ta:datagridItem id="aac003" key="姓名" width="70" align="center" showDetailed="true"/>
					<ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aac040" key="新缴费工资" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" sortable="true"/>							
					<ta:datagridItem id="yac004" key="新养老基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yaa333" key="新其他基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yac506" key="原缴费工资" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yac507" key="原养老基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="yac508" key="原其他基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number"/>
					<ta:datagridItem id="aae110" key="养老" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae210" key="失业" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae310" key="医疗" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae410" key="工伤" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae510" key="生育" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="aae311" key="大额" width="40" align="center" collection="AAE140_W"/>
					<ta:datagridItem id="yae110" key="养老备注" width="105" align="left" showDetailed="true"/>
					<ta:datagridItem id="yae310" key="医疗备注" width="105" align="left" showDetailed="true"/>
					<ta:datagridItem id="yae210" key="失业备注" width="105" align="left" showDetailed="true"/>
					<ta:datagridItem id="yae410" key="工伤备注" width="105" align="left" showDetailed="true"/>
					<ta:datagridItem id="yae510" key="生育备注" width="105" align="left" showDetailed="true"/>
					<ta:datagridItem id="yab019" key="业务类型" width="105" align="left" hiddenColumn="true"/>	
					<ta:dataGridToolPaging  showButton="true" showCount="true" submitIds="form1"  url="yearInternetCenterAuditAction!queryTheWork.do"  pageSize="500"  selectExpButtons="1" showExcel="true"/>
				</ta:datagrid>				
			</ta:tab>

			<ta:tab key="提前结算人员信息">
				<ta:datagrid id="grid7" fit="true" columnFilter="true" haveSn="true" height="600px">
					<ta:datagridItem id="aac001" key="个人编号" width="85" align="center"/>
					<ta:datagridItem id="aab001" key="单位编号" width="100" align="center" hiddenColumn="true"/>
					<ta:datagridItem id="aac003" key="姓名" width="70" align="center" showDetailed="true"/>
					<ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aae041" key="开始期号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aae042" key="结束期号" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aae011" key="经办人" width="150" align="center" dataAlign="left" showDetailed="true"/>
					<ta:datagridItem id="aae036" key="经办时间" width="150" align="center" dataAlign="left" showDetailed="true"/>
				</ta:datagrid>				
			</ta:tab>
		</ta:tabs>

	<ta:box id="auditDHInfo" cssStyle="display:none;width:500px;height:200px;">
		<ta:fieldset id="panel" cols="2">
			<ta:radiogroup id="cwzl" key="是否携带财务资料" cols="2" labelWidth="120">
				<ta:radio key="是" value="0" onClick="setaae013();"/>
				<ta:radio key="否" checked="true" value="1"/>
			</ta:radiogroup>
			<ta:textarea id="aae013_1" key="打回信息" height="60" span="2" required="true"/>
		</ta:fieldset>
		<ta:buttonLayout>
			<ta:button key="打回" onClick="perbatchAlr();" icon="icon-add" id="addBtn" />
		</ta:buttonLayout>
	</ta:box>

</ta:form>
<iframe id="report1_printIFrame" name="report1_printIFrame" width="100" height="100" style="position:absolute;left:-100px;top:-100px"></iframe>
</body>
</html>

<script type="text/javascript">
$(document).ready(function () {
		$("body").taLayout();
	});
	 function perbatchok() {
     var aab001 = Base.getValue("aab001_1");
		 var aae001 = Base.getValue("aae001_1");
		 var iaa011 = Base.getValue("iaa011_1");
		 Base.submit("grid1,businessform","yearInternetCenterAuditAction!perAllok.do",{"dto['aab001']":aab001,"dto['aae001']":aae001,"dto['iaa011']":iaa011},null,null,cancel,null);
	 }
     
	 function fnshbz() {
		 $("#auditDHInfo").show().window({title:"审核打回信息", modal:false, collapsible:false, minimizable:false});
	 }

	function perbatchAlr() {
		var aab001 = Base.getValue("aab001_1");
		var aae001 = Base.getValue("aae001_1");
		var iaa011 = Base.getValue("iaa011_1");
		Base.submit("grid1,businessform","yearInternetCenterAuditAction!perAllNO.do",{"dto['aab001']":aab001,"dto['aae001']":aae001,"dto['iaa011']":iaa011},null,false,cancel,null);
	}

  //预览单个人员的补缴差额(并修改)
	function fnInfo(o) {
		var aab001 = o.aab001;
		var yab019 = o.yab019;
		var aae001 = Base.getValue("aae001_1");
		var iaa011 = Base.getValue("iaa011_1");
		Base.openWindow("perInfo2","人员险种补差信息","yearInternetCenterAuditAction!perInfo.do",{"dto['aac001']":o.aac001,"dto['aac040']":o.aac040,"dto['aab001']":aab001,"dto['aae001']":aae001,"dto['yab019']":yab019,"dto['iaa011']":iaa011},1000,350,null,null,true,null,null);
	}

	function cancel() {
    parent.Base.closeWindow("yearInternetCenterAudit");
  }
     
  function fnPrint() {
	  var aab001 = Base.getValue("aab001_1");
	  var aae001 = Base.getValue("aae001_1");
<%--	    var fileName ="YearApplyUnitJS.raq";--%>
<%--	    $("#report1_printIFrame").attr("src","/xagxsi/reportServlet?action=2&name=report1&reportFileName="+fileName+"&"+--%>
<%--				"srcType=file&savePrintSetup=yes&appletJarName=runqian/runqianReport4Applet.jar%2Crunqian/dmGraphApplet.jar&"+--%>
<%--				"serverPagedPrint=no&mirror=no&paramString=aab001="+aab001+";aae001="+aae001);	--%>
	  var fileName ="YearApplyUnitJS";
	  var params = []; //参数
		params[0] = "aab001="+aab001;
		params[1] = "aae001="+aae001;
		fnSWFPrint(fileName, params);
	 }

  //审核回退
	function perbatchback() {
		var aab001 = Base.getValue("aab001_1");
	  var aae001 = Base.getValue("aae001_1");
	  var iaa011 = Base.getValue("iaa011_1");
	  Base.submit("grid1,businessform","yearInternetCenterAuditAction!rollBackAudit.do",{"dto['aab001']":aab001,"dto['aae001']":aae001,"dto['iaa011']":iaa011},null,false,cancel,null);
	}

	//批量更新补差数据
	function fnPLgengxin() {
		var aab001 = Base.getValue("aab001_1");
	  var aae001 = Base.getValue("aae001_1");
	  var iaa011 = Base.getValue("iaa011_1");
	  Base.submit("grid1,businessform","yearInternetCenterAuditAction!updateJSC.do",{"dto['aab001']":aab001,"dto['aae001']":aae001,"dto['iaa011']":iaa011},null,false,null,null);
	}

	function setaae013() {
		Base.setValue("aae013_1","请携带财务资料前往高新区社保中心审核年报!");
	}

</script>
<%@ include file="/ta/incfooter.jsp"%>