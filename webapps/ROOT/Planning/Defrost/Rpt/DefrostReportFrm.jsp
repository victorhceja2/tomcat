<jsp:include page = '/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : DefrostReportFrm.jsp
# Compania        : PRB
# Autor           : Sergio Cuellar
# Objetivo        : Reporte de Plan de marinado y descongelado KFC
# Fecha Creacion  : 02/July/2013
# Modificaciones  : 11 oct 13 nuevas tiras isp
                    14 Feb 14, favoritas del coronel y coronel supreme
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ page import="java.text.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/DefrostLibYum.jsp" %>

<%!
AbcUtils moAbcUtils = new AbcUtils();
String msYear;
String msPeriod;
String msWeek;
String msTarget;
String msCSS;
String mixCruji;
String mixHCruji;
String mixSecreta;
String mstransCong;
String mspzasTrans;
String msBCToday;
String msBCTomorrow;
String msBCAfterTomorrow;
String msFCToday;
String msFCTomorrow;
String msFCAfterTomorrow;
String msCSToday;
String msCSTomorrow;
String msCSAfterTomorrow;
String msWingsToday;
String msWingsTomorrow;
String msWingsNext3Days;
String msTendersToday;
String msTendersTomorrow;
String msTendersNext3Days;
String msTotalBC;
String msTotalFC;
String msTotalCS;
String msTotalWings;
String msTotalTenders;
String msTotalCrujiTomorrow;
String msTotalSecretaTomorrow;
String msTotalHCTomorrow;
String msPorcCruji17;
String msPorcSecre17;
String msPorcHC17;
String msTodayHH;
String ms24HH;
String ms48HH;
String msCrujiTarde;
String msSecretaTarde;
String msHotTarde;
String msHotSTarde;
String msAlitasTarde;
String msTendersTarde;
float mfCabezas;
%>

<%
try
{
    msYear      = request.getParameter("year");
    msPeriod    = request.getParameter("period");
    msWeek      = request.getParameter("week");
    msTarget    = request.getParameter("hidTarget");
    mixCruji    = request.getParameter("mixCruji");
    mixSecreta  = request.getParameter("mixSecreta");
    mixHCruji   = request.getParameter("mixHCruji");
    mstransCong = request.getParameter("mstransCong");
    mspzasTrans = request.getParameter("mspzasTrans");
    msBCToday   = request.getParameter("msBCToday");
    msBCTomorrow       = request.getParameter("msBCTomorrow");
    msBCAfterTomorrow  = request.getParameter("msBCAfterTomorrow");
    msFCToday   = request.getParameter("msFCToday");
    msFCTomorrow       = request.getParameter("msFCTomorrow");
    msFCAfterTomorrow  = request.getParameter("msFCAfterTomorrow");
    msCSToday   = request.getParameter("msCSToday");
    msCSTomorrow       = request.getParameter("msCSTomorrow");
    msCSAfterTomorrow  = request.getParameter("msCSAfterTomorrow");
    msWingsToday     = request.getParameter("msWingsToday");
    msWingsTomorrow  = request.getParameter("msWingsTomorrow");
    msWingsNext3Days = request.getParameter("msWingsNext3Days");
    msTendersToday     = request.getParameter("msTendersToday");
    msTendersTomorrow  = request.getParameter("msTendersTomorrow");
    msTendersNext3Days = request.getParameter("msTendersNext3Days");
    msTotalBC    = request.getParameter("msTotalBC");
    msTotalFC    = request.getParameter("msTotalFC");
    msTotalCS    = request.getParameter("msTotalCS");
    msTotalWings = request.getParameter("msTotalWings");
    msTotalTenders = request.getParameter("msTotalTenders");
    msTotalCrujiTomorrow = request.getParameter("msTotalCrujiTomorrow");
    msTotalSecretaTomorrow = request.getParameter("msTotalSecretaTomorrow");
    msTotalHCTomorrow = request.getParameter("msTotalHCTomorrow");
    msPorcCruji17 = request.getParameter("msPorcCruji17");
    msPorcSecre17 = request.getParameter("msPorcSecre17");
    msPorcHC17    = request.getParameter("msPorcHC17");
    msTodayHH = request.getParameter("msTodayHH");
    ms24HH = request.getParameter("ms24HH");
    ms48HH = request.getParameter("ms48HH");
    msCrujiTarde = request.getParameter("msCrujiTarde");
    msSecretaTarde = request.getParameter("msSecretaTarde");
    msHotTarde = request.getParameter("msHotTarde");
    msHotSTarde = (request.getParameter("msHotSTarde").equals(""))?"0":request.getParameter("msHotSTarde");
    msAlitasTarde = request.getParameter("msAlitasTarde");
    msAlitasTarde = Round(msAlitasTarde.equals("")?"0":msAlitasTarde);
    msTendersTarde = request.getParameter("msTendersTarde");
    msTendersTarde = Round(msTendersTarde);
    mfCabezas = Float.parseFloat(mstransCong) * Float.parseFloat(mspzasTrans) / 9;

    msCrujiTarde = String.valueOf (Float.parseFloat(msCrujiTarde) * Float.parseFloat(msPorcCruji17)/100.0);
    msCrujiTarde = Round(msCrujiTarde);
    msSecretaTarde = String.valueOf (Float.parseFloat(msSecretaTarde) * Float.parseFloat(msPorcSecre17)/100.0);
    msSecretaTarde = Round(msSecretaTarde);
    msHotTarde = String.valueOf (Float.parseFloat(msHotTarde) * Float.parseFloat(msPorcHC17)/100.0);
    msHotTarde = Round(msHotTarde);
    msHotSTarde = String.valueOf (Float.parseFloat(msHotSTarde)/2);

}
catch(Exception e)
{
    msYear   = "0";
    msPeriod = "0";
    msWeek   = "0";
}

