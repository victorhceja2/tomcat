<%@ include file="/Include/CommonLibYum.jsp" %>   
<%!
/**Obtiene el Id para la excepcion de en la tabla de paso**/
String getStepExcepId(){
	String lsQuery;
	
	lsQuery = "SELECT exception_id FROM op_grl_step_exception";
	return moAbcUtils.queryToString(lsQuery);
}
/**Borra los valores de op_grl_step_exception y op_grl_step_exception_detail**/
void cleanStepExcep(){
	String lsQuery;
	lsQuery = "DELETE FROM op_grl_step_exception_detail";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{});

	lsQuery = "DELETE FROM op_grl_step_exception";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{});
}

void cleanStepTransfer(){
	String lsQuery;
	lsQuery = "DELETE FROM op_grl_step_transfer";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{});
}

    int getDayOfWeek()
    {
        String lsQuery   = "SELECT current_day()";
        String dayOfWeek = moAbcUtils.queryToString(lsQuery,"","");

        return Integer.parseInt(dayOfWeek);
    }

String getSDCExtension(){
	Calendar calendar = Calendar.getInstance();
	int month         = calendar.get(Calendar.MONTH) + 1;
	int day           = calendar.get(Calendar.DAY_OF_MONTH);
	
	String lsmonth    = Integer.toString(month, 16);
	String lsday      = Str.padZero(day, 2);
	
	return lsmonth + lsday;
}

    String getDexFileName(String psLocalStore)
    {
        String filename = psLocalStore + "dex." + getSDCExtension();

        return "/usr/fms/op/rpts/sdc_dex/"+filename;
    }

String getDrtFileName(String psStore)
{
	String filename = psStore + "drt." + getSDCExtension();
	return "/usr/fms/op/rpts/sdc_drt/"+filename;
}

String getFmsFileName(){
	java.text.DateFormat loDateFormat;
	String lsCurrDate;
	String lsFilename;
	
	loDateFormat = new java.text.SimpleDateFormat("yy-MM-dd");
	lsCurrDate   = loDateFormat.format(new Date());
	
	lsFilename   = "/usr/bin/ph/rpcost/" + lsCurrDate +".fms";
	return lsFilename;
}

String getRecepFileName(){
	java.text.DateFormat loDateFormat;
	String lsCurrDate;
	String lsFilename;
	
	loDateFormat = new java.text.SimpleDateFormat("yy-MM-dd");
	lsCurrDate   = loDateFormat.format(new Date());
	
	lsFilename   = "/usr/bin/ph/3w_recepcion/" + lsCurrDate +".txt";
	return lsFilename;
}

