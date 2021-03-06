<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : ExcepDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sandra Castro 
# Objetivo        : Mostrar los productos a agregar en una excepcion
# Fecha Creacion  : 03/Octubre/2006
# Inc/requires    : ../Proc/ExcepLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria ExcepLibYum.jsp
# Modificaciones:
# Autor: 
# Fecha: 
# Descripción:
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@page import="generals.*" %>
<%@page import="java.util.*, java.io.*, java.text.*;"%>
<%! AbcUtils moAbcUtils = new AbcUtils(); %>
<%@ include file="../Proc/ExcepLibYum.jsp" %>   
<%
int transferExists = 0;
try
{
    transferExists = Integer.parseInt(request.getParameter("transfer"));
}
catch(Exception e){}

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
    
        <!-- JavaScript Functions only for detail exceptions -->
        <script src="../Scripts/ExcepDetailYum.js"></script>

        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');
        var liTransferExists = <%= transferExists %>;
        var gaDataset = <%= getDataset(transferExists, true) %>; 
        var lfOrigInventoryQty  = 0;
        var lfOrigProviderQty   = 0;
        var loLastObject = null;


function submitUpdate(){
    var changes   = false;
    document.frmGrid.hidDocNum.value=getNumDoc();
    if(giNumRows > 0)
    {
        for(var liRowId=0; liRowId<giNumRows; liRowId++)
        {
            if(document.getElementById('chkRowControl|'+liRowId).checked)
            {
                changes = true;
                var lfQtyReceived = _getQtyReceived(liRowId);
                //var lsDiscrepancyCode = _getDiscrepancyCode(liRowId);
                if( lfQtyReceived == 0 )
                {
                    alert('No puede dejar la cantidad recibida en cero.');
                    focusElement('qtyReceived|'+liRowId);
                    return false;
                }
/*                if( lsDiscrepancyCode == 0 ){
                    alert('No puede dejar la cantidad recibida sin c&oacute;digo de discrepancia.');
                    focusElement('discCode|'+liRowId);
                    return false;
                }*/
            }
        }
        if(changes)
            submitChanges("ExcepPreviewYum.jsp");    
        else
            alert("Seleccione los productos que quiere recibir.");
    }
    else
        alert("Seleccione los productos que quiere recibir.");
}

function onBlurCustomControl(poControl, event){
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));
    if(lsRowName == 'qtyReceived'){
        if(_getQtyReceived(lsRowId)<0){
            alert('No puede poner valores negativos.');
            document.getElementById('qtyReceived|'+lsRowId).value= _getProviderUm(lsRowId);
            unfocusElement(goCurrentCtrl.id);
            focusElement(goLastCtrl.id);
        }
        var lfInvReceived =roundNumbers(_getQtyReceived(lsRowId)*_getProviderCF(lsRowId),2);
        var lfSubtotal =roundNumbers(_getQtyReceived(lsRowId)*_getUnitPrice(lsRowId),2);
        document.getElementById('invUnit|'+lsRowId).value=lfInvReceived + ' ' + _getInventoryUm(lsRowId);
        document.getElementById('subtotal|'+lsRowId).value = lfSubtotal;
        document.getElementById('qtyReceived|'+lsRowId).value=_getQtyReceived(lsRowId)+' '+ _getProviderUm(lsRowId);
    }
    // Inicio Límites para excepciones iguales que los limites para recepciones
    var lsProviderId = "PFS";
    var lsProductId  =_getProviderProductCode(lsRowId);
    var lfLimit      = top.ifrHelp.getLimitReception(lsProductId);    
    if( lfLimit !=0 && _getQtyReceived(lsRowId) > lfLimit){
        var lsMsg = "No tiene permitido ingresar mas de "+ lfLimit + " " + _getInventoryUm(lsRowId) ;
        lsMsg += " de " + _getProviderProductDesc(lsRowId) + ". Verifique la cantidad que esta ingresando";
        alert(lsMsg);
        document.getElementById('qtyReceived|'+lsRowId).value='0 ' + _getProviderUm(lsRowId);
        document.getElementById('invUnit|'+lsRowId).value='0 ' + _getInventoryUm(lsRowId);
        document.getElementById('subtotal|'+lsRowId).value='0.00';
        unfocusElement(goCurrentCtrl.id);
        focusElement(goLastCtrl.id);
    }
    // Fin Límites para excepciones
}

function submitChanges(psAction){
    document.frmGrid.action = psAction;
    document.frmGrid.target = "destino";
    openWindow("","destino",990,600);
    document.frmGrid.submit();
}
function createCurrentOrdRem(){
    var lsOrdRem = parent.document.frmMaster.cmbOrdRem.selectedIndex;
    document.frmGrid.hidCurrentOrdRem.value = lsOrdRem;
    submitAdd('input');
}
function roundNumbers(qty, numer_dec) {
    var qty = parseFloat(qty);
    var numer_dec = parseFloat(numer_dec);
    numer_dec = (!numer_dec ? 2 : numer_dec);
    return Math.round(qty * Math.pow(10, numer_dec)) / Math.pow(10, numer_dec);
} 

function initCmb(){
    document.frmGrid.hidCurrentOrdRem.value = 0;
}
    </script>
    <script>
    //Para llenar el combo de los codigos de discrepancia
    var discCodes  = <%= getDiscDataset() %>;
    </script>
    </head>
    <body bgcolor="white" onLoad="initDataGrid('input');initCmb()">
        <script src="/Scripts/TooltipsYum.js"></script>
        <form name="frmGrid" id="frmGrid" method="post">
        <table id="test" align="center" width="98%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                <input type="button" value="Actualizar" onClick="submitUpdate()">
                <!--<input type="button" value="Agregar productos" onClick="submitAdd('input')">-->
        <input type="button" value="Agregar productos" onClick="createCurrentOrdRem()">
                <input type="hidden" name="hidDocNum" id="hidDocNum">
        <input type="hidden" name="hidCurrentOrdRem" id="hidCurrentOrdRem">
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
