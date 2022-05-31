<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

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
# Descripción: Añadir topes en la transferencia de entrada
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@page import="java.util.*, java.io.*, java.text.*" %>
<%@page import="generals.*" %>
<%@page import="jinvtran.inventory.*" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
	AplicationsV2 logApps = new AplicationsV2();
%>
<%@ include file="../Proc/TransferLibYum.jsp" %>   

<%
    int transferExists = 0;
    try
    {
        transferExists = Integer.parseInt(request.getParameter("transfer"));
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
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <!-- JavaScript Functions only for detail transfers -->
        <script src="../Scripts/FTransferDetailYum.js"></script>

        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');
        var liTransferExists = <%= transferExists %>;
        var gaDataset = <%= getDataset(transferExists, true) %>; 
        var lfOrigInventoryQty  = 0;
        var lfOrigProviderQty   = 0;
        var loLastObject = null;


        function submitUpdate()
        {
            var lsStoreId = parent.getNeighborStore();
            var changes   = false;

            if(giNumRows > 0)
            {
                for(var liRowId=0; liRowId<giNumRows; liRowId++)
                {
                    if(document.getElementById('chkRowControl|'+liRowId).checked)
                    {
                        changes = true;

                        var lfProviderQuantity  = _getProviderQty(liRowId)
                        var lfInventoryQuantity = _getInventoryQty(liRowId);
                        if(lfProviderQuantity == 0 && lfInventoryQuantity == 0)
                        {
                            alert('No puede dejar los dos valores en cero.');

                            focusElement('inventoryQty|'+liRowId);
                            return false;
                        }
                    }
                }
                if(changes)
                    parent.submitChanges("FITransferPreviewYum.jsp");
                    /*
                    if(lsStoreId != -1)
                    {
                        openWindow("","destino",990,600);
                        document.frmGrid.target = "destino";
                        document.frmGrid.action = "FITransferPreviewYum.jsp";
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
            }
            else
                alert("Seleccione los productos que quiere recibir.");
        }
        
        function getLimitReception(psProductId)
            {
                var lfLimit = 0;
                if(gaDataset.length > 0)
                {
                    for(liRowId=0; liRowId<gaDataset.length; liRowId++)
                    {
                        var lsProduct = gaDataset[liRowId][0];
                        var lsLimit   = gaDataset[liRowId][1];
                        if(rtrim(ltrim(psProductId)) == rtrim(ltrim(lsProduct)))
                        {
                            lfLimit = parseFloat(lsLimit);
                            break;
                        }
                    }
                }

                return lfLimit;    
            }

        function onBlurCustomControl(poControl, event)
        {
            var lsElement = poControl.name;
            var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
            var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));
	    
	//SC Inicio Límites para transferencias
	    var liProductCode = _getProviderProductCode(lsRowId);
	    var lfConversionFactor = _getProviderCF(lsRowId);
	    var lfLimitProvUnit      = getLimitReception(liProductCode);
	    var lfLimitInvUnit = lfConversionFactor * lfLimitProvUnit;
	    var liPorcTope = 25;
	    var lfLimit = lfLimitInvUnit * liPorcTope / 100;
	    var lsUnit_inv = _getInventoryUm(lsRowId);
	    var lsProviderProductDesc= _getProviderProductDesc(lsRowId);
		
		if( lfLimit !=0 && _getInventoryQty(lsRowId) > lfLimit){
			var lsMsg = "No tiene permitido ingresar mas de " + lfLimit + " " + lsUnit_inv ;
			lsMsg += " de " + lsProviderProductDesc + ". Verifique la cantidad que esta ingresando";
			alert(lsMsg);
			// Se comenta esta parte para que el bloqueo de entradas sea solo un alert
			/*document.getElementById('inventoryQty|'+lsRowId).value='0' + lsUnit_inv;
			unfocusElement(goCurrentCtrl.id);
			focusElement(goLastCtrl.id);*/
		}
	//SC Fin Límites para transferencias

            if(lsRowName == 'inventoryQty')
                if(_getInventoryQty(lsRowId) < 0)
                {
                    alert('No puede poner valores negativos.');
		    document.getElementById('inventoryQty|'+lsRowId).value='0' + lsUnit_inv;
                    unfocusElement(goCurrentCtrl.id);
                    focusElement(goLastCtrl.id);
                }
		
            if(lsRowName == 'providerQty')
                if(_getProviderQty(lsRowId) < 0)
                {
                    alert('No puede poner valores negativos.');
                    unfocusElement(goCurrentCtrl.id);
                    focusElement(goLastCtrl.id);
                }
            
            updateExistence(lsRowId);
        }

        function updateExistence(psRowId)
        {
            lsFinExistence  = 'finalExistence|'+psRowId;
            lsTotalTransfer = 'totalTransfer|'+psRowId;
            lsInvQuantity   = 'inventoryQty|'+psRowId;
            lsPrvQuantity   = 'providerQty|'+psRowId ;
            lsPrvFc         = 'providerFc|'+psRowId ;

            lfCurrentExist  = _getCurrentExistence(psRowId);
            lfInvQuantity   = _getInventoryQty(psRowId);
            lfPrvQuantity   = _getProviderQty(psRowId);

            //lfFinExistence  = lfPrvQuantity * _getProviderCF(psRowId) + lfInvQuantity;
            lfFinExistence  = lfInvQuantity;

            document.getElementById(lsTotalTransfer).innerHTML = round_decimals(lfFinExistence, 2) + ' ' + _getInventoryUm(psRowId);
            document.getElementById(lsFinExistence).innerHTML = round_decimals((lfCurrentExist + lfFinExistence), 2) + ' ' +
            _getInventoryUm(psRowId);

            document.getElementById(lsInvQuantity).value = lfInvQuantity + ' ' + _getInventoryUm(psRowId);
            document.getElementById(lsPrvQuantity).value = round_decimals((lfInvQuantity / document.getElementById(lsPrvFc).value),2) + ' ' + _getProviderUm(psRowId);
        }

        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid('input'); parent.hideWaitMessage()">

        <script src="/Scripts/TooltipsYum.js"></script>

        <form name="frmGrid" id="frmGrid" method="post">
        <table align="center" width="98%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                <input type="button" value="Actualizar" onClick="submitUpdate()">
                <input type="button" value="Agregar productos" onClick="submitAdd('input')">
                <input type="hidden" name="hidNeighborStore" id="hidNeighborStore">
            </td>
        </tr>
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
