<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : OrderTriggerYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Disparador de Pedido sugerido
# Fecha Creacion  : 27/Septiembre/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="generals.*" %>
<%@page import="java.util.*, java.io.*, java.text.*"%>

<%! AbcUtils moAbcUtils = new AbcUtils(); %>
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>   

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Generador de Pedido sugerido";
%>

<html>
    <head>
        <title>Generador de Pedido sugerido</title>
        <div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
	<link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
    </head>

    <script src="/Scripts/AbcUtilsYum.js"></script>
    <script src="/Scripts/ReportUtilsYum.js"></script>
    <script src="/Scripts/CalendarYum.js"></script>

    <script>

        function adjustPageSettings() {
            adjustContainer(60,260);
        }

        function submitForm() {
        	if (document.frmMaster.txtDate.value == '') {
        		alert('Por favor introduzca una fecha valida');
        		document.frmMaster.txtDate.focus();
        		return(false);
        	}
		document.frmMaster.submit();
		opener.centerDivWaitGSO();
		opener.showHideControl('divWaitGSO','visible');
		window.close();
        }

    </script>

    <body onResize='adjustPageSettings();' bgcolor = 'white'  onload="showCalendar('frmMaster','txtDate','txtDate');if (opener) opener.blockEvents();" onUnload='if (opener) opener.unblockEvents();' >
        <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
        <br>
     	<form id = 'frmMaster' name = 'frmMaster' method = 'get' target = 'ifrProcess' action='../Proc/OrderTriggerLibYum.jsp'>
            <table border='0' cellspacing='0' cellpadding='0' width='80%' id='tblCourse'>
                <tr valign = 'top'>
                    <td class='descriptionTabla' >                    
        	            Fecha del pedido Sugerido:
                    </td>
                    <td>
                    	<input class = 'combos' type='text' id = 'txtDate' name='txtDate' size = '11' maxlength = '10' onclick="showCalendar('frmMaster','txtDate','txtDate');" onfocus="showCalendar('frmMaster','txtDate','txtDate');" readonly>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                    <td>
                        <input type='button' class = 'combos'  name='btnSubmit' value='Generar' onClick = 'submitForm();'>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>

<%  
loadWayProducts();
loadCurrentInvtranItems(true);
%>
