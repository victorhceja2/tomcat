<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
########################################################################################
# Nombre Archivo : ShowRecepFrmYum.jsp                                                 #
# Compania       : Yum Brands Intl                                                     #
# Autor          : Eduardo Zarate (laliux)                                             # 
# Objetivo       : Muestra el detalle de una recepcion                                 #
# Fecha Creacion : 16/Feb/05                                                           #
# Inc/requires   : ../Proc/PurchaseOrderLibYum.jsp                                     #
# Modificaciones :
# Observaciones  : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer #
#                  uso de los metodos en la libreria PurchaseOrderLibYum.jsp           #
########################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>

<%! AbcUtils moAbcUtils = new AbcUtils(); %>  
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>

<%
    String msDocumentNum="";
    String msRecepId="";
    String msResponsible="";
    String msCSSFile;
    String msTarget;
    String msReferer;
    String msForward;
    String msTitle;
    boolean mbPrinter;
    boolean mbRepDiff;

    try{
        msReferer      = request.getParameter("referer");
        msDocumentNum  = request.getParameter("docNum");
        msTarget       = request.getParameter("hidTarget");
        msRecepId      = request.getParameter("recepId");
        msResponsible  = getRecResponsible(msDocumentNum, msRecepId);

        msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";

    }
    catch(Exception e)
    {
        msTarget  = "Preview";
        msCSSFile = "/CSS/DataGridReportPreviewYum.css";
        msReferer = "Unknown";
    }
System.out.println("msReferer:"+msReferer);
    if(msReferer.startsWith("ShowOrders"))
    {
        msTitle   = "Consulta de recepci&oacute;n";
        mbPrinter = false;
        mbRepDiff = false;
    }
    else 
        if(msReferer.startsWith("RecepConfirm"))
        {
            msTitle   = "Confirmaci&oacute;n de recepci&oacute;n";
            mbPrinter = true;
            mbRepDiff = true;
        }
        else
        {
            msTitle = "Recepci&oacute;n";
            mbPrinter = false;
            mbRepDiff = false;
        }

    if(msReferer.startsWith("ShowForward"))
    {
        msTitle   = "Consulta de reenvios";
        mbPrinter = false;
        mbRepDiff = false;
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader(msTitle,msTarget);
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <title>Detalle del pedido</title>
        <link rel='stylesheet' type='text/css' href="/CSS/GeneralStandardsYum.css">
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>

        <script language="javascript" src='/Scripts/ReportUtilsYum.js'></script>
        <script language="javascript" src='/Scripts/AbcUtilsYum.js'></script>
        <script language="javascript" src='/Scripts/HtmlUtilsYum.js'></script>

        <!-- deshabilita el "right-click" del mouse-->
        <script language="javascript" src='/Scripts/ProtectPageYum.js'></script>

        <script language="javascript" src="/Scripts/MiscLibYum.js"></script>
        <script language="javascript" src="/Scripts/DataGridClassYum.js"></script>

        <script language="javascript">


        var loGrid = new Bs_DataGrid('loGrid');
        var printerDialog = <%= mbPrinter %>;
        var lsTarget = '<%= msTarget %>';

        function initDataGrid()
        {        
            loGrid.bHeaderFix = false;
            loGrid.isReport   = true;
            loGrid.padding    = 4;
            laDataset         = parent.gaDataset;
        
            if(laDataset.length > 0)
            {
                laHeaders  = new Array(
                     {text:'&nbsp;',width:'2%', sort: false},
                     {text:'C&oacute;digo producto',width:'10%', sort: false},
                     {text:'Producto', width:'24%', sort: false},
                     {text:'Cantidad recibida', width:'10%', sort: false},
                     {text:'Discrepancia', width:'14%', sort: false},
                     {text:'Reenvio', width:'8%', sort: false},
                     {text:'Unidad Inv', width:'14%', sort: false},
                     {text:'Precio unit', width:'8%', sort: false},
                     {text:'Subtotal', width:'10%', sort: false} );

                loGrid.setHeaders(laHeaders);
                loGrid.setData(laDataset);
                loGrid.drawInto('goDataGrid');
            }
        }

        function showPrinterDialog()
        {
            if(lsTarget == 'Preview')
            {
                  parent.hideWaitMessage();

                if(printerDialog == true)
                {    
                    if(confirm("Su recepcion ha sido terminada. \n\n Desea imprimir su comprobante?"))
                        {
                        parent.printer.focus();
                        parent.printer.print();
                    }
                }
            }
            parent.preview.focus();
        }

        /* Cancelacion de los eventos del teclado.
        Para evitar que hagan un alt+flecha izquierda e ir
        a la pagina anterior. */

        function cancelKeyEvents(e)
        {
            return false;
        }

        document.onkeypress = cancelKeyEvents;

        </script>
    </head>
    
    <body bgcolor="white" style="margin-left: 0px; margin-right: 0px" 
          onLoad="initDataGrid(); setTimeout('showPrinterDialog()', 2000)">
    <jsp:include page="/Include/GenerateHeaderYum.jsp"/>
    
    <table width="99%" border="0" align="center" cellspacing="5">
        <tr>
            <td class="descriptionTabla" width="10%" nowrap>
                Centro de contribuci&oacute;n:
            </td>
            <td class="descriptionTabla" width="90%">
                <b> <%=getStore()%>&nbsp;<%=getStoreName()%> </b>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                No. de Recepcion:
            </td>
            <td class="descriptionTabla">
                <b><%= msRecepId %></b>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                Nmero de documento: 
            </td>
            <td class="descriptionTabla">
                <b><%= msDocumentNum %></b>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                Capturada por:
            </td>
            <td class="descriptionTabla">
                <b><%= msResponsible %></b>
            </td>
        </tr>
    <%
    String lsContDiff = getDiffCount(msRecepId);
    %>
        <% if(mbRepDiff == true && msTarget.equals("Preview") && !lsContDiff.equals("0")) { %>
        <tr>
            <td colspan="2" align="right" class="descriptionTabla">
                <a href="javascript: openWindow('RecepDiffYum.jsp?hidRecep=<%= msRecepId %>','diff',800,600)">Ver reporte de diferencias</a>
            </td>
        </tr>
    <% } %>
        <tr>
            <td colspan="2">
                <br>
               <div id="goDataGrid"></div>
            </td>
        </tr>
    <tr>
        <td class="detail-desc" colspan="2"><%@ include file='/IncomeAndExpense/Semivariable/Entry/mensaje.jsp' %></td>
    </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!
String getDiffCount(String psRecep){
    String lsQuery = "";
    AbcUtils moAbcUtils = new AbcUtils();
    lsQuery += " SELECT count(*) from op_grl_difference where reception_id=" + psRecep;
    String lsContDiff=moAbcUtils.queryToString(lsQuery,"","");
    return(lsContDiff);
}
%>
