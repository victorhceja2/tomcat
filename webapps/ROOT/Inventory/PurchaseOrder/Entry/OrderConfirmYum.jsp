<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : OrderConfirmYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Confirmación de orden de compra
# Fecha Creacion  : 17/Septiembre/2004
# Inc/requires    :
# Modificaciones  : Eduardo Zarate (laliux)
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>   
<%! AbcUtils moAbcUtils = new AbcUtils();  %>

<%
    int miOrder=0;
    int miStore=0;
    int miNumItems=0;
    String msStepOrder="-1";
    String msStepStore="0";
    String msDateLimit = "";
System.out.println("Estos son los parametros que se le pasan a OrderConfirmYum.jsp");
    try{
        miOrder=Integer.parseInt(request.getParameter("hidOrder"));
        miStore=Integer.parseInt(request.getParameter("hidStore"));
    }catch(Exception e){
System.out.println("Entrando en el catch");
	msStepOrder=request.getParameter("hidStepOrder");
        msStepStore=request.getParameter("hidStepStore");
    }
System.out.println("msStepOrder="+msStepOrder);
System.out.println("msStepStore="+msStepStore);
System.out.print("miOrder=");
System.out.println(miOrder);
System.out.print("miStore=");
System.out.println(miStore);

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation ="";
    try{
        msOperation = request.getParameter("hidOperation");
    }catch(Exception e){
        System.out.println("msOperation="+msOperation);
    }
	
System.out.println("Antes del try msDateLimit="+msDateLimit);
    try{
	msDateLimit = request.getParameter("psDateLimit");
	miNumItems = Integer.parseInt(request.getParameter("piNumItems"));
    }catch(Exception e){
        System.out.println("Error en msDateLimit");
    }

System.out.println("msDateLimit="+msDateLimit);
System.out.print("miNumItems=");
System.out.println(miNumItems);

    String msPresentation = (msOperation==null)?"VIEWPORT":msOperation;
    if (!msStepOrder.equals("-1"))
       moHtmlAppHandler.setPresentation("PRINTER");
    else
       moHtmlAppHandler.setPresentation(msPresentation);

    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    String msFontMain = moHtmlAppHandler.moReportHeader.msFontMain;
    String msFontSub = moHtmlAppHandler.moReportHeader.msFontSub;
    String msFontEnd = "</font>";

    if (msStepOrder.equals("-1"))
		moHtmlAppHandler.msReportTitle = getCustomHeader("Revisi&oacute;n de pedido", "Printer");
    else
        moHtmlAppHandler.msReportTitle = getCustomHeader("Confirmacion de pedido", "Printer");

    moHtmlAppHandler.moReportTable.setTableHeaders("|||Datos del Sistema|Datos del Sistema|Datos del Sistema|Datos del Sistema||Esto estas Pidiendo|Esto estas Pidiendo|Esto estas Pidiendo|| ",0,true);
    moHtmlAppHandler.moReportTable.setTableHeaders("Codigo Producto|Producto|Proveedor|Cantidad<br>Disponible|Pron&oacute;stico<br>Requerido|Producto<br>en tr&aacute;nsito|Sugerido|Cantidad<br>Requerida|Equiv<br>Unidad<br>Prov|Pedido<br>Unidad<br>Prov|Pedido<br>Unidad<br>Inv|Dif vs Sug|Costo",1,false);
    moHtmlAppHandler.moReportTable.setFieldFormats("||||||||||||##,###.##");
    moHtmlAppHandler.moReportTable.setFieldColors("#E6E6FA|#E6E6FA|#E6E6FA|#66CCFF|#66CCFF|#66CCFF|#66CCFF|#E6E6FA|#CCFFFF|#CCFFFF|#CCFFFF|#E6E6FA|#E6E6FA",2);
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }
%>

