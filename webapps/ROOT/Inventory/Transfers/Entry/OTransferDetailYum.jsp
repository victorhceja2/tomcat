<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : OTransferDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Mostrar los productos que se van a transpasar a otra tienda.
# Fecha Creacion  : 07/Abril/2005
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
	int transferExists = 0;
	boolean lbIsFranq = Boolean.valueOf(isFranq());
	int neighborStore = 0;
    try {
    	String transfer = request.getParameter("transfer");
    	String store = request.getParameter("remSt");

    	if(transfer != null){
        	transferExists = Integer.parseInt(transfer);
    	}
    	if(store != null){
        	neighborStore = Integer.parseInt(store);
    	}
    } catch(Exception e) {
    	logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }
    if(lbIsFranq){
    	logApps.writeInfo("\n" + new Date() + ": Se realizara una transferencia de Salida");
    }else{
    	if (neighborStore == 2223) {
			logApps.writeInfo("\n" + new Date() + ": Se realizara una transferencia de salida de tapas y canastillas");
		} else {
			logApps.writeInfo("\n" + new Date() + ": Se realizara una transferencia especial");
		}
	}

	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler) session
			.getAttribute(request.getRemoteAddr());
	moHtmlAppHandler.setPresentation("VIEWPORT");
	moHtmlAppHandler.initializeHandler();
	moHtmlAppHandler.msReportTitle = getCustomHeader(
			"Productos a traspasar", "Preview");
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

<script src="/Scripts/MathUtilsYum.js"></script>
<script src="/Scripts/ReportUtilsYum.js"></script>
<script src="/Scripts/AbcUtilsYum.js"></script>
<script src="/Scripts/ArrayUtilsYum.js"></script>
<script src="/Scripts/StringUtilsYum.js"></script>
<script src="/Scripts/MiscLibYum.js"></script>
<script src="/Scripts/DataGridClassYum.js"></script>
<script src="/Scripts/HtmlUtilsYum.js"></script>

<!-- JavaScript Functions only for detail transfers -->
<%if(lbIsFranq){%>
<script src="../Scripts/FTransferDetailYum.js"></script>
<%}else{ %>
<script src="../Scripts/TransferDetailYum.js"></script>
<%} %>
<!-- 
	Archivo que define la hora de bloqueo de transferencias de salida a los CC
	con la ip NA 
-->
<script src="/Scripts/HourBlockTransfers.txt"></script>

