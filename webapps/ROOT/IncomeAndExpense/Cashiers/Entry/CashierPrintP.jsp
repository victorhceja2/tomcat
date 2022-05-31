<%--
##########################################################################################################
# Nombre Archivo  : CashierDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : MCA
# Objetivo        : Reporte Cajeros
# Fecha Creacion  : 28/Mar/2008
# Inc/requires    : ../Proc/CashierLibFrec.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria CashierLibfrec.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/CashierLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msDate;
	String msDataset;
	String msEmp;
	String msMgr;
	String lsManager;
	String lsCashier;
%>	

<%
    moAbcUtils = new AbcUtils();
    try{
		msDate     = request.getParameter("hidDate");
		if(msDate.equals("") || msDate.equals(null)){
			msDate = "31/10/2006";
		}
		msEmp = request.getParameter("hidEmp");
		msMgr = request.getParameter("hidMngr");
	}
    catch(Exception e){
		System.out.println("CashierDetail.jsp ... " + e);
    }
    msDataset = "new Array()";
    if(!(msEmp.equals("0"))){
	msDataset = getDataset(msDate, msEmp, msMgr);
    }
    lsCashier = getEmpRequest(msEmp);
    lsManager = getEmpRequest(msMgr);
 
System.out.println("Cashier:" + lsCashier + " Manager:" + lsManager);

%>

<html>
	<head>

		<link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
		<link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>
				

	
        <script type="text/javascript">
			var gaDataset = <%= msDataset %>;
			var gsEmp = "<%= lsCashier %>"
			var gsMgr = "<%= lsManager %>"

			function executeReportCashier(){
				var name;
				var ficha = document.getElementById('repimp');
				ficha.innerHTML = 
				"<tr class='bsDb_tr_header'><td class='bsDb_td_header_right' align='center', hclass='right, bclass='right', colspan='4'>Empleado solicitante:" + gsMgr + " Cajero:" + gsEmp + "</td></tr>" + 
				"<tr class='bsDb_tr_header'><td width='30%', align='left' class='bsDb_td_header_default'>Rubro</td>" +
				"<td width='20%', align='left' class='bsDb_td_header_default'>Valor</td>" + 
				"<td width='30%', align='left' class='bsDb_td_header_default'>Rubro</td>" +
				"<td width='20%', align='left' class='bsDb_td_header_default'>Valor</td></tr>";
			
				for(var i = 0; i < gaDataset.length; i++){
					var paso = gaDataset[i];
					var lin = i%2;
					var tr_def = "";
					var td_def = "";
					
					ficha.innerHTML += "<tr class='bsDg_tr_row_zebra_0'>";
					var pos = paso[0].indexOf("&");
					name = paso[0].substring(55,pos);
					name = name.replace(/_/g,' ');
					ficha.innerHTML += "<td class='bsDg_td_row_zebra_0'>" + paso[1] + "</td>" +
							   "<td class='bsDg_td_row_zebra_0'>" + paso[2] + "</td>" +
							   "<td class='bsDg_td_row_zebra_0'>" + paso[3] + "</td>" +
							   "<td class='bsDg_td_row_zebra_0'>" + paso[4] + "</td></tr>";
				}
				//setTimeout("window.print()",1500);
				window.focus();
				window.print();
				window.close();
			}	           

		</script>
    </head>

    <body bgcolor="white" onLoad="executeReportCashier();" style="margin-left: 4px; margin-right: 0px">
	<form name="frmGrid" id="frmGrid" method="post">
        <table align="center" width="100%" border="0" cellspacing="3">
		<table id="repimp" class="bsDg_table" cellspacing="0" cellpadding="4" border="0">
		</table>
        </table>
	</form>
    </body>
</html>
