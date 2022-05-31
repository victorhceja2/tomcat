<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransactionsReportYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Genera datos del reporte de transacciones por tendencia diaria.
# Fecha Creacion  : 09/Feb/06
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.text.DateFormat" %>
<%@ page import = "java.util.Calendar" %>
<%@ page import = "java.util.Date" %>
<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "java.io.FileReader" %>
<%@ page import = "java.io.File" %>
<%@ page import = "generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/TendenciesLibYum.jsp" %>

<%! AbcUtils moAbcUtils = new AbcUtils();

    String msYear   = "0";
    String msPeriod = "0";
    String msWeek   = "0";
    String msDay    = "0";
    String msReport = "0";
    String msHistoryDays = "0";

	String msMessage;

    boolean reportOk = false;
    int liNumDays = 7;
%>

<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
        msHistoryDays = request.getParameter("txtHistoryDays");
		msMessage = "";

        resetReport();

        if(msHistoryDays != null)
        {
            try
            {
                liNumDays = Integer.parseInt(msHistoryDays);

                if(liNumDays <= 0)
                    liNumDays = 7;
            }
            catch(Exception e)
            {
                liNumDays = 7;
            }
        }


		if(msReport.equals("3"))//Se tiene que escoger un dia
		{

            Calendar calendar     = Calendar.getInstance();

			DateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd");
            
			Date currentDate      = dateformat.parse(calculateCurrentDate());
			Date selectedDate     = dateformat.parse(calculateSelectedDate(msYear, msPeriod, msWeek, msDay));

            if(selectedDate.after(currentDate)) //No fechas futuras
				msMessage = "No puede seleccionar fechas futuras.";
			else
			{
                calendar.setTime(selectedDate);
                calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - liNumDays);

                dateformat   = new SimpleDateFormat("MM/dd/yy");

                String start = dateformat.format(calendar.getTime());
                String end   = dateformat.format(selectedDate);

                reportOk = generateReport(start, end);

				if(reportOk)
                {
                    //Mostrar archivo
					//msMessage = "Se genera reporte, fecha inicio "+start+", end "+end;
                    msMessage = "NA";
                }    
				else
					msMessage = "No se encontraron datos anteriores para la fecha seleccionada.";

			}
		}
		else
		{
            reportOk = false;

			if(msReport.equals("0"))
            {
				msMessage = "Escriba el n&uacute;mero de d&iacute;as de " +
                            "historia, y seleccione alguna fecha del calendario Yum para "+
                            "obtener el reporte.";
            }                            
			else
				msMessage = "La fecha seleccionada tiene que ser una dia.";
		}
    }
    catch(Exception e)
    {
        System.out.println("Exception e: " + e);    
    }

%>


<html>
	<head>
		<%@ include file="/Include/CalendarLibYum.jsp" %>
		<script language="javascript" src="/Scripts/HtmlUtilsYum.js"></script>
		<script language="javascript" src="/Scripts/AbcUtilsYum.js"></script>
		<script>
			var dataOk = <%= reportOk %>;

            <%= getDataset() %>

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
				submitFrame('printer');
				//Despues de 1 seg se carga el segundo frame
				setTimeout("submitFrame('preview')", 1000);
			}

			function doAction()
			{
				if(dataOk == true)
					splitWindow(false);
				else
                {
                    parent.showHideControl('extraFields','visible');

                    var loExtraFields = parent.document.getElementById("extraFields");

                    loExtraFields.innerHTML = "<div class='detail-desc' align='right'>" +
                                "<b>D&iacute;as de historia: </b>" +
                                "<input type='text' name='txtHistoryDays' id='historyDays' size='3' value='7'> &nbsp;"+
                                "</div>";

					splitWindow(true);
                }
				submitFrames();
			}
		
		</script>
	</head>
	<body onLoad="doAction()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="520" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>                      
        <form name="mainform" action="TendenciesReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeek %>">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidMessage"  value="<%= msMessage %>">
            <input type="hidden" name="hidReportOk" value="<%= reportOk %>">
        </form>
	</body>
</html>
