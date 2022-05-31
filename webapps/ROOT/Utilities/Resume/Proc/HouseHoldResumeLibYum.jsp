<%!
   
    String getLimitDates(String psYear, String psMode, String psPeriod)
    {
        String lsQry;
	if(psMode.equals("I")){
	   lsQry = "SELECT to_char(MIN(date_id), 'YYYY-MM-DD') FROM ss_cat_time where period_no ";
	   lsQry += "= 1 and week_no = 1 AND year_no = " + psYear;
	}else{
	   lsQry = "SELECT to_char(MAX(date_id), 'YYYY-MM-DD') FROM ss_cat_time where period_no ";
	   lsQry += "= "+ psPeriod+" AND year_no = " + psYear;
	}

	return moAbcUtils.queryToString(lsQry);
    }

    String getDateNow()
    {
        String lsQry;
        lsQry = "SELECT to_char(now(), 'YYYY-MM-DD')";
        return moAbcUtils.queryToString(lsQry);
    }

    String getCurrentPeriod(String psDate)
    {
        String lsQry;
	lsQry = "SELECT get_period('"+ psDate +"')";
        return moAbcUtils.queryToString(lsQry);
    }
    
    String getCurrentYear(String psDate){
        String lsQry;
	lsQry = "SELECT get_year('"+ psDate +"')";
        return moAbcUtils.queryToString(lsQry);
    }

    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {

        String lsCurrInitDate, lsPastInitDate, lsLastInitDate;
        String lsCurrEndDate, lsPastEndDate, lsLastEndDate;
        String lsDateNow;
	String lsCurrPer;
	String lsCurrYear;
        
        lsDateNow = getDateNow();
        lsCurrYear = getCurrentYear(lsDateNow);
        lsCurrPer = getCurrentPeriod(lsDateNow);

	lsCurrInitDate = getLimitDates(lsCurrYear,"I",lsCurrPer);
        lsCurrEndDate = getLimitDates(lsCurrYear,"E",lsCurrPer);

	String lsPastYear = Integer.toString(Integer.parseInt(lsCurrYear)-1);
	String lsLastYear = Integer.toString(Integer.parseInt(lsCurrYear)-2);

	lsPastInitDate = getLimitDates(lsPastYear,"I",lsCurrPer);
        lsPastEndDate = getLimitDates(lsPastYear,"E",lsCurrPer);

	lsLastInitDate = getLimitDates(lsLastYear,"I",lsCurrPer);
        lsLastEndDate = getLimitDates(lsLastYear,"E",lsCurrPer);

        String lsQryMain;
       
        lsQryMain =  "SELECT a.ageb_id,CAST(ROUND(c.trans,0) AS CHAR(3)),CAST(ROUND(b.trans,0) AS CHAR(3)), CAST(ROUND(a.trans,0) AS CHAR(3)), ";
	lsQryMain += "CAST((ROUND(a.trans,0) - ROUND(c.trans,0)) AS CHAR(3)), CAST((ROUND(a.trans, 0) - ROUND(b.trans,0)) AS CHAR(3))";
	lsQryMain += "FROM (SELECT ageb_id, avg(transactions) AS trans FROM op_hh_week_transactions ";
	lsQryMain += "WHERE date_id BETWEEN '" + lsCurrInitDate + "' AND '" + lsCurrEndDate + "' GROUP BY 1 ORDER BY ageb_id) AS a INNER JOIN ";
        lsQryMain += "(SELECT ageb_id, AVG(transactions) AS trans FROM op_hh_week_transactions ";
        lsQryMain += "WHERE date_id BETWEEN '" + lsPastInitDate + "' AND '" + lsPastEndDate + "' GROUP BY 1 ORDER BY ageb_id) AS b ON (a.ageb_id = b.ageb_id) INNER JOIN ";
	lsQryMain += "(SELECT ageb_id, AVG(transactions) AS trans FROM op_hh_week_transactions ";
        lsQryMain += "WHERE date_id BETWEEN '"+ lsLastInitDate +"' AND '"+ lsLastEndDate +"' GROUP BY 1 ORDER BY ageb_id) AS c ON (b.ageb_id = c.ageb_id) ";
	lsQryMain += "UNION ";
	lsQryMain += "SELECT 'ZZZZ','','','','','' ORDER BY 1 ";

        return moAbcUtils.getJSResultSet(lsQryMain);
    }

//    void updateConm(String lsYearC, String lsPeriodC, String lsWeekC, String lsDayC){
 //    }//Fin metodo updateConm()
%>
