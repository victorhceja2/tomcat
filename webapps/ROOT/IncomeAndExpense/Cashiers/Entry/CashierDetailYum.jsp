<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CashierDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : MCA
# Objetivo        : Reporte Cajeros
# Fecha Creacion  : 14/Feb/2008
# Inc/requires    : ../Proc/CashierLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria CashierLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/CashierLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msDate;
	String msDataset;
	String msEmp;
	String lsEmp;
	String msMngr;
	String lsMngr;
%>	

<%
    moAbcUtils = new AbcUtils();
    try{
	msMngr     = request.getParameter("hidMngr");
	msDate     = request.getParameter("hidDate");
	
        System.out.println("Este es el valor de msDate: "+msDate);
	if(msDate.equals("") || msDate.equals(null) || msDate == null){
		msDate = "31/10/2010";
	}

	msEmp = request.getParameter("hidEmp");
        if(msEmp == null){
    		System.out.println("Empleado: "+msEmp);
                msEmp = "";
	}
	if(msEmp.equals("")){
		msEmp = "ALL";
	}
    }catch(Exception e){
	System.out.println("CashierDetail.jsp ... " + e);
    }
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte Clientes", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    msDataset = "new Array()";
   System.out.println("Antes de: "+msEmp);

    if( msEmp != null ){
        updateP1toDB();
        msDataset = getDataset(msDate, msEmp, msMngr);
        lsMngr = getEmpRequest(msMngr);
        lsEmp = getEmpRequest(msEmp);
    }
%>

<html>
	<head>
    	<link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="../Scripts/CashierLibYum.js"></script>
        <script src="../Scripts/CashierDetailYum.js"></script>
        <script type="text/javascript">
	function submitPrint(){
		window.open("./CashierPrintP.jsp?hidDate=<%=msDate%>&hidEmp=<%=msEmp%>&hidMngr=<%=msMngr%>", "Impresion Reporte","width='10px', height='10px',left='35px', top='20px'");
	}
	var gaDataset = <%= msDataset %>;
	var gsEmpCashier = "<%= getEmpRequest(msEmp) %>"
	var gsReport = "ok"  
	var gsEmpMgr = "<%= getEmpRequest(msMngr) %>"
        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(gsReport, gsEmpMgr, gsEmpCashier); parent.hideWaitMessage();" style="margin-left: 4px; margin-right: 0px">
        <script src="/Scripts/TooltipsYum.js"></script>
        <script src="/Scripts/FixedTooltipsYum.js"></script>
		<form name="frmGrid" id="frmGrid" method="post">
        	<table align="center" width="100%" border="0" cellspacing="3">
        		<tr>
            		<td class="descriptionTabla" width="90%">&nbsp;</td>
				<td width="10%" align="center">
					<a href="javascript: submitPrint()"><img src="/Images/Menu/print_button.gif" border="0"></a>
				</td>
        		</tr>
			<tr>
        	    	<td colspan="2">
                		<div id="goDataGrid"></div>
            		</td>
        		</tr>
        	</table>
		</form>
    	<jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

