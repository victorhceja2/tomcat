<%--
##########################################################################################################
    Document   : AssitanceDetail
    Created on : 3/12/2012, 01:46:45 PM
    Author     : Erick Mejia - Strk
    Company    : PRB
##########################################################################################################
--%>

<%@ page import="generals.*" %>
<%@ page import="java.io.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%!
    AbcUtils moAbcUtils = new AbcUtils();
    String noempl = "";
    String msYear;
    String msPeriod;
    String msWeek;
    String sow = "";
    String eow = "";
%>

<%
    try{
        noempl = request.getParameter("noempl");
        msYear   = request.getParameter("year");
        msPeriod = request.getParameter("period");
        msWeek   = request.getParameter("week");
        
        sow = getStartOfWeek();
        eow = getEndtOfWeek();
    }catch(Exception e){
       //tel = "0"; 
    }
    
%>

<script>
    var gaDataset = <%= getDetailedDataset() %>;
</script>

<frameset rows="99%, 1%" border="0">
    <frame src="AssistanceDetailFrm.jsp?target=Preview&noempl=<%= noempl %>&startOfWeek=<%= sow %>&endOfWeek=<%= eow %>" name="preview" frameborder="0"/>
    <frame src="AssistanceDetailFrm.jsp?target=Printer&noempl=<%= noempl %>&startOfWeek=<%= sow %>&endOfWeek=<%= eow %>" name="printer" frameborder="0"/>
</frameset>

<%!
    String getStartOfWeek(){
        String lsData;
        String lsQuery = "select MIN(caldate) as start_of_week "
                + "from (select to_char(date_id, 'yyyy-mm-dd') as caldate "
                + "from ss_cat_time WHERE year_no="+ msYear +" and period_no="+ msPeriod +" and week_no="+ msWeek +") as caldate;";
        lsData = moAbcUtils.queryToString( lsQuery );
        return(lsData);
    }
    
    String getEndtOfWeek(){
        String lsData;
        String lsQuery = "select MAX(caldate) as start_of_week "
                + "from (select to_char(date_id, 'yyyy-mm-dd') as caldate "
                + "from ss_cat_time WHERE year_no="+ msYear +" and period_no="+ msPeriod +" and week_no="+ msWeek +") as caldate;";
        lsData = moAbcUtils.queryToString( lsQuery );
        return(lsData);
    }
    
    String getDetailedDataset(){
        String lsData;

        String lsQuery = "SELECT date_id, "
                + "to_char(timein1,'HH24:MI:SS') as Timein1,to_char(timeout1,'HH24:MI:SS') as Timeout1, "
                + "to_char(timein2,'HH24:MI:SS') as Timein2,to_char(timeout2,'HH24:MI:SS') as Timeout2, "
                + "(SELECT total_worked_hours("
                + "CAST(ppc.timein1 as varchar), CAST(ppc.timeout1 as varchar), "
                + "CAST(ppc.timein2 as varchar), CAST(ppc.timeout2 as varchar))) AS TotalWorkedHours "
                + "FROM pp_emp_check ppc INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "
                + "WHERE ppc.emp_num ='"+noempl+"' "
                + "AND date_id IN (SELECT to_date( to_char(date_id, 'YYYY-MM-DD'), 'YYYY-MM-DD' ) "
                + "FROM ss_cat_time WHERE week_no = "+ msWeek +" AND year_no = "+ msYear +");";

        lsData = moAbcUtils.getJSResultSet( lsQuery );
        return(lsData);
    }
    
%>
