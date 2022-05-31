<%!
    String getDataset(String recu, String frec, String sDate, String sAgeb){
        String lsQuery;
		String qryageb = "";

		if(sAgeb.equals("0")){
			qryageb = "";
		}
		else{
			qryageb = " and C.section = '" + sAgeb+ "'";
		}

		lsQuery =  "select fin.section, SUM(fin.clientes), replace('" + frec + "','>','m') as frec, '" + sDate + "' as fec, '" + recu + "' as recur, '";
		lsQuery += sAgeb + "' as ageb from(";
		lsQuery += "select def.street, def.section, count(*) as clientes, replace('" + frec + "','>','m') as frec, '" + sDate + "' as fec, '" + recu + "' as recur, '";
		lsQuery += sAgeb + "' as ageb";
		lsQuery += " from ( ";
		lsQuery += "Select CLI.NAME,";
		lsQuery += " CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC,'DD-Mon-YYYY'), CLI.TOTAL, CLI.FRECUENCY, ";
		lsQuery += " CLI.SEQ, CLI.STREET";
		lsQuery += " FROM (select P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section, P.street ";
		lsQuery += " from gc_guest_checks W "; 
	    lsQuery += " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq,"; 
		lsQuery += " X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") ";
		lsQuery += " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
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
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") ";
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
		lsQuery += " ) def group by def.section, def.street order by clientes desc, def.section, def.street";
		lsQuery += " ) fin group by fin.section order by 2 desc";

        return moAbcUtils.getJSResultSet(lsQuery);
    }

	String getClients(String rec, String frec, String date1, String ageb){
		String qryageb = "";
		String lsQuery = "";
		if(ageb.equals("0")){
			qryageb = "";
		}
		else{
			qryageb = " and C.section = '" + ageb+ "'";
		}
		
		lsQuery = "select SUM(cta.clientes) from ( ";
		lsQuery += "select def.street, def.section, count(*) as clientes from ( ";
		lsQuery += "Select CLI.NAME,";
		lsQuery += " CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC,'DD-Mon-YYYY'), CLI.TOTAL, CLI.FRECUENCY, ";
		lsQuery += " CLI.SEQ, CLI.STREET";
		lsQuery += " FROM (select P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section, P.street ";
		lsQuery += " from gc_guest_checks W "; 
	    lsQuery += " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq,"; 
		lsQuery += " X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") ";
		lsQuery += " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
		lsQuery += " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " order by U.client) P ";
      	lsQuery += " on W.store_id = P.store_id and "; 
        lsQuery += " W.date_id = P.fec and "; 
		lsQuery += " W.gc_sequence = P.seq and "; 
		lsQuery += " P.fec > '" + date1 + "' and "; 
		lsQuery += " P.fec < (current_date - " + rec + ")) CLI ";
		lsQuery += " LEFT OUTER JOIN (select P.client ";
		lsQuery += " from gc_guest_checks W "; 
		lsQuery += " inner join (select U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.client, MAX(D.date_id) as fec ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") ";
		lsQuery += " GROUP BY C.client) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
		lsQuery += " group by U.client, U.fec, X.store_id ";
		lsQuery += " order by U.client) P ";
		lsQuery += " on W.store_id = P.store_id and "; 
		lsQuery += " W.date_id = P.fec and ";
		lsQuery += " W.gc_sequence = P.seq and ";
		lsQuery += " P.fec > (current_date - " + rec + ")) PAS ";
		lsQuery += " ON CLI.CLIENT = PAS.CLIENT ";
		lsQuery += " ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT";
		lsQuery += " ) def group by def.section, def.street order by def.section, def.street";
		lsQuery += " ) cta";

		return moAbcUtils.queryToString(lsQuery);
	}

	String getRescli(String rec, String frec, String date1, String ageb){
		String qryageb = "";
		String lsQuery = "";
		if(ageb.equals("0")){
			qryageb = "";
		}
		else{
			qryageb = " and C.section = '" + ageb+ "'";
		}

		lsQuery = "select count(*) from ( ";
		lsQuery += " select fin.section, SUM(fin.clientes) from (";
		lsQuery += " select def.street, def.section, count(*) as clientes from ( ";
		lsQuery += " Select CLI.NAME,";
		lsQuery += " CLI.ADDRESS_COM, CLI.SECTION, CLI.CLIENT, to_char(CLI.FEC,'DD-Mon-YYYY'), CLI.TOTAL, CLI.FRECUENCY, ";
		lsQuery += " CLI.SEQ, CLI.STREET";
		lsQuery += " FROM (select P.name, P.address_com, P.client, P.fec, (W.gross_sold - W.promo_allowance) as total, P.frecuency, P.seq, P.section, P.street ";
		lsQuery += " from gc_guest_checks W "; 
	    lsQuery += " inner join (select U.name, U.address_com, U.client, U.fec, MAX(X.gc_sequence) as seq,"; 
		lsQuery += " X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.name, C.client, C.address_com, MAX(D.date_id) as fec, C.frecuency, C.section, C.street ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") ";
		lsQuery += " GROUP BY C.client, C.name, C.address_com, C.frecuency, C.section, C.street) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
		lsQuery += " group by U.name, U.address_com, U.client, U.fec, X.store_id, U.frecuency, U.section, U.street ";
		lsQuery += " order by U.client) P ";
      	lsQuery += " on W.store_id = P.store_id and "; 
        lsQuery += " W.date_id = P.fec and "; 
		lsQuery += " W.gc_sequence = P.seq and "; 
		lsQuery += " P.fec > '" + date1 + "' and "; 
		lsQuery += " P.fec < (current_date - " + rec + ")) CLI ";
		lsQuery += " LEFT OUTER JOIN (select P.client ";
		lsQuery += " from gc_guest_checks W "; 
		lsQuery += " inner join (select U.client, U.fec, MAX(X.gc_sequence) as seq, X.store_id ";
		lsQuery += " from gc_delivery X ";
		lsQuery += " inner join (select C.client, MAX(D.date_id) as fec ";
		lsQuery += " from sus_clients C "; 
		lsQuery += " JOIN gc_delivery D ";  
		lsQuery += " ON (C.store_id = D.store_id and "; 
		lsQuery += " C.client = D.client and ";
		lsQuery += " C.frecuency " + frec + " and C.name <> 'UNK' and C.address_com <> 'UNK' and C.section <> 'UNK' and C.street <> 'UNK'" + qryageb + ") ";
		lsQuery += " GROUP BY C.client) U "; 
		lsQuery += " on X.date_id = U.fec and "; 
		lsQuery += " X.client = U.client ";
		lsQuery += " group by U.client, U.fec, X.store_id ";
		lsQuery += " order by U.client) P ";
		lsQuery += " on W.store_id = P.store_id and "; 
		lsQuery += " W.date_id = P.fec and ";
		lsQuery += " W.gc_sequence = P.seq and ";
		lsQuery += " P.fec > (current_date - " + rec + ")) PAS ";
		lsQuery += " ON CLI.CLIENT = PAS.CLIENT ";
		lsQuery += " ORDER BY CLI.FEC DESC, CLI.NAME, CLI.CLIENT";
		lsQuery += " ) def group by def.section, def.street order by def.section, def.street";
		lsQuery += " ) fin group by fin.section";
		lsQuery += " ) cta";

		return moAbcUtils.queryToString(lsQuery);
	}
%>
