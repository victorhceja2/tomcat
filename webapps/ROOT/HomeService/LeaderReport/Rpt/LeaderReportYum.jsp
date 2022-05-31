<%--
##########################################################################################################
# Nombre Archivo  : LeaderReportYum.jsp     
# Compania        : Premium Restaurant Brands
# Autor           : Jose Abraham Vanegas Mata
# Objetivo        : Mostrar la eficiencia de reparto.
# Fecha Creacion  : 09/Junio/2016
# Inc/requires    : ../Include/CommonLibyum.jsp
# Observaciones   : Se requiere mostrar un porcentaje de eficiencia de repartidor
##########################################################################################################
--%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="generals.*"%>

<%@ include file="../Proc/LeaderLibYum.jsp"%>

<%!AbcUtils moAbcUtils = new AbcUtils();

	String msYear;
	String msPeriod;
	String msWeek;
	String msDay;%>

<%
	try {
		msYear = request.getParameter("hidSelectedYear");
		msPeriod = request.getParameter("hidSelectedPeriod");
		msWeek = request.getParameter("hidSelectedWeek");
		msDay = request.getParameter("hidSelectedDay");
		
		System.out.println("Año: " + msYear + "\nPeriodo: " + msPeriod + "\nSemana: " + msWeek + "\nDía: " + msDay);
		
	} catch (Exception e) {
	}
%>

<html>
<head>
<script type="text/javascript">
	function doAction(){
		 document.mainform.submit();
	}
</script>
</head>
<body onLoad="doAction()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="530" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>
        <form name="mainform" action="LeaderReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeek %>">
            <input type="hidden" name="day" value="<%= msDay %>">
            <input type="hidden" name="hidTarget">
        </form>
    </body>

</html>