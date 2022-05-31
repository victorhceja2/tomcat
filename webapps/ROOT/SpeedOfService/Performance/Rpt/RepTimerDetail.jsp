<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%-- 
    Document   : RepTimerDetail
    Created on : 12/04/2012, 11:32:33 AM
    Author     : emejia
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/RepTimerLib.jsp" %>   

<%! 
    AbcUtils moAbcUtils = new AbcUtils();
    String msPreviousYear;
    String msYear;
    String msPeriod;
    String msWeek;
    String msDay;
    String msTarget;
    String msCSS;
%>

<%
    try{
        msYear   = request.getParameter("year");
        msPeriod = request.getParameter("period");
        msWeek   = request.getParameter("week");
        msDay   = request.getParameter("day");
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
        msCSS = "/CSS/DataGridReportPrinterYum.css";
    }
    else
    {
        msCSS = "/CSS/DataGridDefaultYum.css";
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte de Autoexpress", msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSS %>" />

        <style>
            .subsec_text{
                font-size:   13px;
                color: #000099;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                text-align: left;
            }
            .avg_text{
                font-size:   11px;
                color: #000099;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                text-align: left;
            }
            .eff_text{
                font-size:   11px;
                color: #000099;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                text-align: center;
            }
        </style>
        
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <script src="../Scripts/RepTimer.js"></script>

        <script type="text/javascript">
        var giCurrentYear  = <%= msYear %>;
        var giDay  = <%= msDay %>;
        var giPreviousYear = <%= msPreviousYear %>;
        var isReport       = <%= msTarget.equals("Printer") %>;
        
        //Estas dos variables son requeridas en el Script RepTimer.js
        var loGrid    = new Bs_DataGrid('loGrid');
        var gaWindowDataset = parent.gaWindowDataset;
        var gaOrderDataset = parent.gaOrderDataset;
        var gaDeliveryDataset = parent.gaDeliveryDataset;
        var gaSumDataset = parent.gaSumDataset;
        
        </script>
    </head>
    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" onLoad="initDataGrid(giCurrentYear, giPreviousYear, isReport)">
        <jsp:include page="/Include/GenerateHeaderYum.jsp">
            <jsp:param name="psStoreName" value="true"/>
        </jsp:include>
        <table width="99%" border="0" align="center" cellspacing="6">
            <tr>
                <td>
                    <b class="datagrid-leyend">A&ntilde;o: <%= msYear %>, Periodo: <%= msPeriod %>, Semana: <%= msWeek %>, D&iacute;a: <%= msDay %></b>
                </td>
            </tr>
            
            <tr><td><br></td></tr>
            <tr><td class="subsec_text">Resumen de Rendimiento de Autoexpress</td></tr>
            <tr>
                <td>
                    <div id="goDataGridDrive"></div>
                    <br>
                </td>
            </tr>
            
            <tr><td><br></td></tr>
            <tr><td class="subsec_text">Toma Orden</td></tr>
            <tr>
                <td>
                    <div id="goDataGrid"></div>
                    <br>
                </td>
            </tr>
            <tr><td><br></td></tr>
            <tr><td class="subsec_text">Servicio</td></tr>
            <tr>
                <td>
                    <div id="goDataGridWin"></div>
                    <br>
                </td>
            </tr>
            <tr><td><br></td></tr>
            <tr><td class="subsec_text">Total</td></tr>
            <tr>
                <td>
                    <div id="goDataGridDelivery"></div>
                    <br>
                </td>
            </tr>
            
        </table>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
