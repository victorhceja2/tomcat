<%@page import="java.io.FileWriter"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/Include/CommonLibYum.jsp"%>

<%!boolean gbFlgErr;
	File gfErrors = new File("/usr/local/tomcat/webapps/ROOT/Scripts/final_inv_error.txt");
	//File gfErrors = new File("/tmp/final_inv_error.txt");
	/**
	    Devuelve el anio actual. Informacion del invcaldr.txt
	 */
	String getInvYear() {
		return "20" + Inventory.getCurrentYear();
	}

	/**
	    Devuelve el periodo actual. Informacion del invcaldr.txt
	 */
	String getInvPeriod() {
		return Inventory.getCurrentPeriod();
	}

	/**
	    Devuelve la semana actual. Informacion del invcaldr.txt
	 */
	String getInvWeek() {
		return Inventory.getCurrentWeek();
	}

	/**
	    Llena la tabla op_inv_conversion_factor. Los productos que tengan
	    factores de conversion duplicados se eleminan 
	 */

	void loadConversionFactors() {
		String lsQry;

		//Se borran valores originales
		lsQry = "DELETE FROM op_inv_conversion_factor";
		moAbcUtils.executeSQLCommand(lsQry, new String[] {});

		//Se insertan nuevos factores de conversion
		lsQry = "INSERT INTO op_inv_conversion_factor SELECT DISTINCT b.inv_id, "
				+ "i.rcp_conversion_factor, p.conversion_factor, "
				+ "lower(substr(pum.unit_name,0,5)) AS prov_unit_measure, "
				+ "lower(substr(ium.unit_name,0,5)) AS inv_unit_measure FROM "
				+ "op_inv_inventory_begin b "
				+ "INNER JOIN op_grl_cat_providers_product p ON (b.inv_id=p.inv_id) "
				+ "INNER JOIN op_grl_cat_inventory i ON (p.inv_id = i.inv_id) "
				+ "INNER JOIN op_grl_cat_unit_measure pum ON (p.provider_unit_measure = pum.unit_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) ";

		moAbcUtils.executeSQLCommand(lsQry, new String[] {});

		//Se ponen en 0 los factores de conversion de proveedor repetidos
		lsQry = "UPDATE op_inv_conversion_factor SET prv_conversion_factor=0, "
				+ "prv_unit_measure='NA' WHERE "
				+ "inv_id IN (SELECT inv_id FROM op_inv_conversion_factor  GROUP BY inv_id "
				+ "HAVING COUNT(prv_conversion_factor) > 1)";
		moAbcUtils.executeSQLCommand(lsQry, new String[] {});

		// Se agrego esta solucion fast & dirty solicitud de JJ
		String lsQryUpd = "UPDATE op_inv_step_inventory_detail SET prv_conversion_factor = 0 "
				+ "WHERE inv_id in (SELECT inv_id FROM op_grl_prv_end_block) ";
		moAbcUtils.executeSQLCommand(lsQryUpd);

		//Se actualizan los factores de conversion
		String lsQryUp = "UPDATE op_inv_step_inventory_detail SET prv_conversion_factor = "
				+ "cf.prv_conversion_factor, rcp_conversion_factor=cf.rcp_conversion_factor, "
				+ "prv_unit_measure = cf.prv_unit_measure, "
				+ "inv_unit_measure = cf.inv_unit_measure "
				+ "FROM op_inv_conversion_factor cf WHERE "
				+ " cf.inv_id = op_inv_step_inventory_detail.inv_id ";

		moAbcUtils.executeSQLCommand(lsQryUp);
	}

	/*
	 *  EZ: tunning
	 *  Solo en caso de de se requiera se invocara a este metodo.
	 *
	 *  Llena la tabla op_inv_inventory_begin con los valores del inventario
	 *  inicial. Los valores que se ingresan se leen del archivo invtran.
	 */
	void loadInventoryBegin(String psYear, String psPeriod, String psWeek) {
		Inventory loInventory;
		LinkedHashMap loHashmap;
		ArrayList loValues;
		ArrayList loKeys;
		Double loQuantity;
		Iterator iterator;
		String lsQry, lsInvId, lsQuantity, lsRes;
		int numItems = 0;

		try {
			/* Siempre se borran los valores existentes y se calculan los nuevos */

			lsQry = "SELECT COUNT(*) FROM op_inv_flag WHERE year_no= " + psYear
					+ " AND period_no=" + psPeriod + " AND week_no=" + psWeek;
			lsRes = moAbcUtils.queryToString(lsQry);

			if (lsRes != null && Integer.parseInt(lsRes) < 1) {
				String lsQryI = "INSERT INTO op_inv_flag VALUES (" + psYear + ","
						+ psPeriod + "," + psWeek + ",0)";
				moAbcUtils.executeSQLCommand(lsQryI);
			}

			lsQry = "DELETE FROM op_inv_inventory_begin";
			moAbcUtils.executeSQLCommand(lsQry, new String[] {});
			
			lsQry = "INSERT INTO op_inv_exceptions "
					+ "SELECT inv_id, family_id, 70, 100, 0.003 "
					+ "FROM op_grl_cat_inventory "
					+ "WHERE inv_id NOT IN (SELECT inv_id FROM op_inv_exceptions)";
			moAbcUtils.executeSQLCommand(lsQry);

			lsQry = "INSERT INTO op_inv_inventory_begin(inv_id, inv_beg, week_no) VALUES(?,?,?)";

			//Objecto que manipula el archivo de inventario (invtran)
			loInventory = new Inventory(psYear.substring(2), Str.padZero(
					psPeriod, 2), psWeek);

			loHashmap = loInventory.getInventoryBegin();
			iterator = loHashmap.keySet().iterator();
			loValues = new ArrayList(loHashmap.size());
			loKeys = new ArrayList();

			logApps.writeInfo("Items: " + loHashmap.size());

			int liCounter = 0;

			while (iterator.hasNext()) {
				lsInvId = (String) iterator.next();
				loQuantity = (Double) loHashmap.get(lsInvId);

				liCounter++;

				if (loQuantity.doubleValue() >= 0) {
					lsQuantity = Str.getFormatted("%.2f",
							loQuantity.doubleValue());

					if (loKeys.contains(lsInvId)) {
						logApps.writeInfo("duplicado: " + lsInvId + " begin: "
								+ lsQuantity);
						continue;
					} else {
						loKeys.add(lsInvId);
						loValues.add(new String[] { lsInvId, lsQuantity, psWeek });
					}
				}
			}

			logApps.writeInfo("Counter: " + liCounter);

			moAbcUtils.executeSQLCommand(lsQry, loValues);
		}//Fin try
		catch (Exception e) {
			logApps.writeInfo("Exception loadInventoryBegin() ... "
					+ e.toString());
		}

	}

	/*
	    Se actualizan valores de costo y uso ideal.
	    Los valores que se ingresan se leen del archivo invtran.
	 */
	void loadUsageAndCost(String psYear, String psPeriod, String psWeek) {
		Inventory loInventory;
		LinkedHashMap loHashmap;
		ArrayList loValues;
		Iterator iterator;
		String lsQry, lsInvId, lsUsage, lsCost, lsCode;
		SimpleRecord loSimpleRecord;
		String lsMisc;

		loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod,
				2), psWeek);

		loHashmap = loInventory.getSimpleRecords();
		iterator = loHashmap.keySet().iterator();
		loValues = new ArrayList(loHashmap.size());

		lsQry = "UPDATE op_inv_step_inventory_detail SET ideal_use=?, unit_cost=?, misc=? WHERE inv_id=?";

		while (iterator.hasNext()) {
			lsInvId = (String) iterator.next();
			loSimpleRecord = (SimpleRecord) loHashmap.get(lsInvId);

			if (loSimpleRecord.getUsage() >= 0 && loSimpleRecord.getCost() >= 0) {
				lsUsage = Str.getFormatted("%.2f", loSimpleRecord.getUsage());
				lsCost = Str.getFormatted("%.2f", loSimpleRecord.getCost());
				lsCode = loSimpleRecord.getCode().trim();

				if (lsCode.length() == 0)
					lsMisc = "true";
				else
					lsMisc = "false";

				loValues.add(new String[] { lsUsage, lsCost, lsMisc, lsInvId });
			}
		}

		moAbcUtils.executeSQLCommand(lsQry, loValues);

		loadUsageAndCostInv(psYear, psPeriod, psWeek);
		//Pone uso ideal igual a uso real para miscelaneos
		lsQry = "SELECT update_ideal_use('op_inv_step_inventory_detail')";
		moAbcUtils.queryToString(lsQry);
	}
	
	void loadUsageAndCostInv(String psYear, String psPeriod, String psWeek){
		logApps.writeInfo("Cargando usos ideales en inventario...");
		Inventory loInventory;
		LinkedHashMap loHashmap;
		ArrayList loValues;
		Iterator iterator;
		String lsQry, lsInvId, lsUsage, lsCost, lsCode;
		SimpleRecord loSimpleRecord;
		String lsMisc;

		loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod,
				2), psWeek);

		loHashmap = loInventory.getSimpleRecords();
		iterator = loHashmap.keySet().iterator();
		loValues = new ArrayList(loHashmap.size());

		lsQry = "UPDATE op_inv_inventory_detail SET ideal_use=?, unit_cost=?, misc=? WHERE inv_id=?";

		while (iterator.hasNext()) {
			lsInvId = (String) iterator.next();
			loSimpleRecord = (SimpleRecord) loHashmap.get(lsInvId);

			if (loSimpleRecord.getUsage() >= 0 && loSimpleRecord.getCost() >= 0) {
				lsUsage = Str.getFormatted("%.2f", loSimpleRecord.getUsage());
				lsCost = Str.getFormatted("%.2f", loSimpleRecord.getCost());
				lsCode = loSimpleRecord.getCode().trim();

				if (lsCode.length() == 0)
					lsMisc = "true";
				else
					lsMisc = "false";

				loValues.add(new String[] { lsUsage, lsCost, lsMisc, lsInvId });
			}
		}

		moAbcUtils.executeSQLCommand(lsQry, loValues);
	}
	
	/**
	** Funcion que actualiza uso ideal y costos de tabla first
	*/
	void loadUsageAndCostFirst(String psYear, String psPeriod, String psWeek) {
		Inventory loInventory;
		LinkedHashMap loHashmap;
		ArrayList loValues;
		Iterator iterator;
		String lsQry, lsInvId, lsUsage, lsCost, lsCode;
		SimpleRecord loSimpleRecord;
		String lsMisc;
		
		logApps.writeInfo("Se actualizara el uso ideal y el costo de la tabla op_inv_first_inventory_detail");
		loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod,
				2), psWeek);

		loHashmap = loInventory.getSimpleRecords();
		iterator = loHashmap.keySet().iterator();
		loValues = new ArrayList(loHashmap.size());

		lsQry = "UPDATE op_inv_first_inventory_detail SET ideal_use=?, unit_cost=?, misc=? WHERE inv_id=?";

		while (iterator.hasNext()) {
			lsInvId = (String) iterator.next();
			loSimpleRecord = (SimpleRecord) loHashmap.get(lsInvId);

			if (loSimpleRecord.getUsage() >= 0 && loSimpleRecord.getCost() >= 0) {
				lsUsage = Str.getFormatted("%.2f", loSimpleRecord.getUsage());
				lsCost = Str.getFormatted("%.2f", loSimpleRecord.getCost());
				lsCode = loSimpleRecord.getCode().trim();

				if (lsCode.length() == 0)
					lsMisc = "true";
				else
					lsMisc = "false";

				loValues.add(new String[] { lsUsage, lsCost, lsMisc, lsInvId });
			}
		}

		moAbcUtils.executeSQLCommand(lsQry, loValues);

		//Pone uso ideal igual a uso real para miscelaneos
		lsQry = "SELECT update_ideal_use('op_inv_step_inventory_detail')";
		moAbcUtils.queryToString(lsQry);
	}
	
	void loadTransfersFirst(String psYear, String psPeriod, String psWeek){
		logApps.writeInfo("Actualizando movimientos para " + psYear + "/"+psPeriod + "/" + psWeek);
		String[] laMovs={"receptions", "itransfers", "otransfers"};
		
		for (String lsMov : laMovs){
			String lsQry = "SELECT add_" + lsMov + "_inv(" + psYear + ", " + psPeriod + "," + psWeek + ")";
			moAbcUtils.queryToString(lsQry);
		}
		
		String lsUpdTransIn = "UPDATE op_inv_first_inventory_detail fid "
				+ "SET itransfers=inv.itransfers "
				+ "FROM op_inv_inventory_detail inv "
				+ "WHERE inv.year_no= " + psYear
				+ "AND inv.period_no= " + psPeriod
				+ "AND inv.week_no= " + psWeek
				+ "AND fid.inv_id=inv.inv_id "
				+ "AND inv.year_no=fid.year_no "
				+ "AND inv.period_no=fid.period_no "
				+ "AND inv.week_no=fid.week_no";
		moAbcUtils.executeSQLCommand(lsUpdTransIn);
		
		String lsUpdTransOut = "UPDATE op_inv_first_inventory_detail fid "
				+ "SET otransfers=inv.otransfers "
				+ "FROM op_inv_inventory_detail inv "
				+ "WHERE inv.year_no= " + psYear
				+ "AND inv.period_no= " + psPeriod
				+ "AND inv.week_no= " + psWeek
				+ "AND fid.inv_id=inv.inv_id "
				+ "AND inv.year_no=fid.year_no "
				+ "AND inv.period_no=fid.period_no "
				+ "AND inv.week_no=fid.week_no";
		moAbcUtils.executeSQLCommand(lsUpdTransOut);
		
		String lsUpdRecep = "UPDATE op_inv_first_inventory_detail fid "
				+ "SET receptions=inv.receptions "
				+ "FROM op_inv_inventory_detail inv "
				+ "WHERE inv.year_no= " + psYear
				+ "AND inv.period_no= " + psPeriod
				+ "AND inv.week_no= " + psWeek
				+ "AND fid.inv_id=inv.inv_id "
				+ "AND inv.year_no=fid.year_no "
				+ "AND inv.period_no=fid.period_no "
				+ "AND inv.week_no=fid.week_no";
		moAbcUtils.executeSQLCommand(lsUpdRecep);
	}

	/**
	    Metodo que calcula las recepciones y las transferencias de entrada/salida 
	 */
	void loadInventoryMov(String psYear, String psPeriod, String psWeek) {
		String lsQry, lsBeginDate, lsWeekNo, lsYear, lsMonth, lsDay;

		lsWeekNo = getWeekNo(psYear, psPeriod, psWeek);

		lsQry = "DELETE FROM op_inv_inventory_mov";
		moAbcUtils.executeSQLCommand(lsQry, new String[] {});

		lsQry = "INSERT INTO op_inv_inventory_mov " + "SELECT p.inv_id, rd.provider_product_code, "
				+ "SUM(rd.received_quantity*p.conversion_factor) AS receptions,  "
				+ "0 AS itransfers, 0 AS otransfers FROM  op_grl_reception_detail rd "
				+ "INNER JOIN op_grl_reception r " + "ON (r.reception_id = rd.reception_id) "
				+ "INNER JOIN op_grl_cat_providers_product p ON "
				+ "( p.provider_product_code = rd.provider_product_code AND p.provider_id = rd.provider_id) "
				+ "WHERE date_trunc('day',date_id) IN ( " + "SELECT date_trunc('day',date_id) FROM ss_cat_time WHERE "
				+ "year_no=" + psYear + " AND period_no=" + psPeriod + " AND week_no=" + lsWeekNo + "  ) "
				+ "GROUP BY p.inv_id, rd.provider_product_code " +

				"UNION " +

				"select td.inv_id, td.provider_product_code, 0 AS reception, "
				+ "SUM(td.provider_quantity * td.prv_conversion_factor + td.inventory_quantity) AS itransfers, "
				+ "0 AS otransfers FROM  op_grl_transfer_detail td " + "INNER JOIN op_grl_transfer t "
				+ "ON (t.transfer_id = td.transfer_id) WHERE t.transfer_type=1 AND " + "date_trunc('day',t.date_id) "
				+ "IN(SELECT date_trunc('day',date_id) FROM ss_cat_time WHERE " + "year_no=" + psYear
				+ " AND period_no=" + psPeriod + " AND week_no=" + lsWeekNo + "  ) "
				+ "GROUP BY td.inv_id, td.provider_product_code " +

				"UNION " +

				"select td.inv_id, td.provider_product_code, 0 AS reception, 0 AS itransfers ,"
				+ "SUM(td.provider_quantity * td.prv_conversion_factor + td.inventory_quantity) AS "
				+ "otransfers FROM  op_grl_transfer_detail td " + "INNER JOIN op_grl_transfer t "
				+ "ON (t.transfer_id = td.transfer_id) WHERE t.transfer_type=0 AND  "
				+ "date_trunc('day',t.date_id) IN(SELECT date_trunc('day',date_id) " + "FROM ss_cat_time WHERE "
				+ "year_no=" + psYear + " AND period_no=" + psPeriod + " AND week_no=" + lsWeekNo + "  ) "
				+ "GROUP BY td.inv_id, td.provider_product_code ";

		moAbcUtils.executeSQLCommand(lsQry, new String[] {});
	}

	/**
	    EZ: tunning
	    Reimplementacion del metodo initInventory()
	    Se carga en tabla de paso lo que este en tabla de inventario
	    directamente.
	 */

	void initInventory(String psYear, String psPeriod, String psWeek) {
		//DEBUG
		logApps.writeInfo("initInventory() ... ");
		boolean lbFirst = false;
		boolean lbTable = false;
		String lsQry, lsTable;
		lsTable = "";

		// Se cargan los valores del inventario inicial del archivo invtran.
		// Se utilizan estos datos para determinar que productos son activos.
		loadInventoryBegin(psYear, psPeriod, psWeek);
		
		loadTransfersFirst(psYear, psPeriod, psWeek);

		lsQry = "DELETE FROM op_inv_step_inventory_detail";
		moAbcUtils.executeSQLCommand(lsQry);

		// EZ fix:
		//  ya no se toma la tabla op_inv_inventory_begin para hacer este DELETE

		/*
		    lsQry = "DELETE FROM op_inv_inventory_detail WHERE " +
		            "year_no=? AND period_no=? AND week_no=? AND inv_id NOT IN " +
		            "(SELECT DISTINCT(inv_id) FROM op_inv_inventory_begin)"; */

		//Borra productos que ya no son validos
		lsQry = "DELETE FROM op_inv_inventory_detail WHERE "
				+ "year_no=? AND period_no=? AND week_no=? AND inv_id NOT IN "
				+ "(SELECT DISTINCT(inv_id) FROM op_grl_cat_providers_product " + "WHERE active_flag IN(1,2))";
		moAbcUtils.executeSQLCommand(lsQry, new String[] { psYear, psPeriod, psWeek });

		//Deja solo los posibles productos nuevos
		lsQry = "DELETE FROM op_inv_inventory_begin WHERE "
				+ "inv_id IN (SELECT DISTINCT(inv_id) FROM op_inv_inventory_detail "
				+ "WHERE year_no=? AND period_no=? AND week_no=?)";
		moAbcUtils.executeSQLCommand(lsQry, new String[] { psYear, psPeriod, psWeek });
		// Llenamos por primera vez la bandera de captura

		lbFirst = inventoryFirst(psYear, psPeriod, psWeek);
		lbTable = inventoryTable(psYear, psPeriod, psWeek);
		logApps.writeInfo("lbFirst[" + lbFirst + "]  lbTable[" + lbTable + "]");

		if (lbTable) {
			lsTable = "_first";
			if (lbFirst) {
				lsTable = "_first";
			}
		} else {
			if (lbFirst) {
				lsTable = "_first";
			}
		}
		
		

		lsQry = "INSERT INTO op_inv_step_inventory_detail " + "SELECT * FROM op_inv" + lsTable + "_inventory_detail "
				+ "WHERE year_no=%s AND period_no=%s AND week_no=%s " + "UNION " + //Se consideran productos nuevos.
				"SELECT b.inv_id, b.inv_beg, 0,0,0,0,0,0,0,0,0,0,0,0,0,'','','f',(SELECT to_char(timestamp 'now','YYYY-MM-DD HH24:MM:SS'))::timestamp, "
				+ "%s,%s,%s FROM op_inv_inventory_begin b INNER JOIN op_grl_cat_providers_product p "
				+ "ON(b.inv_id = p.inv_id) WHERE p.active_flag IN(1,2)";

		lsQry = Str.getFormatted(lsQry, new Object[] { psYear, psPeriod, psWeek, psYear, psPeriod, psWeek });

		moAbcUtils.executeSQLCommand(lsQry);

		// Carga de movimientos de inventarios por si falla
		lsQry = "SELECT add_receptions_inv(" + psYear + "," + psPeriod + "," + psWeek + ")";
		moAbcUtils.queryToString(lsQry);
		lsQry = "SELECT add_itransfers_inv(" + psYear + "," + psPeriod + "," + psWeek + ")";
		moAbcUtils.queryToString(lsQry);
		lsQry = "SELECT add_otransfers_inv(" + psYear + "," + psPeriod + "," + psWeek + ")";
		moAbcUtils.queryToString(lsQry);
		lsQry = "SELECT add_exceptions_inv(" + psYear + "," + psPeriod + "," + psWeek + ")";
		moAbcUtils.queryToString(lsQry);

	}

	/**        
	    Metodo inserta los valores iniciales de la tabla de inventario. 
	    Las columnas principales son el inv_id, inv_beg
	    
	void initInventory(String psYear, String psPeriod, String psWeek)
	{
	    //DEBUG
	    logApps.writeInfo("initInventory() ... ");
	
	    String lsQry, lsRes;
	    int numItems;
	
	    lsQry    = "SELECT COUNT(*) FROM op_inv_inventory_detail WHERE " +
	               "year_no="+psYear+" AND period_no="+psPeriod+" AND week_no="+psWeek;
	
	    lsRes    = moAbcUtils.queryToString(lsQry, "", ",");
	    numItems = -1;
	
	    try
	    {
	        if(lsRes != null)
	            numItems = Integer.parseInt(lsRes);
	
	        // Se cargan los valores del inventario inicial del archivo invtran 
	        // Determina que productos son validos para la semana
	        loadInventoryBegin(psYear, psPeriod, psWeek);
	
	        // Se borran los registros de la tabla de paso 
	        lsQry = "DELETE FROM op_inv_step_inventory_detail";
	
	        moAbcUtils.executeSQLCommand(lsQry, new String[]{});
	
	
	        // Se cargan productos actuales a tabla de paso
	        lsQry = "INSERT INTO op_inv_step_inventory_detail " + 
	        "(inv_id, inv_beg, date_id, year_no, period_no, week_no) " +
	        "SELECT DISTINCT " +
	        "prod.inv_id, ibegin.inv_beg, " +
	        "CURRENT_DATE, " + psYear + "," + psPeriod + "," + psWeek + " " +
	        "FROM op_grl_cat_providers_product prod " +
	        "INNER JOIN op_inv_inventory_begin ibegin " +
	        "ON (prod.inv_id = ibegin.inv_id) WHERE prod.active_flag IN(1,2) " ;
	
	        moAbcUtils.executeSQLCommand(lsQry, new String[]{});
	
	        if(numItems == 0)
	        {
	            // Se cargan mismos datos de la tabla de paso a inventario
	            
	            lsQry = "INSERT INTO op_inv_inventory_detail " +
	                "SELECT * FROM op_inv_step_inventory_detail ";
	
	            moAbcUtils.executeSQLCommand(lsQry, new String[]{});
	        }
	        else
	        {
	            //Borra productos que ya no son validos
	            lsQry = "DELETE FROM op_inv_inventory_detail WHERE " +
	            "year_no="+psYear+" AND period_no="+psPeriod+" AND " +
	            "week_no="+psWeek+" AND inv_id NOT IN " +
	            "(SELECT DISTINCT(inv_id) FROM op_inv_inventory_begin)";
	
	            moAbcUtils.executeSQLCommand(lsQry, new String[]{});
	
	            //Inserta productos nuevos
	            lsQry = "INSERT INTO op_inv_inventory_detail " +
	            "(inv_id, inv_beg, date_id, year_no, period_no, week_no) " +
	            "SELECT inv_id, inv_beg, CURRENT_DATE, year_no, period_no, week_no " +
	            "FROM op_inv_step_inventory_detail " +
	            "EXCEPT " +
	            "SELECT inv_id, inv_beg, CURRENT_DATE, year_no, period_no, week_no " +
	            "FROM op_inv_inventory_detail WHERE year_no="+psYear+" AND "+
	            "period_no="+psPeriod+" AND week_no="+psWeek;
	
	            moAbcUtils.executeSQLCommand(lsQry, new String[]{});
	
	            // Se ponen todos los inventarios finales en cero. Para ya no
	               hacer la validacion isnull()
	            lsQry = "UPDATE op_inv_step_inventory_detail SET prv_inv_end=0, "+
	                    "inv_inv_end=0, rec_inv_end=0";
	            moAbcUtils.executeSQLCommand(lsQry);                        
	
	            // Se actualizan valores capturados anteriormente 
	            lsQry = "UPDATE op_inv_step_inventory_detail SET prv_inv_end=id.prv_inv_end, " +
	            "inv_inv_end=id.inv_inv_end, rec_inv_end=id.rec_inv_end, " +
	            "decreases=id.decreases " +
	            "FROM op_inv_inventory_detail id " +
	            "WHERE op_inv_step_inventory_detail.year_no=id.year_no AND " +
	            "op_inv_step_inventory_detail.period_no=id.period_no AND " +
	            "op_inv_step_inventory_detail.week_no = id.week_no AND " +
	            "op_inv_step_inventory_detail.inv_id=id.inv_id AND " +
	            "op_inv_step_inventory_detail.year_no=? AND " +
	            "op_inv_step_inventory_detail.period_no=? AND " +
	            "op_inv_step_inventory_detail.week_no=? ";
	
	            moAbcUtils.executeSQLCommand(lsQry, new String[]{psYear, psPeriod, psWeek});
	
	
	        }
	    }
	
	    catch(Exception e)
	    {
	        logApps.writeInfo("Exception initInventory() ... " + e.toString());
	    }
	}
	 */

	/**
	    Metodo que actualiza las recepciones y las transferencias de entrada/salida 
	    en la tabla de inventario.
	 */
	void updateInventory(String psYear, String psPeriod, String psWeek) {
		//DEBUG
		logApps.writeInfo("updateInventory(psYear["+psYear+"], psPeriod[" + psPeriod + "], psWeek[" + psWeek +"]).. ");

		String lsQry;

		// Se cargan los factores de conversion a la tabla op_inv_conversion_factor 
		loadConversionFactors();

		//Llena las tablas op_inv_ideal_use y op_inv_unit_cost
		loadUsageAndCost(psYear, psPeriod, psWeek);
		
		//loadTransfersFirst(psYear, psPeriod, psWeek);

		/*
		  EZ: tunning
		  Ya no se invocara a este metodo
		  loadInventoryMov(psYear, psPeriod, psWeek);
		
		//Se actualizan los valores de recepciones y transferencias.
		lsQry = "UPDATE op_inv_step_inventory_detail SET " +
		"receptions=isnull( get_receptions(inv_id), 0), " +
		"itransfers=isnull( get_itransfers(inv_id),0 ) , "+
		"otransfers=isnull( get_otransfers(inv_id), 0)  "+
		"WHERE year_no=? AND period_no=? AND week_no=?";
		   moAbcUtils.executeSQLCommand(lsQry, new String[]{psYear, psPeriod, psWeek});
		 */

	}

	String getCaptureFormatQuery(String psYear, String psPeriod, String psWeek, String psFamilyId) {
		String lsQry = "SELECT DISTINCT c.inv_desc, " + "'' AS cong_prov, '' AS conv_inv, '' AS cong_rec, "
				+ "'' AS most_prov, '' As most_inv, '' AS most_rec, "
				+ "'' AS bode_prov, '' AS bode_inv, '' As bode_rec, "
				+ "'' AS cuar_prov, '' AS cuar_inv, '' As cuar_rec "
				+ "FROM op_inv_step_inventory_detail i INNER JOIN op_grl_cat_inventory c " + "ON (i.inv_id = c.inv_id) "
				+ "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) " + "WHERE "
				+ "p.active_flag IN(1,2) AND " + "c.family_id = '" + psFamilyId + "' AND i.year_no = " + psYear
				+ " AND i.period_no = " + psPeriod + " AND i.week_no = " + psWeek
				+ " AND (i.inv_beg > 0.0 OR i.ideal_use > 0.0 OR i.receptions > 0.0 OR i.itransfers > 0.0) ORDER BY 1";
		logApps.writeInfo("Query para impresion de formato:\n" + lsQry);
		return lsQry;
	}

	/** Actualiza el valor del inventario final y la merma en la tabla de paso 
	   op_inv_step_inventory_detail o first*/
	void updateStepInventory(HttpServletRequest poRequest) throws Exception {
		ArrayList loValues;
		String lsQry, lsParam, lsRowId;
		String lsPrvQty, lsInvQty, lsRecQty, lsDecQty, lsInvId, lsRes;
		String lsTable = "op_inv_first_inventory_detail";
		int liNumItems;
		int liIndSpace;
		if (poRequest.getParameter("hidTried").equals("2")) {
			lsTable = "op_inv_step_inventory_detail";
		}

		logApps.writeInfo("Tabla a insertar: " + lsTable);

		lsQry = "SELECT COUNT(*) FROM op_inv_first_inventory_detail WHERE " + "year_no= "
				+ poRequest.getParameter("hidYear") + " AND period_no = " + poRequest.getParameter("hidPeriod")
				+ " AND week_no = " + poRequest.getParameter("hidWeek");
		lsRes = moAbcUtils.queryToString(lsQry);
		logApps.writeInfo("Total de registros de firts: [" + lsRes + "]");
		if (lsRes != null && Integer.parseInt(lsRes) > 0) {
			lsQry = "UPDATE " + lsTable
					+ " SET prv_inv_end=?, inv_inv_end=?, rec_inv_end=?, decreases=? WHERE inv_id = ?";
		} else {
			lsQry = "INSERT INTO " + lsTable + " SELECT * FROM op_inv_step_inventory_detail WHERE year_no = "
					+ poRequest.getParameter("hidYear") + " AND period_no = " + poRequest.getParameter("hidPeriod")
					+ " AND week_no = " + poRequest.getParameter("hidWeek");

			logApps.writeInfo("Insert de la tabla first:" + lsQry);
			moAbcUtils.executeSQLCommand(lsQry);
			lsQry = "UPDATE " + lsTable
					+ " SET prv_inv_end=?, inv_inv_end=?, rec_inv_end=?, decreases=? WHERE inv_id = ?"; // PAra que actualice el Preview   
		}

		try {
			String lsNumItems = poRequest.getParameter("hidNumItems");
			if (lsNumItems != null && lsNumItems.equals("") && lsNumItems.equals("null")) {
				logApps.writeError("No se encontraron número de items para guardar");
				return;
			}
			liNumItems = Integer.parseInt(lsNumItems);
			loValues = new ArrayList();

			for (int liRowId = 0; liRowId < liNumItems; liRowId++) {

				lsInvId = poRequest.getParameter("inventoryId|" + liRowId);
				if (lsInvId.equals("NA"))
					continue;

				lsPrvQty = poRequest.getParameter("finalPrvQty|" + liRowId);
				lsInvQty = poRequest.getParameter("finalInvQty|" + liRowId);
				lsRecQty = poRequest.getParameter("finalRecQty|" + liRowId);
				lsDecQty = "0.0"; //poRequest.getParameter("decreaseQty|"+liRowId);

				if (lsPrvQty.compareTo("") == 0) {
					lsPrvQty = "0.0";
				} else {
					liIndSpace = lsPrvQty.indexOf(" ");
					lsPrvQty = lsPrvQty.substring(0, liIndSpace);
				}

				liIndSpace = lsInvQty.indexOf(" ");
				lsInvQty = lsInvQty.substring(0, liIndSpace);
				liIndSpace = lsRecQty.indexOf(" ");
				lsRecQty = lsRecQty.substring(0, liIndSpace);
				//lsDecQty = lsDecQty.substring(0, lsDecQty.indexOf(" "));
				loValues.add(new String[] { lsPrvQty, lsInvQty, lsRecQty, lsDecQty, lsInvId.trim() });
			}
			gbFlgErr = true;
			if (gfErrors.exists()) {
				logApps.writeInfo("Eliminando el archivo " + gfErrors);
				gfErrors.delete();
			}
			while (gbFlgErr) {
				logApps.writeInfo("\nValidando si hay errores en la captura de finales...");
				loValues = validateValues(loValues);
			}

			moAbcUtils.executeSQLCommand(lsQry, loValues);

			/*EZ: tunning Calcula inventario final total en tabla de paso*/

			lsQry = "SELECT update_inv_end('" + lsTable + "')";
			moAbcUtils.queryToString(lsQry);

			/*EZ: tunning
			  Calcula el uso real en tabla de paso*/
			lsQry = "SELECT update_real_use('" + lsTable + "')";
			moAbcUtils.queryToString(lsQry);
		} catch (Exception e) {
			String error = "Error: " + e.getMessage() + "\n";
			for (StackTraceElement trace : e.getStackTrace()) {
				error += trace.toString() + "\n";
			}
			logApps.writeInfo("updateInventoryEnd() ... " + error);
		}

		if (!poRequest.getParameter("hidTried").equals("2")) {
			lsQry = "DELETE FROM op_inv_step_inventory_detail WHERE year_no = " + poRequest.getParameter("hidYear")
					+ " AND period_no = " + poRequest.getParameter("hidPeriod") + " AND week_no = "
					+ poRequest.getParameter("hidWeek");
			moAbcUtils.executeSQLCommand(lsQry);
			lsQry = "INSERT INTO op_inv_step_inventory_detail SELECT * FROM op_inv_first_inventory_detail WHERE year_no = "
					+ poRequest.getParameter("hidYear") + " AND period_no = " + poRequest.getParameter("hidPeriod")
					+ " AND week_no = " + poRequest.getParameter("hidWeek");
			moAbcUtils.executeSQLCommand(lsQry);
		}

	}

	void setFlagErr(boolean pbFlg) {
		gbFlgErr = pbFlg;
	}

	ArrayList validateValues(ArrayList poValues) {
		ArrayList<Integer> loErrValues = new ArrayList<Integer>();
		int liIndexD = -1;
		for (int index = 0; index < poValues.size(); index++) {
			String lsVal[] = (String[]) poValues.get(index);
			for (String loVal : lsVal) {
				if (!loVal.matches("[-+]?\\d*\\.?\\d+")) {
					logApps.writeError(
							"Se intenta ingresar un valor invalido para el inv_id " + lsVal[4] + ": [" + loVal + "]");
					logApps.writeError("El index del detalle es " + index);
					writeFileErrors(lsVal[4]);
					liIndexD = index;
					setFlagErr(true);
					break;
				} else {
					setFlagErr(false);
				}
			}
			if (gbFlgErr) {
				break;
			}
		}

		if (liIndexD >= 0) {
			poValues.remove(liIndexD);
		}
		return poValues;
	}

	void writeFileErrors(String psInvId) {
		boolean lbCpDel = false;
		try {
			FileInputStream fr = null;
			FileOutputStream fw = null;

			String lsQry = "SELECT TRIM(provider_product_desc) FROM op_grl_cat_providers_product " + "WHERE inv_id='"
					+ psInvId + "' " + "AND active_flag<>0 " + "limit 1";
			String lsData = "";

			logApps.writeInfo("Tamaño del archivo " + gfErrors + " " + gfErrors.length());
			if (gfErrors.length() > 0) {
				logApps.writeInfo("El archivo existe, se va a copiar la información que contiene...");
				fr = new FileInputStream(gfErrors);
				fw = new FileOutputStream(gfErrors + ".tmp");
				int character = 0;
				while ((character = fr.read()) != -1) {
					fw.write(character);
					fw.flush();
				}
				lbCpDel = true;
				lsData = psInvId + " - " + moAbcUtils.queryToString(lsQry) + "\\n";
			} else {
				fw = new FileOutputStream(gfErrors);
				lsData = "prdErrors=\"" + psInvId + " - " + moAbcUtils.queryToString(lsQry) + "\\n\"";
			}

			logApps.writeInfo("Escribiendo error en el archivo para el inv_id: [" + lsData + "]");
			fw.write(lsData.getBytes());
			fw.flush();

			if (fr != null)
				fr.close();
			if (fw != null)
				fw.close();
			if (lbCpDel) {
				copyAndDeleteFile(new File(gfErrors + ".tmp"), gfErrors);
			}
		} catch (Exception e) {
			logApps.writeError(e);
		}
	}

	void copyAndDeleteFile(File fileOrig, File fileNew) {
		FileInputStream fr;
		FileOutputStream fw;
		boolean lbCom = false;
		if (fileOrig.exists()) {
			try {
				fr = new FileInputStream(fileOrig);
				fw = new FileOutputStream(fileNew);
				int character = 0;
				while ((character = fr.read()) != -1) {
					if (character == 34) {
						if (lbCom) {
							continue;
						}
						lbCom = true;
					}
					fw.write(character);
					fw.flush();
				}
				fw.write("\"".getBytes());
				fw.close();
				fr.close();
				fileOrig.delete();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		} else {
			logApps.writeInfo("El archivo " + fileOrig.getAbsolutePath() + " no existe");
		}
	}

	void saveInventoryDB(String psYear, String psPeriod, String psWeek) {
		String lsQuery, laResult[][];
		String lsNextYear, lsNextPeriod, lsNextWeek, lsNextDate;
		String lsWeekNo;

		lsQuery = "DELETE FROM op_inv_inventory_detail WHERE year_no=? " + "AND period_no=? AND week_no=?";

		moAbcUtils.executeSQLCommand(lsQuery, new String[] { psYear, psPeriod, psWeek });

		lsQuery = "INSERT INTO op_inv_inventory_detail SELECT * FROM " + "op_inv_step_inventory_detail "
				+ "WHERE year_no=? AND period_no=? AND week_no=?";

		moAbcUtils.executeSQLCommand(lsQuery, new String[] { psYear, psPeriod, psWeek });

		/*
		    EZ: tunning
		    Se ingresaran los valores del inventario inicial de la siguiente
		    semana para que ya esten listos.
		 */
		lsWeekNo = getWeekNo(psYear, psPeriod, psWeek);
		lsNextDate = getTimestamp(psYear, psPeriod, lsWeekNo);

		lsQuery = "SELECT  '%s'::date +  interval '7 day'";
		lsQuery = Str.getFormatted(lsQuery, new Object[] { lsNextDate });
		lsNextDate = moAbcUtils.queryToString(lsQuery);

		lsQuery = "SELECT get_year('%s'), get_period('%s'), get_week('%s')";
		lsQuery = Str.getFormatted(lsQuery, new Object[] { lsNextDate, lsNextDate, lsNextDate });
		laResult = moAbcUtils.queryToMatrix(lsQuery);

		lsNextYear = laResult[0][0];
		lsNextPeriod = laResult[0][1];
		lsNextWeek = laResult[0][2];

		lsQuery = "DELETE FROM op_inv_inventory_detail WHERE year_no=? AND " + "period_no=? AND week_no=?";

		moAbcUtils.executeSQLCommand(lsQuery, new String[] { lsNextYear, lsNextPeriod, lsNextWeek });

		lsQuery = "INSERT INTO op_inv_inventory_detail SELECT inv_id, inv_end, 0, 0, 0, 0, 0, 0, 0, 0,"
				+ "0,0,0,prv_conversion_factor, rcp_conversion_factor, prv_unit_measure, "
				+ "inv_unit_measure,misc,'%s',%s,%s,%s FROM op_inv_inventory_detail WHERE "
				+ "year_no=? AND period_no=? AND week_no=?";
		lsQuery = Str.getFormatted(lsQuery, new Object[] { lsNextDate, lsNextYear, lsNextPeriod, lsNextWeek });
		moAbcUtils.executeSQLCommand(lsQuery, new String[] { psYear, psPeriod, psWeek });
	}

	/**
	    Escribe el valor del inventario final en el archivo de FMS  (invtran)
	 */
	boolean saveInventoryFMS(String psYear, String psPeriod, String psWeek) {

		LinkedHashMap invend;
		Inventory loInventory;
		Record records[];
		String lsQry, laResult[][], keys[];
		int liWeekId;
		//float finalInv[];

		loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod, 2), psWeek);
		liWeekId = loInventory.getWeekId();

		lsQry = "SELECT DISTINCT i.inv_id, " +
		//"ROUND(isnull(i.inv_inv_end+i.prv_inv_end*p.conversion_factor+i.rec_inv_end/c.rcp_conversion_factor,0),2) " + //Version original MCHA
		//"FROM op_inv_inventory_detail i INNER JOIN op_grl_cat_providers_product p " +
		//"ON(i.inv_id = p.inv_id) INNER JOIN op_grl_cat_inventory c " +
		//"ON(i.inv_id = c.inv_id) " +
		//"WHERE i.year_no="+psYear+" AND i.period_no="+psPeriod+" AND i.week_no="+psWeek;

				"ROUND(isnull(i.inv_inv_end+i.prv_inv_end*i.prv_conversion_factor+i.rec_inv_end/c.rcp_conversion_factor,0),2) "
				+ "FROM op_inv_inventory_detail i " + "INNER JOIN op_grl_cat_inventory c " + "ON(i.inv_id = c.inv_id) "
				+ "WHERE i.year_no=" + psYear + " AND i.period_no=" + psPeriod + " AND i.week_no=" + psWeek;

		laResult = moAbcUtils.queryToMatrix(lsQry);

		keys = new String[laResult.length];
		//finalInv  = new float[laResult.length];
		invend = new LinkedHashMap();

		logApps.writeInfo("laResult.length: " + laResult.length);

		try {

			for (int rowId = 0; rowId < laResult.length; rowId++) {
				keys[rowId] = laResult[rowId][0].trim();
				//finalInv[rowId] = Float.parseFloat(laResult[rowId][1]);

				invend.put(keys[rowId], new Float(laResult[rowId][1]));
			}

			records = loInventory.findRecords(keys);

			logApps.writeInfo("records.length: " + records.length);

			for (int rowId = 0; rowId < records.length; rowId++) {
				//Para actualizar los valores del inventario final en el archivo de FMS
				String key = records[rowId].getProduct().getKey();
				//records[rowId].getWeek(liWeekId).setInvEnd(finalInv[rowId]);
				Float finalinv = (Float) invend.get(key);
				records[rowId].getWeek(liWeekId).setInvEnd(finalinv.floatValue());
			}

			//Se hace un backup del archivo antes de que se actualizen los valores
			loInventory.backup();

			if (loInventory.updateRecords(records) > 0)
				return true;
			else
				return false;
		} catch (Exception e) {
			logApps.writeInfo("Exception saveInventoryFMS() ... " + e.toString());
			return false;
		}
	}

	/**
	    Para obtener las categorias de productos
	 */

	String getFamiliesQuery() {
		String lsQry;

		lsQry = "SELECT family_id, upper(family_desc) AS family_desc FROM op_grl_cat_family "
				+ "WHERE family_order IS NOT NULL ORDER BY family_order ASC ";

		return lsQry;
	}

	String[][] getFamilies() {
		return moAbcUtils.queryToMatrix(getFamiliesQuery());
	}

	String getFamilyDesc(String psFamilyId) {
		String lsQry;

		lsQry = "SELECT upper(family_desc) AS family_desc FROM op_grl_cat_family " + "WHERE family_id = '" + psFamilyId
				+ "'";

		return moAbcUtils.queryToString(lsQry, "", ",");
	}

	String getDataset(boolean step, String psYear, String psPeriod, String psWeek, String psFamily) {
		if (psFamily.equals("-1"))
			return getFullDataset(step, psYear, psPeriod, psWeek);
		else
			return getSimpleDataset(step, psYear, psPeriod, psWeek, psFamily);
	}

	/*
	    Para inventory preview e inventory report
	 *
	String getReportDataset(boolean step, String psYear, String psPeriod, String psWeek, String psFamily)
	{
	    if(psFamily.equals("-1"))
	        return getFullReportDataset(step, psYear, psPeriod, psWeek);
	    else
	        return getSimpleReportDataset(step, psYear, psPeriod, psWeek, psFamily);
	}
	 */

	String getCaptureFormat(String psYear, String psPeriod, String psWeek, String psFamily) {
		if (psFamily.equals("-1"))
			return getFullCaptureFormat(psYear, psPeriod, psWeek);
		else
			return getSimpleCaptureFormat(psYear, psPeriod, psWeek, psFamily);
	}

	String getFullDataset(boolean step, String psYear, String psPeriod, String psWeek) {
		String lsData = "var tmpArray = new Array();\n";
		String data[][] = getFamilies();

		if (data.length > 0) {
			for (int i = 0; i < data.length; i++) {
				String familyId = data[i][0];
				String familyDesc = data[i][1];

				lsData += getSimpleDataset(step, psYear, psPeriod, psWeek, familyId, familyDesc);
			}
		}
		return lsData;
	}

	/*
	String getFullReportDataset(boolean step, String psYear, String psPeriod, String psWeek)
	{
	    String lsData = "var tmpArray = new Array();\n";
	    String data[][] = getFamilies();
	
	    if(data.length > 0)
	    {
	        for(int i=0; i<data.length; i++)
	        {
	            String familyId   = data[i][0];
	            String familyDesc = data[i][1];
	
	            lsData += getSimpleReportDataset(step, psYear, psPeriod, psWeek, familyId, familyDesc);
	        }
	    }
	    return lsData;
	}*/

	String getFullCaptureFormat(String psYear, String psPeriod, String psWeek) {
		String lsData = "var tmpArray = new Array();\n";
		String data[][] = getFamilies();

		if (data.length > 0) {
			for (int i = 0; i < data.length; i++) {
				String familyId = data[i][0];
				String familyDesc = data[i][1];

				lsData += getSimpleCaptureFormat(psYear, psPeriod, psWeek, familyId, familyDesc);
			}
		}
		return lsData;
	}

	String getSimpleDataset(boolean step, String psYear, String psPeriod, String psWeek, String psFamilyId) {
		String lsData = "var tmpArray = new Array(); \n";
		String lsFamilyDesc = getFamilyDesc(psFamilyId);

		lsData += getSimpleDataset(step, psYear, psPeriod, psWeek, psFamilyId, lsFamilyDesc);

		return lsData;
	}

	/*
	String getSimpleReportDataset(boolean step, String psYear, String psPeriod, String psWeek, String psFamilyId)
	{
	    String lsData  = "var tmpArray = new Array(); \n";
	    String lsFamilyDesc = getFamilyDesc(psFamilyId);
	
	    lsData += getSimpleReportDataset(step, psYear, psPeriod, psWeek, psFamilyId, lsFamilyDesc);
	
	    return lsData;
	}
	 */

	String getSimpleCaptureFormat(String psYear, String psPeriod, String psWeek, String psFamilyId) {
		String lsData = "var tmpArray = new Array(); \n";
		String lsFamilyDesc = getFamilyDesc(psFamilyId);

		lsData += getSimpleCaptureFormat(psYear, psPeriod, psWeek, psFamilyId, lsFamilyDesc);

		return lsData;
	}

	String getSimpleDataset(boolean step, String psYear, String psPeriod, String psWeek, String psFamilyId,
			String psFamilyDesc) {
		String lsData = "";
		String tmpData = moAbcUtils.getJSResultSet(getInventoryDetailQuery(step, psYear, psPeriod, psWeek, psFamilyId));

		if (!tmpData.trim().equals("new Array()")) {
			lsData += "tmpArray  = new Array(new Array('" + psFamilyDesc + "')); \n";
			lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
			lsData += "tmpArray  = " + tmpData + ";\n";
			lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
		}

		return lsData;
	}

	/*
	String getSimpleReportDataset(boolean step, String psYear, String psPeriod,
	                        String psWeek, String psFamilyId, String psFamilyDesc)
	{
	    String lsData  = "";
	    String tmpData = moAbcUtils.getJSResultSet( getInventoryReportQuery(step, psYear, psPeriod, psWeek, psFamilyId));
	
	    if(!tmpData.trim().equals("new Array()"))
	    {
	        lsData += "tmpArray  = new Array(new Array('"+psFamilyDesc+"')); \n";
	        lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
	        lsData += "tmpArray  = " + tmpData + ";\n";
	        lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
	    }
	
	    return lsData;
	} */

	/**
	    Metodo que devuelve la consulta para obtener el detalle de un
	    inventario. Debe ser comun a Entry/InventoryPreview y Rpt/InventoryDetail. 
	    El parametro step determina si se leen los datos
	    de la tabla de paso.
	 */

	/*
	String getInventoryReportQuery(boolean step, String psYear, String psPeriod, String psWeek, String psFamilyId)
	{
	    String lsInvTable = "op_inv"+ ((step==true)?"_step_":"_") + "inventory_detail";
	
	    String lsQry = "SELECT DISTINCT c.inv_desc, " +
	    "i.inv_beg,  i.receptions, i.itransfers, i.otransfers, " +
	    "i.prv_inv_end, i.inv_inv_end, i.rec_inv_end, " +
	    "i.inv_end || ' ' || i.inv_unit_measure AS inv_total, " +
	    "i.real_use, i.ideal_use, (i.ideal_use - i.real_use) AS difference, "+
	    "ROUND((i.ideal_use - i.real_use) * i.unit_cost, 2) AS difference_money, "+
	    "i.decreases, "+
	    "(i.ideal_use-i.real_use)-i.decreases AS faltant, i.inv_id, " +
	    "i.inv_unit_measure, " +
	    "i.prv_conversion_factor AS prov_conversion_factor, " + 
	    "prv_unit_measure, " +
	    "i.rcp_conversion_factor AS recipe_conversion_factor, " +
	    "lower(substr(rum.unit_name, 0, 5)) AS rec_unit_measure, " +
	    "i.unit_cost AS unit_cost, isnull(e.max_variance,0) AS max_variance, " +
	    "isnull(e.min_efficiency,0) AS min_efficiency, " +
	    "isnull(e.max_efficiency,0) As max_efficiency, " +
	    "i.misc AS miscelaneo " +
	    "FROM "+lsInvTable+" i INNER JOIN op_grl_cat_inventory c " +
	    "ON (i.inv_id = c.inv_id) " +
	    "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) " +
	    "INNER JOIN op_grl_cat_unit_measure rum ON(c.recipe_unit_measure = rum.unit_id) " +
	    "LEFT JOIN op_inv_exceptions e ON (i.inv_id = e.inv_id) " +
	    "WHERE " +
	    "p.active_flag IN(1,2) AND " +
	    "c.family_id = '" + psFamilyId + "' AND " +
	    "i.year_no = " + psYear + " AND i.period_no = " + psPeriod + 
	    " AND i.week_no = " + psWeek;
	
	    return lsQry;
	} */

	/**
	    Metodo que devuelve la consulta para obtener el detalle de un
	    inventario. Debe ser comun a Entry/InventoryDetail, Entry/InventoryPreview 
	    y Rpt/InventoryDetail. El parametro step determina si se leen los datos
	    de la tabla de paso.
	 */

	String getInventoryDetailQuery(boolean step, String psYear, String psPeriod, String psWeek, String psFamilyId) {
		String lsInvTable="";
		if (step){
			String qryNumProds="SELECT COUNT(*) FROM op_inv_first_inventory_detail"
				+ " WHERE year_no=" + psYear
				+ " AND period_no=" + psPeriod
				+ " AND week_no=" + psWeek;
			String lsNumProds=moAbcUtils.queryToString(qryNumProds, "", "");
			int liNumProds=Integer.parseInt(lsNumProds);
			//logApps.writeInfo("liNumProds: [" + liNumProds + "]");
			if ( liNumProds > 0 ){
				String qryFlag = "SELECT flag_id from op_inv_flag "
					+ "WHERE year_no=" + psYear
                                	+ " AND period_no=" + psPeriod
                                	+ " AND week_no=" + psWeek;
				String lsFlag = moAbcUtils.queryToString(qryFlag, "", "");
				int liFlag = Integer.parseInt(lsFlag);
				logApps.writeInfo("liFlag: [" + liFlag + "]");
				if ( liFlag > 1 ){
					lsInvTable = "op_inv_inventory_detail";
				} else {
					lsInvTable = "op_inv_first_inventory_detail";
				}
			} else {
				lsInvTable = "op_inv_step_inventory_detail";
			}
		} else {
			lsInvTable = "op_inv_inventory_detail";
		}

		String lsQry = "SELECT DISTINCT c.inv_desc, " + "i.inv_beg, " + "i.receptions, " + "i.itransfers, "
				+ "i.otransfers, " + "i.prv_inv_end || ' ' || i.prv_unit_measure AS prv_inv_end, "
				+ "i.prv_inv_end || ' ' || i.prv_unit_measure AS prv_inv_end, "
				+ "i.inv_inv_end || ' ' || i.inv_unit_measure AS inv_inv_ed, "
				+ "i.inv_inv_end || ' ' || i.inv_unit_measure AS inv_inv_ed, "
				+ "i.rec_inv_end || ' ' || lower(substr(rum.unit_name, 0, 5)) AS rec_inv_end, "
				+ "i.rec_inv_end || ' ' || lower(substr(rum.unit_name, 0, 5)) AS rec_inv_end, "
				+ "i.inv_end || ' ' || i.inv_unit_measure AS inv_total, " + "i.real_use, "
				+ "(i.inv_beg + i.receptions + i.itransfers - i.otransfers - i.inv_end - i.ideal_use) AS difference, "
				+ "i.ideal_use, " + "i.inv_id, " + "i.inv_unit_measure, "
				+ "i.prv_conversion_factor AS prov_conversion_factor, " + "i.prv_unit_measure, "
				+ "i.rcp_conversion_factor AS recipe_conversion_factor, "
				+ "lower(substr(rum.unit_name, 0, 5)) AS rec_unit_measure, " + "i.unit_cost AS unit_cost, "
				+ "isnull(e.max_variance, 0) AS max_variance, " + "isnull(e.min_efficiency, 0) AS min_efficiency, "
				+ "isnull(e.max_efficiency, 0) AS max_efficiency, " + "i.misc AS miscelaneo " + "FROM " + lsInvTable
				+ " i INNER JOIN op_grl_cat_inventory c ON (i.inv_id = c.inv_id) "
				+ "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) "
				+ "INNER JOIN op_grl_cat_unit_measure rum ON(c.recipe_unit_measure = rum.unit_id) "
				+ "LEFT JOIN op_inv_exceptions e ON (i.inv_id = e.inv_id) " + "WHERE p.active_flag IN(1,2) "
				+ "AND c.family_id = '" + psFamilyId + "' " + "AND i.year_no = " + psYear + " AND i.period_no = "
				+ psPeriod + " AND i.week_no = " + psWeek
				+ " AND (i.inv_beg > 0.0 OR i.ideal_use > 0.0 OR i.receptions > 0.0 OR i.itransfers > 0.0) "
				+ "ORDER BY 1";

		if (psFamilyId.contains("12020000")) {
			logApps.writeInfo("Query de busqueda de productos para la familia " + psFamilyId + ":\n\t" + lsQry);
		}
		return lsQry;
	}

	String getSimpleCaptureFormat(String psYear, String psPeriod, String psWeek, String psFamilyId,
			String psFamilyDesc) {
		String lsData = "";
		String tmpData = moAbcUtils.getJSResultSet(getCaptureFormatQuery(psYear, psPeriod, psWeek, psFamilyId));

		if (!tmpData.trim().equals("new Array()")) {
			lsData += "tmpArray  = new Array(new Array('" + psFamilyDesc + "','d1','d2','d3','d4','d5','d6','d7')); \n";
			lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
			lsData += "tmpArray  = " + tmpData + ";\n";
			lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
		}

		return lsData;
	}

	/**
	    Obtiene las ventas netas para una semana.
	 */
	String getSales(String psYear, String psPeriod, String psWeek) {
		String lsQuery, lsWeekNo;

		lsWeekNo = getWeekNo(psYear, psPeriod, psWeek);

		lsQuery = "SELECT sum(quantity) FROM op_grl_finantial_mov WHERE  "
				+ "finantial_code = '1' AND date_trunc('day', date_id) IN ("
				+ "SELECT date_id FROM ss_cat_time WHERE year_no=%s AND " + "period_no=%s AND week_no=%s)";
		lsQuery = Str.getFormatted(lsQuery, new Object[] { psYear, psPeriod, lsWeekNo });

		return moAbcUtils.queryToString(lsQuery);
	}

	boolean saveChanges(String psYear, String psPeriod, String psWeek) throws Exception {
		logApps.writeInfo("Se guardara el inventario");
		try {
			String lsQry = "SELECT COUNT(*) FROM op_inv_first_inventory_detail WHERE " + "year_no=" + msYear
					+ " AND period_no=" + msPeriod + " AND week_no=" + msWeek;
			logApps.writeInfo("lsQry:\n" + lsQry);

			String lsStatus = moAbcUtils.queryToString(lsQry, "", "");

			if (Integer.parseInt(lsStatus) > 0) //Se guardo el registro en la BD por segunda vez
			{
				saveInventoryDB(psYear, psPeriod, psWeek);
				lsQry = "SELECT COUNT(*) FROM op_inv_inventory_detail WHERE " + "year_no=" + msYear + " AND period_no="
						+ msPeriod + " AND week_no=" + msWeek;
				logApps.writeInfo("saveChanges.lsQry:\n" + lsQry);

				lsStatus = moAbcUtils.queryToString(lsQry, "", "");

				logApps.writeInfo("saveChanges.lsStatus: [" + lsStatus + "]");
				if (Integer.parseInt(lsStatus) > 0) //Se guardo el registro en la BD
				{
					//Se modifica el archivo de inventario para escribir el inventario final
					if (saveInventoryFMS(psYear, psPeriod, psWeek)) {
						return true;
					} else {
						return false;
					}

				} else {

					return false;
				}
			} else {
				return true;
			}
		} catch (Exception e) {
			logApps.writeError(e);
			return false;
		}
	}

	boolean inventoryExists(String psYearNo, String psPeriodNo, String psWeekId) {
		String lsQuery, lsResult;

		lsQuery = "SELECT COUNT(DISTINCT(inv_id)) FROM op_inv_inventory_detail "
				+ "WHERE year_no=%s AND period_no=%s AND week_no=%s";
		lsQuery = Str.getFormatted(lsQuery, new Object[] { psYearNo, psPeriodNo, psWeekId });

		lsResult = moAbcUtils.queryToString(lsQuery);

		if (lsResult != null && Integer.parseInt(lsResult) > 0)
			return true;
		else
			return false;
	}

	String inventoryFileUnBlock() {
		File lfInvBlock = null;
		FileReader lfrInvBlock = null;
		BufferedReader lbrInvBlock = null;
		String lsInvFile = "/usr/local/tomcat/webapps/ROOT/Scripts/InventoryUnBlock.txt";
		String lsLineReturn = "";
		String lsLine = "";

		try {
			lfInvBlock = new File(lsInvFile);
			lfrInvBlock = new FileReader(lfInvBlock);
			lbrInvBlock = new BufferedReader(lfrInvBlock);
			while ((lsLine = lbrInvBlock.readLine()) != null) {
				if (lsLine != null) {
					lsLineReturn = lsLine;
				}
			}
		} catch (Exception e2) {
			logApps.writeError("Cerrando Archivo de bloqueo: " + e2);
			e2.printStackTrace();
		} finally {
			try {
				if (null != lbrInvBlock) {
					lbrInvBlock.close();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
		return lsLineReturn;
	}

	void registerAudit(String psUser, String psYear, String psPeriod, String psWeek, String psInitDate) {
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Calendar c = Calendar.getInstance();
		psUser = psUser.length() > 30 ? psUser.substring(0, 30) : psUser;
		String qryInsert = "INSERT INTO op_grl_audit_events VALUES ("
				+ "(SELECT (CASE WHEN max(audit_id) IS NULL THEN 0 ELSE max(audit_id) END)+1 FROM op_grl_audit_events),"
				+ "'" + psYear.substring(2, 4) + psPeriod + "0" + psWeek + "'," + "'INVENTARIO SEM'," + "'" + psInitDate
				+ "'," + "'" + sdf.format(c.getTime()) + "'," + "'" + psUser + "')";
		logApps.writeInfo("Query para auditoria de inventario semanal:\n" + qryInsert);
		moAbcUtils.executeSQLCommand(qryInsert);
	}

	String attentionItems(String psYear, String psPeriod, String psWeek) {
		loadEfficiencyInventory();
		loadUsageAndCostFirst(psYear, psPeriod, psWeek);
		String lsQry = "SELECT i.inv_id || ' - ' || inv_desc "
				+ "FROM op_grl_cat_inventory AS i INNER JOIN op_inv_efficiency_inventory AS b ON (i.inv_id = b.inv_id) "
				+ "INNER  JOIN (SELECT inv_id, " + "(CASE WHEN ideal_use = 0 THEN 1 "
				+ "WHEN ideal_use>real_use THEN ((ideal_use-real_use)*100)/ideal_use "
				+ "ELSE ((real_use-ideal_use)*100)/ideal_use " + "END) AS diff_quantity, "
				+ "(CASE WHEN real_use <= 0 THEN 0 WHEN ideal_use <= 0 THEN 0 WHEN real_use - ideal_use > 0 THEN (real_use - ideal_use) * unit_cost "
				+ "ELSE 0 END) AS diff_money FROM op_inv_first_inventory_detail " + "WHERE misc <> 't' AND year_no = "
				+ psYear + "AND period_no = " + psPeriod + "AND week_no = " + psWeek
				+ ") AS c ON (c.inv_id = b.inv_id) WHERE diff_quantity > inv_quantity "
				+ "OR diff_money > prod_money ORDER BY diff_money DESC LIMIT 5";

		logApps.writeInfo("lsQry Negativos:\n" + lsQry);
		String[][] laNegatives = moAbcUtils.queryToMatrix(lsQry);

		lsQry = "SELECT i.inv_id || ' - ' || inv_desc "
				+ "FROM op_grl_cat_inventory AS i INNER JOIN op_inv_efficiency_inventory AS b ON (i.inv_id = b.inv_id) "
				+ "INNER  JOIN " + "(SELECT inv_id, " + "(CASE WHEN ideal_use = 0 THEN 1 "
				+ "WHEN ideal_use<real_use THEN ((ideal_use-real_use)*100)/ideal_use "
				+ "ELSE ((real_use-ideal_use)*100)/ideal_use " + "END) AS diff_quantity, "
				+ "(CASE WHEN ideal_use - real_use < 0 THEN 0 " + "ELSE (ideal_use - real_use) * unit_cost "
				+ "END) AS diff_money, misc FROM op_inv_first_inventory_detail " + "WHERE year_no = " + psYear
				+ "AND period_no = " + psPeriod + "AND week_no = " + psWeek + ") AS c ON (c.inv_id = b.inv_id) "
				+ "WHERE misc <> 't' AND diff_quantity < inv_quantity "
				+ "OR diff_money < prod_money ORDER BY diff_money DESC LIMIT 5";

		logApps.writeInfo("lsQry Positivos:\n" + lsQry);
		String[][] laPositives = moAbcUtils.queryToMatrix(lsQry);

		lsQry = "SELECT fid.inv_id || ' - ' || inv_desc " + "FROM op_inv_first_inventory_detail fid "
				+ "INNER JOIN op_grl_cat_inventory ci ON (ci.inv_id=fid.inv_id) " + "WHERE inv_end = 0  "
				+ "AND (inv_beg > 0 OR receptions > 0 OR itransfers > 0 OR ideal_use > 0) " + "AND misc <> 't' "
				+ "AND year_no = " + psYear + "AND period_no = " + psPeriod + "AND week_no = " + psWeek
				+ "ORDER BY unit_cost desc limit 5";
		
		logApps.writeInfo("lsQry Ceros:\n" + lsQry);

		String[][] laItemsZero = moAbcUtils.queryToMatrix(lsQry);

		return formatAttItems(laNegatives, laPositives, laItemsZero);
	}

	String formatAttItems(String[][] paNegs, String[][] paPos, String[][] paItems) {
		String lsFormat = "";
		int liRow = 0;
		int liPos=paPos.length;
		int liNeg=paNegs.length;
		int liItem=paItems.length;
		String [][]laMenor;
		String [][]laMedio;
		String [][]laAlto;

		if (paNegs.length == paPos.length && paNegs.length == paItems.length) {
			for (int index = 0; index < paNegs.length; index++) {
				lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + index % 2 + "\"><td class=\"text\" width=\"33%\">"
						+ paNegs[index][0] + "</td><td class=\"text\" width=\"33%\">" + paPos[index][0]
						+ "</td><td class=\"text\" width=\"34%\">" + paItems[index][0] + "</td></tr>";
			}
		} else {
			if (liPos < liNeg && liPos < liItem) {
				laMenor = paPos;
				if( liNeg < liItem){
					laMedio = paNegs;
					laAlto = paItems;
				} else {
					laMedio = paItems;
					laAlto = paNegs;
				}
			} else if (liNeg < liItem && liNeg < liPos) {
				laMenor = paNegs;
				if( liItem < liPos){
					laMedio = paItems;
					laAlto = paPos;
				} else {
					laMedio = paPos;
					laAlto = paItems;
				}
			} else {
				laMenor = paItems;
				if (liNeg < liPos){
					laMedio = paNegs;
					laAlto = paPos;
				} else {
					laMedio = paPos;
					laAlto = paNegs;
				}
			}
			logApps.writeInfo("menor: [" + laMenor.length + "]\nMedio: [" + laMedio.length + "]");

			/*
			* Tabla con menor datos
			*/
			for (int index = 0; index < laMenor.length; index++) {
				lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + index % 2 + "\"><td class=\"text\" width=\"33%\">"
						+ paNegs[index][0] + "</td><td class=\"text\" width=\"33%\">" + paPos[index][0]
						+ "</td><td class=\"text\" width=\"34%\">" + paItems[index][0] + "</td></tr>";
				liRow = index;
			}
			
			/*
			* Tabla con Medio datos
			*/
			if (laMedio == paPos && laAlto == paNegs) {
				for (liRow = (liRow + 1); liRow < laMedio.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2 + "\"><td class=\"text\" width=\"33%\">"
							+ paNegs[liRow][0] + "</td><td class=\"text\" width=\"33%\">" + paPos[liRow][0]
							+ "</td><td class=\"text\" width=\"34%\">&nbsp;</td></tr>";
				}
				for (; liRow < laAlto.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2 + "\"><td class=\"text\" width=\"33%\">"
							+ paNegs[liRow][0]
							+ "</td><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"34%\">&nbsp;</td></tr>";
				}
			} else if (laMedio == paPos && laAlto == paItems) {
				for (liRow = (liRow + 1); liRow < laMedio.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">"
							+ paPos[liRow][0] + "</td><td class=\"text\" width=\"34%\">" + paItems[liRow][0]
							+ "</td></tr>";
				}
				for (; liRow < laAlto.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"34%\">"
							+ paItems[liRow][0] + "</td></tr>";
				}
			} else if (laMedio == paNegs && laAlto == paPos) {
				for (liRow = (liRow + 1); liRow < laMedio.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2 + "\"><td class=\"text\" width=\"33%\">"
							+ paNegs[liRow][0] + "</td><td class=\"text\" width=\"33%\">" + paPos[liRow][0]
							+ "</td><td class=\"text\" width=\"34%\">&nbsp;</td></tr>";
				}
				for (; liRow < laAlto.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">"
							+ paPos[liRow][0] + "</td><td class=\"text\" width=\"34%\">&nbsp;</td></tr>";
				}
			} else if (laMedio == paNegs && laAlto == paItems) {
				for (liRow = (liRow + 1); liRow < laMedio.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2 + "\"><td class=\"text\" width=\"33%\">"
							+ paNegs[liRow][0]
							+ "</td><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"34%\">"
							+ paItems[liRow][0] + "</td></tr>";
				}
				for (; liRow < laAlto.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"34%\">"
							+ paItems[liRow][0] + "</td></tr>";
				}
			} else if (laMedio == paItems && laAlto == paNegs) {
				for (liRow = (liRow + 1); liRow < laMedio.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2 + "\"><td class=\"text\" width=\"33%\">"
							+ paNegs[liRow][0]
							+ "</td><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"34%\">"
							+ paItems[liRow][0] + "</td></tr>";
				}
				for (; liRow < laAlto.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">"
							+ paNegs[liRow][0] + "</td><td class=\"text\" width=\"34%\">&nbsp;</td></tr>";
				}
			} else {
				for (liRow = (liRow + 1); liRow < laMedio.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">"
							+ paPos[liRow][0] + "</td><td class=\"text\" width=\"34%\">" + paItems[liRow][0]
							+ "</td></tr>";
				}
				for (; liRow < laAlto.length; liRow++) {
					lsFormat += "<tr class=\"bsDg_tr_row_zebra_" + liRow % 2
							+ "\"><td class=\"text\" width=\"33%\">&nbsp;</td><td class=\"text\" width=\"33%\">"
							+ paPos[liRow][0] + "</td><td class=\"text\" width=\"34%\">&nbsp;</td></tr>";
				}
			}

		}
		return lsFormat;
	}

	void loadEfficiencyInventory() {

		String lsQry = "INSERT INTO op_inv_efficiency_inventory SELECT inv_id,15.00,400 "
				+ "FROM op_inv_inventory_detail "
				+ "WHERE inv_id not in (select inv_id from op_inv_efficiency_inventory) "
				+ "AND date_id = (SELECT to_char(CURRENT_DATE,'YYYY-MM-DD')::date)";
		moAbcUtils.executeSQLCommand(lsQry);
	}

	// Funcion para ver si ya guardo una vez es el flag 1 
	boolean inventoryFirst(String psYearNo, String psPeriodNo, String psWeekId) {
		String lsQuery, lsResult;

		lsQuery = "SELECT flag_id FROM op_inv_flag " + "WHERE year_no=%s AND period_no=%s AND week_no=%s";
		lsQuery = Str.getFormatted(lsQuery, new Object[] { psYearNo, psPeriodNo, psWeekId });

		lsResult = moAbcUtils.queryToString(lsQuery);

		if (lsResult != null && Integer.parseInt(lsResult) >= 1)
			return true;
		else
			return false;
	}

	boolean inventoryTable(String psYearNo, String psPeriodNo, String psWeekId) {
		String lsQuery, lsResult;
		lsQuery = "SELECT COUNT(*) FROM op_inv_first_inventory_detail "
				+ "WHERE year_no=%s AND period_no=%s AND week_no=%s";

		lsQuery = Str.getFormatted(lsQuery, new Object[] { psYearNo, psPeriodNo, psWeekId });
		lsResult = moAbcUtils.queryToString(lsQuery);

		if (lsResult != null && Integer.parseInt(lsResult) > 0)
			return true;
		else
			return false;
	}

	void inventoryClose() {
		try {
			String laPFSCommand[] = { "/usr/bin/ph/invcloseMail.s" };
			Runtime.getRuntime().exec(laPFSCommand);
		} catch (Exception e) {
			logApps.writeError("Error en SaveChanguesYum.jsp" + e);
		}
	}

	void valUseWeekInventory() {
		try {
			String laPFSCommand[] = { "/usr/fms/bin/valUseWeek.s" };
			Runtime.getRuntime().exec(laPFSCommand);
		} catch (Exception e) {
			logApps.writeError("Error en Actualizacion de usos ideales en SaveChanguesYum.jsp" + e);
		}
	}

	void updateFlagInv(String psYearNo, String psPeriodNo, String psWeekId, String psFlag) {
		String lsQuery;

		lsQuery = "UPDATE op_inv_flag SET flag_id = %s ";
		if ( psFlag.equals("1") ){
				lsQuery += "WHERE year_no=%s AND period_no=%s AND week_no=%s and flag_id <> 1";
		} else {
			lsQuery += "WHERE year_no=%s AND period_no=%s AND week_no=%s";
		}
		logApps.writeInfo("updateFlagInv.lsQuery: \n" + lsQuery);
		lsQuery = Str.getFormatted(lsQuery, new Object[] { psFlag, psYearNo, psPeriodNo, psWeekId });
		moAbcUtils.executeSQLCommand(lsQuery);
	}%>
