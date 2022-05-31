<%--
##########################################################################################################
# Nombre Archivo  : MainMenu.jsp
# Compania        : Premium Restaurant Brands
# Autor           : Erick Mejia (Stark)
# Descripcion     : 
# Fecha Creacion  : 01/Mar/2012
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>

<%@ include file="../Proc/EmployeeLib.jsp" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
        
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <script lang="text/javascript">
            var retval = <%= saveChangesFromDB(request)%>;
        
            function goBack(){
                if( retval == 0 ){
                    alert("Los cambios han sido guardados.");
                }else{
                    alert("Los cambios no han podido registrarse.");
                }
                parent.switchDisabledElement('btnAdd');
                parent.switchDisabledElement('cmbAsoc');
                parent.switchDisabledElement('btnCancel');
            }
        </script>
    </head>
    <body onLoad="goBack()" bgcolor="white">
        
    </body>
</html>
<%
    
%>