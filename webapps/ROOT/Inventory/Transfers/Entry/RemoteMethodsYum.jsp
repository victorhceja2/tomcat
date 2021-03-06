
<%--
##########################################################################################################
# Nombre Archivo  : RemoteMethodYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Implementa metodos usados por RemoteScripting JS
# Fecha Creacion  : 08/Julio/2005
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@page import="generals.*"%>
<%@ page language="java" extends="generals.servlets.RemoteScripting"%>

<%!
	private static AbcUtils loAbcUtils = new AbcUtils();
	private static AplicationsV2 logApps = new AplicationsV2();

	public void log(String msg) {
		//DEBUG
		//logApps.writeInfo("RemoteScripting:"+msg);
	}

	static public String neighborStoreExists(String psStoreId) {

		String lsStoreName = "NA";

		try {
			lsStoreName = loAbcUtils.queryToString(
					"SELECT store_desc FROM ss_cat_neighbor_store WHERE store_id="
							+ psStoreId, "", "");
			if (lsStoreName.length() > 0)
				return lsStoreName;
			else
				return "FALSE";

		} catch (Exception e) {
			logApps.writeError("\n" + new java.util.Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return "ERROR";
		}

	}

	static public String verifyCredentials(String psUserPwd) {
		//	AbcUtils loAbcUtils = new AbcUtils();
		String lsSUSID = "0";
		String[] loUsr = psUserPwd.split(" ");
		String[] loPwd = psUserPwd.split(",");
		try {
			String qry = "SELECT sus_id FROM pp_employees WHERE emp_num='"
					+ loUsr[0] + "' and sus_pass='" + loPwd[1] + "'";
			logApps.writeInfo(qry);
			lsSUSID = loAbcUtils.queryToString(qry, "", "");
			if (lsSUSID.length() > 0)
				return lsSUSID;
			else
				return "FALSE";
		} catch (Exception e) {
			logApps.writeError("\n" + new java.util.Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return "ERROR";
		}
	}

	static public String verifyConectionToStore(String lsStore) {
		//AbcUtils loAbcUtils = new AbcUtils();
		String lsIpStore = "";
		try {
			String query = "SELECT ip_addr from ss_cat_neighbor_store WHERE store_id="
					+ lsStore;
			logApps.writeInfo(query);
			lsIpStore = loAbcUtils.queryToString(query, "", "");
			logApps.writeInfo("lsIpStore: " + lsIpStore);
			if (lsIpStore.equals("NA")) {
				return lsIpStore;
			} else if (lsIpStore.length() > 0) {
				return doPingStore(lsIpStore);
			} else {
				query = "SELECT COUNT(store_id) FROM ss_cat_store where store_id="
						+ lsStore;
				if (Integer.parseInt(loAbcUtils.queryToString(query, "", "")) > 0) {
					return "localstore";
				} else {
					return "nhip";
				}
			}
		} catch (Exception e) {
			logApps.writeError("\n" + new java.util.Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return "ERROR";
		}
	}

	static private String doPingStore(String lsIpStore) {
		String cmd = "ping -c2 " + lsIpStore;
		String ping = "SinConexion";
		logApps.writeInfo("cmd: " + cmd);
		try {
			Runtime run = Runtime.getRuntime();
			Process proc = run.exec(cmd);
			java.io.BufferedReader br = new java.io.BufferedReader(
					new java.io.InputStreamReader(proc.getInputStream()));
			String line;
			String result = "";
			while ((line = br.readLine()) != null) {
				logApps.writeInfo(line);
				result += line;
			}
			logApps.writeInfo("Result: " + result);
			if (result.contains("100% packet loss")) {
				return ping;
			} else if (result.contains("0% packet loss")) {
				ping = "Exito";
			} else {
				ping = "Intermitente";
			}
			String valWeeks = validateWeek(lsIpStore); 
			if(!valWeeks.equals("OK")){
				ping = "difW:"+valWeeks;
			}
		} catch (Exception e) {
			logApps.writeError("\n" + new java.util.Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
		}
		
		return ping;
	}
	
	static private String validateWeek(String lsIpStore) throws Exception{
		String weekOk = "OK";
		String lsWeekN = "";
		String lsWeekL = "";
		logApps.writeInfo("Validando la semana del CC vecino...");
		String cmd = "java -jar /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/transfers/ClientTransfer.jar "
				+ lsIpStore + " -w";
		Runtime run = Runtime.getRuntime();
		Process procesConfirm = run.exec(cmd);
		logApps.writeInfo("Se ejecutar? el comando:\n\n" + cmd);
		java.io.BufferedReader br = new java.io.BufferedReader(
				new java.io.InputStreamReader(
						procesConfirm.getInputStream()));
		String linea;
		while ((linea = br.readLine()) != null) {
			if(linea.startsWith("Week")){
				lsWeekN=linea.split(":")[1].trim();
			}
			logApps.writeInfo(linea);
		}
		java.io.BufferedReader bre = new java.io.BufferedReader(
				new java.io.InputStreamReader(
						procesConfirm.getErrorStream()));
		while ((linea = bre.readLine()) != null) {
			logApps.writeError(linea);
		}
		
		if(!lsWeekN.equals("")){
			lsWeekL = getLocalWeek();
			logApps.writeInfo("Validando si la semana local [" + lsWeekL + "] es igual a la semana del CC vecino [" + lsWeekN + "]");
			if(!lsWeekL.equals(lsWeekN)){
				weekOk = lsWeekL.trim() + ":" + lsWeekN.trim();
			}
		} else {
			weekOk="Error";
		}
		logApps.writeInfo("Se regresa: " + weekOk);
		return weekOk;
	}
	
	static private String getLocalWeek() throws Exception{
		String linea;
		String lsWeekL = "";
		logApps.writeInfo("Obteniendo la semana actual...");
		String cmdL = "/usr/fms/bin/syscalgt -p /usr/fms/data/invcaldr.txt";
		Runtime runL = Runtime.getRuntime();
		Process procesConfirmL = runL.exec(cmdL);
		logApps.writeInfo("Se ejecutar? el comando:\n\n" + cmdL);
		java.io.BufferedReader br1 = new java.io.BufferedReader(
				new java.io.InputStreamReader(
						procesConfirmL.getInputStream()));
		while ((linea = br1.readLine()) != null) {
			lsWeekL=linea.trim();
			logApps.writeInfo(linea);
		}
		java.io.BufferedReader bre1 = new java.io.BufferedReader(
				new java.io.InputStreamReader(
						procesConfirmL.getErrorStream()));
		while ((linea = bre1.readLine()) != null) {
			logApps.writeError(linea);
		}
		return lsWeekL;
	}

	static public String confirmTransfer(String lsDataConfirm) {
		//AbcUtils loAbcUtils = new AbcUtils();
		String confirm = "OK";
		logApps.writeInfo("Actualizando transferencia en restaurantes...");
		logApps.writeInfo("lsDataConfirm:\n" + lsDataConfirm);
		try {
			String[] loData = lsDataConfirm.split(",");
			String loResponsible = loData[0].length() > 30 ? loData[0]
					.substring(0, 30).replace(" ", "_") : loData[0].replace(
					" ", "_");
			loResponsible = stripAccents(loResponsible.toUpperCase());
			String query = "UPDATE op_grl_confirm_transfer SET confirm=1, date_id=(SELECT to_char(timestamp 'now','YYYY-MM-DD HH24:MI:SS'))::timestamp, responsible='"
					+ loResponsible + "' WHERE transfer_id=" + loData[1];
			//actualiza en restaurante local
			loAbcUtils.executeSQLCommand(query);
			String queryIP = "select ip_addr from ss_cat_neighbor_store where store_id = (select neighbor_store_id from op_grl_confirm_transfer where transfer_id="
					+ loData[1] + ")";
			String IP = loAbcUtils.queryToString(queryIP, "", "");

			ConectStore loConectSt = new ConectStore(IP, "dbeyum", "postgres",
					"");
			String updConfirmRem = "UPDATE op_grl_confirm_transfer SET confirm=1, neighbor_responsible='"
					+ loResponsible
					+ "', neighbor_transfer_id="
					+ loData[1]
					+ " WHERE transfer_id="
					+ loAbcUtils.queryToString(
							"SELECT neighbor_transfer_id from op_grl_confirm_transfer where transfer_id="
									+ loData[1], "", "");
			loConectSt.setQuery(updConfirmRem);
			//actualiza en el restaurante remoto
			loConectSt.execute();

			String cmd = "java -jar /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/transfers/ClientTransfer.jar "
					+ IP + " " + loData[1];

			Runtime run = Runtime.getRuntime();
			Process procesConfirm = run.exec(cmd);
			logApps.writeInfo("Se ejecutar? el comando:\n\n" + cmd);
			java.io.BufferedReader br = new java.io.BufferedReader(
					new java.io.InputStreamReader(
							procesConfirm.getInputStream()));
			String linea;
			while ((linea = br.readLine()) != null) {
				logApps.writeInfo(linea);
			}
			java.io.BufferedReader bre = new java.io.BufferedReader(
					new java.io.InputStreamReader(
							procesConfirm.getErrorStream()));
			while ((linea = bre.readLine()) != null) {
				logApps.writeError(linea);
				confirm += linea + "\n";
			}
			if (!confirm.equals("OK")) {
				/*logApps.writeInfo("Se regresa a su estado inicial la transferencia "
								+ loData[1]);
				query = "UPDATE op_grl_confirm_transfer SET confirm=0, date_id=(SELECT to_char(timestamp 'now','YYYY-MM-DD HH24:MI:SS'))::timestamp, responsible='' WHERE transfer_id="
						+ loData[1];
				loAbcUtils.executeSQLCommand(query);
				updConfirmRem = "UPDATE op_grl_confirm_transfer SET confirm=0, neighbor_responsible='', neighbor_transfer_id="
						+ loData[1]
						+ " WHERE transfer_id="
						+ loAbcUtils.queryToString(
								"SELECT neighbor_transfer_id from op_grl_confirm_transfer where transfer_id="
										+ loData[1], "", "");
				loConectSt.setQuery(updConfirmRem);
				loConectSt.execute();*/
				query = "SELECT neighbor_store_id FROM op_grl_confirm_transfer WHERE transfer_id=" + loData[1];
				String lsNTransId=loAbcUtils.queryToString(query);
				cmd = "java -jar /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/transfers/JRegTrans.jar 0 \"" + loData[1] + "|" + lsNTransId + "\"";
				Runtime runJreg = Runtime.getRuntime();
				Process procesConfirmE = runJreg.exec(cmd);
				logApps.writeInfo("Se ejecutar? el comando:\n\n" + cmd);
				java.io.BufferedReader brErr = new java.io.BufferedReader(
						new java.io.InputStreamReader(
								procesConfirmE.getInputStream()));
				
				while ((linea = brErr.readLine()) != null) {
					logApps.writeInfo(linea);
				}
				java.io.BufferedReader brErre = new java.io.BufferedReader(
						new java.io.InputStreamReader(
								procesConfirmE.getErrorStream()));
				while ((linea = brErre.readLine()) != null) {
					logApps.writeError(linea);
				}
				
				if(confirm.contains("Connection refused") || confirm.contains("Conexion reusada") || confirm.contains("Read timed out")){
					confirm="Error de comunicacion, se confirmar? automaticamente la transferencia";
				}
			}
		} catch (Exception e) {
			String error = "Error: " + e.getMessage() + "\n\t";
			for (int i = 0; i < e.getStackTrace().length; i++) {
				StackTraceElement stack = e.getStackTrace()[i];
				error += stack + "\n\t";
			}
			logApps.writeError(error);
			return "Error " + e.getMessage();
		}
		return confirm;
	}

	static public String updateReject(String lsDataReject) {
		//AbcUtils loAbcUtils = new AbcUtils();
		logApps.writeInfo("Actualizando los datos de la transferencia con los siguientes datos "
						+ lsDataReject);
		try {
			String[] loData = lsDataReject.split(",");
			String queryEmpl = "SELECT last_name || '_' || last_name2 || '_' || name FROM pp_employees WHERE emp_num='"
					+ loData[2] + "'";
			String empl = loData[2] + "_"
					+ loAbcUtils.queryToString(queryEmpl, "", "");
			empl = empl.length() > 30 ? empl.substring(0, 30) : empl;
			empl = stripAccents(empl);
			String query = "UPDATE op_grl_confirm_transfer SET confirm=2, reason_reject="
					+ loData[0]
					+ ", date_id=(SELECT to_char(timestamp 'now', 'YYYY-MM-DD HH24:MI:SS'))::timestamp, responsible='"
					+ empl + "' WHERE transfer_id=" + loData[1];
			logApps.writeInfo("Se acutalizar? la transferencia " + query);
			loAbcUtils.executeSQLCommand(query);
			String queryIP = "select ip_addr from ss_cat_neighbor_store where store_id = (select neighbor_store_id from op_grl_confirm_transfer where transfer_id="
					+ loData[1] + ")";
			String IP = loAbcUtils.queryToString(queryIP, "", "");
			logApps.writeInfo("Conectando a la base de la maquina remota con la ip "
							+ IP);
			ConectStore loConectSt = new ConectStore(IP, "dbeyum", "postgres",
					"");
			String updrejectRem = "UPDATE op_grl_confirm_transfer SET confirm=2, reason_reject="
					+ loData[0]
					+ ", neighbor_responsible='"
					+ empl
					+ "', neighbor_transfer_id="
					+ loData[1]
					+ " WHERE transfer_id="
					+ loAbcUtils.queryToString(
							"SELECT neighbor_transfer_id from op_grl_confirm_transfer where transfer_id="
									+ loData[1], "", "");
			logApps.writeInfo(updrejectRem);
			loConectSt.setQuery(updrejectRem);
			loConectSt.execute();

			String cmd = "/usr/bin/ph/mail2222.s " + loData[1];

			Runtime run = Runtime.getRuntime();
			Process procesConfirm = run.exec(cmd);
			logApps.writeInfo("Se envia correo de rechazo");
			java.io.BufferedReader br = new java.io.BufferedReader(
					new java.io.InputStreamReader(
							procesConfirm.getInputStream()));
			String linea;
			while ((linea = br.readLine()) != null) {
				logApps.writeInfo(linea);
			}

		} catch (Exception e) {
			logApps.writeError("\n" + new java.util.Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
	    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
	    	for (StackTraceElement stack: e.getStackTrace()){
	    		logApps.writeError("\t" + stack.toString());
	    	}
			return "ERROR";
		}
		return "OK";
	}

	/**
	Metodo para llenar la tabla de productos de la transferencia de salida
	 */
	static public String getDataSet(String transferId) {
		String dataset;
		logApps.writeInfo("Se buscar? informaci?n para el transfer_id "
				+ transferId);
		dataset = loAbcUtils.queryToString(getProductQuery(transferId), ">",
				",");
		return dataset;
	}

	private static String getProductQuery(String transferId) {
		String query = "SELECT DISTINCT i.inv_id,"
				+ "i.inv_id,"
				+ "RTRIM(i.inv_desc),"
				+ "ROUND(CAST(e.quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4) AS current_existence,"
				//+ "ROUND(CAST((inventory_quantity / prod.conversion_factor) AS numeric),2) || ' ' || substr(pum.unit_name,1,4),"
				+ "inventory_quantity|| ' ' || substr(ium.unit_name,1,4),"
				+ "inventory_quantity|| ' ' || substr(ium.unit_name,1,4),"
				+ "ROUND(CAST(e.quantity - inventory_quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4),"
				+ "ROUND(CAST(e.quantity - inventory_quantity AS numeric),2) AS required_quantity,"
				+ "substr(ium.unit_name,1,4),"
				+ "substr(pum.unit_name,1,4) "
				//+ "prod.conversion_factor,"
				//+ "prod.stock_code_id,"
				//+ "prod.provider_id "
				+ "FROM op_grl_cat_inventory i "
				+ "INNER JOIN op_grl_local_existence e ON (i.inv_id = e.inv_id) "
				+ "INNER JOIN op_grl_cat_providers_product prod ON (i.inv_id = prod.inv_id) "
				+ "INNER JOIN op_grl_cat_provider prov ON (prod.provider_id = prov.provider_id) "
				+ "INNER JOIN op_grl_cat_unit_measure pum ON (prod.provider_unit_measure = pum.unit_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) "
				+ "INNER JOIN op_grl_confirm_transfer_detail ctd ON (i.inv_id = ctd.inv_id "
				+ "AND prod.provider_id = ctd.provider_id "
				+ "AND prod.provider_product_code=ctd.provider_product_code) "
				+ "WHERE prod.active_flag IN (1,2) " + "AND ctd.transfer_id="
				+ transferId + "ORDER BY i.inv_id";
		query = "SELECT DISTINCT i.inv_id, "
                + "i.inv_id, "
                + "RTRIM(i.inv_desc), "
                + "ROUND(CAST(e.quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4) AS current_existence, "
                + "inventory_quantity|| ' ' || substr(ium.unit_name,1,4), "
                + "inventory_quantity|| ' ' || substr(ium.unit_name,1,4), "
                + "ROUND(CAST(e.quantity - inventory_quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4), "
                + "ROUND(CAST(e.quantity - inventory_quantity AS numeric),2) AS required_quantity, "
                + "substr(ium.unit_name,1,4), "
                + "substr(ium.unit_name,1,4) "
				+ "FROM op_grl_cat_inventory i "
				+ "INNER JOIN op_grl_local_existence e ON (i.inv_id = e.inv_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) "
				+ "INNER JOIN op_grl_confirm_transfer_detail ctd ON (i.inv_id = ctd.inv_id) "
				+ "WHERE ctd.transfer_id=" + transferId
				+ "ORDER BY i.inv_id";
		logApps.writeInfo("Query busqueda detalle de transfer_id "
				+ transferId + ":\n" + query);
		return query;
	}
	
	static public String getKDataSet(String transferId) {
		String dataset;
		logApps.writeInfo("Se buscar? informaci?n para el transfer_id "
				+ transferId);
		dataset = loAbcUtils.queryToString(getKProductQuery(transferId), ">",
				",");
		return dataset;
	}

	private static String getKProductQuery(String transferId) {
		String query = "SELECT DISTINCT i.inv_id,"
				+ "prod.provider_product_code,"
				+ "RTRIM(prov.name),"
				+ "RTRIM(i.inv_desc),"
				+ "prod.provider_product_desc,"
				+ "ROUND(CAST(0 AS numeric),2) || ' ' || substr(ium.unit_name,1,4) AS current_existence,"
				+ "ROUND(CAST((inventory_quantity / prod.conversion_factor) AS numeric),2) || ' ' || substr(pum.unit_name,1,4),"
				+ "inventory_quantity|| ' ' || substr(ium.unit_name,1,4),"
				+ "inventory_quantity|| ' ' || substr(ium.unit_name,1,4),"
				+ "ROUND(CAST(0 - inventory_quantity AS numeric),2) || ' ' || substr(ium.unit_name,1,4),"
				+ "ROUND(CAST(0 - inventory_quantity AS numeric),2) AS required_quantity,"
				+ "substr(ium.unit_name,1,4),"
				+ "substr(pum.unit_name,1,4),"
				+ "prod.conversion_factor,"
				+ "prod.stock_code_id,"
				+ "prod.provider_id "
				+ "FROM op_grl_cat_inventory i "
				//+ "INNER JOIN op_grl_local_existence e ON (i.inv_id = e.inv_id) "
				+ "INNER JOIN op_grl_cat_providers_product prod ON (i.inv_id = prod.inv_id) "
				+ "INNER JOIN op_grl_cat_provider prov ON (prod.provider_id = prov.provider_id) "
				+ "INNER JOIN op_grl_cat_unit_measure pum ON (prod.provider_unit_measure = pum.unit_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) "
				+ "INNER JOIN op_grl_confirm_transfer_detail ctd ON (i.inv_id = ctd.inv_id "
				+ "AND prod.provider_id = ctd.provider_id "
				+ "AND prod.provider_product_code=ctd.provider_product_code) "
				+ "WHERE prod.active_flag IN (1,2) " + "AND ctd.transfer_id="
				+ transferId + "ORDER BY i.inv_id";
		logApps.writeInfo("Query busqueda detalle de transfer_id "
				+ transferId + ":\n" + query);
		return query;
	}

	public static String isFranq() {
		String query = "SELECT store_id from ss_cat_store ";
		String loNumCC = loAbcUtils.queryToString(query, "", "");
		String isFran = "false";
		int numCC = Integer.parseInt(loNumCC);
		if (numCC > 1000 && numCC < 2000) {
			isFran = "true";
		}
		return isFran;
	}

	public static String getStatusTransfer(String psTransferId, String psAction) {
		String query = "select count(*) from op_grl_confirm_transfer where transfer_id = "
				+ psTransferId + " and confirm=0";
		int count = Integer.parseInt(loAbcUtils.queryToString(query, "", ""));
		if (count == 1) {
			return psAction;
		} else {
			return "ERROR";
		}
	}

	private static String stripAccents(String psInput) {
		String lsAscii = "ABCDEFGHIJKLMN?OPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyz";
		String lsNuevo = "                              ";
		char[] laName = psInput.toUpperCase().toCharArray();
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
						+ " por _");
				laName[i] = '_';
			}
		}//for i
		return new String(laNuevo);
	}%>
