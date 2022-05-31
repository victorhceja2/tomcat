<%--
##########################################################################################################
# Nombre Archivo  : SaveChangesYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Mario Chavez 
# Objetivo        : Guarda los productos que han sido marcados como CRITICOS.
# Fecha Creacion  : 29/Julio/2020
# Inc/requires    : ../Proc/InventoryLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msFamilyId;
%>

<%
	moAbcUtils = new AbcUtils();
	msFamilyId = request.getParameter("cmbFamily");
%>
<html>
	<head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
		<script>
			var msFamilyId = <%= msFamilyId %>;
			function goBack()
			{
				setTimeout('redirect()', 2000);
			}
			function redirect()
			{
				location.href = 'ChooseProductsYum.jsp?hidFamilyId='+msFamilyId+'&hidReload=true';
			}
		</script>
	</head>
	<body onLoad="goBack()" bgcolor="white">
		<p class="TextBodyDesc">
		   <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Guardando cambios espere unos segundos por favor...<br><br>
		</p>
	</body>
</html>
<%
	updateCritics(request);
%>
