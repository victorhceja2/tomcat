<%!
    String getCouponEM(String lsYearD)
    { // Regresa el coupon_id del cupon comida de empleado
      // Ya no se usa
       String lsQryCP="";
       if(!lsYearD.equals("0"))
       {
          lsQryCP += "SELECT coupon_id FROM gc_coupon_codes ";
          lsQryCP += "WHERE coupon_code = 'EM' ";
          return moAbcUtils.queryToString(lsQryCP);
       }else{
          return "0";
       }
    }

    String getDay2Week(String lsYearD, String lsPeriodD, String lsWeekD, String lsNum)
    { // Regresa la fecha en formato 'yyyy-mm-dd 00:00:00'
       String lsQryDay="";
       if(!lsYearD.equals("0"))
       {
          lsQryDay += "SELECT date_id - INTERVAL '2 WEEK' FROM ss_cat_time WHERE year_no = "+lsYearD+" ";
          if(!lsPeriodD.equals("0"))
             lsQryDay += "AND period_no="+lsPeriodD+" ";
  
          if(!lsWeekD.equals("0"))
             lsQryDay += "AND week_no="+lsWeekD+" ";
  
          lsQryDay += " AND EXTRACT(DOW FROM (date_id)) = "+lsNum+" ";
          
          return moAbcUtils.queryToString(lsQryDay);
       }else{
          return "0";
       }
    }

    String getDay(String lsYearD, String lsPeriodD, String lsWeekD, String lsNum)
    { // Regresa la fecha en formato 'yyyy-mm-dd 00:00:00'
       String lsQryDay="";
       if(!lsYearD.equals("0"))
       {
          lsQryDay += "SELECT date_id FROM ss_cat_time WHERE year_no = "+lsYearD+" ";
          if(!lsPeriodD.equals("0"))
             lsQryDay += "AND period_no="+lsPeriodD+" ";
  
          if(!lsWeekD.equals("0"))
             lsQryDay += "AND week_no="+lsWeekD+" ";
  
          lsQryDay += " AND EXTRACT(DOW FROM (date_id)) = "+lsNum+" ";
          
          return moAbcUtils.queryToString(lsQryDay);
       }else{
          return "0";
       }
    }

    String getTransMng(String lsYearD,  String lsDOW)
    { // Regresa total de transacciones congeladas por el mng por dia de la semana actual
      // de momento no se usa
       String lsQryT = "";
       if(!lsYearD.equals("0"))
       {
          lsQryT += "SELECT (CASE WHEN ";
          lsQryT += "(SELECT trans_mng FROM op_gt_real_sist_mng WHERE date_id = '"+lsDOW+"' ) ";
          lsQryT += " IS NULL THEN 0 ELSE ";
          lsQryT += "(SELECT trans_mng FROM op_gt_real_sist_mng WHERE date_id = '"+lsDOW+"' ) ";
          lsQryT += " END ) ";
          return moAbcUtils.queryToString(lsQryT);
       }else{
          return "0";
       }
    }

    String getSistToPastYear(String lsPercent, String lsTotSist)
    { // Regresa valores para transacciones que se esperan para la semana actual segun el sistema
       String lsQryCalc = "";
       if(lsTotSist.equals("0"))
       {
          lsTotSist = "1";
       }
       if(!lsPercent.equals("0"))
       {
          lsQryCalc += "SELECT ROUND("+lsPercent+" / CAST(100 AS DECIMAL) * "+lsTotSist+",0) ";
          return moAbcUtils.queryToString(lsQryCalc);
       }else{
          return "0";
       }
    }

    String getTransSist(String lsYearD, String lsPeriodD, String lsWeekD, String lsLessW)
    {// Devuelve el total de transacciones del sistema por semana - semanas que se quiera
     // de momento no se usa
       String lsQryT = "";
       if(!lsYearD.equals("0"))
       {
          lsQryT += "SELECT ISNULL(SUM(trans_sist),0) FROM op_gt_real_sist_mng WHERE date_id IN ";
          lsQryT += "(SELECT date_id - INTERVAL '"+lsLessW+" WEEK' AS DATE FROM ss_cat_time WHERE year_no = "+lsYearD+" ";
          if(!lsPeriodD.equals("0"))
             lsQryT += "AND period_no="+lsPeriodD+" ";

          if(!lsWeekD.equals("0"))
             lsQryT += "AND week_no="+lsWeekD+" ";

          lsQryT += ") ";
          return moAbcUtils.queryToString(lsQryT);
       }else{
          return "0";
       }
    }

    String getWeekTr(String lsYearD, String lsPeriodD, String lsWeekD, String lsLessW)
    { // Devuelve el total de transacciones por semana para la distribucion
      // no se usa
       String lsQryTW = ""; 
       if(!lsYearD.equals("0"))
       {
          lsQryTW += "SELECT (CASE WHEN SUM(tot_trans) IS NULL THEN 1 ELSE SUM(tot_trans) END) ";
          lsQryTW += "FROM gc_stats_dat WHERE code_id in (1,2,3) AND CAST(date_id AS CHAR(10)) IN "; 
          lsQryTW += "(SELECT to_char(date_id - INTERVAL '"+lsLessW+" WEEK','YYYY-MM-DD') AS DATE FROM ss_cat_time WHERE year_no = "+lsYearD+" ";
          if(!lsPeriodD.equals("0"))
             lsQryTW += "AND period_no="+lsPeriodD+" ";

          if(!lsWeekD.equals("0"))
             lsQryTW += "AND week_no="+lsWeekD+" ";
          
          lsQryTW += ") "; 
          return moAbcUtils.queryToString(lsQryTW);
       }else{
          return "0";
       }
    }

    String getTrDat(String lsYearD, String lsDate, String lsCode)
    { // Devuelve las transacciones por dia y codigo
      // lo usamos para PxP y Hut.
       String lsQryDat = "";
       if(!lsYearD.equals("0"))
       {
          lsQryDat += "SELECT tot_trans FROM gc_stats_dat WHERE date_id = '"+lsDate+"' ";
          lsQryDat += "AND code_id = "+lsCode+" ";

          return moAbcUtils.queryToString(lsQryDat);
       }else{
          return "0";
       }
    }

    String getTotTr(String lsYearD, String lsDate)
    { // Devuelve el total de transacciones por día de guest_step  
      // estas ya son netas
       String lsQryTR=""; 
       if(!lsYearD.equals("0"))
       {
          lsQryTR += "SELECT COUNT(*) FROM gc_guest_step WHERE date_id = '"+lsDate+"' ";
          lsQryTR += "AND gc_sequence <> 0 AND status_code <> 'CN' AND ";
          lsQryTR += "status_code <> 'CH' AND emp_meal = 0 ";

          return moAbcUtils.queryToString(lsQryTR);
       }else{
          return "0";
       }
    }

    String getPercentOfWeek(String lsYearD, String lsDate, String lsTot, String lsLessW)
    { // Regresa el porcentaje de transacciones del año pasado
       String lsQryPerc = "";
       if(lsTot.equals("0"))
       {
          lsTot = "1";
       }
       if(!lsYearD.equals("0"))
       {
          lsQryPerc += "SELECT (CASE WHEN (";
          lsQryPerc += "SELECT ROUND(100 * SUM(tot_trans)/"+lsTot+",0) FROM gc_stats_dat WHERE code_id in (1,2,3) AND date_id IN "; 
          lsQryPerc += "(SELECT DATE '"+lsDate+"' - INTERVAL '"+lsLessW+" WEEK' AS DATE ) ";
          lsQryPerc += ") IS NULL THEN 0 ELSE ("; 
          lsQryPerc += "SELECT ROUND(100 * SUM(tot_trans)/"+lsTot+",0) FROM gc_stats_dat WHERE code_id in (1,2,3) AND date_id IN "; 
          lsQryPerc += "(SELECT DATE '"+lsDate+"' - INTERVAL '"+lsLessW+" WEEK' AS DATE ) ";
          lsQryPerc += ") END ) "; 
 
          return moAbcUtils.queryToString(lsQryPerc);
       }else{
          return "0";
       }
    }

    String getTotTrHr(String lsYearD, String lsDate, String lsTot, String lsLimInf, String lsLimSup)
    { // Devuelve el porcentaje de transacciones entre las horas dadas de la
      // tabla gc_guest_step
       String lsQryTPD="";
       if(lsTot.equals("0"))
       {
          lsTot = "1";
       }
       if(!lsYearD.equals("0"))
       {
          lsQryTPD += "SELECT ROUND(100*CAST(COUNT(*) AS DECIMAL)/(CAST("+lsTot+" AS DECIMAL)),2) FROM gc_guest_step ";
          lsQryTPD += "WHERE ord_time > '"+lsLimInf+"' AND ord_time < '"+lsLimSup+"' AND date_id = '"+lsDate+"' ";
          lsQryTPD += "AND status_code <> 'CN' AND status_code <> 'CH' AND ";
          lsQryTPD += "gc_sequence <> 0 AND emp_meal = 0 ";
          return moAbcUtils.queryToString(lsQryTPD);
       }else{
          return "0";
       }
    }

    String getTotTransDest(String lsYearD, String lsDate, String lsDest, String lsTot)
    { // Devuelve el total de transacciones por día por destino de guest_step
      // estas ya son netas no tienen comidas de empleado
       String lsQryTPD="";
       if(lsTot.equals("0"))
       {
          lsTot = "1";
       }
       if(!lsYearD.equals("0"))
       {
          lsQryTPD += "SELECT ROUND(100*CAST(COUNT(*) AS DECIMAL)/(CAST("+lsTot+" AS DECIMAL)),2) FROM gc_guest_step ";
          lsQryTPD += "WHERE destination = '"+lsDest+"' AND date_id = '"+lsDate+"' ";
          lsQryTPD += "AND status_code <> 'CN' AND status_code <> 'CH' AND ";
          lsQryTPD += "gc_sequence <> 0 AND emp_meal = 0 ";

          return moAbcUtils.queryToString(lsQryTPD);
       }else{
          return "0";
       }
    }

    String getTotTransDestBack(String lsYearD, String lsDate, String lsDest)
    { // Devuelve el porcentaje de transacciones por destino
       String lsQryTT= "";
       if(!lsYearD.equals("0"))
       {
          lsQryTT += "SELECT ROUND(100 * tot_trans / (CASE WHEN (SELECT SUM(tot_trans) FROM gc_stats_dat WHERE date_id IN ";
          lsQryTT += "( SELECT DATE '"+lsDate+"' - INTERVAL '2 WEEK' AS DATE ) ";
          lsQryTT += "AND code_id IN (1,2,3)) = 0 THEN 1 ELSE "; 
          lsQryTT += "(SELECT SUM(tot_trans) FROM gc_stats_dat WHERE date_id IN ";
          lsQryTT += "( SELECT DATE '"+lsDate+"' - INTERVAL '2 WEEK' AS DATE ) ";
          lsQryTT += "AND code_id IN (1,2,3)) END ),1 ) FROM gc_stats_dat ";
          lsQryTT += "WHERE date_id IN "; 
          lsQryTT += "(SELECT DATE '"+lsDate+"' - INTERVAL '2 WEEK' AS DATE ) ";
          lsQryTT += "AND code_id = " + lsDest + " ";
          return moAbcUtils.queryToString(lsQryTT);
       }else{
          return "0";
       }
    }
    
    String getDate(String lsYear, String lsPeriod, String lsWeek, String lsDay)
    {
/*System.out.println("Esto es de getDate = lsyear:"+lsYear+" lsperiod:"+lsPeriod+" lsweek:"+lsWeek+" lsday:"+lsDay);*/
        String lsQueryD="";
        if(lsDay.equals("0"))
        {
           lsQueryD += "(SELECT MAX(date_id) FROM ss_cat_time WHERE year_no="+msYear+" ";
        
           if(!msPeriod.equals("0"))
              lsQueryD += " AND period_no="+msPeriod +" ";

           if(!msWeek.equals("0"))
              lsQueryD += " AND week_no="+msWeek+" ";

           if(!lsDay.equals("0"))
              lsQueryD += " AND EXTRACT(day from date_id) = " + lsDay + " ";

           lsQueryD += ") ";

           return moAbcUtils.queryToString(lsQueryD);
        }else{
           return "0";
        }
    }

    String getDateLim(String psCurrentYear, String psPeriod, String psWeek, String lsLim, String lsLessW)
    {
        String lsQryD="";
        if(!msYear.equals("0"))
        {
           lsQryD += "SELECT to_char("+lsLim+"(date_id) - INTERVAL '"+lsLessW+" WEEK','Mon-DD') FROM ss_cat_time WHERE year_no="+msYear+" ";
        
           if(!msPeriod.equals("0"))
              lsQryD += " AND period_no="+msPeriod +" ";

           if(!msWeek.equals("0"))
              lsQryD += " AND week_no="+msWeek+" ";

           return moAbcUtils.queryToString(lsQryD);
        }else{
           return "0";
        }
    }

    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay)
    {
       String lsCP;
       
       String lsDOW2, lsDOW3, lsDOW4, lsDOW5, lsDOW6, lsDOW0, lsDOW1; 
       String ls2wDOW2, ls2wDOW3, ls2wDOW4, ls2wDOW5, ls2wDOW6, ls2wDOW0, ls2wDOW1; 
       
       String lsTTxW; //lsTrSist;

       String lsTuYP, lsWeYP, lsThYP, lsFrYP, lsSaYP, lsSuYP, lsMoYP;

       //String lsTuSYP, lsWeSYP, lsThSYP, lsFrSYP, lsSaSYP, lsSuSYP, lsMoSYP;

       //String lsTu, lsWe, lsTh, lsFr, lsSa, lsSu, lsMo;

       String lsTrTu, lsTrWe, lsTrTh, lsTrFr, lsTrSa, lsTrSu, lsTrMo;

       String lsTTTu1, lsTTWe1, lsTTTh1, lsTTFr1, lsTTSa1, lsTTSu1, lsTTMo1;
       String lsTTTu2, lsTTWe2, lsTTTh2, lsTTFr2, lsTTSa2, lsTTSu2, lsTTMo2;
       String lsTTTu3, lsTTWe3, lsTTTh3, lsTTFr3, lsTTSa3, lsTTSu3, lsTTMo3;

       String lsTuH1,lsTuH2,lsTuH3,lsTuH4,lsTuH5,lsTuH6,lsTuH7,lsTuH8,lsTuH9,lsTuH10,lsTuH11,lsTuH12,lsTuH13;
       String lsWeH1,lsWeH2,lsWeH3,lsWeH4,lsWeH5,lsWeH6,lsWeH7,lsWeH8,lsWeH9,lsWeH10,lsWeH11,lsWeH12,lsWeH13;
       String lsThH1,lsThH2,lsThH3,lsThH4,lsThH5,lsThH6,lsThH7,lsThH8,lsThH9,lsThH10,lsThH11,lsThH12,lsThH13;
       String lsFrH1,lsFrH2,lsFrH3,lsFrH4,lsFrH5,lsFrH6,lsFrH7,lsFrH8,lsFrH9,lsFrH10,lsFrH11,lsFrH12,lsFrH13;
       String lsSaH1,lsSaH2,lsSaH3,lsSaH4,lsSaH5,lsSaH6,lsSaH7,lsSaH8,lsSaH9,lsSaH10,lsSaH11,lsSaH12,lsSaH13;
       String lsSuH1,lsSuH2,lsSuH3,lsSuH4,lsSuH5,lsSuH6,lsSuH7,lsSuH8,lsSuH9,lsSuH10,lsSuH11,lsSuH12,lsSuH13;
       String lsMoH1,lsMoH2,lsMoH3,lsMoH4,lsMoH5,lsMoH6,lsMoH7,lsMoH8,lsMoH9,lsMoH10,lsMoH11,lsMoH12,lsMoH13;

       String lsTuHut,lsWeHut,lsThHut,lsFrHut,lsSaHut,lsSuHut,lsMoHut;

       String lsTuPxP,lsWePxP,lsThPxP,lsFrPxP,lsSaPxP,lsSuPxP,lsMoPxP;

       //lsCP = getCouponEM( psCurrentYear);

       // Calculo de fechas para las demas funciones esto mejora el performance 
       lsDOW2 = getDay( psCurrentYear, psPeriod, msWeek, "2"); //Martes-Tuesday
       lsDOW3 = getDay( psCurrentYear, psPeriod, msWeek, "3"); //Miercoles-Wednesday
       lsDOW4 = getDay( psCurrentYear, psPeriod, msWeek, "4"); //Jueves-Thursday
       lsDOW5 = getDay( psCurrentYear, psPeriod, msWeek, "5"); //Viernes-Friday
       lsDOW6 = getDay( psCurrentYear, psPeriod, msWeek, "6"); //Sabado-Saturday
       lsDOW0 = getDay( psCurrentYear, psPeriod, msWeek, "0"); //Domingo-Sunday
       lsDOW1 = getDay( psCurrentYear, psPeriod, msWeek, "1"); //Lunes-Monday
      
       // Calculo de fechas para las demas funciones esto mejora el performance 
       ls2wDOW2 = getDay2Week( psCurrentYear, psPeriod, msWeek, "2"); //Martes-Tuesday
       ls2wDOW3 = getDay2Week( psCurrentYear, psPeriod, msWeek, "3"); //Miercoles-Wednesday
       ls2wDOW4 = getDay2Week( psCurrentYear, psPeriod, msWeek, "4"); //Jueves-Thursday
       ls2wDOW5 = getDay2Week( psCurrentYear, psPeriod, msWeek, "5"); //Viernes-Friday
       ls2wDOW6 = getDay2Week( psCurrentYear, psPeriod, msWeek, "6"); //Sabado-Saturday
       ls2wDOW0 = getDay2Week( psCurrentYear, psPeriod, msWeek, "0"); //Domingo-Sunday
       ls2wDOW1 = getDay2Week( psCurrentYear, psPeriod, msWeek, "1"); //Lunes-Monday

       /*lsTu = getTransMng( psCurrentYear, lsDOW2);
       lsWe = getTransMng( psCurrentYear, lsDOW3);
       lsTh = getTransMng( psCurrentYear, lsDOW4);
       lsFr = getTransMng( psCurrentYear, lsDOW5);
       lsSa = getTransMng( psCurrentYear, lsDOW6);
       lsSu = getTransMng( psCurrentYear, lsDOW0);
       lsMo = getTransMng( psCurrentYear, lsDOW1);*/
       // Estos son los totales de transacciones por dia
       lsTrTu = getTotTr( psCurrentYear, ls2wDOW2);
       lsTrWe = getTotTr( psCurrentYear, ls2wDOW3);
       lsTrTh = getTotTr( psCurrentYear, ls2wDOW4);
       lsTrFr = getTotTr( psCurrentYear, ls2wDOW5);
       lsTrSa = getTotTr( psCurrentYear, ls2wDOW6);
       lsTrSu = getTotTr( psCurrentYear, ls2wDOW0);
       lsTrMo = getTotTr( psCurrentYear, ls2wDOW1);
       // Estos son los porcentajes por destino 
       lsTTTu1 = getTotTransDest( psCurrentYear, ls2wDOW2, "2", lsTrTu);
       lsTTWe1 = getTotTransDest( psCurrentYear, ls2wDOW3, "2", lsTrWe);
       lsTTTh1 = getTotTransDest( psCurrentYear, ls2wDOW4, "2", lsTrTh);
       lsTTFr1 = getTotTransDest( psCurrentYear, ls2wDOW5, "2", lsTrFr);
       lsTTSa1 = getTotTransDest( psCurrentYear, ls2wDOW6, "2", lsTrSa);
       lsTTSu1 = getTotTransDest( psCurrentYear, ls2wDOW0, "2", lsTrSu);
       lsTTMo1 = getTotTransDest( psCurrentYear, ls2wDOW1, "2", lsTrMo);
        
       lsTTTu2 = getTotTransDest( psCurrentYear, ls2wDOW2, "3", lsTrTu);
       lsTTWe2 = getTotTransDest( psCurrentYear, ls2wDOW3, "3", lsTrWe);
       lsTTTh2 = getTotTransDest( psCurrentYear, ls2wDOW4, "3", lsTrTh);
       lsTTFr2 = getTotTransDest( psCurrentYear, ls2wDOW5, "3", lsTrFr);
       lsTTSa2 = getTotTransDest( psCurrentYear, ls2wDOW6, "3", lsTrSa);
       lsTTSu2 = getTotTransDest( psCurrentYear, ls2wDOW0, "3", lsTrSu);
       lsTTMo2 = getTotTransDest( psCurrentYear, ls2wDOW1, "3", lsTrMo);
       
       lsTTTu3 = getTotTransDest( psCurrentYear, ls2wDOW2, "1", lsTrTu);
       lsTTWe3 = getTotTransDest( psCurrentYear, ls2wDOW3, "1", lsTrWe);
       lsTTTh3 = getTotTransDest( psCurrentYear, ls2wDOW4, "1", lsTrTh);
       lsTTFr3 = getTotTransDest( psCurrentYear, ls2wDOW5, "1", lsTrFr);
       lsTTSa3 = getTotTransDest( psCurrentYear, ls2wDOW6, "1", lsTrSa);
       lsTTSu3 = getTotTransDest( psCurrentYear, ls2wDOW0, "1", lsTrSu);
       lsTTMo3 = getTotTransDest( psCurrentYear, ls2wDOW1, "1", lsTrMo);
       // Estos son los porcentajes por hora
       lsTuH1 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "10:59:59", "12:00:00"); 
       lsTuH2 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "11:59:59", "13:00:00"); 
       lsTuH3 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "12:59:59", "14:00:00"); 
       lsTuH4 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "13:59:59", "15:00:00"); 
       lsTuH5 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "14:59:59", "16:00:00"); 
       lsTuH6 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "15:59:59", "17:00:00"); 
       lsTuH7 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "16:59:59", "18:00:00"); 
       lsTuH8 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "17:59:59", "19:00:00"); 
       lsTuH9 = getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "18:59:59", "20:00:00"); 
       lsTuH10= getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "19:59:59", "21:00:00"); 
       lsTuH11= getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "20:59:59", "22:00:00"); 
       lsTuH12= getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "21:59:59", "23:00:00"); 
       lsTuH13= getTotTrHr( psCurrentYear, ls2wDOW2, lsTrTu, "22:59:59", "23:59:59"); 

       lsWeH1 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "10:59:59", "12:00:00"); 
       lsWeH2 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "11:59:59", "13:00:00"); 
       lsWeH3 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "12:59:59", "14:00:00"); 
       lsWeH4 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "13:59:59", "15:00:00"); 
       lsWeH5 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "14:59:59", "16:00:00"); 
       lsWeH6 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "15:59:59", "17:00:00"); 
       lsWeH7 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "16:59:59", "18:00:00"); 
       lsWeH8 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "17:59:59", "19:00:00"); 
       lsWeH9 = getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "18:59:59", "20:00:00"); 
       lsWeH10= getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "19:59:59", "21:00:00"); 
       lsWeH11= getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "20:59:59", "22:00:00"); 
       lsWeH12= getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "21:59:59", "23:00:00"); 
       lsWeH13= getTotTrHr( psCurrentYear, ls2wDOW3, lsTrWe, "22:59:59", "23:59:59"); 

       lsThH1 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "10:59:59", "12:00:00"); 
       lsThH2 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "11:59:59", "13:00:00"); 
       lsThH3 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "12:59:59", "14:00:00"); 
       lsThH4 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "13:59:59", "15:00:00"); 
       lsThH5 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "14:59:59", "16:00:00"); 
       lsThH6 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "15:59:59", "17:00:00"); 
       lsThH7 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "16:59:59", "18:00:00"); 
       lsThH8 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "17:59:59", "19:00:00"); 
       lsThH9 = getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "18:59:59", "20:00:00"); 
       lsThH10= getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "19:59:59", "21:00:00"); 
       lsThH11= getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "20:59:59", "22:00:00"); 
       lsThH12= getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "21:59:59", "23:00:00"); 
       lsThH13= getTotTrHr( psCurrentYear, ls2wDOW4, lsTrTh, "22:59:59", "23:59:59"); 

       lsFrH1 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "10:59:59", "12:00:00"); 
       lsFrH2 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "11:59:59", "13:00:00"); 
       lsFrH3 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "12:59:59", "14:00:00"); 
       lsFrH4 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "13:59:59", "15:00:00"); 
       lsFrH5 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "14:59:59", "16:00:00"); 
       lsFrH6 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "15:59:59", "17:00:00"); 
       lsFrH7 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "16:59:59", "18:00:00"); 
       lsFrH8 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "17:59:59", "19:00:00"); 
       lsFrH9 = getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "18:59:59", "20:00:00"); 
       lsFrH10= getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "19:59:59", "21:00:00"); 
       lsFrH11= getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "20:59:59", "22:00:00"); 
       lsFrH12= getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "21:59:59", "23:00:00"); 
       lsFrH13= getTotTrHr( psCurrentYear, ls2wDOW5, lsTrFr, "22:59:59", "23:59:59"); 

       lsSaH1 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "10:59:59", "12:00:00"); 
       lsSaH2 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "11:59:59", "13:00:00"); 
       lsSaH3 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "12:59:59", "14:00:00"); 
       lsSaH4 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "13:59:59", "15:00:00"); 
       lsSaH5 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "14:59:59", "16:00:00"); 
       lsSaH6 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "15:59:59", "17:00:00"); 
       lsSaH7 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "16:59:59", "18:00:00"); 
       lsSaH8 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "17:59:59", "19:00:00"); 
       lsSaH9 = getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "18:59:59", "20:00:00"); 
       lsSaH10= getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "19:59:59", "21:00:00"); 
       lsSaH11= getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "20:59:59", "22:00:00"); 
       lsSaH12= getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "21:59:59", "23:00:00"); 
       lsSaH13= getTotTrHr( psCurrentYear, ls2wDOW6, lsTrSa, "22:59:59", "23:59:59"); 

       lsSuH1 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "10:59:59", "12:00:00"); 
       lsSuH2 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "11:59:59", "13:00:00"); 
       lsSuH3 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "12:59:59", "14:00:00"); 
       lsSuH4 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "13:59:59", "15:00:00"); 
       lsSuH5 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "14:59:59", "16:00:00"); 
       lsSuH6 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "15:59:59", "17:00:00"); 
       lsSuH7 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "16:59:59", "18:00:00"); 
       lsSuH8 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "17:59:59", "19:00:00"); 
       lsSuH9 = getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "18:59:59", "20:00:00"); 
       lsSuH10= getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "19:59:59", "21:00:00"); 
       lsSuH11= getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "20:59:59", "22:00:00"); 
       lsSuH12= getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "21:59:59", "23:00:00"); 
       lsSuH13= getTotTrHr( psCurrentYear, ls2wDOW0, lsTrSu, "22:59:59", "23:59:59"); 

       lsMoH1 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "10:59:59", "12:00:00"); 
       lsMoH2 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "11:59:59", "13:00:00"); 
       lsMoH3 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "12:59:59", "14:00:00"); 
       lsMoH4 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "13:59:59", "15:00:00"); 
       lsMoH5 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "14:59:59", "16:00:00"); 
       lsMoH6 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "15:59:59", "17:00:00"); 
       lsMoH7 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "16:59:59", "18:00:00"); 
       lsMoH8 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "17:59:59", "19:00:00"); 
       lsMoH9 = getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "18:59:59", "20:00:00"); 
       lsMoH10= getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "19:59:59", "21:00:00"); 
       lsMoH11= getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "20:59:59", "22:00:00"); 
       lsMoH12= getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "21:59:59", "23:00:00"); 
       lsMoH13= getTotTrHr( psCurrentYear, ls2wDOW1, lsTrMo, "22:59:59", "23:59:59"); 

       lsTuHut = getTrDat( psCurrentYear, ls2wDOW2, "4");
       lsWeHut = getTrDat( psCurrentYear, ls2wDOW3, "4");
       lsThHut = getTrDat( psCurrentYear, ls2wDOW4, "4");
       lsFrHut = getTrDat( psCurrentYear, ls2wDOW5, "4");
       lsSaHut = getTrDat( psCurrentYear, ls2wDOW6, "4");
       lsSuHut = getTrDat( psCurrentYear, ls2wDOW0, "4");
       lsMoHut = getTrDat( psCurrentYear, ls2wDOW1, "4");
        
       lsTuPxP = getTrDat( psCurrentYear, ls2wDOW2, "5");
       lsWePxP = getTrDat( psCurrentYear, ls2wDOW3, "5");
       lsThPxP = getTrDat( psCurrentYear, ls2wDOW4, "5");
       lsFrPxP = getTrDat( psCurrentYear, ls2wDOW5, "5");
       lsSaPxP = getTrDat( psCurrentYear, ls2wDOW6, "5");
       lsSuPxP = getTrDat( psCurrentYear, ls2wDOW0, "5");
       lsMoPxP = getTrDat( psCurrentYear, ls2wDOW1, "5");

       lsTTxW = getWeekTr( psCurrentYear, psPeriod, msWeek, "52");

       //lsTrSist = getTransSist( psCurrentYear, psPeriod, msWeek, "0");

       lsTuYP = getPercentOfWeek( psCurrentYear, lsDOW2, lsTTxW, "52");
       lsWeYP = getPercentOfWeek( psCurrentYear, lsDOW3, lsTTxW, "52");
       lsThYP = getPercentOfWeek( psCurrentYear, lsDOW4, lsTTxW, "52");
       lsFrYP = getPercentOfWeek( psCurrentYear, lsDOW5, lsTTxW, "52");
       lsSaYP = getPercentOfWeek( psCurrentYear, lsDOW6, lsTTxW, "52");
       lsSuYP = getPercentOfWeek( psCurrentYear, lsDOW0, lsTTxW, "52");
       lsMoYP = getPercentOfWeek( psCurrentYear, lsDOW1, lsTTxW, "52");

       /*lsTuSYP = getSistToPastYear( lsTuYP, lsTrSist);
       lsWeSYP = getSistToPastYear( lsWeYP, lsTrSist);
       lsThSYP = getSistToPastYear( lsThYP, lsTrSist);
       lsFrSYP = getSistToPastYear( lsFrYP, lsTrSist);
       lsSaSYP = getSistToPastYear( lsSaYP, lsTrSist);
       lsSuSYP = getSistToPastYear( lsSuYP, lsTrSist);
       lsMoSYP = getSistToPastYear( lsMoYP, lsTrSist);*/

       String lsQuery="";

       //lsQuery += "SELECT 'a','% Congelado','"+lsTu+"','"+lsWe+"','"+lsTh+"','"+lsFr+"','"+lsSa+"','"+lsSu+"','"+lsMo+"' ";

       lsQuery += "SELECT 'a','<b class=bsTotals>Distribuci&oacute;n</b>','"+lsTuYP+" %','"+lsWeYP+" %','"+lsThYP+" %','"+lsFrYP+" %','"+lsSaYP+" %','"+lsSuYP+" %','"+lsMoYP+" %' ";
       lsQuery += "UNION SELECT 'b','<b class=bsTotals>DESTINOS</b>','','','','','','','' ";
       lsQuery += "UNION SELECT 'c','Delivery','"+lsTTTu1+" %','"+lsTTWe1+" %','"+lsTTTh1+" %','"+lsTTFr1+" %','"+lsTTSa1+" %','"+lsTTSu1+" %','"+lsTTMo1+" %' ";
       lsQuery += "UNION SELECT 'd','Carry Out','"+lsTTTu2+" %','"+lsTTWe2+" %','"+lsTTTh2+" %','"+lsTTFr2+" %','"+lsTTSa2+" %','"+lsTTSu2+" %','"+lsTTMo2+" %' ";
       lsQuery += "UNION SELECT 'e','Dine In','"+lsTTTu3+" %','"+lsTTWe3+" %','"+lsTTTh3+" %','"+lsTTFr3+" %','"+lsTTSa3+" %','"+lsTTSu3+" %','"+lsTTMo3+" %' ";
       lsQuery += "UNION SELECT 'f','<b class=bsTotals>% TRANS. PT</b>','','','','','','','' ";
       lsQuery += "UNION SELECT 'g','11 a 12','"+lsTuH1+" %','"+lsWeH1+" %','"+lsThH1+" %','"+lsFrH1+" %','"+lsSaH1+" %','"+lsSuH1+" %','"+lsMoH1+" %' ";
       lsQuery += "UNION SELECT 'h','12 a 13','"+lsTuH2+" %','"+lsWeH2+" %','"+lsThH2+" %','"+lsFrH2+" %','"+lsSaH2+" %','"+lsSuH2+" %','"+lsMoH2+" %' ";
       lsQuery += "UNION SELECT 'i','13 a 14','"+lsTuH3+" %','"+lsWeH3+" %','"+lsThH3+" %','"+lsFrH3+" %','"+lsSaH3+" %','"+lsSuH3+" %','"+lsMoH3+" %' ";
       lsQuery += "UNION SELECT 'j','14 a 15','"+lsTuH4+" %','"+lsWeH4+" %','"+lsThH4+" %','"+lsFrH4+" %','"+lsSaH4+" %','"+lsSuH4+" %','"+lsMoH4+" %' ";
       lsQuery += "UNION SELECT 'k','15 a 16','"+lsTuH5+" %','"+lsWeH5+" %','"+lsThH5+" %','"+lsFrH5+" %','"+lsSaH5+" %','"+lsSuH5+" %','"+lsMoH5+" %' ";
       lsQuery += "UNION SELECT 'l','16 a 17','"+lsTuH6+" %','"+lsWeH6+" %','"+lsThH6+" %','"+lsFrH6+" %','"+lsSaH6+" %','"+lsSuH6+" %','"+lsMoH6+" %' ";
       lsQuery += "UNION SELECT 'm','17 a 18','"+lsTuH7+" %','"+lsWeH7+" %','"+lsThH7+" %','"+lsFrH7+" %','"+lsSaH7+" %','"+lsSuH7+" %','"+lsMoH7+" %' ";
       lsQuery += "UNION SELECT 'n','18 a 19','"+lsTuH8+" %','"+lsWeH8+" %','"+lsThH8+" %','"+lsFrH8+" %','"+lsSaH8+" %','"+lsSuH8+" %','"+lsMoH8+" %' ";
       lsQuery += "UNION SELECT 'o','19 a 20','"+lsTuH9+" %','"+lsWeH9+" %','"+lsThH9+" %','"+lsFrH9+" %','"+lsSaH9+" %','"+lsSuH9+" %','"+lsMoH9+" %' ";
       lsQuery += "UNION SELECT 'p','20 a 21','"+lsTuH10+" %','"+lsWeH10+" %','"+lsThH10+" %','"+lsFrH10+" %','"+lsSaH10+" %','"+lsSuH10+" %','"+lsMoH10+" %' ";
       lsQuery += "UNION SELECT 'q','21 a 22','"+lsTuH11+" %','"+lsWeH11+" %','"+lsThH11+" %','"+lsFrH11+" %','"+lsSaH11+" %','"+lsSuH11+" %','"+lsMoH11+" %' ";
       lsQuery += "UNION SELECT 'r','22 a 23','"+lsTuH12+" %','"+lsWeH12+" %','"+lsThH12+" %','"+lsFrH12+" %','"+lsSaH12+" %','"+lsSuH12+" %','"+lsMoH12+" %' ";
       lsQuery += "UNION SELECT 's','23 a 24','"+lsTuH13+" %','"+lsWeH13+" %','"+lsThH13+" %','"+lsFrH13+" %','"+lsSaH13+" %','"+lsSuH13+" %','"+lsMoH13+" %' ";
       lsQuery += "UNION SELECT 't','<b class=bsTotals>MIX</b>','','','','','','','' ";
       lsQuery += "UNION SELECT 'u','% Hutcheese + Cheesypops','"+lsTuHut+" %','"+lsWeHut+" %','"+lsThHut+" %','"+lsFrHut+" %','"+lsSaHut+" %','"+lsSuHut+" %','"+lsMoHut+" %' ";
       lsQuery += "UNION SELECT 'v','Pizzas x pedido','"+lsTuPxP+"','"+lsWePxP+"','"+lsThPxP+"','"+lsFrPxP+"','"+lsSaPxP+"','"+lsSuPxP+"','"+lsMoPxP+"' ";
       //lsQuery += "UNION SELECT 'w','<b class=bsTotals>Sistema</b>','"+lsTuSYP+"','"+lsWeSYP+"','"+lsThSYP+"','"+lsFrSYP+"','"+lsSaSYP+"','"+lsSuSYP+"','"+lsMoSYP+"' ";
       lsQuery += "UNION SELECT 'x','<b class=bsTotals>Gerente</b>','','','','','','','' ";
       lsQuery += "UNION SELECT 'y','','','','','','','','' ORDER BY 1";

       return moAbcUtils.getJSResultSet(lsQuery);
    }

    String getDataset1(String psCurrentYear1, String psPeriod1, String psWeek1, String msDay1)
    {

       String lsTxW1,lsTxW2,lsTxW3,lsTxW4,lsTxW5,lsTxW6,lsTxW7;

       String lsTxPW0,lsTxPW1,lsTxPW2,lsTxPW3,lsTxPW4,lsTxPW5,lsTxPW6,lsTxPW7;

       String lsRInf1,lsRSup1,lsRInf2,lsRSup2,lsRInf3,lsRSup3,lsRInf4,lsRSup4,lsRInf5,lsRSup5,lsRInf6,lsRSup6;

       String lsPRInf0,lsPRSup0,lsPRInf1,lsPRSup1,lsPRInf2,lsPRSup2,lsPRInf3,lsPRSup3,lsPRInf4,lsPRSup4,lsPRInf5,lsPRSup5,lsPRInf6,lsPRSup6;

       lsRInf1=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "2");
       lsRSup1=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "2");
       lsRInf2=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "3");
       lsRSup2=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "3");
       lsRInf3=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "4");
       lsRSup3=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "4");
       lsRInf4=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "5");
       lsRSup4=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "5");
       lsRInf5=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "6");
       lsRSup5=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "6");
       lsRInf6=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "7");
       lsRSup6=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "7");

       lsPRInf0=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "52");
       lsPRSup0=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "52");
       lsPRInf1=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "54");
       lsPRSup1=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "54");
       lsPRInf2=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "55");
       lsPRSup2=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "55");
       lsPRInf3=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "56");
       lsPRSup3=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "56");
       lsPRInf4=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "57");
       lsPRSup4=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "57");
       lsPRInf5=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "58");
       lsPRSup5=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "58");
       lsPRInf6=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MIN", "59");
       lsPRSup6=getDateLim( psCurrentYear1, psPeriod1, msWeek, "MAX", "59");
   
       lsTxW1 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "2");
       lsTxW2 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "3");
       lsTxW3 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "4");
       lsTxW4 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "5");
       lsTxW5 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "6");
       lsTxW6 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "7");
           
       lsTxPW0 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "52");
       lsTxPW1 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "54");
       lsTxPW2 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "55");
       lsTxPW3 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "56");
       lsTxPW4 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "57");
       lsTxPW5 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "58");
       lsTxPW6 = getWeekTr( psCurrentYear1, psPeriod1, msWeek, "59");
   
   
       String lsvQuery="";
       lsvQuery += "SELECT 'a','','"+lsRInf6+" "+lsRSup6+"','"+lsRInf5+" "+lsRSup5+"','"+lsRInf4+" "+lsRSup4+"','"+lsRInf3+" "+lsRSup3+"','"+lsRInf2+" "+lsRSup2+"','"+lsRInf1+" "+lsRSup1+"','' ";
       lsvQuery += "UNION SELECT 'b','Actual','"+lsTxW6+"','"+lsTxW5+"','"+lsTxW4+"','"+lsTxW3+"','"+lsTxW2+"','"+lsTxW1+"','' ";
       lsvQuery += "UNION SELECT 'c','','"+lsPRInf6+" "+lsPRSup6+"','"+lsPRInf5+" "+lsPRSup5+"','"+lsPRInf4+" "+lsPRSup4+"','"+lsPRInf3+" "+lsPRSup3+"','"+lsPRInf2+" "+lsPRSup2+"','"+lsPRInf1+" "+lsPRSup1+"','"+lsPRInf0+" "+lsPRSup0+"' ";
       lsvQuery += "UNION SELECT 'd','Anterior','"+lsTxPW6+"','"+lsTxPW5+"','"+lsTxPW4+"','"+lsTxPW3+"','"+lsTxPW2+"','"+lsTxPW1+"','"+lsTxPW0+"' ";
       return moAbcUtils.getJSResultSet(lsvQuery);
    }

   /*void updateConm(String lsYearC, String lsPeriodC, String lsWeekC, String lsDayC){
        
        String lsDate="";
        String lsParamDate="";
        lsDate=getDate(msYear, msPeriod, msWeek, lsDayC);
    
        String laCommand[];
        try{
            if(!lsDate.equals("0")){
                lsParamDate= ""+lsDate.substring(2,4).concat(lsDate.substring(5,7)).concat(lsDate.substring(8,10))+"";
                laCommand = new String[]{"/usr/bin/ph/databases/hours/bin/hr_dat.pl",lsParamDate};
            } else {
                laCommand = new String[]{"/usr/bin/ph/databases/hours/bin/hr_dat.pl"};
            }
                Process process = Runtime.getRuntime().exec(laCommand);
                process.waitFor();
            }
        catch(Exception e){
            System.out.println("Exception Reporte OD fecha " + lsParamDate + " de exec e ... " + e.toString());
        }
     }*/
     //Fin metodo updateConm()
%>
