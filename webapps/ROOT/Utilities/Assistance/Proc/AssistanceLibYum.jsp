<%!
    String getDate(String msYear, String msPeriod, String msWeek, String msDay)
    {
        String lsQuery;
        String selectedDate;
        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
		  "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
		  "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
		  "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";
	selectedDate = moAbcUtils.queryToString(lsQuery);
	return selectedDate;
    }

    String getSimpleDate(String msYear, String msPeriod, String msWeek, String msDay){
        String lsQuery;
        String selectedDate;
        lsQuery = "SELECT to_char(date_id, 'DD/mon/YYYY') AS dateid "
                + "FROM ss_cat_time WHERE year_no="+msYear+" "
                + "AND period_no="+msPeriod+" AND week_no="+msWeek+" "
                + "AND EXTRACT(day FROM date_id) = "+msDay+";";
        selectedDate = moAbcUtils.queryToString(lsQuery);
        ArrayList<String> dateTokens = new ArrayList<String>();
        String s =  selectedDate.trim();
        StringTokenizer st = new StringTokenizer( s, "/" );
        while( st.hasMoreTokens() ){
            dateTokens.add( st.nextToken().trim() );
        }
        Map<String, String> monthMap = new HashMap<String, String>();
        monthMap.put("jan", "enero");
        monthMap.put("feb", "febrero");
        monthMap.put("mar", "marzo");
        monthMap.put("apr", "abril");
        monthMap.put("may", "mayo");
        monthMap.put("jun", "junio");
        monthMap.put("jul", "julio");
        monthMap.put("aug", "agosto");
        monthMap.put("sep", "septiembre");
        monthMap.put("oct", "octubre");
        monthMap.put("nov", "noviembre");
        monthMap.put("dec", "diciembre");
        
        String spanishDate = dateTokens.get(0) + " de " + monthMap.get(dateTokens.get(1)) + " de " + dateTokens.get(2);
	return spanishDate;
    }
    
    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay){
        String lsQuery;
        String selectedDate;
        System.out.println("psCurrentYear: "+psCurrentYear+", psPeriod: "+psPeriod+", psWeek: "+psWeek+", msDay: "+msDay);
        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
                "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";
        selectedDate = moAbcUtils.queryToString(lsQuery);
        System.out.println("selectedDate : "+selectedDate);
        lsQuery = "SELECT ppc.emp_num, "
                + "ppe.name||' '||ppe.last_name AS nombre, "
                + "to_char(timein1,'HH24:MI:SS') AS Timein1, "
                + "to_char(timeout1,'HH24:MI:SS') AS Timeout1, "
                + "to_char(timein2,'HH24:MI:SS') AS Timein2,  "
                + "to_char(timeout2,'HH24:MI:SS') AS Timeout2, "
                + "(SELECT total_worked_hours("
                + "CAST(ppc.timein1 as varchar), CAST(ppc.timeout1 as varchar), "
                + "CAST(ppc.timein2 as varchar), CAST(ppc.timeout2 as varchar))) "
                + "AS Total FROM pp_emp_check ppc INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "
                + "WHERE date_id='"+selectedDate+"'  AND COALESCE(payroll_type,'NU') NOT IN ('C3','C2') ORDER BY nombre ASC";
/*		
        lsQuery = "SELECT date_id,ppc.emp_num, "+
                   "ppe.name||' '||ppe.last_name AS nombre, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timein1 AS TIMESTAMP))||':'||"+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timein1 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timein1 AS TIMESTAMP)))) AS Timein1, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timeout1 AS TIMESTAMP))||':'|| "+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timeout1 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timeout1 AS TIMESTAMP)))) AS Timeout1, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timein2 AS TIMESTAMP))||':'|| "+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timein2 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timein2 AS TIMESTAMP)))) AS Timein2, "+
                   "(SELECT EXTRACT(HOUR "+
                   "FROM CAST(ppc.timeout2 AS TIMESTAMP))||':'|| "+
                   "(SELECT EXTRACT(MINUTE "+
                   "FROM CAST(ppc.timeout2 AS TIMESTAMP)))||':'|| "+
                   "(SELECT EXTRACT(SECOND "+
                   "FROM CAST(ppc.timeout2 AS TIMESTAMP)))) AS Timeout2, "+
                   //"(SELECT age(CAST(ppc.timeout1 AS TIMESTAMP), CAST(ppc.timein1 AS TIMESTAMP))) AS Total "+
				   "(SELECT total_worked_hours(CAST(ppc.timein1 as varchar), CAST(ppc.timeout1 as varchar), "+
				   "CAST(ppc.timein2 as varchar), CAST(ppc.timeout2 as varchar))) AS Total "+
                   "FROM pp_emp_check ppc "+
                   "INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "+
                   "WHERE date_id='"+selectedDate+"' " +
                   "ORDER BY emp_num DESC ";
 * */
                
		//System.out.println("query: "+lsQuery);



        /*
        lsQuery = "SELECT ppc.emp_num, ppe.name||' '||ppe.last_name AS nombre, ppc.timein1, ppc.timeout1, ppc.timein2, ppc.timeout2 "+
		          "FROM pp_emp_check ppc INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "+
				  "WHERE date_id='"+selectedDate+"' ORDER BY emp_num DESC";
        */

        return moAbcUtils.getJSResultSet(lsQuery);
    }

    void logResults (String psCurrentYear, String psPeriod, String psWeek, String msDay){
        String lsQuery;
        String selectedDate;
        String result[][];

        Calendar now = Calendar.getInstance();
        String date_timestamp = now.get(Calendar.DATE)+"-"+ (now.get(Calendar.MONTH) + 1)+ "-"+ now.get(Calendar.YEAR)+ " "+ now.get(Calendar.HOUR_OF_DAY) + ":"+ now.get(Calendar.MINUTE)+ ":"+ now.get(Calendar.SECOND);

        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
                "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";
        selectedDate = moAbcUtils.queryToString(lsQuery);

        lsQuery = "SELECT ppc.emp_num, "
                + "ppe.name||' '||ppe.last_name AS nombre, "
                + "to_char(timein1,'HH24:MI:SS') AS Timein1, "
                + "to_char(timeout1,'HH24:MI:SS') AS Timeout1, "
                + "to_char(timein2,'HH24:MI:SS') AS Timein2,  "
                + "to_char(timeout2,'HH24:MI:SS') AS Timeout2, "
                + "(SELECT total_worked_hours("
                + "CAST(ppc.timein1 as varchar), CAST(ppc.timeout1 as varchar), "
                + "CAST(ppc.timein2 as varchar), CAST(ppc.timeout2 as varchar))) "
                + "AS Total FROM pp_emp_check ppc INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "
                + "WHERE date_id='"+selectedDate+"'  AND COALESCE(payroll_type,'NU') NOT IN ('C3','C2') ORDER BY nombre ASC";

        result = moAbcUtils.queryToMatrix(lsQuery);

        String filename = "/usr/bin/ph/fingerprint/logs/ereports.log";

        try {
            FileWriter fstream = new FileWriter(filename, true);
            BufferedWriter out = new BufferedWriter(fstream);
            out.write("**********"+date_timestamp+"*************\n");
            out.write(selectedDate+"\n");
            if ( result.length > 0 ) {
                for ( int i = 0; i < result.length; i++ ) {
                    out.write(result[i][0]+"\t"+result[i][1]+"\t\t"+result[i][2]+"\t"+result[i][3]
                       +"\t"+result[i][4]+"\t"+result[i][5]+"\n");

                }
            }
            out.write("\n\n\n");
            out.close();
        } catch ( Exception  e) {
            System.err.println("Error al escribir log: "+e.getMessage());
        }    
    }

    String getDatasetW(String psCurrentYear, String psPeriod, String psWeek, String msDay){
        String lsQuery;
        String selectedDate;
        System.out.println("psCurrentYear: "+psCurrentYear+", psPeriod: "+psPeriod+", psWeek: "+psWeek+", msDay: "+msDay);
        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate "
                + "FROM ss_cat_time WHERE year_no="+ psCurrentYear +" AND period_no="+ psPeriod +" "
                + "AND week_no="+ psWeek +" AND EXTRACT(day FROM date_id) = "+ msDay +";";
        
        selectedDate = moAbcUtils.queryToString(lsQuery);
        System.out.println("selectedDate : "+selectedDate);
        
        lsQuery = "SELECT DISTINCT ppc.emp_num, ppe.name||' '||ppe.last_name AS nombre "
                + "FROM pp_emp_check ppc INNER JOIN pp_employees ppe ON (ppe.emp_num=ppc.emp_num) "
                + "WHERE date_id IN "
                + "(SELECT to_date( to_char(date_id, 'YYYY-MM-DD'), 'YYYY-MM-DD' ) FROM ss_cat_time WHERE week_no = "+psWeek+" AND year_no = "+psCurrentYear+")  "
                + "AND NOT ppc.emp_num IN  (SELECT emp_num FROM pp_emp_check WHERE date_id='"+ selectedDate +"') "
                + "AND COALESCE(payroll_type,'NU') NOT IN ('C3','C2') "
                + "ORDER BY nombre ASC;";
        //System.out.println("query: "+lsQuery);


        return moAbcUtils.getJSResultSet(lsQuery);
    }
%>
