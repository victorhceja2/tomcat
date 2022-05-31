
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.*" %>

<%!
    /**
        Checa la hora para saber si son mas de las 8:30pm.

    */
    boolean isValidTime()
    {
        Calendar calendar = Calendar.getInstance();
        int hour   = calendar.get(Calendar.HOUR_OF_DAY);  //20 horas ??
        int minute = calendar.get(Calendar.MINUTE);  //30 minutos ??

        String time = hour + ":" + minute;

        //TODO: quitas comentario
        //if(time.compareTo("20:30") >= 0)
        if(time.compareTo("09:30") >= 0)
            return true;
        else
            return false;
    }

    /**
        Devuelve la fecha de negocio
    */
    /*
    String getBusinessDate()
    {
        //TODO: poner bien la fecha phpqdate
        //return Inventory.getBusinessDate();

        return "2017-07-07";
    }*/

    /**
        Calcula el dia anterior en el formato YYYY-MM-DD
    */
    String calculatePreviousDate(String psCurrentDate)
    {
        String lsQry;

        lsQry = "SELECT to_char(to_date('"+psCurrentDate+"', 'YYYY-MM-DD') - interval '1 day', 'YYYY-MM-DD')";

        return moAbcUtils.queryToString(lsQry);

    }

    /**
        Devuelve el anio actual. Informacion del invcaldr.txt
    */

    String getInvYear(){
        return "20" + Inventory.getCurrentYear();
    }

    /**
        Devuelve el periodo actual. Informacion del invcaldr.txt
    */    
    String getInvPeriod(){
        String lsPeriod = "";
    	lsPeriod = Inventory.getCurrentPeriod();

    	if(Integer.parseInt(lsPeriod) < 10)
       		lsPeriod = Inventory.getCurrentPeriod().substring(1,2);
    	else
       		lsPeriod = Inventory.getCurrentPeriod();
        	return lsPeriod;
        //return "01";
    }

    /**
        Devuelve la semana actual. Informacion del invcaldr.txt
    */
    String getInvWeek(){
        return Inventory.getCurrentWeek();
        //return "3";
    }


    /**
        Llena la tabla op_inv_conversion_factor. Los productos que tengan
        factores de conversion duplicados se eleminan 
    */
    
    void loadConversionFactors()
    {
        String lsQry;

        //Se borran valores ---------------lsFinalInv------------nulloriginales
        lsQry = "DELETE FROM op_inv_conversion_factor";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{});

        //Se insertan nuevos factores de conversion
        lsQry = "INSERT INTO op_inv_conversion_factor SELECT DISTINCT b.inv_id, " +
                "i.rcp_conversion_factor, p.conversion_factor FROM " +
                "op_inv_inventory_begin b INNER JOIN op_grl_cat_providers_product p " +
                "ON(b.inv_id=p.inv_id) INNER JOIN op_grl_cat_inventory i ON " +
                "(p.inv_id = i.inv_id)";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{});

        //Se ponen en 0 los factores de conversion de proveedor repetidos
        lsQry = "UPDATE op_inv_conversion_factor SET prv_conversion_factor = 0 WHERE " +
                "inv_id IN (SELECT inv_id FROM op_inv_conversion_factor  GROUP BY inv_id " +
                "HAVING COUNT(prv_conversion_factor) > 1)";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{});
    }    

    
    /**
        Llena la tabla op_inv_inventory_begin con los valores de inventario-------------lsFinalInv------------null
        inicial. Los valores que se ingresan, son los finales del dia anterior.
    */
    void loadInventoryBegin(String psQdate, String psCurrentDate)
    {
        System.out.println("Afecto el update");
        String lsQry="";
        String lsRes="";
        int numItems = -1;

        //Borra valores anteriores
        lsQry = "DELETE FROM op_inv_inventory_begin";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{});

        //Carga finales del dia anterior
        lsQry = "INSERT INTO op_inv_inventory_begin(inv_id, inv_beg) " +
                "SELECT DISTINCT i.inv_id, i.inv_end " + //ROUND(isnull(i.inv_inv_end+i.prv_inv_end*p.conversion_factor+i.rec_inv_end/c.rcp_conversion_factor,0),2)
                "FROM op_invc_inventory_critics i "+
        "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) "+
        "INNER JOIN op_grl_cat_inventory c ON(i.inv_id = c.inv_id) "+
        "WHERE DATE_TRUNC('day', i.date_id) = ? ";

        moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});

        //No se consideran productos que se han quitado de criticos
        lsQry = "DELETE FROM op_inv_inventory_begin WHERE inv_id NOT IN("+
                "SELECT DISTINCT(inv_id) FROM op_grl_cat_inventory WHERE frecuency_id IN(1,5))";

        moAbcUtils.executeSQLCommand(lsQry);

        
        //Se agregan los nuevos productos marcados como criticos
