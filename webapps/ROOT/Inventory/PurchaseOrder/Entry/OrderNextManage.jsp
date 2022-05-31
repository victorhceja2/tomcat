<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : OrderNextManage.jsp
# Compa?ia        : Yum Brands Intl
# Autor           : SCP
# Objetivo        : Manejar la secuencia de pedidos adelantados que puede realizar el restaurante
# Fecha Creacion  : 26/abril/2005
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>
<%@page import="java.io.*" %>
<%
String lsAtention = "ATENCION VAS A ADELANTAR EL PEDIDO";
%>

<html>
<head>
<script src='/Scripts/AbcUtilsYum.js'></script>
<link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
<link rel='stylesheet' href='/CSS/TabStandardsYum.css' type='text/css'>
<script language="javascript">
function valida(psToday,psPrvDesc,psPrvMsg){
	psSelectedDate = document.forms[0].psActualDateLimit.value;
	var lsMsg = "";

	if(psSelectedDate ==""){
		alert("No hay fechas disponibles para almacenar el pedido!")
		return(false);
	}

	if( psSelectedDate == psToday){
		//lsMsg += "*** Tu límite es hoy!. Debiste realizar tu pedido como máximo el día de ayer, si lo realizas ahora NO hay garantía de que sea recibido por el proveedor. Comunícate con ellos después de las 12:00 hrs para confirmar que lo tengan, de no ser así, hacer pedido telefónico y se hará un cargo \n\nGracias\n\n";
		lsMsg += "*** Este pedido es de "+psPrvDesc+" ***\n"+psPrvMsg+"\n\nPor su atencion gracias\n\n";
	}else{  
	        if( psPrvDesc == "BACHOCO" ){
	                lsMsg += "******** ESTE PEDIDO ES ADELANTADO!!! ******** \nEstas seguro de que lo quieres adelantar?\n";
		}	
	}
	
	lsMsg += " Deseas confirmar la entrega de tu orden al proveedor para la fecha " + psSelectedDate;
	if(confirm(lsMsg)){
		window.opener.document.forms[0].psDateLimit.value = psSelectedDate;
		//window.opener.confirmDate();
		window.opener.aceptData();
		self.close();
	}
}

function advertencia(){
	var lsMsg = "¿Estas seguro de que deseas adelantar tu pedido?\n\nSi lo confirmas adelantado ya no podrás hacer los pedidos de fechas anteriores a la fecha que elegiste."
	if(confirm(lsMsg)){
		document.forms[0].submit();
	}
}
function message(){
    
    var index = document.forms[0].psActualDateLimit.selectedIndex;
    var lsAtention = "<%=lsAtention%>";
    if(index == "0"){
           document.forms[0].atention.value="";
    }
    else{
           document.forms[0].atention.value=lsAtention;
    }
}
</script>

</head>
<body>
<form action="OrderNextManage.jsp" method="POST">
<table border="0">
<%
String lsActualDateLimit = "";
String lsLimitDates = "";
String lsProviderId = "";
String laPrvDescMsg[][];
int liAux =0;
int liIndexAccDate = 0;
int liNumDates = 0;
try{
	lsActualDateLimit=request.getParameter("psActualDateLimit");
	lsLimitDates=request.getParameter("psLimitDates");
	liIndexAccDate = Integer.parseInt(request.getParameter("piIndexAccDate"));
	liNumDates = Integer.parseInt(request.getParameter("piNumDates"));
}catch(Exception e){}

// Obteniendo el codigo del proveedor
lsProviderId = getProvider();
laPrvDescMsg = getProviderMessage(lsProviderId);

System.out.println("PRVDESC:"+laPrvDescMsg[0][1]);
System.out.println("Dentro de OrderNext lsProviderId = "+lsProviderId);

// Obteniendo el limite de dias en los que se puede adelantar el pedido
int giNumLimitDayAdvance = getNumDaysAdvance(lsProviderId);
// Obteniendo la fecha limite de la ultima orden (si existe dicha fecha)
String gsLastOrderDate = getLastOrderLimitDate(lsProviderId);
// Obtenemos la fecha de la ultima orden generada
String gsLastOrderOnlyDate = gsLastOrderDate.substring(0,gsLastOrderDate.indexOf(" "));
int giLastDate = Integer.parseInt(gsLastOrderOnlyDate.replaceAll("-",""));
//Obteniendo la fecha de hoy, hora y minuto para el caso de que hagan la orden el mismo dia del l?mite
String gsToday = getToday();
String gsOnlyDateToday = gsToday.substring(0,gsToday.indexOf(" "));
String gsOnlyHourToday = gsToday.substring(gsToday.indexOf(" ") + 1, gsToday.indexOf(":"));
String gsOnlyMinuteToday = gsToday.substring(gsToday.indexOf(":")+1);
int giTodayDate = Integer.parseInt(gsOnlyDateToday.replaceAll("-",""));
int liFlagToday = 0; // Para determinar si hoy son antes de las 12
String lsQtyReq;
if(Integer.parseInt(gsOnlyHourToday)>=12){
	liFlagToday =1;
}

