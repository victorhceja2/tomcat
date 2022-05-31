
<%@ page import="generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msYear   = "0";
    String msPeriod = "0";
    String msWeek   = "0";
    String msDay    = "0";
    String msReport = "0";
    //String msType   = "input";
%>
<%
    try
    {
        msYear   = request.getParameter("hidSelectedYear");
        msPeriod = request.getParameter("hidSelectedPeriod");
        msWeek   = request.getParameter("hidSelectedWeek");
        msDay    = request.getParameter("hidSelectedDay");
        msReport = request.getParameter("hidReportType");
        //msType   = request.getParameter("type");
    }
    catch(Exception e)
    {
        
    }
%>

<script>
    var rsData = new Array();
    var gaDataset = <%= getDataset() %>;
</script>

<%@ include file="/Include/CalendarLibYum.jsp" %>

<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="CTransferReportFrm.jsp?hidTarget=Preview" name="preview" frameborder="0">
      <FRAME src="CTransferReportFrm.jsp?hidTarget=Printer" name="printer" frameborder="0">
</FRAMESET>
<%!
    String getDataset()
    {
        String lsData;
        String lsQuery;

        try
        {
            //lsQuery = getQueryReport(msYear, msPeriod, msWeek, msDay, psTransferType);
            lsQuery = getQueryReport(msYear, msPeriod, msWeek, msDay);
            lsData  = moAbcUtils.getJSResultSet(lsQuery);
        }
        catch(Exception e)
        {
            lsData = " new Array()";
        }

        return lsData;
    }

    //String getQueryReport(String psYear, String psPeriod, String psWeek, String psDay, String psType)
    String getQueryReport(String psYear, String psPeriod, String psWeek, String psDay)
    {
        String lsQuery;
        //String lsTransferType;

        //lsTransferType = psType.equals("input")?"1":"0";

        lsQuery = "SELECT transfer_id,ns.store_desc || ' - ' || neighbor_store_id, date_id, (CASE WHEN transfer_type = 1 THEN 'Entrada' ELSE 'Salida' END), " +
                  "REPLACE(responsible, '_', ' '), REPLACE(neighbor_responsible,'_',' '), (CASE WHEN confirm = 1 THEN 'Confirmada' WHEN confirm =0 THEN 'Pendiente' ELSE 'Rechazada' END), " +
                  "(CASE WHEN description is null THEN '' ELSE description END) " +
                  "FROM op_grl_confirm_transfer c LEFT JOIN op_grl_cat_reject_transfer r ON (c.reason_reject = r.reject_id) " +
                  "INNER JOIN ss_cat_neighbor_store ns ON (c.neighbor_store_id = ns.store_id) " +
                  "WHERE date_trunc('day', c.date_id) IN " +
                  "(SELECT date_id FROM ss_cat_time WHERE year_no="+psYear+ " ";

        if(!psPeriod.equals("0"))
                lsQuery += "AND period_no="+psPeriod+ " ";

        if(!psWeek.equals("0"))
                lsQuery += "AND week_no="+psWeek+" ";

        if(!msDay.equals("0"))
                lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ")";
        //lsQuery += ") AND t.transfer_type="+lsTransferType;


        return lsQuery;
    }

%>
