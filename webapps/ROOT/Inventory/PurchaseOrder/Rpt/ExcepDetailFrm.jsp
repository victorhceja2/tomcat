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
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@page import="java.util.*, java.io.*, java.text.*;"%>
<%@ include file="../Proc/ExcepLibYum.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils(); 
	DateFormat dateFormat;
	Date excepDate;
	String msDocNum, msResponsible;
	String msExcepId;
	String msMessage;
	String msTarget;
	String msType;
	String msExcepDate;
	String msCSSFile;
	boolean mbPrinter;
%>

<%
    try{

		dateFormat     = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
		msTarget       = request.getParameter("hidTarget");
		
		msExcepId   = request.getParameter("hidExcepId");
		msType         = request.getParameter("hidTransferType");

		msResponsible   = request.getParameter("hidResponsible");
		msDocNum         = request.getParameter("hidDocNum");

		excepDate   = dateFormat.parse(getExcepDate(msExcepId));
		dateFormat     = new SimpleDateFormat("EEEE, MMMM dd, yyyy. kk:mm:ss");
		msExcepDate = dateFormat.format(excepDate);

		msMessage	   = "Confirmaci&oacute;n de la Excepcion";	

        	msCSSFile      = "/CSS/DataGridReport"+msTarget+"Yum.css";

		msMessage     += " Transferencia de " + (msType.equals("input") ? "Entrada" : "Salida");
    }
    catch(Exception e)
	{
		System.out.println("Exception ... " + e);
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

        <script src="../Scripts/ExcepPreviewYum.js"></script>

        <script type="text/javascript">
		    var laDataset     = <%= moAbcUtils.getJSResultSet(getQueryReport(msExcepId)) %>;
    		var lsTransferMsg = 'Cantidades transferidas';
            var printerDialog = <%= mbPrinter %>;
            var lsTarget = '<%= msTarget %>';
        </script>
        <script type="text/javascript">

	function executeReportCustom(){
		parent.printer.focus(); parent.printer.print();
	}

	function hideWaitMessage(){
		if (parent) {
			if (typeof parent.hideWaitMessage == 'function') {
				parent.hideWaitMessage();
			}
		} 
	}

        function showPrinterDialog(){
		if(lsTarget == 'Preview'){
			hideWaitMessage();
            		if(printerDialog == true){
                		if(confirm("Desea imprimir esta excepcion?")){
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
                Centro de contribuci&oacute;n:
			</td>
			<td width="80%" class="descriptionTabla">
				<b><%= getUnit() %>&nbsp;<%=getUnitName()%></b>
			</td>
		</tr>
		<tr>
			<td width="20%" class="descriptionTabla" nowrap>
                		N&uacute;mero de documento:
			</td>
			<td width="80%" class="descriptionTabla">
				<b><%=msDocNum%></b>
			</td>
		</tr>
		<tr>
			<td width="20%" class="descriptionTabla" nowrap>
                		Capturada por:
			</td>
			<td width="80%" class="descriptionTabla">
				<b><%=msResponsible%></b>
			</td>
		</tr>
		<tr>
		<td class="descriptionTabla" nowrap>
                Fecha de realizaci&oacute;n:
			</td>
			<td class="descriptionTabla">
				<b><%= msExcepDate %></b>
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
	String getQueryReport(String psExcepId)
	{
		return getExcepDetailQuery(false, psExcepId,true); //false: NO de la tabla de paso
	}
%>