<script type="text/javascript">
	var loGrid = new Bs_DataGrid('loGrid');
	var liTransferExists = <%= transferExists %>;

	var gaDataset = <%= getDataset(transferExists) %>;
	var isFranq = <%= lbIsFranq%> ;
	var lfMaxInventoryQty = 0;
	var lfOrigInventoryQty = 0;
	var lfMaxProviderQty = 0;
	var lfOrigProviderQty = 0;
	var loLastObject = null;

	function submitUpdate() {
		var lsStoreId = parent.getNeighborStore();
		var changes = false;

		if (giNumRows > 0) {
			for (var liRowId = 0; liRowId < giNumRows; liRowId++) {
				if (document.getElementById('chkRowControl|' + liRowId).checked) {
					changes = true;

					var lfProviderQuantity = _getProviderQty(liRowId)
					var lfInventoryQuantity = _getInventoryQty(liRowId);

					if (lfProviderQuantity == 0 && lfInventoryQuantity == 0) {
						alert('No puede dejar los dos valores en cero.');

						focusElement('inventoryQty|' + liRowId);
						return false;
					}
				}
			}
			if (changes)
				parent.submitChanges("OTransferPreviewYum.jsp");
			else
				alert("Seleccione los productos que quiere traspasar");
		} else
			alert("Seleccione los productos que quiere traspasar");

	}

	function onBlurCustomControl(poControl, event) {
		var lsElement = poControl.name;
		var lsRowId = lsElement.substring(lsElement.indexOf('|') + 1);
		var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));

		if (lsRowName == 'inventoryQty')
			if (_getInventoryQty(lsRowId) < 0) {
				alert('No puede poner valores negativos.');
				unfocusElement(goCurrentCtrl.id);
				focusElement(goLastCtrl.id);
			} else if (_getInventoryQty(lsRowId) > (lfMaxInventoryQty + lfOrigInventoryQty)) {
				lsInventoryUm = _getInventoryUm(lsRowId);
				lsMsg = 'No puede transferir mas de '
						+ (lfMaxInventoryQty + lfOrigInventoryQty) + ' '
						+ lsInventoryUm;

				alert(lsMsg);

				unfocusElement(goCurrentCtrl.id);
				focusElement(goLastCtrl.id);

				document.getElementById(poControl.id).value = lfOrigInventoryQty;
			}

		if (lsRowName == 'providerQty') {
			if (_getProviderQty(lsRowId) < 0) {
				alert('No puede poner valores negativos.');
				unfocusElement(goCurrentCtrl.id);
				focusElement(goLastCtrl.id);
			} else if (_getProviderQty(lsRowId) > (lfMaxProviderQty + lfOrigProviderQty)) {
				lsMsg = 'No puede transferir mas de '
						+ (lfMaxProviderQty + lfOrigProviderQty) + ' '
						+ _getProviderUm(lsRowId);

				alert(lsMsg);

				unfocusElement(goCurrentCtrl.id);
				focusElement(goLastCtrl.id);

				document.getElementById(poControl.id).value = lfOrigProviderQty;
			}
		}
		updateExistence(lsRowId);
	}

	function updateExistence(psRowId) {
		lsFinExistence = 'finalExistence|' + psRowId;
		lsTotalTransfer = 'totalTransfer|' + psRowId;
		lsInvQuantity = 'inventoryQty|' + psRowId;
		lsPrvQuantity = 'providerQty|' + psRowId;
		lsPrvFc = 'providerFc|' + psRowId;

		lfCurrentExist = _getCurrentExistence(psRowId);
		lfInvQuantity = _getInventoryQty(psRowId);
		lfPrvQuantity = _getProviderQty(psRowId);

		//lfFinExistence  = lfPrvQuantity * _getProviderCF(psRowId) + lfInvQuantity;
		lfFinExistence = lfInvQuantity;

		document.getElementById(lsTotalTransfer).innerHTML = round_decimals(
				lfFinExistence, 2)
				+ ' ' + _getInventoryUm(psRowId);
		document.getElementById(lsFinExistence).innerHTML = round_decimals(
				(lfCurrentExist - lfFinExistence), 2)
				+ ' ' + _getInventoryUm(psRowId);

		document.getElementById(lsInvQuantity).value = lfInvQuantity + ' '
				+ _getInventoryUm(psRowId);
		document.getElementById(lsPrvQuantity).value = round_decimals(
				lfInvQuantity, 2)
				+ ' ' + _getProviderUm(psRowId);
	}

	function maxProviderQty(piRowId, piColId) {
		if (isFranq == true || parent.getNeighborStore() == "2223") {
			lfMaxQuantity = _getMaxProviderQty(piRowId);
		} else {
			lfMaxQuantity = _getNeighborExistence(piRowId);
		}
		lfMaxQuantityPrv = round_decimals(
				((_getNeighborExistence(piRowId) - _getInventoryQty(piRowId)) / 1),
				//((_getNeighborExistence(piRowId) - _getInventoryQty(piRowId)) / _getProviderCF(piRowId)),
				2);

		if (lfMaxQuantity > 0) {
			lsMaxQuantity = lfMaxQuantityPrv + ' ' + _getProviderUm(piRowId);
			return 'Dispone de ' + lsMaxQuantity
					+ ' m&aacute;s que puede transferir';
		} else
			return 'No hay m&aacute;s elementos que transferir';
	}

	function maxInventoryQty(piRowId, piColId) {
		if (isFranq == true || parent.getNeighborStore() == "2223" ) {
			lfMaxQuantity = _getMaxInventoryQty(piRowId);
		} else {
			lfMaxQuantity = _getNeighborExistence(piRowId);
		}
		var lfCurrentQuantity = lfMaxQuantity - _getInventoryQty(piRowId);

		if (lfMaxQuantity > 0) {
			lsMaxQuantity = round_decimals(lfCurrentQuantity, 2) + ' '
					+ _getInventoryUm(piRowId);
			return 'Dispone de ' + lsMaxQuantity
					+ ' m&aacute;s que puede transferir';
		} else
			return 'No hay m&aacute;s elementos que transferir';
	}

	function validaFechaHora() {
		if (isFranq == "false"){
			if(parent.getNeighborStore() != "2223") {
				var Dia = new Array("Domingo", "Lunes", "Martes", "Miércoles",
						"Jueves", "Viernes", "Sábado", "Domingo");
				var Hoy = new Date();
				//alert(Dia[Hoy.getDay()]);
				if (Dia[Hoy.getDay()] == dayBlock && Hoy.getHours() >= hourBlock
						&& Hoy.getMinutes() > minuteBlock) {
					alert("Solo se pueden realizar transferencias especiales antes de las "
							+ hourBlock + ":" + minuteBlock + " horas");
					document.frmGrid.btnUpdate.disabled = true;
					document.frmGrid.btnSelectProducts.disabled = true;
				}
			}
		}
	}
</script>
</head>

<body bgcolor="white"
	onLoad="initDataGrid('output'); parent.hideWaitMessage(); validaFechaHora()">

	<script src="/Scripts/TooltipsYum.js"></script>

	<form name="frmGrid" id="frmGrid" method="post">
		<table align="center" width="98%" border="0">
			<tr>
				<td class="descriptionTabla" width="15%" nowrap>
				<input
					type="button" value="Actualizar" onClick="submitUpdate()"
					name="btnUpdate" id="btnUpdate"> 
				<input type="button"
					value="Agregar productos" onClick="submitAdd('output')"
					name="btnSelectProducts" id="btnSelectProducts"> 
				<input
					type="hidden" name="remSt" id="remSt" value="<%=neighborStore%>">
				<input
					type="hidden" name="hidNeighborStore" id="hidNeighborStore" value="<%=neighborStore%>">
				<input type="hidden" name="hidUser" id="hidUser">
				<input type="hidden" name="transfer" id="transfer" value="<%=transferExists%>">
				</td>
			</tr>
			<tr>
				<td><br>
					<div id="goDataGrid"></div> <br> <br></td>
			</tr>
		</table>
	</form>

	<jsp:include page='/Include/TerminatePageYum.jsp' />
</body>
</html>
