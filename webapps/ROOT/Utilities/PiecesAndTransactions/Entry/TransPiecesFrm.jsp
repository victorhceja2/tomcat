
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransPiecesFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : Sergio Cuellar Valdes
# Objetivo        : Contenedor principal de la pantalla de captura de PiezasxTransaccion
# Fecha Creacion  : 29/Mayo/2008
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/TransPiecesLibYum.jsp" %>  

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
%>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Captura de Piezas/Transac.";
    ArrayList<String> tranXdest  = null;
    String msDateDMY       = null;
    String msDateYMD       = null;
    String msDateFMS       = null;
    String msDateQRY       = null;
    String msDay           = null;
    String msMonth         = null;
    String msYear          = null;
    String msYearL         = null;
    String msLd_pzaTrx     = null;
    String msLd_pzaGte     = null;
    String msFms_output    = null;
    String [] msTemp	   = null;
    String msToday_date    = null;
    String [] msLd_TrXdes  = null;
    float mixHomeS         = 0;
    float mixAutoS         = 0;
    float mixHomeG         = 0;
    float mixAutoG         = 0;
    float miTrans_Gte      = 0;
    float miTrans_Sys      = 0;
    float mixDineS         = 0;
    float mixCarryS        = 0;
    String dineIn          = "1";
    String delivery        = "2";
    String carryOut        = "3";
    String window          = "4";


    msDateDMY  = request.getParameter("txtDate");

    msDay      = msDateDMY.substring(0,2);
    msMonth    = msDateDMY.substring(3,5);
    msYear     = msDateDMY.substring(8,10);
    msYearL    = msDateDMY.substring(6,10);

    msDateYMD  = msYear + "-" + msMonth + "-" + msDay;
    msDateFMS  = msMonth + "/" + msDay + "/" + msYear;
    msDateQRY  = msYearL + "-" + msMonth + "-" + msDay;

    msToday_date = getDateTime( );

    msLd_pzaGte = executeCommand("/usr/bin/ph/txthistory/ppt-gerente.pl --fecha " + msDateYMD + " --nocache");
    msLd_pzaTrx = executeCommand("/usr/bin/ph/txthistory/ppt-pron.pl --fecha " + msDateYMD + " --calc --natural");
    //msLd_pzaTrx = executeCommand("/usr/bin/ph/txthistory/ppt-pron.pl --fecha " + msDateYMD + " ");
    tranXdest   = executeCommand("/usr/bin/ph/txthistory/trx-dest-pron.pl --fecha " + msDateYMD, 1);
    msFms_output  = executeCommand("/usr/bin/ph/txthistory/fms.pl " + msDateYMD);
	
    msLd_pzaGte = String.valueOf(round(Float.parseFloat(msLd_pzaGte), 2));
    msLd_pzaTrx = String.valueOf(round(Float.parseFloat(msLd_pzaTrx), 2));
    msTemp        = msFms_output.split(" ");
    miTrans_Gte   = Float.parseFloat(msTemp[1]);
    miTrans_Sys   = Float.parseFloat(msTemp[2]);

    for( String TrXdes: tranXdest){
	msLd_TrXdes=TrXdes.split("\\|");
        if(  msLd_TrXdes[0].equals("DOMICILIO") ){
                mixHomeS=Float.parseFloat(msLd_TrXdes[2]);
        }
        if ( msLd_TrXdes[0].equals("AUTOEXPRESS") ){
                mixAutoS=Float.parseFloat(msLd_TrXdes[2]);
        }
        if ( msLd_TrXdes[0].equals("COMEDOR") ){
                mixDineS=Float.parseFloat(msLd_TrXdes[2]);
        }
        if ( msLd_TrXdes[0].equals("LLEVAR") ){
                mixCarryS=Float.parseFloat(msLd_TrXdes[2]);
        }
        msLd_TrXdes=null;
    }

    String mixHG=getMiXdest(msDateQRY, delivery);
    String mixAG=getMiXdest(msDateQRY, window);
    if (mixHG.equals(""))
	mixHomeG=mixHomeS;
    else
	mixHomeG=Float.parseFloat(mixHG);
    if (mixAG.equals(""))
	mixAutoG=mixAutoS;
    else
	mixAutoG=Float.parseFloat(mixAG);
%>

