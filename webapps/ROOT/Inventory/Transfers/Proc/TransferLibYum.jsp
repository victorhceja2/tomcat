<%@page import="java.util.Date"%>
<%@ include file="/Include/CommonLibYum.jsp"%>

<%!void writeOptions(javax.servlet.jsp.JspWriter out,
			HashMap<String, String> dataForComb) {
		try {

			if (dataForComb.size() > 0) {
				List<String> keys = new ArrayList<String>(dataForComb.keySet());
				Collections.sort(keys);
				for (String key : keys) {
					out.println("<option value=\"" + key + "\">"
							+ dataForComb.get(key) + "</option>");
				}
			}
		} catch (java.io.IOException e1) {
			logApps.writeError("\n" + new Date() + ": ERROR ocurrido en writeOptions " + e1.getMessage() + " en " + e1.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e1.toString() + ":");
	    	for (StackTraceElement stack: e1.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
		}
	}

	String getNeighborStoreName(String psStoreId) {
		String lsQuery;

		lsQuery = "SELECT store_desc from ss_cat_neighbor_store WHERE store_id="
				+ psStoreId;

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	    Clean old values in op_grl_step_transfer
	 */
	void cleanStepTransfer() {
		String lsQuery;

		lsQuery = "DELETE FROM op_grl_step_transfer";
		moAbcUtils.executeSQLCommand(lsQuery, new String[] {});
	}

	/**
	Fill the table op_grl_existence with the values of the invtran file.
	 */

	void loadCurrentExistence(boolean allowNegatives) {
		Inventory inventory;
		LinkedHashMap loHashmap;
		ArrayList loValues;
		Iterator loIterator;
		String lsQuery;
		String lsYear, lsPeriod, lsWeek, lsToleranceDate;

		try {
			//Clean old values
			lsQuery = "DELETE FROM op_grl_local_existence";
			moAbcUtils.executeSQLCommand(lsQuery, new String[] {});
			lsYear = getCurrentYear();
			lsPeriod = getCurrentPeriod();
			lsWeek = getCurrentWeek();

			lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
			if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
				lsQuery = "SELECT now() < date_id FROM op_grl_set_date";
				if (moAbcUtils.queryToString(lsQuery).equals("t")) {// Si la hora es menor a la hora tolerada
					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYYY-MM-DD') FROM op_grl_set_date";
					lsToleranceDate = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT year_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsYear = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT period_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsPeriod = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT week_no - minor_week('" + lsYear + "', '"
							+ lsPeriod
							+ "') + 1 FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsWeek = moAbcUtils.queryToString(lsQuery);
				}
			}

			lsQuery = "INSERT INTO op_grl_local_existence VALUES(?,?)";
			inventory = new Inventory(lsYear.substring(2), Str.padZero(
					lsPeriod, 2), lsWeek);
			loHashmap = inventory.getExistence(false); // only values 
			loIterator = loHashmap.keySet().iterator();
			loValues = new ArrayList(loHashmap.size());

			while (loIterator.hasNext()) {
				String lsInvId = (String) loIterator.next();
				Double loQuantity = (Double) loHashmap.get(lsInvId);
				/*
				Version original:
				String lsQuantity = Str.getFormatted("%.2f", loQuantity.doubleValue());
				 */
				String lsQuantity = loQuantity.toString();
				//logApps.writeInfo("lsInvId: " + lsInvId + ", lsQuantity: "
				//	+ lsQuantity);

				if (allowNegatives)
					loValues.add(new String[] { lsInvId, lsQuantity });
				else if (loQuantity.doubleValue() >= 0)
					loValues.add(new String[] { lsInvId, lsQuantity });
			}
			moAbcUtils.executeSQLCommand(lsQuery, loValues);
		} catch (Exception ex) {
			logApps.writeError("\n" + new Date() + ": Exception loadCurrentExistence() " + ex.getMessage() + " en " + ex.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + ex.toString() + ":");
	    	for (StackTraceElement stack: ex.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
		}
	}

	void loadFCurrentExistence(boolean allowNegatives) {
		Inventory inventory;
		LinkedHashMap loHashmap;
		ArrayList loValues;
		Iterator loIterator;
		String lsQuery;
		String lsYear, lsPeriod, lsWeek, lsToleranceDate;

		try {
			//Clean old values
			lsQuery = "DELETE FROM op_grl_existence";
			moAbcUtils.executeSQLCommand(lsQuery, new String[] {});
			lsYear = getCurrentYear();
			lsPeriod = getCurrentPeriod();
			lsWeek = getCurrentWeek();

			lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
			if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
				lsQuery = "SELECT now() < date_id FROM op_grl_set_date";
				if (moAbcUtils.queryToString(lsQuery).equals("t")) {// Si la hora es menor a la hora tolerada
					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYYY-MM-DD') FROM op_grl_set_date";
					lsToleranceDate = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT year_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsYear = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT period_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsPeriod = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT week_no - minor_week('" + lsYear + "', '"
							+ lsPeriod
							+ "') + 1 FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsWeek = moAbcUtils.queryToString(lsQuery);
				}
			}

			lsQuery = "INSERT INTO op_grl_existence VALUES(?,?)";
			inventory = new Inventory(lsYear.substring(2), Str.padZero(
					lsPeriod, 2), lsWeek);
			loHashmap = inventory.getExistence(false); // only values 
			loIterator = loHashmap.keySet().iterator();
			loValues = new ArrayList(loHashmap.size());

			while (loIterator.hasNext()) {
				String lsInvId = (String) loIterator.next();
				Double loQuantity = (Double) loHashmap.get(lsInvId);
				/*
				Version original:
				String lsQuantity = Str.getFormatted("%.2f", loQuantity.doubleValue());
				 */
				String lsQuantity = loQuantity.toString();
				//logApps.writeInfo("lsInvId: " + lsInvId + ", lsQuantity: "
				//	+ lsQuantity);

				if (allowNegatives)
					loValues.add(new String[] { lsInvId, lsQuantity });
				else if (loQuantity.doubleValue() >= 0)
					loValues.add(new String[] { lsInvId, lsQuantity });
			}
			moAbcUtils.executeSQLCommand(lsQuery, loValues);
		} catch (Exception e) {
			logApps.writeError("\n" + new Date() + ": Exception loadFCurrentExistence() " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
		}
	}

	/**
	    Fill the table op_grl_suggested_transfer with the calculated values of
	    suggested for the next week.
	 */
	void loadSuggestedTransfer(int piNumDays) {
		Calendar calendar;
		ProcessInterface loProcessInterface;
		java.text.DateFormat loDateFormat;
		String lsCurrDate, lsQuery;
		calendar = Calendar.getInstance();
		calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR)
				+ piNumDays);

		lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
		if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
			lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYMMDD') FROM op_grl_set_date";
			lsCurrDate = moAbcUtils.queryToString(lsQuery);
		} else {
			loDateFormat = new java.text.SimpleDateFormat("yyMMdd");
			lsCurrDate = loDateFormat.format(calendar.getTime());
		}
		try {
			String lsCommand = "/usr/bin/ph/databases/transfers/bin/suggested.s";
			String laCommand[] = { lsCommand, lsCurrDate };

			loProcessInterface = new ProcessInterface();
			loProcessInterface.executeProcess(laCommand);
		} catch (Exception e) {
			logApps.writeError("\n" + new Date() + ": Exception loadSuggestedTransfer() " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
		}
	}

	int getDayOfWeek() {
		String lsQuery, lsToleranceDate;
		String dayOfWeek = "";
		lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
		if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
			lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYYY-MM-DD') FROM op_grl_set_date";
			lsToleranceDate = moAbcUtils.queryToString(lsQuery);
			lsQuery = "SELECT weekday_id-1 FROM ss_cat_time WHERE date_id = '"
					+ lsToleranceDate + "'";
			dayOfWeek = moAbcUtils.queryToString(lsQuery);
		} else {
			lsQuery = "SELECT current_day()";
			dayOfWeek = moAbcUtils.queryToString(lsQuery, "", "");
		}
		logApps.writeInfo("dayOfWeek:" + dayOfWeek);
		return Integer.parseInt(dayOfWeek);
	}

	String getSDCExtension() {
		Calendar calendar = Calendar.getInstance();
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);

		String lsmonth = Integer.toString(month, 16);
		String lsday = Str.padZero(day, 2);

		String lsQuery, dayOfWeek, lsToleranceDate;
		lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
		if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
			lsQuery = "SELECT (CASE WHEN to_char((now() - time_less), 'MM') = '10' THEN 'a' "
					+ "WHEN to_char((now() - time_less), 'MM') = '11' then 'b' "
					+ "WHEN to_char((now() - time_less), 'MM') = '12' then 'c' "
					+ "ELSE SUBSTRING(to_char((now() - time_less), 'MM'),2,1) END) "
					+ "FROM op_grl_set_date ";
			lsmonth = moAbcUtils.queryToString(lsQuery);
			lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'DD') FROM op_grl_set_date ";
			lsday = moAbcUtils.queryToString(lsQuery);
		}
		logApps.writeInfo("lsmonth:" + lsmonth + "| lsday:" + lsday + "|");
		return lsmonth + lsday;
	}

	String getDexFileName(String psLocalStore) {
		String filename = psLocalStore + "dex." + getSDCExtension();

		return "/usr/fms/op/rpts/sdc_dex/" + filename;
	}

	String getDimFileName(String psLocalStore) {
		String filename = psLocalStore + "dim." + getSDCExtension();

		return "/usr/fms/op/rpts/sdc_dim/" + filename;
	}

	String getFmsFileName() {
		java.text.DateFormat loDateFormat;
		String lsCurrDate, lsFilename, lsQuery;

		loDateFormat = new java.text.SimpleDateFormat("yy-MM-dd");
		lsCurrDate = loDateFormat.format(new Date());

		lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
		if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
			lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YY-MM-DD') FROM op_grl_set_date";
			lsCurrDate = moAbcUtils.queryToString(lsQuery);
		}

		lsFilename = "/usr/bin/ph/rpcost/" + lsCurrDate + ".fms";

		logApps.writeInfo("lsFilename:" + lsFilename);
		return lsFilename;
	}

	boolean savedOutputTransfer(String psTransferId, String psLocalStore,
			String psRemoteStore) {

		Inventory inventory;
		Process process;
		java.text.DateFormat loDateFormat;
		String lsQuery, lsToleranceDate;
		String lsYear, lsPeriod, lsWeek, lsCurrDate;
		String laResult[][];
		String laInvKeys[];
		String units[];
		int dayId, weekId;
		float laTransfer[];
		String lsRecord;

		String lsTransferType = "0";
		String lsLocalStore = Str.padZero(psLocalStore, 5);
		String lsSDCFile = getDexFileName(lsLocalStore);

		try {
			FileWriter lfFileName = new FileWriter(lsSDCFile, true);
			lsYear = getCurrentYear();
			lsPeriod = getCurrentPeriod();
			lsWeek = getCurrentWeek();
			loDateFormat = new java.text.SimpleDateFormat("MMddyy");
			lsCurrDate = loDateFormat.format(new Date());
			inventory = new Inventory(lsYear.substring(2), Str.padZero(
					lsPeriod, 2), lsWeek);
			weekId = inventory.getWeekId(); // Revisar
			lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
			if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
				lsQuery = "SELECT now() < date_id FROM op_grl_set_date";
				if (moAbcUtils.queryToString(lsQuery).equals("t")) {// Si la hora es menor a la hora tolerada
					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYYY-MM-DD') FROM op_grl_set_date";
					lsToleranceDate = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT year_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsYear = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT period_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsPeriod = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT week_no - minor_week('" + lsYear + "', '"
							+ lsPeriod
							+ "') + 1 FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsWeek = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'MMDDYY') FROM op_grl_set_date";
					lsCurrDate = moAbcUtils.queryToString(lsQuery);
					lsQuery = "SELECT week_no - minor_week('" + lsYear + "', '"
							+ lsPeriod
							+ "') FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					inventory = new Inventory(lsYear.substring(2), Str.padZero(
							lsPeriod, 2), lsWeek);
					weekId = Integer
							.parseInt(moAbcUtils.queryToString(lsQuery));
				}
			}
			dayId = getDayOfWeek();

			lsQuery = "SELECT inv_id, inventory_quantity, "
					+ "upper(inventory_unit_measure) FROM op_grl_transfer_detail "
					+ "WHERE transfer_id=" + psTransferId;

			laResult = moAbcUtils.queryToMatrix(lsQuery);
			laInvKeys = new String[laResult.length];
			laTransfer = new float[laResult.length];
			units = new String[laResult.length];

			for (int rowId = 0; rowId < laResult.length; rowId++) {
				laInvKeys[rowId] = laResult[rowId][0].trim();
				laTransfer[rowId] = Float.parseFloat(laResult[rowId][1]);
				units[rowId] = laResult[rowId][2].trim();
			}

			Record records[] = inventory.findRecords(laInvKeys);

			if (records.length > 0) {
				String laRecords[] = new String[records.length];
				String lsRemoteStore = Str.padZero(psRemoteStore, 5);

				for (int rowId = 0; rowId < records.length; rowId++) {
					Record record = records[rowId];

					float currTransfers = record.getWeek(weekId).getDay(dayId)
							.getTransfers();
					float currReceipts = record.getWeek(weekId).getDay(dayId)
							.getReceipts();
					float transfers = laTransfer[rowId];
					float unitcost = record.getWeek(weekId).getSubproduct()
							.getUnitcost();

					/*Para actualizar los valores de la transferencia en el archivo de FMS*/
					records[rowId].getWeek(weekId).getDay(dayId)
							.setReceipts(currReceipts - transfers);
					records[rowId].getWeek(weekId).getDay(dayId)
							.setTransfers(currTransfers + transfers);

					/*Se guarda el archivo de transferencia en /usr/fms/op/rpts/sdc_dex/ */
					String lsCode = Str.padLeft(laInvKeys[rowId], 6);
					String lsDescrip = Str.padLeft(record.getProduct()
							.getDescription(), 21);
					String lsDate = Str.padLeft(lsCurrDate, 9);
					String lsQuantity = Str.getFormatted("%8.2f", transfers);
					String lsUnitCost = Str.getFormatted("%8.2f", unitcost);
					String lsUnitMeasure = units[rowId];
					lsRecord = lsLocalStore + "," + lsCode + "," + lsDescrip
							+ "," + lsDate + "," + lsQuantity + ","
							+ lsUnitCost + ", " + lsRemoteStore + ", "
							+ lsUnitMeasure + ", " + psTransferId;

					lfFileName.write(lsRecord);
					lfFileName.write('\n');

				}//Fin for

				lfFileName.close();
				String lsPathShell = "/usr/bin/ph/mail2222.s";
				//String laSDCCommand[] = {lsPathShell, pslsSDCFile, moAbcUtils.implodeArray("\n", laRecords)};
				String laSDCCommand[] = { lsPathShell, psTransferId,
						lsTransferType, lsRemoteStore, lsLocalStore };

				//Nueva version:
				process = Runtime.getRuntime().exec(laSDCCommand);
				//process.waitFor();

				//Se hace un backup del archivo antes de que se actualizen los valores
				inventory.backup();

				if (inventory.updateRecords(records) > 0)
					return true;
				else
					return false;
			} else
				return false;
		} catch (Exception e) {
			logApps.writeError("\n" + new Date() + ": savedOutputTransfer() & writing files exception -> " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return false;
		}
	}

	boolean savedInputTransfer(String psTransferId, String psLocalStore,
			String psRemoteStore) {
		Inventory inventory;
		Process process;
		java.text.DateFormat loDateFormat;
		String lsQuery, lsResult, lsCurrDate, lsFMSDate, lsToleranceDate, lsYear, lsPeriod;
		String laDate[];
		String laResult[][];
		String laInvKeys[];
		int dayId, weekId;
		float laTransfer[];
		String lsSDCRecord;
		String lsFmsRecord;
		String lsTransferType = "1";
		String lsLocalStore = Str.padZero(psLocalStore, 5);
		String lsFmsFile = getFmsFileName();
		String lsSDCFile = getDimFileName(lsLocalStore);

		try {
			FileWriter lfSDCFile = new FileWriter(lsSDCFile, true);
			loDateFormat = new java.text.SimpleDateFormat("yy-MM-dd");
			lsFMSDate = loDateFormat.format(new Date());

			loDateFormat = new java.text.SimpleDateFormat("MMddyy");
			lsCurrDate = loDateFormat.format(new Date());
			lsQuery = "SELECT SUBSTR(CAST(current_year() AS CHAR(4)),3), LPAD(CAST(current_period() AS CHAR(2)),2,'0'), current_week()";
			lsResult = moAbcUtils.queryToString(lsQuery, "", ",");
			laDate = lsResult.split(",");
			inventory = new Inventory(laDate[0], laDate[1], laDate[2]);
			weekId = inventory.getWeekId();
			FileWriter lfFMSFile = new FileWriter(lsFmsFile, true);

			lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
			if (moAbcUtils.queryToString(lsQuery).equals("t")) { // Si es la fecha de tolerancia
				lsQuery = "SELECT now() < date_id FROM op_grl_set_date";
				if (moAbcUtils.queryToString(lsQuery).equals("t")) {// Si la hora es menor a la hora tolerada

					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYYY-MM-DD') FROM op_grl_set_date";
					lsToleranceDate = moAbcUtils.queryToString(lsQuery);
					logApps.writeInfo("lsToleranceDate:" + lsToleranceDate
							+ "|");
					lsQuery = "SELECT year_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsYear = moAbcUtils.queryToString(lsQuery);
					logApps.writeInfo("lsYear:" + lsYear + "|");
					lsQuery = "SELECT period_no FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsPeriod = moAbcUtils.queryToString(lsQuery);
					logApps.writeInfo("lsPeriod:" + lsPeriod + "|");
					lsQuery = "SELECT week_no - minor_week('" + lsYear + "', '"
							+ lsPeriod
							+ "') FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					weekId = Integer
							.parseInt(moAbcUtils.queryToString(lsQuery));
					logApps.writeInfo("weekId:"
							+ moAbcUtils.queryToString(lsQuery) + "|");
					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'MMDDYY') FROM op_grl_set_date";
					lsCurrDate = moAbcUtils.queryToString(lsQuery);
					logApps.writeInfo("lsCurrDate:" + lsCurrDate + "|");
					lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YY-MM-DD') FROM op_grl_set_date";
					lsFMSDate = moAbcUtils.queryToString(lsQuery);
					logApps.writeInfo("lsFMSDate:" + lsFMSDate + "|");
					lsQuery = "SELECT SUBSTR(CAST(year_no AS CHAR(4)),3),LPAD(CAST(period_no AS CHAR(2)),2,'0'),week_no - minor_week(year_no, period_no) + 1 "
							+ "FROM ss_cat_time WHERE date_id = '"
							+ lsToleranceDate + "'";
					lsResult = moAbcUtils.queryToString(lsQuery, "", ",");
					laDate = lsResult.split(",");
					logApps.writeInfo("lsResult:" + laDate[0] + "|"
							+ laDate[1] + "|" + laDate[2] + "|");
					inventory = new Inventory(laDate[0], laDate[1], laDate[2]);
				}
			}

			dayId = getDayOfWeek();

			lsQuery = "SELECT inv_id, inventory_quantity "
					+ "FROM op_grl_transfer_detail WHERE transfer_id="
					+ psTransferId;

			laResult = moAbcUtils.queryToMatrix(lsQuery);
			laInvKeys = new String[laResult.length];
			laTransfer = new float[laResult.length];

			for (int rowId = 0; rowId < laResult.length; rowId++) {
				laInvKeys[rowId] = laResult[rowId][0].trim();
				laTransfer[rowId] = Float.parseFloat(laResult[rowId][1]);
			}

			Record records[] = inventory.findRecords(laInvKeys);

			if (records.length > 0) {
				String laSDCRecords[] = new String[records.length];
				String laFmsRecords[] = new String[records.length];
				String lsRemoteStore = Str.padZero(psRemoteStore, 5);

				for (int rowId = 0; rowId < records.length; rowId++) {
					Record record = records[rowId];

					float transfers = laTransfer[rowId];
					float unitcost = record.getWeek(weekId).getSubproduct()
							.getUnitcost();

					//Para el archivo de transferencias en sdc_dim
					String lsCode = Str.padLeft(laInvKeys[rowId], 6);
					String lsDescrip = Str.padLeft(record.getProduct()
							.getDescription(), 21);
					String lsDate = Str.padLeft(lsCurrDate, 9);
					String lsQuantity = Str.getFormatted("%8.2f", transfers);
					String lsUnitCost = Str.getFormatted("%8.2f", unitcost);

					lsSDCRecord = lsLocalStore + "," + lsCode + "," + lsDescrip
							+ "," + lsDate + "," + lsQuantity + ","
							+ lsUnitCost + "," + lsRemoteStore + ", "
							+ psTransferId;
					lfSDCFile.write(lsSDCRecord);
					lfSDCFile.write('\n');

					//Para el archivo .fms en rpcost
					lsCode = Str.padLeft(laInvKeys[rowId], 5);
					lsQuantity = Str.getFormatted("%9.2f", transfers);
					lsUnitCost = Str.getFormatted("%15.2f", unitcost);

					lsFmsRecord = lsCode + "," + lsFMSDate + "," + lsQuantity
							+ "," + lsLocalStore + "," + lsUnitCost + ", "
							+ lsRemoteStore + ",";
					lfFMSFile.write(lsFmsRecord);
					lfFMSFile.write('\n');
				}//Fin for
				lfSDCFile.close();
				lfFMSFile.close();

				String lsPathShell = "/usr/bin/ph/mail2222.s";
				String laSDCCommand[] = { lsPathShell, psTransferId,
						lsTransferType, lsRemoteStore, lsLocalStore };

				//Nueva version:
				process = Runtime.getRuntime().exec(laSDCCommand);
				//process.waitFor();

				//Se hace un backup del archivo antes de que se actualizen los valores
				inventory.backup();

				// Para actualizar el archivo de inventario. 
				//Que se lean los archivos .fms en /usr/bin/ph/rpcost/
				String laPFSCommand[] = { "/usr/local/tomcat/webapps/ROOT/Scripts/upd_invtran.s" };
				process = Runtime.getRuntime().exec(laPFSCommand);
				//process.waitFor();

				return true;
			} else
				return false;
		} catch (Exception e) {
			logApps.writeError("\n" + new Date() + ": savedInputTransfer() exception " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return false;
		}
	}

	/**  Obtiene un ID para la transferencia
	 */
	String getTransferId() {
		return moAbcUtils.queryToString(
				"SELECT max(transfer_id)+1 from op_grl_confirm_transfer", "",
				"");
	}

	/**
	 */
	String getTransferIdF() {
		return moAbcUtils.queryToString("SELECT nextval('transfer_seq')", "",
				"");
	}

	/**
	    Obtiene el tipo de una transferencia:
	    input: transferencia de entrada
	    output: transferencia de salida
	 */
	String getTransferType(String psTransferId) {
		String lsQuery;

		lsQuery = "SELECT CASE WHEN(transfer_type=1) THEN 'input' ELSE"
				+ "'output' END FROM op_grl_transfer WHERE transfer_id="
				+ psTransferId;

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	    Obtiene la fecha de una transferencia
	 */
	String getTransferDate(String psTransferId) {
		String lsQuery;

		lsQuery = "SELECT COUNT(*) FROM op_grl_confirm_transfer WHERE transfer_id="
				+ psTransferId;
		String countTransfers = moAbcUtils.queryToString(lsQuery);
		String loTableTransfer = Integer.parseInt(countTransfers) > 0 ? "op_grl_confirm_transfer"
				: "op_grl_transfer";

		lsQuery = "SELECT date_id FROM " + loTableTransfer
				+ " WHERE transfer_id=" + psTransferId;
		logApps.writeInfo("\ngetTransferDate.lsQuery: " + lsQuery);

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	Obtiene la fecha de una fransferencia
	 */
	String getFTransferDate(String psTransferId) {
		String lsQuery;

		lsQuery = "SELECT date_id FROM op_grl_transfer WHERE transfer_id="
				+ psTransferId;

		return moAbcUtils.queryToString(lsQuery);
	}

	String getNeighborStores() {
		String lsQuery;

		lsQuery = "SELECT ltrim(rtrim(store_id)), store_desc FROM ss_cat_neighbor_store "
				+ "ORDER BY store_desc asc ";

		return lsQuery;
	}

	String getDateTime() {
		String lsDate = "";
		String lsQry = "";
		Date ldToday = new Date();
		String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
		int liMonth = (int) ldToday.getMonth();
		int liDay = (int) ldToday.getDate();
		java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(
				DATE_FORMAT);
		Calendar lsC1 = Calendar.getInstance();
		lsC1.set(1900 + (int) ldToday.getYear(), (liMonth), liDay);
		lsDate = lsDF.format(lsC1.getTime());

		lsQry = "SELECT DATE'" + lsDate + "' = date_limit FROM op_grl_set_date";
		if (moAbcUtils.queryToString(lsQry).equals("t")) {// Si la fecha es la misma
			lsQry = "SELECT TIMESTAMP'" + lsDate
					+ "' < date_id FROM op_grl_set_date";
			if (moAbcUtils.queryToString(lsQry).equals("t")) {// Si la hora es menor a la hora tolerada
				lsQry = "SELECT TIMESTAMP'" + lsDate
						+ "' - time_less FROM op_grl_set_date";
				lsDate = moAbcUtils.queryToString(lsQry);
			}
		}
		return (lsDate);
	}

	/**
	    Obtiene el Id para la transferencia de paso
	 */
	String getStepTransferId() {
		String lsQuery;

		lsQuery = "SELECT transfer_id FROM op_grl_step_transfer";

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	    Obtiene el ID-NOMBRE del restaurante al que se hace la transferencia
	 */
	String getRemoteStore(String psTransferId) {

		String lsQuery;

		lsQuery = "SELECT COUNT(*) FROM op_grl_confirm_transfer WHERE transfer_id="
				+ psTransferId;
		String countTransfers = moAbcUtils.queryToString(lsQuery);
		String loTableTransfer = Integer.parseInt(countTransfers) > 0 ? "op_grl_confirm_transfer"
				: "op_grl_transfer";

		lsQuery = "SELECT store_id || '-' || store_desc FROM ss_cat_neighbor_store, "
				+ loTableTransfer
				+ " WHERE ss_cat_neighbor_store.store_id = "
				+ loTableTransfer
				+ ".neighbor_store_id AND transfer_id = "
				+ psTransferId;

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	Obtiene el ID-NOMBRE del restaurante al que se hace la Fransferencia
	 */
	String getFRemoteStore(String psTransferId) {

		String lsQuery;

		lsQuery = "SELECT store_id || '-' || store_desc FROM ss_cat_neighbor_store, "
				+ "op_grl_transfer WHERE ss_cat_neighbor_store.store_id = "
				+ "op_grl_transfer.neighbor_store_id AND transfer_id = "
				+ psTransferId;

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	    Obtiene el ID-NOMBRE del restaurante que hace la transferencia
	 */
	String getLocalStore(String psTransferId) {

		String lsQuery;
		lsQuery = "SELECT COUNT(*) FROM op_grl_confirm_transfer WHERE transfer_id="
				+ psTransferId;
		String countTransfers = moAbcUtils.queryToString(lsQuery);
		String loTableTransfer = Integer.parseInt(countTransfers) > 0 ? "op_grl_confirm_transfer"
				: "op_grl_transfer";

		lsQuery = "SELECT store_id || '-' || store_desc FROM ss_cat_store, "
				+ loTableTransfer + " WHERE ss_cat_store.store_id = "
				+ loTableTransfer + ".local_store_id AND transfer_id = "
				+ psTransferId;

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
	Obtiene el ID-NOMBRE del restaurante que hace la Fransferencia
	 */
	String getFLocalStore(String psTransferId) {

		String lsQuery;

		lsQuery = "SELECT store_id || '-' || store_desc FROM ss_cat_store, "
				+ "op_grl_transfer WHERE ss_cat_store.store_id = "
				+ "op_grl_transfer.local_store_id AND transfer_id = "
				+ psTransferId;

		return moAbcUtils.queryToString(lsQuery);
	}

	void saveTransfer(String psTransferId) {

		String lsQuery;

		//lsQuery = "DELETE FROM op_grl_transfer WHERE transfer_id=?";
		//moAbcUtils.executeSQLCommand(lsQuery, new String[]{psTransferId});

		lsQuery = "INSERT INTO op_grl_transfer SELECT * FROM op_grl_step_transfer "
				+ "WHERE transfer_id=?";
		lsQuery = "INSERT INTO op_grl_transfer (SELECT transfer_id, local_store_id, neighbor_store_id, date_id,transfer_type,transfer_id,responsible FROM op_grl_step_transfer WHERE transfer_id=?)";
		moAbcUtils.executeSQLCommand(lsQuery, new String[] { psTransferId });

		lsQuery = "INSERT INTO op_grl_transfer_detail SELECT * FROM op_grl_step_transfer_detail "
				+ "WHERE transfer_id=?";
		moAbcUtils.executeSQLCommand(lsQuery, new String[] { psTransferId });
	}

	String getTransferDetailQuery() {
		return getTransferDetailQuery(false);
	}

	String getTransferDetailQuery(boolean step) {
		if (Boolean.valueOf(isFranq())) {
			return getFTransferDetailQuery(step, null);
		} else {
			return getTransferDetailQuery(step, null);
		}
	}

	/*
	OBTIENE el query para obtener el detalle de la transferencia
	 */
	String getTransferDetailQuery(boolean step, String psTransferId) {
		String lsTransferTable, lsQuery;

		lsTransferTable = (step == true) ? "op_grl_step_transfer_detail"
				: "op_grl_confirm_transfer_detail";

		if (lsTransferTable.equals("op_grl_confirm_transfer_detail")) {
			lsQuery = "SELECT COUNT(*) FROM op_grl_confirm_transfer WHERE transfer_id="
					+ psTransferId;
			String countTransfers = moAbcUtils.queryToString(lsQuery);
			lsTransferTable = Integer.parseInt(countTransfers) > 0 ? lsTransferTable
					: "op_grl_transfer_detail";
		}

		lsQuery = "SELECT DISTINCT t.inv_id, prod.provider_product_code, "
				+ "prov.name, inv.inv_desc, prod.provider_product_desc, "
				+ "ROUND(CAST(t.existence AS numeric),2)||' '||t.inventory_unit_measure AS existence, "
				+ "ROUND((t.inventory_quantity / t.prv_conversion_factor) ,2) || ' ' || t.provider_unit_measure AS provider_quantity, "
				+ "t.inventory_quantity || ' ' || t.inventory_unit_measure AS inventory_quantity, "
				+ "'Total Transfer', ROUND(CAST(lpe.quantity  AS numeric),2)||' '||t.inventory_unit_measure AS existence,"
				+ "s.required || ' ' || substr(t.inventory_unit_measure,1,4) AS required_quantity, "
				+ "t.inventory_unit_measure, t.provider_unit_measure, t.prv_conversion_factor, "
				+ "prod.stock_code_id, prod.provider_id "
				+ "FROM "
				+ lsTransferTable
				+ " t INNER JOIN op_grl_cat_providers_product prod "
				+ "ON (t.inv_id = prod.inv_id AND t.provider_product_code = prod.provider_product_code "
				+ "AND t.provider_id = prod.provider_id ) "
				+ "INNER JOIN op_grl_cat_provider prov "
				+ "ON (prod.provider_id = prov.provider_id) "
				+ "INNER JOIN op_grl_cat_inventory inv ON (inv.inv_id = prod.inv_id) "
				+ "INNER JOIN op_grl_local_existence lpe ON (lpe.inv_id = prod.inv_id) "
				+ "LEFT JOIN op_grl_suggested_transfer s ON (t.inv_id = s.inv_id) "
				+ "WHERE prod.active_flag IN(1,2) ";
		
		lsQuery = "SELECT DISTINCT t.inv_id, "
                + "t.inv_id, "
                + "inv.inv_desc, "
                + "ROUND(0,2) || ' ' || t.inventory_unit_measure AS provider_quantity, "
                + "ROUND(CAST(t.existence AS numeric),2)||' '||t.inventory_unit_measure AS existence, "
                + "t.inventory_quantity || ' ' || t.inventory_unit_measure AS inventory_quantity, "
                + "ROUND(CAST(lpe.quantity AS numeric),2)||' '||t.inventory_unit_measure AS existence, "
                + "t.inventory_unit_measure, "
                + "t.provider_unit_measure, "
                + "t.prv_conversion_factor, "
                + "'', "
                + "'' "
                + "FROM "  + lsTransferTable + " t "
                + "INNER JOIN (select distinct inv_id as inv_id from op_grl_cat_providers_product where active_flag <> 0 )prov ON (t.inv_id = prov.inv_id) "
                + "INNER JOIN op_grl_cat_inventory inv ON (inv.inv_id = t.inv_id) "
                + "INNER JOIN op_grl_local_existence lpe ON (lpe.inv_id = t.inv_id) ";
                //+ "LEFT JOIN op_grl_suggested_transfer s ON (t.inv_id = s.inv_id) ";

		if (psTransferId != null)
			lsQuery += " AND t.transfer_id=" + psTransferId;

		lsQuery += " ORDER BY t.inv_id ASC ";

		logApps.writeInfo("Query a ejecutar para busqueda de detalle:\n"
				+ lsQuery + "\n");

		return lsQuery;
	}

	/*
	OBTIENE el query para obtener el detalle de la Fransferencia
	 */
	String getFTransferDetailQuery(boolean step, String psTransferId) {
		String lsTransferTable, lsQuery;

		lsTransferTable = (step == true) ? "op_grl_step_transfer_detail"
				: "op_grl_transfer_detail";

		lsQuery = "SELECT DISTINCT t.inv_id, prod.provider_product_code, "
				+ "prov.name, prod.provider_product_desc, "
				+ "ROUND(CAST(t.existence AS numeric),2)||' '||t.inventory_unit_measure AS existence, "
				+ "t.provider_quantity  || ' ' || t.provider_unit_measure AS provider_quantity, "
				+ "t.inventory_quantity || ' ' || t.inventory_unit_measure AS inventory_quantity, "
				+ "'Total Transfer', 'Final Existence', "
				+ "s.required || ' ' || substr(t.inventory_unit_measure,1,4) AS required_quantity, "
				+ "t.inventory_unit_measure, t.provider_unit_measure, t.prv_conversion_factor, "
				+ "prod.stock_code_id, prod.provider_id "
				+ "FROM "
				+ lsTransferTable
				+ " t INNER JOIN op_grl_cat_providers_product prod "
				+ "ON (t.inv_id = prod.inv_id AND t.provider_product_code = prod.provider_product_code "
				+ "AND t.provider_id = prod.provider_id ) "
				+ "INNER JOIN op_grl_cat_provider prov "
				+ "ON (prod.provider_id = prov.provider_id) "
				+ "LEFT JOIN op_grl_suggested_transfer s ON (t.inv_id = s.inv_id) "
				+ "WHERE prod.active_flag IN(1,2) ";

		if (psTransferId != null)
			lsQuery += " AND t.transfer_id=" + psTransferId;

		lsQuery += " ORDER BY provider_product_desc ASC ";

		return lsQuery;
	}

	/**
	Obtiene el query para seleccionar los productos
	 */
	String getChooseProductsQuery(String psTransferType, String psInvId,
			String psIPNStore) {
		String lsQuery;

		//lsQuery = "SELECT DISTINCT i.inv_id, prod.provider_product_code, " Original
				//+ "RTRIM(prov.name), RTRIM(i.inv_desc), prod.provider_product_desc, ";
		lsQuery = "SELECT DISTINCT i.inv_id, i.inv_id,"
				+ "RTRIM(i.inv_desc), ";
		if (psIPNStore.equals("localhost")) {
			lsQuery += "9999 AS current_existence, ";
		} else {
			lsQuery += "ROUND(CAST(e.quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4) AS current_existence, ";
		}
		
		lsQuery += "'0' AS provider_quantity, '0' AS inventory_quantity, " 
                + "ROUND(CAST(dbl.quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4),"
                + "s.required || ' ' || substr(ium.unit_name,1,4) AS required_quantity,"
                + "substr(ium.unit_name,1,4) ";
		if (psIPNStore.equals("NA") || psIPNStore.equals("")) {
			lsQuery += "FROM op_grl_cat_inventory i INNER JOIN op_grl_local_existence e ";
		} else {
			lsQuery += "FROM op_grl_cat_inventory i INNER JOIN op_grl_existence e ";
		}
		lsQuery += "ON (i.inv_id = e.inv_id and e.quantity > 0) "
				+ "INNER JOIN (select distinct inv_id from op_grl_cat_providers_product where active_flag <> 0 order by 1) prod ON (i.inv_id = prod.inv_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) "
				+ "LEFT JOIN op_grl_suggested_transfer s ON (i.inv_id = s.inv_id) ";

		lsQuery += " AND i.inv_id NOT IN ( '" + psInvId + "') ";
		lsQuery += "INNER JOIN (select * from dblink('hostaddr="
				+ getLocalIP()
				+ " dbname=dbeyum user=postgres','SELECT lprv.inv_id, provider_product_code, provider_id, isnull(quantity,0.0)"
				+ "FROM op_grl_cat_providers_product lprv inner join op_grl_local_existence lexist ON (lprv.inv_id=lexist.inv_id) "
				+ "WHERE active_flag IN (1,2)') as a (inv_id character(6),provider_product_code character(10), "
				+ "provider_id character(10), quantity double precision)) dbl on (prod.inv_id = dbl.inv_id)";

		if (psTransferType.equals("input")){
			//lsQuery += "WHERE prod.active_flag IN (1,2) ORDER BY provider_product_desc ASC ";
			lsQuery += "ORDER BY 2 ASC ";
		}

		if (psTransferType.equals("output")){
			//lsQuery += "WHERE prod.active_flag IN (1,2) AND e.quantity > 0 ORDER BY provider_product_desc ASC ";
			lsQuery += "WHERE e.quantity > 0 ORDER BY 2 ASC";
		}

		return lsQuery;
	}

	/**
	Obtiene el query para seleccionar los productos en franquicia
	 */
	String getFChooseProductsQuery(String psTransferType, String psInvId) {
		String lsQuery;

		lsQuery = "SELECT DISTINCT i.inv_id, prod.provider_product_code, "
				+ "prov.name, prod.provider_product_desc, "
				+ "ROUND(CAST(e.quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4) AS current_existence, "
				+ "'0' AS provider_quantity, '0' AS inventory_quantity, "
				+ "'Total Transfer', 'Final Existence', "
				+ "s.required || ' ' || substr(ium.unit_name,1,4) AS required_quantity, "
				+ "substr(ium.unit_name,1,4), substr(pum.unit_name,1,4), prod.conversion_factor, "
				+ "prod.stock_code_id, prod.provider_id "
				+ "FROM op_grl_cat_inventory i INNER JOIN op_grl_existence e "
				+ "ON (i.inv_id = e.inv_id) "
				+ "INNER JOIN op_grl_cat_providers_product prod "
				+ "ON (i.inv_id = prod.inv_id) "
				+ "INNER JOIN op_grl_cat_provider prov "
				+ "ON (prod.provider_id = prov.provider_id) "
				+ "INNER JOIN op_grl_cat_unit_measure pum ON (prod.provider_unit_measure = pum.unit_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) "
				+ "LEFT JOIN op_grl_suggested_transfer s ON (i.inv_id = s.inv_id) "
				+ "WHERE prod.active_flag IN (1,2) ";

		if (psTransferType.equals("input"))
			lsQuery += " AND i.inv_id NOT IN ( '" + psInvId + "') ";

		if (psTransferType.equals("output"))
			lsQuery += " AND i.inv_id NOT IN ( '" + psInvId
					+ "') AND e.quantity > 0 ";

		lsQuery += " ORDER BY provider_product_desc ASC ";

		return lsQuery;
	}
	
	/*
	
	*/
	
	String getChooseCapAndBasket(){
		String lsQuery="SELECT DISTINCT i.inv_id,"
                + "i.inv_id,"
                + "RTRIM(i.inv_desc),"
                + "ROUND(CAST(e.quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4) AS current_existence, "
                + "'0' AS provider_quantity, "
           		+ "'0' AS inventory_quantity, "
           		+ "ROUND(CAST(e.quantity AS numeric), 2) || ' ' || substr(ium.unit_name, 1, 4), "
           		+ "'0 ' || substr(ium.unit_name, 1, 4) AS required_quantity, "
           		+ "substr(ium.unit_name, 1, 4) "
   				+ "FROM op_grl_cat_inventory i "
				+ "INNER JOIN op_grl_local_existence e ON (i.inv_id = e.inv_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id)"
				+ "AND i.inv_id IN ('11710','11711')";
		return lsQuery;
	}

	String getSelectedItems(HttpServletRequest poRequest) {
		Enumeration loParameters = poRequest.getParameterNames();
		String lsInvId = "";
		while (loParameters.hasMoreElements()) {
			String lsParamName = (String) loParameters.nextElement();

			if (lsParamName.indexOf("chkRowControl") != -1) {
				String lsRowId = lsParamName
						.substring(lsParamName.indexOf('|') + 1);
				lsInvId += poRequest.getParameter("chkRowControl|" + lsRowId)
						+ ",";
			}
		}
		lsInvId += "-1";

		return lsInvId;
	}

	/* Method used in TransferPreview */

	void insertItems(HttpServletRequest poRequest, String psLocalStoreId,
			String psRemoteStoreId, String psTransferType) {
		String lsTransferId = isFranq().equals("true") ? getTransferIdF()
				: getTransferId();
		String lsLocalSid = (psLocalStoreId != null) ? psLocalStoreId
				: getStoreId(); //Local Store Id
		String lsTransferType = psTransferType; //0 Transf salida 1 Transf Entrada
		String lsNeighborSid = (psRemoteStoreId != null) ? psRemoteStoreId
				: poRequest.getParameter("hidNeighborStore"); //Neighbor Store Id
		String lsDateId = getDateTime();
		String lsUser = poRequest.getParameter("hidUser");
		if (lsUser == null) {
			lsUser = "Maquina de franquicia";
		} else {
			lsUser = lsUser.replace(" ", "_");
			lsUser = lsUser.length() > 30 ? lsUser.substring(0, 30) : lsUser;
		}
		lsUser = stripAccents(lsUser);
		logApps.writeInfo("hidUser: " + lsUser);

		/*Se inserta el maestro de la transferencia*/
		String lsQuery = "INSERT INTO op_grl_step_transfer VALUES(?,?,?,?,?,?)";
		logApps.writeInfo("Insertando los valores de op_grl_step_transfer:\n\tlsTransferId: [" + lsTransferId + "]");
		logApps.writeInfo("\tlsLocalSid: [" + lsLocalSid + "]\n\tlsNeighborSid: [" + lsNeighborSid + "]");
		logApps.writeInfo("\tlsDateId: [" + lsDateId + "]\n\tlsTransferType: [" + lsTransferType + "]");
		logApps.writeInfo("\tlsUser: [" + lsUser + "]");
		moAbcUtils.executeSQLCommand(lsQuery, new String[] { lsTransferId,
				lsLocalSid, lsNeighborSid, lsDateId, lsTransferType, lsUser });

		/*Se insertan el detalle de la transferencia
		transfer_id            | integer          | not null
		inv_id                 | character(6)     | not null
		stock_code_id          | character(6)     | not null
		provider_product_code  | character(10)    |
		provider_quantity      | numeric(12,2)    | not null default 0
		inventory_quantity     | numeric(12,2)    | not null default 0
		prv_conversion_factor  | numeric(12,2)    | not null default 0
		provider_unit_measure  | character(50)    |
		inventory_unit_measure | character(50)    |
		provider_id            | character(10)    |
		existence              | double precision |
		 */

		lsQuery = "INSERT INTO op_grl_step_transfer_detail VALUES(?,?,?,?,?,?,?,?,?,?,?)";

		// 		logApps.writeInfo("loParameters: [" + poRequest.getParameterNames().nextElement()
		// 				+ "]");
		Enumeration loParameters = poRequest.getParameterNames();
		try {
			while (loParameters.hasMoreElements()) {
				String lsParamName = (String) loParameters.nextElement();
				logApps.writeInfo("lsParamName: [" + lsParamName + "]");

				if (lsParamName.indexOf("chkRowControl") != -1) {
					String lsRowId = lsParamName.substring(lsParamName
							.indexOf('|') + 1);

					String lsPrvQty = poRequest.getParameter("providerQty|"
							+ lsRowId);
					String lsInvQty = poRequest.getParameter("inventoryQty|"
							+ lsRowId);
					String lsInvId = poRequest.getParameter("chkRowControl|"
							+ lsRowId);
					String lsPfc = poRequest.getParameter("providerFc|"
							+ lsRowId); //Factor conversion prov
					String lsPum = poRequest.getParameter("providerUm|"
							+ lsRowId); //Provider unit measure
					String lsIum = poRequest.getParameter("inventoryUm|"
							+ lsRowId); //Inventory unit measure
					String lsStockId = poRequest.getParameter("stock_code_id|"
							+ lsRowId);
					String lsProvPro = poRequest
							.getParameter("provider_product_code|" + lsRowId);
					String lsProvId = poRequest.getParameter("provider_id|"
							+ lsRowId);
					String lsExisten = poRequest.getParameter("existence|"
							+ lsRowId);

					lsPrvQty = lsPrvQty.substring(0, lsPrvQty.indexOf(" "));
					if(!lsPrvQty.matches("[-+]?\\d*\\.?\\d+")){
						lsPrvQty= "0.0";
					}
					lsInvQty = lsInvQty.substring(0, lsInvQty.indexOf(" "));
					lsPum = lsPum.trim();
					lsIum = lsIum.trim();

					logApps.writeInfo("lsTransferId: [" + lsTransferId
							+ "], lsInvId: [" + lsInvId + "], lsStockId:["
							+ lsStockId + "], lsProvPro: [" + lsProvPro + "],"
							+ "lsPrvQty: [" + lsPrvQty + "], lsInvQty:["
							+ lsInvQty + "], lsPfc:[" + lsPfc + "], lsPum["
							+ lsPum + "], lsIum:[" + lsIum + "], lsProvId:["
							+ lsProvId + "],lsExisten:[" + lsExisten + "]");

					moAbcUtils.executeSQLCommand(lsQuery, new String[] {
							lsTransferId, lsInvId, lsStockId, lsProvPro,
							lsPrvQty, lsInvQty, lsPfc, lsPum, lsIum, lsProvId,
							lsExisten });
				}
			}
		} catch (Exception e) {
			logApps.writeError("\n" + new Date() + ": Exception insertItems() " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return;
		}
	}//Fin metodo

	/* Method used in TransferPreview en Franquicias*/

	void insertItemsF(HttpServletRequest poRequest, String psLocalStoreId,
			String psRemoteStoreId, String psTransferType) {
		String lsTransferId = isFranq().equals("true") ? getTransferIdF()
				: getTransferId();
		String lsLocalSid = (psLocalStoreId != null) ? psLocalStoreId
				: getStoreId(); //Local Store Id
		String lsTransferType = psTransferType; //0 Transf salida 1 Transf Entrada
		String lsNeighborSid = (psRemoteStoreId != null) ? psRemoteStoreId
				: poRequest.getParameter("hidNeighborStore"); //Neighbor Store Id
		String lsDateId = getDateTime();

		/*Se inserta el maestro de la transferencia*/
		String lsQuery = "INSERT INTO op_grl_step_transfer VALUES(?,?,?,?,?)";
		moAbcUtils.executeSQLCommand(lsQuery, new String[] { lsTransferId,
				lsLocalSid, lsNeighborSid, lsDateId, lsTransferType });

		/*Se insertan el detalle de la transferencia
		transfer_id            | integer          | not null
		inv_id                 | character(6)     | not null
		stock_code_id          | character(6)     | not null
		provider_product_code  | character(10)    |
		provider_quantity      | numeric(12,2)    | not null default 0
		inventory_quantity     | numeric(12,2)    | not null default 0
		prv_conversion_factor  | numeric(12,2)    | not null default 0
		provider_unit_measure  | character(50)    |
		inventory_unit_measure | character(50)    |
		provider_id            | character(10)    |
		existence              | double precision |
		 */

		lsQuery = "INSERT INTO op_grl_step_transfer_detail VALUES(?,?,?,?,?,?,?,?,?,?,?)";

		Enumeration loParameters = poRequest.getParameterNames();

		while (loParameters.hasMoreElements()) {
			String lsParamName = (String) loParameters.nextElement();

			if (lsParamName.indexOf("chkRowControl") != -1) {
				String lsRowId = lsParamName
						.substring(lsParamName.indexOf('|') + 1);

				String lsPrvQty = poRequest.getParameter("providerQty|"
						+ lsRowId);
				String lsInvQty = poRequest.getParameter("inventoryQty|"
						+ lsRowId);
				String lsInvId = poRequest.getParameter("chkRowControl|"
						+ lsRowId);
				String lsPfc = poRequest.getParameter("providerFc|" + lsRowId); //Factor conversion prov
				String lsPum = poRequest.getParameter("providerUm|" + lsRowId); //Provider unit measure
				String lsIum = poRequest.getParameter("inventoryUm|" + lsRowId); //Inventory unit measure
				String lsStockId = poRequest.getParameter("stock_code_id|"
						+ lsRowId);
				String lsProvPro = poRequest
						.getParameter("provider_product_code|" + lsRowId);
				String lsProvId = poRequest.getParameter("provider_id|"
						+ lsRowId);
				String lsExisten = poRequest.getParameter("existence|"
						+ lsRowId);

				lsPrvQty = lsPrvQty.substring(0, lsPrvQty.indexOf(" "));
				lsInvQty = lsInvQty.substring(0, lsInvQty.indexOf(" "));
				lsPum = lsPum.trim();
				lsIum = lsIum.trim();

				moAbcUtils.executeSQLCommand(lsQuery, new String[] {
						lsTransferId, lsInvId, lsStockId, lsProvPro, lsPrvQty,
						lsInvQty, lsPfc, lsPum, lsIum, lsProvId, lsExisten });
			}
		}
	}//Fin metodo

	/*  Metodo utilizado en TransferDetail.
	    Se utiliza principalmente para determinar si se calcula o no la
	    existencia en inventario */

	String getDataset(int transferExists) {
		return getDataset(transferExists, false);
	}

	String getDataset(int transferExists, boolean allowNegatives) {
		String dataset;

		if (isFranq().equals("true")) {
			loadFCurrentExistence(allowNegatives);
		} else {
			loadCurrentExistence(allowNegatives);
		}
		switch (transferExists) {
		//Existen datos en la tabla de paso.
		case 1:
			dataset = moAbcUtils.getJSResultSet(getTransferDetailQuery(true)); //true->tabla de paso
			break;
		//Se inicia una transferencia. Es el unico caso en que se calcula existencia.
		case 0:
			cleanStepTransfer();
			dataset = "new Array()";
			break;
		//Se "limpia" TransferDetail
		case 2:
			dataset = "new Array()";
			break;
		default:
			dataset = "new Array()";
		}

		return dataset;
	}

	boolean inputTransferOK(String psTransferId, String psLocalStore,
			String psRemoteStore) {
		return transferOK(psTransferId, psLocalStore, psRemoteStore, true);
	}

	boolean outputTransferOK(String psTransferId, String psLocalStore,
			String psRemoteStore) {
		return transferOK(psTransferId, psLocalStore, psRemoteStore, false);
	}

	boolean transferOK(String psTransferId, String psLocalStore,
			String psRemoteStore, boolean pbInputTransfer) {
		try {
			String lsQuery, lsStatus;

			//Checar si existe ID transferencia
			lsQuery = "SELECT count(transfer_id) FROM op_grl_transfer WHERE "
					+ "transfer_id=" + psTransferId;

			lsStatus = moAbcUtils.queryToString(lsQuery);

			if (Integer.parseInt(lsStatus) > 0) //si la transferencia ya existe
			{
				logApps.writeInfo("Se intento duplicar transferencia");
				return false;
			} else//Se guarda la transferencia
			{
				saveTransfer(psTransferId);

				lsQuery = "SELECT COUNT(*) FROM op_grl_transfer_detail WHERE "
						+ "transfer_id=" + psTransferId;

				lsStatus = moAbcUtils.queryToString(lsQuery);

				if (Integer.parseInt(lsStatus) > 0) //Se guardo el registro en la BD
				{
					//Se modifica el archivo de inventario
					boolean resultOk = false;

					if (pbInputTransfer == true) {
						lsQuery = "SELECT add_itransfer_inv(" + psTransferId
								+ ")";
						resultOk = savedInputTransfer(psTransferId,
								psLocalStore, psRemoteStore);
					} else //Output transfer
					{
						lsQuery = "SELECT add_otransfer_inv(" + psTransferId
								+ ")";
						resultOk = savedOutputTransfer(psTransferId,
								psLocalStore, psRemoteStore);
					}

					/* EZ: tunning
					 * Se insertan los valores de la transferencia en inventario.
					 */
					lsStatus = moAbcUtils.queryToString(lsQuery);
					if (Integer.parseInt(lsStatus) <= 0) //No se ingreso la
						logApps.writeInfo("La transferencia " + psTransferId
								+ " no se ingreso en inv.");

					if (resultOk)
						return true;
					else
						return false;
				} else
					return false;
			}
		} catch (Exception ex) {
			logApps.writeError("\n" + new Date() + ": Exception loadCurrentExistence() " + ex.getMessage() + " en " + ex.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + ex.toString() + ":");
	    	for (StackTraceElement stack: ex.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return false;
		}
	}
	
	String outputConfirmTransfer(String psTransferId) {
		String insert = "INSERT INTO op_grl_confirm_transfer (transfer_id,local_store_id,neighbor_store_id,date_id,transfer_type,responsible)"
				+ " SELECT * FROM op_grl_step_transfer where transfer_id="
				+ psTransferId;
		String insertDetail = "INSERT INTO op_grl_confirm_transfer_detail select * from op_grl_step_transfer_detail where transfer_id="
				+ psTransferId;
		moAbcUtils.executeSQLCommand(insert);
		moAbcUtils.executeSQLCommand(insertDetail);
		String update = "UPDATE op_grl_confirm_transfer set neighbor_responsible = (SELECT responsible FROM op_grl_confirm_transfer WHERE transfer_id=" 
						+ psTransferId +"), confirm=1, neighbor_transfer_id=" + psTransferId +" WHERE transfer_id = " + psTransferId;
		moAbcUtils.executeSQLCommand(update);
		return "OK";
	}

	String syscalgt(String option) {
		String command[] = { "/usr/fms/bin/syscalgt", option, "invcaldr.txt" };
		String environ[] = { "FMS_DATA=" + "/usr/fms/data" };

		String output = null;
		String rvalue = "none";
		try {
			Runtime runtime = Runtime.getRuntime();
			Process process = runtime.exec(command, environ);
			process.waitFor();

			BufferedReader buffer = new BufferedReader(new InputStreamReader(
					process.getInputStream()));
			rvalue = buffer.readLine();

			/* YY/PP/W OR MM/DD/YY */
			if (rvalue.matches("\\d\\d/\\d\\d/\\d")
					|| rvalue.matches("\\d\\d/\\d\\d/\\d\\d"))
				output = rvalue;
		} catch (Exception e) {
			String error = "Exception to run syscalgt " + e.getMessage()
					+ "\n\t";
			for (StackTraceElement stack : e.getStackTrace()) {
				if (stack.toString().startsWith("jinvtran")) {
					error += stack + "\n\t";
				}
			}
			logApps.writeError(error);
		}
		logApps.writeInfo("Inventory.syscalgt(" + option + ") "
				+ "Se regresar? " + output);
		return output;
	}

	String getLocalIP() {
		String lsQuery = "Select ip_addr from ss_cat_store";
		return moAbcUtils.queryToString(lsQuery);
	}

	String isFranq() {
		String query = "SELECT store_id from ss_cat_store ";
		String loNumCC = moAbcUtils.queryToString(query, "", "");
		String isFran = "false";
		int numCC = Integer.parseInt(loNumCC);
		if (numCC > 1000 && numCC < 2000) {
			isFran = "true";
		}
		return isFran;
	}

	String sendTransfer(String moTransferId) {
		boolean loTransSucess = false;
		String loAnswer = "OK";
		BufferedReader loBuffer = null;
		BufferedReader loBufferErr = null;
		BufferedReader loBufferFile = null;
		FileReader loFileRead = null;
		String file = "/usr/local/tomcat/webapps/ROOT/FilesTransfer/SpecialTransfer_"
				+ moTransferId;
		String cmd = "wget -O " + file;

		try {
			String insert = "INSERT INTO op_grl_confirm_transfer (transfer_id,local_store_id,neighbor_store_id,date_id,transfer_type,responsible)"
					+ " SELECT * FROM op_grl_step_transfer where transfer_id="
					+ moTransferId;
			String insertDetail = "INSERT INTO op_grl_confirm_transfer_detail select * from op_grl_step_transfer_detail where transfer_id="
					+ moTransferId;
			String queryDetailTransfer = "SELECT local_store_id, " //0
					+ "neighbor_store_id," //1
					+ "to_char(date_id, 'YYYYMMDD')," //2
					+ "inv_id," //3
					+ "0 as provider_id," //4
					+ "0 as provider_product_code," //5
					+ "inventory_quantity," //6
					+ "existence," //7
					+ "responsible " //8
					+ "FROM op_grl_confirm_transfer ct "
					+ "INNER JOIN op_grl_confirm_transfer_detail ctd ON (ct.transfer_id = ctd.transfer_id) "
					+ "WHERE ct.transfer_id=" + moTransferId;
			moAbcUtils.executeSQLCommand(insert);
			moAbcUtils.executeSQLCommand(insertDetail);
			String result = moAbcUtils.queryToString(queryDetailTransfer, ">",
					",");
			if (result.contains(">")) {
				String[] loTransferDetail = result.split(">");
				int numLines = 1;
				for (String lsTransferDetail : loTransferDetail) {
					String[] lsItemTransfer = lsTransferDetail.split(",");
					String lineServ = "http://www.prb.net:7071/servlet/Transfer.servlets.Transfer?"
							+ getParamsTranfer(lsItemTransfer, moTransferId);
					logApps.writeInfo("\n\nLinea " + numLines + " de "
							+ loTransferDetail.length + ": " + lineServ
							+ "\n\n");
					numLines++;
					cmd += " " + lineServ;
					//logApps.writeInfo("\n\n" + cmd + "\n\n");
					Runtime loRun = Runtime.getRuntime();
					Process loProc = loRun.exec(cmd);
					loBuffer = new BufferedReader(new InputStreamReader(
							loProc.getInputStream()));
					String linea;
					while ((linea = loBuffer.readLine()) != null) {
						logApps.writeInfo(linea);
					}
					loBufferErr = new BufferedReader(new InputStreamReader(
							loProc.getErrorStream()));
					while ((linea = loBufferErr.readLine()) != null) {
						logApps.writeError("Error: " + linea);
					}

					loFileRead = new FileReader(new File(file));
					loBufferFile = new BufferedReader(loFileRead);
					logApps.writeInfo("\nContenido del archivo " + file + ":");
					while ((linea = loBufferFile.readLine()) != null) {
						logApps.writeInfo(linea);
						if (linea.startsWith("Succesfull")
								|| linea.startsWith("true")) {
							loTransSucess = true;
							break;
						} else {
							//logApps.writeInfo("Ocurrio un error al enviar la informacion para aceptar la transferencia");
							if (!linea.startsWith("false")) {
								loAnswer = linea;
							}
						}
					}
					logApps.writeInfo("\n\n");

					if (loTransSucess) {
						cmd = "wget -O " + file;
					} else {
						break;
					}
				}
			} else {
				if (!result.equals("")) {
					String[] lsItemTransfer = result.split(",");
					String lineServ = "http://www.prb.net:7071/servlet/Transfer.servlets.Transfer?"
							+ getParamsTranfer(lsItemTransfer, moTransferId);
					//logApps.writeInfo(lineServ);
					cmd += " " + lineServ;
					logApps.writeInfo("\n" + cmd );
					Runtime loRun = Runtime.getRuntime();
					Process loProc = loRun.exec(cmd);
					loBuffer = new BufferedReader(new InputStreamReader(
							loProc.getInputStream()));
					String linea;
					while ((linea = loBuffer.readLine()) != null) {
						logApps.writeInfo(linea);
					}
					loBufferErr = new BufferedReader(new InputStreamReader(
							loProc.getErrorStream()));
					while ((linea = loBufferErr.readLine()) != null) {
						logApps.writeError("Error: " + linea);
					}

					loFileRead = new FileReader(new File(file));
					loBufferFile = new BufferedReader(loFileRead);
					while ((linea = loBufferFile.readLine()) != null) {
						if (linea.startsWith("Succesfull")
								|| linea.startsWith("true")) {
							loTransSucess = true;
							break;
						} else {
							if (!linea.startsWith("false")) {
								loAnswer = linea;
							}
						}
					}
				}
			}
		} catch (IOException ioe) {
			logApps.writeError("\n" + new Date() + ": Exception loadCurrentExistence() " + ioe.getMessage() + " en " + ioe.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + ioe.toString() + ":");
	    	for (StackTraceElement stack: ioe.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			String error = ioe.getMessage();
			return error;
		} finally {
			try {
				if (loBufferFile != null) {
					loBufferFile.close();
				}
				if (loBufferErr != null) {
					loBufferErr.close();
				}
				if (loBuffer != null) {
					loBuffer.close();
				}
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
			if (loTransSucess) {
				new File(file).delete();
			}
		}
		return loAnswer;
	}

	private String getParamsTranfer(String[] loDataTransfer, String loTransferId) {
		String loParams = "store_id=" + loDataTransfer[0].trim()
				+ "&transfer_id=" + loTransferId + "&store_id_dest="
				+ loDataTransfer[1].trim() + "&date_id="
				+ loDataTransfer[2].trim() + "&responsible="
				+ loDataTransfer[8].trim() + "&inv_id="
				+ loDataTransfer[3].trim() + "&provider_id="
				+ loDataTransfer[4].trim() + "&provider_product_code="
				+ loDataTransfer[5].trim() + "&inventory_qty="
				+ loDataTransfer[6].trim() + "&existence="
				+ loDataTransfer[7].trim();
		return loParams;
	}

	public void writeMenu(javax.servlet.jsp.JspWriter out,
			ArrayList<String> dataForComb) {
		try {
			if (dataForComb.size() > 0) {
				for (int i = 0; i < dataForComb.size(); i++) {
					out.println("<option value=\"" + dataForComb.get(i) + "\">"
							+ dataForComb.get(i) + "</option>");
				}
			}
		} catch (java.io.IOException e) {
			logApps.writeError("\n" + new Date() + ": Exception loadCurrentExistence() " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
		}
	}

	public ArrayList<String> getEmployees() {
		ArrayList<String> maEmployees = new ArrayList<String>();
		String queryEmployees = "SELECT emp_num || ' ' || last_name || ' ' || last_name2 || ' ' || name, last_name "
				+ "FROM pp_employees WHERE sus_id <> 'NULL' "
				+ "AND cast (emp_num as integer) > 0 "
				+ "AND security_level ='01' order by 2";
		String[] laEmployees = moAbcUtils.queryToString(queryEmployees, ">",
				",").split(">");
		for (String employee : laEmployees) {
			String lstEmployee = employee.split(",")[0];
			maEmployees.add(lstEmployee);
		}
		return maEmployees;
	}

	String stripAccents(String psInput) {
		String lsAscii = "ABCDEFGHIJKLMN?OPQRSTUVWXYZ0123456789 _abcdefghijklmnopqrstuvwxyz";
		String lsNuevo = "                              ";
		char[] laName = psInput.toCharArray();
		char[] laAscii = lsAscii.toCharArray();
		char[] laNuevo = lsNuevo.toCharArray();
		String lsOutput = psInput;
		for (int i = 0; i < laName.length; i++) {
			int pos = lsAscii.indexOf(laName[i]);
			if (pos > -1) {
				logApps.writeInfo("No vamos a limpiar esto[" + laName[i] + "]");
				laNuevo[i] = laName[i];
			} else {
				logApps.writeInfo("Vamos a limpiar esto:" + laName[i]
						+ " Por nada");
				//laName[i] = laNull[0];
			}
		}//for i
		return new String(laNuevo);
	}

	HashMap<String, String> getTransfers(String remStore) throws Exception {
		HashMap<String, String> transfers = new HashMap<String, String>();
		if (!remStore.equals("")) {
			String queryTransfers = "update op_grl_confirm_transfer set confirm = 2, reason_reject = 0, neighbor_responsible = 'SISTEMA' where transfer_id in"
					+ "(select transfer_id from op_grl_confirm_transfer where confirm = 0 and (date_id < (SELECT CURRENT_TIMESTAMP - interval '24 hours')"
					+ " OR extract(dow from date_id) = 1 and '23:30:00' < (to_char(now(), 'HH24:MI:SS'))::interval "
					+ " OR extract(dow from date_id) = 2 and '08:00:00' > (to_char(now(), 'HH24:MI:SS'))::interval)"
					+ ") AND transfer_type=1";
			logApps.writeInfo("\nQry Update rechazo de Entradas:\n"
					+ queryTransfers);
			moAbcUtils.executeSQLCommand(queryTransfers);
			queryTransfers = "update op_grl_confirm_transfer set confirm = 2, reason_reject = 0, responsible = 'SISTEMA' where transfer_id in"
					+ "(select transfer_id from op_grl_confirm_transfer where confirm = 0 and (date_id < (SELECT CURRENT_TIMESTAMP - interval '24 hours')"
					+ " OR extract(dow from date_id) = 1 and '23:30:00' < (to_char(now(), 'HH24:MI:SS'))::interval " 
					+ " OR extract(dow from date_id) = 2 and '08:00:00' > (to_char(now(), 'HH24:MI:SS'))::interval)"
					+ ") AND transfer_type=0";
			logApps.writeInfo("\nQry Update rechazo de Salidas:\n"
					+ queryTransfers);
			moAbcUtils.executeSQLCommand(queryTransfers);
			//queryTransfers = "SELECT transfer_id FROM op_grl_confirm_transfer WHERE confirm =2 AND reason_reject=0 AND date_id < (SELECT CURRENT_TIMESTAMP - interval '24 hours') and neighbor_responsible is null";
			queryTransfers = "SELECT transfer_id FROM op_grl_confirm_transfer WHERE confirm =2 AND reason_reject=0 AND date_id > (SELECT CURRENT_TIMESTAMP - interval '7 days') and "
					+ "transfer_type=0";
			logApps.writeInfo("\nQuery busqueda transfers para envio de correo:\n"
							+ queryTransfers + "\n");
			String loTransfersRej = moAbcUtils.queryToString(queryTransfers,
					",", "");
			logApps.writeInfo("loTransfersRej: " + loTransfersRej);
			String cmd = "/usr/bin/ph/mail2222.s ";
			if (loTransfersRej.contains(",")) {
				String[] loRowsTransfersR = loTransfersRej.split(",");
				loTransfersRej = "";
				for (String loTransferRej : loRowsTransfersR) {
					if (new File("/tmp/sdc_" + loTransferRej).exists()) {
						continue;
					}
					cmd = "/usr/bin/ph/mail2222.s " + loTransferRej;
					Runtime run = Runtime.getRuntime();
					Process procesConfirm = run.exec(cmd);
					logApps.writeInfo(new Date()
									+ "Se envia correo de rechazo para la transferencia "
									+ loTransferRej);
					java.io.BufferedReader br = new java.io.BufferedReader(
							new java.io.InputStreamReader(
									procesConfirm.getInputStream()));
					java.io.BufferedReader bre = new java.io.BufferedReader(
							new java.io.InputStreamReader(
									procesConfirm.getErrorStream()));
					String linea;
					while ((linea = br.readLine()) != null) {
						logApps.writeInfo(linea);
					}
					while ((linea = bre.readLine()) != null) {
						logApps.writeError("Error: " + linea);
					}
					loTransfersRej += loTransferRej + ",";
				}
				loTransfersRej += "f";
				updateRejects(loTransfersRej);
			} else {
				if (!loTransfersRej.equals("")) {
					cmd += loTransfersRej;
					Runtime run = Runtime.getRuntime();
					Process procesConfirm = run.exec(cmd);
					logApps.writeInfo("Se envia correo de rechazo para la transferencia "
									+ loTransfersRej);
					java.io.BufferedReader br = new java.io.BufferedReader(
							new java.io.InputStreamReader(
									procesConfirm.getInputStream()));
					String linea;
					while ((linea = br.readLine()) != null) {
						logApps.writeInfo(linea);
					}
					updateRejects(loTransfersRej + ",f");
				} else {
					logApps.writeInfo("No hay transferencias para rechazar");
				}
			}
			queryTransfers = "select ct.transfer_id, CAST(to_char(date_id, 'YYYY/MM/DD') AS date) || ' - ' || ct.transfer_id as date_transfer, count(ctd.transfer_id) as num_prods "
					+ "from op_grl_confirm_transfer ct inner join op_grl_confirm_transfer_detail ctd on (ct.transfer_id = ctd.transfer_id) "
					+ "where confirm=0 AND "
					+ remStore
					+ " not in ( select store_id from ss_cat_neighbor_store WHERE ip_addr = 'NA' ) and neighbor_store_id= "
					+ remStore
					+ " and transfer_type=0 "
					+ "group by 1, 2 order by 1";
			logApps.writeInfo("Ejecutando consulta de busqueda de transferencias de salida pendientes:\n"
							+ queryTransfers);
			String resTransfers = moAbcUtils.queryToString(queryTransfers, ">",
					",");

			if (resTransfers.contains(">")) {
				String[] loRowsTransfers = resTransfers.split(">");
				for (String loRowTransfer : loRowsTransfers) {
					String[] loTransfer = loRowTransfer.split(",");
					transfers.put(loTransfer[0], loTransfer[1]
							+ " - No. Prods: " + loTransfer[2]);
				}
			} else {
				if (!resTransfers.equals("")) {
					String[] loTransfer = resTransfers.split(",");
					transfers.put(loTransfer[0], loTransfer[1]
							+ " - No. Prods: " + loTransfer[2]);
				} else {
					logApps.writeInfo("No hay transferencias de salida pendientes");
				}
			}
		}
		return transfers;
	}

	private void updateRejects(String loTransfers) {
		logApps.writeInfo("Se cancelaran las transferencias: " + loTransfers
				+ "\n");
		String qryIp = "select ip_addr from ss_cat_neighbor_store where store_id=(select neighbor_store_id from op_grl_confirm_transfer where transfer_id=";
		String qryStore = "select store_id from ss_cat_neighbor_store where store_id=(select neighbor_store_id from op_grl_confirm_transfer where transfer_id=";
		String qryNStore = "select store_id from ss_cat_neighbor_store where store_id=(select neighbor_store_id from op_grl_confirm_transfer where transfer_id=";
		String[] loRowsTransfersR = loTransfers.split(",");
		for (String loTransferRej : loRowsTransfersR) {
			if (loTransferRej.equals("f")) {
				break;
			}
			logApps.writeInfo("Qry busqueda restaurante vecino:\n" + qryNStore + loTransferRej
					+ ")");
			String CCN = moAbcUtils.queryToString(qryNStore + loTransferRej
					+ ")", "", "");
			String CC = moAbcUtils.queryToString(
					qryStore + loTransferRej + ")", "", "");
			logApps.writeInfo(new Date() + " Se actualizar? el restaurante "
					+ CCN + " con la transferencia:" + loTransferRej);
			String IP = moAbcUtils.queryToString(qryIp + loTransferRej + ")",
					"", "");
			String loNTransferId = moAbcUtils.queryToString(
					"select neighbor_transfer_id from op_grl_confirm_transfer where transfer_id="
							+ loTransferRej, "", "");
			if (!loNTransferId.equals("")) {
				ConectStore cs = new ConectStore(IP, "dbeyum", "postgres", "");

				String loTransferType = moAbcUtils.queryToString(
						"SELECT transfer_type FROM op_grl_confirm_transfer where transfer_id="
								+ loTransferRej, "", "");
				logApps.writeInfo(new Date() + " Tipo de transferencia: "
						+ (loTransferType.equals("0") ? "Salida" : "Entrada"));
				if (loTransferType.equals("0")) {
					cs.setQuery("Update op_grl_confirm_transfer set neighbor_transfer_id="
							+ loTransferRej
							+ ", confirm = 2, reason_reject = 0, neighbor_responsible = 'SISTEMA' where transfer_id="
							+ loNTransferId + " and neighbor_store_id=" + CC);
					cs.execute();
				} else {
					cs.setQuery("Update op_grl_confirm_transfer set neighbor_transfer_id="
							+ loTransferRej
							+ ", confirm = 2, reason_reject = 0, responsible = 'SISTEMA' where transfer_id="
							+ loNTransferId + " and neighbor_store_id=" + CC);
					cs.execute();
				}
				logApps.writeInfo("Se rechaz? la transferencia en los restaurantes, los transfer_id son:\n\tLocal: "
								+ loTransferRej
								+ "\n\tVecino: "
								+ loNTransferId);
			}
		}
		// 		} else {
		// 			logApps.writeInfo("Se actualizar? el restaurante vecino con la transferencia:"
		// 							+ loTransfers);
		// 			String IP = moAbcUtils.queryToString(qryIp + loTransfers + ")", "",
		// 					"");
		// 			String loNTransferId = moAbcUtils
		// 					.queryToString(
		// 							"select neighbor_transfer_id from op_grl_confirm_transfer where transfer_type=1 and transfer_id="
		// 									+ loTransfers, "", "");
		// 			logApps.writeInfo("El transfer_id vecino es: " + loNTransferId);
		// 			if (!loNTransferId.equals("")) {
		// 				ConectStore cs = new ConectStore(IP, "dbeyum", "postgres", "");

		// 				cs.setQuery("Update op_grl_confirm_transfer set neighbor_transfer_id="
		// 						+ loTransfers
		// 						+ ", confirm = 2, reason_reject = 0, neighbor_responsible = 'SISTEMA' where transfer_id="
		// 						+ loNTransferId);
		// 				cs.execute();
		// 				logApps.writeInfo("Se rechaz? la transferencia en los restaurantes, los transfer_id son:\n\tLocal: "
		// 								+ loTransfers + "\n\tVecino: " + loNTransferId);
		// 			}
		// 		}
	}

	public void registerTransfer(String msRemoteStore, String msTransferId,
			String msLocalStore) throws Exception {
		String IP = moAbcUtils.queryToString(
				"select ip_addr from ss_cat_neighbor_store where store_id='"
						+ msRemoteStore + "'", "", "");
		if (!IP.equals("localhost")) {
			String insert = "INSERT INTO op_grl_confirm_transfer (transfer_id,local_store_id,neighbor_store_id,date_id,transfer_type,responsible) SELECT * FROM op_grl_step_transfer where transfer_id="
					+ msTransferId;
			String insertDetail = "INSERT INTO op_grl_confirm_transfer_detail select * from op_grl_step_transfer_detail where transfer_id="
					+ msTransferId;
			String queryData1Transfer = "select neighbor_store_id, local_store_id, date_id, 0, '', responsible from op_grl_confirm_transfer where transfer_id="
					+ msTransferId;
			String queryDataDTransfer = "select inv_id, stock_code_id,0,provider_quantity,inventory_quantity,prv_conversion_factor,provider_unit_measure,inventory_unit_measure,provider_id,existence from op_grl_confirm_transfer_detail where transfer_id="
					+ msTransferId;
			moAbcUtils.executeSQLCommand(insert);
			moAbcUtils.executeSQLCommand(insertDetail);
			String detailTransfer = moAbcUtils.queryToString(
					queryDataDTransfer, ">", "','");

			logApps.writeInfo("Query Insert local:\n" + insert + "\n");
			ConectStore cs = new ConectStore(IP, "dbeyum", "postgres", "");
			cs.setQuery("SELECT MAX(transfer_id) from op_grl_confirm_transfer");
			String smaxConfirm = cs.getStringResult();
			int maxConfirm = Integer.parseInt(smaxConfirm == null ? "0"
					: smaxConfirm);
			int maxConfirmN=maxConfirm + 1;
			String updTransfer="UPDATE op_grl_confirm_transfer set neighbor_transfer_id=" + maxConfirmN + " WHERE transfer_id=" + msTransferId;
			moAbcUtils.executeSQLCommand(updTransfer);
			cs.setQuery("SELECT MAX(transfer_id) from op_grl_transfer");
			String smaxTransfer = cs.getStringResult();
			int maxTransfer = Integer.parseInt(smaxTransfer);
			String tmpTransferNID = "(SELECT transfer_id from op_grl_confirm_transfer where neighbor_transfer_id ="
					+ msTransferId
					+ " and neighbor_store_id="
					+ moAbcUtils.queryToString(
							"SELECT store_id from ss_cat_store", "", "") + ")";
			String tmpTransferLID = "(SELECT max(transfer_id)+1 FROM op_grl_confirm_transfer)";
			String insertN = "INSERT INTO op_grl_confirm_transfer (transfer_id,neighbor_transfer_id,local_store_id,neighbor_store_id,date_id,transfer_type,responsible,neighbor_responsible,confirm) values ("
					+ tmpTransferLID
					+ ","
					+ msTransferId
					+ ",'"
					+ moAbcUtils.queryToString(queryData1Transfer, "#", "','")
					+ "',0)";
			logApps.writeInfo("Query Insert de transfer para el CC "
					+ msRemoteStore + ":\n" + insertN);
			cs.setQuery(insertN);
			cs.execute();
			if (detailTransfer.contains(">")) {
				String[] aInsertTransfer = detailTransfer.split(">");
				String queryInsertDetail = "INSERT INTO op_grl_confirm_transfer_detail values (";
				for (String detail : aInsertTransfer) {
					queryInsertDetail += tmpTransferNID + ",'"
							+ detail.replace(" ", "").replace("\t", "")
							+ "'),(";
				}
				queryInsertDetail = queryInsertDetail.substring(0,
						(queryInsertDetail.length() - 2));
				logApps.writeInfo("Query Insert de detalle de la transferencia "
								+ msTransferId + " para el CC " + msRemoteStore
								+ ":\n" + queryInsertDetail);
				cs.setQuery(queryInsertDetail);
				cs.execute();
			} else {
				String queryInsertDetail = "INSERT INTO op_grl_confirm_transfer_detail values ("
						+ tmpTransferNID
						+ ",'"
						+ detailTransfer.replace(" ", "").replace("\t", "")
						+ "')";
				logApps.writeInfo("Query Insert de detalle de la transferencia "
								+ msTransferId + " para el CC " + msRemoteStore
								+ ":\n" + queryInsertDetail);
				cs.setQuery(queryInsertDetail);
				cs.execute();
			}
			String cmd = "/usr/bin/ph/mail2222.s " + msTransferId;
			logApps.writeInfo("\n\nSe ejecutara el script: \n\t" + cmd);

			Runtime run = Runtime.getRuntime();
			Process procesConfirm = run.exec(cmd);
			logApps.writeInfo("Se envia correo de solicitud de transferencia con el transfer_id="
							+ msTransferId);
			java.io.BufferedReader br = new java.io.BufferedReader(
					new java.io.InputStreamReader(
							procesConfirm.getInputStream()));
			String linea;
			while ((linea = br.readLine()) != null) {
				logApps.writeInfo(linea);
			}
			logApps.writeInfo("Se envio el correo al restaurante " + msRemoteStore);
		} else {
			String insertC = "INSERT INTO op_grl_confirm_transfer (transfer_id, neighbor_transfer_id, local_store_id, neighbor_store_id, date_id, transfer_type, responsible, neighbor_responsible, confirm)"
					+ "SELECT transfer_id, transfer_id, local_store_id, neighbor_store_id, date_id, transfer_type, responsible, responsible, 1 FROM op_grl_transfer WHERE transfer_id ="
					+ msTransferId;
			String insertD = "INSERT INTO op_grl_confirm_transfer_detail SELECT * FROM op_grl_transfer_detail WHERE transfer_id ="
					+ msTransferId;
			inputTransferOK(msTransferId, msLocalStore, msRemoteStore);
			moAbcUtils.executeSQLCommand(insertC);
			moAbcUtils.executeSQLCommand(insertD);
		}
	}%>
