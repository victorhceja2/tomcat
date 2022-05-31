<%!
    String getDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay, int repType){
        String psqlQuery = "";
        
        switch( repType ){
            case 1: psqlQuery += "SELECT start_time, end_time, olt, omt, cars_d, viewResOrder.daypart, avg_day, wlt, wmt, "
                + "cars_w, avg_sem, otdlt, otdmt, cars_p, avg_period "
                + "from viewResOrder left join op_tmr_dayparts ON viewResOrder.daypart = op_tmr_dayparts.daypart order by daypart";
                break;
            case 2: psqlQuery = "SELECT start_time, end_time, olt, omt, cars_d, viewResWindow.daypart, avg_day, wlt, wmt, "
                + "cars_w, avg_sem, otdlt, otdmt, cars_p, avg_period "
                + "from viewResWindow left join op_tmr_dayparts ON viewResWindow.daypart = op_tmr_dayparts.daypart order by daypart";
                break;
            case 3: psqlQuery = "SELECT start_time, end_time, olt, omt, cars_d, viewResDelivery.daypart, avg_day, wlt, wmt, "
                + "cars_w, avg_sem, otdlt, otdmt, cars_p, avg_period "
                + "from viewResDelivery left join op_tmr_dayparts ON viewResDelivery.daypart = op_tmr_dayparts.daypart order by daypart";
                break;
            case 4: psqlQuery += "SELECT start_time, end_time, Ordertime,  Windowtime, OTD,  viewResDrive.day_part, cars, no_trans,  avg_trans "
                    + "from viewResDrive left join op_tmr_dayparts ON viewResDrive.day_part = op_tmr_dayparts.daypart "
                    + "LEFT JOIN tmp_d_trans ON viewResDrive.day_part = tmp_d_trans.daypart order by start_time;";
                break;
            default:
                return psqlQuery;
        }
        return moAbcUtils.getJSResultSet(psqlQuery);
    }
    
    void prepareDataset(String psCurrentYear, String psPeriod, String psWeek, String msDay){
        String psqlQuery = "";
        
        int periodNo = Integer.parseInt(psPeriod);
        
        int weekNo = Integer.parseInt(psWeek);
        
        //psqlQuery = "select to_char(date_id, 'yyyy-mm-dd') as caldate from "
          //      + "ss_cat_time WHERE year_no="+psCurrentYear+" and period_no="+psPeriod+" and week_no="+weekNo+" and weekday_id=2";
        
        //psqlQuery = "select date_part('month', date_id) FROM ss_cat_time WHERE year_no=%s and period_no=%s and week_no=%s AND date_part('day', date_id) = %s";
        
        psqlQuery = "select to_char(date_id, 'yyyy-mm-dd') as caldate from ss_cat_time WHERE year_no=%s and period_no=%s and week_no=%s AND date_part('day', date_id) = %s";
        psqlQuery =  Str.getFormatted(psqlQuery, new Object[]{psCurrentYear, psPeriod, psWeek, msDay});
        String dateYYYYMMDD = moAbcUtils.queryToString(psqlQuery);
        
        psqlQuery = "select to_char(date_id, 'yymmdd') as caldate from ss_cat_time WHERE year_no=%s and period_no=%s and week_no=%s AND date_part('day', date_id) = %s";
        psqlQuery =  Str.getFormatted(psqlQuery, new Object[]{psCurrentYear, psPeriod, psWeek, msDay});
        String dateYYMMDD = moAbcUtils.queryToString(psqlQuery);
        
        // -----------------------------------------------
        try{
            Process p = Runtime.getRuntime().exec("/usr/bin/ph/timer/rptwin.s "+dateYYMMDD);
            Thread.sleep(2000);
        }catch( Exception e ){
            e.printStackTrace();
        }
        // -----------------------------------------------
        
        psqlQuery = "select fill_performance( '"+dateYYYYMMDD+"' )";
        
        moAbcUtils.executeSQLCommand(psqlQuery);
        
        /*
        switch( repType ){
            case 1: psqlQuery += "SELECT start_time, end_time, olt, omt, cars_d, viewResOrder.daypart, avg_day, wlt, wmt, "
                + "cars_w, avg_sem, otdlt, otdmt, cars_p, avg_period "
                + "from viewResOrder left join op_tmr_dayparts ON viewResOrder.daypart = op_tmr_dayparts.daypart order by daypart";
                break;
            case 2: psqlQuery = "SELECT start_time, end_time, olt, omt, cars_d, viewResWindow.daypart, avg_day, wlt, wmt, "
                + "cars_w, avg_sem, otdlt, otdmt, cars_p, avg_period "
                + "from viewResWindow left join op_tmr_dayparts ON viewResWindow.daypart = op_tmr_dayparts.daypart order by daypart";
                break;
            case 3: psqlQuery = "SELECT start_time, end_time, olt, omt, cars_d, viewResDelivery.daypart, avg_day, wlt, wmt, "
                + "cars_w, avg_sem, otdlt, otdmt, cars_p, avg_period "
                + "from viewResDelivery left join op_tmr_dayparts ON viewResDelivery.daypart = op_tmr_dayparts.daypart order by daypart";
                break;
            case 4: psqlQuery += "SELECT start_time, end_time, Ordertime,  Windowtime, OTD,  viewResDrive.day_part, cars from viewResDrive "
                + " left join op_tmr_dayparts ON viewResDrive.day_part = op_tmr_dayparts.daypart order by start_time";
                break;
            default:
                return psqlQuery;
        }
        return moAbcUtils.getJSResultSet(psqlQuery);*/
    }
%>