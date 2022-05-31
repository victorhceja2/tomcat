<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : SaveChangesYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Guarda los datos que han sido capturados en el inventario final.
# Fecha Creacion  : 06/Septiembre/2005
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page import="java.util.*, java.io.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	AplicationsV2 logApps = new AplicationsV2();
	String msFamilyId;
	String msYear;
	String msPeriod;
	String msWeek;
	String msInitDate;
	String msUser;
	boolean lbInventoryOk;

%>

<%
	moAbcUtils = new AbcUtils();
	msYear     = request.getParameter("hidYear"); 
	msPeriod   = request.getParameter("hidPeriod");
	msWeek     = request.getParameter("hidWeek");
    msFamilyId = request.getParameter("newFamily");
    msInitDate = request.getParameter("hidInitDate");
    msUser     = request.getParameter("hidUser");

    try{
        updateStepInventory(request);
	    lbInventoryOk = saveChanges(msYear, msPeriod, msWeek);
	    updateFlagInv(msYear,msPeriod,msWeek,"2");
    }catch(Exception e){
    	logApps.writeError("Error en SaveChanguesYum.jsp");
    	logApps.writeError(e);
    }
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Confirmacion de cierre de inventario", "Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>
<html>
	<head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

		<script>
		    function cerrar(){
		       //EZ: tunning
                //window.opener.location.href = 'InventoryDetailYum.jsp?hidFamily=<%= msFamilyId %>';
                window.close();
            }
			function showProducts()
			{
				setTimeout("parent.showProducts(<%= msFamilyId %>);", 3000);
			}
		</script>
	</head>
	<body onLoad="showProducts()" bgcolor="white">
		<jsp:include page = '/Include/GenerateHeaderYum.jsp'>
        <jsp:param name="psStoreName" value="true"/>
        </jsp:include>
		<form name="frmConfirm">
			<table align="center" class="mainsubtitle">
            <%
                if(lbInventoryOk){
                    registerAudit(msUser, msYear, msPeriod, msWeek, msInitDate);
                    inventoryClose();
            %>
                    <br><br><br>
                    <tr><td align="center" ><b>&iexcl;Atenci&oacute;n&#33;</b> Se guardaron finales y se cerro la semana <%=msWeek%> periodo <%=msPeriod%> del <%=msYear%>.</td></tr>
                    <tr><td align="center" ><br>&nbsp;<br>&nbsp;<br></td></tr>
            <%
                }else{
                    out.println("Problemas al guardar los datos del inventario. <br><br>");
                }
            %>
                <br>&nbsp;<br>&nbsp;<br>
                <tr><td align="center" ><input type="button" value="Cerrar ventana" onclick="cerrar()"></td></tr>
            </table>
        </form>
	</body>
</html>
	
