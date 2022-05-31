
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : ITransferReportFrm.jsp
# Compania        : Yum Brands Intl
# Autor           : EZ
# Objetivo        : Reportes de transferencias de entrada
# Fecha Creacion  : 03/Octubre/2005
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>   
<%! AbcUtils moAbcUtils = new AbcUtils();  %>
<%
    String msTarget;
    String msCSSFile;
    String msTitle;

    try
    {
        msTarget = request.getParameter("hidTarget");

        msTitle  = "Reporte Confirmaci&oacute;n de Transferencias";

        if(msTarget.equals("Preview"))
            msCSSFile = "/CSS/DataGridDefaultYum.css";
        else
            msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";
    }
    catch(Exception e)
    {
        msTarget  = "Preview";
        msCSSFile = "/CSS/DataGridDefaultYum.css";
        msTitle   = "Reporte de Transferencias";
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader(msTitle, msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
    
        <script type="text/javascript">
        var loGrid   = new Bs_DataGrid('loGrid');

        var lsTarget = '<%= msTarget %>';

        function initDataGrid()
        {

            loGrid.bHeaderFix = false;
            loGrid.isReport   = false;
            loGrid.padding    = 4;

            var laDataset = parent.gaDataset;
           
            if(laDataset.length > 0)
            {
                mheaders = new Array({text: parent.getReportHeader(parent.giReportType), colspan: '8', align: 'left', hclass: 'empty'});

                headers  = new Array(
                         {text:'No de traspaso ',width:'10%', hclass:'left', bclass: 'left'},
                         {text:'Centro Vecino', width:'15%', hclass:'left', bclass:'left' },
                         {text:'Fecha de realizaci&oacute;n', width:'10%', hclass: 'right', bclass:'right'},
                         {text:'Tipo de traspaso', width:'10%', hclass: 'right', bclass:'right'},
                         {text:'Asociado responsable', width:'15%', hclass:'right', bclass:'right'},
                         {text:'Responsable vecino', width:'15%', hclass:'right', bclass:'right'},
                         {text:'Estado del traspaso', width:'10%', hclass:'right', bclass:'right'},
                         {text:'Raz&oacute;n del rechazo', width:'15%', hclass:'right', bclass:'right'}
                         );

                links    = new Array({key:0, baseUrl:'CTransferDetailYum.jsp?transferId='}, 
                         null, null, null );
    
                props    = new Array({onclick:'loGrid.openlink', param1: 900, param2: 600},
                         null, null, null);

                tooltips = new Array({text: 'Ver detalle de la transferencia [0]', width: 100},
                         null, null, null);
                         
                loGrid.setMainHeaders(mheaders);
                loGrid.setHeaders(headers);
                loGrid.setDataProps(props);
                loGrid.setLinks(links);
                loGrid.setTooltips(tooltips);

                loGrid.setData(laDataset);
                loGrid.drawInto('goDataGrid');
            }
            else
                if(lsTarget=='Preview') showErrorMsg(parent.getReportErrorMsg(parent.giReportType));
        }

        function showErrorMsg(psMsg)
        {
            document.getElementById("errorMsg").innerHTML = psMsg;
        }

        function executeReportCustom()
        {
            parent.printer.focus(); parent.printer.print();
        }

        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid()">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
        <jsp:param name="psStoreName" value="true"/>
    </jsp:include>
        <script src="/Scripts/TooltipsYum.js"></script>

        <table width="99%" border="0" align="center" cellspacing="5">
        <tr>
            <td colspan="2">
                <br>
                <div id="goDataGrid"></div>
            </td>
        </tr>
        </table>
        <table align="center" width="60%" border="0">
        <tr>
            <td colspan="2" align="center">
                <br><br>
                <div class="detail-cont" id="errorMsg"></div>
            </td>
        </tr>
        </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
