<%@ page import="generals.AbcUtils" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); %>

<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %> 

<script>            
    var data = <%= getData(request.getParameter("recepId")) %>;
</script>

            
<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="ShowReportDiffFrmYum.jsp?&recepId=<%= request.getParameter("recepId") %>&target=Preview" name="preview" frameborder="0">
      <FRAME src="ShowReportDiffFrmYum.jsp?&recepId=<%= request.getParameter("recepId") %>&target=Printer" name="printer" frameborder="0">
</FRAMESET>
            
<%!
    String getData(String psRecepId){
        String lsData;

        try{
            lsData = moAbcUtils.getJSResultSet(getQueryReport(psRecepId));
        }
        catch(Exception e)
        {
            lsData = "new Array()";
        }

        return lsData;
    }
    
    String getQueryReport(String  psRecep){
	String lsQuery = "";
	AbcUtils moAbcUtils = new AbcUtils();
 	String lsContNeg =moAbcUtils.queryToString("SELECT count(*) FROM op_grl_difference WHERE reception_id ="+psRecep + " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'","","");
	int liContNeg=Integer.parseInt(lsContNeg.trim());
	String lsContPos =moAbcUtils.queryToString("SELECT count(*) FROM op_grl_difference WHERE reception_id ="+psRecep + " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'","","");
	int liContPos=Integer.parseInt(lsContPos.trim());
	if(liContNeg > 0){
		lsQuery+= "SELECT '0' as control,product_name, order_product, qty_required, order_equivalent, ";
		lsQuery+= "to_char(ord_cost,'999999990.99') as ord_cost, recep_product, ";
		lsQuery+= "qty_received, recep_equivalent, to_char(recep_cost, '99999990.99') as recep_cost, ";
		lsQuery+= "dif_desc, dif_prv, dif_inv  FROM op_grl_difference WHERE reception_id ="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'";
		lsQuery+= " UNION ";
		lsQuery+= "SELECT '1' as control,' ',' ',' ','Total Orden:', '<b>' || to_char( sum(ord_cost), '99999990.99') || '</b>' as ord_cost, ";
		lsQuery+= " ' ',' ','Total Recepcion:','<b>' || to_char(sum(recep_cost), '999999990.99') || '</b>' as recep_cost,'','','' ";
		lsQuery+= "FROM op_grl_difference WHERE reception_id="+psRecep;
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
		lsQuery+= "dif_desc, dif_prv, dif_inv  FROM op_grl_difference WHERE reception_id ="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'";
		lsQuery+= " UNION ";
		lsQuery+= "SELECT '4' as control,' ',' ',' ','Total Orden:', '<b>' || to_char( sum(ord_cost), '99999990.99') || '</b>' as ord_cost, ";
		lsQuery+= " ' ',' ','Total Recepcion:','<b>' || to_char(sum(recep_cost), '999999990.99') || '</b>' as recep_cost,'','','' ";
		lsQuery+= "FROM op_grl_difference WHERE reception_id="+psRecep;
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

%>
