
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryReportFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Mostrar los productos del inventario de criticos para un reporte.
# Fecha Creacion  : 26/Diciembre/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
	String msQdate;
	String msSales;
	String msTarget;
	String msCSS;
	String msDate;
	boolean isReport;

%>

<%
	try{
		msQdate  = request.getParameter("hidQdate");
		msSales  = request.getParameter("hidSales");
		msTarget = request.getParameter("hidTarget");

		//msDate = getBusinessDate();
		msDate = msQdate;
	}
	catch(Exception e){
		msQdate = "-1";
	}
	
	if(msTarget.equals("Printer")){
		msCSS = "DataGridReportPrinterYum.css";
		isReport = true;
	}
	else{
		msCSS = "DataGridDefaultYum.css";
		isReport = false;
	}

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Detalle Inventario de Cr&iacute;ticos", msTarget);
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
    
        <script src="../Scripts/InventoryCritLibYum.js"></script>
        <!--<script src="../Scripts/InventoryCritConfigYum.js"></script>-->
        <script src="../Scripts/InventoryCritPreviewYum.js"></script>

		<% if(isReport){ %>
            <script src="../Scripts/InventoryCritReportYum.js"> </script>
		<% } %>

        <script type="text/javascript">

		//Estas dos variables son requeridas en el Script InventoryPreviewYum.js
	var gaDataset = new Array();
	<%= getDataset() %>
	var gaDataSet2 = new Array();
	<%= getDataSet2() %>
	//var netSale   = <%= msSales %>;

	function hideWaitMessage(){
		if (parent) {
			if (typeof parent.hideWaitMessage == 'function'){
				setTimeout("parent.hideWaitMessage()", 2000);
			}
   		}
	}
        </script>
    </head>

    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" 
          onLoad="initDataGrid(<%= isReport %>);initDataGrid2(<%= isReport %>);hideWaitMessage()"> <!-- true: isReport -->

        <script src="/Scripts/TooltipsYum.js"></script>

    <jsp:include page="/Include/GenerateHeaderYum.jsp">
    	<jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <table width="99%" border="0" align="center">
    	<tr>
	   <td class="TextBodyDesc" width="35">
	   <b>Fecha de negocio:</b> <%=msDate%> &nbsp;
	   </td>
	</tr>
        <tr>
            <td>
                <div id="goDataGrid"></div>
                <br>
            </td>
        </tr>
	<tr>
	   <td>
	      <div id="goDataGrid2"></div>
	      <br>
	   </td>
	</tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!
	String getDataset(){
		return getDatasetR(false, msQdate);
	}

	String getDataSet2(){
		return getDatasetAcum(false, msQdate);
	}

%>
