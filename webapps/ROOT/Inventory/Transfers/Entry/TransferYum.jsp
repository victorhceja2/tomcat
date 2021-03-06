<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : TransferYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Contenedor principal de la pantalla de captura de transferencias
# Fecha Creacion  : 06/Abril/2005
# Inc/requires    : 
# Modificaciones  :
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
%>

<%
	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler) session
			.getAttribute(request.getRemoteAddr());
	moHtmlAppHandler.msReportTitle = "Transferencias";
	boolean lbIsFranq = Boolean.valueOf(isFranq());
	logApps.writeInfo("\n" + new Date() + ": Inicia la aplicación de traspasos");
%>

<html>
<head>
<title>Transferencias</title>
<link rel="stylesheet" type="text/css"
	href="/CSS/GeneralStandardsYum.css" />
<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css" />
<link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css" />

<div id="divWaitGSO" style="width: 400px; height: 150px"
	class="wait-gso">
	<br>Calculando la existencia actual en inventario. <br> <br>Espere
	por favor...<br> <br>
</div>

<div id="divValCon" style="width: 400px; height: 150px"
	class="wait-gso">
	<br><br>Validando la conexion con el restaurante vecino.<br><br>
	Espere por favor...<br><br>
</div>

<script src="/Scripts/RemoteScriptingYum.js"></script>
<script src="/Scripts/AbcUtilsYum.js"></script>
<script src="/Scripts/ReportUtilsYum.js"></script>
<script src="/Scripts/Chars.js"></script>
<script src="/Scripts/StringUtilsYum.js"></script>
<script src="/Scripts/HtmlUtilsYum.js"></script>

