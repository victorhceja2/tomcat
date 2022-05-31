<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TicketAudi.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Reporte Tickets Auditoria 
# Fecha Creacion  : 08/Abril/2008
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>

<%! AbcUtils moAbcUtils = new AbcUtils(); %>

<%
    	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    	moHtmlAppHandler.msReportTitle = "Tickets Auditoria";
		String user_log = (String)session.getAttribute("login_user");
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
			function limpiar(){
				document.frmMaster.txtDate.value = "";
				document.frmMaster.txtTicket.value = "";
			}

        		function changeCategory(){
					if(document.frmMaster.txtDate.value == ""){
						alert("Seleccione la fecha.");
						return false;
					}
					document.frmMaster.submit();
        		}
        	</script>
    	</head>
	<body bgcolor="white">
		<jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
		<form id="frmMaster" name="frmMaster" method="post" action="ShowAudiPana.jsp">
			<table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
				<tr>
					<td class="body" width="10%">Fecha: </td>
					<td width="15%">
						<input class = 'combos' type='text' id = 'txtDate' name='txtDate' size = '15' maxlength = '10' onclick="showCalendar('frmMaster','txtDate','txtDate');" onfocus="showCalendar('frmMaster','txtDate','txtDate');" readonly>
					</td>
					<td class="body" width="10%">Ticket: </td>
					<td width="65%">
						<input class = 'combos' type='text' id = 'txtTicket' name='txtTicket' size = '4' maxlength = '4'>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>			
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>
						<input type='button' name="btnBuscar" value='Buscar' onclick='changeCategory();'/>
					</td>
					<td>
						<input type='button' name="btnLimpiar" value='Limpiar' onclick='limpiar();'/>
					</td>
				</tr>
        		</table>
    		</form>
	</body>
</html>
