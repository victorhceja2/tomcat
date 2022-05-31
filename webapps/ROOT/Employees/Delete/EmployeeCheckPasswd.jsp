<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CreditCardCheckPasswd.jsp
# Compania        : Yum Brands Intl
# Autor           : Sergio Cuellar Valdes
# Objetivo        : Verificar Passwd y guardar archivo
# Fecha Creacion  : 18/Mayo/2009
# Inc/requires    : 
# Observaciones   : 
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@page import="java.util.*" %>
<%@page import="java.io.*" %>
<%@page import="generals.*" %>

<%! 
    AbcUtils moAbcUtils;
    String user   = "";
    String passwd = "";
    String noempl = "";
    String usuValid = "";
%>

<% 
    moAbcUtils = new AbcUtils();
%>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Edit/Proc/EmployeeLib.jsp" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Mantenimiento de Empleados", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    user    = request.getParameter("cmbUserSus");
    passwd  = request.getParameter("txtPassword");
    noempl  = request.getParameter("emp_num");
    
    String user_id = getUserValid(user, passwd);
    if(!(user_id.equals(""))) {
         usuValid = "1";
         saveChangesFromDB(user_id);
    }else {
         usuValid = "0";
    }
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        
        <script type="text/javascript">
            var no_empl = "<%= noempl %>";
        </script>
        
    </head>

    <body bgcolor="white">

        <% if(usuValid.equals("1")) { %>
        <script type="text/javascript">
            alert("Ya se dieron de baja los empleados seleccionados.");
	    window.close();
	    window.opener.document.location.reload();
        </script>
        <% } else { %>
        <script type="text/javascript">
            alert("Password incorrecto. Recuerda que es tu password del toma ordenes.");
            history.back();
        </script>
        <% } %>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