System.out.println("Se agregan los nuevos productos marcados como CRITICOS");
        lsQry = "INSERT INTO op_inv_inventory_begin(inv_id, inv_beg) " +
                "SELECT inv_id, 0 FROM op_grl_cat_inventory WHERE frecuency_id IN(1) "+
                "EXCEPT "+
                "SELECT inv_id, 0 FROM op_inv_inventory_begin";

        moAbcUtils.executeSQLCommand(lsQry);
        System.out.println("Terminando del loadInventoryBegin(String "+psQdate+", String "+psCurrentDate+")");
    }

    /** Llena la tabla op_inv_inventory_begin con los valores del inventario
     *  inicial. Los valores que se ingresan se leen del archivo de inventario
     *  de FMS.
     */
    void loadInventoryBegin(String psYear, String psPeriod, String psWeek){
        System.out.println("---------------------- LOAD INV --------------------psYear:"+psYear+" psPeriod:"+psPeriod+" psWeek:"+psWeek);
        Inventory loInventory;
        LinkedHashMap loHashmap;
        ArrayList loValues;
        Double loQuantity;
        Iterator iterator;
        String lsQry, lsRes, lsInvId, lsQuantity;
        int numItems = 0;
        try{
            //Borra valores anteriores
            lsQry = "DELETE FROM op_inv_inventory_begin";
            moAbcUtils.executeSQLCommand(lsQry, new String[]{});

            lsQry = "INSERT INTO op_inv_inventory_begin(inv_id, inv_beg, week_no) VALUES(?,?,?)";

            //Objecto que manipula el archivo de inventario (invtran)
            loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod,2), psWeek);


            loHashmap   = loInventory.getInventoryBegin();
            iterator    = loHashmap.keySet().iterator();
            loValues    = new ArrayList(loHashmap.size());

            int liCounter = 0;                        
        
            while(iterator.hasNext())
            {
                lsInvId    = (String) iterator.next();
                loQuantity = (Double) loHashmap.get(lsInvId);
                lsQuantity = Str.getFormatted("%.2f", loQuantity.doubleValue());
        //System.out.println("lsQuantity----->"+lsQuantity);
        //lsQuantity="100"; // BORRAR !!!!!!!!!!!!

                if(loQuantity.doubleValue() >= 0)
                    loValues.add( new String[]{lsInvId, lsQuantity, psWeek} );
            }

            moAbcUtils.executeSQLCommand(lsQry, loValues);

            //Elimina los NO criticos
            lsQry = "DELETE FROM op_inv_inventory_begin WHERE inv_id NOT IN ("+
                    "SELECT DISTINCT(inv_id) FROM op_grl_cat_inventory WHERE frecuency_id = 1)";

            moAbcUtils.executeSQLCommand(lsQry, new String[]{});
        }//Fin try
        catch(Exception e)
        {
            System.out.println("Exception loadInventoryBegin() ... " + e.toString());
        }            

    }
    /*
        Se actualizan valores de costo y uso ideal.
        Los valores que se ingresan se leen del archivo invtran.
    */
    void loadUsageAndCost(String psYear, String psPeriod, String psWeek, String psQdate)
    {
        Inventory loInventory;
        LinkedHashMap loHashmap;
        ArrayList loValues;
        Iterator iterator;
        String lsQry, lsInvId, lsUsage, lsCost, lsCode;
        SimpleRecord loSimpleRecord;
        String lsMisc;

        loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod,2), psWeek);
        System.out.println("loadUsageAndCost-------------psYear:"+psYear+" psPeriod:"+psPeriod+" psWeek:"+psWeek+" psQdate:"+psQdate);
    
        //loHashmap   = loInventory.getSimpleRecords(psQdate);
        loHashmap   = loInventory.getSimpleRecords();
        System.out.println("loHashmap:loadUsageAndCost-------------psYear:"+psYear+" psPeriod:"+psPeriod+" psWeek:"+psWeek+" psQdate:"+psQdate);
        iterator    = loHashmap.keySet().iterator();    
        System.out.println("iterator:loadUsageAndCost-------------psYear:"+psYear+" psPeriod:"+psPeriod+" psWeek:"+psWeek+" psQdate:"+psQdate);
        loValues    = new ArrayList(loHashmap.size());

        lsQry     = "UPDATE op_invc_step_inventory_critics SET ideal_use=?, unit_cost=?, misc=? WHERE inv_id=? AND date_id=?";
