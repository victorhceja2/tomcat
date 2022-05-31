<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msYear   = "0";
    String msPeriod = "0";
    String msWeek   = "0";
    String msDay    = "0";
    String msReport = "0";
%>
<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
    }
    catch(Exception e)
    {
        
    }
%>

<script>
    var rsData = new Array();
    var gaDataset = new Array();
    <%= getDataset() %>;
</script>

<%@ include file="/Include/CalendarLibYum.jsp" %>

<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="InvoiceReportFrmYum.jsp?target=Preview" name="preview" frameborder="0">
      <FRAME src="InvoiceReportFrmYum.jsp?target=Printer" name="printer" frameborder="0">
</FRAMESET>

<%!
    String getDataset()
    {
        String lsData = "";
        String data[][] = null;

        String tables = " FROM  op_gsv_cat_supplier a ";
        tables += "INNER JOIN op_gsv_supp_subacc b ON a.supp_id=b.supp_id ";
        tables += "INNER JOIN op_gsv_cat_sub_account c ON b.sub_acc_id=c.sub_acc_id AND b.acc_id=c.acc_id ";
	    tables += "INNER JOIN op_gsv_note gsvn ON ";
        tables += "(b.supp_id=gsvn.supp_id AND b.sub_acc_id=gsvn.sub_acc_id AND b.acc_id=gsvn.acc_id) ";
        tables += "WHERE CAST(gsvn.cap_date AS CHAR(10)) IN ";
        tables += "(SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            tables += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            tables += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            tables += " AND EXTRACT(day from date_id) = " + msDay;

        tables += ") ";


        try{
            data = moAbcUtils.queryToMatrix( getSubAccounts() );

            if (data.length > 0)
            {
                for(int i=0; i<data.length; i++)
                {
                    String acc    = data[i][0];
                    String subacc = data[i][1];
                    String tmpData = moAbcUtils.getJSResultSet( getQueryReport(acc, subacc, tables) );
                    lsData += "gaDataset[gaDataset.length] = " + tmpData + ";\n";

                }

                String tmpData = moAbcUtils.getJSResultSet( getReportTotals(tables) );
                lsData += "gaDataset[gaDataset.length] = " + tmpData + "; \n";
            }

        }
        catch(Exception e)
        {
            System.out.println("Exception " + e.toString());
        }

        return lsData;
    }

    String getQueryReport(String psAccount, String psSubacc, String psTables)
    {
        String lsQuery = "";

 	    lsQuery += "SELECT rtrim(a.supp_name) as supp_name, rtrim(c.sub_acc_desc) as subacc_desc, ";
        lsQuery += "' ' || text(cap_date) as today, gsvn.note_id, text(gsvn.amount), text(gsvn.tax), gsvn.comment ";
        lsQuery += psTables;
        lsQuery += " AND c.acc_id ='"+psAccount+"' AND c.sub_acc_id='" + psSubacc +"'";

        lsQuery += " UNION ";

        lsQuery += " SELECT '', '', '&nbsp;', '', '<div class=bsTotals>Subtotal: ' ||sum(gsvn.amount) || '</div><br>', ";
        lsQuery += " '' || '<br><br>', '' ";
        lsQuery += psTables;
        lsQuery += " AND c.acc_id ='"+psAccount+"' AND c.sub_acc_id='" + psSubacc +"'";

        lsQuery += "ORDER BY today ASC \n";
	
        return(lsQuery);
    }

    String getReportTotals(String psTables)
    {
        String lsQuery = "SELECT '', '', '&nbsp;', '', '<div class=bsTotals>TOTAL: ' ||sum(gsvn.amount) || '</div>', '', '' ";
        lsQuery += psTables;

        return lsQuery;
    }

    String getSubAccounts()
    {
        String lsQuery = "SELECT DISTINCT c.acc_id,c.sub_acc_id,c.sub_acc_desc as subacc_desc FROM  op_gsv_cat_supplier a ";
        lsQuery += "INNER JOIN op_gsv_supp_subacc b ON a.supp_id=b.supp_id INNER JOIN op_gsv_cat_sub_account c ";
        lsQuery += "ON b.sub_acc_id=c.sub_acc_id AND b.acc_id=c.acc_id INNER JOIN op_gsv_note gsvn ";
        lsQuery += "ON (b.supp_id=gsvn.supp_id AND b.sub_acc_id=gsvn.sub_acc_id AND b.acc_id=gsvn.acc_id) ";
        lsQuery += "WHERE CAST(gsvn.cap_date AS CHAR(10)) IN ";
        lsQuery += "(SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "ORDER BY subacc_desc ASC";

        return lsQuery;
    }

%>
