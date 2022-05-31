
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
%>
<%@ include file="../Proc/TransferLibYum.jsp"%>

<%
    String msProv;
    String msTarget = "Preview";
    String msCSSFile;

    try{
        //msTarget=request.getParameter("target");
        msProv=request.getParameter("cmbProvRep");
        msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";
    }
    catch(Exception e){
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
	var gaDataset =
<%= moAbcUtils.getJSResultSet(getQueryReport(request)) %>
	;

	//Like a array copy                
	var laDataset =
<%= moAbcUtils.getJSResultSet(getQueryReport(request)) %>
	;
	var laSelected = simpleArray(laDataset.length);
</script>

<!-- JavaScript functions only for choose products -->
<script src="../Scripts/FChooseProductsYum.js"></script>
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
				<div id="goDataGrid"></div> <br>
			<br></td>
		</tr>
	</table>

	<jsp:include page='/Include/TerminatePageYum.jsp' />
</body>
</html>

<%!String getQueryReport(HttpServletRequest poRequest) {
		/* Se descartan los elementos que ya han sido seleccionados */
		String lsInvId = getSelectedItems(poRequest);

		return getFChooseProductsQuery("input", lsInvId);
	}%>
