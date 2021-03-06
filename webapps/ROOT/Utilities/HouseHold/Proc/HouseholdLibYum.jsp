
<%!
    String getHouseholdEntryQuery()
    {
        String query;

        query = "SELECT ageb_id, house_hold, target FROM op_hh_ageb WHERE ageb_id != '' " +
                "ORDER BY ageb_id ";

        return query;
    }

    String getDataset(String psPreviousYear, String psCurrentYear, String psPeriod, String psWeek)
    {
        String lsQuery;

/*
 ageb_id       | character varying(5) |
 house_hold    | integer              |
 prom1         | numeric(12,2)        |
 penetration   | numeric              |
 participation | numeric              |
 target        | smallint             |
 prom2         | numeric              |
 anualindex    | numeric              |
 trans_act     | numeric              |
 trans_ant     | numeric              |
*/
        lsQuery = "SELECT ageb_id || '&nbsp;' AS ageb_id, house_hold || '&nbsp;' AS house_hold, " +
                  "round(prom1,0) || '&nbsp;', "+
                  "round(penetration*100,2) || '%', " +
                  "round(participation*100,2) || '&#37; &nbsp;' , "+
                  "target || '&nbsp;', "+
                  "round(prom2,0) || '&nbsp;', "+
                  "round(anualindex*100,2) || '&nbsp;', "+
                  "trans_ant || '&nbsp;' as trans2005, "+
                  "trans_act || '&nbsp;' as trans2006, (CASE WHEN trans_ant = 0 THEN 0 ELSE "+
                  "ROUND((CAST(trans_act AS DECIMAL)/CAST(trans_ant AS DECIMAL))*100,2) END) || '&nbsp' AS index, "+
                  "lower(ageb_id) AS theageb "+
                  "FROM op_hh_step_transactions "+
                  "UNION "+
                  "SELECT '<br>&nbsp;<br>', '<b class=bsTotals>'|| sum(house_hold) || '&nbsp;</b>', "+
                  "'<b class=bsTotals>' || sum(prom1) || '</b>&nbsp;', "+
                  "'<b class=bsTotals>' || round(sum(prom1)/sum(house_hold)*100,2)|| '% </b>', "+
                  "'<b class=bsTotals>' || round(sum(participation)*100,2) || '% &nbsp;</b>', "+
                  "'<b class=bsTotals>' || sum(target) || '&nbsp;</b>', "+
                  "'<b class=bsTotals>' || round(sum(prom2),0) || '&nbsp;</b>', "+
                  "'<b class=bsTotals>' || round(sum(prom2)/sum(target)*100,2) || '&nbsp;</b>', "+
                  "'<b class=bsTotals>' || sum(trans_ant) || '&nbsp;</b>', "+
                  "'<b class=bsTotals>' || sum(trans_act) || '&nbsp;</b>', "+
                  "'<b class=bsTotals>' || (CASE WHEN sum(trans_ant) = 0 THEN 0 ELSE "+ 
                  "(ROUND(CAST(CAST(sum(trans_act) AS DECIMAL)/CAST(sum(trans_ant) AS DECIMAL) AS DECIMAL (10,2))*100,2)) END) || '&nbsp;</b>', 'z-zz'  "+ 
                  "FROM op_hh_step_transactions " +
                  "ORDER BY theageb ASC";


        return moAbcUtils.getJSResultSet(lsQuery);
    }

    String getReportQuery(String psPreviousYear, String psCurrentYear, String psPeriod, String psWeek)
    {
        String query;
        String yearTransactions;
        String beginDate;
        String endDate;

        yearTransactions = getYearTransactions(psPreviousYear);

        //Calcula la fecha de la primer semana del primer periodo
        beginDate = calculateBeginDate(psCurrentYear);
        //Calcula la fecha de la ultima semana que ha sido cerrada
        endDate   = calculateEndDate(psCurrentYear, psPeriod, psWeek);
//System.out.println(yearTransactions + "-" + beginDate + "-" + endDate);

        query = "SELECT a.ageb_id, a.house_hold, y.transactions AS prom1 , " +
                //"y.transactions / no_zero(a.house_hold,1) AS penetration, " +
                "(CASE WHEN a.house_hold = 0 THEN 0 ELSE (y.transactions / a.house_hold) END) " +
                "AS penetration, " +
                "avg(y.transactions / %s) AS participation, " +
                "a.target, "+
                "avg(w.transactions) AS prom2, avg(w.transactions)/a.target " +
                "AS anualindex, 0 AS Trans2005, wt.transactions AS Trans2006 FROM op_hh_ageb a INNER JOIN op_hh_year_transactions y "+
                "ON (a.ageb_id = y.ageb_id ) INNER JOIN op_hh_week_transactions wt "+
                "ON(y.ageb_id = wt.ageb_id ) INNER JOIN op_hh_week_transactions w " +
                "ON(y.ageb_id = w.ageb_id ) " +
                "WHERE y.year_no = %s AND "+
                "w.date_id >= '%s' AND w.date_id <= '%s' "+
                "AND wt.date_id = '%s' " +
                "GROUP BY a.ageb_id, a.house_hold, y.transactions, a.target, wt.transactions "+
                "UNION " +
                "SELECT a.ageb_id, a.house_hold,0,0 as penetration, 0 as participation, "+
                "a.target, avg(w.transactions) AS prom2, avg(w.transactions)/a.target AS " +
                "anualindex,0, wt.transactions as Trans2006 FROM op_hh_ageb a INNER JOIN op_hh_week_transactions wt "+
                "ON(a.ageb_id = wt.ageb_id) INNER JOIN op_hh_week_transactions w ON(a.ageb_id = w.ageb_id) WHERE a.ageb_id NOT IN "+
                "( SELECT DISTINCT(ageb_id) FROM op_hh_year_transactions "+
                "WHERE year_no = '%s') AND w.date_id >= '%s' " +
                "AND w.date_id <= '%s' AND wt.date_id = '%s' "+
                "GROUP BY a.ageb_id, a.house_hold, a.target, wt.transactions " +
                "ORDER BY ageb_id ASC";

        query = Str.getFormatted(query, new Object[]{yearTransactions, psPreviousYear, beginDate, endDate, endDate, psPreviousYear, beginDate, endDate, endDate});

        return query;
    }

    String getUpdQuery(String psCurrentYear,String psPeriod, String psWeek){
        String endDate;
        String query;

        endDate = calculateEndDate(psCurrentYear, psPeriod, psWeek);

        query="UPDATE op_hh_step_transactions SET trans_ant = op_hh_week_transactions.transactions " +
              "FROM op_hh_week_transactions WHERE op_hh_step_transactions.ageb_id=op_hh_week_transactions.ageb_id " +
              "AND op_hh_week_transactions.date_id=(SELECT DATE '%s' - INTERVAL '52 WEEK' AS DATE )";

        query = Str.getFormatted(query, new Object[]{endDate});
        return query;
    }


    boolean reportOk(String psPreviousYear, String psCurrentYear, String psPeriod, String psWeek)
    {
        String query;    
        String lsResult;

        query      = "DELETE FROM op_hh_step_transactions";
        moAbcUtils.executeSQLCommand(query);

        query      = "INSERT INTO op_hh_step_transactions " + getReportQuery(psPreviousYear, psCurrentYear, psPeriod, psWeek);
        moAbcUtils.executeSQLCommand(query);

        query      = "" + getUpdQuery(psCurrentYear, psPeriod, psWeek);
        moAbcUtils.executeSQLCommand(query);

        query      = "SELECT COUNT(*) FROM op_hh_step_transactions";
        lsResult = moAbcUtils.queryToString(query);

        if(lsResult != null && Integer.parseInt(lsResult) > 0)
            return true;
        else
            return false;
    }

    String calculateBeginDate(String psCurrentYear)
    {
        String query;

        query = "SELECT DATE_TRUNC('day', date_id) FROM ss_cat_time WHERE year_no = %s "+
                "AND period_no = 1 AND weekday_id = 7";

        query = Str.getFormatted(query, new Object[]{psCurrentYear});                

        return moAbcUtils.queryToString(query);
    }

    String calculateEndDate(String psYearNo, String psPeriodNo, String psWeek)
    {
        String lsQuery;
        String weekNo;
        
        weekNo = getWeekNo(psYearNo, psPeriodNo, psWeek);

        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+psYearNo+" AND period_no="+psPeriodNo+" AND "+
                  "week_no="+weekNo+" AND weekday_id=7";
                    
        return moAbcUtils.queryToString(lsQuery);
    }

    String getPreviousYear(String psYear)
    {
        int currentYear = Integer.parseInt(psYear);

        return Integer.toString(currentYear-1);
    }

    String getYearTransactions(String psYear)
    {
        String query;

        query = "SELECT SUM(transactions) FROM op_hh_year_transactions WHERE year_no = '%s'";
        query = Str.getFormatted(query, new Object[]{psYear});

        return moAbcUtils.queryToString(query);
    }

    boolean saveChanges(HttpServletRequest poRequest)
    {
        int liNumRows;
        String query;

        try
        {
            liNumRows   = Integer.parseInt(poRequest.getParameter("numRows"));
            query       = "UPDATE op_hh_ageb SET house_hold=?, target=? WHERE ageb_id=?";

            for(int liRowId=0; liRowId<liNumRows; liRowId++)
            {
                String agebId = poRequest.getParameter("ageb|"+liRowId);
                String househ = poRequest.getParameter("household|"+liRowId);
                String target = poRequest.getParameter("target|"+liRowId);

                househ = househ.trim();
                target = target.trim();

                moAbcUtils.executeSQLCommand(query, new String[]{househ, target, agebId});
            }

            saveHouseholdData();

            return true;
        }
        catch(Exception e)
        {
            System.out.println("Exception ... " + e.toString());

            return false;
        }
    }

    String getHouseholdData()
    {
        String query;
        String regs[][];
        String data;

        query = "SELECT trim(ageb_id), trim(house_hold) FROM op_hh_ageb WHERE ageb_id != '' "+ 
                "ORDER BY ageb_id ASC";

        regs  = moAbcUtils.queryToMatrix(query);
        data  = "";

        for(int rowId=0; rowId<regs.length; rowId++)
        {
            String ageb_id    = regs[rowId][0];
            String house_hold = regs[rowId][1];

            data += ageb_id + "|" + house_hold + "\n";
        }
            data += "|0";

        return data;
    }

    void saveHouseholdData()
    {
        String filename = "/usr/bin/ph/ml/dat/houseHold.dat";

        try
        {
            java.io.File file = new java.io.File(filename);

            if(file.exists())
            {
                java.io.PrintWriter writer = 
                        new java.io.PrintWriter(new java.io.FileWriter(file));

                if(writer != null)
                {
                    writer.print(getHouseholdData());
                    writer.flush();
                    writer.close();

generateHistory();
                }    
            }
        
        }
        catch(Exception e)
        {
            System.out.println("Exception e.. " + e.toString());
        }
    }

void updateAgebs()
{
try
{
String laCommand[] = {"/usr/local/tomcat/webapps/ROOT/Scripts/upd_agebs.s"};
Process process = Runtime.getRuntime().exec(laCommand);
process.waitFor();
}
catch(Exception e)
{
System.out.println("Exception e ... " + e.toString());
}
}

void generateHistory()
{
try
{
String lsCommand = "/usr/local/tomcat/webapps/ROOT/Scripts/gen_his_grid.s";
Runtime.getRuntime().exec(lsCommand);
}
catch(Exception e)
{
System.out.println("Exception e ... " + e.toString());
}
}
%>
