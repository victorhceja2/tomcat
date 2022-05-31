 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>
 <%--
##########################################################################################################
# Nombre Archivo  : InvoiceGasCapture.jsp
# Compañia        : Yum Brands Intl
# Autor           : APS
# Objetivo        : Captura de detalle de carga de gas
# Fecha Creacion  : 02/Feb/2007
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>
<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 
	String  msNotes;
	String msStoreId;
	String msTankCapacity;
	String msRequiredPer;
	String msRequiredLit;
	String msMargin;
	String msAcceptedLit;
	String msCurrentDateTime;
	String msRowNum;
%>
<%
    try
    {
	  msNotes = request.getParameter("notes");
	  msRowNum = request.getParameter("row");
    }
    catch(Exception e)
    {
       msNotes = "0"; 
	   msRowNum = "0";
    }
		msStoreId = getStore();
		msCurrentDateTime = getCurrentDateTime();
		if(msStoreId != null && (msStoreId.length() > 0)){
			msTankCapacity = getTankCapacity(msStoreId);
			msRequiredPer = getRequiredPercentage(msStoreId);
			float lnRequired = (Float.parseFloat(msRequiredPer)/100) * Integer.parseInt(msTankCapacity);
			msRequiredLit = Integer.toString((int)lnRequired);
			msMargin = getMargin(msStoreId);
		}else{
			System.out.println("No se puede obtener store_Id");
		}

%>
<html>
<head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridReportPrinterYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="../Scripts/GasLibYum.js"></script>
		<script src="/Scripts/ReportUtilsYum.js"></script>

<!-- Script para mostrar dialogo de impresion -->

<script>

	function printWindow(){
		bV = parseInt(navigator.appVersion)
		if (bV >= 4) window.print()
	}

