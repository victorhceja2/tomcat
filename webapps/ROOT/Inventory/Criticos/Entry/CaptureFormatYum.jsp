
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CaptureFormatYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Mostrar formato de captura para los productos del inventario.
# Fecha Creacion  : 14/Septiembre/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
	String msYear;
	String msPeriod;
	String msWeek;
	String msFamily;
%>

<%
	try
	{
		msYear   = request.getParameter("hidYear");
		msPeriod = request.getParameter("hidPeriod");
		msWeek   = request.getParameter("hidWeek");
		msFamily = request.getParameter("hidFamily");
	}
	catch(Exception e)
	{
		msYear   = "0";
		msPeriod = "0";
		msWeek   = "0";
		msFamily = "-1";
	}
	
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Formato Captura Inventario", "Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridReportPrinterYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <script src="../Scripts/CaptureFormatYum.js"></script>

        <script type="text/javascript">

		//Estas dos variables son requeridas en el Script InventoryPreviewYum.js
	    var gaDataset = new Array();
		<%= getDataset() %>

        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(true); print();"
style="margin-left: 0px; margin-right: 0px">
	    <jsp:include page="/Include/GenerateHeaderYum.jsp" />

        <form name="frmGrid">
        <table align="center" width="98%" border="0">
        <tr>
            <td>
                <br>
                <div id="goDataGrid"></div>
                <br><br>
            </td>
        </tr>
        </table>
        </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!
	String getDataset()
	{
		return getCaptureFormat(msYear, msPeriod, msWeek, msFamily);
	}
%>