<html>
<head>
    <title>
	<%
	if (msStepOrder.equals("-1"))
		out.println("Revisión de Órden de Compra");
	else
		out.println("Confirmación de Órden de Compra");
	%>
	</title>
    <link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
    <script src='/Scripts/ReportUtilsYum.js'></script>
    <script src='/Scripts/AbcUtilsYum.js'></script>

    <!-- Para tener control en el "doble-click" -->
    <script src='/Scripts/DoubleClickYum.js'></script>

    <script>
	    var giWinControlClose=0;
        function handleOK() {
            if (opener && !opener.closed) {
                opener.dialogWin.returnFunc();
            } else {
                alert("Se ha cerrado la ventana principal.\n\nNo se realizaran cambios por medio de este cuadro de dialogo.");
            }
            return(false);
        }

        function returnData(psParam) {
            parent.opener.dialogWin.returnedValue = psParam;
            handleOK();
            window.close();
        }

        function confirmDate()
        {
            if(document.frm_confirm.piNumItems.value!=0)
                //window.open('OrderNextManage.jsp','auxWindow2','height=250, width=350, menubar=no,scrollbars=yes,resizable=yes, statusbar=yes, toolbar=no,left=300, top=200');
                window.open('OrderNextManage.jsp','auxWindow2','height=300, width=400, menubar=no,scrollbars=yes,resizable=yes, statusbar=yes, toolbar=no,left=300, top=200');
            else
                aceptData();
        }

        function aceptData()
        {
            giWinControlClose=1;
            opener.parent.liRowCount=0;
            opener.parent.lsProductoCodeLst="";
            document.frm_confirm.action='OrderConfirmYum.jsp';
            document.frm_confirm.submit();
        }

        function cancelData(){
            document.frm_confirm.action='OrderDetailYum.jsp';
            document.frm_confirm.target='ifrDetail';
            document.frm_confirm.submit();
            window.close();
        }

        function loadFunction()
        {
            if (opener) opener.blockEvents();
        }

        function doClose()
        {
            if(giWinControlClose==0)
                cancelData();
        }

        function showOrderConfirm(psOrderNum)
        {
            opener.parent.location.href = 'OrderYum.jsp';
            location.href = 'ShowOrderYum.jsp?orderId='+psOrderNum;
        }
    </script>
</head>
<body onUnload="doClose()" bgcolor="white" >
    <%
    try
    {
        //AbcUtils moAbcUtils = new AbcUtils();
	    String lsNumOrder=getNumOrder();
        
        if(msStepOrder==null) msStepOrder="-1";

        if(!msStepOrder.equals("-1")) //Se confirma la orden
        {
            String lsUpdateQuery = "UPDATE op_grl_step_order_detail SET  order_id=?";
            moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsNumOrder });

            lsUpdateQuery = "UPDATE op_grl_step_order SET  date_limit=?";
            moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{msDateLimit});

            lsUpdateQuery = "UPDATE op_grl_step_order SET  order_id=?";
            moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsNumOrder});

            String lsInsertQuery = "INSERT INTO op_grl_order SELECT * from op_grl_step_order  WHERE order_id=? ";
            moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{lsNumOrder});

            lsInsertQuery = "INSERT INTO op_grl_order_detail SELECT * from op_grl_step_order_detail WHERE order_id=? ";
            moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{lsNumOrder});

            String lsPathShell ="/usr/local/tomcat/webapps/ROOT/Scripts/PGDBUtils.s";
            String lsPath="/usr/bin/ph/3w_orden/"+getDateTime()+".txt";
            String laCommand[] ={lsPathShell, "true", getQueryOrderFile(lsNumOrder,msStepStore),lsPath};

            try
            {
                Process loStatus= Runtime.getRuntime().exec(laCommand);
            }
            catch(Exception poException)
            {
                out.println("alert('Error en la generación de la órden. Contacta a sistemas.')");
            }

            lsUpdateQuery = "UPDATE op_grl_suggested_order SET order_id=? WHERE order_id=0";
  	    moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsNumOrder});

            lsUpdateQuery = "UPDATE op_grl_way_order SET order_id=? WHERE order_id=0";
  	    moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsNumOrder});

            String lsDeleteQuery = "DELETE from  op_grl_step_order_detail  ";	
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});

            lsDeleteQuery = "DELETE from  op_grl_step_order ";			
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});

            //moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(Integer.parseInt(lsNumOrder),Integer.parseInt(msStepStore)));
            out.println("<script>");
            out.println("giWinControlClose=1;");
            out.println("showOrderConfirm('"+lsNumOrder+"')");
            out.println("</script>");
        }
        else //Revision de la Orden
        {
        %>
            <jsp:include page="/Include/GenerateHeaderYum.jsp">
		        <jsp:param name="psStoreName" value="true"/>
            </jsp:include>

            <form name ="frm_confirm" id ="frm_confirm" method="get">
            <table width="98%" border="0" align="center" cellspacing="0">
            <tr>
                <td class="descriptionTabla" width="10%">
                    N&uacute;mero de pedido:
                </td>
                <td class="descriptionTabla" width="90%">
                    <b><%=getNumOrder()%></b>
                </td>
            </tr>
            <tr>
                <td colspan="2" class="descriptionTabla" width="10%">
                    <b>Desea confirmar el pedido?</b>
                    <input type="hidden" name="psDateLimit" value=<%=msDateLimit%>>
                    <input type="hidden" name="piNumItems" value=<%=miNumItems%>>
                    <input type="hidden" name="hidStepOrder" value="<%=miOrder%>">
                    <input type="hidden" name="hidStepStore" value="<%=miStore%>">
                    <input type="hidden" name="hidOperation" value="S">
                    <input type="button" name="cmd_ok" value="Aceptar" 
                           onclick="handleClick(event.type, 'confirmDate()')" 
                           ondblclick="handleClick(event.type, 'confirmDate()')">
                    <input type="button" name="cmd_cancel" value="Cancelar" OnClick = "cancelData();">
                </td>    
            </tr>
            </table>
            </form>
        <%
            moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(miOrder,miStore));
			resetTableReport();
        }//FIN ELSE
    }
    catch(Exception moExcpetion)
    {
	System.out.println("Falla por falta de fecha limite");
        moExcpetion.printStackTrace();
    }
    %>

         <jsp:include page = "/Include/TerminatePageYum.jsp"/>
    </body>
