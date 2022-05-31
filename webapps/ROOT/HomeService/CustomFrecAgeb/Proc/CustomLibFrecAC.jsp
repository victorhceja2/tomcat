<%!
    String getDataset(String frec, String sDate, String sDateH, String sAgeb){
        String lsQuery;
		String qryageb = "";

	if(sAgeb.equals("0")){
		qryageb = "";
	}
	else{
		qryageb = " and C.section = '" + sAgeb + "'";
	}

		lsQuery = "select fin.section, SUM(fin.clientes), replace('" + frec + "','>','m') as frec, '" + sDate + "' as fecini, '" +
				  sDateH + "' as fecfin, '" + sAgeb + "' as ageb from ( " +
				  "select def.street, def.section, count(*) as clientes, replace('" + frec + "','>','m') as frec, '" + sDate + "' as fecini, '" + 
				  sDateH + "' as fecfin, '" + sAgeb + "' as ageb from ( " +
				  "SELECT CLI.NAME, CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC, 'DD-Mon-YYYY'), CLI.TOTAL, CLI.FRECUENCY, CLI.coupon " +
				  " ,CLI.SEQ, CLI.STREET" +
				  " FROM (SELECT P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section" +
				  ", case WHEN W.promo_allowance <> '0.00' THEN " +
				  " (select coupon_code from gc_items g inner join gc_coupons c on g.store_id = c.store_id and g.date_id = c.date_id and" +
				  " g.gc_sequence = c.gc_sequence and g.it_seq = c.it_seq and g.date_id = P.fec and g.gc_sequence = P.seq inner join" +
				  " gc_coupon_codes cc on c.coupon_id = cc.coupon_id limit 1)" +
				  " WHEN W.promo_allowance = '0.00' THEN ' '" +
				  " end as coupon, P.street" +
				  " from gc_guest_checks W" +
				  " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id, U.frecuency, U.section, U.street" +
				  " from gc_delivery X inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street" +
				  " from sus_clients C JOIN gc_delivery D ON (C.store_id = D.store_id and C.client = D.client and C.frecuency " + frec + 
				  " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") " +
				  " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U on X.date_id = U.fec and X.client = U.client" +
				  " inner join gc_items po on X.store_id = po.store_id and X.date_id = po.date_id and X.gc_sequence = po.gc_sequence " +
				  " inner join sus_menu_items MI on po.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " +
				  " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street order by U.client) P" +
				  " on W.store_id = P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq and" +
				  " P.fec >= '" + sDate + "' and P.fec <= '" + sDateH + "') CLI ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT" + 
				  " ) def group by def.section, def.street order by clientes desc, def.section, def.street" +
				  " ) fin group by fin.section order by 2 desc";
				  
        return moAbcUtils.getJSResultSet(lsQuery);
    }

	String getClients(String frec, String date1, String date2, String sageb){
		String qryageb = "";
		String lsQuery = "";
		
		if(sageb.equals("0")){
			qryageb = "";
		}
		else{
			qryageb = " and C.section = '" + sageb + "'";
		}

		lsQuery = "select SUM(cta.clientes) from ( " +
				  " select def.street, def.section, count(*) as clientes, replace('" + frec + "','>','m') as frec, '" + date1 + "' as fecini, '" + 
				  date2 + "' as fecfin, '" + sageb + "' as ageb from ( " + 
				  "SELECT CLI.NAME, CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC, 'DD-Mon-YYYY'), CLI.TOTAL, CLI.FRECUENCY, CLI.coupon " +
				  " ,CLI.SEQ, CLI.STREET" +
				  " FROM (SELECT P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section" +
				  ", case WHEN W.promo_allowance <> '0.00' THEN " +
				  " (select coupon_code from gc_items g inner join gc_coupons c on g.store_id = c.store_id and g.date_id = c.date_id and" +
				  " g.gc_sequence = c.gc_sequence and g.it_seq = c.it_seq and g.date_id = P.fec and g.gc_sequence = P.seq inner join" +
				  " gc_coupon_codes cc on c.coupon_id = cc.coupon_id limit 1)" +
				  " WHEN W.promo_allowance = '0.00' THEN ' '" +
				  " end as coupon, P.street" +
				  " from gc_guest_checks W" +
				  " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id, U.frecuency, U.section, U.street" +
				  " from gc_delivery X inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street" +
				  " from sus_clients C JOIN gc_delivery D ON (C.store_id = D.store_id and C.client = D.client and C.frecuency " + frec + 
				  " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") " +
				  " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U on X.date_id = U.fec and X.client = U.client" +
				  " inner join gc_items po on X.store_id = po.store_id and X.date_id = po.date_id and X.gc_sequence = po.gc_sequence " +
				  " inner join sus_menu_items MI on po.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " +
				  " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street order by U.client) P" +
				  " on W.store_id = P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq and" +
				  " P.fec >= '" + date1 + "' and P.fec <= '" + date2 + "') CLI ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT" + 
				  " ) def group by def.section, def.street order by clientes desc, def.section, def.street" + 
				  " ) cta";

		return moAbcUtils.queryToString(lsQuery);

	}

	String getRescli(String frec, String date1, String date2, String sageb){
		String qryageb = "";
		String lsQuery = "";
		
		if(sageb.equals("0")){
			qryageb = "";
		}
		else{
			qryageb = " and C.section = '" + sageb + "'";
		}

		lsQuery = "select count(*) from ( select fin.section, SUM(fin.clientes) from (" +
				  " select def.street, def.section, count(*) as clientes, replace('" + frec + "','>','m') as frec, '" + date1 + "' as fecini, '" + 
				  date2 + "' as fecfin, '" + sageb + "' as ageb from ( " + 
				  "SELECT CLI.NAME, CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC, 'DD-Mon-YYYY'), CLI.TOTAL, CLI.FRECUENCY, CLI.coupon " +
				  " ,CLI.SEQ, CLI.STREET" +
				  " FROM (SELECT P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section" +
				  ", case WHEN W.promo_allowance <> '0.00' THEN " +
				  " (select coupon_code from gc_items g inner join gc_coupons c on g.store_id = c.store_id and g.date_id = c.date_id and" +
				  " g.gc_sequence = c.gc_sequence and g.it_seq = c.it_seq and g.date_id = P.fec and g.gc_sequence = P.seq inner join" +
				  " gc_coupon_codes cc on c.coupon_id = cc.coupon_id limit 1)" +
				  " WHEN W.promo_allowance = '0.00' THEN ' '" +
				  " end as coupon, P.street" +
				  " from gc_guest_checks W" +
				  " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id, U.frecuency, U.section, U.street" +
				  " from gc_delivery X inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street" +
				  " from sus_clients C JOIN gc_delivery D ON (C.store_id = D.store_id and C.client = D.client and C.frecuency " + frec + 
				  " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") " +
				  " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U on X.date_id = U.fec and X.client = U.client" +
				  " inner join gc_items po on X.store_id = po.store_id and X.date_id = po.date_id and X.gc_sequence = po.gc_sequence " +
				  " inner join sus_menu_items MI on po.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " +
				  " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street order by U.client) P" +
				  " on W.store_id = P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq and" +
				  " P.fec >= '" + date1 + "' and P.fec <= '" + date2 + "') CLI ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT" + 
				  " ) def group by def.section, def.street order by clientes desc, def.section, def.street ) fin group by fin.section" + 
				  " ) cta";

		return moAbcUtils.queryToString(lsQuery);
	}
%>
