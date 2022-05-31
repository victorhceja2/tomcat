<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryPreviewYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Mostrar los productos del inventario. Se tiene que hacer la confirmacion para pasar los
#                   datos de la tabla de paso a la tabla real.
# Fecha Creacion  : 09/Agosto/2005
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*, java.io.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
    AbcUtils moAbcUtils;
	AplicationsV2 logApps = new AplicationsV2();
    String msYear;
    String msPeriod;
    String msWeek;
    String msFamily;
    String msSales;
    String msUser;
    String msInitDate;
    String msTried;
%>

<%
    moAbcUtils     = new AbcUtils();
    msYear         = request.getParameter("hidYear");
    msPeriod       = request.getParameter("hidPeriod");
    msWeek         = request.getParameter("hidWeek");
    msFamily       = request.getParameter("hidFamily");
    msSales        = request.getParameter("hidSales");
    msUser         = request.getParameter("hidUser");
    msInitDate     = request.getParameter("hidInitDate");
    msTried        = request.getParameter("hidTried");
    
    updateFlagInv(msYear,msPeriod,msWeek,msTried);

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Revisi&oacute;n Inventario Semanal", "Printer");
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>

        <div id="divWaitGSO" style="width:400px; height:150px"  class="wait-gso">
            <br><br>Espere por favor...<br><br>
        </div>

        <script src="/Scripts/HtmlUtilsYum.js"></script>

        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="../Scripts/InventoryLibYum.js"></script>
        <script src="../Scripts/InventoryConfigYum.js"></script>
        <script src="../Scripts/InventoryPreviewYum.js"></script>
        <script src="/Scripts/final_inv_error.txt"></script>

        <script type="text/javascript">


        //Estas dos variables son requeridas en el Script InventoryPreviewYum.js
        var gaDataset = new Array();
        <%= getDataset(request) %>
        var netSale = <%= msSales %>;
        
        function save()
        {
            document.frmGrid.submit();
        }
        function cancel()
        {
            window.close();
        }
        
        function showErrors(){
        	if(prdErrors != ""){
        		alert('Se ingreso un valor incorrecto en el final de los siguientes productos:\n\n'
        				+ prdErrors + '\nPor favor valida que el valor ingresado sea correcto para que se guarde correctamente.\n');
        	}
        }
        
        </script>
        
    </head>

    <body bgcolor="white" onLoad="initDataGrid(false, true); showErrors()">

        <jsp:include page="/Include/GenerateHeaderYum.jsp">
            <jsp:param name="psStoreName" value="true"/>
        </jsp:include>
        <% if( ! msTried.equals("1") ){ %>
            <table align="center" width="99%" border="0" cellspacing="6">
            <tr>
                <td align="center" class="mainsubtitle">
                    <!--&#191; Desea confirmar estos valores del inventario final &#63; -->
                    Se guardaran estos valores del inventario y podra seguir haciendo cambios pero aun no se reflejaran en los reportes de PCA, inventarios y operaciones.
                    <br><br>
                </td>
            </tr>
            <tr>
                <td class="descriptionTabla" width="15%" nowrap>
                    <input type="button" value="Continuar" onClick="cancel()">
                </td>
            </tr>
            <tr>
                <td>
                    <br>
                        <div id="goDataGrid"></div>
                    <br><br>
                </td>
            </tr>
            </table>

        <%}else{%>

            <form action="InventoryConfirmYum.jsp" name="frmGrid">
            <table align="center" width="99%" border="0" cellspacing="6">
            <tr>
                <td align="center" class="mainsubtitle">
                   <!--&#191; Desea confirmar estos valores del inventario final &#63; -->
                   &#191; Se guardaran estos valores del inventario&#63;
                    <br><br>    
                </td>
            </tr>
            <tr>
                <td class="descriptionTabla" width="15%" nowrap>
                    <input type="button" value="Continuar" onClick="save()">
                    <!--<input type="button" value="Cancelar" onClick="cancel()">-->
                    <input type="hidden" name="hidFamily" value="<%= msFamily %>">
                    <input type="hidden" name="hidYear"   value="<%= msYear %>">
                    <input type="hidden" name="hidPeriod" value="<%= msPeriod %>">
                    <input type="hidden" name="hidWeek"   value="<%= msWeek %>">
                    <input type="hidden" name="hidSales"  value="<%= msSales %>">
                    <input type="hidden" name="hidUser"   value="<%= msUser %>">
                    <input type="hidden" name="hidInitDate" id="hidInitDate" value="<%= msInitDate %>">
                </td>
            </tr>
            <tr>
                <td>
                    <br>
                    <div id="goDataGrid"></div>
                    <br><br>
                </td>
            </tr>
            </table>
            </form>
         <%}%> 
    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!String getDataset(HttpServletRequest poRequest)
    {
		try {
			updateStepInventory(poRequest);
		} catch (Exception e) {
			logApps.writeError(e);
		}

		//return getReportDataset(true, msYear, msPeriod, msWeek, msFamily);
		return getDataset(true, msYear, msPeriod, msWeek, msFamily);
	}%>
