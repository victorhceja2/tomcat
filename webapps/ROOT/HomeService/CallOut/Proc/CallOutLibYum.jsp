<%!
   
    String getMngLine()
    {
        String lsMngLineQry;
	lsMngLineQry = "SELECT manager_line FROM op_call_conf order by date_id desc limit 1";
	return moAbcUtils.queryToString(lsMngLineQry);
    }

    String getLongPhone()
    {
        String lsQueryP;
        lsQueryP = "SELECT long_phone FROM op_call_conf order by date_id desc limit 1";
        return moAbcUtils.queryToString(lsQueryP);
    }

    String getDate(String lsYear, String lsPeriod, String lsWeek, String lsDay)
    {
        String lsQueryD="";
        if(!lsDay.equals("0"))
	{
            lsQueryD += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
            if(!msPeriod.equals("0"))
                lsQueryD += " AND period_no="+msPeriod +" ";

            if(!msWeek.equals("0"))
                lsQueryD += " AND week_no="+msWeek+" ";

            if(!lsDay.equals("0"))
                lsQueryD += " AND EXTRACT(day from date_id) = " + lsDay;

            lsQueryD += ") ";

            return moAbcUtils.queryToString(lsQueryD);
        }else{
	    return "0";
        }
    }

    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {

        String lsLengthPhone;
        String lsMngLinePhone;
	String lsDelCall;
	String lsSelCall;
        
	lsMngLinePhone = getMngLine();
        lsLengthPhone = getLongPhone();

        lsDelCall = "DELETE FROM op_call_out_step";
        moAbcUtils.executeSQLCommand(lsDelCall);

        String lsQuery;
       
        lsQuery =  "INSERT INTO op_call_out_step ";
        lsQuery += "SELECT DISTINCT phone, phone_line, a.hour_b, ";
        lsQuery += "hour_b+(a.duration_call)::INTERVAL,a.duration_call-('00:00:02')::INTERVAL, ";
        lsQuery += "a.date_id FROM op_call_conm a, ";
        lsQuery += "op_call_conf b WHERE type_call = 'C' AND phone ";
        lsQuery += " NOT IN (SELECT DISTINCT client from sus_clients) ";
        lsQuery += "AND a.date_id IN ";
        lsQuery += "(SELECT date_id::date FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "GROUP BY phone, phone_line, a.hour_b, a.duration_call, a.date_id, long_phone ";
        lsQuery += "HAVING LENGTH(phone) >= long_phone ";
        lsQuery += "UNION ";
        lsQuery += "SELECT DISTINCT phone, phone_line, a.hour_b, ";
        lsQuery += "hour_b+(a.duration_call)::INTERVAL, a.duration_call-('00:00:02')::INTERVAL, ";
        lsQuery += "a.date_id FROM op_call_conm a, ";
        lsQuery += "op_call_conf b WHERE type_call = 'C' AND phone ";
        lsQuery += "IN (SELECT DISTINCT client from sus_clients WHERE d_sold_avg=0.00) ";
        lsQuery += "AND a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "GROUP BY phone, phone_line, a.hour_b, a.duration_call, a.date_id, long_phone ";
        lsQuery += "HAVING LENGTH(phone) >= long_phone ";
 
        lsQuery += "ORDER BY phone, date_id";

        moAbcUtils.executeSQLCommand(lsQuery); 

        lsSelCall =  "SELECT phone, '"+lsMngLinePhone+"-' || line, CAST(hour_b AS CHAR(8)), CAST(hour_e AS CHAR(8)), ";
	lsSelCall += "CAST(duration_call AS CHAR(8)), CAST(date_id AS CHAR(10)) ";
	lsSelCall += "FROM op_call_out_step ";
	lsSelCall += "UNION ";
	lsSelCall += "SELECT '<b class=bsTotals>Totales </b>','', ";
	lsSelCall += "'','','<b class=bsTotals>' || SUM(duration_call) || '</b>','<b class=bsTotals>' || COUNT(*) || ' Llamadas</b>' ";
	lsSelCall += "FROM op_call_out_step order by phone";

        return moAbcUtils.getJSResultSet(lsSelCall);
    }

    String getDatasetC(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {

        String lsLengthPhone;
        String lsMngLinePhone;
	String lsDelCall;
	String lsSelCall;
        
	lsMngLinePhone = getMngLine();
        lsLengthPhone = getLongPhone();

        lsDelCall = "DROP TABLE op_call_out_step_clients";
        moAbcUtils.executeSQLCommand(lsDelCall);

        String lsQuery;
       
        lsQuery =  "CREATE TABLE op_call_out_step_clients AS ";
        lsQuery += "SELECT DISTINCT phone, phone_line, a.hour_b, ";
        lsQuery += "hour_b+(a.duration_call)::INTERVAL AS Duracion,a.duration_call-('00:00:02')::INTERVAL AS Dialogo, ";
        lsQuery += "a.date_id FROM op_call_conm a, ";
        lsQuery += "op_call_conf b WHERE type_call = 'C' AND phone ";
        lsQuery += "IN (SELECT DISTINCT client from sus_clients) ";
        lsQuery += "AND a.date_id IN ";
        lsQuery += "(SELECT date_id::date FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "GROUP BY phone, phone_line, a.hour_b, a.duration_call, a.date_id, long_phone ";
        lsQuery += "HAVING LENGTH(phone) >= long_phone ";
        lsQuery += "UNION ";
        lsQuery += "SELECT DISTINCT phone, phone_line, a.hour_b, ";
        lsQuery += "hour_b+(a.duration_call)::INTERVAL AS Duracion, a.duration_call-('00:00:02')::INTERVAL AS Dialogo, ";
        lsQuery += "a.date_id FROM op_call_conm a, ";
        lsQuery += "op_call_conf b WHERE type_call = 'C' AND phone ";
        lsQuery += "NOT IN (SELECT DISTINCT client from sus_clients WHERE d_sold_avg=0.00) ";
        lsQuery += "AND a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "GROUP BY phone, phone_line, a.hour_b, a.duration_call, a.date_id, long_phone ";
        lsQuery += "HAVING LENGTH(phone) >= long_phone ";
 
        lsQuery += "ORDER BY phone, date_id";

        moAbcUtils.executeSQLCommand(lsQuery); 

        lsSelCall =  "SELECT phone, '"+lsMngLinePhone+"-' || phone_line, CAST(hour_b AS CHAR(8)), CAST(duracion AS CHAR(8)), ";
	lsSelCall += "CAST(dialogo AS CHAR(8)), CAST(date_id AS CHAR(10)) ";
	lsSelCall += "FROM op_call_out_step_clients ";
	lsSelCall += "UNION ";
	lsSelCall += "SELECT '<b class=bsTotals>Totales </b>','', ";
	lsSelCall += "'','','<b class=bsTotals>' || SUM(dialogo) || '</b>','<b class=bsTotals>' || COUNT(*) || ' Llamadas</b>' ";
	lsSelCall += "FROM op_call_out_step_clients order by phone";

        return moAbcUtils.getJSResultSet(lsSelCall);
    }



    void updateConm(String lsYearC, String lsPeriodC, String lsWeekC, String lsDayC){
        
        String lsDate="";
        String lsParamDate="";
        lsDate=getDate(msYear, msPeriod, msWeek, lsDayC);
	lsDate = lsDate.substring(0,10);
//System.out.println("msYear:"+msYear+", msPeriod:"+msPeriod+", msWeek:"+msWeek+", lsDayC"+lsDayC+" lsDate "+lsDate+"|");
	String lsQuery = "SELECT to_char(now(),'YYYY-MM-DD')";
        String lsPqDate = moAbcUtils.queryToString(lsQuery);
	
        String laCommand[];
        lsParamDate= ""+lsDate.substring(2,4).concat(lsDate.substring(5,7)).concat(lsDate.substring(8,10))+"";
        laCommand = new String[]{"/usr/bin/ph/databases/call/bin/call_pop.s",lsParamDate};

        try{
            if(lsDate.equals(lsPqDate))
	    {
		System.out.println("Ejecutando call_pop.pl"+lsParamDate);
                Process process = Runtime.getRuntime().exec(laCommand);
                process.waitFor();
            }
        }catch(Exception e){
            System.out.println("Exception de exec e ... " + e.toString());
        }
     }//Fin metodo updateConm()
%>