<html>
    <head>
        <title>Captura de Piezas/Transac.</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/DataGridReportPreviewYum.css"/>
        <link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
	<div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/Chars.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
	<script src="/Scripts/CalendarYum.js"></script>
	<script src="/Scripts/DataGridClassYum.js"></script>
	<script src="../Scripts/PiecesAndTransactions.js"></script>
        <script>

            var gaKeys = new Array('');
	    function validateSearch() {
	        return(true);
	    }

	</script>

    </head>
    <body bgcolor="white">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <form id="frmMaster" name="frmMaster" method="get" >
    <INPUT TYPE=HIDDEN NAME="valorInicio" VALUE="<%=msLd_pzaTrx%>" >
    <INPUT TYPE=HIDDEN NAME="findValueGte" VALUE="no">
    <input type=hidden name="f_hoy" value="<%=msToday_date%>">
    <input type=hidden name="fecha_cal" value="<%=msDateYMD%>">
    <input type=hidden name="fecha_fms" value="<%=msDateFMS%>">
    <input type=hidden name="fecha_qry" value="<%=msDateQRY%>">
    <input type=hidden name="ppt_sis" value="<%=msLd_pzaTrx%>">
    <input type=hidden name="trans_gte" value="<%=miTrans_Gte%>">
    <input type=hidden name="ppt_gte_old" value="<%=msLd_pzaGte%>">
    <input type=hidden name="txtMixDnS" value="<%=mixDineS%>">
    <input type=hidden name="txtMixCoS" value="<%=mixCarryS%>">
    
<table
 align="center" border="0" cellpadding="2" cellspacing="2">
  <tbody>
    <tr class="bsDg_tr_row_zebra_0">
      <td ><font  color="#000000"><b class="datagrid-leyend">ELIJA LA FECHA:</b></font></td>
      <td colspan="2" ><input maxlength="10" size="11" name="txtDate" id="txtDate" onfocus="showCalendar('frmMaster','txtDate','txtDate')" onblur="cleanFields()" value="<%=msDateDMY%>" ></td>
    </tr>
    <tr>
      <td  colspan="3" align="right" ><input type='button' name="btnBuscar" value='Buscar' onclick='searchValue();'/></td>
    </tr>
    <tr class="bsDg_tr_row_zebra_1">
      <td ><b class="datagrid-leyend"> </b></td>
      <td ><b class="datagrid-leyend">SISTEMA </b></td>
      <td ><b class="datagrid-leyend">GERENTE </b></td>
    </tr>
    <tr class="bsDg_tr_row_zebra_0">
      <td ><b class="datagrid-leyend">TRANSACCIONES:</b></td>
      <td ><input readonly="readonly" maxlength="5" size="5" name="txtTrxS" id="txtTrxS" value="<%=miTrans_Sys%>"></td>
      <td ><input readonly="readonly" maxlength="5" size="5" name="txtTrxG" id="txtTrxG" value="<%=miTrans_Gte%>"></td>
    </tr>
    <tr class="bsDg_tr_row_zebra_1">
      <td ><b class="datagrid-leyend">PZA/TRAN:</b></td>
      <td ><input readonly="readonly" maxlength="5" size="5" name="txtSystem" id="txtSystem" value="<%=msLd_pzaTrx%>"></td>
      <td ><input style="background-color:#FBFECC" maxlength="5" size="5" name="txtGerente" id="txtGerente" value="<%=msLd_pzaGte%>"></td>
    </tr>
    <tr class="bsDg_tr_row_zebra_0">
      <td ><b class="datagrid-leyend">%TRX AUTOEXPRESS:</b></td>
      <td ><input readonly="readonly" maxlength="5" size="5" name="txtMixAutoS" id="txtMixAutoS" value="<%=mixAutoS%>"></td>
      <td ><input style="background-color:#FBFECC" maxlength="5" size="5" name="txtMixAutoG" id="txtMixAutoG" value="<%=mixAutoG%>"></td>
    </tr>
    <tr class="bsDg_tr_row_zebra_1">
      <td ><b class="datagrid-leyend">%TRX DOMICILIO:</b></td>
      <td ><input readonly="readonly" maxlength="5" size="5" name="txtMixHdS" id="txtMixHdS" value="<%=mixHomeS%>"></td>
      <td ><input style="background-color:#FBFECC" maxlength="5" size="5" name="txtMixHdG" id="txtMixHdG" value="<%=mixHomeG%>"></td>
    </tr>
    <tr>
      <td  colspan="3" align="right" ><input type='button' name="btnGuardar" value='Guardar' onclick='sendValue();'/></td>
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
      <td>1. Elija la Fecha a la cual desea modificar el valor de pieza por Transacciones y % de Transacciones(AUTOEXPRESS,DOMICILIO).</td>
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
