<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CustomDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Reporte Clientes Sin Recurrencia
# Fecha Creacion  : 14/Feb/2008
# Inc/requires    : ../Proc/CustomLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria CustomLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/CustomLibYumAC.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msFamilyId;
	String msFrecId;
	String msDate;
	String msDataset;
	String msClient = "0";
	String msClientIn = "0";
	String msAgeb	= "";
%>	

<%
	moAbcUtils = new AbcUtils();
    try{
		msFamilyId = request.getParameter("hidFamily");
		msFrecId   = request.getParameter("hidFrecu");
		msDate     = request.getParameter("hidDate");
		if(msDate.equals("") || msDate.equals(null)){
			msDate = "31/10/2006";
		}
		msAgeb	= request.getParameter("hidAgeb");
	}
    catch(Exception e){
		System.out.println("CustomDetailAC.jsp ... " + e);
    }
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte Clientes", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

	msDataset = "new Array()";
	if(!(msFamilyId.equals("0"))){
		msDataset = getDataset(msFamilyId, msFrecId, msDate, msAgeb);
		msClientIn = getRescli(msFamilyId, msFrecId, msDate, msAgeb);
		msClient = getClients(msFamilyId, msFrecId, msDate, msAgeb);
	}
	else{
		msClient = "0";
		msClientIn = "0";
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
        <script src="../Scripts/CustomLibYumAC.js"></script>
        <script src="../Scripts/CustomDetailYumA.js"></script>
        <script type="text/javascript">
			function submitPrint(){
				window.open("./CustomPrintPAC.jsp?hidFrecu=<%=msFrecId%>&hidDate=<%=msDate%>&hidFamily=<%=msFamilyId%>&hidAgeb=<%=msAgeb%>", "Impresion Reporte","width='10px', height='10px',left='35px', top='20px'");
			}
			var gaDataset = <%= msDataset %>;
        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(); parent.hideWaitMessage();" style="margin-left: 4px; margin-right: 0px">
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
					<td colspan="2" align="center" class="body">
						<%=msClient%> clientes, concentrados en <%= msClientIn %> agebs.
					</td>
				</tr>																				 
				<tr>
            		<td colspan="2">
                		<div id="goDataGrid"></div>
            		</td>
        		</tr>
        	</table>
			<input type="hidden" name="hidFamily" value="<%= msFamilyId %>">
		</form>
    	<jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

