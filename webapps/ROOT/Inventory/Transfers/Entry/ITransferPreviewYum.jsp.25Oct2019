<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : ITransferConfirmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Mostrar los productos que se van a recibir. Se tiene que hacer la confirmacion.
# Fecha Creacion  : 11/Julio/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*, java.io.*, java.text.*"%>
<%@ page import="generals.*"%>
<%@ page import="jinvtran.inventory.*"%>
<%@ include file="../Proc/TransferLibYum.jsp"%>

<%! 
    AbcUtils moAbcUtils = new AbcUtils(); 
	AplicationsV2 logApps = new AplicationsV2();
    String msLocalStoreId;
    String msRemoteStoreId;
    String msRemoteStore;
    String msTransferType = "1";
    String msUser="";
    String msProduct="";
%>

<%
    try{
        msLocalStoreId  = getStoreId();
        msRemoteStoreId = request.getParameter("hidNeighborStore");

        msRemoteStore   = msRemoteStoreId + "-" + getNeighborStoreName(msRemoteStoreId);
        msUser = request.getParameter("hidUser").split(" ")[0];
        msProduct = request.getParameter("transferProd");
        logApps.writeInfo(new Date() + ": USER en ITransferPreviewYum.jsp: " + msUser);
    }
    catch(Exception e){
    	logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Revisi&oacute;n Transferencia de entrada", "Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
<head>
<link rel="stylesheet" type="text/css"
	href="/CSS/GeneralStandardsYum.css" />
<link rel="stylesheet" type="text/css"
	href="/CSS/DataGridDefaultYum.css" />

<script src="/Scripts/ArrayUtilsYum.js"></script>
<script src="/Scripts/MathUtilsYum.js"></script>
<script src="/Scripts/DataGridClassYum.js"></script>
<script src="/Scripts/MiscLibYum.js"></script>

<script type="text/javascript">
	//Estas dos variables son requeridas en el Script TransferPreviewYum.js
	var laDataset =
<%= moAbcUtils.getJSResultSet(getQueryReport(request)) %>
	;
	var lsTransferMsg = 'Cantidades a traspasar';
	var lbProduct =
<%=msProduct%>
	;

	function cancel() {
		if (lbProduct == 1) {
			doClosePreview('PTransfer');
		} else {
			doClosePreview('ITransfer');
		}
		window.close();
	}
</script>

<script src="../Scripts/TransferLibYum.js"></script>
<script src="../Scripts/TransferPreviewYum.js"></script>
<!-- Para tener control en el "doble-click" -->
<script src='/Scripts/DoubleClickYum.js'></script>

</head>

<body bgcolor="white"
	onLoad="initDataGrid('input'); resetFrame(lbProduct==1?'PTransfer':'ITransfer')">
	<jsp:include page="/Include/GenerateHeaderYum.jsp">
		<jsp:param name="psStoreName" value="true" />
	</jsp:include>

	<table align="center" width="98%" border="0">
		<tr>
			<td align="center" class="mainsubtitle"><br> <br>
				&#191; Desea confirmar esta transferencia de entrada de la unidad <%=msRemoteStore%>
				&#63; <br> <br></td>
		</tr>
		<tr>
			<td class="descriptionTabla" width="15%" nowrap>
				<form name="mainform" action="ITransferConfirmYum.jsp">
					<input type="button" name="btnAceptar" value="Aceptar"
						onclick="handleClick(event.type,'itransferConfirm()');"
						ondblclick="handleClick(event.type,'itransferConfirm()')">
					<input type="hidden" name="hidLocalStore"
						value="<%=msLocalStoreId%>"> <input type="hidden"
						name="hidRemoteStore" value="<%=msRemoteStoreId%>"> <input
						type="hidden" name="transfer" value="1"> <input
						type="button" value="Cancelar" onClick="cancel()">
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
		if (poRequest.getParameter("transferProd") == null) {
			moAbcUtils.executeSQLCommand("DELETE FROM op_grl_step_transfer",
					new String[] {});
			if (Boolean.valueOf(isFranq())) {
				insertItemsF(poRequest, msLocalStoreId, msRemoteStoreId,
						msTransferType);
			} else {
				insertItems(poRequest, msLocalStoreId, msRemoteStoreId,
						msTransferType);
			}
		}

		return getTransferDetailQuery(true); //true: De la tabla de paso
	}%>
