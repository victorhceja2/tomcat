<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Edit/Proc/EmployeeLib.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
%>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Alta de Empleados";
    String msOperation = "";
	msOperation = request.getParameter("hidOperation");
        
    String msPresentation = (msOperation==null)?"VIEWPORT":msOperation;
	moHtmlAppHandler.setPresentation(msPresentation);
	moHtmlAppHandler.initializeHandler();
    boolean fran=franquicia();
%>

<html>
    <head>
        <title>Formato de captura</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
		<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
    	<link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>
    	
    	<script src="/Scripts/AbcUtilsYum.js"></script>
    	<script type="text/javascript">
        	function loadEntry(){
                <%if(fran){%>
        		    document.frmMaster.action = "EmployeeAddEntry.jsp";
                    document.frmMaster.target = 'ifrDetail';
                    document.frmMaster.submit();
                <%}else{%>				
                    alert("El servicio de alta de Empleados solo es para franquicias.");
                    history.back();
                <%}%>
            }
        </script>
	</head>
	<body bgcolor="white" Onload="loadEntry();">
        <%if(msPresentation.equals("VIEWPORT")){ %>
        	<jsp:include page = '/Include/GenerateHeaderYum.jsp'>
            	<jsp:param name="psStoreName" value="true"/>
        	</jsp:include>
        <% } else { %>
        	<jsp:include page ='/Include/GenerateHeaderYum.jsp'/>
        <% } %>
        <form id="frmMaster" name="frmMaster" method="post" target="ifrDetail">
			<div class='tabMain'>
				<div class='tabIframeWrapper'>
					<iframe class='tabContent' name='ifrDetail' width="100%" height="350" id='ifrDetail' frameBorder='0'></iframe>
				</div>
			</div>
	</form>
	</body>
</html>