<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransferDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Muestra el detalle (reporte) de una transferencia.
# Fecha Creacion  : 11/Julio/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ include file="../Proc/TransferLibYum.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils(); 
	AplicationsV2 logApps = new AplicationsV2();
	DateFormat dateFormat;
	Date transferDate;

	String msLocalStore;
	String msRemoteStore;
	String msTransferId;
	String msMessage;
        String msTarget;
	String msType;
	String msTransferDate;
	String msCSSFile;
    boolean mbPrinter;
%>

<%
    try{

		dateFormat     = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
		msTarget       = request.getParameter("hidTarget");
		msTransferId   = request.getParameter("hidTransferId");
		logApps.writeInfo("\nmsTransferId en TransferDetailFrm.jsp: " + msTransferId);
		msType         = request.getParameter("hidTransferType");

		msLocalStore   = msType.equals("input")?getLocalStore(msTransferId):getRemoteStore(msTransferId);
		msRemoteStore  = msType.equals("input")?getRemoteStore(msTransferId):getLocalStore(msTransferId);
		
		logApps.writeInfo("\ntransferDate: " + getTransferDate(msTransferId));

		transferDate   = dateFormat.parse(getTransferDate(msTransferId));
		dateFormat     = new SimpleDateFormat("EEEE, MMMM dd, yyyy. kk:mm:ss");
		msTransferDate = dateFormat.format(transferDate);

		msMessage	   = "Confirmaci&oacute;n";	

        msCSSFile      = "/CSS/DataGridReport"+msTarget+"Yum.css";

		msMessage     += " Transferencia de " + (msType.equals("input") ? "Entrada" : "Salida");
    }
    catch(Exception e)
	{
		logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }

    if(msTarget.equals("Printer"))
        mbPrinter = false;
    else
        mbPrinter = true;

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader(msMessage, msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
    
        <script src="../Scripts/TransferPreviewYum.js"></script>

        <script type="text/javascript">
		    var laDataset     = <%= moAbcUtils.getJSResultSet(getQueryReport(msTransferId)) %>;
    		var lsTransferMsg = 'Cantidades transferidas';
            var printerDialog = <%= mbPrinter %>;
            var lsTarget = '<%= msTarget %>';
        </script>
        <script type="text/javascript">

        function executeReportCustom()
        {
            parent.printer.focus(); parent.printer.print();
        }

		function hideWaitMessage()
		{
	    	if (parent) {
		        if (typeof parent.hideWaitMessage == 'function') 
				{
        	        parent.hideWaitMessage();
				}
   			} 
		}
        
        function showPrinterDialog()
        {
			if(lsTarget == 'Preview')
			{
          		hideWaitMessage();

            	if(printerDialog == true)
				{	
                	if(confirm("Desea imprimir esta transferencia?"))
               	 	{
                	    parent.printer.focus();
                    	parent.printer.print();
                	}
				}
			}
            parent.preview.focus();
        }

        </script>
    </head>

    <body bgcolor="white" 
        onLoad="initDataGrid('<%= msType %>'); setTimeout('showPrinterDialog()', 2000)">
	    <jsp:include page="/Include/GenerateHeaderYum.jsp"/>

        <table width="99%" border="0" align="center" cellspacing="6">
		<tr>
			<td width="20%" class="descriptionTabla" nowrap>
                Centro de contribuci&oacute;n origen:
			</td>
			<td width="80%" class="descriptionTabla">
				<b><%= msRemoteStore %></b>
			</td>
		</tr>
		<tr>
			<td class="descriptionTabla" nowrap>
                Centro de contribuci&oacute;n destino:
			</td>
			<td class="descriptionTabla">
				<b><%= msLocalStore %></b>
			</td>
        </tr>
		<tr>
			<td class="descriptionTabla" nowrap>
                Fecha de realizaci&oacute;n:
			</td>
			<td class="descriptionTabla">
				<b><%= msTransferDate %></b>
			</td>
        </tr>
		</table>
        <table width="99%" border="0" align="center" cellspacing="6">
		<tr>
            <td>
                <br>
                <div id="goDataGrid"></div>
            </td>
        </tr>
        </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!
	String getQueryReport(String psTransferId)
	{
		return getTransferDetailQuery(false, psTransferId); //false: NO de la tabla de paso
	}
%>
