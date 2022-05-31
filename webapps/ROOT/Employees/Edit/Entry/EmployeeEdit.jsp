<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : MainMenu.jsp
# Compania        : Premium Restaurant Brands
# Autor           : Erick Mejia (Stark)
# Objetivo        : Reemplazo de pantalla de empleados de FMS
# Fecha Creacion  : 09/Ene/2012
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/EmployeeLib.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
        String msEmployee;
%>

<%
        HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
        moHtmlAppHandler.msReportTitle = "Registro de Empleados";
        String msOperation = "";
        msOperation = request.getParameter("hidOperation");
        
        String msPresentation = (msOperation==null)?"VIEWPORT":msOperation;
	moHtmlAppHandler.setPresentation(msPresentation);
	moHtmlAppHandler.initializeHandler();
%>

<html>
    <head>
        <title>Formato de captura</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
		<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
    	<link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/Chars.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="../Scripts/EmployeeBatch.js"></script>
                
        <script>

        var gaKeys = new Array('');
        var liRowCount=0;
	    var liRowCountRecep=0;
        var lsProductoCodeLst='';
	    var lsProductoCodeRecepLst='';
	    var msLastTab = '1';
        var gsStoreName = '';
	
        function printDetail() {
            executeDetail();
        }
        
        function validateSearch(){
            if (document.frmMaster.cmbAsoc.selectedIndex==0){
	            alert("Por favor, seleccione un asociado.");
                document.frmMaster.cmbAsoc.focus();
                return(false);
            }
            
            document.frmMaster.hidSuppSubAccNames.value = document.frmMaster.cmbAsoc.options[document.frmMaster.cmbAsoc.selectedIndex].text;
            return(true);
        }
        
        function adjustPageSettings() {
            adjustContainer(60,165);
        }

        function showHideControls(){
            showHideControl('divTransferCtrls','hidden');
        }

        function loadFirstTab(){
            if( document.frmMaster.cmbAsoc.selectedIndex == 0 ){
                alert("Por favor, seleccione un asociado.");
                document.frmMaster.cmbProv.focus();
                return(false);
            }
            document.frmMaster.btnAdd.disabled="true";
            document.frmMaster.btnCancel.disabled=false;
            validOption(1);
            document.frmMaster.cmbAsoc.disabled="true";
    	}

        function validOption(psTab){
            switch (psTab){
                case 1:
                    browseDetail('EmployeeEntry.jsp','EmployeeEdit.jsp','1');
                    break;
            }
        }
        
        function switchDisabledElement( nameelement ){
            var x = document.getElementById( nameelement );
            if( document.getElementById( nameelement ).getAttribute('disabled') ){
                x.removeAttribute('disabled');
            }else{
                x.setAttribute('disabled', true);
            }
        }
        
        function loadSUSTab() {
            if( document.frmMaster.cmbAsoc.selectedIndex == 0 ){
                alert("Por favor, seleccione un asociado");
                document.frmMaster.cmbAsoc.focus();
            }else{
                document.frmMaster.hidOperation.value = 'S';
                browseDetail("../Entry/EmployeeEntrySUS.jsp","../Entry/EmployeeEdit.jsp","2");
            }
	}
        
        function loadFMSTab() {
            if( document.frmMaster.cmbAsoc.selectedIndex == 0 ){
                alert("Por favor, seleccione un asociado,");
                document.frmMaster.cmbAsoc.focus();
            }else{
                document.frmMaster.hidOperation.value = 'S';
                browseDetail("../Entry/EmployeeEntry.jsp","../Entry/EmployeeEdit.jsp","1");
            }
	}
        
        function modifyRecordFMS(){
            if( document.frmMaster.cmbAsoc.selectedIndex == 0 ){
                alert("Por favor, seleccione un asociado.");
                document.frmMaster.cmbAsoc.focus();
                return(false);
            }
            document.frmMaster.hidOperation.value = 'S';
            switchDisabledElement('btnAdd');
            switchDisabledElement('btnCancel');
            document.frmMaster.submit();
            switchDisabledElement('cmbAsoc');
        }
        
        function allDelete(){
            document.frmMaster.hidOperation.value = null;
            document.frmMaster.cmbAsoc.selectedIndex = 0;
            switchDisabledElement("cmbAsoc");
            document.frmMaster.submit();
            switchDisabledElement("cmbAsoc");
            return false;
        }
        </script>
    </head>
    <body bgcolor="white">
        <%if(msPresentation.equals("VIEWPORT")){ %>
        <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
            <jsp:param name="psStoreName" value="true"/>
        </jsp:include>
        <% } else { %>
        <jsp:include page ='/Include/GenerateHeaderYum.jsp'/>
        <% } %>
            <input type='hidden' name='hidOperation' id='hidOperation' value='S' />
            
            <table border='0' cellspacing='0' cellpadding='0' width='100%' ID='tbl_title'>
            <tr>
                <td align='left'>
                    <form id = 'frmMaster' name = 'frmMaster' method = 'post' target='ifrDetail'  action = 'EmployeeEntry.jsp' onSubmit="return false;">
                        <input type='hidden' name='hidOperation' id='hidOperation' value='S'/>
                        <input type='hidden' name='hidSuppSubAccNames' id='hidSuppSubAccNames' value=''/>
                        <table id = 'tblCapture' border = 0>
			    <tr>
                                <td class = 'body'>
                                    Asociado:
                                </td>
                                <td>
                                    <select id = 'cmbAsoc' name = "cmbAsoc" size = '1' class = 'combos' onChange="loadFMSTab();">
				    <option value="-1"selected> -- Seleccione un Asociado -- </option>
                                        <%
                                            writeMenu(out, readEmplFMS());
                                        %>
                                    </select>
                                </td>
                                <td class = 'body'>
                                    &nbsp;&nbsp;
                                </td>
                            </tr>
                        </table>
                                    
                                    
                    </form>
                </td>
            </tr>
	</table>
                                    
            <table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
                <tr valign="top">
                    
                    <div class='tabBox' style='clear:both'>
                        <div class='tabArea'>
                            <a class='tab' id ='1' name='1' href = 'javascript:loadFMSTab();'>Actualizaci&oacute;n de datos FMS</a>
                            <a class='tab' id ='2' href = 'javascript:loadSUSTab();'>Actualizaci&oacute;n de datos SUS</a>
                        </div>
                        <div class='tabMain'>
                            <div class='tabIframeWrapper'>
                                <iframe class='tabContent' name='ifrDetail' width="100%" height="350" id='ifrDetail' frameBorder='0'></iframe>
                            </div>
                        </div>
                    </div>
                </tr>
            </table>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