System.out.println("lsQry["+lsQry+"]");
    
        while(iterator.hasNext())
        {
            lsInvId        = (String) iterator.next();
            loSimpleRecord = (SimpleRecord) loHashmap.get(lsInvId);

            if(loSimpleRecord.getUsage() >= 0 && loSimpleRecord.getCost() >= 0)
            {    
                lsUsage = Str.getFormatted("%.2f", loSimpleRecord.getUsage());
                lsCost  = Str.getFormatted("%.2f", loSimpleRecord.getCost());
                lsCode  = loSimpleRecord.getCode().trim();
                System.out.println("lsUsage["+lsUsage+"] lsCost["+lsCost+"] lsCode["+lsCode);
                if(lsCode.length() == 0)
                    lsMisc = "true";
                else
                    lsMisc = "false";

                //loValues.add( new String[]{lsUsage, lsCost, lsMisc, lsInvId, psQdate} ); // Dany
                loValues.add( new String[]{lsUsage, lsCost, lsMisc, lsInvId, psQdate} );
            }
        }
        moAbcUtils.executeSQLCommand(lsQry, loValues);
    }
        
    /**
        Metodo que calcula las recepciones y las transferencias de entrada/salida 
        del dia.
    */
    void loadInventoryMov(String psQdate)
    {
        String lsQry;
        lsQry = "DELETE FROM op_inv_inventory_mov";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{});

        lsQry = "INSERT INTO op_inv_inventory_mov " +
        "SELECT p.inv_id, rd.provider_product_code, "  +
        "SUM(rd.received_quantity*p.conversion_factor) AS receptions,  " +
         "0 AS itransfers, 0 AS otransfers FROM  op_grl_reception_detail rd " +
        "INNER JOIN op_grl_reception r " +
         "ON (r.reception_id = rd.reception_id) " +
         "INNER JOIN op_grl_cat_providers_product p ON " +
        "( p.provider_product_code = rd.provider_product_code AND p.provider_id = rd.provider_id) " +
         "WHERE date_trunc('day',date_id) = '"+psQdate+"' "+
        "GROUP BY p.inv_id, rd.provider_product_code " +

        "UNION " +

        "SELECT td.inv_id, td.provider_product_code, 0 AS reception, " +
        "SUM(td.inventory_quantity) AS itransfers, " +
        "0 AS otransfers FROM  op_grl_transfer_detail td " +
        "INNER JOIN op_grl_transfer t " +
        "ON (t.transfer_id = td.transfer_id) WHERE t.transfer_type=1 AND " +
        "date_trunc('day',t.date_id) = '"+psQdate+"' "+
        "GROUP BY td.inv_id, td.provider_product_code " +

        "UNION " +

        "SELECT td.inv_id, td.provider_product_code, 0 AS reception, 0 AS itransfers ," +
        //"SUM(td.provider_quantity * td.prv_conversion_factor + td.inventory_quantity) AS " +
        "SUM(td.inventory_quantity) AS " +
        "otransfers FROM  op_grl_transfer_detail td "+
        "INNER JOIN op_grl_transfer t " +
        "ON (t.transfer_id = td.transfer_id) WHERE t.transfer_type=0 AND  " +
        "date_trunc('day',t.date_id) = '"+psQdate+"' " +
        "GROUP BY td.inv_id, td.provider_product_code " ;
    
        moAbcUtils.executeSQLCommand(lsQry, new String[]{});
        //moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate, psQdate, psQdate});
    }

    /**
        Metodo inserta los valores iniciales de la tabla de inventario. 
        Las columnas principales son el inv_id, inv_beg
        */
    void initInventory(String psYear, String psPeriod, String psWeek, String psQdate)
    {
        //DEBUG
        System.out.println("initInventory() ... psQdate["+psQdate);

        String lsQry, lsRes, lsPreviousDate;
        int numItems = -1;
        boolean firstLoad = false;

        lsPreviousDate = calculatePreviousDate(psQdate); //YYYY-MM-DD

        lsQry    = "SELECT COUNT(*) FROM op_invc_inventory_critics WHERE " +
                   "DATE_TRUNC('day',date_id) = '%s' ";
        lsQry    = Str.getFormatted(lsQry, new Object[]{lsPreviousDate});

        try
        {
            lsRes    = moAbcUtils.queryToString(lsQry);
        
            if(lsRes != null)
                numItems = Integer.parseInt(lsRes);

            System.out.println("En initInventory psYear["+psYear+"] psPeriod["+psPeriod+"]  psWeek["+psWeek+"]");
            if(numItems == 0) //Cargar inicial del archivo de FMS
            {
                System.out.println("Se cargan los valores del inventario inicial del archivo invtran ");
                loadInventoryBegin(psYear, psPeriod, psWeek);

                firstLoad = true;
            }
            else //El inicial del dia actual es el final del dia anterior
            { 
                System.out.println("loadInventoryBegin(lsPreviousDate:"+lsPreviousDate+", psQdate:"+psQdate+")");
                loadInventoryBegin(lsPreviousDate, psQdate);
            }
        }
        catch(Exception e)
        {
            System.out.println("initInventory() exception .. " + e);
        }


        //Valores de inventario final capturados el dia actual
        lsQry    = "SELECT COUNT(*) FROM op_invc_inventory_critics WHERE " +
                   "DATE_TRUNC('day',date_id) = '%s' ";

        lsQry     = Str.getFormatted(lsQry, new Object[]{psQdate});
        lsRes    = moAbcUtils.queryToString(lsQry);
        numItems = -1;

        try
        {
            if(lsRes != null)
                numItems = Integer.parseInt(lsRes);

            /* Se borran los registros de la tabla de paso */
            lsQry = "DELETE FROM op_invc_step_inventory_critics";

            moAbcUtils.executeSQLCommand(lsQry, new String[]{});

            /* Se cargan productos actuales a tabla de paso */
            lsQry = "INSERT INTO op_invc_step_inventory_critics " + 
            "(inv_id, inv_beg, date_id, year_no, period_no, week_no) " +
            "SELECT DISTINCT " +
            "prod.inv_id, ibegin.inv_beg, " +
            "to_date('%s','YYYY-MM-DD'), %s, %s, %s FROM op_grl_cat_providers_product prod " +
            "INNER JOIN op_inv_inventory_begin ibegin " +
            "ON (prod.inv_id = ibegin.inv_id) WHERE prod.active_flag IN(1,2) " ;

            lsQry = Str.getFormatted(lsQry, new Object[]{psQdate, psYear, psPeriod, psWeek});

            moAbcUtils.executeSQLCommand(lsQry, new String[]{});

            if(numItems == 0){
                /* Se cargan mismos datos de la tabla de paso a inventario */
                lsQry = "INSERT INTO op_invc_inventory_critics " +
                    "SELECT * FROM op_invc_step_inventory_critics ";
        
                moAbcUtils.executeSQLCommand(lsQry, new String[]{});
            }else{
                //Borra productos que ya no son validos
                lsQry = "DELETE FROM op_invc_inventory_critics WHERE " +
                "DATE_TRUNC('day', date_id) = ? "+
                "AND inv_id NOT IN (SELECT DISTINCT(inv_id) FROM op_inv_inventory_begin)";

                moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});

                //Inserta productos nuevos
                lsQry = "INSERT INTO op_invc_inventory_critics " +
                "(inv_id, inv_beg, date_id, year_no, period_no, week_no) " +
                "SELECT inv_id, inv_beg, date_id, year_no, period_no, week_no " +
                "FROM op_invc_step_inventory_critics " +
                "EXCEPT " +
                "SELECT inv_id, inv_beg, date_id, year_no, period_no, week_no " +
                "FROM op_invc_inventory_critics WHERE DATE_TRUNC('day', date_id) = ? ";

                moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});

                /* Se actualizan valores capturados anteriormente */
                lsQry = "UPDATE op_invc_step_inventory_critics SET prv_inv_end=crit.prv_inv_end, " +
                "inv_inv_end=crit.inv_inv_end, rec_inv_end=crit.rec_inv_end, " +
                "decreases=crit.decreases " +
                "FROM op_invc_inventory_critics crit " +
                "WHERE op_invc_step_inventory_critics.date_id=crit.date_id AND " +
                "op_invc_step_inventory_critics.inv_id=crit.inv_id AND " +
                "crit.date_id = ? AND " +
                "op_invc_step_inventory_critics.date_id=? " ;

                moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate, psQdate});
            }
        }

        catch(Exception e)
        {
            System.out.println("Exception initInventory() ... " + e.toString());
        }
        System.out.println("FIN initInventory(String psYear, String psPeriod, String psWeek, String psQdate) ... ");
    }

    /**
        Metodo que actualiza las recepciones y las transferencias de entrada/salida 
        en la tabla de inventario.
    */
    void updateInventory(String psYear, String psPeriod, String psWeek, String psQdate)
    {
        //DEBUG
        System.out.println("updateInventory() .. ");
        System.out.println("date---->"+psQdate);
        
        String lsQry;

        // Se cargan los factores de conversion a la tabla op_inv_conversion_factor 
        System.out.println("loadConversionFactors");
        loadConversionFactors();

        System.out.println("Llena la tabla op_inv_inventory_mov  loadInventoryMov");
        loadInventoryMov(psQdate);

        //Llena las tablas op_inv_ideal_use y op_inv_unit_cost
        System.out.println("Llena las tablas op_inv_ideal_use y op_inv_unit_cost: loadUsageAndCost");
        loadUsageAndCost(psYear, psPeriod, psWeek, psQdate);

        System.out.println("FIN loadUsageAndCost updateInventory() .. ");
        //Se actualizan los valores de recepciones y transferencias.
        lsQry = "UPDATE op_invc_step_inventory_critics SET " +
        "receptions=isnull( get_receptions(inv_id), 0), " +
        "itransfers=isnull( get_itransfers(inv_id),0 ) , "+
        "otransfers=isnull( get_otransfers(inv_id), 0)  "+
        "WHERE date_id = ? ";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});

        //Se actualizan los factores de conversion
        lsQry = "UPDATE op_invc_step_inventory_critics SET prv_conversion_factor = " +
        "cf.prv_conversion_factor, rcp_conversion_factor=cf.rcp_conversion_factor " +
        "FROM op_inv_conversion_factor cf WHERE " +
        " cf.inv_id = op_invc_step_inventory_critics.inv_id AND "+
        "op_invc_step_inventory_critics.date_id=?";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});

    /*
    lsQry = "UPDATE op_invc_configuration"+
    " SET value = clock_timestamp()"+
    " WHERE configuration_id = 3";
    moAbcUtils.executeSQLCommand(lsQry, new String[]{});*/

        System.out.println("FIN updateInventory() .. ");
    }

    /**
        Metodo que devuelve la consulta para obtener el detalle de un
        inventario DIARIO. Debe ser comun a Entry/InventoryDetail, Entry/InventoryPreview 
        y Rpt/InventoryDetail. El parametro step determina si se leen los datos
        de la tabla de paso.
    */

    String getInventoryDetailQuery(boolean step, String psQdate){
    String lsInvTable = "op_invc"+ ((step==true)?"_step_":"_") + "inventory_critics";
    String lsDateConfig = "";
    String lsFlag = "";
    String lsQry,lsRes,lslimCritics;
    lsFlag = getConfig("2");
    lsDateConfig= getConfig("3");
    lslimCritics = getConfig("4");

    lsDateConfig = lsDateConfig.substring(0,10);
    //System.out.println("Fecha Tabla----->"+lsDateConfig);
    //System.out.println("Bandera ----->"+lsFlag);

/* Actualizamos los finales del inventario del semanal */
    System.out.println("Actualizamos los finales del inventario del semanal");
    lsQry = "SELECT EXTRACT(DOW FROM '"+psQdate+"'::TIMESTAMP)";
    lsRes = moAbcUtils.queryToString(lsQry);
    if(lsRes.equals("1")){
        lsQry = "UPDATE "+lsInvTable+" SET prv_inv_end=crit.prv_inv_end, " +
        "inv_inv_end=crit.inv_inv_end, rec_inv_end=crit.rec_inv_end, " +
        "inv_end=crit.inv_end " +
        "FROM op_inv_inventory_detail crit " +
        "WHERE "+lsInvTable+".date_id=crit.date_id AND " +
        ""+lsInvTable+".inv_id=crit.inv_id AND " +
        "crit.date_id = ? AND " +
        ""+lsInvTable+".date_id=? " ;

        moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate, psQdate});
    }

