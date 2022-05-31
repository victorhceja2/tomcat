 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
###########################################################################################
# Nombre Archivo  : ShowOrderFrmYum.jsp                                                      #
# Compania        : Yum Brands Intl                                                          #
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Muestra el detalle de una orden
# Fecha Creacion  :
# Inc/requires    : ../Proc/PurchaseOrderLibYum.jsp
# Modificaciones  :
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria PurchaseOrderLibYum.jsp
############################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>

<%! AbcUtils moAbcUtils = new AbcUtils(); %>
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>
  
<%
    String msOperation ="";
    String msTarget;
    String msOrderId;
    String msResponsible="";
    String msCSSFile="";
    String msReferer;
    String msTitle;
    String lsDateId;
    String lsDateLim;
    boolean mbPrinter;

    try{
        msReferer  = request.getParameter("referer");
        msTarget   = request.getParameter("hidTarget");
        msOrderId  = request.getParameter("orderId");

        msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";

    }catch(Exception e){
        msTarget  = "Preview";
        msOrderId = "";
        msReferer = "Unknown";
    }
        lsDateId = getOrdDateId(msOrderId);
        lsDateLim = getOrdDateLimit(msOrderId);


    if(msReferer.startsWith("ShowOrders"))
    {
        msTitle   = "Consulta de pedido";
        mbPrinter = false;
    }
    else 
        if(msReferer.startsWith("OrderConfirm"))
        {
            msTitle   = "Confirmaci&oacute;n de pedido";
            mbPrinter = true;
        }
        else
        {
            msTitle = "Pedido";
            mbPrinter = false;
        }
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader(msTitle,msTarget);
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }

%>

<html>
    <head>
        <title>Detalle de la orden</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>
    
        <script language="javascript" src='/Scripts/HtmlUtilsYum.js'></script>
        <script language="javascript" src='/Scripts/ReportUtilsYum.js'></script>
        <script language="javascript" src='/Scripts/AbcUtilsYum.js'></script>

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
            var laDataset     = parent.gaDataset;         

            if(laDataset.length > 0)
            {
                laHeaders  = new Array(
                     {text:'C&oacute;digo prod',width:'4%', sort: false},
                     {text:'Producto',width:'12%', sort: false},
                     {text:'Proveedor', width:'12%', sort: false},
                     {text:'Cantidad disponible', width:'7%', sort: false},
                     {text:'Pron&oacute;stico requerido', width:'5%', sort: false},
                     {text:'Producto en tr&aacute;nsito', width:'5%', sort: false},
                     {text:'Sugerido', width:'5%', sort: false},
                     {text:'Cantidad <br>requerida', width:'10%', sort: false},
                     {text:'Equiv Unidad Prov', width:'9%', sort: false},
                     {text:'Pedido Unidad Prov', width:'9%', sort: false},
                     {text:'Pedido Unidad Inv', width:'9%', sort: false},
                     {text:'Dif vs Sug', width:'6%', sort: false},
                     {text:'Costo', width:'6%', sort: false});

                loGrid.setHeaders(laHeaders);
                loGrid.setData(laDataset);
                loGrid.drawInto('goDataGrid');
            }
        }

        function endPage()
        {
            hideWaitMessage();
            setTimeout('showPrinterDialog()',1000);
        }
        
        function showPrinterDialog()
        {
			if(lsTarget == 'Preview')
			{
          		parent.hideWaitMessage();

	            if(printerDialog == true)
            	{                
        	        if(confirm("Su pedido ha sido terminado. \n\n Desea imprimir su comprobante?"))
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
          onLoad="initDataGrid(); setTimeout('endPage()',2000)">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
        <jsp:param name="psStoreName" value="true"/>
    </jsp:include>

        <table width="99%" border="0" align="center" cellspacing="5">
        <tr>
            <td class="descriptionTabla" width="10%" nowrap>
                N&uacute;mero de pedido:
            </td>
            <td class="descriptionTabla" width="90%">
                <b><%= msOrderId %></b>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                Fecha realizaci&oacute;n:
            </td>
            <td class="descriptionTabla">
                <!--<b><%= getOrdDateId(msOrderId) %></b>-->
                <b><%= lsDateId %></b>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                Fecha de confirmaci&oacute;n de poleo del pedido:
            </td>
            <td class="descriptionTabla">
                <b><%= getOrdDateLimit(msOrderId) %></b>
            </td>
        </tr>
<%
	String lsProviders = getOrdProviderId(msOrderId);
	String lsProviderPFS = "PFS";
	int indice= lsProviders.indexOf(lsProviderPFS);
        // Si las fechas son iguales y no es de PFS
        if(!lsDateId.substring(0,10).equals(lsDateLim) && indice == -1){

%>
	
	<tr>
            <td class="mainsubtitle">
                PEDIDO
            </td>
            <td class="mainsubtitle">
                ADELANTADO
            </td>
        </tr>
<%}%>
        <tr>
            <td colspan="2">
                <br>
                <div id="goDataGrid"></div>
            </td>
        </tr>
        </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
