<%--
##########################################################################################################
# Nombre Archivo  : ValidateSession.jsp
# Compa�ia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : JSP para validar la sesi�n HtmlAppHandler
# Fecha Creacion  : 29/Enero/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page import="generals.*" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());

    if (moHtmlAppHandler==null) { 
        %>
            <jsp:forward page="/RedirectSessionYum.html"/>
        <%
        return;
    }
%>