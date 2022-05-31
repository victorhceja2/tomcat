
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

<%@page import="java.util.HashMap"%>
<%@page import="generals.*"%>
<%@page language="java" extends="generals.servlets.RemoteScripting"%>

<%!
	private static AbcUtils loAbcUtils = new AbcUtils();
	private static AplicationsV2 logApps = new AplicationsV2();

	public void log(String msg) {
		//DEBUG
		//logApps.writeInfo("RemoteScripting:"+msg);
	}

	/*static public String getItems(String desc) {
		String lsItems = "<table><tr><td>Aquí van los items para " + desc
				+ "</td></tr></table>";
		return lsItems;
	}*/

	static public String getItems(String clss, String base, String size,
			String prod, String topp, String half, String prod2, String topp2,
			String cant, String lsNStore) {
		HashMap<String, Double> itemConsum = new HashMap<String, Double>();
		HashMap<String, Double> itemAdjust1 = new HashMap<String, Double>();
		HashMap<String, Double> itemAdjust2 = new HashMap<String, Double>();
		boolean adjust1 = false;
		boolean adjust2 = false;
		logApps.writeInfo("\n" + new java.util.Date()
				+ ": Ejecutando busqueda para el producto");
		String altProd, altProd2;
		String toppings = "srs.toppno='000'";
		String toppings2 = "srs.toppno='000'";

		if (prod.equals("054")) {
			altProd = "012";
			adjust1 = true;
		} else if (prod.equals("060") || prod.equals("059")) {
			altProd = "011";
			adjust1 = true;
		} else {
			altProd = prod;
		}

		if (prod2.equals("054")) {
			altProd2 = "012";
			adjust2 = true;
		} else if (prod2.equals("060") || prod2.equals("059")) {
			altProd2 = "011";
			adjust2 = true;
		} else {
			altProd2 = prod2;
		}

		if (!topp.equals("")) {
			String[] tops = topp.split(",");
			//logApps.writeInfo("tops[0]" + tops[0]);

			for (int i = 0; i < tops.length; i++) {
				if (i == 0) {
					toppings = toppings.replace("000", tops[i]);
				} else {
					toppings += " or srs.toppno='" + tops[i] + "'";
				}
			}
			String query = "select adjust" + tops.length
					+ ", inv_recipe from sus_adjust_recipe where baseno='"
					+ base + "' and sizeno='" + size + "' and prodno='" + prod
					+ "'";
			logApps.writeInfo("\nQuery adjust:\n" + query);
			String lsAdjust = loAbcUtils.queryToString(query, "|", ">");
			if (!lsAdjust.equals("")) {
				String[] laAdjust = lsAdjust.split("\\|");
				for (String lcAdjust : laAdjust) {
					String[] lAdjust = lcAdjust.split(">");
					itemAdjust1.put(lAdjust[1].trim(),
							Double.valueOf(lAdjust[0]));
				}
			}
		}
		if (!topp2.equals("")) {
			String[] tops = topp2.split(",");
			//logApps.writeInfo("tops[0]" + tops[0]);

			for (int i = 0; i < tops.length; i++) {
				if (i == 0) {
					toppings2 = toppings2.replace("000", tops[i]);
				} else {
					toppings2 += " or srs.toppno='" + tops[i] + "'";
				}
			}
			String query = "select adjust" + tops.length
					+ ", inv_recipe from sus_adjust_recipe where baseno='"
					+ base + "' and sizeno='" + size + "' and prodno='" + prod2
					+ "'";
			logApps.writeInfo("\nQuery adjust2:\n" + query);
			String lsAdjust = loAbcUtils.queryToString(query, "|", ">");
			if (!lsAdjust.equals("")) {
				String[] laAdjust = lsAdjust.split("\\|");
				for (String lcAdjust : laAdjust) {
					String[] lAdjust = lcAdjust.split(">");
					itemAdjust2.put(lAdjust[1].trim(),
							Double.valueOf(lAdjust[0]));
				}
			}
		}
		//logApps.writeInfo("Se buscarán los toppings: " + toppings);
		String lsItems = "<table class=\"bsDg_table\" align=\"center\" width=\"98%\">\n";
		lsItems += "<thead>\n		<tr class=\"bsDb_tr_header\">\n			<td colspan=\"5\" style=\"text-align:center\" class=\"bsDb_td_header_right\">Producto</td>\n"
				+ "<td style=\"text-align:center\" class=\"bsDb_td_header_right\">Existencia Original</td>\n"
				+ "			<td style=\"text-align:center\" class=\"bsDb_td_header_right\" colspan=\"2\">Cantidades a traspasar</td>\n			"
				+ "<td style=\"text-align:center\" class=\"bsDb_td_header_right\">Total traspaso</td>\n			<td style=\"text-align:center\" class=\"bsDb_td_header_right\">Existencia final</td>\n"
				+ "		</tr>\n		<tr class=\"bsDb_tr_header\" valign=\"top\">\n			<td class=\"bsDb_td_header_default\" style=\"width:2%\"></td>\n			"
				+ "<td class=\"bsDb_td_header_default\" style=\"width:3%\">C&oacute;digo prov</td>\n			<td class=\"bsDb_td_header_default\" style=\"width:15%\">Nombre proveedor</td>\n"
				+ "			<td class=\"bsDb_td_header_default\" style=\"width:17%\">Descripci&oacute;n de invitem</td>\n			"
				+ "<td class=\"bsDb_td_header_default\" style=\"width:25%\">Descripci&oacute;n de producto del proveedor</td>\n"
				+ "			<td class=\"bsDb_td_header_default\" style=\"width:10%\">Unidades inventario</td>\n			<td class=\"bsDb_td_header_default\" style=\"width:5%\">Unidades<br>proveedor</td>\n			"
				+ "<td class=\"bsDb_td_header_default\" style=\"width:9%\">Unidades<br>inventario</td>\n"
				+ "			<td class=\"bsDb_td_header_default\" style=\"width:5%\">Unidades inventario</td>\n			<td class=\"bsDb_td_header_default\" style=\"width:9%\">Unidades inventario</td>\n		</tr>\n	</thead><tbody>";
		String lsInvIds = "('";

		String order = ") recipe group by 1, 2, 4, 6, 7 order by 1 desc, 2 asc";
		String query = "select num_inv, Description, sum(Use) as Use, num_inv_subrec, sum(use_sub) as use_sub, use_real, fact_conv from (";
		String subQuery = "select srs.inv_recipe as num_inv, ci.inv_desc as Description, srs.qty_use as Use, ssr.inv_id as num_inv_subrec, "
				+ "ssr.qty_use as use_sub, "
				+ cant
				+ " as use_real, ci.rcp_conversion_factor as fact_conv "
				+ "from op_grl_cat_inventory as ci, sus_recipe_spec as srs "
				+ "left join sus_sub_recipe as ssr ON (srs.inv_recipe=ssr.recipe_no) "
				+ "where srs.classno='"
				+ clss
				+ "' and srs.baseno='"
				+ base
				+ "' and srs.sizeno='"
				+ size
				+ "' and srs.prodno='"
				+ altProd
				+ "' and ("
				+ toppings
				+ ") "
				+ "and (ci.inv_id=srs.inv_recipe or ci.inv_id=ssr.inv_id) "
				+ "UNION "
				+ "select srs.inv_recipe as num_inv, ci.inv_desc as Description, srs.qty_use as Use, ssr.inv_id as num_inv_subrec, "
				+ "ssr.qty_use as use_sub, "
				+ cant
				+ " as use_real, ci.rcp_conversion_factor as fact_conv "
				+ "from op_grl_cat_inventory as ci, sus_recipe_spec as srs "
				+ "left join sus_sub_recipe as ssr ON (srs.inv_recipe=ssr.recipe_no) "
				+ "where srs.classno='"
				+ clss
				+ "' and srs.baseno='"
				+ base
				+ "' and srs.sizeno='"
				+ size
				+ "' and srs.prodno='"
				+ prod
				+ "' and srs.toppno='000' and (ci.inv_id=srs.inv_recipe or ci.inv_id=ssr.inv_id) ";
		//Seccion de query para mitad lado B
		if (half.equals("1")) {
			subQuery += "UNION "
					+ "select srs.inv_recipe , ci.inv_desc as Description, srs.qty_use as Use, ssr.inv_id, "
					+ "ssr.qty_use as use_sub, "
					+ cant
					+ " as use_real, ci.rcp_conversion_factor as fact_conv "
					+ "from op_grl_cat_inventory as ci, sus_recipe_spec as srs "
					+ "left join sus_sub_recipe as ssr ON (srs.inv_recipe=ssr.recipe_no) "
					+ "where srs.classno='" + clss + "' " + "and srs.baseno='"
					+ base + "' " + "and srs.sizeno='" + size + "' "
					+ "and srs.prodno='" + altProd2 + "' " + "and ("
					+ toppings2 + ") "
					+ "and (ci.inv_id=srs.inv_recipe or ci.inv_id=ssr.inv_id) ";
		}
		query += subQuery;
		query += order;

		logApps.writeInfo("\nQuery: \n" + query);

		String lsResult = loAbcUtils.queryToString(query, "|", ">");
		//logApps.writeInfo("\nlsResult: [" + lsResult + "]");
		if (lsResult.equals("")) {
			logApps.writeInfo("No se encontro una receta para el producto seleccionado \n\tclase: ["
							+ clss
							+ "], \n\tbase: ["
							+ base
							+ "], \n\tTamaño: ["
							+ size
							+ "],\n\tProducto1: ["
							+ prod
							+ "],\n\tTopping1: ["
							+ topp
							+ "],\n\tProducto2: ["
							+ prod2
							+ "]\n\tTopping2: ["
							+ topp2 + "]");
			lsItems += "<tr align=\"center\"><td colspan=\"10\" ><p class=descriptionTabla style=\"font-size: 18px;\">"
					+ "No hay datos para el producto seleccionado, por favor seleccione otro producto"
					+ "</p></td></tr>\n</tbody></table>\n";
			return lsItems;
		} else {
			String[] laResult = lsResult.split("\\|");
			for (String lrResult : laResult) {
				String[] lcResult = lrResult.split(">");
				if (lcResult[0].startsWith("0")) {
					lsInvIds += lcResult[3].trim() + "','";
					double ldConsumo = Double.valueOf(lcResult[4].trim())
							/ Double.valueOf(lcResult[6].trim());
					ldConsumo *= Double.valueOf(cant);
					ldConsumo = Math.floor(ldConsumo * 10000) / 10000;
					itemConsum.put(lcResult[3].trim(),
							Double.valueOf(ldConsumo));
				} else {
					lsInvIds += lcResult[0].trim() + "','";
					double ldConsumo = Double.valueOf(lcResult[2].trim())
							/ Double.valueOf(lcResult[6].trim());
					ldConsumo *= Double.valueOf(cant);
					if (adjust1) {
						if (itemAdjust1.containsKey(lcResult[0].trim())) {
							ldConsumo += itemAdjust1.get(lcResult[0].trim());
						}
					}
					if (adjust2) {
						if (itemAdjust2.containsKey(lcResult[0].trim())) {
							ldConsumo += itemAdjust2.get(lcResult[0].trim());
						}
					}
					if (half.equals("1")) {
						ldConsumo *= 0.5;
					}
					ldConsumo = Math.floor(ldConsumo * 10000) / 10000;
					itemConsum.put(lcResult[0].trim(), ldConsumo);
				}
				/*
				 lsItems += "<tr>\n<td></td>";
				 for (String result : lcResult) {
				 lsItems += "<td>" + result + "</td>\n";
				 }
				 lsItems += "</tr>\n";*/
			}
		}
		lsInvIds = lsInvIds.substring(0, (lsInvIds.length() - 2)) + ")";
		logApps.writeInfo("\nInvIds: " + lsInvIds);
		String lsTransferId = insertStepTransfer(lsInvIds, lsNStore, itemConsum);

		lsResult = getDetailItems(lsTransferId);
		String[] laResult = lsResult.split("\\|");
		int indexF = 0;
		for (String lrResult : laResult) {
			String[] lcResult = lrResult.split(">");
			logApps.writeInfo("Item: [" + lcResult[0].trim() + "], consumo: ["
					+ itemConsum.get(lcResult[0].trim()) + "], lcResult[" + 7
					+ "]: [" + lcResult[7] + "]");
			String lsConsumo = itemConsum.get(lcResult[0].trim())
					+ " "
					+ (lcResult[7].equals("null") ? lcResult[7 + 1]
							: lcResult[7].substring(lcResult[7].indexOf(" ")));
			lsItems += "<tr class=\"bsDg_tr_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0) + "\" >\n";
			//Inv Id
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\"><input type=\"text\" name=\"chkRowControl|"
					+ indexF
					+ "\" id=\"chkRowControl|"
					+ indexF
					+ "\" value=\""
					+ lcResult[0]
					+ "\" class=\"descriptionTabla\" style=\"border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;\" readonly size=\"4\"></td>\n";
			//Código prov
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\"><input type=\"text\" name=\"provider_product_code|"
					+ indexF
					+ "\" id=\"provider_product_code|"
					+ indexF
					+ "\" value=\""
					+ lcResult[1]
					+ "\" class=\"descriptionTabla\" style=\"border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;\" readonly size=\"10\"></td>\n";
			//Nombre proveedor
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\">"
					+ lcResult[2] + "</td>\n";
			//Descripción de invitem
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\">"
					+ lcResult[3] + "</td>\n";
			//Descripción de producto del proveedor
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\"><input type=\"text\" name=\"provider_product_desc|"
					+ indexF
					+ "\" id=\"provider_product_desc|"
					+ indexF
					+ "\" value=\""
					+ lcResult[4]
					+ "\" class=\"descriptionTabla\" style=\"border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;\" readonly size=\"40\"></td>\n";
			//Existencia Original 
			//Unidades inventario
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\">"
					+ lcResult[5] + "</td>\n";
			//Cantidades a traspasar
			//			 	Unidades proveedor
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\"><input type=\"text\" name=\"providerQty|"
					+ indexF
					+ "\" id=\"providerQty|"
					+ indexF
					+ "\" value=\""
					+ lcResult[6]
					+ " "
					+ lcResult[10]
					+ "\" class=\"descriptionTabla\" style=\"border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;\" readonly></td>\n";
			//				Unidades inventario
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\">"
					+ lsConsumo + "</td>\n";
			//Total traspaso
			//					Unidades inventario
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\"><input type=\"text\" name=\"inventoryQty|"
					+ indexF
					+ "\" id=\"inventoryQty|"
					+ indexF
					+ "\" value=\""
					+ lsConsumo
					+ "\" class=\"descriptionTabla\" style=\"border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;\" readonly></td>\n";
			//Existencia final
			//			 	Unidades inventario
			lsItems += "<td class=\"bsDg_td_row_zebra_"
					+ (indexF % 2 == 0 ? 1 : 0)
					+ "\" id=\"bsDg_row_1 bsDg_col_0\" style=\"cursor:default;\">0 "
					+ lcResult[9] + "\n";

			lsItems += "<input name=\"inventoryUm|" + indexF
					+ "\" id=\"inventoryUm|" + indexF + "\" value=\""
					+ lcResult[9] + "\" type=\"hidden\">\n"
					+ "<input name=\"providerUm|" + indexF
					+ "\" id=\"providerUm|" + indexF + "\" value=\""
					+ lcResult[10]
					+ "\" type=\"hidden\">\n"
					+ "<input name=\"providerFc|"
					+ indexF
					+ "\" id=\"providerFc|"
					+ indexF
					+ "\" value=\""
					+ lcResult[11]
					+ "\" type=\"hidden\">\n"
					//+ "<input name=\"provider_product_desc|1\" id=\"provider_product_desc|1\" value="JITOMATE" type="hidden">
					+ "<input name=\"provider_id|" + indexF + "\" value=\""
					+ lcResult[13] + "\" type=\"hidden\">\n"
					+ "<input name=\"existence|" + indexF
					+ "\" id=\"existence|" + indexF
					+ "\" value=\"0.0\" type=\"hidden\">\n"
					+ "<input name=\"stock_code_id|" + indexF + "\" value=\""
					+ lcResult[12] + "\" type=\"hidden\">\n";

			lsItems += "\n</td>\n";
			lsItems += "</tr>\n";
			indexF++;
		}

		lsItems += "</tbody></table>\n";
		//logApps.writeInfo("lsItems:\n" + lsItems);
		return lsItems;
	}

	private static String insertStepTransfer(String lsInvIds, String lsNStore,
			HashMap<String, Double> itemCons) {
		String lsTransferId = getTransferId();
		String ipNeighbor = getIpNeighborStore(lsNStore);
		loAbcUtils.executeSQLCommand("DELETE FROM op_grl_step_transfer");
		String lsInsert = "INSERT INTO op_grl_step_transfer (transfer_id, local_store_id, neighbor_store_id, date_id, transfer_type) "
				+ "VALUES ("
				+ lsTransferId
				+ ",(SELECT store_id FROM ss_cat_store), "
				+ lsNStore
				+ ", (SELECT NOW()::TIMESTAMP),'1')";
		logApps.writeInfo("\nlsInsert:\n" + lsInsert);
		loAbcUtils.executeSQLCommand(lsInsert);
		String query = "SELECT DISTINCT ON (i.inv_id) i.inv_id, prod.stock_code_id, prod.provider_product_code, '0' AS provider_quantity,"
				+ "'0' AS inventory_quantity,"
				+ "prod.conversion_factor as prv_conversion_factor,"
				+ "substr(pum.unit_name,1,4) as prv_unit_name,"
				+ "substr(ium.unit_name,1,4) as inv_unit_name,"
				+ "prod.provider_id,"
				+ "'0' as existence "
				+ "FROM op_grl_cat_inventory i "
				//+ "INNER JOIN op_grl_existence e ON (i.inv_id = e.inv_id) "
				+ "INNER JOIN op_grl_cat_providers_product prod ON (i.inv_id = prod.inv_id) "
				+ "INNER JOIN op_grl_cat_provider prov ON (prod.provider_id = prov.provider_id) "
				+ "INNER JOIN op_grl_cat_unit_measure pum ON (prod.provider_unit_measure = pum.unit_id) "
				+ "INNER JOIN op_grl_cat_unit_measure ium ON (i.inv_unit_measure = ium.unit_id) "
				+ "LEFT JOIN op_grl_suggested_transfer s ON (i.inv_id = s.inv_id) "
				+ "INNER JOIN (select * from dblink('hostaddr="
				+ ipNeighbor
				+ " dbname=dbeyum user=postgres','SELECT inv_id, provider_product_code, provider_id "
				+ "FROM op_grl_cat_providers_product WHERE active_flag IN (1,2)') as a "
				+ "(inv_id character(6),provider_product_code character(10), provider_id character(10))) dbl on (prod.provider_id = dbl.provider_id AND prod.inv_id = dbl.inv_id "
				+ "AND prod.provider_product_code=dbl.provider_product_code) "
				+ "WHERE prod.active_flag IN (1,2) AND i.inv_id IN "
				+ lsInvIds
				+ " ORDER BY inv_id ASC";
		logApps.writeInfo("\nEjecutando busqueda de productos:\n" + query);
		String lsResult = loAbcUtils.queryToString(query, "|", ">");
		logApps.writeInfo("\nlsResult:\n" + lsResult + "\n");
		String[] laResult = lsResult.split("\\|");

		lsInsert = "INSERT INTO op_grl_step_transfer_detail VALUES ";
		for (String lrResult : laResult) {
		logApps.writeInfo("lrResult: " + lrResult);
			String[] lcResult = lrResult.split(">");
			int index = 0;
			lsInsert += "(" + lsTransferId + ",'";
			for (String result : lcResult) {
				if (index == 4) {
					lsInsert += itemCons.get(lcResult[0].trim()) + "','";
				} else {
					lsInsert += result + "','";
				}
				index++;
			}
			lsInsert = lsInsert.substring(0, (lsInsert.length() - 2)) + "),";
		}
		lsInsert = lsInsert.substring(0, (lsInsert.length() - 1));
		logApps.writeInfo("\nInsert tmp:\n" + lsInsert);
		loAbcUtils.executeSQLCommand(lsInsert);
		return lsTransferId;
	}

	private static String getDetailItems(String psTransferId) {
		String lsQuery = "SELECT DISTINCT t.inv_id, prod.provider_product_code, "
				+ "prov.name, inv.inv_desc, prod.provider_product_desc, "
				+ "ROUND(CAST(t.existence AS numeric),2)||' '||t.inventory_unit_measure AS existence, 0 as provider_quantity,"
				//+ "ROUND((t.inventory_quantity / t.prv_conversion_factor) ,2) || ' ' || t.provider_unit_measure AS provider_quantity, "
				+ "t.inventory_quantity || ' ' || t.inventory_unit_measure AS inventory_quantity, "
				+ "s.required || ' ' || substr(t.inventory_unit_measure,1,4) AS required_quantity, "
				+ "t.inventory_unit_measure, t.provider_unit_measure, t.prv_conversion_factor, "
				+ "prod.stock_code_id, prod.provider_id "
				+ "FROM op_grl_step_transfer_detail t INNER JOIN op_grl_cat_providers_product prod "
				+ "ON (t.inv_id = prod.inv_id AND t.provider_product_code = prod.provider_product_code "
				+ "AND t.provider_id = prod.provider_id ) "
				+ "INNER JOIN op_grl_cat_provider prov "
				+ "ON (prod.provider_id = prov.provider_id) "
				+ "INNER JOIN op_grl_cat_inventory inv ON (inv.inv_id = prod.inv_id) "
				//+ "INNER JOIN op_grl_local_existence lpe ON (lpe.inv_id = prod.inv_id) "
				+ "LEFT JOIN op_grl_suggested_transfer s ON (t.inv_id = s.inv_id) "
				+ "WHERE prod.active_flag IN(1,2) "
				+ " AND t.transfer_id="
				+ psTransferId;
		logApps.writeInfo("\nQuery de busqueda de detalle:\n" + lsQuery + "\n");
		return loAbcUtils.queryToString(lsQuery, "|", ">");
	}

	public static String verifyCredentials(String psUser, String psPwd) {
		String lsSUSID = "0";
		String[] loUsr = psUser.split(" ");
		String loPwd = psPwd;
		try {
			String qry = "SELECT sus_id FROM pp_employees WHERE emp_num='"
					+ loUsr[0] + "' and sus_pass='" + loPwd + "'";
			logApps.writeInfo(qry);
			lsSUSID = loAbcUtils.queryToString(qry, "", "");
			if (lsSUSID.length() > 0) {
				psUser = stripAccents(psUser);
				logApps.writeInfo("\nSe actualizara el responsable por "
						+ psUser + "\n");
				psUser = psUser.length() > 30 ? psUser.substring(0, 30)
						: psUser;
				qry = "UPDATE op_grl_step_transfer set responsible='" + psUser
						+ "'";
				loAbcUtils.executeSQLCommand(qry);
				return lsSUSID;
			} else {
				return "FALSE";
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

	public static String validaNumToppings(String clss, String prod, String topp) {
		String valTopps = "OK";
		String[] tops = topp.split(",");
		String query = "SELECT prmax_topp FROM sus_prod WHERE clno='" + clss
				+ "' and prno='" + prod + "'";
		int rsQuery = Integer.valueOf(loAbcUtils.queryToString(query));
		logApps.writeInfo("\nMáximo de toppings para el producto " + prod
				+ ": [" + Integer.valueOf(rsQuery)
				+ "]\nTotal de toppings seleccionados: [" + tops.length + "]");
		if (rsQuery < tops.length) {
			valTopps = rsQuery + "";
		}
		return valTopps;
	}

	private static String getIpNeighborStore(String psNStore) {
		String lsIPNStore = "localhost";
		String query = "SELECT ip_addr FROM ss_cat_neighbor_store WHERE store_id="
				+ psNStore;
		String tmpIP = loAbcUtils.queryToString(query, "", "");
		if (tmpIP.length() > 0) {
			lsIPNStore = tmpIP;
		}
		return lsIPNStore;
	}

	private static String stripAccents(String psInput) {
		String lsAscii = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ0123456789_abcdefghijklmnopqrstuvwxyz";
		String lsNuevo = "                              ";
		char[] laName = psInput.toUpperCase().toCharArray();
		char[] laAscii = lsAscii.toCharArray();
		char[] laNuevo = lsNuevo.toCharArray();
		String lsOutput = psInput;
		for (int i = 0; i < laName.length; i++) {
			int pos = lsAscii.indexOf(laName[i]);
			if (pos > -1) {
				//System.out
				//	.println("No vamos a limpiar esto[" + laName[i] + "]");
				laNuevo[i] = laName[i];
			} else {
				//logApps.writeInfo("Vamos a limpiar esto:" + laName[i]
				//	+ " por _");
				laNuevo[i] = '_';
			}
		}//for i
		return new String(laNuevo);
	}

	private static String getTransferId() {
		String transferId = "";
		String lsQuery = "SELECT max(transfer_id)+1 from op_grl_confirm_transfer";
		transferId = loAbcUtils.queryToString(lsQuery);
		return transferId;
	}%>