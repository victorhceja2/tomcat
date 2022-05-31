<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : SearchProductYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Busqueda de productos para ordenes de compra
# Fecha Creacion  : 15/Sep/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Listado de productos por proveedor";
    moHtmlAppHandler.initializeHandler();
    AbcUtils moAbcUtils = new AbcUtils();
    String msStore="";
    String msProv="0";
    String msSource="";
    String msParams="";
    String lsLoad="";
    boolean msRecep=false;
    try{
    	msStore=request.getParameter("psStore");
	if(!request.getParameterValues("psProv").equals(null))
		msProv=request.getParameter("psProv");
	if(!request.getParameterValues("psSource").equals(null))
		msSource=request.getParameter("psSource");
	if(!request.getParameter("psRecep").equals(null))
		msRecep=true;
    }catch(Exception e){
	msProv="0";
    }

    try{
                msParams=request.getParameter("psSub");
    }catch(Exception moExcpetion){msParams="";}


%>

<%!
    String getPrvQuery() {
        String lsQuery = "";
        lsQuery+= "SELECT provider_id,name ";
        lsQuery+= " FROM op_grl_cat_provider";
        //lsQuery+= " UNION ";
        //lsQuery+= " SELECT '0',' -- Todos los Proveedores --' ";
	lsQuery+= " order by 2 ASC ";
        return(lsQuery);
    }
%>

<html>
    <head>
        <title>Búsqueda de Productos</title>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
	<link rel='stylesheet' href='/CSS/TabStandardsYum.css' type='text/css'>
    </head>

    <script src="/Scripts/AbcUtilsYum.js"></script>

    <script>
        var gaKeys = new Array('txtNumEmp');

        function loadFunction() {
            if (opener) opener.blockEvents();
            loadFirstTab();
        }

        function adjustPageSettings() {
            adjustContainer(60,185);
        }

        function loadFirstTab() {
	    <%if(msRecep){%>
            	browseDetail('RChooseProductsYum.jsp','','1');
	    <%}else{%>
            	browseDetail('ChooseProductsYum.jsp','','1');
	    <%}%>
	}
	
	function searchProducts() {
		/*var loCmbProv = document.getElementById('cmbProv');
		if (loCmbProv) {
			/*if (loCmbProv.selectedIndex > 0) {
				loadFirstTab();
				return;
			}
		}*/
		frames['ifrDetail'].findProduct('',document.frmMaster.txtProd.value);
	}

        function validateSearch() {
            return(true);
        }

        function handleOK() {
            
            if (opener && !opener.closed){
                opener.dialogWin.returnFunc();
            }else
                alert("Se ha cerrado la ventana principal.\n\nNo se realizaran cambios por medio de este cuadro de dialogo.");     
            return (false);

        }

    </script>

    <%
    if(msProv.equals("0")){ 
        lsLoad = "<select id = 'cmbProv' name = 'cmbProv' size = '1' class = 'combos' onchange='loadFunction();'>";
    %>
        <body onResize='adjustPageSettings();' bgcolor = 'white' onUnload='if (opener) opener.unblockEvents();'>
    <%}else{
        lsLoad = "<select id = 'cmbProv' name = 'cmbProv' size = '1' class = 'combos'>";
    %>
        <body onResize='adjustPageSettings();' bgcolor = 'white' OnLoad = 'loadFunction();' onUnload='if (opener) opener.unblockEvents();'>
    <%}%>
        <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
        <table border='0' cellspacing='0' cellpadding='0' width='100%' ID='tbl_title'>
            <tr>
                <td align='left'>
                    <%if(msRecep){%>
		    <form name='frmMaster' id='frmMaster' action='RChooseProductsYum.jsp' method='get' target='ifrProcess'>
		    <%}else{%>
		    <form name='frmMaster' id='frmMaster' action='ChooseProductsYum.jsp' method='get' target='ifrProcess'>
		    <%}%>
                        <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
                        <input type='hidden' name='hidStore' id='hidStore' value='<%=msStore%>'>
			<input type='hidden' name='hidProv' id='hidProv' value='<%=msProv%>'>
			<input type='hidden' name='hidSource' id='hidSource' value='<%=msSource%>'>
                        <input type='hidden' name='hidSub' id='hidSub' value='<%=msParams%>'>

                        <table id = 'tblCapture' border = 0>
				<%if(msProv.equals("0")){ %>
				    <tr>
					<td class='descriptionTabla' >
					Proveedor:
					</td>
					<td>
                                    	    <!--<select id = 'cmbProv' name = 'cmbProv' size = '1' class = 'combos' onchange='loadFunction();'>-->
					    <%out.println(lsLoad);%>
						<option value="0" selected> --Seleccione un proveedor --</option>
                                        	<%
                                            	moAbcUtils.fillComboBox(out,getPrvQuery());
                                        	%>
                                    </select>
                                </td>
                            </tr>
				<%}%>

                            <tr>
                                <td class='descriptionTabla' >
                                    Código o Nombre de Producto:
                                </td>
                                <td>
                                    <input type='text' name='txtProd' id='txtProd' size='26' maxlength='25' class='text'>
                                </td>
                            </tr>
                            <tr>
                                <td class = 'body'>&nbsp; </td>
                                <td>
                                    <input type = 'button' id = 'btnSubmit' name = 'btnSubmit' value = 'Buscar' class = 'combos' onClick = 'searchProducts();'>
                                </td>
                            </tr>
                    </form>
                </td>
            </tr>
	</table>
        <table border='0' cellspacing='0' cellpadding='0' width='95%' id='tblCourse'>
            <tr valign = 'top'>
                <td>
                    <div class='tabBox' style='clear:both'>
                        <div class='tabArea'>
                            <a class='tab' id ='1' href = 'javascript:loadFirstTab();'>Productos</a>
                        </div>
                        <div class='tabMain'>
                            <div class='tabIframeWrapper'>
                                <iframe class='tabContent' name='ifrDetail' id='ifrDetail' marginWidth='8' marginHeight='8' frameBorder='0'></iframe>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <script> adjustPageSettings();</script>
    </body>
</html>
