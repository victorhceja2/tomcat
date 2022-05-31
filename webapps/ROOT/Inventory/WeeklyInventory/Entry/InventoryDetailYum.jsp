<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : InventoryDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Mostrar los productos del inventario. Permitir la captura del inventario final y merma.
# Fecha Creacion  : 27/Julio/2005
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*, java.io.*"%>
<%@ page import="generals.*"%>
<%@ page import="jinvtran.inventory.*"%>
<%@ page import="jinvtran.inventory.utils.*"%>
<%@ include file="../Proc/InventoryLibYum.jsp"%>

<%!
	AbcUtils moAbcUtils;
	AplicationsV2 logApps = new AplicationsV2();
	String msYear, msPeriod, msWeek;
	String msFamilyId;
	String msSales;
	String[] maFileUnBlock = null;
	//String msFilePeriod, msFileWeek;
	String lsUnBlock = "0";
	boolean lbFirst = false;
	String msInitDate;
%>

<%
	moAbcUtils = new AbcUtils();
	msYear = getInvYear();
	msPeriod = getInvPeriod();
	msWeek = getInvWeek();

	try {
		msInitDate = request.getParameter("hidInitDate");
		msFamilyId = request.getParameter("hidFamily");
		msSales = getSales(msYear, msPeriod, msWeek);
		maFileUnBlock = inventoryFileUnBlock().split("\\|");
		logApps.writeInfo("ANIO " + maFileUnBlock[0] + " PERIODO "
				+ maFileUnBlock[1] + " SEMANA " + maFileUnBlock[2]);
        lbFirst = inventoryFirst(msYear, msPeriod, msWeek);
        logApps.writeInfo("Validacion de tabla first: [" + lbFirst + "]");
	} catch (Exception e) {
		logApps.writeInfo("InventoryDetail.jsp ... " + e);

	}

	if (msYear.equals(maFileUnBlock[0])
			&& msPeriod.equals(maFileUnBlock[1])
			&& msWeek.equals(maFileUnBlock[2])) {
		lsUnBlock = "1";
	}

	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler) session.getAttribute(request.getRemoteAddr());
	moHtmlAppHandler.setPresentation("VIEWPORT");
	moHtmlAppHandler.initializeHandler();
	moHtmlAppHandler.msReportTitle = getCustomHeader("Productos del inventario", "Preview");
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
<script src="../Scripts/ControlInventory.js"></script>

