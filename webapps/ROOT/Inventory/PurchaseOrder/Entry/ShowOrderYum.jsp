<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); %>

<%
    String referer;
    String orderId;
    
    orderId = request.getParameter("orderId");
    referer = request.getHeader("referer");
    referer = referer.substring(referer.lastIndexOf("/")+1);
    referer = referer.substring(0, referer.indexOf("."));
%>    

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>
        <div id="divWaitGSO" style="width:300px; height:150px"  class="wait-gso">
            <br><br>Espere por favor...<br><br>
        </div>
    	<script language="javascript" src='/Scripts/HtmlUtilsYum.js'></script>
        <script>

        	showWaitMessage();

            function submitFrame(frameName)
			{
                document.mainform.target = frameName;

				if(frameName=='preview')
                	document.mainform.hidTarget.value = "Preview";

				if(frameName=='printer')
                	document.mainform.hidTarget.value = "Printer";

                document.mainform.submit();
			}
			function submitFrames()
			{
				submitFrame('printer');
				setTimeout("submitFrame('preview')", 2000);
			}

   			var gaDataset = <%= getDataset(orderId) %>;

		</script>
    </head>
	<body onLoad="submitFrames()">
        <table width="100%" cellpadding="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="595" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>
        <form name="mainform" action="ShowOrderFrmYum.jsp">
            <input type="hidden" name="orderId"  value="<%= orderId %>">
            <input type="hidden" name="referer" value="<%= referer %>">
            <input type="hidden" name="hidTarget">
        </form>
	</body>
</html>

<%!
    String getDataset(String psOrderId)
    {
        String lsData;
        String lsStoreId;
        

        try{
            lsStoreId = getStoreId();
            lsData    = moAbcUtils.getJSResultSet(getQueryReport(psOrderId, lsStoreId));
        }
        catch(Exception e)
        {
            lsData = "new Array()";
        }

        return lsData;
    }

    String getQueryReport(String psOrderId, String psStore) {
    
        String lsQry = "";

        lsQry += "(SELECT  ";
        lsQry += "Rtrim(p.provider_product_code),i.inv_desc||'/'||p.provider_product_desc,prv.name, ";
        lsQry += "Ltrim(to_char((Case When available_quantity IS NULL then '0' else available_quantity end),'9999990.99')), ";
        lsQry += "Ltrim(to_char((Case When s.required  IS NULL then '0' else s.required end),'9999990.99')), ";
        lsQry += "to_char(isnull(w.way_quantity,0),'9999990.99'), ";
        lsQry += "Ltrim(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99')), ";
        lsQry += "Ltrim((' '||to_char((Case When od.inv_required_quantity IS NULL then '0' else od.inv_required_quantity end),'9999990.99')||' '||rtrim(vwm.unit_name))), ";
        lsQry += "Ltrim(to_char(CAST((Case When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end)/(Case  When p.conversion_factor IS NULL then '0' else p.conversion_factor end) as decimal(12,2)),'9999990.99')||' '||rtrim(m.unit_name)), ";
        lsQry += "Ltrim((' '||to_char(CAST(ceil((Case When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)) as decimal(12,2)),'9999990.99')||' '||rtrim(m.unit_name))), ";
        lsQry += "Ltrim(to_char(ceil((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)*(Case  When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99')||' '||Rtrim(vwm.unit_name)), ";
        lsQry += "Ltrim((to_char((ceil(((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)))*(Case  When p.conversion_factor IS NULL then '0' else p.conversion_factor end) - difference(s.suggested_quantity, w.way_quantity) ),'9999990.99'))) AS dif_vs_sug, ";
        lsQry += "Ltrim(to_char(CAST((Case  When od.prv_required_quantity IS NULL then '0' else od.prv_required_quantity end)*(Case  When  p.provider_price  IS NULL then '0' else p.provider_price end) as decimal(12,2)),'9999,990.99')) ";
        lsQry += "FROM op_grl_order o ";
        lsQry += "LEFT JOIN  op_grl_order_detail od ON o.order_id=od.order_id AND o.store_id=od.store_id  ";
        lsQry += "LEFT JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code AND p.provider_id=od.provider_id ";
        lsQry += "INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id  ";
        lsQry += "INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id  ";
        lsQry += "LEFT JOIN op_grl_suggested_order s ON s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id="+psOrderId;
        lsQry += "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure  ";
        lsQry += "INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure  ";
        lsQry += "LEFT JOIN op_grl_way_order w ON (w.provider_product_code=od.provider_product_code AND w.order_id="+psOrderId+") ";
        lsQry += "WHERE o.store_id="+psStore+" AND o.order_id="+psOrderId+") \n";

        lsQry += "UNION  \n";

        lsQry += "(SELECT '','','','','','','','','','','',' <b>Sub-Total: </b>','$'||Ltrim(to_char(SUM((Case  When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)*(Case  When  p.provider_price IS NULL then 0 else p.provider_price end)),'9999,990.99'))  ";
        lsQry += "FROM  op_grl_order o  ";
        lsQry += "LEFT JOIN  op_grl_order_detail  od   ON o.order_id=od.order_id AND o.store_id=od.store_id ";
        lsQry += "LEFT JOIN op_grl_cat_providers_product p    ON p.provider_product_code=od.provider_product_code  AND p.provider_id=od.provider_id ";
        lsQry += "INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id  ";
        lsQry += "INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id  ";
        lsQry += "LEFT JOIN op_grl_suggested_order s   ON  s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id="+psOrderId;
        lsQry += "WHERE o.store_id="+psStore+" AND o.order_id="+psOrderId+" group by prv.provider_id) ";

        lsQry += "UNION  ";

        lsQry += "(SELECT '','','','','','','','','','','',' <b>TOTAL: </b>','$'||LTRIM(to_char(SUM((Case  When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)*(Case  When  p.provider_price IS NULL then 0 else p.provider_price end)),'9999,990.99'))  ";
        lsQry += "FROM  op_grl_order o  ";
        lsQry += "LEFT JOIN  op_grl_order_detail  od   ON o.order_id=od.order_id AND o.store_id=od.store_id  ";
        lsQry += "LEFT JOIN op_grl_cat_providers_product p    ON p.provider_product_code=od.provider_product_code  AND p.provider_id=od.provider_id ";
        lsQry += "INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id  ";
        lsQry += "INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id  ";
        lsQry += "LEFT JOIN op_grl_suggested_order s   ON  s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id="+psOrderId;
        lsQry += "WHERE o.store_id="+psStore+" AND o.order_id="+psOrderId+") ";
        lsQry += "ORDER BY 3 DESC,1 ASC ,13 ASC";

        return lsQry;        
    }

%>
