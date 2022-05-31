
<%!

    String getDate(String msWeek, String msYear, String msPeriod, String msDay)
    {
        String lsQuery;

        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                  "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
                  "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                  "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";

        return moAbcUtils.queryToString(lsQuery);
    }

    String executeCommand (String [] command) {
        String s = null;

        try {
            Process p = Runtime.getRuntime().exec(command);

            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

            BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

            s = stdInput.readLine();
            //System.out.println(s);
            //while ((s = stdError.readLine()) != null) {
            //    System.out.println(s);
            //}
        } catch (IOException e) {
            System.out.println("Error al ejecutar el comando: ");
            e.printStackTrace();
        } 
        return s;
    }

    String getODmix(String msDate) {
        String [] cmd = { "/bin/sh", "-c", "grep Total /usr/fms/op/rpts/vpxh/"+msDate+" | tail -n1 | perl -ane \'$U=$F[2]+$F[8]+$F[10]; $S=$F[4]; $HC=$F[6];  $TOT=$U+$S+$HC; $pU = $U/$TOT*100; $pHC = $HC/$TOT*100; $pS = $S/$TOT*100; $result = sprintf(\"%.2f,%.2f,%.2f\", $pU, $pHC,$pS); print \"$result\\n\";\'"};
        String result = executeCommand(cmd);
        return result;
    }

    String getYesterdayDate(String msDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
        GregorianCalendar gc = new GregorianCalendar();
        String msYesterday = null;
        try {
            java.util.Date d = sdf.parse(msDate);
            gc.setTime(d);
            int dayBefore = gc.get(Calendar.DAY_OF_YEAR);
            gc.roll(Calendar.DAY_OF_YEAR, -1);
            int dayAfter = gc.get(Calendar.DAY_OF_YEAR);
            if(dayAfter > dayBefore) {
                gc.roll(Calendar.YEAR, -1);
            }
            gc.get(Calendar.DATE);
            java.util.Date yesterday = gc.getTime();
            msYesterday = sdf.format(yesterday);
        } catch(Exception e) {
            e.printStackTrace();
        }
        return msYesterday;

        
    }

    String getTomorrowDate(String msDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
        GregorianCalendar gc = new GregorianCalendar();
        String msTomorrow  = null;
        try {
            java.util.Date d = sdf.parse(msDate);
            gc.setTime(d);
            int dayBefore = gc.get(Calendar.DAY_OF_YEAR);
            gc.roll(Calendar.DAY_OF_YEAR, +1);
            int dayAfter = gc.get(Calendar.DAY_OF_YEAR);
            if(dayBefore > dayAfter) {
                gc.roll(Calendar.YEAR, +1);
            }
            gc.get(Calendar.DATE);
            java.util.Date tomorrow = gc.getTime();
            msTomorrow  = sdf.format(tomorrow);
        } catch(Exception e) {
            e.printStackTrace();
        }
        return msTomorrow;

        
    }

    String getNDate(String msDate, int days) {
        SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
        GregorianCalendar gc = new GregorianCalendar();
        String msNDate = null;
        try {
            java.util.Date d = sdf.parse(msDate);
            gc.setTime(d);
            int dayBefore = gc.get(Calendar.DAY_OF_YEAR);
            gc.roll(Calendar.DAY_OF_YEAR, days);
            int dayAfter = gc.get(Calendar.DAY_OF_YEAR);
            if(dayBefore > dayAfter) {
                gc.roll(Calendar.YEAR, days);
            }
            gc.get(Calendar.DATE);
            java.util.Date tomorrow = gc.getTime();
            msNDate = sdf.format(tomorrow);
        } catch(Exception e) {
            e.printStackTrace();
        }
        return msNDate;

        
    }

    String getCurrentHour() {
        Calendar cal = Calendar.getInstance();
    	cal.getTime();
    	SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
    	return sdf.format(cal.getTime()); 
    }

    String getTransCong(String msDate) {
        String lsQuery = "SELECT trans_mng FROM op_gt_real_sist_mng WHERE date_id='20"+msDate+"'";
        return moAbcUtils.queryToString(lsQuery);
    }

    String getPzaxTrans(String msDate) {
        String lsQuery = "SELECT ppt_mng FROM op_gt_real_sist_mng WHERE date_id='20"+msDate+"'";
        return moAbcUtils.queryToString(lsQuery);
    }

    String Round(String q) {
        return String.valueOf(round(Float.parseFloat(q), 0));
    }

    double round(double val, int places) {
        long factor = (long)Math.pow(10,places);

        val = val * factor;

        long tmp = Math.round(val);

        return (double)tmp / factor;
    }

    float round(float val, int places) {
        return (float)round((double)val, places);
    }
    


    


%>
