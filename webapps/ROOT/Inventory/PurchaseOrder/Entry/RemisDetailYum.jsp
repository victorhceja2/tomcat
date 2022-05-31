<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TotalVacationsYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : SCP
# Objetivo        : Reporte de remisiones
# Fecha Creacion  : 30/Noviembre/2004
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html" %>
<%@page import="generals.*" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msPrv="";
    String msParam="";
    String msOrd="";
    String msRem="";
    String msOperation = request.getParameter("hidOperation");

    String msPresentation = (msOperation.equals("B"))?"VIEWPORT":"PRINTER";

    moHtmlAppHandler.setPresentation(msPresentation);

    if(!request.getParameterValues("cmbProvRem").equals(null)){
       msPrv=request.getParameter("cmbProvRem");
        if(!request.getParameterValues("cmbSubRem").equals(null))
             msParam=request.getParameter("cmbSubRem");
            if (msParam.indexOf("-1")<0){
                    String maParam[]=msParam.split("_");
                    msOrd=maParam[1];
                    msRem =maParam[2];
            }
    }

    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    moHtmlAppHandler.moReportTable.setNullCharacter("");
    moHtmlAppHandler.moReportTable.setNonLevelColor(moHtmlAppHandler.moReportTable.getStoreLevelColor());

    String msFontSub = moHtmlAppHandler.moReportHeader.msFontSub;
    String msFontEnd = "</font>";
    moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte de Remisi&oacute;n ",msPresentation);

    moHtmlAppHandler.moReportTable.setTableHeaders("||Pedido|Pedido|Pedido|Pedido|Remisi&oacute;n|Remisi&oacute;n|Remisi&oacute;n|Remisi&oacute;n| | |",0,true);
moHtmlAppHandler.moReportTable.setTableHeaders("<br>|Producto|C&oacute;digo<br>Producto<br>Solicitado|Cantidad<br>Solicitada|Equival<br>Unidades<br>Inven|Costo|C&oacute;digo<br>Producto<br>Remisi&oacute;n|Cantidad<br>Remisi&oacute;n|Equival<br>Unidades<br>Inven|Costo|Dif<br>Precio|Dif<br>Unidad<br>Inven|",1,false);

    moHtmlAppHandler.moReportTable.setFieldFormats("|| | | | | | | | | | |");
    moHtmlAppHandler.moReportTable.mbCombineColumnsPrint = false;
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();



moHtmlAppHandler.moReportTable.setFieldColors("|#66CCFF|#66CCFF|#66CCFF|#66CCFF|#66CCFF|#CCFFFF|#CCFFFF|#CCFFFF|#CCFFFF| | |",2);

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }
%>