</script>

    <link rel='stylesheet' type='text/css' href='/CSS/GeneralStandardsYum.css'>
    <script language="javascript">

    var gaDataset = new Array();
	var giAcceptedLit = 0;
	var gsTableValues;
	var giDifference;

    function Minimize()
    {
        parent.resizeTo(250,20);
        parent.moveTo(screen.width, screen.height);
    }
	function printRequest(){
		var result=	confirm("Oprima OK para enviar a impresión (Favor de imprimir dos copias)");
		if(result){
			printWindow();
		}
	}
	function onClose(){
		if(giAcceptedLit == 0){
			alert("Es necesario llenar detalle de captura de gas");
	//		window.opener.parent.openDialog("InvoiceGasCapture.jsp?notes=hola&row=window.opener.parent.giLastInserted",400,350);
//			top.opener.parent.openDialog("InvoiceGasCapture.jsp?notes=hola&row=<%=msRowNum%>",400,350);
			window.opener.loadGasPopup();
		}
	}
	function onAccept()
	{
		if ( document.getElementById('loadedLitersbySupp').value == '' ) {
		        alert("Favor de Ingresar los litros que se cargaron de acuerdo a la nota del gasero");
			document.getElementById('loadedLitersbySupp').value = '';
			setTimeout("document.frmGasCapture.loadedLitersbySupp.focus();",400);
			return;    
		}
		if(giAcceptedLit > 0){
			if(giDifference > 2){
				alert('Existe diferencia mayor al 2% por lo que solo se autoriza el pago de ' + giAcceptedLit + ' litros reales cargados');
			}
			printRequest();
			//Actualiza el campo de descripcion en la ventana madre
			window.close();
			var lsFieldName = 'comment|'+<%= msRowNum %>;
			top.opener.document.getElementById(lsFieldName).value=Math.round(giAcceptedLit);
			top.opener.document.getElementById(lsFieldName).disabled=true;
			var lsExtraGas = 'gas_extra_data|'+<%= msRowNum %>;
			top.opener.document.getElementById(lsExtraGas).value= document.getElementById('beginPer').value + '|' + document.getElementById('requiredPer').value + '|' + document.getElementById('finalPer').value + '|' + document.getElementById('differencePer').value + '|' + document.getElementById('beginLit').value + '|' +  document.getElementById('requiredLit').value + '|' + document.getElementById('finalLit').value + '|' +  document.getElementById('differenceLit').value + '|' +  document.getElementById('toloadPer').value + '|' +  document.getElementById('loadedPer').value + '|' +  document.getElementById('acceptedPer').value + '|' +  document.getElementById('toloadLit').value + '|' +  document.getElementById('loadedLit').value + '|' +  document.getElementById('acceptedLit').value + '|' + document.getElementById('loadedLitersbySupp').value + '|';
			//alert("Valor gas_extra_data: "+lsExtraGas);
		}else{
			alert('Por favor ingrese porcentaje inicial y final');
		}
	}
		function clearFields(){
			document.getElementById('beginLit').value=0;
			document.getElementById('finalLit').value=0;
			document.getElementById('loadedLitersbySupp').value=0;
		}
		function onBlurControl(poControl, event){
			  var lsElement = poControl.name;
    		  var lsRowName = lsElement;
			  var liTankCapacity = <%= msTankCapacity %>;
			  var liMargin = <%= msMargin %>;

			  if(lsRowName == 'beginPer'){

					if(_getBeginPer() < 0 || _getBeginPer() > _getRequiredPer())
					{
						gbValidEntry = false;
						alert('Verificar el valor inicial. (Rango: de 0 a Requerido)');
						document.getElementById(poControl.id).value = '';
					    setTimeout("document.frmGasCapture.beginPer.focus();",400);
						return;
					}else{
						//Calcula el valor inicial en litros
						var beginLit = (_getBeginPer()/100) * liTankCapacity;
						document.getElementById('beginLit').value = Math.round(beginLit);
						var toLoadPer = _getRequiredPer() - _getBeginPer();
						var toLoadLit = _getRequiredLit(1) - _getBeginLit();
						document.getElementById('toloadPer').value = toLoadPer;
						document.getElementById('toloadLit').value = Math.round(toLoadLit);
						document.getElementById('finalPer').focus();
					}
			  }
			   if(lsRowName == 'finalPer'){
				   var finalPer = _getFinalPer();
				   var beginPer = _getBeginPer();
					if(finalPer > _getRequiredPer())
					{
						gbValidEntry = false;
						alert('El valor final no puede ser mayor al requerido.');
						document.getElementById(poControl.id).value = '';
					    setTimeout("document.frmGasCapture.finalPer.focus();",400);
						return;
					}
					if(finalPer < _getBeginPer())
					{
						gbValidEntry = false;
						alert('El valor final no puede ser menor al inicial.');
						document.getElementById(poControl.id).value = '';
					    setTimeout("document.frmGasCapture.finalPer.focus();",400);
						return;
					}
					if(finalPer < 0)
					{
						gbValidEntry = false;
						alert('No puede poner valores negativos.');
						document.getElementById(poControl.id).value = 0;
						return;
					}
					var finalLit = (finalPer/100) * liTankCapacity;
					document.getElementById('finalLit').value = Math.round(finalLit);
					var difference = finalPer - _getRequiredPer();
					document.getElementById('differencePer').value = difference;
					var differenceLit = (difference/100) * liTankCapacity;
					document.getElementById('differenceLit').value = Math.round(differenceLit);
					document.getElementById('loadedPer').value = finalPer - beginPer;
					document.getElementById('loadedLit').value = Math.round(finalLit - _getBeginLit());
					var loadedPer = document.getElementById('loadedPer').value;
					var acceptedPer;
					//si cargado = cargar no se suma 2%
					if(_getToLoadPer() == loadedPer){
						acceptedPer = Number(loadedPer);
					}else{
						acceptedPer = Number(loadedPer) + Number(liMargin);
					}
					document.getElementById('acceptedPer').value = acceptedPer;
					//var acceptedLit = (acceptedPer/100) * liTankCapacity;
					//giAcceptedLit = acceptedLit;
					//document.getElementById('acceptedLit').value = Math.round(acceptedLit);
					//giDifference = Math.abs(difference);
			   }
			   if(lsRowName == 'loadedLitersbySupp') {
			   	var loadedLitersNote = _getloadedLitersNote();
				var loadedLits = document.getElementById('loadedLit').value;
			   	var acceptedLitPer =  Math.round (( ( loadedLitersNote - loadedLits ) / loadedLits ) * 100);
				giDifference = Math.abs(acceptedLitPer);
				
				var acceptedLit = Math.round( loadedLits * 1.02 );
				giAcceptedLit = acceptedLit;
				document.getElementById('acceptedLit').value = acceptedLit;
			   }

		}
	
    </script>
