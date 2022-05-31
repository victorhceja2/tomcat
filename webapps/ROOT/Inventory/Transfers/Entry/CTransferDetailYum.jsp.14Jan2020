<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : CTransferDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : javm
# Objetivo        : Mostrar los productos que se van a transpasar a otra tienda.
# Fecha Creacion  : 07/Abril/2016
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
    String remStore = "000";
    HashMap<String,String> transfers = null;
    logApps.writeInfo("\n" + new Date() + ": Se confirmara una transferencia de salida");
    try
    {
        transferExists = Integer.parseInt(request.getParameter("transfer"));
        remStore = request.getParameter("remSt");
        transfers=getTransfers(remStore);
    }
    catch(Exception e)
    {
    	logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    	transfers = new HashMap<String,String>();
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Productos a traspasar", "Preview");
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
<script src="/Scripts/RemoteScriptingYum.js"></script>

<!-- JavaScript Functions only for detail transfers -->
<script src="../Scripts/TransferDetailYum.js"></script>

<script type="text/javascript">
	var loGrid = new Bs_DataGrid('loGrid');
	var liTransferExists = <%= transferExists %>;

	var gaDataset = <%= getDataset(transferExists) %>;
	var lfMaxInventoryQty = 0;
	var lfOrigInventoryQty = 0;
	var lfMaxProviderQty = 0;
	var lfOrigProviderQty = 0;
	var loLastObject = null;

	function submitUpdate() {
		//var lsStoreId = parent.getNeighborStore();
		disableButtons();
		document.frmGrid.cmbTransfer.disabled = true;

		var loUser = parent.getUser();
		var lsPass = parent.getPwd();
		if (loUser == "-1") {
			alert("Por favor seleccione un gerencial");
			return;
		}
		if (lsPass == "") {
			alert("Por favor ingrese su contraseña");
			return;
		}
		var user_pwd = loUser + ',' + lsPass;
		jsrsExecute("RemoteMethodsYum.jsp", validateCredentials,
				"verifyCredentials", user_pwd);

	}

	function validateCredentials(rsUserPwd) {
		if (rsUserPwd == "FALSE" || rsUserPwd == "ERROR") {
			parent.focusElement('cmbAsoc');
			alert('El usuario y/o contraseña no coinciden');
			if (loTransferId > 0) {
				document.frmGrid.btnUpdate.disabled = false;
				document.frmGrid.btnReject.disabled = false;
				document.frmGrid.cmbTransfer.disabled = false;
			}
			return false;
		} else {
			var lsTransferId = document.frmGrid.cmbTransfer.value;
			var loUser = parent.getUser();
			var loDataConfirm = loUser + ',' + lsTransferId;
			jsrsExecute("RemoteMethodsYum.jsp", confirmTransfer,
					"confirmTransfer", loDataConfirm);
		}
	}

	function confirmTransfer(answer) {
		if (answer == 'OK') {
			alert('La transferencia se ha aceptado y se ha ingresado el traspaso en el centro destino');
			location.reload();
		} else {
			answer = answer.replace("OK", "");
			alert('Ocurrio un error al confirmar la transferencia: ' + answer);
		}
		document.frmGrid.cmbTransfer.disabled = false;
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

		lfCurrentExist = _getCurrentExistence(psRowId);
		lfInvQuantity = _getInventoryQty(psRowId);
		lfPrvQuantity = _getProviderQty(psRowId);

		lfFinExistence = lfPrvQuantity * _getProviderCF(psRowId)
				+ lfInvQuantity;

		document.getElementById(lsTotalTransfer).innerHTML = round_decimals(
				lfFinExistence, 2)
				+ ' ' + _getInventoryUm(psRowId);
		document.getElementById(lsFinExistence).innerHTML = round_decimals(
				(lfCurrentExist - lfFinExistence), 2)
				+ ' ' + _getInventoryUm(psRowId);

		document.getElementById(lsInvQuantity).value = lfInvQuantity + ' '
				+ _getInventoryUm(psRowId);
		document.getElementById(lsPrvQuantity).value = lfPrvQuantity + ' '
				+ _getProviderUm(psRowId);
	}

	function maxProviderQty(piRowId, piColId) {
		lfMaxQuantity = _getMaxProviderQty(piRowId);

		if (lfMaxQuantity > 0) {
			lsMaxQuantity = lfMaxQuantity + ' ' + _getProviderUm(piRowId);
			return 'Dispone de ' + lsMaxQuantity
					+ ' m&aacute;s que puede transferir';
		} else
			return 'No hay m&aacute;s elementos que transferir';
	}

	function maxInventoryQty(piRowId, piColId) {
		lfMaxQuantity = _getMaxInventoryQty(piRowId);

		if (lfMaxQuantity > 0) {
			lsMaxQuantity = round_decimals(lfMaxQuantity, 2) + ' '
					+ _getInventoryUm(piRowId);
			return 'Dispone de ' + lsMaxQuantity
					+ ' m&aacute;s que puede transferir';
		} else
			return 'No hay m&aacute;s elementos que transferir';
	}

	function submitReject() {
		var loUser = parent.getUser();
		var lsPass = parent.getPwd();
		if (loUser == "-1") {
			alert("Por favor seleccione un gerencial");
			return;
		}
		if (lsPass == "") {
			alert("Por favor ingrese su contraseña");
			return;
		}
		var user_pwd = loUser + ',' + lsPass;
		jsrsExecute("RemoteMethodsYum.jsp", rejectTransfer,
				"verifyCredentials", user_pwd);
	}

	function rejectTransfer(rsUserPwd) {
		if (rsUserPwd == "FALSE" || rsUserPwd == "ERROR") {
			parent.focusElement('cmbAsoc');
			alert('El usuario y/o contraseña no coinciden');
			if (loTransferId > 0) {
				document.frmGrid.btnUpdate.disabled = false;
				document.frmGrid.btnReject.disabled = false;
				document.frmGrid.cmbTransfer.disabled = false;
			}
			return false;
		} else {
			loTransferId = document.frmGrid.cmbTransfer.value;
			if (loTransferId > 0) {
				dest = window
						.open("", 'choose',
								'width=400, height=350, menubar=no,scrollbars=yes,resizable=yes');
				document.frmGrid.target = 'choose';
				document.frmGrid.action = 'ChooseReasonReject.jsp?lsTransId='
						+ loTransferId + '&hidUser=' + parent.getUser();
				document.frmGrid.submit();
				location.reload();
			} else {
				alert('Se debe seleccionar una transferencia para rechazar');
			}
		}
	}

	function getStatusTransfer(lsStatus) {
		if (lsStatus == "CONFIRM") {
			submitUpdate();
		} else if (lsStatus == "REJECT") {
			submitReject();
		} else {
			alert('La transferencia ya se ha Aceptado o Rechazado, consulte el estado en el reporte de Confirmaci\u00F3n de Transferencias');
			location.reload();
		}
	}

	function validateStatusTransfer(lsAction) {
		var loData = new Array();
		loTransferId = document.frmGrid.cmbTransfer.value;
		loData.push(loTransferId);
		loData.push(lsAction);
		jsrsExecute("RemoteMethodsYum.jsp", getStatusTransfer,
				"getStatusTransfer", loData);
	}

	function viewDetailTransfer() {
		loTransferId = document.frmGrid.cmbTransfer.value;
		if (loTransferId > 0) {
			document.frmGrid.btnUpdate.disabled = false;
			document.frmGrid.btnReject.disabled = false;
			jsrsExecute("RemoteMethodsYum.jsp", updateProducts, "getDataSet",
					loTransferId);
		} else {
			disableButtons();
			gaDataset = new Array();
			initDataGrid('input');
		}
	}

	function updateProducts(dataSet) {
		var data = new Array();
		var rows = dataSet.split(">");
		for (row in rows) {
			var info = new Array();
			var columns = rows[row].split(",");
			for (column in columns) {
				info.push(columns[column]);
			}
			data.push(info);
		}
		gaDataset = data;
		initDataGrid('input');
	}

	function disableButtons() {
		document.frmGrid.btnUpdate.disabled = true;
		document.frmGrid.btnReject.disabled = true;
	}
</script>
</head>

<body bgcolor="white"
	onLoad="initDataGrid('output'); parent.hideWaitMessage(); disableButtons()">

	<script src="/Scripts/TooltipsYum.js"></script>

	<form name="frmGrid" id="frmGrid" method="post">
		<table align="center" width="98%" border="0">
			<tr>
				<td class="descriptionTabla" width="15%" nowrap><select
					id="cmbTransfer" name="cmbTransfer" size="1" class="combos"
					onChange="viewDetailTransfer()">
						<option value="-1" selected>-- Seleccione una
							Transferencia --</option>
						<%
							writeOptions(out, transfers);
						%>
				</select> <input type="button" value="Aceptar" id="btnUpdate"
					name="btnUpdate" onClick="validateStatusTransfer('CONFIRM')">
					<!--input type="button" value="Agregar productos" onClick="submitAdd('output')"-->
					<input type="button" value="Rechazar" id="btnReject"
					name="btnReject" onClick="validateStatusTransfer('REJECT')">
					<input type="hidden" name="hidNeighborStore" id="hidNeighborStore">
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
