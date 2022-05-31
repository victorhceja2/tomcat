<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : InventoryConfirmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Realiza la confirmacion del cierre de inventario semanal.
# Fecha Creacion  : 03/Agosto/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
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

<%!AbcUtils moAbcUtils;
	AplicationsV2 logApps = new AplicationsV2();
	String msYear;
	String msPeriod;
	String msWeek;
	String msFamily;
	String msSales;
	String msUser;
	String msInitDate;
	String laAttention;

	boolean msInventoryOk;%>

<%
	try {
		moAbcUtils = new AbcUtils();

		msYear = request.getParameter("hidYear");
		msPeriod = request.getParameter("hidPeriod");
		msWeek = request.getParameter("hidWeek");
		msFamily = request.getParameter("hidFamily");
		msSales = request.getParameter("hidSales");
		msUser = request.getParameter("hidUser");
		msInitDate = request.getParameter("hidInitDate");
		//msInventoryOk = saveChanges(msYear, msPeriod, msWeek);
		laAttention = attentionItems(msYear, msPeriod, msWeek);

	} catch (Exception e) {
		logApps.writeError(e);
	}

	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler) session
			.getAttribute(request.getRemoteAddr());
	moHtmlAppHandler.setPresentation("VIEWPORT");
	moHtmlAppHandler.initializeHandler();
	moHtmlAppHandler.msReportTitle = getCustomHeader(
			"Confirmaci&oacute;n actualizaci&oacute;n de inventario",
			"Printer");
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

<script src="/Scripts/DataGridClassYum.js"></script>
<script src="/Scripts/TooltipsYum.js"></script>

<script language="javascript">
    function cerrar(){
        //EZ: tunning
        //window.opener.location.href = 'InventoryDetailYum.jsp?hidFamily=<%=msFamily%>';
		alert("Esta es la ultima oportunidad de hacer cambios adicionales en el inventario");
		window.close();

	}
	function imprimir() {
		parent.frames["ifrPrinter"].focus();
		parent.frames["ifrPrinter"].print();
	}
	
	function submitPrint()
	{
		document.frmConfirm.target = "ifrTopPrinter";
		document.frmConfirm.action = "DifferenceItems.jsp";
        document.frmConfirm.submit();
	}
</script>
</head>
<body bgcolor="white">
	<jsp:include page='/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true" />
	</jsp:include>
	<form name="frmConfirm">
		<div id="divButtons">
			<br> <br> <input type="button" value="Imprimir Finales"
				onclick="imprimir()"> &nbsp;&nbsp; <input type="button"
				value="Cerrar ventana" onclick="cerrar()"> 
				<br> <br>
			<br>
		</div>
		<div id="divTable">
			<table width="98%" border="0">
				<tr>
					<td align="center" class="mainsubtitle" colspan="2"><b>&iexcl;Atenci&oacute;n&#33;</b>
						Los siguientes items tienen diferencias altas en dinero o cantidad y/o no se ingreso su final<br>
					<br></td>
					<td><a href="javascript: submitPrint()"><img
							src="/Images/Menu/print_button.gif"
							onMouseOver="ddrivetip('Imprimir TOP 5.')"
							onMouseOut="hideddrivetip()" border="0"></a></td>
				</tr>
				<tr class="bsDb_tr_header">
					<td width="33%" align="center">Negativos (Top 5)</td>
					<td width="33%" align="center">Positivos (Top 5)</td>
					<td width="34%" align="center">Prods con Final Cero</td>
				</tr>
				<%
					registerAudit(msUser, msYear, msPeriod, msWeek, msInitDate);
					out.println(laAttention);
				%>
			</table>
		</div>
		<input type="hidden" name="hidYear" value="<%=msYear%>"> <input
			type="hidden" name="hidPeriod" value="<%=msPeriod%>"> <input
			type="hidden" name="hidWeek" value="<%=msWeek%>">
	</form>
	<iframe name="ifrPrinter"
		src="../Rpt/InventoryReportFrm.jsp?year=<%=msYear%>&period=<%=msPeriod%>&week=<%=msWeek%>&hidFamily=<%=msFamily%>&hidSales=<%=msSales%>&hidTarget=Printer&hidFirst=true"
		frameborder="0" width="800" height="10"></iframe>
	<iframe name="ifrTopPrinter" frameborder="0" width="800" height="10"></iframe>
	<jsp:include page='/Include/TerminatePageYum.jsp' />
</body>
</html>


