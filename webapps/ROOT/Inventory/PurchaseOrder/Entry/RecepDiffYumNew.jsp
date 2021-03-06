<jsp:include page = '/Include/ValidateSessionYum.jsp'/>


<%--
##########################################################################################################
# Nombre Archivo  : RecepDiffYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sandra Castro
# Objetivo        : Reporte de Diferencias antes de Confirmacion de Recepcion
# Fecha Creacion  : 22/ago/2006
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>

<%
    String msRecep="";
    String msStepRecep="0";

    String lsPrv="";
    String psPrv="";
    String msRem="";
    String lsNumRpt="";
    AbcUtils moAbcUtils = new AbcUtils();

    try{
        lsNumRpt=request.getParameter("txtNumRpt");
        if (lsNumRpt.equals("")) lsNumRpt=lsNumRpt;
    }catch(Exception moExcpetion){lsNumRpt="";}

    try{
        msRecep=request.getParameter("hidRecep");
        if (msRecep.equals("")) msRecep=msRecep;
    }catch(Exception e){
        msRecep="";
    }

    try{
        msRem=request.getParameter("hidRem");
        if (msRem.equals("")) msRem=msRem;
    }catch(Exception e){
        msRem="";
    }

    try{
        msStepRecep=request.getParameter("msStepRecep");
        if (msStepRecep.equals("")) msStepRecep=msStepRecep;
    }catch(Exception moExcpetion){msStepRecep="0";}

	/*Inserta registros en tabla de diferencias de paso*/
	insertIntoStepDifference(msRecep, moAbcUtils);


    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation ="";
    try{
        msOperation = request.getParameter("hidOperation");
    }catch(Exception e){}

     String msPresentation = (msOperation==null)?"VIEWPORT":msOperation;
//     String msPresentation = (msOperation==null)?"PRINTER":msOperation;
    if (!msStepRecep.equals("0"))
       moHtmlAppHandler.setPresentation("PRINTER");
    else
       moHtmlAppHandler.setPresentation(msPresentation);

    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    String msFontMain = moHtmlAppHandler.moReportHeader.msFontMain;
    String msFontSub = moHtmlAppHandler.moReportHeader.msFontSub;
    String msFontEnd = "</font>";


    if (msStepRecep.equals("0"))
        //moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte de Discrepancias ", msPresentation);
	moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte de Discrepancias ", "Printer");
     else
//         moHtmlAppHandler.msReportTitle = getCustomHeader("Confirmaci??? de Nmero de Reporte ", msPresentation);
	moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte de Discrepancias ", "Printer");

    moHtmlAppHandler.moReportTable.setTableHeaders("||Pedido|Pedido|Pedido|Pedido|Recepci&oacute;n|Recepci&oacute;n|Recepci&oacute;n|Recepci&oacute;n||| ",0,true);
    moHtmlAppHandler.moReportTable.setTableHeaders("-|Producto|Codigo<br>Producto<br>Solicitado|Cantidad<br>Requerida|Equiv<br>Unidad<br>Inv|Costo|Codigo<br>Producto<br>Recibido|Cantidad<br>Recibida|Equiv<br>Unidad<br>Inv|Costo|C&oacute;digo<br>Discr.|Differencia<br>Unid<br>Prov|Differencia<br>Unid<br>Inv",1,false);
    moHtmlAppHandler.moReportTable.setFieldFormats("|||||||||||| ");
    moHtmlAppHandler.moReportTable.setFieldColors("#E6E6FA|#E6E6FA|#66CCFF|#66CCFF|#66CCFF|#66CCFF|#CCFFFF|#CCFFFF|#CCFFFF|#CCFFFF|#E6E6FA|#E6E6FA|#E6E6FA",2);
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }

%>

<html>
    <head>
        <title><%
	if (msStepRecep.equals("0"))
		out.println("Reporte de Discrepancias");
