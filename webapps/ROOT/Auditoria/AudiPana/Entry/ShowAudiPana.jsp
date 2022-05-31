<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : ShowAudiReport.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Reporte Tickets Auditoria 
# Fecha Creacion  : 08/Abril/2008
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="java.io.*" %>
<%@ include file="../Proc/AudiReportLib.jsp" %>

<%
    	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    	moHtmlAppHandler.msReportTitle = "Tickets Auditoria";

	String repOut 		= "";
	boolean reportOk 	= false;
	String ano 		= "";
	String mes 		= "";
	String dia 		= "";
	String archivo 		= "";
	String ticket 		= "";
	String valToday		= "0";

	archivo 		= request.getParameter("txtDate");
	ano 			= archivo.substring(8,10);
	mes 			= archivo.substring(3,5);
	dia 			= archivo.substring(0,2);
	ticket			= request.getParameter("txtTicket");
	String cmd 		= "";

	Calendar c = new GregorianCalendar();
	String tdia = Integer.toString(c.get(Calendar.DATE));
	String tmes = Integer.toString(c.get(Calendar.MONTH) + 1);
	String tannio = Integer.toString(c.get(Calendar.YEAR));

	if(tdia.length() < 2){
		tdia = "0" + tdia;
	}
	if(tmes.length() < 2){
		tmes = "0" + tmes;
	}
	tannio = tannio.substring(2);

	archivo	= ano + mes + dia;
	String today = tannio + tmes + tdia;
	
	if(archivo.equals(today)){
		valToday = "1";
	}


	cmd = "/tmp/" + archivo + ".au.txt";
	String laComand = "/usr/local/tomcat/webapps/ROOT/Auditoria/AudiPana/Scripts/showTickPana.pl  " + archivo + " " + valToday + " " + ticket;
	try{
		Process p = Runtime.getRuntime().exec(laComand);
		p.waitFor();
	}catch(IOException e){
		e.printStackTrace();
		System.out.println("error en esta parte  "+ laComand);
	}
	repOut = PrintFile(cmd,132);
	laComand = "rm " + cmd;
	try{
		Process p = Runtime.getRuntime().exec(laComand);
		p.waitFor();
	}catch(IOException e){
		e.printStackTrace();
		System.out.println("error en esta parte  "+ laComand);
	}
	archivo = dia + "-" + mes + "-20" + ano;
	reportOk = true;
%>

<html>
	<head>
    		<title>Reporte Auditoria</title>
		<link rel="stylesheet" href="/CSS/GeneralStandardsYum.css" type="text/css">
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
	<body bgcolor="white" onLoad="limpiar();">
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
			<table>
				<tr>
					<td class='descriptionTabla'>
						<b>
							Fecha:  
						</b>
						<%=archivo%>
						<b>
							Ticket: 
						</b>
						<%=ticket%>
					</td>
				</tr>
			</table>
			<table align='center' width='50%' border='0'>
				<tr>
					<td align='center' class='descriptionTabla' nowrap>
						<br><br>
						<div id='message' class='detail-cont'>
							<b>
							Reporte Auditoria Ticket 
							</b>
						</div>
					</td>
				</tr>
				<%
					if(repOut.length() < 50){
				%>
				<tr>
					<td align='center' class='descriptionTabla' nowrap>
						<br><br>
						<div id='message' class='detail-cont'>
							<b>No se encontraron datos, verificar criterios de busqueda.</b>
						</div>
					</td>
				</tr>
				<%
					}
				%>
			</table>
			<table align="center" border="0" cellpadding="0" cellspacing="0">
	  			<%
					if (reportOk){
						out.print(repOut);
					}
	  			%>
	 		</table>
			<jsp:include page = '/Include/TerminatePageYum.jsp'/>
    		</form>
	</body>
</html>
