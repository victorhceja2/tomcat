<%--
##########################################################################################################
# Nombre Archivo  : LeaderReportFrm.jsp     
# Compania        : Premium Restaurant Brands
# Autor           : Jose Abraham Vanegas Mata
# Objetivo        : Mostrar la eficiencia de reparto.
# Fecha Creacion  : 09/Junio/2016
# Inc/requires    : ../Include/CommonLibyum.jsp
# Observaciones   : Se requiere mostrar un porcentaje de eficiencia de repartidor
##########################################################################################################
--%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="generals.*"%>

<%@ include file="../Proc/LeaderLibYum.jsp"%>

<%!AbcUtils moAbcUtils = new AbcUtils();

	String msYear;
	String msPeriod;
	String msWeek;
	String msDay;
	String msDataset;%>

<%
	try {
		msYear = request.getParameter("year");
		msPeriod = request.getParameter("period");
		msWeek = request.getParameter("week");
		msDay = request.getParameter("day");

		System.out.println("Año: " + msYear + "\nPeriodo: " + msPeriod
				+ "\nSemana: " + msWeek + "\nDía: " + msDay);

		msPeriod = Integer.parseInt(msPeriod) < 10
				? "0" + msPeriod
				: msPeriod;
		if (msYear.equals("0")) {
			msDataset = "new Array()";
		} else {
			msDataset = searchTransfers(msYear, msPeriod, msWeek, msDay);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler) session
			.getAttribute(request.getRemoteAddr());
	//   moHtmlAppHandler.setPresentation("VIEWPORT");
	moHtmlAppHandler.initializeHandler();
	moHtmlAppHandler.msReportTitle = getCustomHeader(
			"Reporte de Lideres de Reparto", "");
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
<script src="../Scripts/LeaderReportYum.js"></script>
<script src="/Scripts/DataGridClassYum.js"></script>
<script src="/Scripts/MiscLibYum.js"></script>
<!-- script src="/Scripts/ReportUtilsYum.js"></script-->
<script src="/Scripts/HtmlUtilsYum.js"></script>
<script type="text/javascript">
	var isReport = false;
	var loGrid = new Bs_DataGrid('loGrid');
	var gaDataset =
<%=msDataset%>
	;
</script>
</head>
<body bgcolor="white" style="margin-left: 0px; margin-right: 0px"
	onload="initDataGrid();">
	<jsp:include page="/Include/GenerateHeaderYum.jsp">
		<jsp:param name="psStoreName" value="true" />
	</jsp:include>

	<table width="99%" border="0" align="center" cellspacing="6">
		<tr>
			<td><b class="datagrid-leyend">A&ntilde;o: <%=msYear%>,
					Periodo: <%=msPeriod%>, Semana: <%=msWeek%> <br> Fecha Negocio: <%=getBussinesDate(msYear, msPeriod, msWeek, msDay)%></b></td>
		</tr>
		<tr>
			<td>
				<div id="goDataGrid" align="center"></div> <br>
			</td>
		</tr>
	</table>
	<jsp:include page='/Include/TerminatePageYum.jsp' />

</body>

</html>