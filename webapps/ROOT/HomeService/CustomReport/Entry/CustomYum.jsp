<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CustomYum.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Reporte Clientes sin Recurrencias
# Fecha Creacion  : 14/Feb/2008
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="../Proc/CustomLibYum.jsp" %>   

<%! 
    AbcUtils moAbcUtils; 
%> 

<%
    moAbcUtils = new AbcUtils();
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Reporte Clientes que no han llamado";
%>

<html>
	<head>
    	<title>Reporte Clintes que no han llamado</title>
		
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
                        browseDetail('CustomDetailYum.jsp?hidFamily=0','CustomYum.jsp','1');
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
				document.frmMaster.cmbFamily.value = "0";
				document.frmMaster.cmbFrecuency.value = "> 0";
				document.frmMaster.txtDate.value = "";
				document.frmMaster.cmbBase.value = "ALL";
				document.frmMaster.cmbPackage.value = "ALL";
			}
			
        	function changeCategory(){
            	var index    = document.frmMaster.cmbFamily.selectedIndex;
            	var familyId = document.frmMaster.cmbFamily.options[index].value;
				var frecuencyId = document.frmMaster.cmbFrecuency.value;
				var date = document.frmMaster.txtDate.value;
				var base = document.frmMaster.cmbBase.value;
				var pack = document.frmMaster.cmbPackage.value;
			
				if(familyId == "0"){
					alert("Seleccione la Recurrencia.");
					return false;
				}
				showProducts(familyId, frecuencyId, date, base, pack);
        	}

        	function showProducts(familyId, frecuencyId, date, base, pack){
				if(familyId != "0")
            		showWaitMessage();
            	browseDetail('CustomDetailYum.jsp?hidFamily=' + familyId + '&hidFrecu=' + frecuencyId + '&hidDate=' + date + '&hidBase=' + base + '&hidPack=' + pack,'CustomYum.jsp','1');
        	}

        	//showWaitMessage();
        </script>
    </head>

    <body bgcolor="white" OnLoad="loadFirstTab();">
    	<jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
    	<form id="frmMaster" name="frmMaster" method="post" action="CustomDetailYum.jsp" target="ifrDetail">
    		<input type='hidden' name='hidOperation' id='hidOperation' value='S'>
			<input type='hidden' name='hidAgeb' id='hidAgeb' value='0'>
			<input type='hidden' name='hidStreet' id='hidStreet' value='ALL'>
        	<table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
            	<tr>
               		<td class="body" width="10%">Desde:</td>
					<td width="10%">
						<input class = 'combos' type='text' id = 'txtDate' name='txtDate' size = '11' maxlength = '10' onclick="showCalendar('frmMaster','txtDate','txtDate');" onfocus="showCalendar('frmMaster','txtDate','txtDate');" readonly>
					</td>
					<td class="body" width="10%">Frecuencia: </td>
					<td width="10%">
						<select id="cmbFrecuency" name="cmbFrecuency" size="1" class="combos">
							<option value="> 0">-- SELECCIONE --</option>
							<option value="= 1">= 1</option>
							<option value="> 1">> 1</option>
							<option value="= 2">= 2</option>
							<option value="> 2">> 2</option>
							<option value="= 3">= 3</option>
							<option value="> 3">> 3</option>
							<option value="= 4">= 4</option>
							<option value="> 4">> 4</option>
							<option value="= 5">= 5</option>
							<option value="> 5">> 5</option>
						</select>
					</td>			
					<td class="body" width="10%" align="left">Recurrencia: </td>
                	<td width="10%" align="left">
                    	<select id="cmbFamily" name="cmbFamily" size="1" class="combos">
                    		<option value="0"> -- SELECCIONE -- </option>
                			<option value="7">7 Dias</option>
							<option value="14">14 Dias</option>
							<option value="21">21 Dias</option>
							<option value="28">28 Dias (Periodo 1)</option>
							<option value="35">35 Dias</option>
							<option value="42">42 Dias</option>
							<option value="49">49 Dias</option>
							<option value="56">56 Dias (Periodo 2)</option>
							<option value="63">63 Dias</option>
							<option value="70">70 Dias</option>
							<option value="77">77 Dias</option>
							<option value="84">84 Dias (Periodo 3)</option>
							<option value="112">Periodo 4</option>
							<option value="140">Periodo 5</option>
							<option value="168">Periodo 6</option>
							<option value="196">Periodo 7</option>
							<option value="224">Periodo 8</option>
							<option value="252">Periodo 9</option>
							<option value="280">Periodo 10</option>
							<option value="308">Periodo 11</option>
							<option value="336">Periodo 12</option>
							<option value="364">Periodo 13</option>			
						</select>
					</td>
					<td class="body" width="10%">Paquete: </td>
					<td width="10%">
						<select id="cmbPackage" name="cmbPackage" size="1" class="combos">
							<option value="ALL">---- TODOS ----</option>
								<%
									moAbcUtils.fillComboBox(out,"select pruleno, pdesc from sus_prule_codes where pstat = 'A' order by pdesc");
								%>
						</select>
					</td>
                    <td class="body" width="10%">Receta: </td>
					<td width="10%">
						<select id="cmbBase" name="cmbBase" size="1" class="combos">
							<option value="ALL">---- TODOS ----</option>
								<%
									moAbcUtils.fillComboBox(out,"select B.baseno, B.bdesc from sus_menu_items I inner join sus_clss_codes C on I.classno = C.classno and I.classno = '137' inner join sus_base_codes B on I.baseno = B.baseno and B.bstat = 'A' group by B.baseno, B.bdesc order by B.bdesc");
								%>
						</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td class="body" width="20%" align="right" colspan="2">
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
