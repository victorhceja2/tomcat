<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : HouseHoldResumeFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : Mario Chavez Ayala     
# Objetivo        : Mostrar un reporte de resumen de transacciones
# Fecha Creacion  : 12/Marzo/2006
# Inc/requires    : ../Proc/HouseHoldResumeLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria HouseHoldResumeLibYum.jsp
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/HouseHoldResumeLibYum.jsp" %>

<%! 
    AbcUtils moAbcUtils = new AbcUtils();
    String msPreviousYear;
    String msYear;
    String msPeriod;
    String msWeek;
    String msTarget;
    String msCSS;
    String lsDateToData;
    String lsYearToData, lsPeriodToData;
%>

<%
    try
    {
        lsDateToData = getDateNow();
        lsYearToData = getCurrentYear(lsDateToData);
        lsPeriodToData = getCurrentPeriod(lsDateToData);
	//lsPeriodToData = Integer.toString(Integer.parseInt(lsPeriodToData)-1);
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
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte resumen de transacciones delivery", msTarget);
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
    
        <script src="../Scripts/HouseHoldResumeYum.js"></script>

        <script type="text/javascript">
        var giCurrentYear  = <%= lsYearToData %>;
        var giCurrentPeriod = <%= lsPeriodToData %>;
        var giPreviousYear = <%= msPreviousYear %>;
        var isReport       = <%= msTarget.equals("Printer") %>;

        //Estas dos variables son requeridas en el Script CallReportYum.js
        var loGrid    = new Bs_DataGrid('loGrid');
        var gaDataset = parent.gaDataset;
        </script>


    </head>

    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" onLoad="initDataGrid(giCurrentYear, giCurrentPeriod, isReport)">

    <jsp:include page="/Include/GenerateHeaderYum.jsp">
        <jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <table width="99%" border="0" align="center" cellspacing="6">
        <tr>
            <td>
                <b class="datagrid-leyend">A&ntilde;o: <%= lsYearToData %>, Periodo: <%= lsPeriodToData %></b>
            </td>
        </tr>
        <tr>
            <td>
                <div id="goDataGrid"></div>
                <br>
            </td>
        </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>