if(msTarget.equals("Printer"))
{
    msCSS = "../CSS/DataGridReportPrinterYum.css";
}
else
{
    msCSS = "/CSS/DataGridDefaultYum.css";
}
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css" />
        <link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridReportPreviewYum.css"/>
        
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="../Scripts/DefrostReport.js"></script>
        <script>
            var reportOk = true;
            function submitFrame(frameName)
            {
                document.mainform.target = frameName;

                if(frameName=='preview')
                document.mainform.hidTarget.value = "Preview";

                if(frameName=='printer')
                document.mainform.hidTarget.value = "Printer";

                document.mainform.submit();
            }
            function submitFrames()
            {
                setTimeout("submitFrame('printer')", 1000);
                //Despues de 2 seg se carga el segundo frame
                setTimeout("submitFrame('preview')", 3000);
            }
	    function executeReportCustom()
	    {
		window.focus(); window.print();
	    }
            function doAction()
            {

                if(reportOk == true)
                {
                    submitFrames();
                }
                else
                {
                    document.mainform.action = '/MessageYum.jsp';
                    addHidden(document.mainform, 'hidTitle', 'Plan Marinado/Descongelado');
                    addHidden(document.mainform, 'hidSplit', 'true');
                    submitFrame('preview');
                }
            }
        </script>
    </head>

    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" onLoad="doAction()">

        <jsp:include page="/Include/GenerateHeaderYum.jsp">
            <jsp:param name="psStoreName" value="true" />
        </jsp:include>

        <table width="60%" border="0" align="left" cellspacing="6">
            <tr >
                <td>
                    <b class="datagrid-leyend">
                        A&ntilde;o:<%= msYear %>, Periodo:<%= msPeriod %>, Semana:<%= msWeek %>
                    </b>
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" value="Calcular" onclick="magia()" />
                </td>
		<td>
		    <a href="javascript:executeReportCustom();"><img src="/Images/Menu/print_button.gif" border="0">
		</td>
            </tr>
	    <tr>
		<td>
		    <a href="javascript:executeReportCustom();"><img src="/Images/Menu/print_button.gif" border="0">
		</td>
	    </tr>
            <tr>
                <td>
                    <div id="goDataGrid"></div>
    <table align="center" border="0" width="60%">
      <tbody>
        <tr>
          <td align="center" valign="top">
            
            
            
            
            <table border="0" width="30%">
              <tbody>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Trans.
                      Congeladas</b>
                  </td>
                  <td valign="top"><%= mstransCong%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Piezas por
                      tran.</b>
                  </td>
                  <td valign="top"><%= mspzasTrans%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Cabezas</b>
                  </td>
                  <td valign="top"><%= mfCabezas%>
                  </td>
                </tr>
              </tbody>
            </table>
            
            
            <table border="0">
              <tbody>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="left" valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Secreta</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Cruji</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">3aReceta</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Mix</b>
                  </td>
                  <td valign="top"><%= mixSecreta %>
                  </td>
                  <td valign="top"><%= mixCruji %>
                  </td>
                  <td valign="top"><%= mixHCruji %>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Index</b>
                  </td>
                  <td valign="top"><%=msPorcSecre17%>
                  </td>
                  <td valign="top"><%=msPorcCruji17%>
                  </td>
                  <td valign="top"><%=msPorcHC17%>
                  </td>
                </tr>
              </tbody>
            </table>
            
            <table border="0">
              <tbody>
                <tr class="bsDg_tr_row_zebra_0" align="center">
                  <td colspan="4" rowspan="1" valign="top"><b
                      class="datagrid-leyend">Productividad</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td colspan="4" rowspan="1" valign="top"><b
                      class="datagrid-leyend">Harinas</b></td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Secreta</b>
                  </td>
                  <td align="center" valign="top"><b
                      class="datagrid-leyend">Cruji</b>
                  </td>
                  <td align="center" valign="top"><b
                      class="datagrid-leyend">3a</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top" id="harina_secreta">
                  </td>
                  <td valign="top" id="harina_cruji">
                  </td>
                  <td valign="top" id="harina_hot">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Marinado</b>
                  </td>
                  <td align="center" valign="top"><b
                      class="datagrid-leyend">Mallas</b>
                  </td>
                  <td align="center" valign="top"><b
                      class="datagrid-leyend">Horas</b>
                  </td>
                  <td align="center" valign="top"><b
                      class="datagrid-leyend">Tiempo</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Secreta</b>
                  </td>
                  <td valign="top" id="mallas_secreta">
                  </td>
                  <td valign="top" id="horas_secreta">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Cruji</b>
                  </td>
                  <td valign="top" id="mallas_cruji">
                  </td>
                  <td valign="top" id="horas_cruji">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">3a</b>
                  </td>
                  <td valign="top" id="mallas_hot">
                  </td>
                  <td valign="top" id="horas_hot">
                  </td>
                  <td valign="top" id="tiempo_marinado">
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr>
        <tr class="bsDg_tr_row_zebra_0">
          <td valign="top" width="400">
            <table align="center" border="0" width="400">
              <tbody>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="center" valign="top" width="40%"><b
                      class="datagrid-leyend">Concepto</b>
                  </td>
                  <td align="center" valign="top" width="30%"><b
                      class="datagrid-leyend">Comentarios</b>
                  </td>
                  <td align="center" valign="top" width="10%"><b
                      class="datagrid-leyend">Secreta (cbzs.)</b></td>
                  <td align="center" valign="top" width="10%"><b
                      class="datagrid-leyend">Cruji (cbzs.)</b></td>
                  <td align="center" valign="top" width="10%"><b
                      class="datagrid-leyend">3aReceta (cbzs.)</b></td>
                  <td align="center" valign="top" width="10%"><b
                      class="datagrid-leyend">Tiras  (piezas)</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Cabezas
                      Pron&oacute;stico sig. d&iacute;a</b>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
		     <textarea class="descriptionTabla"
		       onkeydown="handleKeyEvents(event, this)"
		       onfocus="onFocusControl(this)"
		       onblur="onBlurControl(this, true)"
		       style="border: solid
		       rgb(0,0,0) 0px; font-size:11px; background-color:
		       transparent;"  rows="3" cols="30"> </textarea> </td>
                  <td valign="top" id="cabezas_secreta_tomorrow"><%=msTotalSecretaTomorrow%>
                  </td>
                  <td valign="top" id="cabezas_cruji_tomorrow"><%=msTotalCrujiTomorrow%>
                  </td>
                  <td valign="top" id="cabezas_hot_tomorrow"><%=msTotalHCTomorrow%>
                  </td>
                  <td valign="top" id="tenders_piezas_tomorrow"><%=msTendersTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Inventario
                      marinado a las 17:00 hrs</b>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
		     <textarea class="descriptionTabla"
		       onkeydown="handleKeyEvents(event, this)"
		       onfocus="onFocusControl(this)"
		       onblur="onBlurControl(this, true)"
		       style="border: solid
		       rgb(0,0,0) 0px; font-size:11px; background-color:
		       transparent;" rows="3" cols="30"> </textarea> </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="secreta_inv" id="secreta_inv" maxlength="3" size="25"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="cruji_inv" id="cruji_inv" maxlength="3" size="25"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="hotcruji_inv" id="hotcruji_inv" maxlength="3"
                      size="25" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="tenders_inv" id="tenders_inv" maxlength="3" size="25"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Producto
                      por vender en la tarde</b>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
		     <textarea class="descriptionTabla"
		       onkeydown="handleKeyEvents(event, this)"
		       onfocus="onFocusControl(this)"
		       onblur="onBlurControl(this, true)"
		       style="border: solid
		       rgb(0,0,0) 0px; font-size:11px; background-color:
		       transparent;" rows="3" cols="30"> </textarea> </td>
                  <td valign="top" id="secreta_tarde"><%=msSecretaTarde%>
                  </td>
                  <td valign="top" id="cruji_tarde"><%=msCrujiTarde%>
                  </td>
                  <td valign="top" id="hot_tarde"><%=msHotTarde%>
                  </td>
                  <td valign="top" id="tenders_tarde"><%=msTendersTarde%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Total a
                      marinar</b>
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top" id="marinar_tot_secreta">
                  </td>
                  <td valign="top" id="marinar_tot_cruji">
                  </td>
                  <td valign="top" id="marinar_tot_hot">
                  </td>
                  <td valign="top" id="marinar_tot_tenders">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pollo
                      entero</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">70% del
                      total a marinar</b>
                  </td>
                  <td valign="top" id="marinar_70_secreta">
                  </td>
                  <td valign="top" id="marinar_70_cruji">
                  </td>
                  <td valign="top" id="marinar_70_hot">
                  </td>
                  <td valign="top" id="marinar_70_tenders">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pierna y
                      muslo</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">30% del
                      total a marinar</b>
                  </td>
                  <td valign="top" id="marinar_30_secreta">
                  </td>
                  <td valign="top" id="marinar_30_cruji" >
                  </td>
                  <td valign="top" id="marinar_30_hot">
                  </td>
                  <td valign="top" id="marinar_30_tenders">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">EN MALLAS</b>
                  </td>
                  <td valign="top" id="total_mallas_secreta">
                  </td>
                  <td valign="top" id="total_mallas_cruji">
                  </td>
                  <td valign="top" id="total_mallas_hot">
                  </td>
                  <td valign="top" id="total_mallas_tenders">
                  </td>
                </tr>
              </tbody>
            </table>
            
          </td>
        </tr>
        <tr class="bsDg_tr_row_zebra_0">
          <td>
              <table>
                <tr>
                  <td class="datagrid-leyend">Aviso de Marinaci&oacute;n 3er receta</td>
                  <td class="datagrid-leyend"><b>Colocar aviso en las &uacute;ltimas(mallas)</td>
                </tr>
                <tr>
                  <td class="datagrid-leyend">Mallas de 3a receta de 3pm a 7pm (Siguiente d&iacute;a)</td>
                  <td class="datagrid-leyend" id="3rdRec37">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=msHotSTarde%></td>
                </tr>
              </table> 
          </td>
        </tr>
        <tr class="bsDg_tr_row_zebra_0">
          <td valign="top">
            <table align="left" border="0">
              <tbody>
                <tr align="center">
                  <td colspan="5" rowspan="1" valign="top"><b
                      class="datagrid-leyend">BigCrunch
                      Pron&oacute;stico</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pron&oacute;stico</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend"># de
                      filetes</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">BigCrunch
                      Hoy</b>
                  </td>
                  <td valign="top" id="bc_today"><%=msBCToday%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">BigCrunch
                      Ma&ntilde;ana</b>
                  </td>
                  <td valign="top" id="bc_tomorrow"><%=msBCTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">BigCrunch
                      Pasado Ma&ntilde;ana</b>
                  </td>
                  <td valign="top" id="bc_aftertomorrow"><%=msBCAfterTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="right" valign="top"><b
                      class="datagrid-leyend">TOTAL</b>
                  </td>
                  <td valign="top" id"=bc_total"><%=msTotalBC%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Descongelado</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Fecha y
                      hora</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Filete en
                      descongelaci&oacute;n</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Dif.</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Bolsas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes
                      descongelaci&oacute;n con &gt; 48 hrs</b>
                  </td>
                  <td valign="top"><%=ms48HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_bc_48" id="filetes_bc_48"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_48_bc">
                  </td>
                  <td valign="top" id="bolsas_48_bc">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes
                      descongelaci&oacute;n con &gt; 24 hrs</b>
                  </td>
                  <td valign="top"><%=ms24HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_bc_24" id="filetes_bc_24"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_24_bc">
                  </td>
                  <td valign="top" id="bolsas_24_bc">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes a
                      descongelar hoy (9 am)</b>
                  </td>
                  <td valign="top"><%=msTodayHH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_bc_hoy" id="filetes_bc_hoy"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_today_bc">
                  </td>
                  <td valign="top" id="bolsas_today_bc">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Total a
                      descongelar</b>
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top" id="total_des_bolsas_bc">
                  </td>
                </tr>
              </tbody>
            </table>
            
          </td>
        </tr>
        <tr class="bsDg_tr_row_zebra_0">
          <td valign="top">
            <table align="left" border="0">
              <tbody>
                <tr align="center">
                  <td colspan="5" rowspan="1" valign="top"><b
                      class="datagrid-leyend">Filete 55g
                      Pron&oacute;stico</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pron&oacute;stico</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend"># de
                      filetes</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filete 55g
                      Hoy</b>
                  </td>
                  <td valign="top" id="fc_today"><%=msFCToday%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filete 55g
                      Ma&ntilde;ana</b>
                  </td>
                  <td valign="top" id="fc_tomorrow"><%=msFCTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filete 55g
                      Pasado Ma&ntilde;ana</b>
                  </td>
                  <td valign="top" id="fc_aftertomorrow"><%=msFCAfterTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="right" valign="top"><b
                      class="datagrid-leyend">TOTAL</b>
                  </td>
                  <td valign="top" id"=fc_total"><%=msTotalFC%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Descongelado</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Fecha y
                      hora</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Filete en
                      descongelaci&oacute;n</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Dif.</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Bolsas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes
                      descongelaci&oacute;n con &gt; 48 hrs</b>
                  </td>
                  <td valign="top"><%=ms48HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_fc_48" id="filetes_fc_48"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_48_fc">
                  </td>
                  <td valign="top" id="bolsas_48_fc">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes
                      descongelaci&oacute;n con &gt; 24 hrs</b>
                  </td>
                  <td valign="top"><%=ms24HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_fc_24" id="filetes_fc_24"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_24_fc">
                  </td>
                  <td valign="top" id="bolsas_24_fc">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes a
                      descongelar hoy (9 am)</b>
                  </td>
                  <td valign="top"><%=msTodayHH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_fc_hoy" id="filetes_fc_hoy"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_today_fc">
                  </td>
                  <td valign="top" id="bolsas_today_fc">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Total a
                      descongelar</b>
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top" id="total_des_bolsas_fc">
                  </td>
                </tr>
              </tbody>
            </table>
            
          </td>
        </tr>
        <tr class="bsDg_tr_row_zebra_0">
          <td valign="top">
            <table align="left" border="0">
              <tbody>
                <tr align="center">
                  <td colspan="5" rowspan="1" valign="top"><b
                      class="datagrid-leyend">Coronel Supreme  
                      Pron&oacute;stico</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pron&oacute;stico</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend"># de
                      filetes</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Coronel Supreme  
                      Hoy</b>
                  </td>
                  <td valign="top" id="cs_today"><%=msCSToday%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Coronel Supreme  
                      Ma&ntilde;ana</b>
                  </td>
                  <td valign="top" id="cs_tomorrow"><%=msCSTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Coronel Supreme  
                      Pasado Ma&ntilde;ana</b>
                  </td>
                  <td valign="top" id="cs_aftertomorrow"><%=msCSAfterTomorrow%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="right" valign="top"><b
                      class="datagrid-leyend">TOTAL</b>
                  </td>
                  <td valign="top" id"=cs_total"><%=msTotalCS%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Descongelado</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Fecha y
                      hora</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Filete en
                      descongelaci&oacute;n</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Dif.</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Bolsas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes
                      descongelaci&oacute;n con &gt; 48 hrs</b>
                  </td>
                  <td valign="top"><%=ms48HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_cs_48" id="filetes_cs_48"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_48_cs">
                  </td>
                  <td valign="top" id="bolsas_48_cs">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes
                      descongelaci&oacute;n con &gt; 24 hrs</b>
                  </td>
                  <td valign="top"><%=ms24HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_cs_24" id="filetes_cs_24"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_24_cs">
                  </td>
                  <td valign="top" id="bolsas_24_cs">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Filetes a
                      descongelar hoy (9 am)</b>
                  </td>
                  <td valign="top"><%=msTodayHH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="filetes_cs_hoy" id="filetes_cs_hoy"
                      size="3" maxlength="3" autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="dif_today_cs">
                  </td>
                  <td valign="top" id="bolsas_today_cs">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Total a
                      descongelar</b>
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top">
                  </td>
                  <td valign="top" id="total_des_bolsas_cs">
                  </td>
                </tr>
              </tbody>
            </table>
            
          </td>
        </tr>
        <!--tr class="bsDg_tr_row_zebra_0">
          <td valign="top">
            <table align="left" border="0">
              <tbody>
                <tr align="center">
                  <td colspan="4" rowspan="1" valign="top"><b
                      class="datagrid-leyend">Alitas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pron&oacute;stico</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend"># de
                      alitas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Alitas
                      para hoy</b>
                  </td>
                  <td valign="top" id="alitas_today"><%=msWingsToday%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Alitas
                      prox. 3 d&iacute;as</b>
                  </td>
                  <td valign="top" id="alitas_3_days"><%=msWingsNext3Days%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="right" valign="top"><b
                      class="datagrid-leyend">TOTAL</b>
                  </td>
                  <td valign="top" id="total_alitas"><%=msTotalWings%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Descongelado</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Fecha y
                      hora</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Alitas en
                      descongelaci&oacute;n</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Bolsas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Alitas
                      descongelaci&oacute;n con &gt; 48 hrs</b>
                  </td>
                  <td valign="top"><%=ms48HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="descong_alitas_48"
                      id="descong_alitas_48" size="3" maxlength="3"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="bolsas_48_alitas">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Alitas
                      descongelaci&oacute;n con &gt; 24 hrs</b></td>
                  <td valign="top"><%=ms24HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="descong_alitas_24"
                      id="descong_alitas_24" size="3" maxlength="3"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="bolsas_24_alitas">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Alitas a
                      descongelar hoy (9 am)</b>
                  </td>
                  <td valign="top"><%=msTodayHH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="descong_alitas_hoy"
                      id="descong_alitas_hoy" size="3" maxlength="3"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="bolsas_today_alitas">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Total a
                      descongelar</b>
                  </td>
                  <td valign="top" id="total_descong_alitas">
                  </td>
                  <td valign="top" id="total_descong_bols_alitas">
                  </td>
                </tr>
              </tbody>
            </table>
          </td>
        </tr-->
        <tr class="bsDg_tr_row_zebra_0">
          <td valign="top">
            <table align="left" border="0">
              <tbody>
                <tr align="center">
                  <td colspan="4" rowspan="1" valign="top"><b
                      class="datagrid-leyend">Tiras</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Pron&oacute;stico</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend"># de
                      tiras</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Tiras 
                      para hoy</b>
                  </td>
                  <td valign="top" id="tenders_today"><%=msTendersToday%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Tiras 
                      prox. 3 d&iacute;as</b>
                  </td>
                  <td valign="top" id="tenders_3_days"><%=msTendersNext3Days%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td align="right" valign="top"><b
                      class="datagrid-leyend">TOTAL</b>
                  </td>
                  <td valign="top" id="total_tenders"><%=msTotalTenders%>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Descongelado</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Fecha y
                      hora</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Tiras  en
                      descongelaci&oacute;n</b>
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Bolsas</b>
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Tiras 
                      descongelaci&oacute;n con &gt; 48 hrs</b>
                  </td>
                  <td valign="top"><%=ms48HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="descong_tenders_48"
                      id="descong_tenders_48" size="3" maxlength="3"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="bolsas_48_tenders">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Tiras 
                      descongelaci&oacute;n con &gt; 24 hrs</b></td>
                  <td valign="top"><%=ms24HH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="descong_tenders_24"
                      id="descong_tenders_24" size="3" maxlength="3"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="bolsas_24_tenders">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top"><b class="datagrid-leyend">Tiras  a
                      descongelar hoy (9 am)</b>
                  </td>
                  <td valign="top"><%=msTodayHH%>
                  </td>
                  <td class="bsDg_td_row_zebra_0 bsDg_td_entry"
                    onmouseover="" onmouseout="" style="cursor:default;
                    " valign="top">
                    <input name="descong_tenders_hoy"
                      id="descong_tenders_hoy" size="3" maxlength="3"
                      autocomplete="off"
                      onkeydown="handleKeyEvents(event, this)"
                      onfocus="onFocusControl(this)"
                      onblur="onBlurControl(this, true)"
                      class="descriptionTabla" style="border: solid
                      rgb(0,0,0) 0px; font-size:11px; background-color:
                      transparent;" type="text"> </td>
                  <td valign="top" id="bolsas_today_tenders">
                  </td>
                </tr>
                <tr class="bsDg_tr_row_zebra_0">
                  <td valign="top">
                  </td>
                  <td valign="top"><b class="datagrid-leyend">Total a
                      descongelar</b>
                  </td>
                  <td valign="top" id="total_descong_tenders">
                  </td>
                  <td valign="top" id="total_descong_bols_tenders">
                  </td>
                </tr>
      </tbody>
    </table>

                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" value="Calcular" onclick="magia()" />
                </td>
            </tr>
        </table>

        <jsp:include page = '/Include/TerminatePageYum.jsp' />
    </body>
</html>