// Query principal

    lsQry = "SELECT DISTINCT " +
    "i.inv_id||'  '||c.inv_desc, "+
    "isnull(i.inv_beg,0.00), "+
    "isnull(i.receptions,0.00), "+
    "isnull(i.itransfers,0.00), "+
    "isnull(i.otransfers,0.00), " +
    "isnull(i.prv_inv_end,0) AS prv_inv_end, "+
    "isnull(i.prv_inv_end,0) AS prv_inv_end, "+
    "isnull(i.inv_inv_end,0) AS inv_inv_end, "+
    "isnull(i.inv_inv_end,0) AS inv_inv_end, "+
    "isnull(i.rec_inv_end,0) AS rec_inv_end, "+
    "isnull(i.rec_inv_end,0) AS rec_inv_end, "+
    "'t' AS inv_total, " +
        //"0 AS real_use, "+
    "ISNULL("+((step==true)? "0":"real_use")+",0) AS real_use, "+
    "isnull(i.decreases,0) AS decrease, "+
    "i.ideal_use, "+
    "0 AS difference, "+
    "0 AS difference_money, "+
    "0 AS faltant, "+
    "i.inv_id, " +
        "lower(substr(ium.unit_name, 0, 5)) AS inventory_unit_measure, " +
        "i.prv_conversion_factor AS prov_conversion_factor, " + 
        //"lower(substr(pum.unit_name,0,5)) AS prov_unit_measure, " +
    "CASE WHEN i.prv_conversion_factor = 0 THEN '' ELSE lower(substr(pum.unit_name,0,5)) END AS prov_unit_measure, "+
        "i.rcp_conversion_factor AS recipe_conversion_factor, " +
        "lower(substr(rum.unit_name, 0, 5)) AS rec_unit_measure, " +
        "i.unit_cost AS unit_cost, "+
    "isnull(e.max_variance,0) AS max_variance, " +
        "isnull(e.min_efficiency,0) AS min_efficiency, " +
        "isnull(e.max_efficiency,0) As max_efficiency, " +
        "i.misc AS miscelaneo, "+
    "EXTRACT(dow FROM i.date_id::TIMESTAMP) AS week_day " + //EXTRACT(dow FROM i.date_id::TIMESTAMP) AS week_day
        "FROM "+lsInvTable+" i "+
    "INNER JOIN op_grl_cat_inventory c ON (i.inv_id = c.inv_id) " +
        "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) " +
        "INNER JOIN op_grl_cat_unit_measure pum ON(p.provider_unit_measure = pum.unit_id) " +
        "INNER JOIN op_grl_cat_unit_measure ium ON(c.inv_unit_measure = ium.unit_id) " +
        "INNER JOIN op_grl_cat_unit_measure rum ON(c.recipe_unit_measure = rum.unit_id) " +
        "LEFT JOIN op_inv_exceptions e ON (i.inv_id = e.inv_id) " +
        "WHERE " +
        "p.active_flag IN(1,2) AND DATE_TRUNC('day', i.date_id) = '"+((lsFlag.equals("0"))? psQdate:lsDateConfig )+"'"+
        //"p.active_flag IN(1,2) AND DATE_TRUNC('day', i.date_id) = '2017-07-07'"+
    " ORDER BY 1";
	System.out.println("Detalle 1 --->"+lsQry);
        return lsQry;
    }

   String getAcumDetailQuery(String psQdate){
       String lsQuery = "";
    lsQuery = "SELECT * FROM op_invc_get_acumulated_data('"+psQdate+"')";

    return lsQuery;
   }

