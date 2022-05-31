 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>
 
<%-- 
##########################################################################################################
    Document   : AssistanceDetailFrm
    Created on : 4/12/2012, 02:12:52 PM
    Author     : Erick Mejia - Strk
    Company    : PRB
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%!
    AbcUtils moAbcUtils = new AbcUtils(); 
    String msTarget;
    String msPrintOption;
    String noempl = "";
    String nombre = "";
    String eow = "";
    String sow = "";
%>
<%
    try{
        msTarget = request.getParameter("target");
        noempl = request.getParameter("noempl");
        eow = request.getParameter("endOfWeek");
        sow = request.getParameter("startOfWeek");
        
        nombre = getEmplName( noempl );
    }
	catch(Exception e){
        msTarget = "Preview";
    }

    if(msTarget.equals("Preview"))
        msPrintOption = "yes";
    else
        msPrintOption = "no";

    
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Asistencias semanales en biométrico", msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" href="/CSS/TabStandardsYum.css" type="text/css"/>
	<link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>
        
        <style>
            .tr_text{
                font-size:   11px;
                color: #000099;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                text-align: left;
            }
        </style>
        
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
	<script src="/Scripts/MathUtilsYum.js"></script>
	<script src="/Scripts/DataGridClassYum.js"></script>
	<script src="/Scripts/MiscLibYum.js"></script>
	<script src="/Scripts/StringUtilsYum.js"></script>
	<script src="/Scripts/HtmlUtilsYum.js"></script> 
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="../Scripts/AssistanceReportYum.js"></script>
        <script>
            function executeReportCustom(){
                parent.printer.focus(); parent.printer.print();
            }
            var loGridD    = new Bs_DataGrid('loGridD');
            var gaDataset = parent.gaDataset;
        </script>
    </head>
    <body bgcolor="white" onLoad="initDetailedDataGrid('msPrintOption');">
        <jsp:include page = "/Include/GenerateHeaderYum.jsp"/>
        <script src="/Scripts/TooltipsYum.js"></script>
		
        <table align="left" width="90%" border="0">
            <tr>
                <td class='tr_text' width="30%">No. Empleado</td>
                <td class='descriptionTabla' align="left"><%= noempl %></td>
            </tr>
            <tr>
                <td class='tr_text' width="30%">Nombre</td>
                <td class='descriptionTabla' align="left"><%= nombre %></td>
            </tr>
            <tr>
                <td class='tr_text' width="30%">Fechas del reporte</td>
                <td class='descriptionTabla' align="left">Del dia <%= sow %> al <%= eow %></td>
            </tr>
            <tr>
                <td colspan="2" align="left">
                    <div id="goDetailedDataGrid"></div>
                </td>
            </tr>
	</table>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!

    String getEmplName( String noEmpl )
    {
        String lsQuery;
        String lsData;
        lsQuery = "select last_name||' '||last_name||' '||name as emp_comp_name from pp_employees where emp_num='"+noEmpl+"'";
        lsData = moAbcUtils.queryToString( lsQuery );
        return lsData;
    }
   
%>
