<%!
    String getDataset(String frec, String sDate, String sDateH, String sbase, String spack, String sAgeb, String sStreet){
        String lsQuery;
		String pbase = "";
		String ppack = "";
		String pageb = "";
		String pStreet = "";
		String pTabTemp = "";
						

	if(sbase.equals("ALL")){
		pbase = "";
	}
	else{
		pbase = "and B.baseno IN ('" + sbase + "')";
	}

	if(spack.equals("ALL")){
		ppack = "";
	}
	else{
		ppack = "and po.pruleno = '" + spack + "'";
	}

	if(sAgeb.equals("0")){
		pageb = "";
	}
	else{
		pageb = " and C.section = '" + sAgeb + "'";
	}
	
	if(sStreet.equals("ALL")){
		pStreet = "";
	}
	else{
		pTabTemp = " INTO TEMP tb_frecrep ";
		pStreet = " select name, address_com, section, client, fecha, total, frecuency, coupon, seq, street from tb_frecrep where street = '" + sStreet + "'";
	}

		lsQuery = "SELECT CLI.NAME, CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC, 'DD-Mon-YYYY') as fecha, CLI.TOTAL, CLI.FRECUENCY, CLI.coupon " +
				  " ,CLI.SEQ, CLI.STREET" + pTabTemp +
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
				  " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + pageb + " ) " +
				  " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U on X.date_id = U.fec and X.client = U.client" +
				  " inner join gc_items po on X.store_id = po.store_id and X.date_id = po.date_id and X.gc_sequence = po.gc_sequence " +
				  ppack +
				  " inner join sus_menu_items MI on po.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " +
				  pbase +
				  " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street order by U.client) P" +
				  " on W.store_id = P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq and" +
				  " P.fec >= '" + sDate + "' and P.fec <= '" + sDateH + "') CLI ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT";


		if(sStreet.equals("ALL")){
			return moAbcUtils.getJSResultSet(lsQuery);
		}
		else{
			moAbcUtils.executeSQLCommand(lsQuery);
			return moAbcUtils.getJSResultSet(pStreet);
		}
    }

	String getClients(){
		String lsQuery = "Select count(*) from sus_clients";
		return moAbcUtils.queryToString(lsQuery);
	}

	void droptbfrectemp(){
		String lsQuery = "drop table tb_frecrep";
		moAbcUtils.executeSQLCommand(lsQuery);
	}

	String getRescli(String frec, String date1, String date2, String sbase, String spack, String sAgeb, String sStreet){
		String pbase = "";
		String ppack = "";
		String pageb = "";
		String pStreet = "";
		
		if(sbase.equals("ALL")){
			pbase = "";
		}
		else{
			pbase = "and B.baseno IN ('" + sbase + "')";
		}

		if(spack.equals("ALL")){
			ppack = "";
		}
		else{
			ppack = "and po.pruleno = '" + spack + "'";
		}

		if(sAgeb.equals("0")){
			pageb = "";
		}
		else{
			pageb = " and C.section = '" + sAgeb + "'";
		}
	
		String lsQuery = "Select COUNT(*) FROM (select P.client, P.fec, P.seq from gc_guest_checks W inner join (" + 
						 "select U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id from gc_delivery X" +
						 " inner join (select C.client, MAX(D.date_id) as fec from sus_clients C JOIN gc_delivery D" +  
						 " ON (C.store_id = D.store_id and C.client = D.client and C.frecuency " + frec + 
						 " and C.name <> 'UNK' and C.address_com <> 'UNK' and  C.section <> 'UNK' and C.street <> 'UNK'" + pageb + " ) " +  
						 " GROUP BY C.client) U on X.date_id = U.fec and X.client = U.client" +
						 " inner join gc_items po on X.store_id = po.store_id and X.date_id = po.date_id and X.gc_sequence = po.gc_sequence " +
						 ppack +
						 " inner join sus_menu_items MI on po.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " +
						 pbase +
						 " group by U.client, U.fec," +
						 " X.store_id) P on W.store_id = P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq" +
						 " and P.fec >= '" + date1 + "' and P.fec <= '" + date2 + "') CLI";  

		if(sStreet.equals("ALL")){ 
			return moAbcUtils.queryToString(lsQuery);
		}
		else{
			pStreet = "select count(*) from tb_frecrep where street = '" + sStreet + "'";
			return moAbcUtils.queryToString(pStreet);
		}
	}
%>
