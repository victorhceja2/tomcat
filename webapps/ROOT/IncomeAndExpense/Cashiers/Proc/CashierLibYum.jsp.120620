<%!
  String getDataset(String psDate, String psEmp, String psMgr){
      String laQryG[][], laQryC[][]; // Arreglo para los datos de guest y datos de cash
      String lsQryG,lsQryInit,lsQryInitRS,lsQryEsp,lsQryEspRS,lsQryC,lsMainQry,lsAvgNet,lsNoTks,lsTotVtaB,lsTotRec,lsEfect,lsValidDate,lsValidDateR,lsDepTar,lsRecMisc,lsEfectivo;

      lsValidDate = "SELECT (CASE WHEN fecha is null THEN '1' ELSE fecha END) FROM (SELECT isnull('"+psDate+"','') as fecha) d";
      lsValidDateR = moAbcUtils.queryToString(lsValidDate); // Fecha valida   
      if(lsValidDateR.length() < 9){
          System.out.println("Fecha no valida:"+psDate+" EMP:"+psEmp+" psMgr:"+psMgr);
	  psEmp = "1";
	  psMgr = "1";
	  psDate = "30/11/2010";
      }


      lsQryG = "SELECT tot, vta_bruta, tot_prom, num_prom, emp.no_emp_meal, emp.tot_emp_meal, ch.no_ch, ch.tot_ch, cn.no_cn, cn.tot_cn ";
      lsQryG += "FROM ";
      lsQryG += "(SELECT "+psEmp+" AS code,COUNT(gc_sequence) AS tot, (CASE WHEN SUM(gross_sold) IS NULL THEN '0' ELSE SUM(gross_sold) END) AS vta_bruta, ";
      lsQryG += "(CASE WHEN SUM(promo_allowance) IS NULL THEN '0' ELSE SUM(promo_allowance) END) AS tot_prom, ";
      lsQryG += "(SELECT COUNT(gc_sequence) FROM gc_guest_step where cash_emp = "+psEmp+" AND date_id = '"+psDate+"' AND promo_allowance > 0) AS num_prom ";
      lsQryG += "FROM gc_guest_checks WHERE cash_emp = "+psEmp+" AND date_id = '"+psDate+"') AS st INNER JOIN ";
      lsQryG += "(SELECT "+psEmp+" AS cash_emp,COUNT(gc_sequence) AS no_emp_meal, ";
      lsQryG += "(CASE WHEN SUM(gross_sold) IS NULL THEN '0' ELSE SUM(gross_sold) END) AS tot_emp_meal ";
      lsQryG += "FROM gc_guest_step where cash_emp = "+psEmp+" AND date_id = '"+psDate+"' AND emp_meal = 1) AS emp ";
      lsQryG += "ON (st.code=emp.cash_emp) INNER JOIN ";
      lsQryG += "(SELECT "+psEmp+" AS cash_emp, COUNT(gc_sequence) AS no_ch, ";
      lsQryG += "(CASE WHEN SUM(gross_sold) IS NULL THEN '0' ELSE SUM(gross_sold) END) AS tot_ch ";
      lsQryG += "FROM gc_guest_step where cash_emp = "+psEmp+" AND date_id = '"+psDate+"' AND status_code = 'CH') AS ch ";
      lsQryG += "ON (emp.cash_emp=ch.cash_emp) INNER JOIN ";
      lsQryG += "(SELECT "+psEmp+" AS cash_emp, COUNT(gc_sequence) AS no_cn, ";
      lsQryG += "(CASE WHEN SUM(gross_sold) IS NULL THEN '0' ELSE SUM(gross_sold) END) as tot_cn ";
      lsQryG += "FROM gc_guest_step where cash_emp = "+psEmp+" AND date_id = '"+psDate+"' AND status_code = 'CN') AS cn ";
      lsQryG += "ON (ch.cash_emp=cn.cash_emp) ";

      laQryG = moAbcUtils.queryToMatrix(lsQryG); // Datos de guest

      lsQryInit = "SELECT (CASE WHEN SUM(gross) IS NULL THEN '0' ELSE SUM(gross) END) FROM gc_cash ";
      lsQryInit += "WHERE date_id = '"+psDate+"' and emp_code = "+psEmp+" and trans_code = 0 and ser_sequence = 1 ";

      lsQryInitRS = moAbcUtils.queryToString(lsQryInit); // Cambio inicial
     
      lsQryEsp = " select (CASE WHEN sum(gross) IS NULL THEN '0' ELSE sum(gross) END) from gc_cash WHERE ";
      lsQryEsp += "date_id = '"+psDate+"' and emp_code = "+psEmp+" and trans_code in (8,12,14,18,22,28,30,38,40,52,42,44,45,46,47,43,50,51,53,54,20)";

      lsQryEspRS = moAbcUtils.queryToString(lsQryEsp); // Gastos
      
      lsQryC = "select t.trans_desc ,isnull(c.tot,0) from gc_trans_codes t left join ";
      lsQryC += "(select trans_code, sum(gross) as tot from gc_cash ";
      lsQryC += "where date_id = '"+psDate+"' and emp_code = "+psEmp+" and trans_code in (1,60,100,200,208,209,211) ";
      lsQryC += "group by 1) c on (c.trans_code = t.trans_code) ";
      lsQryC += "where t.trans_code in (1,60,100,200,208,209,211) ORDER BY 1";

      laQryC = moAbcUtils.queryToMatrix(lsQryC); // Movimientos de cajero
                                                 /*Decrementar Caja
						   Deposito Dolares
						   Deposito Efectivo Banco
						   Deposito Tarjeta Bancom Bancomer o Scot 208 0 209
						   Efectivo
						   Ingresos Miscelaneos*/

      lsDepTar=laQryC[3][1];
      lsEfectivo=laQryC[4][1];
      lsRecMisc=laQryC[5][1];
      if( laQryC.length != 6 ){
         lsEfectivo=laQryC[5][1];
         lsRecMisc=laQryC[6][1];
         lsDepTar=laQryC[4][1]+"+"+laQryC[3][1];
      }
      if(laQryG[0][0].equals("0") || laQryG[0][0].equals(laQryG[0][4])){
         lsAvgNet = "'0'";
      }else{
         lsAvgNet = "CAST(ROUND(("+laQryG[0][1]+"-"+laQryG[0][2]+"-"+laQryG[0][7]+"-"+laQryG[0][9]+")/("+laQryG[0][0]+"-"+laQryG[0][4]+"),2) AS CHAR(9))";
      }
      lsNoTks = laQryG[0][0]+"-"+laQryG[0][8]+"-"+laQryG[0][6]; // Numero de tickets menos cancelaciones hechas y no hechas
      lsTotVtaB = laQryG[0][1]+"-"+laQryG[0][7]+"-"+laQryG[0][9]; // Total ventas brutas menos cancelaciones
      lsTotRec = laQryG[0][1]+"-"+laQryG[0][2]+"-"+laQryG[0][7]+"-"+laQryG[0][9]; // Tot. recibido menos cancelaciones
      lsEfect = laQryG[0][0]+"-"+laQryG[0][8]+"-"+laQryG[0][6];

      lsMainQry = "SELECT 'A','# No tickets', CAST(("+lsNoTks+") AS CHAR(5)), '$ Total ventas brutas',CAST(("+lsTotVtaB+") AS CHAR(9))";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'B','$ Total Recibido',CAST(("+lsTotRec+") AS CHAR(9)),'Promedio Net/Ticket',"+lsAvgNet+"";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'C','$ Cambio inicial','"+lsQryInitRS+"','$ Recibos ventas','"+laQryC[1][1]+"'"; 
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'D','# Recibos miscelaneos','"+lsRecMisc+"','$ Decremento','"+laQryC[0][1]+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'E','$ Gastos','"+lsQryEspRS+"', '$ Depositos efectivo', '"+laQryC[2][1]+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'F','$ Depositos tarjeta',CAST(("+lsDepTar+") AS CHAR(9)), '$ Depositos dolares','"+laQryC[1][1]+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'G','# Efectivo',CAST(("+lsEfect+") AS CHAR(5)), '$ Efectivo','"+lsEfectivo+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'H','# Promos',CAST(("+laQryG[0][3]+"-"+laQryG[0][4]+") AS CHAR(5)),'$ Promos',CAST(("+laQryG[0][2]+"-"+laQryG[0][5]+") AS CHAR(9))";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'I','# Comidas de empleado','"+laQryG[0][4]+"', '$ Total comidas de empleado','"+laQryG[0][5]+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'J','# Cancelaciones hechas','"+laQryG[0][6]+"', '$ Cancelaciones hechas','"+laQryG[0][7]+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'K','# Cancelaciones no hechas','"+laQryG[0][8]+"', '$ Cancelaciones no hechas','"+laQryG[0][9]+"'";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'L','<b class=bsTotals>CUPONES</b>','', '','' ";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'M','<b class=bsTotals>Descripci&oacute;n</b>','<b class=bsTotals># Numero</b>', '<b class=bsTotals>Reporte iniciado por:&nbsp;&nbsp;&nbsp;"+getEmpRequest(psMgr)+"</b>','' ";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'N',cc.coup_desc, CAST(COUNT(cp.gc_sequence) AS CHAR(4)), '','' ";
      lsMainQry += "FROM gc_guest_step gc RIGHT JOIN gc_items it ON (gc.date_id=it.date_id AND gc.gc_sequence=it.gc_sequence) ";
      lsMainQry += "RIGHT JOIN gc_coupons cp ON (it.date_id=cp.date_id AND it.gc_sequence=cp.gc_sequence AND it.it_seq=cp.it_seq) ";
      lsMainQry += "RIGHT JOIN gc_coupon_codes cc ON (cp.coupon_id=cc.coupon_id) ";
      lsMainQry += "WHERE gc.date_id = '"+psDate+"' AND gc.cash_emp = "+psEmp+" GROUP BY 1,2";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'O','<b class=bsTotals>PRODUCTOS DE LA CUPONERA</b>','', '',''";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'P','<b class=bsTotals>Descripci&oacute;n del producto</b>','<b class=bsTotals># Numero de productos</b>', '<b class=bsTotals>Autoriza:</b>_______________________________________________',''";
      lsMainQry += " UNION ";
      lsMainQry += "SELECT 'Q',mi.menu_item_desc,CAST(SUM(it.qty_sold) AS CHAR(8)),'','' ";
      lsMainQry += "FROM gc_guest_step gc RIGHT JOIN gc_items it ON (gc.date_id=it.date_id AND gc.gc_sequence=it.gc_sequence) ";
      lsMainQry += "RIGHT JOIN sus_menu_items mi ON (it.menu_item = mi.menu_item) ";
      lsMainQry += "INNER JOIN mk_items_marketin mki ON (mki.menu_item = mi.menu_item) ";
      lsMainQry += "WHERE gc.date_id = '"+psDate+"' AND gc.cash_emp = "+psEmp+" GROUP BY 1,2";
      lsMainQry += "ORDER BY 1 ";

      return moAbcUtils.getJSResultSet(lsMainQry);

    }

    String getEmpRequest(String psEmpCode){
        String lsQry="SELECT REPLACE(name,' ','&nbsp;') FROM pp_employees WHERE emp_code = "+psEmpCode;
        return moAbcUtils.queryToString(lsQry);
    }

    void updateP1toDB(){

        String laCommand[] = new String[]{"/usr/bin/ph/gctpopn.s"};
        try{
                System.out.println("Actualizando Reporte de cajeros");
                Process process = Runtime.getRuntime().exec(laCommand);
                //process.waitFor();
            }catch(Exception e){
                System.out.println("Exception Reporte de cajeros fecha de exec e ... " + e.toString());
            }
    }
%>
