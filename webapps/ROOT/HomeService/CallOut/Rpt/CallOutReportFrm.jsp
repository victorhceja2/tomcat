<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : CallOutReportFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : Mario Chavez Ayala     
# Objetivo        : Mostrar un resumen de llamadas.
# Fecha Creacion  : 12/Marzo/2006
# Inc/requires    : ../Proc/CallOutLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria CallOutLibYum.jsp
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/CallOutLibYum.jsp" %>

<%! 
    AbcUtils moAbcUtils = new AbcUtils();
    String msPreviousYear;
    String msYear;
    String msPeriod;
    String msWeek;
    String msTarget;
    String msCSS;
%>

<%
    try
    {
        msYear   = request.getParameter("year");
        msPeriod = request.getParameter("period");
        msWeek   = request.getParameter("week");
        msTarget = request.getParameter("hidTarget");
        msPreviousYear = request.getParameter("hidPreviousYear");

    }
    catch(Exception e)
    {
        msYear   = "0";
        msPeriod = "0";
        msWeek   = "0";
    }
    
    if(msTarget.equals("Printer"))
    {
        msCSS = "/HomeService/ConmCall/CSS/DataGridReportPrinterYum.css";
    }
    else
    {
        msCSS = "/CSS/DataGridDefaultYum.css";
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte llamadas de salida", msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSS %>" />

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <script src="../Scripts/CallOutReportYum.js"></script>

        <script type="text/javascript">
        var giCurrentYear  = <%= msYear %>;
        var giPreviousYear = <%= msPreviousYear %>;
        var isReport       = <%= msTarget.equals("Printer") %>;

        //Estas dos variables son requeridas en el Script CallReportYum.js
        var loGrid    = new Bs_DataGrid('loGrid');
        var loGridC   = new Bs_DataGrid('loGridC');
        var gaDataset = parent.gaDataset;
        var gaDatasetC= parent.gaDatasetC;
        </script>


    </head>

    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" onLoad="initDataGrid(giCurrentYear, giPreviousYear, isReport);initDataGridC(giCurrentYear, giPreviousYear, isReport)">

    <jsp:include page="/Include/GenerateHeaderYum.jsp">
        <jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <table width="99%" border="0" align="center" cellspacing="6">
        <tr>
            <td>
                <b class="datagrid-leyend">A&ntilde;o: <%= msYear %>, Periodo: <%= msPeriod %>, Semana: <%= msWeek %></b>
            </td>
        </tr>
        <tr>
            <td>
                <div id="goDataGrid"></div>
                <br>
            </td>
        </tr>
        <tr>
            <td>
                <div id="goDataGridC"></div>
                <br>
            </td>
        </tr>

    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
