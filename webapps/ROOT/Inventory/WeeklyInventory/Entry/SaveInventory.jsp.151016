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

	boolean msInventoryOk;%>

<%
	try {
		moAbcUtils = new AbcUtils();

		msYear = request.getParameter("hidYear");
		msPeriod = request.getParameter("hidPeriod");
		msWeek = request.getParameter("hidWeek");

		msInventoryOk = saveChanges(msYear, msPeriod, msWeek);
	} catch (Exception e) {
		System.err.print(e);
	}

	if(msInventoryOk){
		System.out.println("Se registró correctamente el inventario");
		%>
		<html>
		<body>
		<p>Se registr&oacute; el inventario</p>
		</body>
		</html>
		<%
	}else{
		System.out.println("Ocurrio un error al registrar el inventario");
		%>
		<html>
		<body>
		<p>No se registr&oacute; el inventario</p>
		</body>
		</html>
		<%
	}
%>