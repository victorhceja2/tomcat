<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryPreviewYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Mostrar los productos del inventario. Se tiene que hacer la confirmacion para pasar los
#                   datos de la tabla de paso a la tabla real.
# Fecha Creacion  : 29/Diciembre/2005
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
    AbcUtils moAbcUtils;
    String msYear;
    String msPeriod;
    String msWeek;
    String msFamily;
    String msSales;
    String msQdate;
    String msSave;
%>

<%
    moAbcUtils  = new AbcUtils();
    msSales     = request.getParameter("hidSales");
    msQdate     = request.getParameter("hidQdate");
    msSave	= request.getParameter("hidSave");
    msYear	= request.getParameter("hidYear");
    msPeriod	= request.getParameter("hidPeriod");
    msWeek	= request.getParameter("hidWeek");

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Revisi&oacute;n Inventario Cr&iacute;ticos", "Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <script src="../Scripts/InventoryLibYum.js"></script>
        <script src="../Scripts/InventoryConfigYum.js"></script>
        <script src="../Scripts/InventoryPreviewYum.js"></script>

        <script type="text/javascript">

        //Estas dos variables son requeridas en el Script InventoryPreviewYum.js
        var gaDataset = new Array();
        <%= getDataset(request) %>
        var netSale = <%= msSales %>;

        function save(){
	    document.frmGrid.submit();
        }
        function cancel(){
            window.close();
        }
        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(false)">
    	<div style="overflow:auto;height:100%;">
        <script src="/Scripts/TooltipsYum.js"></script>

        <jsp:include page="/Include/GenerateHeaderYum.jsp">
            <jsp:param name="psStoreName" value="true"/>
        </jsp:include>
	<%if(!"1".equals(msSave)){%>
            <form action="InventoryConfirmYum.jsp" name="frmGrid">
            <table align="center" width="99%" border="0" cellspacing="6">
              <tr>
                <td align="center" class="mainsubtitle">
                   &#191; Desea confirmar estos valores del inventario de cr&iacute;ticos &#63; 
                   <br><br>
                </td>
              </tr>
              <tr>
                <td class="descriptionTabla" width="15%" nowrap>
                  <input type="button" value="Aceptar" onClick="save()">
                  <!--<input type="button" value="Cancelar" onClick="cancel()">-->
                  <input type="hidden" name="hidYear"   value="<%= msYear %>">
                  <input type="hidden" name="hidPeriod" value="<%= msPeriod %>">
                  <input type="hidden" name="hidWeek"   value="<%= msWeek %>">
                  <input type="hidden" name="hidQdate"  value="<%= msQdate %>">
                  <input type="hidden" name="hidSales"  value="<%= msSales %>">
		  <input type="hidden" name="hidSave"   value="<%= msSave%>">
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
	<%} 
	  else{
	     saveChanges(msQdate, msSave);%>
	     <table align="center" width="99%" border="0" cellspacing="6">
	       <tr>
	         <td align="center" class="mainsubtitle">
		 Se guardaran estos valores del inventario y podra seguir haciendo cambios.
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
	<%}%>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </div>
    </body>
</html>
<%!
    String getDataset(HttpServletRequest poRequest){
        updateStepInventory(poRequest);

        return getDataset(true, msQdate);
    }
%>