if(liNumDates== 0){
	lsLimitDates = getLimitDates(giNumLimitDayAdvance, liFlagToday, gsLastOrderDate, lsProviderId);
	if(!lsLimitDates.equals("")){
		String gaLimitDates[] = lsLimitDates.split("@");
		out.println("<tr>\n");
		out.println("<td class='descriptionTabla' colspan='2'>Este pedido es el que se espera polear para:</td>\n");
		out.println("</tr>\n");
		out.println("<tr>\n");
		out.println("<td class='descriptionTabla' colspan='2' width='70%'><input type='text' name='psActualDateLimit' size='10' maxlength='10' value=\"" + gaLimitDates[liIndexAccDate] + "\" READONLY class ='mainsubtitle'><b class ='mainsubtitle'>&nbsp;&nbsp;ATENCI&Oacute;N</b></td>\n");
		out.println("<tr><td class='mainsubtitle' colspan='2'>Esta es la fecha en la que le entregaremos el pedido al proveedor</td></tr>\n");
		out.println("</tr>\n");
                if(giLastDate >= giTodayDate && lsProviderId.equals("325")){
                        lsQtyReq = getRequiredQty(lsProviderId,gsLastOrderDate);
                        out.println("<tr>\n");
                        out.println("<td class='mainsubtitle' colspan='2' width='70%'>Fecha de confirmaci&oacute;n del ultimo pedido: "+gsLastOrderOnlyDate+"</b></td>\n");
                        out.println("</tr>\n");
                        out.println("<tr>\n");
                        out.println("<td class='mainsubtitle' colspan='2' width='70%'>Cantidad requerida: "+lsQtyReq+" CBZ</b></td>\n");
                        out.println("</tr>\n");
                }
		out.println("<input type='hidden' name='piNumDates' value=\"" +  gaLimitDates.length + "\">\n");
		liAux = gaLimitDates.length;
		liIndexAccDate++;
	}
}else{
	String gaLimitDates[] = lsLimitDates.split("@");
	out.println("<tr>\n");
	out.println("<td class='descriptionTabla' colspan='2'>Este pedido es para:</td>\n");
	out.println("</tr>\n");
	out.println("<tr>\n<td class='descriptionTabla' colspan=2>\n");
	out.println("<select name='psActualDateLimit' class ='tdBgColor' onChange=\"javascript:message()\">\n");
	for(int i=0; i <= liIndexAccDate; i++ ){
		out.println("<option value='" + gaLimitDates[i] +"' \n");
		if(i == liIndexAccDate){
			out.println("selected\n");
		}
		out.println(">"+gaLimitDates[i]+"\n");
	}
        out.println("</select><b><input class='mainsubtitle' size=40 style='border:1px solid white' type=text name='atention' id='atention' value='"+lsAtention+"' readonly></b></td>\n");
	out.println("</tr>\n");
	out.println("<input type='hidden' name='piNumDates' value=\"" +  gaLimitDates.length + "\">\n");
	liAux = gaLimitDates.length;
	liIndexAccDate++;
}
out.println("<input type='hidden' name='piIndexAccDate' value=\"" +  liIndexAccDate + "\">\n");
out.println("<input type='hidden' name='psLimitDates' value=\"" +  lsLimitDates + "\">\n");
out.println("<tr>\n");
out.println("<td class='descriptionTabla' colspan='2'>&nbsp;</td>\n");
out.println("</tr>\n");
out.println("<tr>\n");
out.println("<td class='descriptionTabla' colspan=2>\n");
if(!lsLimitDates.equals("")){
	out.println("<input type='button' value='Aceptar' onClick=\"javascript:valida('" +gsOnlyDateToday+ "','" +laPrvDescMsg[0][0]+"','"+laPrvDescMsg[0][1]+"')\">\n");
}else{
	out.println("&nbsp;\n");
}
out.println("</td></tr>\n");


// Esta condicion me indica si aún tenemos fechas para adelantar siga poniendo el botón de siguiente Pedido
if(liIndexAccDate != liNumDates && liAux !=1 ){
	out.println("<tr><td class='descriptionTabla' colspan='2'>* Si deseas adelantar el pedido y la fecha no es la correcta pulsa el botón del \"Siguiente pedido\" para elegir la siguiente fecha</td></tr>\n");
}else{
	out.println("&nbsp;\n");
	out.println("</td></tr>\n");
	out.println("<tr><td class='mainsubtitle' colspan='2'>* Ya adelantaste los pedidos de los siguientes " + giNumLimitDayAdvance + " días y no es posible adelantar más.</td></tr>\n");
	out.println("<tr><td class='mainsubtitle' colspan='2'>&nbsp;</td></tr>\n");
	if(liAux == 1 || liAux==0){
		out.println("<tr><td class='mainsubtitle' colspan='2' align='center'>\n");
		out.println("<input type='button' value='Cerrar' onClick='javascript:window.opener.close();self.close();'>\n");
		out.println("</td></tr>\n");
	}
}