<html>
    <head>
        <title>Reporte de Remisi&oacute;n</title>
        <link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
    </head>
    <script src="/Scripts/ReportUtilsYum.js"></script>
    <script src="/Scripts/AbcUtilsYum.js"></script>

    <script>

    	function executeReportCustom() {
    		parent.executeDetail(parent.frames['ifrDetail'].document.location.href,'',gsOppPrint,'_blank');
    	}

    </script>

   <body bgcolor = 'white' <%=moHtmlAppHandler.moReportHeader.getBodyStyle() %> >
    	<% if (msPresentation.equals("VIEWPORT")) { %>
            <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
                <jsp:param name = 'psPrintOption' value = 'yes'/>
            </jsp:include>
        <% } else { %>
            <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
        <% } %>
	<%=msFontSub%>
	    	&nbsp;&nbsp;Centro de contribuci&oacute;n: <b><%=getStore()%>&nbsp;<%=getStoreName()%></b><br>
		<%   if(!msOrd.equals(""))
				out.println("&nbsp;&nbsp;N&uacute;mero de orden <b> "+msOrd + "</b>" );
			if(!msRem.equals(""))
				out.println("&nbsp;&nbsp;N&uacute;mero de remisi&oacute;n <b> "+msRem + "</b>" );
		%>


         <%=msFontEnd%>
        <%
		String laSum[]=getSumOrderRem(msRem, msOrd, msPrv).split(",");
		int liSequence = 0;
		if(!msRem.equals(""))
			liSequence = getSequence(msRem);

            if (moHtmlAppHandler.getPresentation().equals("")) { moHtmlAppHandler.initializeHandler(); return; }
            moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msRem,msOrd,msPrv,laSum,liSequence));
        %>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!


    String getQueryReport(String psRem, String psOrd, String psPrv, String[] psSum, int piSequence) {
    	String lsQuery = "";
		lsQuery += "SELECT"; // Primera parte, productos que están en orden Y en remisión
		lsQuery += " rd.sort_num as sort_num,";
		lsQuery += "(Case rd.difference when  't' then '<img src=\"/Images/Menu/red_button.gif\">' else '&nbsp;' end) ||' ' ||  p.provider_product_desc, ";
		lsQuery += " rd.provider_product_code_order as order_product_code,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity,'9999990.99')||' '|| m.unit_name) as order_required,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity IS NULL then '0' else od.inv_required_quantity end)),'9999990.99')||' '||m1.unit_name as order_equivalent,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity*od.unit_cost,'9999990.99')) as ord_cost,";
		lsQuery += " rd.provider_product_code_remis as remis_product_code,";
		lsQuery += " Ltrim(to_char(rd.required_quantity,'9999990.99')||' '||m2.unit_name) as remis_qty,";
		lsQuery += " to_char(ROUND((Case When rd.required_quantity IS NULL then '0' else rd.required_quantity end)*(Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99')||' '|| m1.unit_name as remis_equivalent,";
		lsQuery += " Ltrim(to_char(rd.unit_cost,'9999990.99')) as remis_cost,";
		//lsQuery += " Ltrim(to_char(rd.required_quantity*rd.unit_cost - od.prv_required_quantity*od.unit_cost,9999990.99))  as dif_cost,"; //Asi estaba MCH
		lsQuery += " Ltrim(to_char(rd.unit_cost - od.prv_required_quantity*od.unit_cost,'9999990.99')) as dif_cost,";
		lsQuery += " to_char((Case When rd.required_quantity IS NULL then '0' else rd.required_quantity end)*(Case When p.conversion_factor = Null then '0' else p.conversion_factor end)-(Case";
		lsQuery += " When od.inv_required_quantity = Null then '0' else od.inv_required_quantity end),'9999990.99')||' '||rtrim(m1.unit_name) as dif_inv";
		lsQuery += " FROM op_grl_remission_detail rd ";
		lsQuery += " INNER JOIN op_grl_order_detail od ON od.provider_product_code = rd.provider_product_code_order";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
		lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m2 ON m2.unit_id = rd.unit_measure_remis";
		lsQuery += " WHERE rd.remission_id ='"+ psRem +"'";
		lsQuery += " AND od.order_id='" + psOrd + "'";

		lsQuery += " UNION"; //Segunda parte: Para obtener los elementos de la orden que no estan en la remision

		lsQuery += " SELECT  DISTINCT CAST('999' as integer) as sort_num,";
		lsQuery += " '<img src=\"/Images/Menu/red_button.gif\">'||' '|| p.provider_product_desc,";
		lsQuery += " od.provider_product_code as order_product_code,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity,'9999990.99')||' '||m.unit_name) as order_required,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity = Null then '0' else od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity*od.unit_cost,'9999990.99')) as ord_cost,";
		lsQuery += " CAST('' as char) as remis_product_code,";
		lsQuery += " CAST('' as char) as remis_qty,";
		lsQuery += " CAST('' as char) as remis_equivalent,";
		lsQuery += " CAST('' as char) as remis_cost,";
		lsQuery += " Ltrim(to_char(-od.prv_required_quantity*od.unit_cost,'9999990.99')) as dif_cost,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity = Null then '0' else -od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as dif_inv";
		lsQuery += " FROM op_grl_order_detail od";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code =od.provider_product_code";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=od.provider_unit";
		lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
		lsQuery += " WHERE p.provider_id = '" + psPrv + "'";
		lsQuery += " AND od.order_id = " + psOrd;
		lsQuery += " AND i.inv_id NOT IN (";
		lsQuery += " SELECT i1.inv_id";
		lsQuery += " FROM op_grl_remission_detail rd";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code = rd.provider_product_code_order";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = rd.provider_product_code_remis";
		lsQuery += " INNER JOIN op_grl_cat_inventory i1 ON i1.inv_id = p1.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_inventory i2 ON i2.inv_id = p2.inv_id";
		lsQuery += " WHERE i1.inv_id = i2.inv_id";
		lsQuery += " AND rd.remission_id ='" + psRem + "'";
		lsQuery += " )";

		lsQuery += " UNION"; //Tercera parte: Para obtener los elementos de la remision que no estan en la orden

		lsQuery += " SELECT";
		lsQuery += " DISTINCT rd.sort_num as sort_num,";
		lsQuery += " '<img src=\"/Images/Menu/red_button.gif\">'||' '|| p2.provider_product_desc,";
		lsQuery += " CAST('' as char) as order_product_code,";
		lsQuery += " CAST('' as char) as order_required,";
		lsQuery += " CAST('' as char) as order_equivalent,";
		lsQuery += " CAST('' as char) as order_cost,";
		lsQuery += " rd.provider_product_code_remis as remis_product_code,";
		lsQuery += " Ltrim(to_char(rd.required_quantity,'9999990.99')||' '||m.unit_name) as remis_qty,";
		lsQuery += " to_char(ROUND((Case When rd.required_quantity = Null then '0' else rd.required_quantity end)*(Case When p2.conversion_factor = Null then '0' else p2.conversion_factor end)),'9999990.99')||' '||rtrim(vwm.unit_name) as remis_equivalent,";
		//lsQuery += " Ltrim(to_char(rd.required_quantity*rd.unit_cost,'9999990.99')) as remis_cost,";
		lsQuery += " Ltrim(to_char(rd.unit_cost,'9999990.99')) as remis_cost,";
		//lsQuery += " Ltrim(to_char(rd.required_quantity*rd.unit_cost,'9999990.99')) as dif_cost,"; // Asi estaba MCH
		lsQuery += " Ltrim(to_char(rd.unit_cost,'9999990.99')) as dif_cost,";
		lsQuery += " to_char(ROUND((Case When rd.required_quantity = Null then '0' else rd.required_quantity end)*(Case When p2.conversion_factor = Null then '0' else p2.conversion_factor end)),'9999990.99')||' '||rtrim(vwm.unit_name) as dif_inv";
		lsQuery += " FROM op_grl_remission_detail rd";
		lsQuery += " INNER JOIN op_grl_remission r ON r.remission_id = rd.remission_id";
		lsQuery += " FULL OUTER JOIN op_grl_order_detail od  ON od.order_id = r.order_id";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code = rd.provider_product_code_order";
		lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = rd.provider_product_code_remis";
		lsQuery += " INNER JOIN op_grl_cat_inventory i1 ON i1.inv_id = p1.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_inventory i2 ON i2.inv_id = p2.inv_id";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p2.provider_unit_measure";
		lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id = i2.inv_unit_measure";
		lsQuery += " WHERE r.remission_id='" + psRem + "' ";
		lsQuery += " AND rd.provider_product_code_order='0'"; //Con esta condicion nueva sabemos que no esta en la orden

		lsQuery += " UNION"; //Totales

		lsQuery += " SELECT";
		lsQuery += " DISTINCT CAST('1000' as integer) as sort_num,";
		lsQuery += " CAST('&nbsp;' as varchar),";
		lsQuery += " CAST('&nbsp;' as varchar),";
		lsQuery += " CAST('' as char),";
		lsQuery += " CAST('<b>Total <br>Orden:</b>' as varchar),";
		lsQuery += " CAST('<b>    " + psSum[0] + "</b>' as varchar),";
		lsQuery += " CAST('' as char), CAST('' as char),";
		lsQuery += " CAST('<b>Total<br>Remisi&oacute;n:</b>' as varchar),";
		lsQuery += " CAST('<b>    " + psSum[1] + "</b>' as varchar),";
		//lsQuery += " CAST('' as char), CAST('' as char)"; // Asi estaba MCH
		lsQuery += " CAST('<b>    " + psSum[2] + "</b>' as varchar), CAST('' as char)";
		lsQuery += " FROM op_grl_remission_detail rd";

		lsQuery += " ORDER BY sort_num";

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

   String getSumOrderRem(String psRem, String psOrd, String psPrv){
   	String lsQuery = "";
	lsQuery += "SELECT to_char(SUM(od.prv_required_quantity*od.unit_cost),'9999990.99')";
	lsQuery += " FROM op_grl_order_detail od";
	lsQuery += " FULL OUTER JOIN op_grl_remission r ON r.order_id = od.order_id";
	lsQuery += " INNER JOIN op_grl_cat_provider p ON p.provider_id = r.provider_id";
	lsQuery += " WHERE r.remission_id = '" + psRem + "'";
	lsQuery += " AND od.provider_id = '" + psPrv + "'";
	lsQuery += " AND od.order_id = '"+ psOrd + "'";

	AbcUtils moAbcUtils = new AbcUtils();
        String lsSum=moAbcUtils.queryToString(lsQuery,"","");
	lsQuery = "SELECT to_char(SUM(rd.unit_cost),'9999990.99')";
	lsQuery += " FROM op_grl_remission_detail rd";
	lsQuery += " INNER JOIN op_grl_remission r ON r.remission_id = rd.remission_id";
	lsQuery += " INNER JOIN op_grl_cat_provider p ON p.provider_id = r.provider_id";
	lsQuery += " WHERE rd.remission_id = '" + psRem + "'";
        String lsSumRd = moAbcUtils.queryToString(lsQuery,"","");

        //Por Error con resta de vacio a null soptmc
	if( lsSum.equals("") ) lsSum = "0";

	lsQuery = "SELECT " + lsSumRd + " - " + lsSum + " ";
        moAbcUtils.queryToString(lsQuery,"","");
	lsSum = lsSum + "," + lsSumRd + "," + moAbcUtils.queryToString(lsQuery,"","");
        return(lsSum);
   }

   int getSequence(String psRem){
   	String lsQuery = "";
	AbcUtils moAbcUtils = new AbcUtils();
	lsQuery += "SELECT MAX(sort_num) FROM op_grl_remission_detail WHERE remission_id = '" + psRem + "'";
	int liSeq=Integer.parseInt(moAbcUtils.queryToString(lsQuery,"",""))+1;
	return(liSeq);
   }

%>


