<%--
##########################################################################################################
# Nombre Archivo  : DestChangeYum.jsp     
# Compania        : Yum Brands Intl
# Autor           : Mario Chavez Ayala     
# Objetivo        : Mostrar los tickets con cambio de destino.
# Fecha Creacion  : 22/Marzo/2006
# Inc/requires    : ../Include/CommonLibyum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos
##########################################################################################################
--%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>

<%@ include file="../Proc/DestChangeLibYum.jsp" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%! AbcUtils moAbcUtils = new AbcUtils();

    String msPreviousYear;
    String msYear;
    String msPeriod;
    String msWeek;
    String msWeekId;
    String msDay;
    String msReport;
    String msMessage;
    String msDataset;
    boolean reportOk;
%>

<%
    try
    {
        msYear            = request.getParameter("hidSelectedYear");
        msPeriod          = request.getParameter("hidSelectedPeriod");
        msWeek            = request.getParameter("hidSelectedWeek");
        msDay             = request.getParameter("hidSelectedDay");
        //msReport          = request.getParameter("hidReportType");
        msMessage = "";
        msDataset = "new Array()";
        //reportOk  = false;

        if(!msWeek.equals("0"))
        {
            msWeekId = getWeekId(msYear, msPeriod, msWeek);
        }

        //if(msReport.equals("2"))//Se tiene que escoger una semana
        //{
            //DateFormat  dateformat = new SimpleDateFormat("yyyy-MM-dd");
            //String currentdate = calculateCurrentDate();
            //String begindate   = calculateDate(msYear, msPeriod, msWeek);
            //Considerar semanas cerradas.
        reportOk  = true;//reportOk(msPreviousYear, msYear, msPeriod, msWeekId);
        msDataset = getDataset(msYear, msPeriod, msWeekId, msDay);
        //else
        //{
            //msMessage = "No se encontraron datos para generar el reporte.";
            //msMessage = "No se encontraron datos para la semana %s del periodo %s.";
            //msMessage = Str.getFormatted(msMessage, new Object[]{msWeekId, msPeriod});
        //}
        //}
        //if(msReport.equals("0"))
            //msMessage = "Seleccione alguna semana del calendario Yum.";
        //else
            //msMessage = "Para obtener el reporte, seleccione una semana del calendario Yum";
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
            var reportOk = <%= reportOk %>;

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

                if(reportOk == true)
                {
                    submitFrames();
                }
                else
                {    
                    document.mainform.action = '/MessageYum.jsp';
                    addHidden(document.mainform, 'hidTitle', 'Reporte cambio de destino');
                    addHidden(document.mainform, 'hidSplit', 'true');
                    submitFrame('preview');
                }
            }
        
            var gaDataset = <%= msDataset %>;

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
        <form name="mainform" action="DestChangeReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeekId %>">
            <input type="hidden" name="day" value="<%= msDay %>">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidMessage" value="<%= msMessage %>">
            <input type="hidden" name="hidPreviousYear" value="<%= msPreviousYear %>">
        </form>
    </body>
</html>

