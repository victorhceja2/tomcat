<%!
    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {
        String lsQuery;
        // Este qry trae toda la inf

        lsQuery = "SELECT gc_sequence, CAST(date_id||'_'||disp_time AS CHAR(16)) AS date_id, CAST(gc_key AS CHAR(10)), ";
        lsQuery += "(CASE WHEN name IS NULL THEN 'DESCONOCIDO' ELSE name END), total_tax, gross_sold-total_tax as neto,gross_sold ";
        //lsQuery += "FROM gc_guest_checks ggc LEFT JOIN pp_employees emp ON (ord_emp=emp.emp_code) ";
        lsQuery += "FROM gc_guest_step ggc LEFT JOIN pp_employees emp ON (ord_emp=emp.emp_code) ";
	lsQuery += "WHERE emp_meal=1 AND status_code = 'C' AND ggc.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "UNION SELECT 9999,'XXX','','',0,COUNT(gc_sequence),SUM(gross_sold) ";
        lsQuery += "FROM gc_guest_step ";
        lsQuery += "WHERE emp_meal=1 AND status_code = 'C' AND date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
        lsQuery += "ORDER BY date_id, gc_sequence";
        return moAbcUtils.getJSResultSet(lsQuery);
    }

String getDatasetOld(String psCurrentYear, String psPeriod, String psWeek, String msDay)
{

    String lsQuery;
    // Este qry trae toda la inf

    lsQuery = "SELECT ggc.gc_sequence,CAST(ggc.date_id||'-'||disp_time AS CHAR(16)) AS date_id,CAST(gc_key AS CHAR(10)),(CASE WHEN name IS NULL THEN 'DESCONOCIDO' ELSE name END),";
    lsQuery += "CAST(gc.qty_sold AS CHAR(6)), smi.menu_item_desc,pdesc, get_toppings(ggc.gc_sequence,ggc.date_id,it_seq), gc.gross_sold, ggc.gross_sold ";
    lsQuery += "FROM gc_guest_checks ggc INNER JOIN gc_items gc ON (gc.gc_sequence=ggc.gc_sequence and gc.date_id=ggc.date_id) ";
    lsQuery += "LEFT JOIN pp_employees emp ON (ord_emp=emp.emp_code) ";
    lsQuery += "INNER JOIN sus_menu_items smi ON (smi.menu_item=gc.menu_item) ";
    lsQuery += "INNER JOIN sus_prod_codes spd ON (smi.prodno=spd.prodno and smi.classno=spd.classno) ";
    lsQuery += "WHERE emp_meal=1 AND ggc.date_id IN ";
    lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
    if(!msPeriod.equals("0"))
        lsQuery += " AND period_no="+msPeriod +" ";

    if(!msWeek.equals("0"))
        lsQuery += " AND week_no="+msWeek+" ";

    if(!msDay.equals("0"))
        lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

    lsQuery += ") ";

    lsQuery += "UNION SELECT 9999,'XXX','','','','','','',count(gc_sequence),sum(gross_sold) ";
    lsQuery += "FROM gc_guest_checks ";
    lsQuery += "WHERE emp_meal=1 AND date_id IN ";
    lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
    if(!msPeriod.equals("0"))
        lsQuery += " AND period_no="+msPeriod +" ";

    if(!msWeek.equals("0"))
        lsQuery += " AND week_no="+msWeek+" ";

    if(!msDay.equals("0"))
        lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

    lsQuery += ") ";
    lsQuery += "ORDER BY date_id, gc_sequence";
    return moAbcUtils.getJSResultSet(lsQuery);
}
String getDatesFormatted (String psCurrentYear, String psPeriod, String psWeek, String msDay)
{
    String laDates[][], lsDatesFormatted = "";
    String lsDatesQry = "SELECT SUBSTR(date_id, 1,10) AS date_id,'' FROM ss_cat_time WHERE year_no="+msYear+" ";
    if(!msPeriod.equals("0"))
       lsDatesQry += " AND period_no="+msPeriod +" ";

    if(!msWeek.equals("0"))
       lsDatesQry += " AND week_no="+msWeek+" ";

    if(!msDay.equals("0"))
       lsDatesQry += " AND EXTRACT(day from date_id) = " +msDay;

    laDates = moAbcUtils.queryToMatrix(lsDatesQry);

    if (laDates.length > 1){
        for(int i=0; i<laDates.length; i++){
            if ( i < 6 ){
                lsDatesFormatted += laDates[i][0]+"','";
            }else{
                lsDatesFormatted += laDates[i][0];
            }
        }
    }else{
        lsDatesFormatted = laDates[0][0];
    }
System.out.println("EMPL lsDatesFormatted: "+lsDatesFormatted);
    return lsDatesFormatted;
}

String getDate(String lsYear, String lsPeriod, String lsWeek, String lsDay){
    String lsQueryD="";
    if(!lsDay.equals("0")){
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

void updateP1toDB(String lsYearC, String lsPeriodC, String lsWeekC, String lsDayC){
        
    String lsDate="";
    String lsParamDate="";
    lsDate=getDate(lsYearC, lsPeriodC, lsWeekC, lsDayC);
    lsDate = lsDate.substring(0,10);
    String lsQuery = "SELECT to_char(now(),'YYYY-MM-DD')";
    String lsPqDate = moAbcUtils.queryToString(lsQuery);

    lsParamDate=lsDate.substring(2,4)+"-"+lsDate.substring(5,7)+"-"+lsDate.substring(8,10);

    String laCommand[] = new String[]{"/usr/bin/ph/gctpopn.s"};
    try{
	System.out.println(lsDate+" "+lsPqDate);
        if(lsDate.equals(lsPqDate)){
	    System.out.println(lsDate+" IGUALES "+lsPqDate+" lsParamDate:"+lsParamDate);
            Process process = Runtime.getRuntime().exec(laCommand);
        }
        //process.waitFor();
    }catch(Exception e){
        System.out.println("Exception Reporte Comidas de empleados fecha " + lsParamDate + " de exec e ... " + e.toString());
    }
}

%>