boolean savedExcepFiles(String psExcepId){
	java.text.DateFormat loDateFormat;
	String lsQuery, lsSDCDate, lsFMSDate;
	String laRecepRecords[];
	String laResult[][];
	try{
		String lsStore = getUnit();
		lsStore = Str.padZero(lsStore, 5);
		String lsRecepFile    =getRecepFileName();
		String lsFmsFile      = getFmsFileName();
		String lsSDCFile      = getDrtFileName(lsStore);
		
		loDateFormat= new java.text.SimpleDateFormat("MMddyy");
		lsSDCDate  = loDateFormat.format(new Date());

		loDateFormat= new java.text.SimpleDateFormat("yy-MM-dd");
		lsFMSDate   = loDateFormat.format(new Date());

		//Para archivo de recepcion
		FileWriter lfReception = new FileWriter(lsRecepFile, true);
		//Para archivo rpcost de inventario 
		FileWriter lfFMS       = new FileWriter(lsFmsFile, true);
		//Para archivo sdc_drt
		FileWriter lfSDC       = new FileWriter(lsSDCFile, true);

		lsQuery = "SELECT e.reception_id, rtrim(ltrim(e.document_num)), r.remission_id, r.order_id, e.store_id, e.date_id, rtrim(ltrim(r.provider_id)), "+
		"rtrim(ltrim(p.inv_id)), rtrim(ltrim(p.stock_code_id)), ed.provider_product_code, ed.received_quantity, "+
		"substr(up.unit_id,1,4), ed.difference_id, r.document_type_id, r.report_num, ed.unit_cost, "+
		"Ltrim(to_char(p.conversion_factor * ed.received_quantity,'9999990.99')) as inv_received, "+
		"Ltrim(to_char(ed.unit_cost * ed.received_quantity,'9999990.99')) as total_cost "+
		"FROM op_grl_exception e "+
		"INNER JOIN op_grl_reception r ON r.reception_id = e.reception_id "+
		"INNER JOIN op_grl_exception_detail ed ON ed.exception_id = e.exception_id "+
		"INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = ed.provider_product_code AND p.provider_id = r.provider_id  "+
		"INNER JOIN op_grl_cat_unit_measure up ON up.unit_id = p.provider_unit_measure "+
		"WHERE e.exception_id='"+psExcepId+"'";

		laResult    = moAbcUtils.queryToMatrix(lsQuery);

		for(int rowId=0; rowId<laResult.length; rowId++){
			//Formateo para 3w_recepcion
			String lsDocumentNum         = Str.padRight(laResult[rowId][1], 15);
			String lsRemissionId         = Str.padRight(laResult[rowId][2], 10);
			String lsProviderId          = Str.padRight(laResult[rowId][6], 10);
			String lsInvId               = Str.padRight(laResult[rowId][7], 6);
			String lsStockCodeId         = Str.padRight(laResult[rowId][8], 6);
			String lsProviderProductCode = Str.padRight(laResult[rowId][9], 10);
			String lsProviderUnit        = Str.padRight(laResult[rowId][11], 4);
			String lsDifferenceId        = Str.padRight(laResult[rowId][12], 2);
			
			//Registro para 3w_recepcion
			String lsRegRecep = laResult[rowId][0]+"|"+lsDocumentNum+"|"+lsRemissionId+"|"+laResult[rowId][3]+"|"+laResult[rowId][4]+"|"+
			                    laResult[rowId][5]+"|"+lsProviderId+"|"+lsInvId+"|"+lsStockCodeId+"|"+lsProviderProductCode+"|"+laResult[rowId][10]+"|"+
					    lsProviderUnit+"|"+lsDifferenceId+"|"+laResult[rowId][13]+"|"+laResult[rowId][14]+"|"+laResult[rowId][15]+"|3";
			lfReception.write(lsRegRecep);
			lfReception.write('\n');

			//Formateo para rpcost
			float lfQtyReceivedInv  = Float.parseFloat(laResult[rowId][16]);
			String lsQtyReceivedInv = Str.getFormatted("%9.2f", lfQtyReceivedInv);
			float lfProviderPrice   = Float.parseFloat(laResult[rowId][15]);
			String lsProviderPrice = Str.getFormatted("%15.2f", lfProviderPrice);
	
			//Registro para rpcost
			String lsRegFMS = laResult[rowId][7]+", "+lsFMSDate+", "+lsQtyReceivedInv+","+
				laResult[rowId][1]+", "+lsProviderPrice+", "+laResult[rowId][6]+",";
			lfFMS.write(lsRegFMS);
			lfFMS.write('\n');

			//Formateo para sdc_drt
			float lfQtyReceivedProv  = Float.parseFloat(laResult[rowId][10]);
			String lsQtyReceivedProv = Str.getFormatted("%9.2f", lfQtyReceivedProv);
			float lfTotalCost  = Float.parseFloat(laResult[rowId][17]);
			String lsTotalCost = Str.getFormatted("%15.2f", lfTotalCost);
						
			String lsRegSDC = lsStore+", "+laResult[rowId][8]+", "+lsSDCDate+", "+
				lsQtyReceivedProv+", "+laResult[rowId][1]+", "+lsTotalCost+", "+
				laResult[rowId][6]+",";
			lfSDC.write(lsRegSDC);
			lfSDC.write('\n');
		}
		lfSDC.close();	
		lfFMS.close();
		lfReception.close();
		
		// Para actualizar el archivo de inventario. 
		//Que se lean los archivos .fms en /usr/bin/ph/rpcost/
		String laPFSCommand [] = {"/usr/local/tomcat/webapps/ROOT/Scripts/exp_invtran.s"};
		Process process = Runtime.getRuntime().exec(laPFSCommand);
		process.waitFor();
		return true;
	}catch(Exception e){
	System.out.println("savedExcepFiles() exception " + e);
	return false;
	}
}
    /**  Obtiene un ID para la excepcion */
    String getExcepId(){
        return moAbcUtils.queryToString("SELECT nextval('excep_seq')","","");
    }

    /**
        Obtiene el tipo de una transferencia:
        input: transferencia de entrada
        output: transferencia de salida
    */
    String getTransferType(String psTransferId)
    {
        String lsQuery;

        lsQuery = "SELECT CASE WHEN(transfer_type=1) THEN 'input' ELSE" +
                  "'output' END FROM op_grl_transfer WHERE transfer_id="+psTransferId;

        return moAbcUtils.queryToString(lsQuery);
    }
