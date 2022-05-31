<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CreditCardPasswd.jsp
# Compania        : Yum Brands Intl
# Autor           : Sergio Cuellar Valdes
# Objetivo        : Capturar usuario SUS y passwd para guardar cambios del cierre de lote
# Fecha Creacion  : 15/Mayo/2009
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
    String txtNoEmpl = "";
    String Pantalla = "";

    String bdate  = "";
    String nRows  = "";
    String query  = "";
    String totCC  = "";
    String totSUS = "";
    String Add	  = "";
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
    moHtmlAppHandler.msReportTitle = getCustomHeader("Mantenimiento de empleados", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    Pantalla = request.getParameter("Pantalla");
    Add = request.getParameter("Add");

    boolean val = false;
    
    if( Pantalla.equals("FMS") ){
        val = saveTmpFMS( request );
    }else{
        val = saveTmpSUS( request );
    }
    
    txtNoEmpl = request.getParameter("txtNoEmpl");
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
            function validate() {
                if(document.frmGrid.cmbUserSus.value == "") {
                    alert("Seleccione un Usuario.");
                    return false;
                }
                if(document.frmGrid.txtPassword.value == ""){
                    alert("Ingrese el Password.");
                    return false;
                }
                //var emplll = "<%=txtNoEmpl%>";
                //addHidden(document.frmGrid,'emp_num', emplll );
                document.frmGrid.txtPassword.value = document.frmGrid.txtPassword.value.toUpperCase();
                document.frmGrid.submit();
            }

        </script>
    </head>

    <body bgcolor="white">

        <form name="frmGrid" id="frmGrid" method="post" action="EmployeeCheckPasswd.jsp">
            <%if (Pantalla.equals("FMS")){%>
            	<input type="hidden" name="Pantalla" value="FMS"/>
            <%}else{%>
            	<input type="hidden" name="Pantalla" value="SUS"/>
            <%}%>
            <%if (Add!=null){%>
            	<input type="hidden" name="Add" value="true"/>	
            <%}%>
            <input type="hidden" name="emp_num" value="<%=txtNoEmpl%>"/>
        <table align="left" style="width: 384px;" width="90%" border="0">
	<tr class="bsTotals">
	    <td class="descriptionTabla" colspan="2">
                <h2>Necesitas permisos gerenciales para hacer modificaciones.</h2>
                <h3>Por favor, ingresa tu password del toma &oacute;rdenes.</h3>
            </td>
	</tr>
	<tr class="bsTotals">
	    <td class="descriptionTabla">
	        Usuario SUS: 
	    </td>
	    <td>
	    <select id = 'cmbUserSus' name ='cmbUserSus' size = '1' class ='combos'>
	        <option value="">-- Seleccione --</option>
		<%
		   moAbcUtils.fillComboBox(out,"SELECT emp_num, sus_id FROM pp_employees WHERE sus_id <> 'NULL' AND sus_pass <> 'NULL' AND sus_id <> 'UNKN' AND security_level='01' ORDER BY sus_id");
		%>
	    </select>
	    </td>
	</tr>
	<tr class="bsTotals">
	    <td class="descriptionTabla">
	        Password:
	    </td>
	    <td class="descriptionTabla">
	        <input type='password' name='txtPassword' size='12' maxlength='8'>
	    </td>
	</tr>
        <tr>
            <td style="width: 203px;">
                <input type="button" value="Aceptar" onClick="validate()"/>
                <input type="button" value="Regresar" onClick="javascript:history.back();"/>
            </td>
        </tr>
        </table>
        </form>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

