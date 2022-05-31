
<%@ page import="generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msYear   = "0";
    String msPeriod = "0";
    String msWeek   = "0";
    String msDay    = "0";
    String msReport = "0";
	String msType   = "input";
%>
<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
		msType   = request.getParameter("type");
    }
    catch(Exception e)
    {
        
    }
%>

<script>
    var rsData = new Array();
    var gaDataset = <%= getDataset(msType) %>;
</script>

<%@ include file="/Include/CalendarLibYum.jsp" %>

<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="TransferReportFrm.jsp?hidTarget=Preview&hidType=<%= msType %>" name="preview" frameborder="0">
      <FRAME src="TransferReportFrm.jsp?hidTarget=Printer&hidType=<%= msType %>" name="printer" frameborder="0">
</FRAMESET>
<%!
    String getDataset(String psTransferType)
    {
        String lsData;
		String lsQuery;

		try
		{
			lsQuery = getQueryReport(msYear, msPeriod, msWeek, msDay, psTransferType);
			lsData  = moAbcUtils.getJSResultSet(lsQuery);
		}
		catch(Exception e)
		{
			lsData = " new Array()";
		}

        return lsData;
    }

    String getQueryReport(String psYear, String psPeriod, String psWeek, String psDay, String psType)
    {
        String lsQuery;
		String lsTransferType;

		lsTransferType = psType.equals("input")?"1":"0";

		lsQuery = "SELECT  lpad(CAST(t.transfer_id AS CHAR(6)), 5, '0') AS transfer_id, " +
				  "rs.store_id || '-' || upper(rs.store_desc) AS remote_store, " +
				  "ls.store_id || '-' || upper(ls.store_desc) AS local_store, t.date_id, t.responsible, neighbor_responsible " +
				  "FROM op_grl_transfer t INNER JOIN ss_cat_neighbor_store rs ON " +
				  " (t.neighbor_store_id = rs.store_id ) " +
				  "INNER JOIN ss_cat_store ls ON (t.local_store_id = ls.store_id) " +
				  "LEFT JOIN op_grl_confirm_transfer c ON (t.transfer_id = c.transfer_id) " +
				  "WHERE date_trunc('day', t.date_id) IN " +
				  "(SELECT date_id FROM ss_cat_time WHERE year_no="+psYear+ " ";

		if(!psPeriod.equals("0"))
				lsQuery += "AND period_no="+psPeriod+ " ";

		if(!psWeek.equals("0"))
				lsQuery += "AND week_no="+psWeek+" ";

        if(!msDay.equals("0"))
            	lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

		lsQuery += ") AND t.transfer_type="+lsTransferType;


        return lsQuery;
    }

%>
