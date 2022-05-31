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
    String pantalla = "";
    
    String usuValid = "";
    String bdate = "";
    String bdate_ = "";
    String dataSet = "";
    String add = "";
%>

<% 
    moAbcUtils = new AbcUtils();
%>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/EmployeeLib.jsp" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Cierre Lote de Tarjetas de Cr&eacute;dito", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    user    = request.getParameter("cmbUserSus");
    passwd  = request.getParameter("txtPassword");
    noempl  = request.getParameter("emp_num");
    
    pantalla = request.getParameter("Pantalla");
    
    add = request.getParameter("Add");
	int ret=-1;
    
    String user_id = getUserValid(user, passwd);
    if(!(user_id.equals("")) && add==null) {
    //if( pantalla.equals("SUS") ) {
         usuValid = "1";
         saveChangesFromDB( noempl, pantalla );
         //saveChangesFromDB( noempl );
    }else if(!(user_id.equals(""))){
    	usuValid = "2";
    	ret=addEmployeetoDB( noempl );
    }else {
         usuValid = "0";
    }

    //System.out.println("usuValid= "+usuValid);

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
            alert("Empleado " + no_empl + " actualizado.");
            parent.allDelete();
        </script>
        <% } else if(usuValid.equals("2")){
        	if(ret==0){%>
	        	<script type="text/javascript">
       				alert("Empleado " + no_empl + " agregado. ");
           			location.replace("../../Add/EmployeeAddEntry.jsp");
        		</script>
        	<%}else if(ret==1){%>
        		<script type="text/javascript">
       				alert("ERROR: El empleado " + no_empl + " ya existe.");
           			history.back();
        		</script> 
        	<%}else{%>
        		<script type="text/javascript">
       				alert("ERROR: Empleado " + no_empl + " NO agregado.");
           			history.back();
        		</script> 
        	<%}%>
        <% } else { %>
        <script type="text/javascript">
            alert("Password incorrecto. Recuerda que es tu password del toma ordenes.");
            history.back();
        </script>
        <% } %>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

