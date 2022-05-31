<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : InvoiceQueryYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : EZ
# Objetivo        : Reportes de facturas
# Fecha Creacion  : 20/MAyo2005
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
    String msPrintOption;

    try
    {
        msTarget   = request.getParameter("target");
        if(msTarget.equals("Preview"))
            msCSSFile = "/CSS/DataGridDefaultYum.css";
        else
            msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";
    }
    catch(Exception e)
    {
        msTarget  = "Preview";
        msCSSFile = "/CSS/DataGridDefaultYum.css";
    }

    if(msTarget.equals("Preview"))
        msPrintOption = "yes";
    else
        msPrintOption = "no";


    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = "Reportes de facturas";
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
                mheaders = new Array({text: parent.getReportHeader(parent.giReportType), colspan: '7', align: 'left', hclass: 'empty'});

                headers  = new Array(
                         {text:'Proveedor ',width:'20%'},
                         {text:'Subcuenta', width:'25%'},
                         {text:'Fecha',  width:'8%'},
                         {text:'No.Factura', width:'7%'},
                         {text:'Importe sin iva ', width:'13%', align: 'right'},
                         {text:'Iva', width:'7%', align: 'right' },
                         {text:'Descripci&oacute;n', width:'20%'}
                         );

                links    = new Array( null, null, null,
                         {key:3, baseUrl:'InvoiceDetailYum.jsp?noteId='}, 
                         null, null, null );
    
                props    = new Array( null, null, null,
                         {onclick:'loGrid.openlink', param1: 600, param2: 460},
                         null, null, null);

                tooltips = new Array(
                         null,
                         null,
                         null,
                         {text: 'Ver detalle de la factura [3]', width: 100},
                         null,
                         null,
                         null);
                         
				loGrid.setMainHeaders(mheaders);
                loGrid.setHeaders(headers);
                loGrid.setDataProps(props);
                loGrid.setLinks(links);
                loGrid.setTooltips(tooltips);

                var data = new Array();
                for(i=0; i<laDataset.length; i++)
                {
                    data = data.concat(laDataset[i]);
                    //subtotal = arraySubtotal(laDataset[i][0]);
                    //alert(subtotal);
                }

				loGrid.setData(data);

                loGrid.drawInto('goDataGrid');
            }
            else
                if(lsTarget=='Preview') showErrorMsg(parent.getReportErrorMsg(parent.giReportType));
        }

        function arraySubtotal(dataRows)
        {
            var arr = new Array('','','','',0,'','');
            for(i=0; i<dataRows.length; i++)
            {
                var row = dataRows[i];
                arr[4] = arr[4] + row[4];
            }
            return arr;
           
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
    <jsp:include page = '/Include/GenerateHeaderYum.jsp' >
        <jsp:param name = 'psPrintOption' value = '<%= msPrintOption %>'/>
    </jsp:include>
        <script src="/Scripts/TooltipsYum.js"></script>

        <table align="center" width="98%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                Centro de contribuci&oacute;n: 
            </td>
            <td class="descriptionTabla" width="85%">
                <b><%=getStore()%>&nbsp;<%=getStoreName()%></b>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <br>
                <div id="goDataGrid"></div>
                <br><br>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <div class="subHeadB" id="errorMsg"></div>
            </td>
        </tr>
        </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
