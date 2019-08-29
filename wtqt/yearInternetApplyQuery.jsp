<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ taglib prefix="ta" tagdir="/WEB-INF/tags/tatags"%>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>社会保险年审核申报查询</title>
		<%@ include file="/ta/inc.jsp"%>
	</head>
	<body onload="Base.setDisabled('excel');Base.setDisabled('sel_excel');"
		oncontextmenu="self.event.returnValue=false">
		<ta:pageloading />
		<ta:form id="form1" fit="true" heightDiff="0"
			cssStyle="overflow-y:hidden" methord="post"
			enctype="multipart/form-data">
			<ta:buttonLayout align="left">
				<ta:button id="printBtn1" key="打印基数申报表" onClick="fnPrint();" isShowIcon="true" icon="icon-print"/>
				<ta:button id="printBtn2" key="打印基数申报汇总表" onClick="fnPrint1();" isShowIcon="true" icon="icon-print"/>	
				<ta:button id="printBtn3" key="打印税务补差申报表" onClick="fnprintBCDetail();" isShowIcon="true" icon="icon-print"/>
				<ta:button id="printBtn4" key="打印自筹补差申报表" onClick="fnprintBCDetail2();" isShowIcon="true"  icon="icon-print"/>		
				<ta:button id="printBtn5" key="导出补差明细excel" onClick="fnexcBCDetail();" isShowIcon="true" icon="icon-print"/>						
			</ta:buttonLayout>

			<ta:fieldset id="fst1" cols="3" cssStyle="height:27px"> 
				<ta:text id="aae001" key="查询年度" required="true" maxLength="4" cssStyle="width:250px;"/>
				<ta:button id="button"  hotKey="alt+q" icon="icon-search" key="查&nbsp;&nbsp;&nbsp;&nbsp;询" onClick="query();" isShowIcon="true"/>
				<ta:text id="aab001" key="社保助记码" maxLength="10" required="true" readOnly="true" />
			</ta:fieldset>
			<ta:tabs id="tabs" fit="true" heightDiff="0" cssStyle="margin-top:30px">
				<ta:tab id="tab1" key="年审申报信息">
					<ta:datagrid id="sucGrid" fit="true" columnFilter="true" haveSn="true">
						<ta:datagridItem id="ck" key="查看" width="40" align="center" click="fnInfo" icon="icon-search"/>
						<ta:datagridItem id="iaa002" key="审核标志" width="70" collection="IAA002" />
						<ta:datagridItem id="yab029" key="养老个人编号" width="95" align="center"/>
						<ta:datagridItem id="aac001" key="个人编号" width="85" align="center"/>
						<ta:datagridItem id="aac003" key="姓名" width="70" align="center" showDetailed="true"/>
						<ta:datagridItem id="aac002" key="社会保障号" width="150" align="center" dataAlign="left" showDetailed="true"/>
						<ta:datagridItem id="aac009" key="户口性质" width="75" align="center" dataAlign="center" collection="AAC009"/>
						<ta:datagridItem id="aac040" key="新缴费工资" width="90" align="center" dataAlign="right" showDetailed="true" dataType="Number" />
						<ta:datagridItem id="yac004" key="新养老基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" />
						<ta:datagridItem id="yaa333" key="新其他基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" />						
						<ta:datagridItem id="yac506" key="原缴费工资" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" />
						<ta:datagridItem id="yac507" key="原养老基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" />
						<ta:datagridItem id="yac508" key="原其他基数" width="80" align="center" dataAlign="right" showDetailed="true" dataType="Number" />
						<ta:datagridItem id="aae110" key="养老" width="40" align="center" collection="AAE140"/>
						<ta:datagridItem id="aae210" key="失业" width="40" align="center" collection="AAE140"/>
						<ta:datagridItem id="aae310" key="医疗" width="40" align="center" collection="AAE140"/>
						<ta:datagridItem id="aae410" key="工伤" width="40" align="center" collection="AAE140"/>
						<ta:datagridItem id="aae510" key="生育" width="40" align="center" collection="AAE140"/>
						<ta:datagridItem id="aae311" key="大额" width="40" align="center" collection="AAE140"/>
						<ta:datagridItem id="yae110" key="养老备注" width="105" align="left" showDetailed="true" />
						<ta:datagridItem id="yae310" key="医疗备注" width="105" align="left" showDetailed="true" />
						<ta:datagridItem id="yae210" key="失业备注" width="105" align="left" showDetailed="true" />
						<ta:datagridItem id="yae410" key="工伤备注" width="105" align="left" showDetailed="true" />
						<ta:datagridItem id="yae510" key="生育备注" width="105" align="left" showDetailed="true" />	
						<ta:dataGridToolPaging url="yearInternetApplyQueryAction!queryDetail.do" pageSize="100" submitIds="form1" showButton="true" 
				    showCount="true" showDetails="true" selectExpButtons="1" showExcel="true" ></ta:dataGridToolPaging>
					</ta:datagrid>
				</ta:tab>

			</ta:tabs>
		</ta:form>
	</body>
</html>
<script type="text/javascript">
	$(document).ready(function () {                                                                                                                                                                                                                                                    
		$("body").taLayout();                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
	});
	//打印基数表
	function fnPrint(){
	    var aab001 = Base.getValue("aab001");
	    var aae001 = Base.getValue("aae001");
	    var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printEmpJS.do?aab001="+aab001+"&aae001="+aae001;
		open(url);
	}
		//打印基数汇总表
	function fnPrint1(){
	    var aab001 = Base.getValue("aab001");
	    var aae001 = Base.getValue("aae001");
	    var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printUnitJSH.do?aab001="+aab001+"&aae001="+aae001;
		open(url);
	}
	//预览单个人员的补缴差额
	function fnInfo(o){
		var aab001 = Base.getValue('aab001');
		var aae001 = Base.getValue('aae001');
		Base.openWindow("perInfo","人员险种补差信息","yearInternetApplyAction!perInfo.do",{"dto['aac001']":o.aac001,"dto['aac040']":o.aac040,"dto['aab001']":aab001,"dto['aae001']":aae001},1000,350,null,null,true,null,null);
	}
	
	//显示按钮板（导出补差明细excel）
	function fnexcBCDetail(){
		var aab001 = Base.getValue('aab001');
		var aae001 = Base.getValue('aae001');
		Base.openWindow('perInfo',"单位险种实际补差信息","yearInternetApplyQueryAction!btnPanel.do",{"dto['aab001']":aab001,"dto['aae001']":aae001},550,380,null,null, true);
	}
	//页面初始查询
	function query() {
		Base.submit("form1","yearInternetApplyQueryAction!queryDetail.do",null);
	}
	//打印补差申报表
	function fnprintBCDetail(){	  
    	var yae010 = "3";
    	var aab001 = Base.getValue('aab001');
		var aae001 = Base.getValue('aae001');
    	var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printBCDetail.do?aab001="+aab001+"&aae001="+aae001+"&yae010="+yae010;
		open(url);
	}
	function fnprintBCDetail2(){
    	var yae010 = "1";
    	var aab001 = Base.getValue('aab001');
		var aae001 = Base.getValue('aae001');
    	var url = "<%=basePath%>" + "nethall/company/yearApply/yearInternetApplyAction!printBCDetail.do?aab001="+aab001+"&aae001="+aae001+"&yae010="+yae010;
		open(url);
	}
</script>
<%@ include file="/ta/incfooter.jsp"%>