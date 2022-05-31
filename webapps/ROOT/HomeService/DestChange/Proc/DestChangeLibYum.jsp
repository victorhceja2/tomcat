<%!
    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {
        String lsQuery;

        lsQuery = "SELECT CAST(a.gc_sequence AS CHAR(3)), (CASE WHEN a.destination = '1' THEN 'Comedor' WHEN a.destination = '2' THEN 'Entrega/D' WHEN a.destination = '3' THEN 'P/Llevar' ELSE 'Ventana' END), ";
	lsQuery += "(CASE WHEN b.destination = '1' THEN 'Comedor' WHEN b.destination = '2' THEN 'Entrega/D' WHEN b.destination = '3' THEN 'P/Llevar' ELSE 'Ventana' END), ";
	lsQuery += "CAST(a.date_id AS CHAR(10)),c.client,CAST(b.ord_time AS CHAR(8)), CAST(a.reg_time AS CHAR(8)), SUBSTR(CAST(c.promise_time AS CHAR(8)),4,2), ";
	lsQuery += "CAST(b.ord_time AS CHAR(8)), CAST(b.cash_time AS CHAR(8)), b.gross_sold || '&nbsp;', b.promo_allowance || '&nbsp;', (b.gross_sold - b.promo_allowance) || '&nbsp;'";
	lsQuery += "FROM gc_guest_checks_change a ";
	lsQuery += "INNER JOIN gc_guest_checks b ON (a.store_id=b.store_id and a.date_id=b.date_id and a.gc_sequence=b.gc_sequence) ";
	lsQuery += "INNER JOIN gc_delivery_change c ON (a.store_id = c.store_id and a.date_id = c.date_id and a.gc_sequence = c.gc_sequence) ";
	lsQuery += "WHERE a.destination='2' AND b.destination='3' AND a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
	lsQuery += "UNION ";
	lsQuery += "SELECT CAST(a.gc_sequence AS CHAR(3)), (CASE WHEN a.destination = '1' THEN 'Comedor' WHEN a.destination = '2' THEN 'Entrega/D' WHEN a.destination = '3' THEN 'P/Llevar' ELSE 'Ventana' END), ";
	lsQuery += "(CASE WHEN b.destination = '1' THEN 'Comedor' WHEN b.destination = '2' THEN 'Entrega/D' WHEN b.destination = '3' THEN 'P/Llevar' ELSE 'Ventana' END), ";
	lsQuery += "CAST(a.date_id AS CHAR(10)),'N/A',CAST(b.ord_time AS CHAR(8)), CAST(a.reg_time AS CHAR(8)),'N/A', CAST(b.ord_time AS CHAR(8)), ";
	lsQuery += "CAST(b.cash_time AS CHAR(8)),b.gross_sold || '&nbsp;', b.promo_allowance || '&nbsp', (b.gross_sold - b.promo_allowance) || '&nbsp'";
	lsQuery += "FROM gc_guest_checks_change a ";
	lsQuery += "INNER JOIN gc_guest_checks b ON (a.store_id=b.store_id and a.date_id=b.date_id and a.gc_sequence=b.gc_sequence) ";
	//lsQuery += "INNER JOIN gc_delivery_change c ON (c.store_id=b.store_id and c.date_id=b.date_id) ";
	lsQuery += "WHERE a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ";
    lsQuery += "AND a.destination='2' AND b.destination='3' ";
	lsQuery += "AND a.gc_sequence NOT IN ";
    lsQuery += "(SELECT gc_sequence FROM gc_delivery_change WHERE date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ")) ";

	lsQuery += "UNION ";
	lsQuery += "SELECT '<b class=bsTotals>Totales&nbsp;</b>','','','','','','','','','','<b class=bsTotals>' || SUM(b.gross_sold) || '</b>','<b class=bsTotals>' || SUM(b.promo_allowance) || '</b>','<b class=bsTotals>' || SUM((b.gross_sold - b.promo_allowance)) || '</b>'";
	lsQuery += "FROM gc_guest_checks_change a INNER JOIN gc_guest_checks b ON (a.store_id=b.store_id and a.date_id=b.date_id and a.gc_sequence=b.gc_sequence)";
    lsQuery += "WHERE a.destination='2' AND b.destination='3' AND a.date_id IN ";
        lsQuery += "(SELECT date_id FROM ss_cat_time WHERE year_no="+msYear+" ";
        
        if(!msPeriod.equals("0"))
            lsQuery += " AND period_no="+msPeriod +" ";

        if(!msWeek.equals("0"))
            lsQuery += " AND week_no="+msWeek+" ";

        if(!msDay.equals("0"))
            lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

        lsQuery += ") ORDER BY date_id DESC, gc_sequence";
        //lsQuery += ") GROUP BY a.date_id, a.gc_sequence ORDER BY date_id DESC, gc_sequence";

        return moAbcUtils.getJSResultSet(lsQuery);
    }

%>
