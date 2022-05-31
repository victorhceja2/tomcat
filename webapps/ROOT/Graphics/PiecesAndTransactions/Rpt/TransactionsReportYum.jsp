<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransactionsReportYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Muestra reporte grafico de Transacciones
# Fecha Creacion  : 27/OCt/05
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.DateFormat" %>
<%@ page import = "java.util.Calendar" %>
<%@ page import = "java.util.Date" %>
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
<%@ page import = "org.jfree.chart.renderer.category.LineAndShapeRenderer" %>
<%@ page import = "org.jfree.chart.renderer.category.LineAndShapeRenderer" %>
<%@ page import = "org.jfree.chart.renderer.category.BarRenderer" %>
<%@ page import = "org.jfree.ui.TextAnchor" %>
<%@ page import = "generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="/Include/CalendarLibYum.jsp" %>
<%@ include file="../Proc/GraphicsLibYum.jsp" %>

<%! AbcUtils moAbcUtils = new AbcUtils();

    String msYear   = "0";
    String msPeriod = "0";
    String msWeek   = "0";
    String msDay    = "0";
    String msReport = "0";

	String msMsg;
	String filename;
	String graphURL;

	CategoryDataset[] createDataset(int numWeeks, Date begindate)
	{
		return createTransactionsDataset(numWeeks, begindate);
	}

%>

<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
		msMsg = "";
		graphURL = "/Images/Generals/Transparent.gif";

		if(msReport.equals("3"))//Se tiene que escoger un dia
		{
			DateFormat  dateformat = new SimpleDateFormat("yyyy-MM-dd");
            //Para fechas futuras
			//Date currentdate = dateformat.parse(calculateCurrentDate());
			Date limitdate = dateformat.parse(calculateLimitDate(14));
			Date begindate   = dateformat.parse(calculateBeginDate());

            //if(begindate.after(currentdate)) //No fechas futuras
            if(begindate.after(limitdate)) //No fechas mayores de 2 semanas
			{	
				msMsg = "No puede seleccionar fechas futuras. <br>" + limitdate.toString() +
                " <br> "  + begindate.toString();
				
			}
			else
			{
				filename = generateChart(session, new PrintWriter(out), begindate, "Transacciones");

				if(filename != null)
					graphURL = "/servlet/DisplayChart?filename=" + filename;
				else
					msMsg  = "No se encontraron datos anteriores para la fecha seleccionada.";

			}
		}
		else
		{
            loadRSG();

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

<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="TransactionsReportFrm.jsp?target=Preview&graphURL=<%= graphURL %>&msMsg=<%= msMsg %>" name="preview" frameborder="0">
      <FRAME src="TransactionsReportFrm.jsp?target=Printer&graphURL=<%= graphURL %>&msMsg=<%= msMsg %>" name="printer" frameborder="0">
</FRAMESET>