/**Obtiene la fecha de una exception*/
String getExcepDate(String psExcepId){
	String lsQuery;
	lsQuery = "SELECT date_id FROM op_grl_exception WHERE exception_id="+psExcepId;
	return moAbcUtils.queryToString(lsQuery);
}


    String getNeighborStores()
    {
        String lsQuery;

        lsQuery = "SELECT ltrim(rtrim(store_id)), store_desc FROM ss_cat_neighbor_store "+
                  "ORDER BY store_desc asc ";
    
        return lsQuery;
    }

    String getDateTime()
    {
        String lsDate="";
        Date ldToday=new Date();
        String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
        int liMonth=(int)ldToday.getMonth();
        int liDay=(int)ldToday.getDate();
        java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
        Calendar lsC1 = Calendar.getInstance(); 
        lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay); 
        
        lsDate=lsDF.format(lsC1.getTime());
        return(lsDate);
    }

    /**Obtiene el Id para la transferencia de paso*/
    String getStepTransferId()
    {
        String lsQuery;

        lsQuery = "SELECT transfer_id FROM op_grl_step_transfer";

        return moAbcUtils.queryToString(lsQuery);
    }

    /**
        Obtiene el ID-NOMBRE del restaurante al que se hace la transferencia
    */
    String getRemoteStore(String psTransferId)
    {

        String lsQuery;

        lsQuery = "SELECT store_id || '-' || store_desc FROM ss_cat_neighbor_store, "+
                  "op_grl_transfer WHERE ss_cat_neighbor_store.store_id = " +
                  "op_grl_transfer.neighbor_store_id AND transfer_id = " + psTransferId;

        return moAbcUtils.queryToString(lsQuery);
    }

    /**
        Obtiene el ID-NOMBRE del restaurante que hace la transferencia
    */
    String getLocalStore(String psTransferId)
    {

        String lsQuery;
        
        lsQuery = "SELECT store_id || '-' || store_desc FROM ss_cat_store, " +
                  "op_grl_transfer WHERE ss_cat_store.store_id = " +
                  "op_grl_transfer.local_store_id AND transfer_id = " + psTransferId;

        return moAbcUtils.queryToString(lsQuery);
    }

void saveExcep(String psExcepId,String psResponsible){
	String lsQuery;
			
	lsQuery = "INSERT INTO op_grl_exception SELECT * FROM op_grl_step_exception "+
			"WHERE exception_id=?";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{psExcepId});
	
	lsQuery = "INSERT INTO op_grl_exception_detail SELECT * FROM op_grl_step_exception_detail " +
			"WHERE exception_id=?";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{psExcepId});
	
	//Aniadiendo el responsable el la BDD
	lsQuery = "UPDATE op_grl_exception SET responsible=? WHERE exception_id=?";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{psResponsible,psExcepId});
}

//despTotal es para saber si desplegamos la parte del total en la pantalla o no 
String getExcepDetailQuery(boolean despTotal){
	return getExcepDetailQuery(false,despTotal);
}
String getExcepDetailQuery(boolean step,boolean despTotal){
	return getExcepDetailQuery(step, null,despTotal);
}