<script type="text/javascript">

		var gaDataset = new Array();
		<%=getDataset()%>
		var netSale = <%=msSales%>;

	function validateCredentials(){
	    var lsEmpl=parent.getUser();
	    var lsPass=parent.getPassword();
	    if(lsEmpl == "-1"){
	       alert('Seleccione un empleado');
	       parent.setFocus('true');
	       return (false);
	    }
	    if(lsPass == ""){
	      alert('La clave de empleado no puede estar vacia');
	      parent.setFocus('false');
	      return (false);
	    }else{
	      var laParams = new Array(2);
	      laParams[0] = lsEmpl;
	      laParams[1] = lsPass;
	      jsrsExecute("RemoteMethodsYum.jsp", submitUpdate, "validateCredentials", laParams);
	    }
	}
	
	function updateValButton(psValButton){
		//alert("psValButton:["+psValButton+"]");
        if(psValButton == true){
        	document.getElementById("btnGuardar").value="Guardar y Cerrar";
        }
	}

	function submitUpdate(psResult){
		if(psResult == "FALSE" || psResult == "ERROR"){
			alert('El empleado y la clave no coinciden, por favor valide que sean correctos');
			parent.setFocus('true');
			return (false);
		}
        if(giNumRows > 0) {
        	lsTried=document.getElementById("btnGuardar").value=="Guardar"?"0":"1";
        	document.frmGrid.hidNumItems.value = giNumRows;
            
            if(lsTried=="1"){
            	lbAnswer=confirm("Se cerrara la semana y no se podran hacer más cambios en el inventario esta de acuerdo");
            	if(lbAnswer==true){
            		dest = window.open("","destino","width=900,height=400");
                    document.frmGrid.target = "destino";
                    document.frmGrid.action = "SaveChangesYum.jsp?hidUser="+parent.getUser()+"&hidTried=2";
                    document.frmGrid.submit();
                    parent.parent.location.href = '/MainPageYum.jsp';
                }else{
                	return false;
                }
            }else{
                alert("Se guardaran los datos pero sin cerrar la semana y sin generar los reportes semanales (PCA, Inventario, Operaciones, etc)");
            	dest = window.open("","destino","width=1100,height=700,scrollbars=yes");
                document.frmGrid.target = "destino";
                document.frmGrid.action = "InventoryPreviewYum.jsp?hidUser="+parent.getUser()+"&hidTried=1";
                document.getElementById("btnGuardar").value="Guardar y Cerrar";
                document.frmGrid.submit();
            }
        } else{
        	alert("No hay productos que actualizar");
        }
	}
	
	/*function validateVals(){
		for(var idx=0; idx<gaDataset.length; idx++){
			if(idx==1){
				alert(document.getElementById("finalPrvQtyRec|"+idx).value);
			}
		}
	}*/

	function submitChanges(newFamily)
	{
		document.frmGrid.hidNumItems.value = giNumRows;
		document.frmGrid.action = "SaveChangesYum.jsp?newFamily="+newFamily;
		document.frmGrid.submit();
	}

	function submitPrint()
	{
		document.frmGrid.hidFamily.value = "-1";
        document.frmGrid.target = "ifrProcess";
        document.frmGrid.action = "CaptureFormatYum.jsp";
        document.frmGrid.submit();
	}

	function submitTempUpdate(request){
        if(giNumRows > 0) {
        	//lsTried=document.getElementById("btnGuardar").value=="Guardar"?"0":"1";
        	document.frmGrid.hidNumItems.value = giNumRows;
                        
        	alert("Se guardaran los datos pero sin cerrar la semana y sin generar los reportes semanales (PCA, Inventario, Operaciones, etc)");
    		dest = window.open("","destino","width=1100,height=700,scrollbars=yes");
            document.frmGrid.target = "destino";
            document.frmGrid.action = "InventoryPreviewYum.jsp?hidUser="+parent.getUser()+"&hidTried=0";
            document.frmGrid.submit();
        }else{
        	alert("No hay productos que actualizar");
        }
	}

    </script>
</head>

<body bgcolor="white"
	onLoad="initDataGrid(true,true,<%=lsUnBlock%>); parent.hideWaitMessage(); updateValButton(<%=lbFirst%>)"
	style="margin-left: 4px; margin-right: 0px">

	<script src="/Scripts/TooltipsYum.js"></script>
	<script src="/Scripts/FixedTooltipsYum.js"></script>

	<form name="frmGrid" id="frmGrid" method="post">
		<table align="center" width="100%" border="0" cellspacing="3">
			<tr>
				<td class="descriptionTabla" width="45%"><input type="button"
					value="Guardar" id="btnGuardar" onClick="validateCredentials()">
					<input type="button"
					value="Guardar y seguir capturando" id="btnSoloGuardar" onClick="submitTempUpdate(this)"></td>
				<td width="10%" align="center"><a
					href="javascript: submitPrint()"><img
						src="/Images/Menu/print_button.gif"
						onMouseOver="ddrivetip('Imprimir formato de captura de inventario.')"
						onMouseOut="hideddrivetip()" border="0"></a></td>
			</tr>
			<tr>
				<td colspan="3">
					<div id="goDataGrid"></div>
				</td>
			</tr>
		</table>
		<input type="hidden" name="hidYear" value="<%=msYear%>"> <input
			type="hidden" name="hidPeriod" value="<%=msPeriod%>"> <input
			type="hidden" name="hidWeek" value="<%=msWeek%>"> <input
			type="hidden" name="hidFamily" value="<%=msFamilyId%>"> <input
			type="hidden" name="hidSales" id="hidSales" value="<%=msSales%>">
		<input type="hidden" name="hidInitDate" id="hidInitDate"
			value="<%=msInitDate%>"> <input type="hidden"
			name="hidNumItems" value="0"> <input type="hidden"
			name="hidHasChanges" value="false">
	</form>

	<jsp:include page='/Include/TerminatePageYum.jsp' />
</body>
</html>

<%!String getDataset() {
	return getDataset(true, msYear, msPeriod, msWeek, msFamilyId);
}%>