// 	else
// 		out.println("Confirmaci??? de Nmero de Reporte");
	%>
	</title>
        <link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
    </head>
    <script src='/Scripts/ReportUtilsYum.js'></script>
    <script src='/Scripts/AbcUtilsYum.js'></script>
    <script>

        function handleOK() {

            if (opener && !opener.closed) {
                opener.dialogWin.returnFunc();
            } else {
                alert("Se ha cerrado la ventana principal.\n\nNo se realizaran cambios pormedio de este cuadro de dialogo.");
            }

            return(false);
        }

        function returnData(psParam) {
            parent.opener.dialogWin.returnedValue = psParam;
            handleOK();
            window.close();
        }

        function aceptData(){
//             if (document.frm_confirm.txtNumRpt.length==0 || document.frm_confirm.txtNumRpt.value==""){
//                 alert('Para confirmar las diferencias, ingresa el numero de Reporte del proveedor. \n Si no obtuviste el No. de reporte del proveedor, ingresa 0.');
//                 document.frm_confirm.txtNumRpt.focus();
//                 return(false);
//             }else{
//                 executePageDW('PRINTER');
                document.frm_confirm.action='RecepConfirmYum.jsp';
                document.frm_confirm.submit();
//             }

        }

        function cancelData(){
            document.frm_confirm.action='RecepDetailYum.jsp';
            document.frm_confirm.target='ifrDetail';
            document.frm_confirm.submit();
            window.close();
        }

        function loadFunction() {
            if (opener) opener.blockEvents();
        }

 	function executeReportCustom(){
 			window.print(); 
 	}
</script>

    </script>
    <body  bgcolor = 'white' <%=moHtmlAppHandler.moReportHeader.getBodyStyle() %> onload="javascript:executePageDW('PRINTER');">
            <% if (msPresentation.equals("VIEWPORT")) { %>
                    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
                        <jsp:param name = 'psPrintOption' value = 'yes'/>
                    </jsp:include>
            <% } else { %>
                    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
            <% } %>

            <%=msFontSub%>
	    	&nbsp;Centro de contribuci&oacute;n: <b><%=getStore()%>&nbsp;<%=getStoreName()%><br>
                &nbsp;No. Recepci&oacute;n:<b><% if (!msRecep.equals("")) out.println(msRecep); else  out.println(msStepRecep); %></b>
            <%=msFontEnd%>
            <br>
            <form name ='frm_confirm' id ='frm_confirm' method='get'>
            <% try{
//                AbcUtils moAbcUtils = new AbcUtils();
	       String lsDiscrepDescrip = getQueryDiscDesc();
//             if (msStepRecep==null) msStepRecep="0";
//                 if (!msStepRecep.equals("0")){
// 			String lsUpdateQuery="UPDATE op_grl_reception SET report_num=? WHERE reception_id=?";
//                   	moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsNumRpt.trim(),msStepRecep});
// 			out.println("<p class=descriptionTabla><b>Reporte del Proveedor Capturado:"+lsNumRpt+"</b></p>");
// 			moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msStepRecep));
// 
// 			String lsDeleteQuery = "DELETE from op_grl_step_reception_detail";
// 			moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});
// 			lsDeleteQuery = "DELETE from op_grl_step_reception ";
// 			moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});
//             }else {
                 lsPrv=moAbcUtils.queryToString("SELECT provider_id from op_grl_step_reception WHERE reception_id="+msRecep+"","","");
                 if (msPresentation.equals("VIEWPORT") || msPresentation.equals("")){ %>
                    <input type = 'hidden' name = 'msStepRecep1' value ='<%=msRecep%>'>
                    <input type = 'hidden' name = 'hidOperation' value ='S'>
		    <input type='hidden' name='hidRem' value='<%= msRem %>'>
		    <input type='hidden' name='hidRecep' value='<%= msRecep %>'>
		    <input type='hidden' name='hidOrigen' value='diff'>
			<br>
                    <input type = 'button' name = 'cmd_ok' value = '  Aceptar  ' OnClick = 'aceptData();'>
                    <input type = 'button' name = 'cmd_cancel' value = ' Cancelar ' OnClick = 'cancelData();'
			<br><br>
                    
                 <%
		 }
			//else if (msPresentation.equals("PRINTER")){
                 %>
		 <!--<a href="javascript:history.back();" class="mainsubtitle"> << Continuar con la captura del No. de Reporte del Proveedor. </a>-->

		  <!--<br><br>-->

		 <%
                 //}
                 moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msRecep)); //,lsDiscrepDescrip));
            %>
            <% //}

             }catch(Exception moExcpetion) {
                moExcpetion.printStackTrace();
             }
            %>
            </form>
		<br><br><br><br>
		<table border="0" width="50%" align="center">
		<tr>
			<td class="descriptionTabla" align="center">
			______________________________________________<br>
			<b>Firma y Nombre del gerente o jefe de piso</b><br><br>
			Acepto las diferencias que aparecen en este reporte como las correctas.	
			</td>
		</tr>
		<table>
		
            <jsp:include page = '/Include/TerminatePageYum.jsp'/>

    </body>