</html>

<%!
   String getDateTime(){
        String lsDate="";
        Date ldToday=new Date();
        String DATE_FORMAT = "yy-MM-dd";
        int liMonth=(int)ldToday.getMonth();
        int liDay=(int)ldToday.getDate();
        java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
        Calendar lsC1 = Calendar.getInstance();
        lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay);

        lsDate=lsDF.format(lsC1.getTime());
        return(lsDate);
    }

    String getQueryReport(int piOrder,int piStore) {
        String lsSqlQuery = "";


		lsSqlQuery += "INSERT INTO order_report ";
        lsSqlQuery += "SELECT  ";
        lsSqlQuery += "Rtrim(p.provider_product_code) as uno,i.inv_desc||'/'||p.provider_product_desc as dos,prv.name as tres, ";
        lsSqlQuery += "Ltrim(to_char((Case  When available_quantity IS NULL then '0' else available_quantity end),'9999990.99')) as cuatro, ";
        lsSqlQuery += "Ltrim(to_char(isnull(s.required,0 ),'9999990.99')) as cinco, ";
        lsSqlQuery += "to_char(isnull(w.way_quantity,0),'9999990.99') as seis, ";
        lsSqlQuery += "Ltrim(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99')) as siete, ";
        lsSqlQuery += "Ltrim((' '||to_char( isnull(od.inv_required_quantity,0),'9999990.99')||' '||rtrim(vwm.unit_name))) as ocho, ";
        lsSqlQuery += "Ltrim(to_char(CAST((Case  When od.inv_required_quantity IS NULL then '0' else od.inv_required_quantity end)/(Case  When p.conversion_factor IS NULL then '0' else p.conversion_factor end) as decimal(12,2)),'9999990.99')||' '||rtrim(m.unit_name)) as nueve, ";
        lsSqlQuery += "Ltrim((' '||to_char(CAST(ceil((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)) as decimal(12,2)),'9999990.99')||' '||rtrim(m.unit_name))) as diez, ";
        lsSqlQuery += "Ltrim(to_char(ceil((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)*(Case  When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99')||' '||Rtrim(vwm.unit_name)) as once, ";
        lsSqlQuery += "Ltrim((to_char((ceil(isnull(od.prv_required_quantity,0))*isnull(p.conversion_factor,0) - difference(s.suggested_quantity,w.way_quantity)),'9999990.99'))) AS dif_vs_sug, ";
        lsSqlQuery += "CAST((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)*(Case  When  p.provider_price  IS NULL then '0' else p.provider_price end) as decimal(12,2)) as monto, ";
        lsSqlQuery += "ltrim(prv.provider_id) as cato, ";
        lsSqlQuery += "Ltrim(to_char(provider_price,'9999990.99'))  as quin ";
		//lsSqlQuery += " INTO TEMP tb_report ";
        lsSqlQuery += "FROM op_grl_step_order o  ";
        lsSqlQuery += "LEFT JOIN  op_grl_step_order_detail od ON o.order_id=od.order_id AND o.store_id=od.store_id  ";
        lsSqlQuery += "LEFT JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code AND p.provider_id=od.provider_id ";
        lsSqlQuery += "INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id  ";
        lsSqlQuery += "INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id  ";
        lsSqlQuery += "LEFT JOIN op_grl_suggested_order s   ON  s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id=0 ";
        lsSqlQuery += "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure  ";
        lsSqlQuery += "INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure  ";
        lsSqlQuery += "LEFT JOIN op_grl_way_order w ON ";
		lsSqlQuery += "(w.provider_product_code=od.provider_product_code AND w.order_id="+piOrder+")";
        lsSqlQuery += "WHERE o.store_id="+piStore+" AND o.order_id="+piOrder+" order by monto desc ";

		moAbcUtils.executeSQLCommand(lsSqlQuery);
					
        lsSqlQuery = "";

        lsSqlQuery += "INSERT INTO order_report SELECT '','','','','','','','','','','',' <b>Sub-Total: $</b>',CAST(SUM((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)*(Case  When  p.provider_price IS NULL then 0 else p.provider_price end)) as decimal(12,2)) as subto,ltrim(prv.provider_id),''  ";
        lsSqlQuery += "FROM  op_grl_step_order o  ";
        lsSqlQuery += "LEFT JOIN  op_grl_step_order_detail  od   ON o.order_id=od.order_id AND o.store_id=od.store_id ";
        lsSqlQuery += "LEFT JOIN op_grl_cat_providers_product p    ON p.provider_product_code=od.provider_product_code  AND p.provider_id=od.provider_id ";
        lsSqlQuery += "INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id  ";
        lsSqlQuery += "INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id  ";
        lsSqlQuery += "LEFT JOIN op_grl_suggested_order s   ON  s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id=0  ";
        lsSqlQuery += "WHERE o.store_id="+piStore+" AND o.order_id="+piOrder+" group by prv.provider_id ";

		moAbcUtils.executeSQLCommand(lsSqlQuery);

        lsSqlQuery = "";

        lsSqlQuery += "INSERT INTO order_report SELECT '', '','','','','','','','','','',' <b>TOTAL: $</b>',CAST(SUM((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)*(Case  When  p.provider_price IS NULL then '0' else p.provider_price end)) as decimal(12,2)), '0',''  ";
        lsSqlQuery += "FROM  op_grl_step_order o  ";
        lsSqlQuery += "LEFT JOIN  op_grl_step_order_detail  od   ON o.order_id=od.order_id AND o.store_id=od.store_id  ";
        lsSqlQuery += "LEFT JOIN op_grl_cat_providers_product p    ON p.provider_product_code=od.provider_product_code  AND p.provider_id=od.provider_id ";
        lsSqlQuery += "INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id  ";
        lsSqlQuery += "INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id  ";
        lsSqlQuery += "LEFT JOIN op_grl_suggested_order s   ON  s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id=0  ";
        lsSqlQuery += "WHERE o.store_id="+piStore+" AND o.order_id="+piOrder;

		moAbcUtils.executeSQLCommand(lsSqlQuery);

		lsSqlQuery = "Select * from order_report";

        return(lsSqlQuery);
    }

	void resetTableReport(){
		String lsSqlQuery = "Delete from order_report";
		moAbcUtils.executeSQLCommand(lsSqlQuery);
	}


   String getQueryOrderFile(String psOrder,String psStore){

       String lsQuery="SELECT o.order_id, o.store_id,o.date_id,od.provider_id,p.inv_id,p.stock_code_id,od.provider_product_code,";
       lsQuery+="od.provider_unit,od.unit_cost,od.prv_required_quantity,";
       lsQuery+="i.inv_unit_measure,od.inv_required_quantity,o.date_limit";
       lsQuery+=" FROM";
       lsQuery+=" op_grl_order o";
       lsQuery+=" LEFT JOIN op_grl_order_detail od ON (od.order_id = o.order_id AND od.store_id=o.store_id)";
       lsQuery+=" LEFT JOIN op_grl_cat_providers_product p ON (p.provider_id =od.provider_id AND p.provider_product_code = od.provider_product_code)";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
       lsQuery+=" WHERE o.order_id="+psOrder;
       lsQuery+=" AND o.store_id="+psStore;

       return(lsQuery);
   }


   String getNumOrder(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsOrder="";
	String lsQryMaxOrder="";
        String lsPrvId = moAbcUtils.queryToString("SELECT TRIM(provider_id) FROM op_grl_step_order_detail limit 1","","");
        if (lsPrvId.equals("325")){
                lsQryMaxOrder="SELECT o.order_id from op_grl_order o inner join op_grl_order_detail od on (o.order_id = od.order_id) and o.order_id < 500000 order by 1 desc limit 1";
        } else {
                lsQryMaxOrder="SELECT order_id from op_grl_order where order_id < 500000 ORDER BY order_id DESC limit 1";
        }
        System.out.println("lsQryMaxOrder: " + lsQryMaxOrder);
	lsOrder=moAbcUtils.queryToString(lsQryMaxOrder,"","");
        //lsOrder=moAbcUtils.queryToString("SELECT order_id from op_grl_order  ORDER BY order_id DESC limit 1","","");
        if (lsOrder.equals("") || lsOrder.equals("0"))
            lsOrder="10000";
        else{
            int liOrder=Integer.parseInt(lsOrder)+1;
            lsOrder=String.valueOf(liOrder);
        }
        return(lsOrder);
   }

   String getOrderRemiQuery(){
        String lsQuery=" SELECT distinct  rtrim(p.provider_id)||'_'||cast(rtrim(o.order_id) as Varchar),cast(rtrim(o.order_id) as         Varchar)";
        lsQuery+=" FROM  op_grl_order_detail o ";
        lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id";
        lsQuery+=" WHERE  o.order_id not in (SELECT DISTINCT order_id FROM op_grl_remission )";
        lsQuery+=" AND  rtrim(ltrim(o.order_id)||'_'||ltrim(o.provider_id)) NOT IN (SELECT DISTINCT rtrim(ltrim(rp.order_id)||'_'||ltrim(rp.provider_id)) FROM op_grl_reception rp) ";
        lsQuery+=" UNION " ;
        lsQuery+=" SELECT DISTINCT  rtrim(p.provider_id)||'_'||cast(rtrim(o.order_id) as Varchar)||'_'||cast(rtrim(r.remission_id) as         Varchar),cast(rtrim(o.order_id) as         Varchar)||'/'||cast(rtrim(r.remission_id) as Varchar)";
        lsQuery+=" FROM  op_grl_order_detail o ";
        lsQuery+=" INNER JOIN op_grl_remission r ON r.order_id=o.order_id  AND r.provider_id=o.provider_id ";
        lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id ";
        lsQuery+=" WHERE NOT EXISTS (SELECT * FROM op_grl_reception WHERE o.store_id = store_id AND r.remission_id = remission_id) ";

	   return(lsQuery);
    }

    String getOrderRemissionQuery(){
	String lsQuery = "SELECT trim(p.provider_id)||'_'||cast(rtrim(r.order_id) as VARCHAR)||'_'||cast(rtrim(r.remission_id) as varchar),";
	lsQuery+=" cast(rtrim(r.order_id) as VARCHAR)||'/'||cast(rtrim(r.remission_id) as varchar)";
	lsQuery+=" FROM op_grl_cat_provider p";
	lsQuery+=" INNER JOIN op_grl_remission r ON r.provider_id = p.provider_id";
	lsQuery+=" WHERE NOT EXISTS (SELECT * FROM op_grl_reception re WHERE re.store_id = r.store_id AND re.remission_id = r.remission_id)";
	return(lsQuery);
    }
%>

