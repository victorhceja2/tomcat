<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Contenedor principal de la pantalla de inventario de criticos
# Fecha Creacion  : 16/Diciembre/2005
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.SimpleRecord" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>
<%@ include file="../../../Employees/Edit/Proc/EmployeeLib.jsp" %>

<%! 
    AbcUtils moAbcUtils; 

    String msYear;
    String msPeriod;
    String msWeek;
    String msDate;
    String msCurrDate;
    String msBusiDate;
    String msCritics;
    String msHour;
    String msHourConfig;
    String miInvClosed;
    boolean isValidTime;
    boolean mbMonday;

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
    moAbcUtils   = new AbcUtils();
    msYear       = getInvYear();
    msPeriod     = getInvPeriod();
    msWeek       = getInvWeek();
    msDate       = getBusinessDate();
    msCurrDate   = getCurrentDate();
    msBusiDate   = msDate.replaceAll("-","");
    isValidTime  = isValidTime();
    msCritics    = validCritics(msDate);
    mbMonday     = getWeekDay();
    msHour       = getHour();
    msHourConfig = getConfig("1");
    miInvClosed  = validateInvClose(msDate);
    
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Inventario de cr&iacute;ticos";
%>

<html>
  <head>

    <title>Inventario de criticos</title>

    <link rel="stylesheet" href="/CSS/GeneralStandardsYum.css" type="text/css">
    <link rel="stylesheet" href="/CSS/TabStandardsYum.css" type="text/css">
    <link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css">

    <div id="divWaitGSO" style="width: 300px; height: 150px" class="wait-gso">
            <br>Cargando informaci&oacute;n de los productos.
            <br><br>Espere por favor...<br><br>
	</div>

    <script src='/Scripts/RemoteScriptingYum.js'></script>
    <script src="/Scripts/AbcUtilsYum.js"></script>
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
        var isValidTime = <%= isValidTime %>;
	var lsCritics = <%= msCritics %>;
	var lsHour = <%= msHour %>;
	var lsHourConfig = <%= msHourConfig %>;
	var liCloseDate = <%= miInvClosed %>;
	var lsCurrDate = <%= msCurrDate %>;
	var lsBusiDate = <%= msBusiDate %>;

	function getUser(){
	   return document.frmMaster.cmbEmpl.value;
	}

	function getPassword(){
	   return document.frmMaster.txtPass.value;
	}

	function setFocus(psEmpl){
	   if(psEmpl == "true")
	      document.frmMaster.cmbEmpl.focus();
	   else
	      document.frmMaster.txtPass.focus();
	}
    
        function printDetail() {
            executeDetail();
        }

        function loadFirstTab() {
	    //alert('Test--->'+lsHour+'         Config-->'+lsHourConfig);
	    /*if(parseInt(lsCritics) > 0){
	    	alert('Ya se hizo captura de cr\u00EDticos para esta semana');
		return;
	    }*/
//alert("lsHour:"+lsHour+" lsHourConfig:"+lsHourConfig+" lsCurrDate:"+lsCurrDate+" lsBusiDate:"+lsBusiDate);
	    if(parseInt(lsHour) < parseInt(lsHourConfig) && !(parseInt(lsCurrDate) > parseInt(lsBusiDate))){
	    	alert('La captura de la informaci\u00F3n s\u00F3lo puede hacerse a partir de las '+lsHourConfig+':00 hrs.');
		return;
	    }
	    if(liCloseDate > 0){
	    	alert('El inventario de cr\u00EDticos ya fue cerrado');
		return;
	    }
            validOption('1');
        }

        function validOption(psTab){
            switch (psTab)
            {
                    case '1':

                        if(isValidTime) 
                        {
                            browseDetail('InventoryDetailYum.jsp','InventoryYum.jsp','1');
                           //showWaitMessage();
                        }                            
                        else
                        {
                            document.frmMaster.target = '_self';
			    addHidden(document.frmMaster, 'hidTitle', 'Inventario de cr&iacute;ticos');
		            addHidden(document.frmMaster, 'hidMessage', 'El inventario se puede capturar hasta despu&eacute;s de las 8:30pm');
		            addHidden(document.frmMaster, 'hidSplit', 'false');
                            document.frmMaster.submit();
                        }
                    break;
                          
                    case '2':    
                    break;

            }

            msLastTab = psTab;
        }

        function validateSearch() {
               return(true);
        }

        </script>
    </head>

    <body bgcolor="white" OnLoad="loadFirstTab();">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>

    <form id="frmMaster" name="frmMaster" method="post" action="/MessageYum.jsp" target="ifrDetail">
    <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
        <table width="99%" align="center" id="tblCapture" border="0" cellpadding="2">
        <tr>
            <td class="TextBodyDesc" width="35%">
                <b>A&ntilde;o: </b><%= msYear %> &nbsp;
                <b>Periodo: </b><%= msPeriod %> &nbsp;
                <b>Semana: </b><%= msWeek %> &nbsp;
                <b>Fecha de negocio: </b><%= msDate %> &nbsp;
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
	    <td class="body" align="right" width="10%"> Contrase&ntilde;a: </td>
	    <td width="5%">
	    	<input type="password" name="txtPass" size="10">
	    </td>
        </tr>
	</table>
	<table border = "1" cellspacing='0' cellpadding='0' width='100%' id='tblCourse'>
	<tr valign="top">
	   <td width="100%" height="100%">
	     <iframe class='tabContent' name='ifrDetail' width='100%' height="450" id='ifrDetail' frameBorder='0'> </frame>
	   </td>
	</tr>
    </table>
    </form>
</body>
</html>

<%
    if(isValidTime){
        // Valores del inventario inicial a la tabla de inventario */
        initInventory(msYear, msPeriod, msWeek, msDate);
    
        //Se actualizan las recepciones, las transferencias de entrada/salida 
        //y el uso ideal en la tabla de inventario

        //msWeek="47";
        //msDate="17-11-20";
        updateInventory(msYear, msPeriod, msWeek, msDate);
    }

    if(mbMonday){
    	RestartInventory();
    }
%>
