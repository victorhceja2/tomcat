<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : ChooseProductsYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Mario Chavez
# Objetivo        : Mostrar todos los productos del inventario de criticos para seleccionarlos.          #
# Fecha Creacion  : 06/Agosto/2020
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
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
    String msFamilyId;
    String msReload;
    String msYear;
    String msPeriod;
    String msWeek;
    String msQdate;
    String msMaxCritA;
    String msMaxCrit;
%>    

<%  
    moAbcUtils = new AbcUtils(); 

	msYear     = getInvYear();
	msPeriod   = getInvPeriod();
	msWeek	   = getInvWeek();
	msQdate	   = getBusinessDate();
        msMaxCritA = getRestItems();
        msMaxCrit  = getConfig("4");

    msFamilyId = request.getParameter("hidFamilyId");
    msReload   = request.getParameter("hidReload");
    
    if(msReload == null)
	msReload = "false";

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Productos de inventario", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
    
        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');

        //Original values
        var gaDataset = <%= getDataset(msFamilyId) %>;
        //Like a array copy                
	var laDataset  = <%= getDataset(msFamilyId)  %>;
        var laSelected = simpleArray(laDataset.length);
        var giNumItems  = 0;
	var gaNewItems  = new Array();
	var gaOldItems  = new Array();

        function updateCritics(psFamilyId) {
		var lsNewItems = (gaNewItems.length>0)?gaNewItems.join():'-1';
		var lsOldItems = (gaOldItems.length>0)?gaOldItems.join():'-1';

           	addHidden(document.frmCritics, 'hidNumItems',giNumItems);
            	addHidden(document.frmCritics, 'hidNewItems',lsNewItems);
           	addHidden(document.frmCritics, 'hidOldItems',lsOldItems);

            	document.frmCritics.action = "SaveChangesYum.jsp";
            	document.frmCritics.submit();
        }
        
        function changeCategory(){
            var index    = document.frmCritics.cmbFamily.selectedIndex;
            var familyId = document.frmCritics.cmbFamily.options[index].value;

            //si hay cambios en Datagrid, alertar
            if(document.frmCritics.hidHasChanges.value=='true'){
                var msg = 'Al parecer realizo algunos cambios. Si cambia de ' +
                          'categoria estos cambios seran perdidos. \n\n ' +
                          'Desea guardar sus cambios antes de cambiar? ';

                if(confirm(msg))
                    updateCritics(familyId);
                else
                    showProducts(familyId);
            }
            else{
	    	showProducts(familyId);
            }
        }

        function showProducts(psFamilyId){
		addHidden(document.frmCritics, 'hidFamilyId', psFamilyId);
            	document.frmCritics.action = "ChooseProductsYum.jsp";
           	document.frmCritics.submit();
        }

	function reloadParent(psReload){
		if(psReload == 'true'){
			var _top = opener.top;
			alert(_top);
		}
	}
  
        function cancelAlert(){
                alert("Si desea ver los cambios aplicados en este cierre, vuelva a entrar a cr\u00EDticos");
                //window.location.reload();
                cancel();
        }

        </script>
		<!-- JavaScript functions only for choose products -->
        <script src="../Scripts/ChooseProductsYum.js"></script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid(<%= msMaxCrit %>,<%= msMaxCritA %>); reloadParent(<%= msReload %>)">

        <form name="frmCritics" id="frmCritics" action="SaveChangesYum.jsp">
        <table align="center" width="90%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                <input type="button" value="Guardar cambios" onClick="updateCritics()">
                <input type="button" value="Cerrar ventana" onClick="cancelAlert()">
                <input type="hidden" name="hidHasChanges" value="false">

		        <input type="hidden" name="hidQdate" value="<%= msQdate %>">
        		<input type="hidden" name="hidYear" value="<%= msYear %>">
       		 	<input type="hidden" name="hidPeriod" value="<%= msPeriod %>">
		        <input type="hidden" name="hidWeek" value="<%= msWeek %>">

            </td>
			<td align="right">
				<select id="cmbFamily" name="cmbFamily" size="1" class="combos" onChange="changeCategory()">
                    		<option value="-1"> -- TODAS LAS CATEGORIAS -- </option>
                   		 <%= moAbcUtils.fillComboBox(getFamilies(), msFamilyId) %>
                 		</select>
			</td>
        </tr>
        <tr>
            <td colspan="2">
                <br>
                <div id="goDataGrid"></div>
                <br><br>
            </td>
        </tr>
        </table>
        </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!

    String getDataset(String psFamilyId){
        // Algun procedimiento previo
		//String lsInvId = getSelectedItems(poRequest);
	System.out.println("psFamilyId-->"+psFamilyId);
        return moAbcUtils.getJSResultSet(getChooseProductsQuery(psFamilyId));
    }

%>
