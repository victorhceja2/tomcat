
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryReportFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Mostrar los productos del inventario para un reporte.
# Fecha Creacion  : 03/Agosto/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page import="java.util.*, java.io.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
	AplicationsV2 logApps = new AplicationsV2();
	String msYear;
	String msPeriod;
	String msWeek;
	String msFamily;
	String msSales;
	String msTarget;
	String msCSS;
	boolean isReport;
	String msFirst="false";
%>

<%
	try
	{
		msYear   = request.getParameter("year");
		msPeriod = request.getParameter("period");
		msWeek   = request.getParameter("week");
		msFamily = request.getParameter("hidFamily");
		msSales  = request.getParameter("hidSales");
		msTarget = request.getParameter("hidTarget");
		msFirst  = request.getParameter("hidFirst");
		if ( msFirst == null )
			msFirst="false";
	}
	catch(Exception e)
	{
		msYear   = "0";
		msPeriod = "0";
		msWeek   = "0";
		msFamily = "-1";
		msFirst  = "false";
	}
	
	if(msTarget.equals("Printer"))
	{
		msCSS = "DataGridReportPrinterYum.css";
		isReport = true;
	}
	else
	{
		msCSS = "DataGridDefaultYum.css";
		isReport = false;
	}

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Detalle Inventario", msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/<%= msCSS %>"/>
		<link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <script src="../Scripts/InventoryLibYum.js"></script>
        <script src="../Scripts/InventoryConfigYum.js"></script>
        <script src="../Scripts/InventoryPreviewYum.js"></script>

		<% if(isReport){ %>
        <script src="../Scripts/InventoryReportYum.js"></script>
		<% } %>

        <script type="text/javascript">

		//Estas dos variables son requeridas en el Script InventoryPreviewYum.js
	    var gaDataset = new Array();
		<%= getDataset() %>

		var netSale   = <%= msSales %>;

        </script>
    </head>

    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" 
          onLoad="initDataGrid(<%= isReport %>)"> <!-- true: isReport -->

        <script src="/Scripts/TooltipsYum.js"></script>

    <jsp:include page="/Include/GenerateHeaderYum.jsp">
		<jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <table width="99%" border="0" align="center" cellspacing="6">
        <tr>
			<td>
				<b class="datagrid-leyend">A&ntilde;o: <%= msYear %>, Periodo: <%= msPeriod %>, Semana: <%= msWeek %></b>
            </td>
        </tr>
        <tr>
            <td>
                <div id="goDataGrid"></div>
                <br>
            </td>
        </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!
	String getDataset()
	{
		logApps.writeInfo("InventoryReportFrm.jsp.getDataset\nmsFirst:[" + msFirst + "]");
		if ( msFirst.equals("true") ){
			return getDataset(true, msYear, msPeriod, msWeek, msFamily);
		} else {
			return getDataset(false, msYear, msPeriod, msWeek, msFamily);
		}
	}

%>
