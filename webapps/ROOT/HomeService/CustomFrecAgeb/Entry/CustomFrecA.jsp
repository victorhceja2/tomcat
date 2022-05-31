<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CustomFrec.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Reporte Clientes Frecuentes
# Fecha Creacion  : 18/Marzo/2008
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="../Proc/CustomLibFrecAC.jsp" %>   

<%! 
    AbcUtils moAbcUtils; 
%> 

<%
    moAbcUtils = new AbcUtils();
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Reporte Clientes que han llamado por AGEB";
%>

<html>
	<head>
    	<title>Reporte Clintes que han llamado</title>
		
		<link rel="stylesheet" href="/CSS/GeneralStandardsYum.css" type="text/css">
		<link rel="stylesheet" href="/CSS/TabStandardsYum.css" type="text/css">
		<link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css">
		<link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
		
		<div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>
		
		<div id="divWaitGSO" style="width: 300px; height: 150px" class="wait-gso">
        	<br>Cargando informaci&oacute;n Clientes.
            <br><br>Espere por favor...<br><br>
		</div>

		<script src="/Scripts/AbcUtilsYum.js"></script>
		<script src="/Scripts/HtmlUtilsYum.js"></script>
	    <script src="/Scripts/CalendarYum.js"></script>	
    	<script>
        	var gaKeys = new Array('');
        	var gsFamilyId = '';
        	var msLastTab = '1';
    
        	function loadFirstTab() {
				document.frmMaster.btnBuscar.enable = true;
            	validOption('1');
    		}

        	function validOption(psTab){
            	switch (psTab){
                    case '1':     
                        browseDetail('CustomDetailFrecAC.jsp?hidFrecu=0','CustomFrecA.jsp','1');
                    break;
                    case '2':    
                    break;
            	}
            	msLastTab = psTab;
    		}

        	function validateSearch() {
           		return(true);
        	}

			function limpiar(){
				document.frmMaster.txtDate.value = "";
				document.frmMaster.txtDateH.value = "";
				document.frmMaster.cmbFrecuency.value = ">0";
				document.frmMaster.cmbAgeb.value = "0";
			}

			function valFec(F1, F2){
				var diai = F1.substring(0,2);
				var mesi = F1.substring(3,5);
			    var anoi = F1.substring(6,10);
				var diaf = F2.substring(0,2);
				var mesf = F2.substring(3,5);
				var anof = F2.substring(6,10);
				if(anof < anoi){
					alert("Rango incorrecto, favor de corregir.");
					return false;
				}
				else{
					if((mesf < mesi) && (anof == anoi)){
						alert("Rango incorrecto, favor de corregir.");
						return false;
					}
					else{
						if((diaf < diai) && (mesf == mesi)){
							alert("Rango incorrecto, favor de corregir.");
							return false;
						}
					}
				}
				return true;
			}

        	function changeCategory(){
            	var index    = document.frmMaster.cmbFrecuency.selectedIndex;
            	var frecuencyId = document.frmMaster.cmbFrecuency.options[index].value;
				var date = document.frmMaster.txtDate.value;
				var dateH = document.frmMaster.txtDateH.value;
				var ageb = document.frmMaster.cmbAgeb.value;

				if(date == "" || dateH == ""){
					alert("Seleccione un rango de busqueda.");
					return false;
				}
				if(valFec(date, dateH)){
					showProducts(frecuencyId, date, dateH, ageb);
				}
        	}

        	function showProducts(frecuencyId, date, dateH, ageb){
				if(frecuencyId != "0")
            		showWaitMessage();
            	browseDetail('CustomDetailFrecAC.jsp?hidFrecu=' + frecuencyId + '&hidDate=' + date + '&hidDateH=' + dateH + '&hidAgeb=' + ageb,'CustomFrecA.jsp','1');
        	}

        	//showWaitMessage();
        </script>
    </head>

    <body bgcolor="white" OnLoad="loadFirstTab();">
    	<jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
    	<form id="frmMaster" name="frmMaster" method="post" action="CustomDetailFrecAC.jsp" target="ifrDetail">
    		<input type='hidden' name='hidOperation' id='hidOperation' value='S'>
        	<table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
            	<tr>
               		<td class="body" width="10%">Desde:</td>
					<td width="10%">
						<input class = 'combos' type='text' id = 'txtDate' name='txtDate' size = '11' maxlength = '10' onclick="showCalendar('frmMaster','txtDate','txtDate');" onfocus="showCalendar('frmMaster','txtDate','txtDate');" readonly>
					</td>
					<td class="body" width="10%">Hasta:</td>
					<td width="10%">
						<input class = 'combos' type='text' id = 'txtDateH' name='txtDateH' size = '11' maxlength = '10' onclick="showCalendar('frmMaster','txtDateH','txtDateH');" onfocus="showCalendar('frmMaster','txtDateH','txtDateH');" readonly>
					</td>
					<td class="body" width="10%">Frecuencia: </td>
					<td width="10%">
						<select id="cmbFrecuency" name="cmbFrecuency" size="1" class="combos">
							<option value=">0">-- SELECCIONE --</option>
							<option value="<2">Primera Compra</option>
							<option value=">1">> 1</option>
							<option value="=2">= 2</option>
							<option value=">2">> 2</option>
							<option value="=3">= 3</option>
							<option value=">3">> 3</option>
							<option value="=4">= 4</option>
							<option value=">4">> 4</option>
							<option value="=5">= 5</option>
							<option value=">5">> 5</option>
						</select>
					</td>	
					<td class="body" width="10%">AGEB: </td>
					<td width="10%">
						<select id="cmbAgeb" name="cmbageb" size="1" class="combos">
							<option value="0"> -- SELECCIONE -- </option>
								<%
									moAbcUtils.fillComboBox(out,"select ageb_id, ageb_id from op_hh_ageb where ageb_id != '' order by ageb_id");
								%>
						</select>
					</td>
					<td class="body" width="10%">&nbsp</td>
					<td width="10%">&nbsp;</td>
				</tr>
				<tr>
					<td class="body" width="20%" align="right" colspan="10">
						<input type='button' name="btnBuscar" value='Buscar' onclick='changeCategory();'/>
						<input type='button' name="btnLimpiar" value='Limpiar' onclick='limpiar();'/>
					</td>
            	</tr>
        	</table>
    		<table border="0" cellspacing='0' cellpadding='0' width='100%' id='tblCourse'>
				<tr valign="top">
        			<td width="100%" height="100%">
         				<iframe class='tabContent' name='ifrDetail' width="100%" height="450" id='ifrDetail' frameBorder='0'>
						</iframe>
        			</td>
    			</tr>
    		</table>
    	</form>
	</body>
</html>