/* Query del reporte de criticos diarios */
    String getInventoryDetailQueryR(boolean step, String psQdate){
        String lsDateConfig = "";
        String lsFlag = "";
        String lsQry,lsRes;
       
        lsQry = "SELECT DISTINCT " +
        "c.inv_id||' '||c.inv_desc, "+
        "isnull(i.inv_beg,0.00), "+
        "isnull(i.receptions,0.00), "+
        "isnull(i.itransfers,0.00), "+
        "isnull(i.otransfers,0.00), " +
        "isnull(i.prv_inv_end,0.00) AS prv_inv_end, "+
        "isnull(i.inv_inv_end,0.00) AS inv_inv_end, "+
        "isnull(i.rec_inv_end,0.00) AS rec_inv_end, "+
        "ROUND((i.prv_inv_end*i.prv_conversion_factor+i.inv_inv_end+i.rec_inv_end/i.rcp_conversion_factor),2) AS inv_total, " +
        "ISNULL(real_use,0) AS real_use, "+
        "ISNULL(iu.ideal_use,0.00) AS ideal_use, "+
        "0 AS difference, "+
        "isnull(i.decreases,0) AS decrease, "+
        "0 AS difference_money, "+
        "0 AS faltant, "+
        "i.inv_id, " +
        "lower(substr(ium.unit_name, 0, 5)) AS inventory_unit_measure, " +
        "i.prv_conversion_factor AS prov_conversion_factor, " + 
        //"lower(substr(pum.unit_name,0,5)) AS prov_unit_measure, " +
        "CASE WHEN i.prv_conversion_factor = 0 THEN '' ELSE lower(substr(pum.unit_name,0,5)) END AS prov_unit_measure, "+
        "i.rcp_conversion_factor AS recipe_conversion_factor, " +
        "lower(substr(rum.unit_name, 0, 5)) AS rec_unit_measure, " +
        "i.unit_cost AS unit_cost, "+
        "isnull(e.max_variance,0) AS max_variance, " +
        "isnull(e.min_efficiency,0) AS min_efficiency, " +
        "isnull(e.max_efficiency,0) As max_efficiency, " +
        "i.misc AS miscelaneo, "+
        "EXTRACT(dow FROM i.date_id::TIMESTAMP) AS week_day " + //EXTRACT(dow FROM i.date_id::TIMESTAMP) AS week_day
        "FROM op_inv_ideal_use iu "+
        "RIGHT JOIN op_invc_inventory_critics i ON (i.inv_id = iu.inv_id AND iu.turn_date = i.date_id) "+
        "INNER JOIN op_grl_cat_inventory c ON (i.inv_id = c.inv_id) " +
        "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) " +
        "INNER JOIN op_grl_cat_unit_measure pum ON(p.provider_unit_measure = pum.unit_id) " +
        "INNER JOIN op_grl_cat_unit_measure ium ON(c.inv_unit_measure = ium.unit_id) " +
        "INNER JOIN op_grl_cat_unit_measure rum ON(c.recipe_unit_measure = rum.unit_id) " +
        "LEFT JOIN op_inv_exceptions e ON (i.inv_id = e.inv_id) " +
        "WHERE " +
        "p.active_flag IN(1,2) AND DATE_TRUNC('day', i.date_id) = '"+ psQdate +"'"+
        //"p.active_flag IN(1,2) AND DATE_TRUNC('day', i.date_id) = '2017-07-07'"+
        " ORDER BY 1";
        System.out.println("Detalle 2 --->"+lsQry);
            return lsQry;
    }

    String getCaptureFormatQuery(String psYear, String psPeriod, String psWeek, String psFamilyId)
    {
        String lsQry = "SELECT DISTINCT c.inv_desc, " +
        "'' AS cong_prov, '' AS conv_inv, '' AS cong_rec, " +
        "'' AS most_prov, '' As most_inv, '' AS most_rec, " +
        "'' AS bode_prov, '' AS bode_inv, '' As bode_rec, " +
        "'' AS cuar_prov, '' AS cuar_inv, '' As cuar_rec " +
        "FROM op_invc_step_inventory_critics i INNER JOIN op_grl_cat_inventory c " +
        "ON (i.inv_id = c.inv_id) " +
        "INNER JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id) " +
        "WHERE " +
        "p.active_flag IN(1,2) AND " + 
        "c.family_id = " + psFamilyId + " AND " +
        "i.year_no = " + psYear + " AND i.period_no = " + psPeriod + 
        " AND i.week_no = " + psWeek ;

        return lsQry;
    }

    /**
       Metodo que devuelve la consulta para obtener una lista de los productos del inventario critico para agregar mas criticos
    */

    String getChooseProductsQuery(String psFamilyId){
        String lsQuery;

        //TODO: revisar y corregir query
        lsQuery = "SELECT DISTINCT prod.inv_id, i.inv_id, " +
                  "i.inv_desc, i.frecuency_id, COALESCE(c.frecuency_id,0) "+ 
                  "FROM op_grl_cat_inventory i INNER JOIN op_grl_cat_providers_product prod "+
                  "ON(i.inv_id = prod.inv_id) " +
                  "INNER JOIN op_grl_cat_provider prov " +
                  "ON(prod.provider_id = prov.provider_id) " +
                  "LEFT JOIN op_invc_cat_inventory_critics c ON (i.inv_id = c.inv_id) " +
                  "WHERE prod.active_flag IN (1,2) AND i.family_id <> '12800000' ";

        if(!psFamilyId.equals("-1"))
             lsQuery += "AND i.family_id = '" +psFamilyId+"'";
        
        lsQuery += " ORDER BY inv_desc ASC";

        return lsQuery;
    }

    /** Agrega o quita los productos seleccionados al inventario criticos.
    */
    void updateCritics(HttpServletRequest poRequest){
        System.out.println("--------------------updateCritics-----------------");
        String lsQry, lsNewItems, lsOldItems;
        String lsYear;
        String lsPeriod;
        String lsWeek;
        String lsQdate;
        int liNumItems;

        try{
            lsYear   = poRequest.getParameter("hidYear");
            lsPeriod = poRequest.getParameter("hidPeriod");
            lsWeek   = poRequest.getParameter("hidWeek");
            lsQdate  = poRequest.getParameter("hidQdate");
            lsNewItems = poRequest.getParameter("hidNewItems");
            lsOldItems = poRequest.getParameter("hidOldItems");

            String invIds[] = lsNewItems.split(",");
            if(invIds.length > 0)
            for(int i=0; i<invIds.length; i++)
            {
                if(!invIds[i].equals("-1"))
                {
                    lsQry = "INSERT INTO op_invc_cat_inventory_critics SELECT inv_id,inv_desc,family_id,frecuency_id, NOW() " +
                            "FROM op_grl_cat_inventory WHERE inv_id = '"+invIds[i]+"'";
                    moAbcUtils.executeSQLCommand(lsQry);

                    lsQry = "INSERT INTO op_invc_inventory_critics (inv_id, inv_beg, date_id, year_no, period_no, week_no) " +
                        "VALUES(%s, 0, '%s', %s, %s, %s)";
                    lsQry = Str.getFormatted(lsQry, new Object[]{invIds[i], lsQdate, lsYear, lsPeriod, lsWeek});                        
                    moAbcUtils.executeSQLCommand(lsQry);
                    System.out.println("Insert updateCritics-->"+lsQry);

                    lsQry = "UPDATE op_grl_cat_inventory SET frecuency_id=1 WHERE inv_id IN ('"+invIds[i]+"')";
                    System.out.println("updateCritics lsQry["+lsQry+"]");
                    moAbcUtils.executeSQLCommand(lsQry, new String[]{});
                }                        
            }                    
            String invIdsOld[] = lsOldItems.split(",");
            for(int i=0; i<invIdsOld.length; i++)
            {
                if(!invIdsOld[i].equals("-1"))
                {
                    //Se inventaria semanalmente
                    lsQry = "UPDATE op_grl_cat_inventory SET frecuency_id=2 WHERE inv_id IN ('"+invIdsOld[i]+"')";
                    moAbcUtils.executeSQLCommand(lsQry);
                    System.out.println("updateCritics lsQry["+lsQry+"]");

                    //Se borran las entradas de la tabla de criticos opcionales
                    System.out.println("Quitando los elementos anteriores["+invIdsOld[i]+"]"); 
                    lsQry = "DELETE FROM op_invc_cat_inventory_critics WHERE inv_id = '"+invIdsOld[i]+"'";
                    moAbcUtils.executeSQLCommand(lsQry);

                    lsQry = "DELETE FROM op_invc_inventory_critics WHERE inv_id = '"+invIdsOld[i]+"' AND date_id='"+lsQdate+"'";
                    moAbcUtils.executeSQLCommand(lsQry);
                }
            }
        }
        catch(Exception e)
        {
            System.out.println("updateInventoryEnd() ... "  + e);
        }
    }

    /** Actualiza el valor del inventario final y la merma en la tabla de paso
       op_invc_step_inventory_critics */
    void updateStepInventory(HttpServletRequest poRequest){
        System.out.println("--------------updateStepInventory----------------");
        String lsQry, lsParam, lsRowId;
        String lsPrvQty,lsPrvQtyRec = "";
    	String lsInvQty,lsInvQtyRec = "";
    	String lsRecQty,lsRecQtyRec = "";
    	String lsDecQty = "";
    	String lsInvId = "";
    	String lsBeginInvQty = "";
    	String lsReceptions = "";
    	String lsInputTransf = "";
    	String lsOutputTransf = "";
	String lsFinalInvTotal = "";
    	float lsFinalInv = 0;

    String lsQdate = "";
    float lfRealUse = 0;
        int liNumItems = 0;

    lsQdate = getBusinessDate();

        lsQry = "UPDATE op_invc_step_inventory_critics "+
    "SET prv_inv_end=?, "+ 
    "    inv_inv_end=?, "+
    "    rec_inv_end=?, "+
    "    decreases=?, "+
    "    inv_end=?, "+
    "    real_use=?"+
    "WHERE inv_id = ?";

        try{

        liNumItems = Integer.parseInt(poRequest.getParameter("hidNumItems"));

        for(int liRowId=0; liRowId<liNumItems; liRowId++)
        {
            
            lsInvId     = poRequest.getParameter("inventoryId|"+liRowId);
            if(lsInvId.equals("NA")) continue;
            
              lsPrvQty   = poRequest.getParameter("finalPrvQty|"+liRowId);
              lsInvQty   = poRequest.getParameter("finalInvQty|"+liRowId);
              lsRecQty   = poRequest.getParameter("finalRecQty|"+liRowId);

              lsPrvQtyRec= poRequest.getParameter("finalPrvQtyRec|"+liRowId);
              lsInvQtyRec= poRequest.getParameter("finalInvQtyRec|"+liRowId);
              lsRecQtyRec= poRequest.getParameter("finalRecQtyRec|"+liRowId);

              lsDecQty   = poRequest.getParameter("decreaseQty|"+liRowId);
	      lsFinalInvTotal = poRequest.getParameter("finalInvTotal|"+liRowId);
              //lsFinalInv = poRequest.getParameter("finalInvTotal|"+liRowId);
          //System.out.println("---------------lsFinalInv------------"+lsFinalInv);
	  
          
          lsBeginInvQty  = poRequest.getParameter("beginInvQty|"+liRowId);
          lsReceptions   = poRequest.getParameter("receptionsQty|"+liRowId);
          lsInputTransf  = poRequest.getParameter("itransfersQty|"+liRowId);
          lsOutputTransf = poRequest.getParameter("otransfersQty|"+liRowId);

            if(lsPrvQty.compareTo("") == 0)
                lsPrvQty = "0.0";
            else
                lsPrvQty = lsPrvQty.substring(0, lsPrvQty.indexOf(" "));

            lsInvQty = lsInvQty.substring(0, lsInvQty.indexOf(" "));
            lsRecQty = lsRecQty.substring(0, lsRecQty.indexOf(" "));
            lsDecQty = lsDecQty.substring(0, lsDecQty.indexOf(" "));
        lfRealUse = Float.parseFloat(lsBeginInvQty)+Float.parseFloat(lsReceptions)+Float.parseFloat(lsInputTransf)-Float.parseFloat(lsOutputTransf);
	lsFinalInv = Float.parseFloat(lsPrvQty)+Float.parseFloat(lsInvQty)+Float.parseFloat(lsRecQty);
	System.out.println("lsFinalInv-->"+lsFinalInv);

           // moAbcUtils.executeSQLCommand(lsQry, new String[]{lsPrvQty, lsInvQty, lsRecQty, lsDecQty, lsBeginInvQty, Float.toString(lfRealUse), lsInvId});
           moAbcUtils.executeSQLCommand(lsQry, new String[]{lsPrvQty, lsInvQty, lsRecQty, lsDecQty, Float.toString(lsFinalInv), Float.toString(lfRealUse), lsInvId});
        }
    
    lsQry = "UPDATE op_invc_step_inventory_critics m1 "+
    "SET prv_unit_measure = gm1.prv_unit_measure, "+
    "    inv_unit_measure = gm1.inv_unit_measure "+
    "FROM("+
    "    SELECT DISTINCT"+
    "    i.inv_id,"+
    "    lower(substr(ium.unit_name, 0, 5)) AS inv_unit_measure,"+
    "    CASE WHEN i.prv_conversion_factor = 0 THEN '' ELSE lower(substr(pum.unit_name,0,5)) END AS prv_unit_measure"+
    "    FROM op_invc_step_inventory_critics i"+
    "    JOIN op_grl_cat_inventory c ON (i.inv_id = c.inv_id)"+
    "    JOIN op_grl_cat_providers_product p ON(i.inv_id = p.inv_id)"+
    "    JOIN op_grl_cat_unit_measure pum ON(p.provider_unit_measure = pum.unit_id)"+
    "    JOIN op_grl_cat_unit_measure ium ON(c.inv_unit_measure = ium.unit_id)"+
    "    WHERE p.active_flag IN (1,2)"+
    "    AND DATE_TRUNC('day', i.date_id) = ? "+
    ") gm1 "+
    "WHERE m1.inv_id = gm1.inv_id";

    moAbcUtils.executeSQLCommand(lsQry, new String[]{lsQdate});

    lsQry = "UPDATE op_invc_step_inventory_critics m1 "+
    "        SET inv_end = gm1.final_inv "+
    "FROM( "+
    "   SELECT inv_id, (prv_inv_end * prv_conversion_factor) + inv_inv_end + (rec_inv_end / rcp_conversion_factor) AS final_inv "+
    "   FROM op_invc_step_inventory_critics "+
    "   WHERE date_id = ? "+
    "   AND (prv_inv_end * prv_conversion_factor) + inv_inv_end + (rec_inv_end / rcp_conversion_factor) IS NOT NULL "+
    ")gm1 "+
    "WHERE m1.inv_id = gm1.inv_id";

   System.out.println("Query nuevo -->"+lsQry);

    moAbcUtils.executeSQLCommand(lsQry, new String[]{lsQdate});

    }
        catch(Exception e)
        {
            System.out.println("updateInventoryEnd() ... "  + e);
        }
        
    }

    void saveInventoryDB(String psQdate, String psSaveType){

    	System.out.println("---------------------saveInventoryDB -------------------");
        String lsQry;
	String lsFlag = "";
	//lsFlag=validateInvClose(psQdate);
	
        lsQry = "DELETE FROM op_invc_inventory_critics WHERE DATE_TRUNC('day', date_id) = ? "; // DeleteX
       	moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});

        lsQry = "INSERT INTO op_invc_inventory_critics SELECT * FROM op_invc_step_inventory_critics " +
                "WHERE DATE_TRUNC('day', date_id) = ? ";

       	moAbcUtils.executeSQLCommand(lsQry, new String[]{psQdate});
    
    if("T".equals(psSaveType)){
        lsQry = "UPDATE op_invc_configuration"+
        " SET value = '"+psQdate+"'"+
        " WHERE configuration_id = 3";
	System.out.println("upd conf-->"+lsQry);
            moAbcUtils.executeSQLCommand(lsQry, new String[]{});
    }

    lsQry = "INSERT INTO op_invc_close_inv_log (date_id, business_date)"+
    " VALUES(now(), '"+psQdate+"')";

        moAbcUtils.executeSQLCommand(lsQry, new String[]{});

    executeAsciiPl(psQdate);
    }

    /*
        Escribe el valor del inventario final en el archivo de FMS  (invtran)
    */
    boolean saveInventoryFMS(String psYear, String psPeriod, String psWeek)
    {

        Inventory loInventory;
        Record records[];
        String lsQry, laResult[][], keys[];
        int liWeekId;
        float finalInv[];
        
        loInventory = new Inventory(psYear.substring(2), Str.padZero(psPeriod,2), psWeek);
        liWeekId    = loInventory.getWeekId();

        lsQry   = "SELECT DISTINCT i.inv_id, " +
                    "ROUND(isnull(i.inv_inv_end+i.prv_inv_end*p.conversion_factor+i.rec_inv_end/c.rcp_conversion_factor,0),2) " +
                    "FROM op_invc_inventory_critics i INNER JOIN op_grl_cat_providers_product p " +
                    "ON(i.inv_id = p.inv_id) INNER JOIN op_grl_cat_inventory c " +
                    "ON(i.inv_id = c.inv_id) " +
                    "WHERE i.year_no="+psYear+" AND i.period_no="+psPeriod+" AND i.week_no="+psWeek;

        laResult  = moAbcUtils.queryToMatrix(lsQry);

        keys      = new String[laResult.length];
        finalInv  = new float[laResult.length];

        try
        {

            for(int rowId=0; rowId<laResult.length; rowId++)
            {
                keys[rowId]     = laResult[rowId][0].trim();
                finalInv[rowId] = Float.parseFloat(laResult[rowId][1]);
            }

            records = loInventory.findRecords(keys);

            for(int rowId=0; rowId<records.length; rowId++)
            {
                //Para actualizar los valores del inventario final en el archivo de FMS
                records[rowId].getWeek(liWeekId).setInvEnd(finalInv[rowId]);
            }

            //Se hace un backup del archivo antes de que se actualizen los valores
            loInventory.backup();

            if( loInventory.updateRecords(records)>0 ) 
                return true;
            else
                return false;
        }
        catch(Exception e)
        {
            System.out.println("Exception saveInventoryFMS() ... " + e.toString());
            return false;
        }
    }

    /**
        Obtiene las ventas netas para un dia.
    */
    String getSales(String psQdate){
        String lsQuery;
        lsQuery  = "SELECT quantity FROM op_grl_finantial_mov WHERE  " +
                   "finantial_code = '1' AND date_trunc('day', date_id) = '%s' ";
        lsQuery  = Str.getFormatted(lsQuery, new Object[]{psQdate});

        return moAbcUtils.queryToString(lsQuery);
    }



    boolean saveChanges(String psQdate, String psSaveType)
    {
        try
        {
            saveInventoryDB(psQdate, psSaveType);

            String lsQry = "SELECT COUNT(*) FROM op_invc_inventory_critics WHERE " +
            "DATE_TRUNC('day',date_id) = '%s' ";

            lsQry = Str.getFormatted(lsQry, new Object[]{psQdate});

            String lsStatus  = moAbcUtils.queryToString(lsQry, "", "");
            
            if(Integer.parseInt(lsStatus)>0) //Se guardo el registro en la BD
            {
                //TODO: poner validacion
                //SOLO EL LUNES se modifica el archivo de inventario para escribir el
                //inventario final
                /*
                if(saveInventoryFMS(psYear, psPeriod, psWeek))
                   return true;
                else
                   return false;
                   */
                   
                return true;
            }                
            else
                return false;
        }
        catch(Exception e)
        {
            return false;
        }
    }

    /**
        Funcion que se utiliza para obtener el reporte de criticos para una
        fecha dada.
    */
    boolean inventoryExists(String psQdate){
        String lsQuery, lsResult;

        lsQuery  = "SELECT COUNT(DISTINCT(inv_id)) FROM op_invc_inventory_critics "+
                   "WHERE DATE_TRUNC('day', date_id) = '"+psQdate+"'";
        lsQuery  = Str.getFormatted(lsQuery, new Object[]{psQdate});

        lsResult = moAbcUtils.queryToString(lsQuery);

        if(lsResult != null && Integer.parseInt(lsResult) > 0)
            return true;
        else
            return false;
    }

    String getDataset(boolean step, String psQdate){
        String lsData  = "";
        String tmpData = moAbcUtils.getJSResultSet( getInventoryDetailQuery(step, psQdate));

        if(!tmpData.trim().equals("new Array()")){
            lsData += "tmpArray  = " + tmpData + ";\n";
            lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
        }

        return lsData;
    }
    
    String getDatasetAcum(boolean step, String psQdate){
        String lsData  = "";
        String tmpData = moAbcUtils.getJSResultSet( getAcumDetailQuery(psQdate));

        if(!tmpData.trim().equals("new Array()")){
            lsData += "tmpArray2  = " + tmpData + ";\n";
            lsData += "gaDataSet2 = gaDataSet2.concat(tmpArray2); \n";
        }

        return lsData;
    }

    String getDatasetR(boolean step, String psQdate){
        String lsData  = "";
        String tmpData = moAbcUtils.getJSResultSet( getInventoryDetailQueryR(step, psQdate));

        if(!tmpData.trim().equals("new Array()")){
            lsData += "tmpArray  = " + tmpData + ";\n";
            lsData += "gaDataset = gaDataset.concat(tmpArray); \n";
        }

        return lsData;
    }

    String getFamiliesQuery()
    {
        String lsQry;

        lsQry = "SELECT family_id, upper(family_desc) AS family_desc FROM op_grl_cat_family " +
                "WHERE family_order IS NOT NULL ORDER BY family_order ASC ";

        return lsQry;
    }

    String[][] getFamilies()
    {
        return moAbcUtils.queryToMatrix( getFamiliesQuery() );
    }

    String getMonth(String psYear, String psPeriod, String psWeek, String psWeekDay){
        String lsQuery = "";
    String lsMonth = "";
    lsQuery = "SELECT DATE_PART('month', date_id)"+
    " FROM ss_cat_time"+
    " WHERE year_no = "+psYear+
    " AND period_no = "+psPeriod+
    " AND week_no = "+psWeek+
    " AND EXTRACT('day' FROM date_id) = "+psWeekDay;
    System.out.println("getMonth"+lsQuery);
    lsMonth = moAbcUtils.queryToString(lsQuery);
    return lsMonth;
    }

    String validCritics(String psQdate){
        String lsQuery = "";
        String lsCritics = "";

        lsQuery = "SELECT COUNT(*)"+
        " FROM op_invc_inventory_critics"+
        " WHERE date_id = '"+psQdate+"'"+
        " AND decreases > 0";

        lsCritics = moAbcUtils.queryToString(lsQuery);
        return lsCritics;
    }
             
    String getBusinessDate(){
        String s = "";
        String lsOutput = "";
        String lsFinalDate = "";
        
        try {
            Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Scripts/phpqdate.s");
            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
            while ((s = stdInput.readLine()) != null) {
                lsOutput = lsOutput + s;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        lsFinalDate = "20"+lsOutput.substring(0,2)+"-"+lsOutput.substring(2,4)+"-"+lsOutput.substring(4,6);
        System.out.println("Fecha de negocio----------------------"+lsFinalDate);
        return lsFinalDate;
    }

    boolean getWeekDay(){
        String lsQuery = "";
        String lsDay = "";
        boolean lbFlag = false;
        String lsBusinessDate = getBusinessDate();
    
        /*lsQuery = "SELECT EXTRACT(dow FROM DATE_TRUNC('day',date_id)::timestamp)"+
        " FROM op_invc_step_inventory_critics LIMIT 1";*/
        //lsQuery = "SELECT EXTRACT(dow FROM DATE_TRUNC('day',now())::timestamp)";
        //lsDay = moAbcUtils.queryToString(lsQuery);
        lsQuery = "SELECT EXTRACT(dow FROM '"+lsBusinessDate+"'::timestamp)";
        lsDay = moAbcUtils.queryToString(lsQuery);
  
        if(Integer.parseInt(lsDay) == 1)
           lbFlag = true;

        return lbFlag;
    }

    void RestartInventory(){
        System.out.println("Entro a RestartInventory");
        String lsQuery = "";

        lsQuery = "UPDATE op_invc_inventory_critics AS m1"+
        " SET prv_inv_end = gm1.prv_inv_end,"+
        "     inv_inv_end = gm1.inv_inv_end,"+
        "     rec_inv_end = gm1.rec_inv_end"+
        " FROM ("+
        "         SELECT inv_id, prv_inv_end, inv_inv_end, rec_inv_end "+
        "        FROM op_inv_inventory_detail "+
        " ) gm1"+
        " WHERE m1.inv_id = gm1.inv_id";

        moAbcUtils.executeSQLCommand(lsQuery, new String[]{});
    }

    String getHour(){
        String lsQuery = "";
        String lsHour = "";

        lsQuery = "SELECT EXTRACT(hr FROM DATE_TRUNC('hour',clock_timestamp())::TIMESTAMP)";
        lsHour = moAbcUtils.queryToString(lsQuery);

        return lsHour;
    }
    
    String getConfig(String psConfig){
        String lsQuery = "";
        String lsConfigValue = "";

        lsQuery = "SELECT value FROM op_invc_configuration"+
        " WHERE configuration_id = "+psConfig;
        lsConfigValue = moAbcUtils.queryToString(lsQuery);
    
        return lsConfigValue;
    }

    void executeAsciiPl(String psQdate){
        String lsDate= "";
        lsDate = psQdate.substring(2,4)+psQdate.substring(5,7)+psQdate.substring(8,10);
    try {
           Process p = Runtime.getRuntime().exec("/usr/bin/ph/asciiCrit.pl "+lsDate);
        }catch (IOException e) {
               System.out.println("Excep perl criticos ..."+ e.toString());
        }
    }

    String validateInvClose(String psQdate){
        String lsQuery = "";
        String lsResult = "";

        lsQuery = "SELECT COUNT(*) FROM op_invc_configuration "+
                  "WHERE configuration_id = 3 "+
                  "AND '"+psQdate+"' <= CAST(value AS DATE)";

        lsResult = moAbcUtils.queryToString(lsQuery);
        return lsResult;
    }

    void loadIdealUse(){
        String lsBDate=getBusinessDate();
    
        String laCommand[] = new String[]{"/usr/bin/perl /usr/bin/ph/databases/posdb/bin/loadIdealUse.pl "+lsBDate};
        try{
            System.out.println("loadIdealUse.pl "+lsBDate);
            Process process = Runtime.getRuntime().exec(laCommand);
            //process.waitFor();
        }catch(Exception e){
            System.out.println("Exception carga de uso ideal fecha" + lsBDate + " de exec e ... " + e.toString());
        }
    }

    String [][] attentionItems(String psYear, String psPeriod, String psWeek, String psQdate){
        
        String lsResult = "";
	loadIdealUse();
    
        String lsQry = "SELECT '<tr><td align=\"center\" class=\"text\" >'||inv_desc||'</td></tr>'"+
        " FROM op_grl_cat_inventory as i "
    	+"INNER JOIN op_inv_efficiency_inventory AS b ON (i.inv_id = b.inv_id)"
    	+" INNER  JOIN (SELECT inv_id,(CASE WHEN ideal_use = 0 THEN 1 WHEN ideal_use>real_use THEN ((ideal_use-real_use)*100)/ideal_use ELSE ((real_use-ideal_use)*100)/ideal_use END) AS diff_quantity, "
    	+"    (CASE WHEN ideal_use - real_use > 0 THEN (ideal_use - real_use) * unit_cost ELSE (real_use - ideal_use) * unit_cost END) AS diff_money "
    	+"    FROM op_invc_inventory_critics "
    	+"    WHERE year_no = "+ psYear+" AND period_no = "+ psPeriod +" AND week_no = "+ psWeek
    	+"     AND date_id = '"+ psQdate +"')"
    	+" AS c ON (c.inv_id = b.inv_id) "
    	+" WHERE diff_quantity > inv_quantity OR diff_money > prod_money ORDER BY diff_money DESC";
	
	System.out.println("Query att----->"+lsQry);
	
    	lsResult = moAbcUtils.queryToString(lsQry);
    	return moAbcUtils.queryToMatrix(lsQry);
    }

    String getRestItems(){
       String lsQry, lsResult;
       lsQry = "SELECT (SELECT value FROM op_invc_configuration WHERE configuration_id = 4)::int - (SELECT COUNT(*) FROM op_invc_cat_inventory_critics)";
       lsResult = moAbcUtils.queryToString(lsQry);
       return lsResult;
    }

    String getCurrentDate()
    {
        String lsQry;

        lsQry = "SELECT TO_CHAR(NOW(), 'YYYYMMDD')";
        return moAbcUtils.queryToString(lsQry);
    }

%>
