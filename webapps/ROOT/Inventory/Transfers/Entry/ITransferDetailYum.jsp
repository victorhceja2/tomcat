<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : ITransferDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Mostrar los productos que se van a recibir de otra tienda.
# Fecha Creacion  : 11/Julio/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
# Modificaciones:
# Autor: Sandra Castro
# Fecha: 28/ago/2006
# Descripci?n: A?adir topes en la transferencia de entrada
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@page import="java.util.*, java.io.*, java.text.*"%>
<%@page import="generals.*"%>
<%@page import="jinvtran.inventory.*"%>

<%@ include file="../Proc/TransferLibYum.jsp"%>
<%! 
    AbcUtils moAbcUtils = new AbcUtils();
    AplicationsV2 logApps = new AplicationsV2();
%>

<%
    int transferExists = 0;
    String remStore="";
    String ipRemStore="";
    
    try
    {
        transferExists = Integer.parseInt(request.getParameter("transfer"));
		remStore = request.getParameter("remSt");
		//System.out.println("\n" + new Date() + ": Se realizara solicitud de transferencia del CC " + remStore);
		logApps.writeInfo(new Date() + ": Se realizara solicitud de transferencia del CC " + remStore);
		if(!remStore.equals("")){
			ipRemStore=moAbcUtils.queryToString("SELECT ip_addr from ss_cat_neighbor_store WHERE store_id="+remStore, "", "");
		}
	//System.out.println("\n\nRemote Store: " + remStore+ "\n\n");
    }
    catch(Exception e)
    {
    	logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Productos a recibir", "Preview");
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
<script src="../Scripts/TransferDetailYum.js"></script>

<script type="text/javascript">
	var loGrid = new Bs_DataGrid('loGrid');
	var liTransferExists =
<%= transferExists %>
	;
	var gaDataset =
<%= getDataset(transferExists, true) %>
	;
	var lfMaxInventoryQty = 0;
	var lfOrigInventoryQty = 0;
	var lfMaxProviderQty = 0;
	var lfOrigProviderQty = 0;
	var loLastObject = null;
	var lsStoreId = parent.getIdNeighborStore()

	function submitAddP(ipRemStore) {
		if (lsStoreId == null) {
			alert('Se debe ingresar la tienda de origen para poder seleccionar los productos');
			return;
		}
		dest = window
				.open("", 'choose',
						'width=600, height=650, menubar=no,scrollbars=yes,resizable=yes');
		document.frmGrid.target = 'choose';
		document.frmGrid.action = "IChooseProductsYum.jsp?ipRemStore="
				+ ipRemStore;
		document.frmGrid.submit();
	}

	function submitUpdate() {

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
				parent.submitChanges("ITransferPreviewYum.jsp");
			/*
			if(lsStoreId != -1)
			{
			    openWindow("","destino",990,600);
			    document.frmGrid.target = "destino";
			    document.frmGrid.action = "ITransferPreviewYum.jsp";
			    document.frmGrid.submit();
			}
			else
			{
			    //alert('Escriba el CC del que va a recibir.');
			    parent.focusNeighborStore();
			    return false;
			}*/
			else
				alert("Seleccione los productos que quiere recibir.");
		} else
			alert("Seleccione los productos que quiere recibir.");
	}

	function getLimitReception(psProductId) {
		var lfLimit = 0;
		if (gaDataset.length > 0) {
			for (liRowId = 0; liRowId < gaDataset.length; liRowId++) {
				var lsProduct = gaDataset[liRowId][0];
				var lsLimit = gaDataset[liRowId][1];
				if (rtrim(ltrim(psProductId)) == rtrim(ltrim(lsProduct))) {
					lfLimit = parseFloat(lsLimit);
					break;
				}
			}
		}

		return lfLimit;
	}

	function onBlurCustomControl(poControl, event) {
		var lsElement = poControl.name;
		var goCurrentCtrl = poControl.id;
		var lsRowId = lsElement.substring(lsElement.indexOf('|') + 1);
		var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));

		//SC Inicio L?mites para transferencias
		var liProductCode = _getProviderProductCode(lsRowId);
		var lfConversionFactor = _getProviderCF(lsRowId);
		var lfLimitProvUnit = getLimitReception(liProductCode);
		var lfLimitInvUnit = lfConversionFactor * lfLimitProvUnit;
		var liPorcTope = 25;
		var lfLimit = lfLimitInvUnit * liPorcTope / 100;
		var lsUnit_inv = _getInventoryUm(lsRowId);
		var lsProviderProductDesc = _getProviderProductDesc(lsRowId);
		var lsTransferQtry = _getTransferQty(poControl);
		var lsLimitExistence = _getNeighborExistence(lsRowId);

		if (lsLimitExistence < lsTransferQty) {
			var lsMsg = "No tiene permitido ingresar mas de "
					+ lsLimitExistence + " " + lsUnit_inv;
			lsMsg += " de " + lsProviderProductDesc
					+ ". Verifique la cantidad que esta ingresando";
			alert(lsMsg);
			document.getElementById('inventoryQty|' + lsRowId).value = '0'
					+ lsUnit_inv;
			unfocusElement(goCurrentCtrl);
			focusElement(goLastCtrl.id);
		}
		//SC Fin L?mites para transferencias

		if (lsRowName == 'inventoryQty')
			if (_getInventoryQty(lsRowId) < 0) {
				alert('No puede poner valores negativos.');
				document.getElementById('inventoryQty|' + lsRowId).value = '0'
						+ lsUnit_inv;
				unfocusElement(goCurrentCtrl);
				focusElement(goLastCtrl.id);
			}
		/* 
		         else                    
		             if(_getInventoryQty(lsRowId) > (lfMaxInventoryQty+lfOrigInventoryQty))
		             {    
		                 lsInventoryUm = _getInventoryUm(lsRowId);
		                 lsMsg = 'No puede transferir mas de ' + (lfMaxInventoryQty+lfOrigInventoryQty) + ' ' + lsInventoryUm;
		                 alert(lsMsg);
		                 unfocusElement(goCurrentCtrl);
		                 focusElement(goLastCtrl.id);

		                 document.getElementById(poControl.id).value = lfOrigInventoryQty;
		             }
		     if(lsRowName == 'providerQty')
		         if(_getProviderQty(lsRowId) < 0)
		         {
		             alert('No puede poner valores negativos.');
		             unfocusElement(goCurrentCtrl);
		             focusElement(goLastCtrl.id);
		         }
		         else
		             if(_getProviderQty(lsRowId) > (lfMaxProviderQty+lfOrigProviderQty))
		             {
		                 lsMsg = 'No puede transferir mas de ' + (lfMaxProviderQty+lfOrigProviderQty) + ' '
		                 + _getProviderUm(lsRowId);

		                 alert(lsMsg);

		                 unfocusElement(goCurrentCtrl);
		                 focusElement(goLastCtrl.id);

		                 document.getElementById(poControl.id).value = lfOrigProviderQty;
		             }
		 */
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
		//lfPrvQuantity = _getProviderQty(psRowId);

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
				//(lfInvQuantity / document.getElementById(lsPrvFc).value), 2)
				lfInvQuantity,2)
				+ ' ' + _getProviderUm(psRowId);
	}

	function maxProviderQty(piRowId, piColId) {
		//lfMaxQuantity   = _getMaxProviderQty(piRowId);
		lfMaxQuantity = _getNeighborExistence(piRowId);
		lfMaxQuantityPrv = round_decimals(
				((_getNeighborExistence(piRowId) - _getInventoryQty(piRowId)) / _getProviderCF(piRowId)),
				2);

		if (lfMaxQuantity > 0) {
			lsMaxQuantityPrv = lfMaxQuantityPrv + ' ' + _getProviderUm(piRowId);
			return 'El CC origen dispone de ' + lsMaxQuantityPrv
					+ ' actualmente';
		} else
			return 'No hay m&aacute;s elementos que transferir';
	}

	function maxInventoryQty(piRowId, piColId) {
		//lfMaxQuantity = _getMaxInventoryQty(piRowId);
		lfMaxQuantity = _getNeighborExistence(piRowId);
		var lfCurrentQuantity = lfMaxQuantity - _getInventoryQty(piRowId);

		if (lfMaxQuantity > 0) {
			lsMaxQuantity = round_decimals(lfCurrentQuantity, 2) + ' '
					+ _getInventoryUm(piRowId);
			return 'El CC origen dispone de ' + lsMaxQuantity
					+ ' m&aacute;s que puede transferir';
		} else
			return 'No hay m&aacute;s elementos que transferir';
	}
</script>
</head>

<body bgcolor="white"
	onLoad="initDataGrid('output'); parent.hideWaitMessage()">

	<script src="/Scripts/TooltipsYum.js"></script>

	<form name="frmGrid" id="frmGrid" method="post">
		<%
			if (ipRemStore.equals("NA")) {
		%>
		<h1>
			Solo se pueden realizar Transferencias de Salida Especiales para el
			CC
			<%=remStore%></h1>
		<%
			} else {
		%>
		<table align="center" width="98%" border="0">
			<tr>
				<td class="descriptionTabla" width="15%" nowrap><input
					type="button" value="Actualizar" onClick="submitUpdate()">
					<input type="button" value="Agregar productos"
					onClick="submitAddP(lsStoreId)"> <input type="hidden"
					name="hidNeighborStore" id="hidNeighborStore"> <input
					type="hidden" name="hidUser" id="hidUser"></td>
			</tr>
			<tr>
				<td><br>
					<div id="goDataGrid"></div> <br> <br></td>
			</tr>
		</table>
		<%
			}
		%>
	</form>

	<jsp:include page='/Include/TerminatePageYum.jsp' />
</body>
</html>
