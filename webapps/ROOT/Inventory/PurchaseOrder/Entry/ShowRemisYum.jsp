<%@ page import="generals.AbcUtils" %>
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); %>

<%  String remissionId = request.getParameter("remissionId"); %>

<script>            
   var gaDataset = <%= getDataset(remissionId) %>;
</script>

<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="ShowRemisFrmYum.jsp?&remissionId=<%= remissionId %>&target=Preview" name="preview" frameborder="0">
      <FRAME src="ShowRemisFrmYum.jsp?&remissionId=<%= remissionId %>&target=Printer" name="printer" frameborder="0">
</FRAMESET>

<%!
    String getDataset(String psRem){
        String lsData;
        String lsOrd = getRemOrderId(psRem);
        String lsPrv = getRemProviderId(psRem);

        try{
            lsData   = moAbcUtils.getJSResultSet(getQueryReport(psRem,lsOrd,lsPrv));
        }
        catch(Exception e)
        {
            lsData = "new Array()";
        }

        return lsData;
    }

    String getQueryReport(String psRem, String psOrd, String psPrv) {
    	String laSum[]    = getSumOrderRem(psRem, psOrd, psPrv).split(",");
    	
    	String lsQuery = "";
		lsQuery += "SELECT"; // Primera parte, productos que están en orden Y en remisión
		lsQuery += " rd.sort_num as sort_num,";
		lsQuery += "(Case rd.difference when  't' then '<img src=\"/Images/Menu/red_button.gif\">' else '&nbsp;' end) ||' ' ||  p.provider_product_desc, ";
		lsQuery += " rd.provider_product_code_order as order_product_code,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity,'9999990.99')||' '|| m.unit_name) as order_required,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end)),'9999990.99')||' '||m1.unit_name as order_equivalent,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity*od.unit_cost,'9999990.99')) as ord_cost,";
		lsQuery += " rd.provider_product_code_remis as remis_product_code,";
		lsQuery += " Ltrim(to_char(rd.required_quantity,'9999990.99')||' '||m2.unit_name) as remis_qty,";
		lsQuery += " to_char(ROUND((Case When rd.required_quantity IS NULL then 0 else rd.required_quantity end)*(Case When p.conversion_factor IS NULL then 0 else p.conversion_factor end)),'9999990.99')||' '|| m1.unit_name as remis_equivalent,";
		lsQuery += " Ltrim(to_char(rd.unit_cost,'9999990.99')) as remis_cost,";
		lsQuery += " Ltrim(to_char(rd.required_quantity*rd.unit_cost - od.prv_required_quantity*od.unit_cost,'9999990.99'))  as dif_cost,";
		lsQuery += " to_char((Case When rd.required_quantity IS NULL then 0 else rd.required_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)-(Case";
		lsQuery += " When od.inv_required_quantity = Null then 0 else od.inv_required_quantity end),'9999990.99')||' '||rtrim(m1.unit_name) as dif_inv";
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
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity = Null then 0 else od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
		lsQuery += " Ltrim(to_char(od.prv_required_quantity*od.unit_cost,'9999990.99')) as ord_cost,";
		lsQuery += " '' as remis_product_code,";
		lsQuery += " '' as remis_qty,";
		lsQuery += " '' as remis_equivalent,";
		lsQuery += " '' as remis_cost,";
		lsQuery += " Ltrim(to_char(-od.prv_required_quantity*od.unit_cost,'9999990.99')) as dif_cost,";
		lsQuery += " to_char(ROUND((Case When od.inv_required_quantity = Null then 0 else -od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as dif_inv";
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
		lsQuery += " '' as order_product_code,";
		lsQuery += " '' as order_required,";
		lsQuery += " '' as order_equivalent,";
		lsQuery += " '' as order_cost,";
		lsQuery += " rd.provider_product_code_remis as remis_product_code,";
		lsQuery += " Ltrim(to_char(rd.required_quantity,'9999990.99')||' '||m.unit_name) as remis_qty,";
		lsQuery += " to_char(ROUND((Case When rd.required_quantity = Null then 0 else rd.required_quantity end)*(Case When p2.conversion_factor = Null then 0 else p2.conversion_factor end)),'9999990.99')||' '||rtrim(vwm.unit_name) as remis_equivalent,";
		lsQuery += " Ltrim(to_char(rd.unit_cost,'9999990.99')) as remis_cost,";
		lsQuery += " Ltrim(to_char(rd.required_quantity*rd.unit_cost,'9999990.99')) as dif_cost,";
		lsQuery += " to_char(ROUND((Case When rd.required_quantity = Null then 0 else rd.required_quantity end)*(Case When p2.conversion_factor = Null then 0 else p2.conversion_factor end)),'9999990.99')||' '||rtrim(vwm.unit_name) as dif_inv";
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
		lsQuery += " '',";
		lsQuery += " CAST('&nbsp;' as varchar),";
		lsQuery += " '',";
		lsQuery += " CAST('<b>Total <br>Orden:</b>' as varchar),";
		lsQuery += " CAST('<b>    " + laSum[0] + "</b>' as varchar),";
		lsQuery += " '', '',";
		lsQuery += " CAST('<b>Total<br>Remisi&oacute;n:</b>' as varchar),";
		lsQuery += " CAST('<b>    " + laSum[1] + "</b>' as varchar),";
		lsQuery += " '', '' ";
		lsQuery += " FROM op_grl_remission_detail rd";

		lsQuery += " ORDER BY sort_num";

		return(lsQuery);
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


        String lsSum=moAbcUtils.queryToString(lsQuery,"","");
    	lsQuery = "SELECT to_char(SUM(rd.unit_cost),'9999990.99')";
	    lsQuery += " FROM op_grl_remission_detail rd";
    	lsQuery += " INNER JOIN op_grl_remission r ON r.remission_id = rd.remission_id";
	    lsQuery += " INNER JOIN op_grl_cat_provider p ON p.provider_id = r.provider_id";
    	lsQuery += " WHERE rd.remission_id = '" + psRem + "'";

	    lsSum = lsSum + "," + moAbcUtils.queryToString(lsQuery,"","");
        return(lsSum);
    }
%>