</html>

<%!

void insertIntoStepDifference(String psRecep, AbcUtils moAbcUtils){
	String lsRem = "";
        String lsOrd = "";
        String lsPrv = "";
        String lsDiscrepDesc="";
        String lsQuery = "";
	lsRem=moAbcUtils.queryToString("SELECT ltrim(rtrim(remission_id)) FROM op_grl_step_reception WHERE reception_id ="+psRecep,"","");
	lsOrd=moAbcUtils.queryToString("SELECT ltrim(rtrim(CAST(order_id AS CHAR(5)))) FROM op_grl_step_reception WHERE reception_id ="+psRecep,"","");
        lsPrv=moAbcUtils.queryToString("SELECT ltrim(rtrim(provider_id)) FROM op_grl_step_reception WHERE reception_id ="+psRecep,"","");

	lsQuery += " SELECT d.dif_desc FROM op_grl_cat_difference d";
        lsQuery += " INNER JOIN op_grl_cat_config_difference cd ON cd.difference_id = d.difference_id";
        lsQuery += " WHERE case_id=7";
        lsQuery += " ORDER BY sort_seq LIMIT 1";
        
        lsDiscrepDesc = moAbcUtils.queryToString(lsQuery,"","");

	if (!lsOrd.equals("-1") && !lsOrd.equals("") ){
		lsQuery = "INSERT INTO op_grl_step_difference ";
		/*******QUERY DE ELEMENTOS QUE MATCHEAN ENTRE ORDEN Y RECEPCION*******/
		lsQuery += "SELECT " + psRecep +",";
		lsQuery += " i.inv_desc as product_name,";
		lsQuery += " od.provider_product_code as order_product,";
		lsQuery += " ltrim(to_char(od.prv_required_quantity, '9999990.99'))||' '||m.unit_name as qty_required,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
		lsQuery += " od.prv_required_quantity*od.unit_cost as ord_cost,";
		lsQuery += " rd.provider_product_code as recep_product,";
		lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name) as qty_received,";
		lsQuery += " to_char(ROUND((Case When rd.received_quantity IS Null then 0 else rd.received_quantity end)*(Case When p.conversion_factor IS NULL then 0 else p.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as recep_equivalent,";
		lsQuery += " rd.received_quantity*rd.unit_cost as recep_cost,";
		lsQuery += " d.dif_desc,";
		lsQuery += " to_char(rd.received_quantity - od.prv_required_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
		lsQuery += " to_char((rd.received_quantity -od.prv_required_quantity)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
		lsQuery += " FROM op_grl_order_detail od";
		lsQuery += " INNER JOIN op_grl_step_reception_detail rd ON rd.provider_product_code = od.provider_product_code AND od.provider_id = rd.provider_id";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code AND p.provider_id = od.provider_id";
		lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
		lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
		lsQuery += " WHERE od.order_id = " + lsOrd;
		lsQuery += " AND rd.reception_id = " + psRecep;
		lsQuery += " AND rd.provider_id = '" + lsPrv + "'";
		lsQuery += " AND (rd.received_quantity - od.prv_required_quantity) <> 0";
		/*******QUERY DE ELEMENTOS QUE MATCHEAN ENTRE ORDEN Y RECEPCION, PERO TIENEN UN CODIGO DE PROVEEDOR DIFERENTE******/
		lsQuery += " \nUNION\n";
		lsQuery += " SELECT " + psRecep +",";
		lsQuery += " i.inv_desc as product_name,";
		lsQuery += " p1.provider_product_code as provider_product_code_order,";
		lsQuery += " ltrim(to_char(od.prv_required_quantity, '9999990.99'))||' '||m.unit_name as qty_required,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
		lsQuery += " od.prv_required_quantity*od.unit_cost as ord_cost,";
		lsQuery += " p2.provider_product_code as provider_product_code_recep,";
		lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name) as qty_received,";
		lsQuery += " to_char(ROUND((Case When rd.received_quantity IS Null then 0 else rd.received_quantity end)*(Case When p2.conversion_factor IS NULL then 0 else p2.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as recep_equivalent,";
		lsQuery += " rd.received_quantity*rd.unit_cost as recep_cost,";
		lsQuery += " d.dif_desc,";
		lsQuery += " to_char(rd.received_quantity - od.prv_required_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
		lsQuery += " to_char((rd.received_quantity -od.prv_required_quantity)*(Case When p2.conversion_factor = Null then 0 else p2.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
		lsQuery += " FROM op_grl_cat_providers_product p1";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.inv_id = p1.inv_id AND p2.provider_id = p1.provider_id";
		lsQuery += " INNER JOIN op_grl_order_detail od ON od.provider_product_code = p1.provider_product_code AND od.provider_id = p1.provider_id";
		lsQuery += " INNER JOIN op_grl_step_reception_detail rd ON rd.provider_product_code = p2.provider_product_code AND rd.provider_id = p2.provider_id";
		lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p1.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
		lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
		lsQuery += " WHERE  p1.provider_product_code <> p2.provider_product_code";
		lsQuery += " AND od.order_id = "+ lsOrd;
		lsQuery += " AND rd.reception_id = " + psRecep;
		lsQuery += " AND rd.provider_id = '"+ lsPrv + "'";
		/*******QUERY DE ELEMENTOS QUE ESTAN EN ORDEN, PERO NO EN RECEPCION*******/
        	lsQuery += " \nUNION\n";

		lsQuery += " SELECT " + psRecep +",";
		lsQuery += " i.inv_desc as product_name,";
		lsQuery += " od.provider_product_code as order_product,";
		lsQuery += " ltrim(to_char(od.prv_required_quantity, '9999990.99'))||' '||m.unit_name as qty_required,";
		lsQuery += " to_char(ROUND((Case When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)*(Case When p1.conversion_factor = Null then 0 else p1.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
		lsQuery += " od.prv_required_quantity*od.unit_cost as ord_cost,";
		lsQuery += " '' as recep_product_product,";
		lsQuery += " '' as qty_received,";
		lsQuery += " '' as recep_equivalent,";
		lsQuery += " CAST ('0' as integer) as recep_cost,";
		lsQuery += " CAST('"+ lsDiscrepDesc + "' as varchar) as dif_desc,";
		lsQuery += " to_char(0 -od.prv_required_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
		lsQuery += " to_char((0 -od.prv_required_quantity)*(Case When p1.conversion_factor = Null then 0 else p1.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
		lsQuery += " FROM op_grl_order_detail od";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code = od.provider_product_code AND od.provider_id = p1.provider_id";
		lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p1.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
		lsQuery += " WHERE od.order_id = " + lsOrd;
		lsQuery += " AND od.provider_id = '" +  lsPrv + "'";
		lsQuery += " AND p1.inv_id NOT IN";
		lsQuery += " (SELECT p2.inv_id";
		lsQuery += " FROM op_grl_step_reception_detail rd";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = rd.provider_product_code";
		lsQuery += " WHERE rd.reception_id=" + psRecep;
		lsQuery += " )";
		/*******QUERY DE ELEMENTOS QUE ESTAN EN RECEPCION, PERO NO EN ORDEN*******/
		lsQuery += " \nUNION\n";
		lsQuery += " SELECT " + psRecep +",";
		lsQuery += " i.inv_desc as product_name,";
		lsQuery += " '' as order_product,";
		lsQuery += " '' as qty_required,";
		lsQuery += " '' as order_equivalent,";
		lsQuery += " CAST('0' as integer) as ord_cost,";
		lsQuery += " rd.provider_product_code as recep_product,";
		lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name) as qty_received,";
		lsQuery += " to_char(ROUND((Case When rd.received_quantity IS Null then 0 else rd.received_quantity end)*(Case When p1.conversion_factor IS NULL then 0 else p1.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as recep_equivalent,";
		lsQuery += " rd.received_quantity*rd.unit_cost as recep_cost,";
		lsQuery += " d.dif_desc,";
		lsQuery += " to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
		lsQuery += " to_char((rd.received_quantity)*(Case When p1.conversion_factor = Null then 0 else p1.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
		lsQuery += " FROM op_grl_step_reception_detail rd";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code = rd.provider_product_code AND p1.provider_id = rd.provider_id";
		lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p1.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p1.provider_unit_measure";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
		lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
		lsQuery += " WHERE rd.reception_id = " + psRecep ;
		lsQuery += " AND rd.provider_id = '"+ lsPrv + "'";
		lsQuery += " AND p1.inv_id NOT IN (";
		lsQuery += " SELECT p2.inv_id";
		lsQuery += " FROM op_grl_order_detail od";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = od.provider_product_code AND p2.provider_id = od.provider_id";
		lsQuery += " WHERE od.order_id=" + lsOrd;
		lsQuery += " )";
		moAbcUtils.executeSQLCommand(lsQuery, new String[]{});
	}
}

