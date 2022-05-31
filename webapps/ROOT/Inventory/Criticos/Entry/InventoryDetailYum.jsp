<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Mostrar los productos del inventario. Permitir la captura del inventario diario y merma.
# Fecha Creacion  : 20/Diciembre/2005
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
    AbcUtils moAbcUtils;
    String msQdate;
    String msSales;
    String msYear;
    String msPeriod;
    String msWeek;
%>    

<%
    moAbcUtils = new AbcUtils();
    msYear     = getInvYear();
    msPeriod   = getInvPeriod();
    msWeek     = getInvWeek();
    msQdate    = getBusinessDate();

    try{
	//TODO: quitar comentario para calculo de getSales()
        //msSales = "5123.32"; 
        getSales(msQdate);
	//msYear = request.getParameter("hidYear");
	//msPeriod = request.getParameter("hidPeriod");
	//msWeek = request.getParameter("hidWeek");
    }
    catch(Exception e){
        System.out.println("InventoryDetail.jsp ... " + e);
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Productos del inventario", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
	<script src="/Scripts/RemoteScriptingYum.js"></script>

    
        <script src="../Scripts/InventoryLibYum.js"></script>
        <script src="../Scripts/InventoryConfigYum.js"></script>
        <script src="../Scripts/InventoryDetailYum.js"></script>

        <script type="text/javascript">

        var gaDataset = new Array();
        <%= getDataset() %>
        var netSale = <%= msSales %>;
	var gsSaveType;

	function validateCredentials(psTypeUpd){
	   gsSaveType = psTypeUpd;
	   var lsEmpl=parent.getUser();
	   var lsPass=parent.getPassword();
	   if(gsSaveType == '2'){
	      if(lsEmpl == "-1"){
	         alert('Seleccione un empleado');
	         parent.setFocus('true');
	         return (false);
	      }
	      if(lsPass == ""){
	         alert('La clave de empleado no puede estar vac\u00EDa');
	         parent.setFocus('false');
	         return (false);
	      }
	   }
	   var laParams = new Array(2);
	   laParams[0] = lsEmpl;
	   laParams[1] = lsPass;
	   jsrsExecute("RemoteMethodsYum.jsp", submitUpdate, "validateCredentials", laParams);
	}

        function submitUpdate(psResult){
	    var lsTriedFlag;
	    var lsYear = <%= msYear%>;
	    var lsPeriod = <%= msPeriod%>;
	    var lsWeek = <%= msWeek%>;
	    if((psResult == "FALSE" || psResult == "ERROR") && gsSaveType == '2'){
	    	alert('El empleado y la clave no coinciden, por favor valide que sean correctos');
		parent.setFocus('true');
		return (false);
	    }
	    
	    if(giNumRows > 0){
                document.frmGrid.hidNumItems.value = giNumRows;
	
		lsTriedFlag = document.getElementById("btnGuardar").value=="Guardar"?"0":"1";
		
		if(lsTriedFlag == '1') // Segunda vez
		   gsSaveType = 'T';

		if(gsSaveType == '2')
		   document.getElementById("btnGuardar").value="Guardar y Cerrar";

                dest = window.open("","destino","width=1000,height=700");
                document.frmGrid.target = "destino";
                document.frmGrid.action = "InventoryPreviewYum.jsp?hidSave="+gsSaveType+"&hidYear="+lsYear+"&hidPeriod="+lsPeriod+"&hidWeek="+lsWeek;
                //document.frmGrid.action = "InventoryPreviewYum.jsp?hidSave="+gsSaveType;
                document.frmGrid.submit();
		if(gsSaveType == 'T'){
		   parent.parent.location.href = '/MainPageYum.jsp';
		}
            }
            else
                alert("No hay productos que actualizar");
        }

        function submitCritics(){
            openWindow("ChooseProductsYum.jsp?hidFamilyId=-1", "destino", "800", "600");
        }

        function submitChanges(newFamily){
            document.frmGrid.hidNumItems.value = giNumRows;
            document.frmGrid.action = "SaveChangesYum.jsp";
            document.frmGrid.submit();
        }

        function submitPrint(){
            document.frmGrid.target = "ifrProcess";
            document.frmGrid.action = "CaptureFormatYum.jsp";
            document.frmGrid.submit();
        }
 
        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(); parent.hideWaitMessage();"
          style="margin-left: 4px; margin-right: 0px">

        <script src="/Scripts/TooltipsYum.js"></script>
        <script src="/Scripts/FixedTooltipsYum.js"></script>
	
        <form name="frmGrid" id="frmGrid" method="post">
        <table align="center" width="100%" border="0" cellspacing="3">
        <tr>
            <td class="descriptionTabla" width="100%"> 
                <input type="button" value="Guardar y seguir capturando" id="btnSeguir" onClick="validateCredentials('1');"> <!--submitUpdat -->
		<input type="button" value="Guardar" id="btnGuardar" onClick="validateCredentials('2');">
                <input type="button" value="Manejar cr&iacute;ticos" onClick="submitCritics()">
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div id="goDataGrid"></div>
            </td>
        </tr>
        </table>
        <input type="hidden" name="hidQdate" value="<%= msQdate %>">
        <input type="hidden" name="hidSales" id="hidSales" value="<%= msSales %>">
        <input type="hidden" name="hidNumItems" value="0">
        <input type="hidden" name="hidHasChanges" value="false">
        </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!
    String getDataset(){
        return getDataset(true, msQdate);
    }
%>
