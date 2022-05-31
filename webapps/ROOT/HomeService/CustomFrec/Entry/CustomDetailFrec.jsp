<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : CustomDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Reporte Clientes Frecuentes 
# Fecha Creacion  : 28/Mar/2008
# Inc/requires    : ../Proc/CustomLibFrec.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria CustomLibfrec.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/CustomLibFrec.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msFrecId;
	String msDate;
	String msDataset;
	String msDateH;
	String msBase;
	String msPack;
	String msClient = "0";
	String msClientIn = "0";
	String msAgeb = "";
	String msStreet = "";
%>	

<%
	moAbcUtils = new AbcUtils();
    try{
		msFrecId   = request.getParameter("hidFrecu");

		if(msFrecId.indexOf("m") >= 0){
			msFrecId = msFrecId.replace('m','>');
		}
		else if(msFrecId.indexOf("i") >= 0){
			msFrecId = msFrecId.replace('i','=');
		}

		msDate     = request.getParameter("hidDate");
		if(msDate.equals("") || msDate.equals(null)){
			msDate = "31/10/2006";
		}
		msDateH    = request.getParameter("hidDateH");
		if(msDateH.equals("") || msDateH.equals(null)){
			msDateH = "31/10/2006";
		}
		msBase = request.getParameter("hidBase");
		if(msBase.equals("")){
			msBase = "ALL";
		}
	
		msPack = request.getParameter("hidPack");
		if(msPack.equals("")){
			msPack = "ALL";
		}
		
		msAgeb  = request.getParameter("hidAgeb");
		msStreet = request.getParameter("hidStreet");
		msStreet   = msStreet.replace('_',' ');
	}
    catch(Exception e){
		System.out.println("CustomDetail.jsp ... " + e);
    }
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte Clientes", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

	msDataset = "new Array()";
	if(!(msFrecId.equals("0"))){
		msDataset = getDataset(msFrecId, msDate, msDateH, msBase, msPack, msAgeb, msStreet);
		msClientIn = getRescli(msFrecId, msDate, msDateH, msBase, msPack, msAgeb, msStreet);
		msClient = getClients();

		if(!(msStreet.equals("ALL"))){
			droptbfrectemp();
		}
	}
	else{
		msClient = "0";
		msClientIn = "0";
	}
	
%>

<html>
	<head>
    	<link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
		<script src="../Scripts/CustomLibFrec.js"></script>
		<!--<script src="../Scripts/CustomDetailFrec.js"></script>-->
        <script type="text/javascript">
			var gaDataset = <%= msDataset %>;

			function executeReportCustom(){
				window.open("./CustomPrint.jsp?hidFrecu=<%=msFrecId%>&hidDate=<%=msDate%>&hidDateH=<%=msDateH%>&hidBase=<%=msBase%>&hidPack=<%=msPack%>&hidAgeb=<%=msAgeb%>&hidStreet=<%=msStreet%>", "Impresion Reporte","width='10px', height='10px',left='35px', top='20px'");
			}	            

		</script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(); parent.hideWaitMessage();" style="margin-left: 4px; margin-right: 0px">
        <script src="/Scripts/TooltipsYum.js"></script>
        <script src="/Scripts/FixedTooltipsYum.js"></script>
		<form name="frmGrid" id="frmGrid" method="post">
        	<table align="center" width="100%" border="0" cellspacing="3">
        		<tr>
            		<td class="descriptionTabla" width="90%">&nbsp;</td>
					<td width="10%" align="center">
						<a href="javascript:executeReportCustom();"><img src="/Images/Menu/print_button.gif" border="0"></a>
					</td>
        		</tr>
				<tr>
					<td colspan="2" align="center" class="body">
						 Clientes encontrados <%= msClientIn %> de <%= msClient %>
					</td>
				</tr>
				<tr>
            		<td colspan="2">
                		<div id="goDataGrid"></div>
            		</td>
        		</tr>
        	</table>
		</form>
    	<jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

