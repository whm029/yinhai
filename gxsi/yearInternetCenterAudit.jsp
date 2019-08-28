<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<%@ taglib prefix="ta" tagdir="/WEB-INF/tags/tatags" %>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>单位年申报审核</title>
		<%@ include file="/ta/inc.jsp"%>
	</head>
	<body oncontextmenu="self.event.returnValue=false">
	<ta:form id="form1">
		<ta:fieldset id="panel0" cols="4">
				<ta:box cols="4" cssStyle="width:100%;">
					<ta:radiogroup id="audit" cols="4" span="4">
						<ta:radio id="audit_0" key="未申报" value="0"/>
						<ta:radio id="audit_1" key="待审" value="1"/>
						<ta:radio id="audit_2" key="通过" value="2"/>
						<ta:radio id="audit_3" key="已打回" value="3"/>
					</ta:radiogroup>
				</ta:box>
				<ta:text id="aab001" key="单位编号"/>
				<ta:text id="aae001" key="年审年度" required="true"/>
				<ta:buttonLayout>
					<ta:button key="查询" icon="icon-search" asToolBarItem="true" onClick="queryInfo();" id="queryBtn" cssStyle="border: 1px outset buttonshadow;" />
					<ta:button id="messageInfo" key="发送短消息" asToolBarItem="true"  icon="icon-save" onClick="fnMessage()" cssStyle="border: 1px outset buttonshadow;"/>
					<ta:button id="btnRetset" key="重置" asToolBarItem="true" type="resetPage"  cssStyle="border: 1px outset buttonshadow;"/>
				</ta:buttonLayout>
		</ta:fieldset>
		
		<ta:panel fit="true" height="470px" key="单位年审信息">
			<ta:datagrid  id="auditCon" haveSn="true" fit="true" columnFilter="true" selectType="checkbox" snWidth="60"> 
				<ta:datagridItem id="iaa002" key="申报状态" collection="IAA002" width="60" />
				<ta:datagridItem id="iaa011" key="业务类型" width="60" collection="IAA011"/>
				<ta:datagridItem id="irad54c" key="备注条数" width="80" dataAlign="center"/>
				<ta:datagridItem id="aab001" key="单位助记码" width="80" click="fnshbz" dataAlign="center"/>
				<ta:datagridItem id="aab004" key="单位名称" showDetailed="true" width="190"/>
				<ta:datagridItem id="aae001" key="年度" width="50" showDetailed="true"/>
				<ta:datagridItem id="aaa165" key="预约号" width="100" showDetailed="true"/>	
				<ta:datagridItem id="aaa156" key="预约地" width="100" showDetailed="true"/>	
				<ta:datagridItem id="iaz051" key="提交编号" showDetailed="true" width="190"/>
				<ta:datagridItem id="aab016" key="专管员" width="60" />
				<ta:datagridItem id="aae035" key="申报时间" width="130" showDetailed="true"/>
				<ta:datagridItem id="sh" key="审核" click="fnAudit" width="60"/>
				<ta:datagridItem id="bc" key="补差" click="fnBC" width="60" />
				<ta:datagridItem id="aae036" key="审核时间" width="130" showDetailed="true"/>
				<ta:datagridItem id="aee011" key="审核人员" width="80" />
				<ta:datagridItem id="fssj" key="养老基数写入" icon="icon-save" click="fnFSSJ" width="120" />
				<ta:dataGridToolPaging url="yearInternetCenterAuditAction!queryYearAuditInfo.do" 
				   submitIds="form1" showCount="true" showExcel="true" pageSize="500" selectExpButtons="1,2">
				</ta:dataGridToolPaging>
			</ta:datagrid>
		</ta:panel>

		<ta:box id="auditBZInfo" cssStyle="display:none;width:700px;height:380px;">
			  <ta:fieldset id="panel" cols="2">
					<ta:text id="aab001_1" key="单位编号" readOnly="true"/>
					<ta:text id="aae001_1" key="年审年度" readOnly="true"/>
					<ta:textarea id="aae013" key="备注" height="40" span="2" required="true"/>
					<ta:text id="iaa011_1" key="年审类型" display="false"/>
				</ta:fieldset>
				<ta:buttonLayout>
        	<ta:button key="查询" icon="icon-search" onClick="queryBZ();" id="bzBtn" />
        	<ta:button key="添加" icon="icon-add" onClick="addBZ();" id="addBtn" />
        </ta:buttonLayout>
			  <ta:panel height="200px">
        	<ta:datagrid id="bzList" haveSn="true" fit="true" columnFilter="true" forceFitColumns="true" selectType="checkbox">
						<ta:datagridItem id="sc" key="删除" icon="icon-cancel" click="fnscbz" width="40"/>
						<ta:datagridItem id="iab001" key="备注编号" width="90" hiddenColumn="true"/>
						<ta:datagridItem id="aab001" key="单位编号" width="90"/>
						<ta:datagridItem id="aae001" key="年度" width="50"/>
						<ta:datagridItem id="aae013" key="备注" width="230" showDetailed="true"/>
						<ta:datagridItem id="aae035" key="登记时间" width="90"/>
						<ta:datagridItem id="aee011" key="登记人员" width="90" collection="YAE092"/>
        	</ta:datagrid>
				</ta:panel>
		</ta:box>
	</ta:form>
	</body>