String getExcepDetailQuery(boolean step, String psExcepId,boolean despTotal){
	String lsExcepTable, lsQuery, lsExcepTableMaster;
	lsExcepTable = (step==true)?"op_grl_step_exception_detail":"op_grl_exception_detail";
	lsExcepTableMaster = (step==true)?"op_grl_step_exception":"op_grl_exception";
	lsQuery = "SELECT p.inv_id as orden,e.provider_product_code, p.provider_product_desc, " +
	"e.received_quantity || ' ' || substr(up.unit_name,1,4) as qty_received, d.dif_desc,  " +
	"Ltrim(to_char(e.received_quantity * p.conversion_factor,'9999990.99') || ' ' || substr(ui.unit_name,1,4)) as qty_received_inv, " +
	"Ltrim(to_char(e.unit_cost,'9999990.99')) as unit_cost, " +
	"Ltrim(to_char(e.unit_cost * e.received_quantity,'9999990.99')) as subtotal, " +
	"cp.name, to_char(p.conversion_factor,'9999990.99'), substr(ui.unit_name,1,4),substr(up.unit_name,1,4) " +
	"FROM "+lsExcepTable +" e  " +
        "INNER JOIN "+lsExcepTableMaster +" ex ON  ex.exception_id = e.exception_id " +
	"INNER JOIN op_grl_cat_providers_product p ON e.provider_product_code = p.provider_product_code " +
        "INNER JOIN op_grl_reception r ON r.reception_id = ex.reception_id AND p.provider_id = r.provider_id " +
	"INNER JOIN op_grl_cat_provider cp ON p.provider_id = cp.provider_id " +
	"INNER JOIN op_grl_cat_unit_measure up ON p.provider_unit_measure = up.unit_id " +
	"INNER JOIN op_grl_cat_difference d ON d.difference_id = e.difference_id " +
	"INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id " +
	"INNER JOIN op_grl_cat_unit_measure ui ON ui.unit_id = i.inv_unit_measure ";
	if(psExcepId != null)
		lsQuery += " AND e.exception_id = " + psExcepId;
	if(despTotal==true){
	lsQuery +=" UNION " +
	"SELECT '999999' as orden,CAST('&nbsp;' as varchar),CAST('&nbsp;' as varchar), " +
	"CAST('&nbsp;' as varchar),CAST('&nbsp;' as varchar),CAST('&nbsp;' as varchar), " +
	"CAST('<b>TOTAL</b>' as varchar), "+
	"to_char(ROUND(SUM((Case  When e.received_quantity = Null then 0 else e.received_quantity end)*e.unit_cost),2),'9999990.99'), "+
	"CAST('&nbsp;' as varchar),CAST('&nbsp;' as varchar),CAST('&nbsp;' as varchar),CAST('&nbsp;' as varchar) " +
	"FROM "+ lsExcepTable +" e  ";
	if(psExcepId != null)
		lsQuery += " WHERE exception_id = " + psExcepId;
	}
 	lsQuery += " ORDER BY orden ";
 	return lsQuery;
}

    String getChooseProductsQuery(String psInvId)
    {
        String lsQuery;
	lsQuery = "SELECT p.inv_id, p.provider_product_code, p.provider_product_desc, " +
		"to_char(0,'90.99') || ' ' ||substr(m.unit_name,1,4) AS qty_received, " +
		"c.family_desc as category, " +
		"to_char(0,'90.99') || ' ' ||substr(vwm.unit_name,1,4) , ROUND(p.provider_price,2), " +
		"to_char(0,'90.99') AS subtotal, " +
		"Ltrim(prv.name), " +
		"p.conversion_factor, " +
		"vwm.unit_name, " +
		"substr(m.unit_name,1,4) AS unit_prov " +
		"FROM  op_grl_cat_providers_product p " +
		"INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id " +
		"INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure  " +
		"INNER JOIN op_grl_cat_provider prv   ON prv.provider_id=p.provider_id  " +
		"INNER JOIN  op_grl_cat_family c ON c.family_id=i.family_id  " +
		"INNER JOIN   op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure " +
		"WHERE p.active_flag<>0 " +
		"AND p.provider_id='PFS' " +
		"AND p.inv_id NOT IN ('" + psInvId + "') " +
		" ORDER BY p.provider_product_desc ASC ";
		return lsQuery;
    }

    String getSelectedItems(HttpServletRequest poRequest)
    {
        Enumeration loParameters = poRequest.getParameterNames();
        String lsInvId = "";
        while(loParameters.hasMoreElements())
        {
            String lsParamName = (String)loParameters.nextElement();
        
            if(lsParamName.indexOf("chkRowControl") != -1)
            {
                String lsRowId = lsParamName.substring(lsParamName.indexOf('|')+1);
                lsInvId    += poRequest.getParameter("chkRowControl|"+lsRowId) + ",";
            }
        }
        lsInvId += "-1";

        return lsInvId;
    }

String getReceptionId(String psDocNum){
	String lsQuery = "SELECT reception_id FROM op_grl_reception WHERE document_num='"+ psDocNum+"'";
        return moAbcUtils.queryToString(lsQuery,"","");
}

String getUnit(){
	String lsQuery = "SELECT store_id FROM ss_cat_store";
        return moAbcUtils.queryToString(lsQuery,"","");
}

String getUnitName(){
	String lsQuery = "SELECT store_desc FROM ss_cat_store where store_id='" + getUnit() + "'";
        return moAbcUtils.queryToString(lsQuery,"","");
}