<script>
	var gaKeys = new Array('');
	var liRowCount = 0;
	var liRowCountRecep = 0;
	var lsProductoCodeLst = '';
	var lsProductoCodeRecepLst = '';
	var msLastTab = '1';
	var gsStoreName = '';
	var loStoreId = '';
	var loTransOutOnly = 0;
	
	function centerDivWait() {
        document.getElementById('divValCon').style.left = (Math.round(getWindowWidth()/2) - 135) + 'px';
        document.getElementById('divValCon').style.top = (Math.round(getWindowHeight()/2) - 80) + 'px';
    }
    
    centerDivWait(); 

	function printDetail() {
		executeDetail();
	}

	function adjustPageSettings() {
		adjustContainer(60, 165);
	}

	function showHideControls() {
<%if (lbIsFranq == false) {%>
	//showHideControl('divCredentials', 'visible');
		showHideControl('tabsFran', 'hidden');
		showHideControl('divTransferCtrls', 'visible');
<%} else {%>
	showHideControl('divCredentials', 'hidden');
		showHideControl('tabsPremium', 'hidden');
		showHideControl('divTransferCtrls', 'hidden');
<%}%>
	}

	function loadFirstTab() {
		document.frmMaster.reset();
		//document.frmTransfer.submit();
		//showHideControls();
	}

	function validOption(psTab, psReSt) {
<%if (!lbIsFranq) {%>
	var lsStoreId = document.frmMaster.txtStore.value;
		if (lsStoreId == '') {
			alert('Debe ingresar el n\u00FAmero de tienda al que desea hacer el traspaso');
			focusNeighborStore();
			return;
		}
<%}%>
	switch (psTab) {
		case '1':
			if (loTransOutOnly == 0) {
				document.getElementById("storeDesc").innerHTML = "Tienda de origen";
<%if (!lbIsFranq) {%>
	browseDetail('ITransferDetailYum.jsp?transfer=0&remSt='
						+ psReSt, 'TransferYum.jsp', '1');
<%} else {%>
	browseDetail('FITransferDetailYum.jsp?transfer=0',
						'TransferYum.jsp', '1');
<%}%>
	} else {
				alert('Solo se permite hacer transferencias de salida para el CC ingresado');
			}
			break;
		case '2':
			if (loTransOutOnly == 0) {
				document.getElementById("storeDesc").innerHTML = "Tienda destino";
<%if (!lbIsFranq) {%>
	browseDetail('CTransferDetailYum.jsp?transfer=0&remSt='
						+ psReSt, 'TransferYum.jsp', '2');
<%} else {%>
	browseDetail('OTransferDetailYum.jsp?transfer=0&remSt=0',
						'TransferYum.jsp', '2');
<%}%>
	} else {
				alert('Solo se permite hacer transferencias de salida para el CC ingresado');
			}
			break;
		case '3':
			if (loTransOutOnly == 1) {
				browseDetail('OTransferDetailYum.jsp?transfer=0&remSt='
						+ psReSt, 'TransferYum.jsp', '3');
				document.getElementById("storeDesc").innerHTML = "CC destino";
				showHideControl('divTransferCtrls', 'visible');
			} else {
				alert('No se permite realizar Traspasos Especiales para la tienda ingresada');
			}
			break;
		case '4':
			browseDetail('PTransferDetailYum.jsp?transfer=0&remSt=' + psReSt,
					'TransferYum.jsp', '4');
			document.getElementById("storeDesc").innerHTML = "CC destino";
			showHideControl('divTransferCtrls', 'visible');
			break;
		}

	}
	function validateSearch() {
		return (true);
	}

	function focusNeighborStore() {
		focusElement('txtStore');
	}

	function unfocusNeighborStore() {
		unfocusElement('txtStore');
	}

	function getNeighborStore() {
		var lsStoreId = document.frmMaster.txtStore.value;
		var lsStoreName = document.getElementById('storeName').innerHTML;

		if (!isEmpty(lsStoreId)) {
			if (!isEmpty(lsStoreName)) {
				frames['ifrDetail'].document.getElementById("hidNeighborStore").value = lsStoreId;
				return parseInt(lsStoreId);
			} else
				return -2;
		} else
			return -1;
	}

	function getIdNeighborStore() {
		var lsStoreId = document.frmMaster.txtStore.value;
		if (!isEmpty(lsStoreId)) {
			return lsStoreId;
		}
	}

	function getUser() {
		return document.frmMaster.cmbAsoc.value;
	}

	function getPwd() {
		return document.frmMaster.pwd.value;
	}

	//function validateNeighborStore()
	function submitChanges(psAction) {
		frames['ifrDetail'].document.frmGrid.action = psAction;

		loStoreId = document.frmMaster.txtStore.value;

		var blContinue = true;
		if (!isEmpty(loStoreId)) {
			if (isNaN(Number(loStoreId))) {
				focusNeighborStore();
				alert('Escriba un numero de centro valido!');
				document.frmMaster.txtStore.value = '';

				return false;
			}
		} else {
			focusNeighborStore();
			alert('Escriba el CC para la transferencia');
			document.getElementById('storeName').innerHTML = '';
			return false;
		}
		if (blContinue == true) {
<%if(lbIsFranq){%>
	jsrsExecute("RemoteMethodsYum.jsp", continueValidation,
					"neighborStoreExists", loStoreId);
<%} else {%>
	var lsPass = document.frmMaster.pwd.value;
			var lsUser = document.frmMaster.cmbAsoc.value
			var user_pwd = lsUser + ',' + lsPass;
			if (lsUser == "-1") {
				focusElement('cmbAsoc');
				alert('Se debe selecionar un asociado');
				return false;
			} else if (isEmpty(lsPass)) {
				focusElement('pwd');
				alert('La Contraseńa es obligatoria');
				document.frmMaster.pwd.value = '';
				return false;
			} else {
				jsrsExecute("RemoteMethodsYum.jsp", validateCredentials,
						"verifyCredentials", user_pwd);
			}
<%}%>
	}
	}

	function validateCredentials(rsUserPwd) {
		if (rsUserPwd == "FALSE" || rsUserPwd == "ERROR") {
			focusElement('cmbAsoc');
			alert('El usuario y/o contraseńa no coinciden');
			return false;
		} else {
			jsrsExecute("RemoteMethodsYum.jsp", continueValidation,
					"neighborStoreExists", loStoreId);
		}
	}

	function continueValidation(psStoreName) {
		if (psStoreName == "FALSE" || psStoreName == "ERROR") {
			focusNeighborStore();
			alert('El CC proporcionado no existe.');

			document.frmMaster.txtStore.value = '';
			document.getElementById('storeName').innerHTML = '';

			return false;
		} else {
			unfocusNeighborStore();
			document.getElementById('storeName').innerHTML = psStoreName;

			var lsStoreId = document.frmMaster.txtStore.value;
			frames['ifrDetail'].document.frmGrid.hidNeighborStore.value = lsStoreId;
<%
			if(!lbIsFranq){
			%>
	frames['ifrDetail'].document.frmGrid.hidUser.value = getUser();
<%}//else{%>
	frames['ifrDetail'].document.frmGrid.target = "destino";
			openWindow("", "destino", 990, 600);
			frames['ifrDetail'].document.frmGrid.submit();
<%//}%>
	}
	}

	function testStore() {
<%
	if(!lbIsFranq){
%>
		showHideControl('divValCon', 'visible');
		var lsStoreId = document.frmMaster.txtStore.value;
		if (lsStoreId == '') {
			alert('Por favor ingrese el n\u00FAmero de CC para continuar con el proceso de transferencia');
			focusNeighborStore();
		} else if (!/^([0-9])*$/.test(lsStoreId)) {
			alert('Solo se permite ingresar n\u00FAmeros para el CC de transferencia');
			focusNeighborStore();
		} else {
			loTransOutOnly = 0;
			//validOption("1", lsStoreId);
			jsrsExecute("RemoteMethodsYum.jsp", validatePing,
					"verifyConectionToStore", lsStoreId);
		}
<%}%>
	}

	function validatePing(psIpStore) {
		showHideControl('divValCon', 'hidden');
		var res = psIpStore.substring(0, 4);
		if (psIpStore == "ERROR" || psIpStore == "nhip") {
			focusNeighborStore();
			alert('El CC proporcionado no tiene registrada una direcci\u00F3n de red');
		}
		if (psIpStore == "Intermitente") {
			alert('No hay una conexi\u00F3n correcta con el CC proporcionado, por lo que puede que no se registren correctamente los cambios');
		}
		if (psIpStore == "SinConexion") {
			alert('El CC proporcionado no tiene conexi\u00F3n a la red');
		}
		if (psIpStore == "NA") {
			alert('Para el CC ingresado solo se pueden realizar transferencias de salida especial');
			loTransOutOnly = 1;
		}
		if (psIpStore == "localstore") {
			alert('No se permiten transferencias locales, por favor ingrese otro CC');
			focusNeighborStore();
		}
		if (res == "difW"){
			lsStoreId = document.frmMaster.txtStore.value
			
			lsWeekL = psIpStore.split(":")[1];
			lsWeekN = psIpStore.split(":")[2];
			if(lsWeekL == "Error"){
				alert('No se pudo obtener el periodo y semana del CC proporcionado,\n'
						+ 'por favor considera que puede haber algun error en el proceso de transferencia.\n'
						+ 'Se recomienda intentar mas tarde realizar la transferencia');
			} else {
				alert('El CC proporcionado tiene Periodo y/o semana diferente (' + lsWeekN + '),\n'
						+ 'por favor valida con el encargado del CC ' + lsStoreId + ' que tenga el Periodo y/o semana igual.\n'
						+ 'Si continuas con el proceso de transferencia puede afectar en tu inventario o en el inventario del CC ' + lsStoreId);
			}
			
			//focusNeighborStore();
		}
	}
