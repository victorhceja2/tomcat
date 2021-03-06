<%!
    String getLongPhone()
    {
        String lsQueryP;
        lsQueryP = "SELECT long_phone FROM op_call_conf limit 1";
        return moAbcUtils.queryToString(lsQueryP);
    }

    String calculateLada()
    {
        String lsQueryL;
        lsQueryL = "SELECT LENGTH(lada)+1 FROM op_call_conf limit 1";
        //query = Str.getFormatted(query, new Object[]{});                
        return moAbcUtils.queryToString(lsQueryL);
    }

    
    String getDate(String lsYear, String lsPeriod, String lsWeek, String lsDay)
    {

    /*System.out.println("Esto es de getDate => lsyear:"+lsYear+" lsperiod:"+lsPeriod+" lsweek:"+lsWeek+" lsday:"+lsDay);
    System.out.println("Esto es de getDate => msperiod:"+msPeriod+" msweek:"+msWeek+" lsday:"+lsDay);*/
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
        String lsLongLada;
        
        lsLongLada = calculateLada();
        lsLengthPhone = getLongPhone();

        String lsQuery;
        // Este qry trae toda la inf
        lsQuery = "SELECT a.phone,CAST(c.ord_time AS CHAR(8)),CAST(a.hour_b AS CHAR(8)), ";
        lsQuery += "CAST(a.hour_b+(a.duration_call)::INTERVAL AS CHAR(8)),CAST(a.duration_call AS CHAR(8)), ";
        lsQuery += "'0',CAST(a.date_id AS CHAR(10)),CAST(b.gc_sequence AS CHAR(3)) FROM op_call_conm a ";
        lsQuery += "INNER JOIN gc_delivery b ON ";
        lsQuery += "(a.date_id=b.date_id AND SUBSTR(a.phone,"+lsLongLada+","+lsLengthPhone+")=b.client) ";
        lsQuery += "INNER JOIN gc_guest_checks c ON ";
        lsQuery += "(c.gc_sequence=b.gc_sequence AND c.date_id=b.date_id) ";
        lsQuery += "WHERE a.phone IN ";
        lsQuery += "(SELECT phone FROM op_call_conm WHERE ";
        lsQuery += "type_call = 'I' AND phone <> 'IN' AND date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

        lsQuery += "GROUP BY phone HAVING COUNT(phone) > 1 ) ";
        lsQuery += "AND b.client IN ";
        lsQuery += "(SELECT client FROM gc_delivery WHERE ";
        lsQuery += "date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

        lsQuery += "GROUP BY client HAVING COUNT(client) = 1 ) ";


        lsQuery += "AND a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "UNION SELECT '<b class=bsTotals>Totales </b>','','','','','','','' ";
        lsQuery += "ORDER BY phone, hour_b, date_id";

        return moAbcUtils.getJSResultSet(lsQuery);
    }

    String getDataset1(String psCurrentYear1, String psPeriod1, String psWeek1, String msDay1)
    {

        String lsLengthPhone1;
        String lsLongLada1;
        
        lsLongLada1 = calculateLada();
        lsLengthPhone1 = getLongPhone();

        String lsvQuery;

        lsvQuery = "SELECT name,b.client,CAST(count(phone) AS CHAR(3)),CAST(sum(duration_call) AS CHAR(8)),CAST(a.date_id AS CHAR(10)) ";
        lsvQuery += "FROM op_call_conm a ";
        lsvQuery += "INNER JOIN sus_clients b ON ";
        lsvQuery += "(SUBSTR(phone,"+lsLongLada1+","+lsLengthPhone1+")=client) ";
        lsvQuery += "WHERE date_id IN ";
        lsvQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsvQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsvQuery += " AND week_no="+msWeek+" ";

        if(!msDay1.equals("0"))
            lsvQuery += " AND EXTRACT(day from date_id) = " + msDay1;

        lsvQuery += ") ";
        lsvQuery += "AND last_gc_date < (SELECT MIN(date_id) FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsvQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsvQuery += " AND week_no="+msWeek+" ";

        if(!msDay1.equals("0"))
            lsvQuery += " AND EXTRACT(day from date_id) = " + msDay1;

        lsvQuery += ") ";

        lsvQuery += "AND b.client NOT IN (SELECT client FROM gc_delivery WHERE date_id IN ";
        lsvQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsvQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsvQuery += " AND week_no="+msWeek+" ";

        if(!msDay1.equals("0"))
            lsvQuery += " AND EXTRACT(day from date_id) = " + msDay1;

        lsvQuery += ") ";

        lsvQuery += " ) GROUP BY b.client, name, a.date_id ";
        lsvQuery += "UNION SELECT '','<b class=bsTotals>Totales </b>','<b class=bsTotals>Llamadas ' || CAST(count(phone) AS CHAR(3)) || '</b>', ";
	lsvQuery += "'<b class=bsTotals>' || CAST(sum(duration_call) AS CHAR(8)) || '</b>','' ";
        lsvQuery += "FROM op_call_conm a ";
        lsvQuery += "INNER JOIN sus_clients b ON ";
        lsvQuery += "(SUBSTR(phone,"+lsLongLada1+","+lsLengthPhone1+")=client) ";
        lsvQuery += "WHERE date_id IN ";
        lsvQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsvQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsvQuery += " AND week_no="+msWeek+" ";

        if(!msDay1.equals("0"))
            lsvQuery += " AND EXTRACT(day from date_id) = " + msDay1;

        lsvQuery += ") ";
        lsvQuery += "AND last_gc_date < (SELECT MIN(date_id) FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsvQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsvQuery += " AND week_no="+msWeek+" ";

        if(!msDay1.equals("0"))
            lsvQuery += " AND EXTRACT(day from date_id) = " + msDay1;

        lsvQuery += ") ";

        lsvQuery += "AND b.client NOT IN (SELECT client FROM gc_delivery WHERE date_id IN ";
        lsvQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";

        if(!msPeriod.equals("0"))
            lsvQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsvQuery += " AND week_no="+msWeek+" ";

        if(!msDay1.equals("0"))
            lsvQuery += " AND EXTRACT(day from date_id) = " + msDay1;

        lsvQuery += ") ) ";

        lsvQuery += "ORDER BY name DESC ";

        return moAbcUtils.getJSResultSet(lsvQuery);
    }

    String getDataset2(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {

        String lsLengthPhone;
        String lsLongLada;
        
        lsLongLada = calculateLada();
        lsLengthPhone = getLongPhone();

        String lsQuery;
        // Este qry trae toda la inf
        lsQuery = "SELECT a.phone,CAST(c.ord_time AS CHAR(8)),CAST(a.hour_b AS CHAR(8)), ";
        lsQuery += "CAST(a.hour_b+(a.duration_call)::INTERVAL AS CHAR(8)),CAST(a.duration_call AS CHAR(8)), ";
        lsQuery += "CAST(delivery_time AS CHAR(8)),CAST(a.date_id AS CHAR(10)),CAST(b.gc_sequence AS CHAR(3)) FROM op_call_conm a ";
        lsQuery += "INNER JOIN gc_delivery b ON ";
        lsQuery += "(a.date_id=b.date_id AND SUBSTR(a.phone,"+lsLongLada+","+lsLengthPhone+")=b.client) ";
        lsQuery += "INNER JOIN gc_guest_checks c ON ";
        lsQuery += "(c.gc_sequence=b.gc_sequence AND c.date_id=b.date_id) ";
        lsQuery += "WHERE a.phone IN ";
        lsQuery += "(SELECT phone FROM op_call_conm WHERE ";
        lsQuery += "type_call = 'I' AND phone <> 'IN' AND date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

        lsQuery += "GROUP BY phone HAVING COUNT(phone) = 1 ) ";
        lsQuery += "AND b.client IN ";
        lsQuery += "(SELECT client FROM gc_delivery WHERE ";
        lsQuery += "delivery_time > '00:30:00' AND date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

        lsQuery += "GROUP BY client HAVING COUNT(client) = 1 ) ";


        lsQuery += "AND a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        //lsQuery += "UNION SELECT '<b class=bsTotals>Totales </b>','','','','','','','' ";
        lsQuery += "ORDER BY phone, hour_b, date_id";

        return moAbcUtils.getJSResultSet(lsQuery);
 
    }


    void updateConm(String lsYearC, String lsPeriodC, String lsWeekC, String lsDayC){
        
        String lsDate="";
        String lsParamDate="";
//System.out.println("msYear:"+msYear+", msPeriod:"+msPeriod+", msWeek:"+msWeek+", lsDayC"+lsDayC);
        lsDate=getDate(msYear, msPeriod, msWeek, lsDayC);
	
System.out.println("Este es lsDate:"+lsDate);

        String laCommand[];
        try{
            if(!lsDate.equals("0")){
                lsParamDate= ""+lsDate.substring(2,4).concat(lsDate.substring(5,7)).concat(lsDate.substring(8,10))+"";
                laCommand = new String[]{"/usr/bin/ph/databases/call/bin/call_pop.s",lsParamDate};
            } else {
                laCommand = new String[]{"/usr/bin/ph/databases/call/bin/call_pop.s"};
            }
                Process process = Runtime.getRuntime().exec(laCommand);
                process.waitFor();
            }
        catch(Exception e){
            System.out.println("Exception de exec e ... " + e.toString());
        }
     }//Fin metodo updateConm()
%>