</html>

<script type="text/javascript">
	$(document).ready(function () {
		$("body").taLayout();
	});

	//审核
	function fnAudit(rowData) {
	  Base.setValue("audit_1","");
		Base.setValue("audit_2","2");
	  Base.setValue("aab001",rowData.aab001);
		Base.openWindow("yearInternetCenterAudit","单位年申报信息审核","yearInternetCenterAuditAction!queryTheWorkInfo.do",{"dto['aab001']":rowData.aab001,"dto['aae001']":rowData.aae001,"dto['iaa011']":rowData.iaa011},1000,500,null,queryInfo,true,null,null);
	}

	//补差
	function fnBC(rowData){
	    if(rowData.bc.search('已经补差') != -1){
	    	 Base.alert("当前单位<font color='red'>["+rowData.aab001+":"+rowData.aab004+"]已经做过补差,</font>不能再做补差操作!");
	    }else{  
	      // Base.setValue("audit_1","");
		  // Base.setValue("audit_2","2");
		   Base.setValue("aab001",rowData.aab001);
		  //Base.submit("auditCon","yearInternetCenterAuditAction!yearSalaryBc.do",{"dto['aab001']":rowData.aab001,"dto['aae001']":rowData.aae001,"dto['iaa002']":rowData.iaa002,"dto['iaa011']":rowData.iaa011});
		   Base.submit("auditCon","yearInternetCenterAuditAction!yearSalaryBc.do",{"dto['aab001']":rowData.aab001,"dto['aae001']":rowData.aae001,"dto['iaa002']":rowData.iaa002,"dto['iaa011']":rowData.iaa011},null,null,queryInfo,null);
		}
	}

	function fnFSSJ(rowData){
		if(rowData.iaa011!='A05'){
			Base.alert("不是企业年申报");
             return;
			}
		  if(!(rowData.bc.search('已经补差') != -1)){
			  Base.alert("当前单位<font color='red'>["+rowData.aab001+":"+rowData.aab004+"]未补差,</font>先做补差操作!");
		      
		    }else{  
		       //Base.setValue("audit_1","1");
			 //  Base.setValue("audit_2","");
			  // Base.setValue("aab001","");
			   Base.submit("auditCon","yearInternetCenterAuditAction!yearSalaryFSSJ.do",{"dto['aab001']":rowData.aab001,"dto['aae001']":rowData.aae001,"dto['iaa002']":rowData.iaa002,"dto['iaa011']":rowData.iaa011},null,null,queryInfo,null);
			}
	}

	function queryInfo(){
		Base.submit("form1","yearInternetCenterAuditAction!queryYearAuditInfo.do",null,null,null);
	}

	//批量导出
	function fnExcel(o){
		var id = o.id.substr(7, 2);
		Base.submitForm("form1",null,false,"yearInternetCenterAuditAction!excExport.do?aae140="+id);
		Base.hideMask();
	}

	function fnMessage(){
	    var auditConInfo = Base.getGridSelectedRows("auditCon");
	    if(auditConInfo == null || auditConInfo == ''){
		   Base.alert('请选择需要审核的信息记录!','warn');
		   return;
	    }else{
	       Base.submit("auditCon","yearInternetCenterAuditAction!message.do",null,null,null,null)
	       Base.openWindow('neweditWin',"编辑短消息","yearInternetCenterAuditAction!messageInfo.do",null,480,250,null,function(){ window.location.href = window.location.href;},true,null,null);
        }
    }

	//审核备注弹出框
  function fnshbz(o){
    var aab001 = o.aab001;
		var aae001 = o.aae001;      
		var iaa011 = o.iaa011;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
	  	Base.setValue("aab001_1",aab001);                                                                                                                                                                                                                                                 
	  	Base.setValue("aae001_1",aae001);     
	  	Base.setValue("iaa011_1",iaa011);                                                                                                                                                                                                                                             
	  	Base.setValue("aae013","");  
	  	Base.clearGridData('bzList');                                                                                                                                                                                                                                               
    	$("#auditBZInfo").show().window({title:"审核备注信息", modal:false, collapsible:false, minimizable:false});                                                                                                                                                                              
    	Base.submit("aab001_1,aae001_1","yearInternetCenterAuditAction!querySHBZ.do");
    }

	//备注登记查询
  function queryBZ(){
   	Base.submit("aab001_1,aae001_1","yearInternetCenterAuditAction!querySHBZ.do");
  }

  //备注登记保存
  function addBZ(){
   	Base.submit("panel","yearInternetCenterAuditAction!saveSHBZ.do");
  }

	//备注删除
  function fnscbz(o){
    var iab001 = o.iab001;
    Base.submit("aab001_1,aae001_1","yearInternetCenterAuditAction!deleteSHBZ.do",{"dto['iab001']":iab001});
  }
</script>
<%@ include file="/ta/incfooter.jsp"%>