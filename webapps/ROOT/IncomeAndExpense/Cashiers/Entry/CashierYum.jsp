<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CashierYum.jsp
# Compania        : Yum Brands Intl
# Autor           : MCA
# Objetivo        : Reporte Cajeros
# Fecha Creacion  : 14/Feb/2008
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/CashierLibYum.jsp" %>   

<%! 
    AbcUtils moAbcUtils; 
%> 

<%
    moAbcUtils = new AbcUtils();
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Reporte de cajeros";
%>

<html>
	<head>
    	<title>Reporte de cajeros</title>
		
		<link rel="stylesheet" href="/CSS/GeneralStandardsYum.css" type="text/css">
		<link rel="stylesheet" href="/CSS/TabStandardsYum.css" type="text/css">
		<link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css">
		<link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
		
		<div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>
		
		<div id="divWaitGSO" style="width: 300px; height: 150px" class="wait-gso">
        	<br>Cargando informaci&oacute;n de Cajeros.
            	<br><br>Espere por favor...<br><br>
		</div>

		<script src="/Scripts/AbcUtilsYum.js"></script>
		<script src="/Scripts/HtmlUtilsYum.js"></script>
	    <script src="/Scripts/CalendarYum.js"></script>	
    	<script>
        	var gaKeys = new Array('');
        	var gsEmp = '';
        	var msLastTab = '1';
    
        	function loadFirstTab() {
			document.frmMaster.btnBuscar.enable = true;
            		validOption('1');
    		}

        	function validOption(psTab){
            	switch (psTab){
                    case '1':     
                        browseDetail('CashierDetailYum.jsp?hidEmp=0','CashierYum.jsp','1');
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
			document.frmMaster.cmbEmployee.value = "ALL";
			document.frmMaster.cmbManager.value = "Seleccione";
		}
			
        	function changeCategory(){
			var date = document.frmMaster.txtDate.value;
			var emp_code = document.frmMaster.cmbEmployee.value;
			var emp_mngr = document.frmMaster.cmbManager.value;
			if(date == ""){ 	
				alert("Seleccione una fecha.");	
				return false;
			}
			if(emp_code == "ALL"){ 	
				alert("Seleccione el cajero.");	
				return false;
			}
			if(emp_mngr == "ALL"){ 	
				alert("Seleccione el usuario que solicita el reporte.");	
				return false;
			}
			showProducts(date, emp_code, emp_mngr);
        	}

        	function showProducts(date, emp_code, emp_mngr){
			if(emp_mngr != "ALL")
            			showWaitMessage();
            		browseDetail('CashierDetailYum.jsp?hidDate=' + date + '&hidEmp=' + emp_code + '&hidMngr=' + emp_mngr,'CashierYum.jsp','1');
        	}

        </script>
    </head>

    <body bgcolor="white" OnLoad="loadFirstTab();">
    	<jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
    	<form id="frmMaster" name="frmMaster" method="post" action="CashierDetailYum.jsp" target="ifrDetail">
    		<input type='hidden' name='hidOperation' id='hidOperation' value='S'>
        	<table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
		<tr>
			<td>&nbsp;</td>
		</tr>
            	<tr>
               		<td class="Text" width="10%">Fecha:</td>
			<td width="10%">
				<input class = 'subheadBPrn' type='text' id = 'txtDate' name='txtDate' size = '11' maxlength = '10' onclick="showCalendar('frmMaster','txtDate','txtDate');" onfocus="showCalendar('frmMaster','txtDate','txtDate');" readonly>
			</td>
			<td class="Text" width="10%">Cajero: </td>
			<td width="10%">
				<select id="cmbEmployee" name="cmbEmployee" size="1" class="subheadBPrn">
					<option value="ALL">---- SELECCIONE ----</option>
					<%moAbcUtils.fillComboBox(out,"SELECT MAX(emp_code) AS emp_code, sus_id FROM pp_employees WHERE sus_id <> 'NULL' AND sus_pass <> 'NULL' AND sus_id <> 'UNKN' AND security_level <> 'NU' GROUP BY 2 ORDER BY 2");%>
				</select>
			</td>
			<td class="text" width="10%">Empleado Solicitante: </td>
			<td width="10%">
				<select id="cmbManager" name="cmbManager" size="1" class="subheadBPrn">
					<option value="ALL">---- SELECCIONE ----</option>
					<%moAbcUtils.fillComboBox(out,"SELECT emp_code, sus_id FROM pp_employees WHERE sus_id <> 'NULL' AND sus_pass <> 'NULL' AND sus_id <> 'UNKN' AND security_level <> 'NU' ORDER BY 2");%>
				</select>
			</td>
			<td class="body" width="20%" align="right" colspan="2">
				<input type='button' class="combos" name="btnBuscar" value='Buscar' onclick='changeCategory();'/>
				<input type='button' class="combos" name="btnLimpiar" value='Limpiar' onclick='limpiar();'/>
			</td>
            	</tr>
		<tr>
			<td>&nbsp;</td>
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
