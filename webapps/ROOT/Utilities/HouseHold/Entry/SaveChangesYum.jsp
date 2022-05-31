
<%--
##########################################################################################################
# Nombre Archivo  : SaveChangesYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Guarda los datos que han sido capturados de House Hold.
# Fecha Creacion  : 16/Enero/2006
# Inc/requires    : ../Proc/HouseholdLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria HouseholdLibYum.jsp
##########################################################################################################
--%>

<%@ page import="generals.*" %>
<%@ include file="../Proc/HouseholdLibYum.jsp" %>   
<%@ include file="/Include/CommonLibYum.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
%>
<html>
	<head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
		<script>
			function goBack()
			{
				alert("Los cambios han sido guardados.");

				location.href = "HouseholdDetailYum.jsp";
			}
		</script>
	</head>
	<body onLoad="goBack()" bgcolor="white">
	</body>
</html>
<%
	saveChanges(request);
%>
