<jsp:include page = '/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : DestSellsReportFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : Sergio Cuellar
# Objetivo        : Reporte de venta diaria por destino
# Fecha Creacion  : 20/Febrero/2013
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="generals.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/DestSellsLibYum.jsp" %>

<%!
AbcUtils moAbcUtils = new AbcUtils();
String msYear;
String msPeriod;
String msWeek;
String msWeekId;
String msDay;
String msTarget;
String msCSS;
String selectedDate;
%>

<%
try
{
    msYear   = request.getParameter("year");
    msPeriod = request.getParameter("period");
    msWeek   = request.getParameter("week");
    msWeekId = request.getParameter("weekId");
    msDay    = request.getParameter("day");
    msTarget = request.getParameter("hidTarget");

    selectedDate = getDate(msWeek, msYear, msPeriod, msDay);

}
catch(Exception e)
{
    msYear   = "0";
    msPeriod = "0";
    msWeek   = "0";
}

if(msTarget.equals("Printer"))
{
    msCSS = "DataGridReportPrinterYum.css";
}
else
{
    msCSS = "DataGridDefaultYum.css";
}

HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
moHtmlAppHandler.setPresentation("VIEWPORT");
moHtmlAppHandler.initializeHandler();
moHtmlAppHandler.msReportTitle = getCustomHeader("Ventas Diarias por Destino", msTarget);
moHtmlAppHandler.updateHandler();
moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css" />
        <link rel="stylesheet" type="text/css" href="/CSS/<%= msCSS %>" />
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script type="text/javascript">
            var loGrid1    = new Bs_DataGrid('loGrid1');
            var loGrid2    = new Bs_DataGrid('loGrid2');
            var loGrid3    = new Bs_DataGrid('loGrid3');
            var loGrid4    = new Bs_DataGrid('loGrid4');
            var loGrid5    = new Bs_DataGrid('loGrid5');
            var AllDestsDataset = parent.AllDestsDataset;
            var DineinDataset   = parent.DineinDataset;
            var DeliveryDataset = parent.DeliveryDataset;
            var CarryoutDataset = parent.CarryoutDataset;
            var WindowDataset   = parent.WindowDataset;
        </script>
        <script src="../Scripts/DestSellsYum.js"></script>
    </head>

    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" onLoad="initDataGrid()">

        <jsp:include page="/Include/GenerateHeaderYum.jsp">
            <jsp:param name="psStoreName" value="true" />
        </jsp:include>

        <table width="99%" border="0" align="center" cellspacing="6">
            <tr>
                <td>
                    <b class="datagrid-leyend">
                        A&ntilde;o:<%= msYear %>, Periodo:<%= msPeriod %>, Semana:<%= msWeek %>
                    </b>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="AllDestsDataGrid"></div>
                    <br>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="DineinDataGrid"></div>
                    <br>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="DeliveryDataGrid"></div>
                    <br>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="CarryoutDataGrid"></div>
                    <br>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="WindowDataGrid"></div>
                    <br>
                </td>
            </tr>
        </table>

        <jsp:include page = '/Include/TerminatePageYum.jsp' />
    </body>
</html>

