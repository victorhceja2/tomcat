<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZ
# Objetivo        : Contenedor principal de la pantalla de inventario
# Fecha Creacion  : 27/Julio/2005
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*, java.io.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.SimpleRecord" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   
<%@ include file="/Include/InventoryLibYum.jsp" %>
<%@ include file="../../../Employees/Edit/Proc/EmployeeLib.jsp" %>

<%! 
    AbcUtils moAbcUtils; 
	AplicationsV2 logApps = new AplicationsV2();

    String msYear;
    String msPeriod;
    String msWeek;
    String msInitDate;

    ArrayList<String> getEmployees() {
        ArrayList<String> maEmployees = new ArrayList<String>();
        String queryEmployees = "SELECT emp_num || ' ' || last_name || ' ' || last_name2 || ' ' || name, last_name "
            + "FROM pp_employees WHERE sus_id <> 'NULL' "
            + "AND cast (emp_num as integer) > 0 "
            + "AND security_level ='01' order by 2";
        String[] laEmployees = moAbcUtils.queryToString(queryEmployees, ">", ",").split(">");
        for (String employee : laEmployees) {
            String lstEmployee = employee.split(",")[0];
            maEmployees.add(lstEmployee);
        }	
        return maEmployees;
    }

%> 

<%
    moAbcUtils = new AbcUtils();
    msYear     = getInvYear();
    msPeriod   = getInvPeriod();
    msWeek     = getInvWeek();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Calendar c = Calendar.getInstance();
    msInitDate = sdf.format(c.getTime());

    logApps.writeInfo("\n" + msInitDate + " -> Inicia Aplicacion de Inventario Semanal\n");
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Inventario semanal";
%>

<html>
  <head>

    <title>Inventario</title>

    <link rel="stylesheet" href="/CSS/GeneralStandardsYum.css" type="text/css">
    <link rel="stylesheet" href="/CSS/TabStandardsYum.css" type="text/css">
    <link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css">

    <div id="divWaitGSO" style="width: 300px; height: 150px" class="wait-gso">
            <br>Validando usos ideales...<br>
            <br>Cargando informaci&oacute;n de todos los productos.
            <br><br>Espere por favor...<br><br>
	</div>

    <script src='/Scripts/RemoteScriptingYum.js'></script>
    <script src="/Scripts/AbcUtilsYum.js"></script>
    <script src="/Scripts/Chars.js"></script>
    <script src="/Scripts/StringUtilsYum.js"></script>
    <script src="/Scripts/HtmlUtilsYum.js"></script>

    <script>

        var gaKeys = new Array('');
        var gsFamilyId = '';
        var liRowCount=0;
        var liRowCountRecep=0;
        var lsProductoCodeLst='';
        var lsProductoCodeRecepLst='';
        var msLastTab = '1';
    
        function printDetail() {
            executeDetail();
        }

        function adjustPageSettings() {
            adjustContainer(60,165);
        }

        function loadFirstTab() {
	    document.frmMaster.reset();
            validOption('1');
    }

        function validOption(psTab)
	{
            switch (psTab){
                    case '1':     
                        browseDetail('InventoryDetailYum.jsp?hidFamily=-1','InventoryYum.jsp','1');
                    break;
                          
                    case '2':    
                    break;

            }

            msLastTab = psTab;
    	}

        function validateSearch() {
               return(true);
        }

        function saveCurrentCategory()
        {
            var index  = document.frmMaster.cmbFamily.selectedIndex;
            gsFamilyId = document.frmMaster.cmbFamily.options[index].value;
        }

        function changeCategory()
        {
            var index    = document.frmMaster.cmbFamily.selectedIndex;
            var familyId = document.frmMaster.cmbFamily.options[index].value;

            //si hay cambios en Datagrid, alertar
            if(frames['ifrDetail'].document.frmGrid.hidHasChanges.value=='true')
            {
                var msg = 'Al parecer realizo algunos cambios. Si cambia de ' +
                          'categoria estos cambios seran perdidos. \n\n ' +
                          'Desea guardar sus cambios antes de cambiar? ';

                if(confirm(msg))
                    frames['ifrDetail'].submitChanges(familyId);
                else
                    showProducts(familyId);
            }
            else
            {
                showProducts(familyId);
            }
        }

        function showProducts(familyId)
        {
            if(familyId == -1)
                showWaitMessage();

            browseDetail('InventoryDetailYum.jsp?hidFamily='+familyId,'InventoryYum.jsp','1');
        }
        
        function getUser(){
	    return document.frmMaster.cmbEmpl.value;
        }
        
        function getPassword(){
	    return document.frmMaster.txtPass.value;
        }
        
        function setFocus(psEmpl){
	    if(psEmpl == "true"){
	      document.frmMaster.cmbEmpl.focus();
	    }else{
	      document.frmMaster.txtPass.focus();
	    }
        }

        showWaitMessage();
        </script>
    </head>

    <body bgcolor="white" OnLoad="loadFirstTab();">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>

    <form id="frmMaster" name="frmMaster" method="post" action="InventoryDetailYum.jsp" target="ifrDetail">
    <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
    <input type="hidden" name="hidInitDate" id="hidInitDate" value="<%= msInitDate %>">
        <table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
            <tr>
                <td class="TextBodyDesc" width="35%">
                    <b>A&ntilde;o: </b><%= msYear %> &nbsp;
                    <b>Periodo: </b><%= msPeriod %> &nbsp;
                    <b>Semana: </b><%= msWeek %> &nbsp;
                </td>
                <td class="body" align="right" width="10%">Empleado: </td>
                <td width="20%">
		    <select id="cmbEmpl" name="cmbEmpl" size="1" class="combos" onChange="document.frmMaster.txtPass.value=''">
		    <option value="-1"> -- Seleccione Empleado -- </option>
		    <%
			writeMenu(out, getEmployees());
		    %>
		    </select>
		</td>
		<td class="body" align="right" width="10%">Contrase&ntilde;a: </td>
		<td width="5%">
		    <input type="password" name="txtPass" id="txtPass" size="10">
		</td>
                <td class="body" width="10%" align="right">Categor&iacute;a: </td>
                <td width="10%">
                    <select id="cmbFamily" name="cmbFamily" size="1" class="combos" 
                            onChange="changeCategory()" onFocus="saveCurrentCategory()">
                    <option value="-1"> -- TODAS LAS CATEGORIAS -- </option>
                    <%
                        moAbcUtils.fillComboBox(out, getFamiliesQuery() );
                    %>
                    </select>
                </td>
            </tr>
        </table>
    <table border="0" cellspacing='0' cellpadding='0' width='100%' id='tblCourse'>
    <tr valign="top">
        <td width="100%" height="100%">
         <iframe class='tabContent' name='ifrDetail' width="100%" height="450"
                                id='ifrDetail' frameBorder='0'></iframe>
        </td>
    </tr>
    </table>
    </form>
</body>
</html>

<%
    // Valores del inventario inicial a la tabla de inventario */
    //EZ: tunning
    //Se hizo reimplementacion de este metodo
    logApps.writeInfo("Update desde inventario semanal");
    updateIdealUse();
    initInventory(msYear, msPeriod, msWeek);
    
    
    /* EZ: tunning
        Solo se actualizara el uso ideal y los factores de conversion
        YA NO se actualizan las recepciones, las transferencias de entrada/salida 
    */
    updateInventory(msYear, msPeriod, msWeek);
%>
