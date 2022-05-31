<!--
##########################################################################################################
# Nombre Archivo  : MessageYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - laliux
# Objetivo        : Pantalla en blanco para mostrar un mensaje.
# Fecha Creacion  : 18/Nov/2005
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################

-->

<%@ page import="generals.*" %>

<%
	
	String lsMessage = request.getParameter("hidMessage");
	String lsTitle   = request.getParameter("hidTitle");
	String lsSplit   = request.getParameter("hidSplit");

	if(lsMessage == null)
		lsMessage = "&nbsp";
	if(lsTitle == null)
		lsTitle = "Mensaje";
	if(lsSplit == null)
		lsSplit = "false";

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle  = lsTitle;
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <script src="/Scripts/AbcUtilsYum.js"></script>

    </head>

    <body bgcolor="white" onLoad="splitWindow(<%= lsSplit %>)">
	    <jsp:include page="/Include/GenerateHeaderYum.jsp" />

        <table align="center" width="50%" border="0">
        <tr>
			<td align="center" class="descriptionTabla" nowrap>
				<br><br>
				<br><br>
				<br><br>
				<div id="message" class="detail-cont"><%= lsMessage %></div>
            </td>
        </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
