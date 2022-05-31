<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransactionsIndexReportYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Crear reporte grafico de Transacciones del anio actual y
#                   del anio anterior en base a un DIA o una FECHA.
# Fecha Creacion  : 04/Nov/05
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.DateFormat" %>
<%@ page import = "java.util.Calendar" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.awt.Color" %>
<%@ page import = "java.awt.GradientPaint" %>
<%@ page import = "java.awt.BasicStroke" %>
<%@ page import = "org.jfree.chart.labels.StandardCategoryLabelGenerator" %>
<%@ page import = "org.jfree.chart.*" %>
<%@ page import = "org.jfree.chart.axis.*" %>
<%@ page import = "org.jfree.chart.entity.StandardEntityCollection" %>
<%@ page import = "org.jfree.chart.servlet.*" %>
<%@ page import = "org.jfree.chart.labels.ItemLabelPosition" %>
<%@ page import = "org.jfree.chart.labels.ItemLabelAnchor" %>
<%@ page import = "org.jfree.chart.plot.PlotOrientation" %>
<%@ page import = "org.jfree.chart.plot.CategoryPlot" %>
<%@ page import = "org.jfree.data.category.DefaultCategoryDataset" %>
<%@ page import = "org.jfree.data.category.CategoryDataset" %>
<%@ page import = "org.jfree.chart.renderer.category.DefaultCategoryItemRenderer" %>
<%@ page import = "org.jfree.chart.renderer.category.LineAndShapeRenderer" %>
<%@ page import = "org.jfree.chart.renderer.category.BarRenderer" %>
<%@ page import = "org.jfree.ui.TextAnchor" %>
<%@ page import = "generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/GraphicsLibYum.jsp" %>

<%! AbcUtils moAbcUtils = new AbcUtils();

    String msYear   = "0";
    String msPeriod = "0";
    String msWeek   = "0";
    String msDay    = "0";
    String msReport = "0";

	String msMsg;
	String msSelectedDate;
    String msType;
	String filename;
	String graphURL;


%>

<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
		msType   = request.getParameter("type");

		msMsg = "";
		graphURL = "/Images/Generals/Transparent.gif";

		if(msReport.equals("3"))//Se tiene que escoger un dia
		{
			DateFormat  dateformat = new SimpleDateFormat("yyyy-MM-dd");
			Date currentdate    = dateformat.parse(calculateCurrentDate());
			Date begindate      = dateformat.parse(calculateBeginDate());
			Calendar calendar   = Calendar.getInstance();
            String rowsLabel    = "Fechas del a\u00F1o " + msYear;
            String columnsLabel = "Transacciones";

            if(begindate.after(currentdate)) //No fechas futuras
			{	
				msMsg = "No puede seleccionar fechas futuras.";
			}
			else
			{
				filename = generateChart(session, new PrintWriter(out), begindate, columnsLabel, rowsLabel);

				if(filename != null)
				{
					calendar.setTimeInMillis(begindate.getTime());
					graphURL = "/servlet/DisplayChart?filename=" + filename;
					dateformat = new SimpleDateFormat("d/MMM/yyyy");
					msSelectedDate = getDayName(calendar.get(Calendar.DAY_OF_WEEK)) +
									 " " + dateformat.format(begindate);
				}
				else
					msMsg  = "No se encontraron datos anteriores para la fecha seleccionada.";

			}
		}
		else
		{
			if(msReport.equals("0"))
				msMsg = "Seleccione alguna fecha del calendario Yum.";
			else
				msMsg = "La fecha seleccionada tiene que ser una día.";

		}
    }
    catch(Exception e)
    {
        
    }


%>

<html>
	<head>
		<%@ include file="/Include/CalendarLibYum.jsp" %>
		<script>
			function submitFrames()
			{
                document.mainform.target = "preview";
                document.mainform.hidTarget.value = "Preview";
                document.mainform.submit();

                document.mainform.target = "printer";
                document.mainform.hidTarget.value = "Printer";
                document.mainform.submit();
			}
		</script>
	</head>
	<body onLoad="submitFrames()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="450" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>                      
        <form name="mainform" action="TransactionsIndexReportFrm.jsp">
            <input type="hidden" name="hidGraphURL" value="<%= graphURL %>">
            <input type="hidden" name="hidMsg" value="<%= msMsg %>">
            <input type="hidden" name="hidSelectedDate" value="<%= msSelectedDate %>">
            <input type="hidden" name="hidType" value="<%= msType %>">
            <input type="hidden" name="hidTarget">
        </form>
	</body>
</html>

<%!
	CategoryDataset[] createDataset(int numWeeks, Date currentDate)
	{
		Calendar calendar;
		Date previousDate;
		DateFormat dateformat;

		try
		{
			if(msType.equals("date"))
			{
				calendar = Calendar.getInstance();
				calendar.setTimeInMillis(currentDate.getTime());

				calendar.set(Calendar.YEAR, calendar.get(Calendar.YEAR) - 1);
	
				previousDate = calendar.getTime();
			}
			else //day
			{
				dateformat   = new SimpleDateFormat("yyyy-MM-dd");
				previousDate = dateformat.parse(calculatePreviousDate(msYear,msPeriod,msWeek,msDay));
			}			

			return createTransactionsDataset(numWeeks, currentDate, previousDate, msType);
		}
		catch(Exception e)
		{
			return null;
		}	
	}
%>
