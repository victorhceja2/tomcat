<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryReportYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Toma los datos del calendario YUM y los pasa al programa
#                   que genera el reporte del inventario semanal.
# Fecha Creacion  : 17/Nov/05
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page import="java.util.*, java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>

<%@ include file="../Proc/InventoryLibYum.jsp" %>
<!-- ya se include "/Include/CommonLibYum.jsp"  -->

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
	AplicationsV2 logApps = new AplicationsV2();
    String msYear;
    String msPeriod;
    String msWeek;
    String msWeekId;
    String msDay;
    String msReport;
	String msMessage;
	String msFamily;
	String msSales;
	boolean inventoryOk;
%>

<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
		msMessage = "";
		msFamily = "-1";
		inventoryOk = false;

		if(!msWeek.equals("0"))
		{
			msWeekId = getWeekId(msYear, msPeriod, msWeek);
			msSales  = getSales(msYear, msPeriod, msWeekId);
		}
		else
		{
			msSales = "1";
		}

		if(msReport.equals("2"))//Se tiene que escoger una semana
		{
			DateFormat  dateformat = new SimpleDateFormat("yyyy-MM-dd");
			String currentdate = calculateCurrentDate();
			String begindate   = calculateDate(msYear, msPeriod, msWeek);

            if(begindate.compareTo(currentdate) >= 0) //No fechas futuras
			{	
				msMessage = "No se pueden obtener reportes para semanas en las que no ha sido cerrado el inventario.";
			}
			else
			{
				inventoryOk = inventoryExists(msYear, msPeriod, msWeekId);

                if(!inventoryOk)
				{
                    msMessage = "No se encontraron datos para la semana %s del periodo %s.";
					msMessage = Str.getFormatted(msMessage, new Object[]{msWeekId, msPeriod});
				}

			}
		}
		else
		{
			if(msReport.equals("0"))
				msMessage = "Seleccione alguna semana del calendario Yum.";
			else
				msMessage = "Para obtener el reporte, seleccione una semana del calendario Yum";
		}
    }
    catch(Exception e)
    {
		System.out.println("Exception .. " + e);
    }
%>

<html>
	<head>
		<%@ include file="/Include/CalendarLibYum.jsp" %>
		<script language="javascript" src="/Scripts/HtmlUtilsYum.js"></script>
		<script>
			var inventoryOk = <%= inventoryOk %>;

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

			function doAction()
			{

				if(inventoryOk == true)
				{
					submitFrames();
				}
				else
				{	
					document.mainform.action = '/MessageYum.jsp';
					addHidden(document.mainform, 'hidTitle', 'Reporte Inventario Semanal');
					addHidden(document.mainform, 'hidSplit', 'true');
					submitFrame('preview');
				}
			}
		
		</script>
	</head>
	<body onLoad="doAction()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="530" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>                      
        <form name="mainform" action="InventoryReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeekId %>">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidFamily" value="<%= msFamily %>">
            <input type="hidden" name="hidSales" value="<%= msSales %>">
            <input type="hidden" name="hidMessage" value="<%= msMessage %>">
        </form>
	</body>
</html>

