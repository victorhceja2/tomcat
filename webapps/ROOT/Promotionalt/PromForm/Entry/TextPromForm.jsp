<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TextPromForm.jsp
# Compania        : Yum Brands Intl
# Autor           : Mario Chavez
# Objetivo        : Contenedor principal de la pantalla de captura de volanteo  
# Fecha Creacion  : 24/febrero/2006
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
%>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Captura de Volanteo";
	String msOperation ="";
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

        function adjustPageSettings() {
            adjustContainer(60,165);
        }

        function showHideControls(){
	        showHideControl('divTransferCtrls','hidden');
        }

        function loadFirstTab()
        {
            showHideControls();
			validOption(1);
    	}

        function validOption(psTab)
        {
            switch (psTab){
                    case 1: 	
		                browseDetail('TextPromFormDetail.jsp','TextPromForm.jsp','1');
                  	break;
            }
		
        }
        function validateSearch() {
        	return(true);
        }

		function executeReportCustom(){
		   ifrDetail.focus();
		   ifrDetail.print();
		}

		function allDelete(){
           ifrDetail.document.frmGrid.reset();
		}

        </script>
    </head>
    <body bgcolor="white" OnLoad="loadFirstTab();">
      <%if(msPresentation.equals("VIEWPORT")){ %>
        <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
        <jsp:param name="psStoreName" value="true"/>
        <jsp:param name = 'psPrintOption' value = 'yes'/>
        </jsp:include>
      <% } else { %>
        <jsp:include page ='/Include/GenerateHeaderYum.jsp'/>
      <% } %>
    <form id="frmMaster" name="frmMaster" method="post" target="ifrDetail">
    <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
    <input class='combos' type='button' name='Borrar' id='Borrar' value='Borrar' onClick="allDelete();">
    <table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
    	<tr valign="top">
        <td width="100%" height="100%">
                <div class="simpleBorder">
                    <div class="tabIframeWrapper">
                        <iframe class='tabContent' name='ifrDetail' width="100%" height="450" id='ifrDetail' frameBorder='0'></iframe>
                    </div>
                </div>
        </td>
    	</tr>
    </table>
	</form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
</html>