</script>
</head>
<body onResize='adjustPageSettings();' bgcolor='white'
	OnLoad='loadFirstTab();'>
	<jsp:include page='/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true" />
	</jsp:include>

	<form id='frmMaster' name='frmMaster' method='post'
		action='OrderDetailYum.jsp' target='ifrProcess'>
		<input type='hidden' name='hidOperation' id='hidOperation' value='S'>

		<div id='divTransferCtrls' name='divTransferCtrls'>
			<table width="100%" id="tblCapture" align="right">
				<tr>
					<%
					if(!lbIsFranq){
					%>
					<td class="body" width="35%" align="right" id="user">Gerencial
						en Turno</td>
					<td width="10%"><select id="cmbAsoc" name="cmbAsoc" size="1"
						class="combos" onChange="">
							<option value="-1" selected>-- Seleccione un Asociado --</option>
							<%
												//writeMenu(out, readEmplFMS());
							writeMenu(out, getEmployees());
											%>
					</select></td>
					<td class="body" width="10%" align="right" id="lbPwd">
						Contrase&ntilde;a</td>
					<td width="10%"><input type="password" name="pwd" id="pwd"
						size="12"></td>
					<%
					} else {
					%>
					<td class="body" width="55%"></td>
					<%} %>
					<td class="body" width="20%" align="right" id="storeDesc">
						Tienda</td>
					<td width="10%"><input type="text" name="txtStore"
						id="txtStore" size="4" onBlur="testStore();" maxlength="4">
						<!--onBlur="validateNeighborStore(); unfocusNeighborStore()"--></td>
					<td class="body" width="15%" align="left" id="storeName"></td>
				</tr>
			</table>
		</div>
	</form>
	<br>

	<form action="TransferLimitsYum.jsp" name="frmTransfer"
		target="ifrHelp">
		<input type="hidden" name="providerId">
	</form>

	<table border="0" cellspacing='0' cellpadding='0' width='96%'
		id='tblCourse'>
		<tr valign='top'>
			<td width="100%">
				<div width="100%">
					<% if(!lbIsFranq){
							logApps.writeInfo("No es franquicia");
					%>
					<div class='tabArea' id='tabsPremium' name='tabsPremium'>
						<a class='tab' id='1'
							href='javascript:validOption("1",document.frmMaster.txtStore.value)'>Entradas</a>
						<a class='tab' id='2'
							href='javascript:validOption("2",document.frmMaster.txtStore.value)'>Salidas</a>
						<a class='tab' id='3'
							href='javascript:validOption("3",document.frmMaster.txtStore.value)'>Transferencia
							de Salida Especiales</a>
						<!-- a class='tab' id='4'
							href='javascript:validOption("4",document.frmMaster.txtStore.value)'>Transferencia
							de Producto Final</a-->
					</div>
					<%} else { 
						logApps.writeInfo("Es franquicia");
					%>
					<div class='tabArea' id='tabsFran' name='tabsFran'>
						<a class='tab' id='1'
							href='javascript:validOption("1",document.frmMaster.txtStore.value)'>Transferencia
							de Entrada</a> <a class='tab' id='2'
							href='javascript:validOption("2",document.frmMaster.txtStore.value)'>Transferencia
							de Salida</a>
					</div>
					<%} %>
					<div class='tabMain'>
						<div class='tabIframeWrapper'>
							<iframe class='tabContent' name='ifrDetail' id='ifrDetail'
								marginWidth='4' marginHeight='8' frameBorder='0'>
								<input type='hidden' name='hidUser' id='hidUser'>
							</iframe>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<script>
		adjustPageSettings();
	</script>
</body>
</html>