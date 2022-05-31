<%!

    String getTotCuponDest(String psCurrentYear, String psPeriod, String psWeek, String msDay, String psDestination)
    {
        String  lsQuery;
        
	lsQuery = "SELECT COUNT(*) FROM gc_coupons cp INNER JOIN gc_guest_checks gc ON (gc.date_id=cp.date_id and gc.gc_sequence=cp.gc_sequence) ";
	lsQuery += "WHERE destination = '"+psDestination+"' AND CAST(gc.date_id AS CHAR(10)) IN ";
        lsQuery += "(SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE  year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

        return moAbcUtils.queryToString(lsQuery);
    }
    

    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {

        String lsQuery;

	String lsTotDine = getTotCuponDest(psCurrentYear,psPeriod,psWeek,msDay,"1");
	String lsTotDely = getTotCuponDest(psCurrentYear,psPeriod,psWeek,msDay,"2");
	String lsTotCOut = getTotCuponDest(psCurrentYear,psPeriod,psWeek,msDay,"3");
	String lsTotWind = getTotCuponDest(psCurrentYear,psPeriod,psWeek,msDay,"4");

        lsQuery = "SELECT to_char(gc.date_id, 'YYYY-Mon-DD Day') AS date_id, (CASE WHEN gc.destination = '1' THEN 'COMEDOR' WHEN gc.destination = '2' THEN 'ENTREGA/DOMICILIO' ";
	lsQuery += "WHEN gc.destination = '3' THEN 'PARA/LLEVAR' ELSE 'VENTANA' END), cc.coup_desc, COUNT(*), SUM(cp.gross) ";
        lsQuery += "FROM gc_guest_checks gc INNER JOIN gc_items it ON (gc.date_id=it.date_id AND gc.gc_sequence=it.gc_sequence) ";
        lsQuery += "INNER JOIN gc_coupons cp ON (it.date_id=cp.date_id AND it.gc_sequence=cp.gc_sequence AND it.it_seq=cp.it_seq) ";
        lsQuery += "INNER JOIN gc_coupon_codes cc ON (cp.coupon_id=cc.coupon_id) ";
	lsQuery += "WHERE CAST(gc.date_id AS CHAR(10)) IN ";
        lsQuery += "(SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

	lsQuery += "GROUP BY 1,2,3 ";
	
	lsQuery += "UNION ";
	lsQuery += "SELECT '<b class=bsTotals>Totales</b>','<b class=bsTotals>Comedor: "+lsTotDine+"&nbsp;&nbsp; Entrega: "+lsTotDely+" &nbsp;&nbsp; Llevar: "+lsTotCOut+"&nbsp;&nbsp; Ventana: "+lsTotWind+"</b>', ";
	lsQuery += "'',COUNT(*),SUM(gross) FROM gc_coupons ";
	lsQuery += "WHERE CAST(date_id AS CHAR(10)) IN ";
        lsQuery += "(SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";

	lsQuery += "GROUP BY 1,2,3 ORDER BY date_id";
	
        return moAbcUtils.getJSResultSet(lsQuery);
    }

%>
