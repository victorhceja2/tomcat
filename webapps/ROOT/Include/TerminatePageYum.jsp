<%--
##########################################################################################################
# Nombre Archivo  : TerminatePageYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : JSP general para terminación de reportes
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
    moHtmlAppHandler.setPresentation("");
    moHtmlAppHandler.initializeHandler();
%>

<script language = 'javascript'>
    if (opener) {
        if (typeof opener.hideWaitWindow == 'function') 
            opener.hideWaitWindow();
    } 
    else {
        //versión 2 embebida en V3
        if (typeof parent.hideWaitWindow == 'function') parent.hideWaitWindow();
        if (typeof parent.parent.hideWaitWindow == 'function') parent.parent.hideWaitWindow();
        if (typeof parent.hideWaitIfrWindow == 'function') parent.hideWaitIfrWindow();
        if (typeof parent.parent.hideWaitIfrWindow == 'function') parent.parent.hideWaitIfrWindow();
        if (typeof top.hideWaitWindow == 'function') top.hideWaitWindow();
        if (typeof top.hideWaitIfrWindow == 'function') top.hideWaitIfrWindow();
 
        if (mbIsIE) { 
            top.frames['ifrDummy'].location.href = '/BlankYum.html';
            parent.frames['ifrDummy'].location.href = '/BlankYum.html';
        }
    }

</script>