/* Method used in ExcepPreview */
void insertItems(HttpServletRequest poRequest, String psDocNum){
	String lsExcepId = getExcepId();
	String lsDateId  = getDateTime();
	String lsDocNum  = psDocNum.trim();
	String lsRecepId = getReceptionId(lsDocNum);
	String lsStore   = getUnit();
	
	//Concatenando la letra de la excepcion al mismo numero de documento
	lsDocNum  = psDocNum.trim() + "a"; 
	
	// Se inserta el maestro de la excepcion
	String lsQuery = "INSERT INTO op_grl_step_exception VALUES(?,?,?,?,?)";
	moAbcUtils.executeSQLCommand(lsQuery, new String[]{lsExcepId, lsRecepId, lsStore, lsDocNum, lsDateId});

	//Se insertan el detalle de la excepcion
	// -----------------------+---------------+------------------------------
	//  exception_id          | integer       | not null default 0
	//  provider_product_code | character(10) | not null default ''::bpchar
	//  received_quantity     | numeric(12,2) | not null default 0.00
	//  difference_id         | character(2)  | not null default '0'::bpchar
	//  unit_cost             | numeric(12,2) | default 0.00


	lsQuery = "INSERT INTO op_grl_step_exception_detail VALUES(?,?,?,?,?)";
	
	Enumeration loParameters = poRequest.getParameterNames();
	
	while(loParameters.hasMoreElements()){
		String lsParamName = (String)loParameters.nextElement();
         
		if(lsParamName.indexOf("chkRowControl") != -1){
			String lsRowId = lsParamName.substring(lsParamName.indexOf('|')+1);

			String lsProvPro = poRequest.getParameter("provider_product_code|"+lsRowId);
			String lsQtyReceived = poRequest.getParameter("qtyReceived|"+lsRowId);
			lsQtyReceived  = lsQtyReceived.substring(0,lsQtyReceived.indexOf(" "));
			String lsDiscCode = poRequest.getParameter("discCode|"+lsRowId);
			String lsUnitPrice = poRequest.getParameter("unitPrice|"+lsRowId);

                 moAbcUtils.executeSQLCommand(lsQuery, 
                 new String[]{lsExcepId, lsProvPro.trim(), lsQtyReceived, lsDiscCode.trim(), lsUnitPrice });
		}
	}
}//Fin metodo

String getDataset(int transferExists){
		return getDataset(transferExists, false);
}

String getDataset(int transferExists, boolean allowNegatives){
        String dataset;
        switch(transferExists){
		//Existen datos en la tabla de paso.
		case 1:
			dataset = moAbcUtils.getJSResultSet(getExcepDetailQuery(true,false)); //true->tabla de paso
		break;
		case 0:
			cleanStepTransfer();
			dataset = "new Array()";
		break;
		case 2:
			dataset = "new Array()";
		break;
		default:
			dataset = "new Array()";
	}
	return dataset;    
}
   
boolean excepOK(String psExcepId,String psResponsible){
	try{
		String lsQuery, lsStatus;

            //Checar si existe ID excepcion
		lsQuery  = "SELECT count(exception_id) FROM op_grl_exception WHERE " +
			"exception_id="+psExcepId;
	
		lsStatus = moAbcUtils.queryToString(lsQuery);

		if(Integer.parseInt(lsStatus)>0){ //si la excepcion ya existe
			System.out.println("Se intento duplicar la excepcion");
			return false; 
		}else{//Se guarda la excepcion
			saveExcep(psExcepId,psResponsible);
			lsQuery = "SELECT COUNT(*) FROM op_grl_exception_detail WHERE " +
				"exception_id="+psExcepId;
			lsStatus  = moAbcUtils.queryToString(lsQuery);
			if(Integer.parseInt(lsStatus)>0){ // Se guardo la excepcion en la BDD
				lsQuery = "SELECT add_exception_inv("+psExcepId+")";//Aniade excepcion a inventario
                		moAbcUtils.queryToString(lsQuery);
				boolean resultOk = false;
				resultOk = savedExcepFiles(psExcepId);
				if(resultOk){
					cleanStepExcep();
                        		return true;
                    		}else
                        		return false;
			}else
				return false;
		}

        }catch(Exception e){
            return false;
        }
}
String getDiscDataset(){
	String lsDataset = moAbcUtils.getJSResultSet(getDiscCodeQry());
	return lsDataset;
}

String getDiscCodeQry(){
	//String lsQry = "select * from op_grl_cat_difference";
	String lsQry = "SELECT cd.difference_id, d.dif_desc "+
	               "FROM op_grl_cat_config_difference cd "+
	               "INNER JOIN op_grl_cat_difference d ON d.difference_id = cd.difference_id "+
                       "WHERE cd.case_id=2 AND active_flag = 'Y' ORDER BY cd.sort_seq";
	return lsQry;
}
%>
