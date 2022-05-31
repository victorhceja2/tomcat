<%!
    String getDataset(String recu, String frec, String sDate, String sBase, String spack, String sAgeb, String sStreet){
        String lsQuery;
		String pbase = "";
		String ppack = "";
		String pageb = "";
		String pStreet = "";
		String pTabTemp = "";

		if(sBase.equals("ALL")){
			pbase = "";
		}
		else{
			pbase = "and B.baseno IN ('" + sBase + "')";
		}

		if(spack.equals("ALL")){
			ppack = "";
		}
		else{
			ppack = "and I.pruleno = '" + spack + "'";
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
			pTabTemp = " INTO TEMP tb_potrep ";
			pStreet = " select name, address_com, section, client, fecha, total, frecuency, coupon, seq, street from tb_potrep where street = '" + sStreet + "'";
		}
		

		lsQuery = "Select CLI.NAME,";
		lsQuery += " CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC,'DD-Mon-YYYY') as fecha, CLI.TOTAL, CLI.FRECUENCY, CLI.COUPON ";
		lsQuery += ", CLI.SEQ, CLI.STREET " + pTabTemp;
		lsQuery += " FROM (select P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section ";
      	lsQuery += ", case WHEN W.promo_allowance <> '0.00' THEN ";
		lsQuery += " (select coupon_code from gc_items g inner join gc_coupons c on g.store_id = c.store_id and g.date_id = c.date_id and ";
		lsQuery += " g.gc_sequence = c.gc_sequence and g.it_seq = c.it_seq and g.date_id = P.fec and g.gc_sequence = P.seq inner join gc_coupon_codes cc on ";
		lsQuery += " c.coupon_id = cc.coupon_id limit 1) ";
		lsQuery += " WHEN W.promo_allowance = '0.00' THEN ' '";
		lsQuery += " end as coupon, P.street ";
		lsQuery += " from gc_guest_checks W "; 
	    lsQuery += " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq,"; 
		lsQuery += " X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + pageb + ") ";
		lsQuery += " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
		lsQuery += " inner join gc_items I on X.store_id = I.store_id and X.date_id = I.date_id and X.gc_sequence = I.gc_sequence " + ppack + " inner ";
		lsQuery += " join sus_menu_items MI on I.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " + pbase;
		lsQuery += " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " order by U.client) P ";
      	lsQuery += " on W.store_id = P.store_id and "; 
        lsQuery += " W.date_id = P.fec and "; 
		lsQuery += " W.gc_sequence = P.seq and "; 
		lsQuery += " P.fec > '" + sDate + "' and "; 
		lsQuery += " P.fec < (current_date - " + recu + ")) CLI ";
		lsQuery += " LEFT OUTER JOIN (select P.client ";
		lsQuery += " from gc_guest_checks W "; 
		lsQuery += " inner join (select U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.client, MAX(D.date_id) as fec ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + pageb + ") ";
		lsQuery += " GROUP BY C.client) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
		lsQuery += " group by U.client, U.fec, X.store_id ";
		lsQuery += " order by U.client) P ";
		lsQuery += " on W.store_id = P.store_id and "; 
		lsQuery += " W.date_id = P.fec and ";
		lsQuery += " W.gc_sequence = P.seq and ";
		lsQuery += " P.fec > (current_date - " + recu + ")) PAS ";
		lsQuery += " ON CLI.CLIENT = PAS.CLIENT ";
		lsQuery += " ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT";
		
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

	void droptbtemp(){
		String lsQuery = "drop table tb_potrep";
		moAbcUtils.executeSQLCommand(lsQuery);
	}
	
	String getRescli(String rec, String frec, String date1, String sBase, String sPack, String sAgeb, String sStreet){

		String pbase = "";
		String ppack = "";
		String pageb = "";
		String pStreet = "";
	
		if(sBase.equals("ALL")){
			pbase = "";
		}
		else{
			pbase = "and B.baseno IN ('" + sBase + "')";
		}
		if(sPack.equals("ALL")){
			ppack = "";
		}
		else{
			ppack = "and I.pruleno = '" + sPack + "'";
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
						 " ON (C.store_id = D.store_id and C.client = D.client and C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and" +
						 " C.section <> 'UNK' and C.street <> 'UNK'" + pageb + ")" +  
						 " GROUP BY C.client) U on X.date_id = U.fec and X.client = U.client" +
						 " inner join gc_items I on X.store_id = I.store_id and X.date_id = I.date_id and X.gc_sequence = I.gc_sequence " + ppack + " inner" +
						 " join sus_menu_items MI on I.menu_item = MI.menu_item inner join sus_base_codes B on MI.baseno = B.baseno and B.baseno <> '001' " + 
						 pbase +
						 " group by U.client, U.fec," +
						 " X.store_id) P on W.store_id = P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq" +
						 " and P.fec > '" + date1 + "' and P.fec < (current_date - " + rec + ")) CLI" +  
						 " LEFT OUTER JOIN (select P.client from gc_guest_checks W inner join (select U.client, U.fec," +
						 " MAX(X.gc_sequence) as seq, X.store_id from gc_delivery X inner join (select C.client," +
						 " MAX(D.date_id) as fec from sus_clients C JOIN gc_delivery D ON (C.store_id = D.store_id" +
						 " and C.client = D.client and C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and" +
						 " C.section <> 'UNK' and C.street <> 'UNK'" + pageb + ")" +
						 " GROUP BY C.client) U on X.date_id" +
						 " = U.fec and X.client = U.client group by U.client, U.fec, X.store_id) P on W.store_id =" +
						 " P.store_id and W.date_id = P.fec and W.gc_sequence = P.seq and P.fec" +
						 " > (current_date - " + rec + ")) PAS ON CLI.CLIENT = PAS.CLIENT";

		if(sStreet.equals("ALL")){
			return moAbcUtils.queryToString(lsQuery);	
		}
		else{
			pStreet = "select count(*) from tb_potrep where street = '" + sStreet + "'";
			return moAbcUtils.queryToString(pStreet); 
		}
	}
%>