</head>
<!--<body onLoad="initDataGrid(true);">-->
<body onload="javascript:document.getElementById('beginPer').focus();document.getElementById('beginPer').select()" onUnload="clearFields()">
    <p class="mainsubtitle">
        Detalle de carga de gas. 
    </p>

	<font class = 'descriptionTabla'>Fecha: &nbsp;<b><%= msCurrentDateTime %></b></font>
	&nbsp;&nbsp;&nbsp;&nbsp;	
	<a href='javascript: printWindow()'><img src='/Images/Menu/print_button.gif' border='0' align='middle'></a> <b class='descriptionTabla'>Imprimir</b> &nbsp;

	<p align="center" class="subHeadB">
        Favor de ingresar los porcentajes  de carga.
    </p>
	    <p align="center" class="subHeadC">
			Capacidad del tanque: <%= msTankCapacity %> &nbsp; litros
		</p>
	
    <form name='frmGasCapture' id= 'frmGasCapture'>
			<table id = 'tblMdx' name = 'tblMdx' border = '0'>
			<!-- Encabezado -->
			<tr bgcolor = 'white'  ><th bgcolor = 'white' colspan = '1'><font class = 'descriptionTabla'>&nbsp;</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Inicial</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Requerido</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Final</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Diferencia</font></th></tr>
			<!-- Primera fila porcentajes -->
			<tr id = 'tblRow|0' width = '40%' bgcolor = '#E6E6FA'>
					<td  align = 'center'><input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly     size='9' maxlength = '8'  type='text' value='%' disabled="true"  >
					</td> 

					<td  bgcolor = '#66CCFF'  align = 'center'>
						<input class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; background-color: #66CCFF;'     OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='beginPer' name='beginPer' value='0' onkeypress="return isNumberKey(event)" onChange="javascript:document.getElementById('finalPer').focus();document.getElementById('finalPer').select()"  >
					</td> 

					<td  align = 'center'>
						<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='requiredPer' name='requiredPer' value=<%=msRequiredPer%>  >
					</td> 

					<td  bgcolor = '#66CCFF'  align = 'center'>
						<input class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; background-color: #66CCFF;'     OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='finalPer' name='finalPer' value='0' onkeypress="return isNumberKey(event)" onChange="javascript:document.getElementById('btnAceptar').focus();document.getElementById('btnAceptar').select()" >
					</td> 

					<td  align = 'center'><input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='differencePer' name='differencePer' value='0'  >
					</td> 
			</tr>
			<!-- segunda Fila litros -->

					<tr id = 'tblRow|1' width = '40%' bgcolor = '#E6E6FA'>
						<td  align = 'center'><input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'		readonly     size='9' maxlength = '8'  type='text' value='litros'  >
						</td> 
						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='beginLit' name='beginLit' value='0' >
						</td> 

						<td align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='requiredLit' name='requiredLit' value=<%=msRequiredLit%>  >
						</td> 

						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'  readonly   OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='finalLit' name='finalLit' value='0'>
						</td> 

						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='differenceLit' name='differenceLit' value='0'  >
						</td> 
					</tr>
			</table>
			<br>
			<!-- Segunda tabla -->
			<table id = 'tblMdx2' name = 'tblMdx2' border = '0'>
				<tr bgcolor = 'white'  ><th bgcolor = 'white' colspan = '1'><font class = 'descriptionTabla'>&nbsp;</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Cargar</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Cargado</font></th><th bgcolor = 'gainsboro' colspan = '1'><font class = 'descriptionTabla'>Aceptado</font></th>
				</tr>
				<!-- Primera fila porciento -->
				<tr id = 'tbl2Row|0' width = '40%' bgcolor = '#E6E6FA'>
					<td  align = 'center'><input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly     size='9' maxlength = '8'  type='text' value='%' disabled="true"  >
					</td> 
					<td  align = 'center'>
						<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='toloadPer' name='toloadPer' value="0"  >
					</td> 
					<td  align = 'center'>
						<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='loadedPer' name='loadedPer' value="0"  >
					</td> 
					<td  align = 'center'>
						<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='acceptedPer' name='acceptedPer' value="0"  >
					</td> 
				</tr>
				<!-- Segunda fila litros -->
					<tr id = 'tbl2Row|1' width = '40%' bgcolor = '#E6E6FA'>
						<td  align = 'center'><input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly     size='9' maxlength = '8'  type='text' value='litros' disabled="true"  >
						</td> 
						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='toloadLit' name='toloadLit' value="0"  >
						</td> 
						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='loadedLit' name='loadedLit' value="0"  >
						</td> 
						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly  OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='acceptedLit' name='acceptedLit' value="0"  >
						</td> 
					</tr>
			</table>
			<!-- Tabla para ingresar los litros llenados segun la gasera -->
			<table id = 'tblMdx3' name = 'tblMdx3' border = '0'>
					<tr id = 'tbl3Row|0' width = '40%' bgcolor = '#E6E6FA'>
						<td  align = 'center'><input class='subHeadC' style='border: solid rgb(0,0,0) 0px; background-color: #E6E6FA;'   readonly     size='38' maxlength = '50'  type='text' value='Litros cargados reportados por gasera' disabled="true"  >
						</td>
						<td  align = 'center'>
							<input class='ctrlDisabled' style='border: solid rgb(0,0,0) 0px; background-color: #66CCFF;'     OnBlur = "onBlurControl(this,false);"   size='9' maxlength = '8'  type='text' id='loadedLitersbySupp' name='loadedLitersbySupp' value='' onkeypress="return isNumberKey(event)" >
						</td>
					</tr>
			</table>
        <p align="center">
            <br>
            <input type="button" id="btnAceptar" name="btnAceptar" value="Aceptar" onClick="onAccept()">
        </p>
    </form>
</body>
</html>
<%!

   String getMainQuery(String psStoreId)
    {
        String lsQuery = "SELECT 0 as begin,required,0 as final,0 as difference FROM op_gsv_gas" +
			" WHERE store_id=" + psStoreId;        
         return(lsQuery);
    }

	String getTankCapacity(String psStoreId){
		String lsQuery = "SELECT capacity from op_gsv_gas WHERE " +
			"store_id=" + psStoreId;
		return moAbcUtils.queryToString(lsQuery);
	}
	String getRequiredPercentage(String psStoreId){
		String lsQuery = "SELECT required from op_gsv_gas WHERE " +
			"store_id=" + psStoreId;
		return moAbcUtils.queryToString(lsQuery);
	}
	String getMargin(String psStoreId){
		String lsQuery = "SELECT margin from op_gsv_gas WHERE " +
			"store_id=" + psStoreId;
		return moAbcUtils.queryToString(lsQuery);
	}
	String getCurrentDateTime(){
		String lsQuery = "select to_char(now(),'yyyy-mm-dd HH24:MI:SS')";
		return moAbcUtils.queryToString(lsQuery);
	}
%>
