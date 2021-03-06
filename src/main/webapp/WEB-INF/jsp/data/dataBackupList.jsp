<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/taglib.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<HTML xmlns="http://www.w3.org/1999/xhtml"><HEAD>
<base href="${config:url(pageContext.request)}">
<TITLE>数据备份列表</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="_csrf_token" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<link href="backstage/css/list.css" type="text/css" rel="stylesheet"/>
<link href="backstage/css/table.css" type="text/css" rel="stylesheet"/>
<script language="javascript" src="backstage/js/Tool.js" type="text/javascript"></script>
<script language="javascript" src="backstage/js/ajax.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
//提交备份
function submitBackup(){
	//获取提交的参数
	var parameter = "";
	var csrf =  getCsrf();
	parameter += "&_csrf_token="+csrf.token;
	parameter += "&_csrf_header="+csrf.header;
	//删除第一个&号,防止因为多了&号而出现警告: Parameters: Invalid chunk ignored.信息
	if(parameter.indexOf("&") == 0){
		parameter = parameter.substring(1,parameter.length);
	}
	post_request(function(value){
		if(value != ""){
			if(value == "1"){
				document.getElementById("log").innerHTML = "开始备份";
				document.getElementById("submit").disabled = true;
				
				queryBackupProgress();
			}else if(value == "2"){
				alert("任务正在运行，请稍后再试");
			}
			
		}
	},
		"${config:url(pageContext.request)}control/dataBase/manage${config:suffix()}?method=backup&timestamp=" + new Date().getTime(), true,parameter);

}

//查询备份进度
function queryBackupProgress(){
	get_request(function(value){
		if(value != ""){
			document.getElementById("log").innerHTML = value;
			setTimeout(function(){
				if(value != "备份完成"){
					queryBackupProgress();
				}
				
		    }, 3000);//3秒钟刷新 
		}
	},
		"${config:url(pageContext.request)}control/dataBase/manage${config:suffix()}?method=queryBackupProgress&timestamp=" + new Date().getTime(), false);
}


</script>
</HEAD>

<BODY>
<!-- IE6 会弹出'已终止操作'错误，本JS要放在Body标签下面 -->
<script type="text/javascript" src="backstage/spin/spin.min.js" ></script>
<DIV class="d-box">
<div class="d-button">
	<input class="functionButton" type="button" onClick="javascript:window.location.href='${config:url(pageContext.request)}control/dataBase/list${config:suffix()}'" value="返回">
</div>
<form:form>
<TABLE class="t-table" cellSpacing="1" cellPadding="2" width="100%" border="0">
	<TBODY>
	<TR>
    <TD class="t-label t-label-h" width="15%">备份进度：</TD>
    <TD class="t-content" width="85%" >
    	<span id="log"></span>
    </TD>
  </TR>
		<TR>
		    <TD class="t-button" height="50px" colSpan="2">
		         <span class="submitButton"><INPUT type="button" id="submit" value="立即备份" onClick="submitBackup();return false;"></span>
		  		<span style="color: red;">注意：备份过程不能中断</span>
		  	</TD>
		</TR>
	</TBODY>
</TABLE>

<TABLE class="t-list-table" cellSpacing="1" cellPadding="0" width="100%" border="0">
  <THEAD class="t-list-thead">
  <TR>
    <TH>表名称</TH>
    <TH>记录条数</TH>
    <TH>索引大小</TH>
    <TH>数据大小</TH>
    </TR></THEAD>
  <TBODY class="t-list-tbody" align="center">
   <c:forEach items="${showTable}" var="entry">
	  <TR >
	    <TD width="30%">${entry.name }</TD>
	    <TD width="20%">${entry.rows}</TD>
	    <TD width="20%" >${entry.indexSize}</TD>
	    <TD width="30%">${entry.dataSize}</TD>
	  </TR>
	 </c:forEach>
	 <TR >
	    <TD>总大小</TD>
	    <TD>${countRow}</TD>
	    <TD>${countIndexSize}</TD>
	    <TD>${countDataSize}</TD>
	  </TR>
  </TBODY>
</TABLE>
</form:form>
</DIV></BODY></HTML>
