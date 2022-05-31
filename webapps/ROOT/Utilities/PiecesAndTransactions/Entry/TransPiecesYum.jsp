
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransPiecesYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sergio Cuellar Valdes
# Objetivo        : Contenedor principal de la pantalla de captura de PiezasxTransaccion
# Fecha Creacion  : 29/Mayo/2008
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/TransPiecesLibYum.jsp" %>  

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
%>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Captura de Piezas/Transac.";
%>

<html>
    <head>
        <title>Captura de Piezas/Transac.</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
        <link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
	<link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
	<div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/Chars.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
	<script src="/Scripts/CalendarYum.js"></script>
	<script src="/Scripts/DataGridClassYum.js"></script>
        <script>

            var gaKeys = new Array('');
	    function validateSearch() {
	        return(true);
	    }

            function format_date(thedate) {
	        if(thedate == "") {
		   alert("Seleccione una fecha.");
		   return false;
		}
	        var day_month_year = thedate.split("/");
		var year = day_month_year[2].substring(2);
	        return year + "-" + day_month_year[1]+"-"+day_month_year[0];
	    }
	

            function submitForm() {
                if (document.frmMaster.txtDate.value == '') {
                    alert('Por favor introduzca una fecha');
                    document.frmMaster.txtDate.focus();
                    return(false);
                }
                document.frmMaster.submit();
            }
	</script>

    </head>
    <body bgcolor="white">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <form id="frmMaster" name="frmMaster" method="get" target="_self" action="TransPiecesFrm.jsp">
      <table  align="center" border="0" cellpadding="2" cellspacing="2">
        <tbody>
          <tr class="bsDg_tr_row_zebra_0">
            <td ><font color="#000000"><b class="datagrid-leyend">ELIJA LA FECHA:</b></font></td>
            <td colspan="2" ><input maxlength="10" size="11" name="txtDate" id="txtDate" onfocus="showCalendar('frmMaster','txtDate','txtDate');" readonly></td>
          </tr>
          <tr>
            <td colspan="3" align="right" ><input type='button' name="btnBuscar" value='Buscar' onclick='submitForm();'/></td>
          </tr>
	  <tr class="bsDg_tr_row_zebra_1">
            <td ><b class="datagrid-leyend"> </b></td>
            <td ><b class="datagrid-leyend">SISTEMA </b></td>
            <td ><b class="datagrid-leyend">GERENTE </b></td>
          </tr>
          <tr class="bsDg_tr_row_zebra_0">
            <td ><b class="datagrid-leyend">TRANSACCIONES:</b></td>
            <td ><input readonly="readonly" maxlength="5" size="5" name="txtTrxS" id="txtTrxS"></td>
	    <td ><input readonly="readonly" maxlength="5" size="5" name="txtTrxG" id="txtTrxG"></td>
	  </tr>
          <tr class="bsDg_tr_row_zebra_1">
            <td ><b class="datagrid-leyend">PZA/TRAN:</b></td>
            <td ><input readonly="readonly" maxlength="5" size="5" name="txtSystem" id="txtSystem"></td>
	    <td ><input readonly="readonly" maxlength="5" size="5" name="txtGerente" id="txtGerente"></td>
          </tr>
          <tr class="bsDg_tr_row_zebra_0">
            <td ><b class="datagrid-leyend">%TRX AUTOEXPRESS:</b></td>
            <td ><input readonly="readonly" maxlength="3" size="5" name="txtMixAutoS" id="txtMixAutoS"></td>
            <td ><input readonly="readonly" maxlength="3" size="5" name="txtMixAutoG" id="txtMixAutoG"></td>
          </tr>
          <tr class="bsDg_tr_row_zebra_1">
            <td ><b class="datagrid-leyend">%TRX DOMICILIO:</b></td>
            <td ><input readonly="readonly" maxlength="3" size="5" name="txtMixHdS" id="txtMixHdS"></td>
            <td ><input readonly="readonly" maxlength="3" size="5" name="txtMixHdG" id="txtMixHdG"></td>
          </tr>
        </tbody>
      </table>
   <center>
   <table align="center" border="0" cellpadding="2" cellspacing="2">
   <tbody>
    <tr class="bsTotals">
      <td>Instrucciones:</td>
    </tr>  
    <tr class="bsTotals">
      <td>1. Elja la Fecha a la cual desea modificar el valor de pieza por Transacciones y % de Transacciones(AUTOEXPRESS,DOMICILIO).</td>
    </tr>  
    <tr class="bsTotals">
      <td>2. Presione el bot&oacute;n de Buscar para encontrar los valores actuales de las piezas por transacci&oacute;n y % de Transacciones.</td>
    </tr>  
    <tr class="bsTotals">
      <td>3. Ingresar los valores deseados en los campos de la columna GERENTE, s&oacute;lo se aceptan valores num&eacute;ricos.</td>
    </tr>  
    <tr class="bsTotals">
      <td style="color:#FF0000">** Para modificar las Transacciones de GERENTE se debe realizar por medio de FMS ** </td>
    </tr>
    <tr class="bsTotals">
      <td>4. Presionar el bot&oacute;n de Guardar para finalizar.</td>
    </tr>  
  </tbody>
</table>
</center>
    </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
</html>