String getQueryReport(String  psRecep) {
	String lsQuery = "";
	AbcUtils moAbcUtils = new AbcUtils();
	String lsContNeg =moAbcUtils.queryToString("SELECT count(*) FROM op_grl_step_difference WHERE reception_id ="+psRecep + " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'","","");
	int liContNeg=Integer.parseInt(lsContNeg.trim());
	String lsContPos =moAbcUtils.queryToString("SELECT count(*) FROM op_grl_step_difference WHERE reception_id ="+psRecep + " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'","","");
	int liContPos=Integer.parseInt(lsContPos.trim());
	if(liContNeg > 0){
		//System.out.println("lsContNeg: " + lsContNeg + "\nliContNeg: "+ liContNeg);
		lsQuery+= "SELECT '0' as control,product_name, order_product, qty_required, order_equivalent, ";
		lsQuery+= "to_char(ord_cost,'999999990.99') as ord_cost, recep_product, ";
		lsQuery+= "qty_received, recep_equivalent, to_char(recep_cost, '99999990.99') as recep_cost, ";
		lsQuery+= "dif_desc, dif_prv, dif_inv  FROM op_grl_step_difference WHERE reception_id ="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'";
		lsQuery+= " UNION ";
		lsQuery+= "SELECT '1' as control,' ',' ',' ','Total Orden:', '<b>' || to_char( sum(ord_cost), '99999990.99') || '</b>' as ord_cost, ";
		lsQuery+= " ' ',' ','Total Recepcion:','<b>' || to_char(sum(recep_cost), '999999990.99') || '</b>' as recep_cost,'','','' ";
		lsQuery+= "FROM op_grl_step_difference WHERE reception_id="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'";
	}
	if(liContNeg > 0 && liContPos > 0){
 		lsQuery+= " UNION ";
		lsQuery+= "SELECT '2' as control ,' ',' ',' ',' ', ' ', ";
		lsQuery+= " ' ',' ',' ',' ','','','' ";
		lsQuery+= " UNION ";
	}
	if(liContPos > 0){
		lsQuery+= "SELECT '3' as control,product_name, order_product, qty_required, order_equivalent, ";
		lsQuery+= "to_char(ord_cost,'999999990.99') as ord_cost, recep_product, ";
		lsQuery+= "qty_received, recep_equivalent, to_char(recep_cost, '99999990.99') as recep_cost, ";
		lsQuery+= "dif_desc, dif_prv, dif_inv  FROM op_grl_step_difference WHERE reception_id ="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'";
		lsQuery+= " UNION ";
		lsQuery+= "SELECT '4' as control,' ',' ',' ','Total Orden:', '<b>' || to_char( sum(ord_cost), '99999990.99') || '</b>' as ord_cost, ";
		lsQuery+= " ' ',' ','Total Recepcion:','<b>' || to_char(sum(recep_cost), '999999990.99') || '</b>' as recep_cost,'','','' ";
		lsQuery+= "FROM op_grl_step_difference WHERE reception_id="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'";
		lsQuery+= " ORDER BY control ASC";
	}
	if(liContNeg == 0 && liContPos == 0){
		lsQuery+= "SELECT ' ' as control ,' ','<b>NO</b>','<b>HAY</b> ','<b>DIFERENCIAS</b> ', ' ', ";
		lsQuery+= " '<b>NO</b>','<b>HAY</b> ','<b>DIFERENCIAS</b> ',' ','<b>NO</b>','<b>HAY</b>',";
		lsQuery+= " '<b>DIFERENCIAS</b> ' ";
	}
	return(lsQuery);
}

   String getStore(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsStore=moAbcUtils.queryToString("SELECT store_id from ss_cat_store ","","");
        return(lsStore);
   }

   String getStoreName(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsStore=moAbcUtils.queryToString("SELECT store_desc from ss_cat_store ","","");
        return(lsStore);
   }

   String getCustomHeader(String psTitle, String psPresentation){
   	String lsHeader ="";
	String lsReportTitle="";
	String lsOthers ="";
   	if(psPresentation.equals("VIEWPORT")){
		lsReportTitle = "mainsubtitle";
		lsOthers = "descriptionTabla";
	}else{
		lsReportTitle = "mainsubtitlePrn";
		lsOthers = "descriptionTablaPrn";
	}
	lsHeader +=  "<table border='0' width='100%'>";
	lsHeader += "<tr>";
	lsHeader += "<td width='80%' class='" + lsOthers + "'>";
	lsHeader += "<b>Yum! Restaurants International</b>";
	lsHeader += "</td>";
	lsHeader += "<td width='20%' class='" + lsOthers +"'>";
	lsHeader += "<img src='/Images/Menu/yum_icons.gif'>";
	lsHeader += "</td>";
	lsHeader += "</tr>";
	lsHeader += "<tr><td colspan=2 class='" + lsOthers + "'>&nbsp;</td></tr>";
	lsHeader += "<tr>";
	lsHeader += "<td colspan=2 class='"+ lsReportTitle +"'>";
	lsHeader += psTitle;
	lsHeader += "</td>";
	lsHeader += "</tr>";
	lsHeader += "</table>";
	return(lsHeader);
   }

//    String getDateTime(){
//         String lsDate="";
//         Date ldToday=new Date();
//         String DATE_FORMAT = "yy-MM-dd_hh:mm:ss";
//         int liMonth=(int)ldToday.getMonth();
//         int liDay=(int)ldToday.getDate();
//         java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
//         Calendar lsC1 = Calendar.getInstance();
//         lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay);
// 
//         lsDate=lsDF.format(lsC1.getTime());
//         return(lsDate);
//    }

   String getQueryDiscDesc(){
		int case_id = 7; //Es el de diferencia entre orden y recepcion, cuando el elemento de la orden no esta en la recepcion
    		String lsQuery = "";
		lsQuery += " SELECT d.dif_desc FROM op_grl_cat_difference d";
		lsQuery +=" INNER JOIN op_grl_cat_config_difference cd ON cd.difference_id = d.difference_id";
		lsQuery +=" WHERE case_id=" + case_id;
		lsQuery += " ORDER BY sort_seq LIMIT 1";
		AbcUtils moAbcUtils = new AbcUtils();
        	String lsSelectedDefault=moAbcUtils.queryToString(lsQuery,"","");
		return(lsSelectedDefault);
}

%>
