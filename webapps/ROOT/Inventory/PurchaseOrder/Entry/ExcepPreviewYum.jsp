<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : ExcepPreviewYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sandra Castro
# Objetivo        : Mostrar los productos que se van a recibir. Se tiene que hacer la confirmacion.
# Fecha Creacion  : 09/oct/2006
# Inc/requires    : ../Proc/ExcepLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria ExcepLibYum.jsp
##########################################################################################################
--%>
<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>
<%@page import="java.util.*, java.io.*, java.text.*;"%>
<%@ include file="../Proc/ExcepLibYum.jsp" %>   

<%! 
    AbcUtils moAbcUtils = new AbcUtils(); 
    String msDocNum;
%>

<%
    try{
        msDocNum = request.getParameter("hidDocNum");
    }
    catch(Exception e){
        
    }
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Revisi&oacute;n Excepcion", "Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>

        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
    
        <script type="text/javascript">

        //Estas dos variables son requeridas en el Script ExcepPreviewYum.js
        var laDataset     = <%= moAbcUtils.getJSResultSet(getQueryReport(request)) %>;
        var lsTransferMsg = 'Cantidades a traspasar';

        function cancel()
        {
            doClosePreview('Excep');           
            window.close();
        }
       
        </script>

        <script src="../Scripts/ExcepLibYum.js"></script>
        <script src="../Scripts/ExcepPreviewYum.js"></script>
        <!-- Para tener control en el "doble-click" -->
        <script src='/Scripts/DoubleClickYum.js'></script>

    </head>

    	<body bgcolor="white" onLoad="initDataGrid(); resetFrame('Excep')">
        <jsp:include page="/Include/GenerateHeaderYum.jsp">
            <jsp:param name="psStoreName" value="true"/>
        </jsp:include>
	<form name="mainform" action="ExcepConfirmYum.jsp">
	<table width="99%" border="0" align="center" cellspacing="5">
		<tr>
		<td class=descriptionTabla width="10%" nowrap>Quien captura:</td>
		<td class="descriptionTabla">
            	<input type = "text" name = "txtResponsible" id="txtResponsible" size="30">
		<input type = "hidden" name = "hidDocNum" id="hidDocNum" value="<%=msDocNum%>">
            	</td>
		</tr>
	</table>
	<table align="center" width="98%" border="0">
        <tr>
            <td align="center" class="mainsubtitle">
                <br><br>
               &#191; Desea confirmar esta excepci&oacute;n  &#63; 
                <br><br>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                
                <input type="button" name="btnAceptar" value="Aceptar"
                    onclick="handleClick(event.type,'excepConfirm()');" 
                    ondblclick="handleClick(event.type,'excepConfirm()')">
                
                <input type="hidden" name="transfer" value="1">
                <input type="button" value="Cancelar" onClick="cancel()">
                
            </td>
        </tr>
        <tr>
            <td>
                <br>
                <div id="goDataGrid"></div>
                <br><br>
            </td>
        </tr>
        </table>
	</form>
    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!
    String getQueryReport(HttpServletRequest poRequest)
    {
        moAbcUtils.executeSQLCommand("DELETE FROM op_grl_step_exception", new String[]{});
	moAbcUtils.executeSQLCommand("DELETE FROM op_grl_step_exception_detail", new String[]{});
        insertItems(poRequest,msDocNum);

        return getExcepDetailQuery(true,true); //true: De la tabla de paso
    }
%>