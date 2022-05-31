<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msNoteId;
%>
<%
    try
    {
        msNoteId = request.getParameter("noteId");
    }
    catch(Exception e)
    {
       msNoteId = "0"; 
    }
%>

<script>            
    var gaInvoiceDetail;
    var gaDataset = <%= getDataset() %>;

    if(gaDataset.length > 0)
        gaInvoiceDetail = gaDataset[0];
    else
        gaInvoiceDetail = new Array();

</script>
<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="InvoiceDetailFrmYum.jsp?target=Preview&noteId=<%= msNoteId %>" name="preview" frameborder="0">
      <FRAME src="InvoiceDetailFrmYum.jsp?target=Printer&noteId=<%= msNoteId %>" name="printer" frameborder="0">
</FRAMESET>

<%!
    String getDataset()
    {
        String lsData;

        try{
            lsData = moAbcUtils.getJSResultSet(getQueryReport());
        }
        catch(Exception e)
        {
            lsData = "new Array()";
        }

        return lsData;
    }

    String getQueryReport()
    {
        String lsQuery = "";
 	    lsQuery += "SELECT rtrim(a.supp_name) as supp_name, rtrim(c.sub_acc_desc) as subacc_desc, ";
        lsQuery += "cap_date as today, gsvn.note_id, gsvn.amount, gsvn.comment as description, ";
        lsQuery += "gsvn.tax, gsvn.qty, gsvn.consecutive ";
        lsQuery += "FROM  op_gsv_cat_supplier a ";
        lsQuery += "INNER JOIN op_gsv_supp_subacc b ON a.supp_id=b.supp_id ";
        lsQuery += "INNER JOIN op_gsv_cat_sub_account c ON b.sub_acc_id=c.sub_acc_id AND b.acc_id=c.acc_id ";
	    lsQuery += "INNER JOIN op_gsv_note gsvn ON ";
        lsQuery += "(b.supp_id=gsvn.supp_id AND b.sub_acc_id=gsvn.sub_acc_id AND b.acc_id=gsvn.acc_id) ";
        lsQuery += "WHERE gsvn.note_id='" + msNoteId + "'";
        
        return(lsQuery);
    }

%>
