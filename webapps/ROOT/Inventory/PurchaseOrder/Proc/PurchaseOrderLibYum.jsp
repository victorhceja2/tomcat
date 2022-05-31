<%@ include file="/Include/CommonLibYum.jsp" %>   
<%@page import="java.util.*, java.io.*, java.text.*" %>
<%@page import="generals.*" %>
<%@page import="jinvtran.inventory.*" %>

<%!
    void loadCurrentInvtranItems(boolean allowNegatives)
    {
        Inventory inventory;
        LinkedHashMap loHashmap;
        ArrayList loValues;
        Iterator loIterator;
        String lsQuery;
        String lsYear, lsPeriod, lsWeek, lsToleranceDate;

        try
        {
            //Clean old values
            lsQuery = "DELETE FROM op_grl_invtran";
            moAbcUtils.executeSQLCommand(lsQuery, new String[]{});

            lsYear   = getCurrentYear();
            lsPeriod = getCurrentPeriod();
            lsWeek   = getCurrentWeek();

            lsQuery = "SELECT current_date = date_limit FROM op_grl_set_date";
            if(moAbcUtils.queryToString(lsQuery).equals("t")){ // Si es la fecha de tolerancia
                lsQuery = "SELECT now() < date_id FROM op_grl_set_date";
                if(moAbcUtils.queryToString(lsQuery).equals("t")){// Si la hora es menor a la hora tolerada
                    lsQuery = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YYYY-MM-DD') FROM op_grl_set_date";
                    lsToleranceDate = moAbcUtils.queryToString(lsQuery);
                    lsQuery = "SELECT year_no FROM ss_cat_time WHERE date_id = '"+lsToleranceDate+"'";
                    lsYear  = moAbcUtils.queryToString(lsQuery);
                    lsQuery = "SELECT period_no FROM ss_cat_time WHERE date_id = '"+lsToleranceDate+"'";
                    lsPeriod= moAbcUtils.queryToString(lsQuery);
                    lsQuery = "SELECT week_no - minor_week('"+lsYear+"', '"+lsPeriod+"') + 1 FROM ss_cat_time WHERE date_id = '"+lsToleranceDate+"'";
                    lsWeek  = moAbcUtils.queryToString(lsQuery);
                }
            }

        
            lsQuery = "INSERT INTO op_grl_invtran VALUES(?,?)";

            inventory  = new Inventory(lsYear.substring(2), Str.padZero(lsPeriod,2), lsWeek);
            loHashmap  = inventory.getExistence(false); // only values 
            loIterator = loHashmap.keySet().iterator();
            loValues   = new ArrayList(loHashmap.size());

            while(loIterator.hasNext())
            {
                String lsInvId    = (String) loIterator.next();
                Double loQuantity = (Double) loHashmap.get(lsInvId);
                String lsQuantity = loQuantity.toString();

                if(allowNegatives)
                    loValues.add( new String[]{lsInvId, lsQuantity} );
                else
                    if(loQuantity.doubleValue() >= 0)
                        loValues.add( new String[]{lsInvId, lsQuantity} );
            }
            moAbcUtils.executeSQLCommand(lsQuery, loValues);
        }
        catch(Exception e)
        {
            System.out.println("Exception loadCurrentInvtranItems() " + e.toString());
        }
    }

    /**
    Regresa el ID del proveedor para una remision dada.
    */
    String getRemProviderId(String psRemissionId)
    {
        String qry = "SELECT provider_id FROM op_grl_remission WHERE remission_id='"+ psRemissionId+"'";
        return moAbcUtils.queryToString(qry,"","");
    }

    /**
    Regresa el ID del proveedor para una orden dada.
    */
    String getOrdProviderId(String psOrderId)
    {
        String qry = "SELECT DISTINCT(provider_id) FROM op_grl_order_detail WHERE order_id="+psOrderId;
        return moAbcUtils.queryToString(qry,"","");
    }
    
    /**
    Regresa el ID de la orden para una remision dada.
    */
    String getRemOrderId(String psRemissionId){
        String lsQuery = "SELECT order_id FROM op_grl_remission WHERE remission_id='"+ psRemissionId+"'";
        return moAbcUtils.queryToString(lsQuery,"","");
    }

    String getRecProviderId(String psReceptionId)
    {
        String lsQuery = "SELECT provider_id FROM op_grl_reception WHERE reception_id="+ psReceptionId;
        return moAbcUtils.queryToString(lsQuery,"","");
    }

    String getOrdDateId(String psOrderId){
        String lsQuery = "SELECT date_id from op_grl_order WHERE order_id="+psOrderId;
        return moAbcUtils.queryToString(lsQuery,"","");
    }

    String getOrdDateLimit(String psOrderId){
        String lsQuery = "SELECT to_char(date_limit,'YYYY-MM-DD') FROM op_grl_order WHERE order_id=" + psOrderId;
        return moAbcUtils.queryToString(lsQuery,"","");
    }
    
    String getRecResponsible(String psDocNum, String psRecepId){
        return moAbcUtils.queryToString("SELECT responsible from op_grl_reception WHERE document_num='"+psDocNum+"' AND reception_id="+psRecepId,"","");
    }
    
    /**
        Obtiene el ID de una recepcion en base al numero de documento.
    */
    String getRecReceptionId(String psDocNum){
        return moAbcUtils.queryToString("SELECT reception_id FROM op_grl_reception WHERE document_num='"+psDocNum+"'","","");

    }
    
    /**
        Obtiene el valor maximo de sort_num para un detalle de remision.
    */
    String getRemSequence(String psRem){
        String lsQuery = "SELECT MAX(sort_num)+1 FROM op_grl_remission_detail WHERE remission_id = '" + psRem + "'";
        return moAbcUtils.queryToString(lsQuery,"","");
    }    
       

    /**
        Carga los registros de las cantidades de productos de pedidos en transito 
    */    
    void loadWayProducts()
    {
        String lsDummyOrderId = "0";

        String lsQry = "DELETE FROM op_grl_way_order WHERE order_id=?";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{lsDummyOrderId});

        lsQry = "DELETE FROM op_grl_suggested_order WHERE order_id=?";
        moAbcUtils.executeSQLCommand(lsQry, new String[]{lsDummyOrderId});

        lsQry  = " INSERT INTO op_grl_way_order SELECT 0, o.store_id, p.provider_product_code, ";
        lsQry += " p.provider_id, sum( od.inv_required_quantity )";
        lsQry += " FROM op_grl_order o INNER JOIN op_grl_order_detail od ON o.order_id = od.order_id ";
        lsQry += " AND o.store_id = od.store_id ";
        lsQry += " INNER JOIN op_grl_cat_providers_product p ON ";
        lsQry += " (p.provider_product_code = od.provider_product_code AND p.provider_id = od.provider_id)";
        lsQry += " WHERE o.date_id >= (current_date - interval '7 days') ";
        lsQry += " AND o.order_id NOT IN(SELECT order_id FROM op_grl_reception ORDER BY date_id DESC LIMIT 10) ";
        lsQry += " GROUP BY p.provider_product_code, o.store_id, p.provider_id ";
        lsQry += " ORDER BY p.provider_product_code";

        moAbcUtils.executeSQLCommand(lsQry, new String[]{});        
    }

%>