//Esta condicion se usa para desplegar un mensaje para elegir fechas anteriores, pero después de la pulsación de Siguiente Pedido
if(liNumDates!= 0){
	out.println("<tr><td class='descriptionTabla' colspan='2'>* Si deseas elegir un pedido de las fechas anteriores disponibles, seleccionalo de la lista desplegable.</td></tr>\n");
}else{
	out.println("<tr><td class='descriptionTabla' colspan=2>&nbsp;</td></tr>\n");
}

// Esta condicion me indica si aún tenemos fechas para adelantar siga poniendo el botón de siguiente Pedido
if(liIndexAccDate != liNumDates && liAux !=1 ){
	out.println("<tr><td class='descriptionTabla' colspan=2>\n");
	//out.println("<input type='button' value='Siguiente pedido' onClick=\"javascript:document.forms[0].submit()\">\n");
	out.println("<input type='button' value='Siguiente pedido' onClick=\"javascript:advertencia()\">\n");
	out.println("</td></tr>\n");
}else{
	out.println("<tr><td class='descriptionTabla' colspan=2>&nbsp;</td></tr>\n");
}

%>
</table>
</form>
</body>
</html>
<%!
String getLastOrderLimitDate(String psProviderId){
	String lsQuery = "";
	String lsLastOrderDate = "";
	AbcUtils loAbcUtils = new AbcUtils();
	lsQuery = "SELECT (Case when date_limit IS NULL then '1970-01-01 12:00:00' else date_limit end)";
	lsQuery += " FROM op_grl_order";
	lsQuery += " WHERE order_id=(SELECT max(order_id) FROM op_grl_order_detail WHERE provider_id like '"+psProviderId+"%')";
	lsLastOrderDate = loAbcUtils.queryToString(lsQuery,"","");
	return(lsLastOrderDate);
}

int getNumDaysAdvance(String psProviderId){
	String lsQuery = "";
	int liNumLimitDayAdvance=0;
	AbcUtils loAbcUtils = new AbcUtils();
	lsQuery += "SELECT num_days_advance FROM op_grl_days_advance_order WHERE provider_id = '"+psProviderId+"'";
	liNumLimitDayAdvance=Integer.parseInt(loAbcUtils.queryToString(lsQuery,"",""));
	return(liNumLimitDayAdvance);
}

String getProvider(){
        String lsQuery = "SELECT DISTINCT(TRIM(provider_id)) FROM op_grl_step_order_detail WHERE order_id = 0 limit 1";
        AbcUtils loAbcUtils = new AbcUtils();
        return loAbcUtils.queryToString(lsQuery);
}

String getRequiredQty(String psProviderId, String lsDateLimit){
        String lsQuery = "SELECT prv_required_quantity FROM op_grl_order_detail WHERE provider_id = "+psProviderId+" AND order_id IN ";
        lsQuery += "(SELECT order_id FROM op_grl_order WHERE date_limit = '"+lsDateLimit+"') ";
        AbcUtils loAbcUtils = new AbcUtils();
        return loAbcUtils.queryToString(lsQuery);
}

String [][] getProviderMessage(String psProviderId){
        String lsQuery = "SELECT TRIM(provider_desc),LTRIM(provider_msg) FROM op_grl_cat_prv_msg WHERE provider_id like '"+psProviderId+"%'";
        AbcUtils loAbcUtils = new AbcUtils();
        return loAbcUtils.queryToMatrix(lsQuery);
}

String getToday(){
	String lsQuery = "";
	String lsToday = "";
	AbcUtils loAbcUtils = new AbcUtils();
	lsQuery += "SELECT to_char(timestamp 'now','YYYY-MM-DD HH24:MI')";
	lsToday = loAbcUtils.queryToString(lsQuery,"","");
	return(lsToday);
}

String getLimitDates(int piNumLimitDayAdvance, int piFlagToday, String  psLastOrderDate, String psProviderId){
	String lsQuery = "";
	String lsLimitDates = "";
	AbcUtils loAbcUtils = new AbcUtils();
	lsQuery += " SELECT to_char(date_id,'YYYY-MM-DD')";
	lsQuery += " FROM ss_cat_time";
	if(piFlagToday == 1){
		lsQuery += " WHERE date_id BETWEEN (CURRENT_DATE + interval '1 days') AND (CURRENT_DATE + interval '"+ piNumLimitDayAdvance +" days' )";
	}else{
		lsQuery += " WHERE date_id BETWEEN CURRENT_DATE AND (CURRENT_DATE + interval '"+ piNumLimitDayAdvance +" days' )";
	}
	lsQuery += " AND weekday_id IN (SELECT weekday_id FROM op_grl_order_limit WHERE provider_id like '"+psProviderId+"%')";
	if(!psLastOrderDate.equals("1970-01-01 12:00:00")){
		lsQuery += " AND date_id > '" +  psLastOrderDate+ "'";
	}
	lsQuery += " ORDER BY date_id";
	System.out.println(lsQuery);

	lsLimitDates = loAbcUtils.queryToString(lsQuery,"@","");

 	return(lsLimitDates);
}
%>
