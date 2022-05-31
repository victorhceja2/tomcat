<%@ page import="generals.AbcUtils" %>
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); %>

<%  
    String docNum;
    String recepId;
    String referer;
    String toForward;

    recepId = request.getParameter("recepId");
    docNum  = getDocNum(recepId);//request.getParameter("docNum"); 
    //referer = request.getHeader("referer");
    referer = "ShowForward";

    //referer = referer.substring(referer.lastIndexOf("/")+1);
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


               var gaDataset = <%= getDataset(docNum, recepId) %>;

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
        <form name="mainform" action="ShowRecepFrmYum.jsp">
            <input type="hidden" name="recepId"  value="<%= recepId %>">
            <input type="hidden" name="referer" value="<%= referer %>">
            <input type="hidden" name="docNum" value="<%= docNum %>">
            <input type="hidden" name="hidTarget">
        </form>
    </body>
</html>


<%!
    String getDataset(String psDocNum, String psRecepId)
    {

        String lsData;
        String lsRecepId;
        String lsProvId;
        
        if(psRecepId != null)
            lsRecepId = psRecepId;
        else
            lsRecepId = getRecReceptionId(psDocNum);

        lsProvId = getProviderId(lsRecepId);

        try{
            lsData = moAbcUtils.getJSResultSet(getQueryReport(lsRecepId, lsProvId));
        }
        catch(Exception e)
        {
            lsData = "new Array()";
        }

        return lsData;
    }

    String getProviderId(String psRecepId)
    {
        String lsProviderId;
        String lsQuery;

        lsQuery      = "SELECT provider_id FROM op_grl_reception WHERE reception_id ='" + psRecepId +"'";
        lsProviderId = moAbcUtils.queryToString(lsQuery);

        return lsProviderId;
    }

    String getQueryReport(String psRecepId, String psProvId)
    {
    
        String lsQuery;
        int liSeq;

        lsQuery = "SELECT MAX(sort_num) FROM op_grl_reception_detail WHERE reception_id='" + psRecepId + "'";
        liSeq   = Integer.parseInt(moAbcUtils.queryToString(lsQuery))+1;

        lsQuery = " SELECT isnull(rd.sort_num,0)," +
        "rd.provider_product_code,p.provider_product_desc," +
        "Ltrim(to_char(rd.received_quantity,'9999,990.99')||' '||m.unit_name),dif_desc, forw_desc, " +
        "Ltrim(to_char(rd.received_quantity*p.conversion_factor,'9999,990.99')||' '||mm.unit_name), " +
        "Ltrim(to_char(unit_cost,'9999990.99')) as unit_cost, " +
        "Ltrim(to_char(ROUND((rd.received_quantity*unit_cost),2),'9999,990.99')) "+
        "FROM " +
        "op_grl_reception r " +
        "INNER JOIN op_grl_reception_detail rd ON r.reception_id=rd.reception_id "+
        "INNER JOIN op_grl_cat_providers_product p ON rd.provider_product_code=p.provider_product_code "+
        "LEFT JOIN op_grl_cat_difference d ON d.difference_id=rd.difference_id "+
        "INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id "+
        "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p.provider_unit_measure "+
        "INNER JOIN op_grl_cat_unit_measure mm ON mm.unit_id = i.inv_unit_measure "+
        "INNER JOIN op_grl_cat_forwarding fw ON fw.forwarding_id = rd.forwarding_id "+
        "WHERE r.reception_id = '"+psRecepId +"' AND p.provider_id='" + psProvId + "' AND rd.forwarding_id LIKE '1%'" +

        "UNION " +

        "SELECT " + liSeq + ", " +
        "CAST('&nbsp;' as varchar) as provider_product_code,CAST('' as char) as inv_desc," +
        "CAST('' as char), CAST('' as char)," +
        "CAST('' as char), CAST('' as char)," +
        "' <b>TOTAL:</b>' as unit_cost, "+
        "to_char(ROUND(SUM((Case  When rd.received_quantity = Null then 0 else rd.received_quantity end)*rd.unit_cost),2),'9999,990.99') " +
        "FROM " +
        "op_grl_reception_detail rd " +
        "WHERE rd.reception_id = '"+psRecepId +"' AND rd.forwarding_id LIKE '1%' ORDER BY 1 ASC";

        return(lsQuery);
    }

    String getDocNum(String psReceptionId)
    {
        String lsQuery = "SELECT document_num FROM op_grl_reception WHERE reception_id = '"+psReceptionId+"'";

        return moAbcUtils.queryToString(lsQuery);
    }
%>
