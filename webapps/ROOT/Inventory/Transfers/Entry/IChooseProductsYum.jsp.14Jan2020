<%@page import="org.w3c.dom.ls.LSResourceResolver"%>
<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : IChooseProductsYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Mostrar todos los productos del inventario.
# Fecha Creacion  : 15/Julio/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@page import="java.util.*, java.io.*, java.text.*"%>
<%@page import="generals.*"%>
<%@page import="jinvtran.inventory.*"%>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
	AplicationsV2 logApps = new AplicationsV2();
	String ipRemStore;
%>
<%@ include file="../Proc/TransferLibYum.jsp"%>

<%
    String msProv;
    String msTarget = "Preview";
    String msCSSFile;

    ConectStore cs=null;
    try{
        //msTarget=request.getParameter("target");
        msProv=request.getParameter("cmbProvRep");
        msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";
	    logApps.writeInfo("\n" + new Date() + ": Se buscarán los productos que se pueden traspasar en el CC " + request.getParameter("ipRemStore"));
	    
		String query= "SELECT ip_addr from ss_cat_neighbor_store WHERE store_id="+request.getParameter("ipRemStore");
		logApps.writeInfo("\n" + query);
		ipRemStore = moAbcUtils.queryToString(query);
		String[] lsDate = syscalgt("-p").split("\\/");
		String lsYear = "20" + lsDate[0];
		String lsPeriod = lsDate[1];
		String lsWeek = lsDate[2];
		cs = new ConectStore(ipRemStore,"dbeyum","postgres","");
		ConectStore csUpdate = new ConectStore(ipRemStore,"dbeyum","postgres","","select get_product_using(" + lsYear + "," + lsPeriod + "," + lsWeek + ")");
		csUpdate.getResultQuery();
    
    } catch(Exception e){
        msProv="-1";
        msCSSFile = "/CSS/DataGridReportPreviewYum.css";
        logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Productos a traspasar", msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
<head>
<link rel="stylesheet" type="text/css"
	href="/CSS/GeneralStandardsYum.css" />
<link rel="stylesheet" type="text/css"
	href="/CSS/DataGridDefaultYum.css" />
<link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css" />

<script src="/Scripts/ReportUtilsYum.js"></script>
<script src="/Scripts/AbcUtilsYum.js"></script>
<script src="/Scripts/ArrayUtilsYum.js"></script>
<script src="/Scripts/MiscLibYum.js"></script>
<script src="/Scripts/DataGridClassYum.js"></script>
<script src="/Scripts/MathUtilsYum.js"></script>

<script type="text/javascript">
	var loGrid = new Bs_DataGrid('loGrid');

	//Original values
<%logApps.writeInfo("Query en IChooseProductsYum:\n" + getQueryReport(request));%>
	var gaDataset =
<%= cs.getJSResultSet(getQueryReport(request)) %>
	;
	//var gaDataset =  
	<!-- %= moAbcUtils.getJSResultSet(getQueryReport(request)) % -->//; Original

	//Like a array copy                
	var laDataset =
<%= cs.getJSResultSet(getQueryReport(request)) %>
	;
	//var laDataset  = 
	<!-- %= moAbcUtils.getJSResultSet(getQueryReport(request)) % -->//; Original
	var laSelected = simpleArray(laDataset.length);
</script>

<!-- JavaScript functions only for choose products -->
<script src="../Scripts/ChooseProductsYum.js"></script>
</head>

<body bgcolor="white" onLoad="initDataGrid()">

	<table align="center" width="98%" border="0">
		<tr>
			<td class="descriptionTabla" width="15%" nowrap>
				<form name="frmGrid" id="frmGrid">
					<input type="button" value="Aceptar" onClick="addProducts()">
					<input type="button" value="Cancelar" onClick="cancel()"> <input
						type="hidden" name="hidTransferId" value="">
				</form>
			</td>
		</tr>
		<tr>
			<td><br>
				<div id="goDataGrid"></div> <br> <br></td>
		</tr>
	</table>

	<jsp:include page='/Include/TerminatePageYum.jsp' />
</body>
</html>

<%!String getQueryReport(HttpServletRequest poRequest) {
		/* Se descartan los elementos que ya han sido seleccionados */
		String lsInvId = getSelectedItems(poRequest);

		return getChooseProductsQuery("input", lsInvId, ipRemStore);
	}%>
