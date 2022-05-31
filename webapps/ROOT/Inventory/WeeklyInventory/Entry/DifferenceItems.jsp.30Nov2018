<jsp:include page='/Include/ValidateSessionYum.jsp' />

<%@ page contentType="text/html"%>
<%@ page import="java.util.*, java.io.*"%>
<%@ page import="generals.*"%>
<%@ page import="jinvtran.inventory.*"%>
<%@ page import="jinvtran.inventory.utils.*"%>
<%@ include file="../Proc/InventoryLibYum.jsp"%>

<%!AbcUtils moAbcUtils = new AbcUtils();
	AplicationsV2 logApps = new AplicationsV2();
	String msYear;
	String msPeriod;
	String msWeek;
	String msTarget;
	String laAttention;%>

<%
	try {
		msYear = request.getParameter("hidYear");
		msPeriod = request.getParameter("hidPeriod");
		msWeek = request.getParameter("hidWeek");
		msTarget = "Printer";
		
		logApps.writeInfo("En DifferenceItems.jsp\nmsYear: [" + msYear + "]\nmsPeriod: [" + msPeriod + "]\nmsWeek: [" + msWeek + "]\nmsTarget: [" + msTarget + "]");
		
		laAttention = attentionItems(msYear, msPeriod, msWeek);
	} catch (Exception e) {
		msYear = "0";
		msPeriod = "0";
		msWeek = "0";
		msTarget = "Printer";
	}

	HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler) session.getAttribute(request.getRemoteAddr());
	moHtmlAppHandler.setPresentation("VIEWPORT");
	moHtmlAppHandler.initializeHandler();
	moHtmlAppHandler.msReportTitle = getCustomHeader("TOP 5 Positivos, Negativos y Ceros", msTarget);
	moHtmlAppHandler.updateHandler();
	moHtmlAppHandler.validateHandler();
%>

<html>
<head>
<title>TOP 5 Positivos, Negativos y Ceros</title>
<link rel="stylesheet" type="text/css"
	href="/CSS/GeneralStandardsYum.css" />
<link rel="stylesheet" type="text/css"
	href="/CSS/DataGridDefaultYum.css" />
<link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css" />
</head>
<body bgcolor="white" onLoad="print()" style="margin-left: 0px; margin-right: 0px">
	    <jsp:include page="/Include/GenerateHeaderYum.jsp" />
	<form name="frmConfirm">
		<div id="divTable">
			<table width="98%" border="1">
				<tr>
					<td align="center" class="mainsubtitle" colspan="3"><b>&iexcl;Atenci&oacute;n&#33;</b>
						Los siguientes items tienen diferencias altas en dinero o cantidad y/o no se ingreso su final<br>
						<br></td>
				</tr>
				<tr class="bsDb_tr_header">
					<td width="33%" align="center">Negativos (Top 5)</td>
					<td width="33%" align="center">Positivos (Top 5)</td>
					<td width="34%" align="center">Prods con Final Cero</td>
				</tr>
				<%
					out.println(laAttention);
				%>
			</table>
		</div>

	</form>
	<jsp:include page = '/Include/TerminatePageYum.jsp'/>
</body>
</html>