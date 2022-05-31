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
<%@ include file="../Proc/CustomLibFrecA.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msFrecId;
	String msDate;
	String msDataset;
	String msDateH;
	String msAgeb;
	String msClient = "0";
	String msClientIn = "0";
%>	

<%
	moAbcUtils = new AbcUtils();
    try{
		msFrecId   = request.getParameter("hidFrecu");
		msDate     = request.getParameter("hidDate");
		if(msDate.equals("") || msDate.equals(null)){
			msDate = "31/10/2006";
		}
		msDateH    = request.getParameter("hidDateH");
		if(msDateH.equals("") || msDateH.equals(null)){
			msDateH = "31/10/2006";
		}
		msAgeb = request.getParameter("hidAgeb");
	}
    catch(Exception e){
		System.out.println("CustomDetailA.jsp ... " + e);
    }
	msDataset = "new Array()";
	if(!(msFrecId.equals("0"))){
		msDataset = getDataset(msFrecId, msDate, msDateH, msAgeb);
		msClientIn = getRescli(msFrecId, msDate, msDateH, msAgeb);
		msClient = getClients(msFrecId, msDate, msDateH, msAgeb);
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
				

	
        <script type="text/javascript">
			var gaDataset = <%= msDataset %>;

			function executeReportCustom(){
				var name;
				var ficha = document.getElementById('repimp');
				ficha.innerHTML = "<tr class='bsDb_tr_header'><td class='bsDb_td_header_right' align='center', hclass='right, bclass='right', colspan='3'>Ultima Compra Cliente por AGEB</td></tr>" + 
								  "<tr class='bsDb_tr_header'><td width='60%', align='left' class='bsDb_td_header_default'>Calle</td>" +
								  "<td width='20%', align='left' class='bsDb_td_header_default'>AGEB</td>" + 
								  "<td width='2%', align='left' class='bsDb_td_header_default'>Clientes</td>";
			
				for(var i = 0; i < gaDataset.length; i++){
					var paso = gaDataset[i];
					var lin = i%2;
					var tr_def = "";
					var td_def = "";
					
					ficha.innerHTML += "<tr class='bsDg_tr_row_zebra_0'>";
					ficha.innerHTML += "<td class='bsDg_td_row_zebra_0'>" + paso[0] + "</td>" + 
									   "<td class='bsDg_td_row_zebra_0'>" + paso[1] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[2] + "</td></tr>";
				}
				//setTimeout("window.print()",1500);
				window.focus();
				window.print();
				window.close();
			}	           

		</script>
    </head>

    <body bgcolor="white" onLoad="executeReportCustom();" style="margin-left: 4px; margin-right: 0px">
		<form name="frmGrid" id="frmGrid" method="post">
        	<table align="center" width="100%" border="0" cellspacing="3">
				<tr>
					<td colspan="2" align="center" class="body">
						<%=msClient%> clientes, concentrados en <%=msClientIn%> calles.
					</td>
				</tr>
				<table id="repimp" class="bsDg_table" cellspacing="0" cellpadding="4" border="0">
				</table>
        	</table>
		</form>
    </body>
</html>
