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
    ArrayList<String[]> empleados = new ArrayList<String[]>();
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
    moHtmlAppHandler.msReportTitle = getCustomHeader("Depuracion de empleados", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    boolean val = false;

    empleados=readAllEmplFMS();
    addToEmplBD(empleados);

    txtNoEmpl = request.getParameter("empl");
    
    val = saveTmpDel(txtNoEmpl);
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
                document.frmGrid.txtPassword.value = document.frmGrid.txtPassword.value.toUpperCase();
                document.frmGrid.submit();
            }

	    function cancel(){
		for ( var i = 0; i < window.opener.document.frmSelection.getElementsByTagName("input").length ; i++ ){
                        window.opener.document.frmSelection.getElementsByTagName("input")[i].disabled=false;
                }
	    }

	    function closeWin(){
		window.close();
		cancel();
	    }

    	    window.onunload = unloadPage;

    	    function unloadPage(){
		cancel();
    	    }
	
	   window.onload = onloadPage;
	
           function onloadPage(){
		for ( var i = 0; i < window.opener.document.frmSelection.getElementsByTagName("input").length ; i++ ){
			window.opener.document.frmSelection.getElementsByTagName("input")[i].disabled=true;
		}
           }


        </script>
    </head>

    <body bgcolor="white">

        <form name="frmGrid" id="frmGrid" method="post" action="EmployeeCheckPasswd.jsp">
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
		<input type="button" value="Cancelar" onClick="closeWin()"/>
            </td>
        </tr>
        </table>
        </form>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

