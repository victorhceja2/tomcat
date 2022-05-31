 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : OrderDetailFrm.jsp
# Compañia        : Yum Brands Intl
# Autor           : MCHA
# Objetivo        : Muestra el detalle de Orden.
# Fecha Creacion  : 10/Jul/2009
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>   

<%! AbcUtils moAbcUtils = new AbcUtils(); 
    String msTarget;
    String msPrintOption;
    String msFech = "";
    String msSeq = "";
%>
<%
    try{
        msTarget = request.getParameter("target");
        msFech   = request.getParameter("fecha");
        msSeq    = request.getParameter("sequence");
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
    moHtmlAppHandler.msReportTitle = getCustomHeader("Detalle Orden", msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" href="/CSS/TabStandardsYum.css" type="text/css">
        <link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>
                
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script> 
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="../Scripts/EmplMealReportYum.js"></script>
        <script>
            function executeReportCustom(){
                parent.printer.focus(); parent.printer.print();
            }
 
            var loGrid    = new Bs_DataGrid('loGrid');
            var gaDataset = parent.gaDataset;
        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGridSub('msPrintOption');">
        <jsp:include page = "/Include/GenerateHeaderYum.jsp"/>
        <script src="/Scripts/TooltipsYum.js"></script>
        
        <table align="left" width="98%" border="0">
        <tr>
            <td class='descriptionTabla' align="left">
                Fecha de Compra: &nbsp; <%=msFech%>
            </td>
        </tr>
        <tr>
            <td class='descriptionTabla' align="left">
                Ticket numero: &nbsp; <%=msSeq%>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="left">
                <div id="goDataGrid"></div>
            </td>
        </tr>
        </table>
    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
