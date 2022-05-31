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
<%@ include file="../Proc/CustomLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msFamilyId;
	String msFrecId;
	String msDate;
	String msDataset;
	String msBase;
	String msPack;
	String msClient = "0";
	String msClientIn = "0";
	String msAgeb = "0";
	String msStreet = "0";
%>	

<%
	moAbcUtils = new AbcUtils();
    try{
		msFamilyId = request.getParameter("hidFamily");
		msFrecId   = request.getParameter("hidFrecu");
		msDate     = request.getParameter("hidDate");
		if(msDate.equals("") || msDate.equals(null)){
			msDate = "31/10/2006";
		}
		msBase = request.getParameter("hidBase");
		msPack = request.getParameter("hidPack");

		msAgeb = request.getParameter("hidAgeb");
		msStreet = request.getParameter("hidStreet");
		
	}
    catch(Exception e){
		System.out.println("CustomDetail.jsp ... " + e);
    }
	msDataset = "new Array()";
	if(!(msFamilyId.equals("0"))){
		msDataset = getDataset(msFamilyId, msFrecId, msDate, msBase, msPack, msAgeb, msStreet);
		msClientIn = getRescli(msFamilyId, msFrecId, msDate, msBase, msPack, msAgeb, msStreet);
		msClient = getClients();

		if(!(msStreet.equals("ALL"))){
			droptbtemp();
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
				

	
        <script type="text/javascript">
			var gaDataset = <%= msDataset %>;

			function executeReportCustom(){
				var name;
				var ficha = document.getElementById('repimp');
				ficha.innerHTML = "<tr class='bsDb_tr_header'><td class='bsDb_td_header_right' align='center', hclass='right, bclass='right', colspan='8'>Ultima Compra Cliente</td></tr>" + 
								  "<tr class='bsDb_tr_header'><td width='30%', align='left' class='bsDb_td_header_default'>Nombre</td>" +
								  "<td width='30%', align='left' class='bsDb_td_header_default'>Direccion</td>" + 
								  "<td width='5%', align='left' class='bsDb_td_header_default'>Ageb</td>" +
								  "<td width='8%', align='left' class='bsDb_td_header_default'>Telefono</td>" +
								  "<td width='10%', align='right' class='bsDb_td_header_default'>Fecha Ultima Compra</td>" +
								  "<td width='7%', align='right' class='bsDb_td_header_default'>Monto</td>" +
								  "<td width='5%', align='right' class='bsDb_td_header_default'>Frecuencia</td>" +
								  "<td width='5%', align='left' class='bsDb_td_header_default'>Cupon</td></tr>";
			
				for(var i = 0; i < gaDataset.length; i++){
					var paso = gaDataset[i];
					var lin = i%2;
					var tr_def = "";
					var td_def = "";
					
					ficha.innerHTML += "<tr class='bsDg_tr_row_zebra_0'>";
					var pos = paso[0].indexOf("&");
					name = paso[0].substring(55,pos);
					name = name.replace(/_/g,' ');
					ficha.innerHTML += "<td class='bsDg_td_row_zebra_0'>" + name + "</td>" + 
									   "<td class='bsDg_td_row_zebra_0'>" + paso[1] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[2] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[3] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[4] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[5] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[6] + "</td>" +
									   "<td class='bsDg_td_row_zebra_0'>" + paso[7] + "</td></tr>";
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
						 Clientes encontrados <%= msClientIn %> de <%= msClient %>
					</td>
				</tr>
				<table id="repimp" class="bsDg_table" cellspacing="0" cellpadding="4" border="0">
				</table>
        	</table>
		</form>
    </body>
</html>
