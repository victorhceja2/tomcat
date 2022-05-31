
<%!
    String getDataset(String msWeek, String msYear, String msPeriod, String msWeekId, String msDay, String Fn)
    {
        String lsQuery;
	String products     = getProducts("/usr/local/tomcat/webapps/ROOT/Planning/IdealUse/Rpt/conf/"+Fn);
	String selectedDate = getDate(msWeek, msYear, msPeriod, msDay);
	String TransManager = getTransManager(selectedDate);
	String goalDate     = getLastDateEqualRealTransactions(TransManager);

	//System.out.println("goalDate = "+goalDate);

        lsQuery = "(SELECT d.inv_desc, d.inv_unit_measure, i.ideal_use  FROM op_inv_ideal_use as i INNER JOIN "+
	          "op_grl_cat_inventory as d ON i.inv_id=d.inv_id WHERE "+
		  "i.turn_date='"+goalDate+"' AND i.inv_id IN ("+products+")) "+
		  "ORDER BY 1";
		  
	//System.out.println("QUERY: "+lsQuery); 

        return moAbcUtils.getJSResultSet(lsQuery);
    }

    String getDataset(String msWeek, String msYear, String msPeriod, String msWeekId, String msDay, String Fn, int days)
    {
        String lsQuery;
	String products     = getProducts("/usr/local/tomcat/webapps/ROOT/Planning/IdealUse/Rpt/conf/"+Fn);
	String percent      = getPercent("/usr/local/tomcat/webapps/ROOT/Planning/IdealUse/Rpt/conf/percent.conf");
        String Date14       = getDate(msWeek, msYear, msPeriod, msDay, days);

	//System.out.println("goalDate = "+goalDate);

        lsQuery = "(SELECT d.inv_desc, d.inv_unit_measure, trunc(i.ideal_use*"+percent+"+i.ideal_use,2) FROM op_inv_ideal_use as i INNER JOIN "+
	          "op_grl_cat_inventory as d ON i.inv_id=d.inv_id WHERE "+
		  "i.turn_date='"+Date14+"' AND i.inv_id IN ("+products+")) "+
		  "ORDER BY 1";
		  
	return moAbcUtils.getJSResultSet(lsQuery);
    }

    String getProducts(String Filename)
    {
	String products="";
	try {
	    FileInputStream fstream = new FileInputStream(Filename);
	    DataInputStream in      = new DataInputStream(fstream);
	    BufferedReader br       = new BufferedReader(new InputStreamReader(in));
	    String strLine;
	    String newLine;
	    while ((strLine = br.readLine()) != null) {
		//System.out.println("line: "+strLine);
		newLine = ignoreComments (strLine);
		if (newLine != null) {
		    //System.out.println (newLine);
		    products = products + ",'"+newLine+"'";
		}
	    }
	    products = products.substring(1, products.length());
	} catch (Exception e) {
	    e.printStackTrace ();
	}

	return products;
    }

    String ignoreComments (String line) {
        String result_line = null;
	int upto = line.indexOf ('#');
	if (upto != 0 && upto > 0) {
	    result_line = line.substring (0, upto);
	} else if (upto < 0) {
	    result_line = line;
	}
	return result_line;
    }

    
    String getPercent(String Filename)
    {
        String percent="";
        try {
            FileInputStream fstream = new FileInputStream(Filename);
            DataInputStream in      = new DataInputStream(fstream);
            BufferedReader br       = new BufferedReader(new InputStreamReader(in));
            String strLine;
            String newLine;
            while ((strLine = br.readLine()) != null) {
                newLine = ignoreComments (strLine);
                if (newLine != null) {
                    percent = newLine;
                }
            }
        } catch (Exception e) {
            e.printStackTrace ();
        }

        return percent;
    }

    String getLastDateEqualRealTransactions(String msTrans)
    {
        /*
        String lsQuery = "SELECT to_date(EXTRACT(YEAR FROM date_id) || '-' "+ 
	                 "|| EXTRACT(MONTH FROM date_id) || '-' "+
			 "|| EXTRACT(DAY FROM date_id), 'YYYY-MM-dd') AS x "+
			 "FROM op_gt_real_sist_mng WHERE trans_real="+msTrans+" ORDER BY x DESC LIMIT 1";
        */

        String lsQuery = "SELECT to_date(EXTRACT(YEAR FROM date_id) || '-' "+
                         "|| EXTRACT(MONTH FROM date_id) || '-' "+
                         "|| EXTRACT(DAY FROM date_id), 'YYYY-MM-dd') AS x "+
                         "FROM op_gt_real_sist_mng "+
                         "WHERE trans_real="+msTrans+" "+
                         "OR (trans_real BETWEEN "+msTrans+"-10  AND "+msTrans+"+10) ORDER BY x DESC"; 
   
	String Result = moAbcUtils.queryToString(lsQuery);

	if(Result.equals("")) {
	    lsQuery = "SELECT to_date(EXTRACT(YEAR FROM date_id) || '-' "+
	              "|| EXTRACT(MONTH FROM date_id) || '-' "+
		      "|| EXTRACT(DAY FROM date_id), 'YYYY-MM-dd') AS x "+
		      "FROM op_gt_real_sist_mng "+
                      "WHERE trans_real BETWEEN " +msTrans+"-15 AND "+msTrans+"+15 ORDER BY x DESC"; 
            Result = moAbcUtils.queryToString(lsQuery);
	}

	return Result;
    }

    String getTransManager(String msDate)
    {
        String lsQuery = "SELECT trans_mng  from op_gt_real_sist_mng where date_id='"+msDate+"'";

	String yymmdd  = msDate.substring(2, 4)+msDate.substring(5,7)+msDate.substring(8,10);

	try {
	    Process p = Runtime.getRuntime().exec("/usr/bin/ph/databases/graphics/bin/carga_rsg.pl "+yymmdd);
            p.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }
	return moAbcUtils.queryToString(lsQuery);
    }

    String getTransReal(String msDate)
    {
        String lsQuery = "SELECT trans_real from op_gt_real_sist_mng where date_id='"+msDate+"'";

	String yymmdd  = msDate.substring(2, 4)+msDate.substring(5,7)+msDate.substring(8,10);

	try {
	    Process p = Runtime.getRuntime().exec("/usr/bin/ph/databases/graphics/bin/carga_rsg.pl "+yymmdd);
            p.waitFor();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException ie) {
            ie.printStackTrace();
        }
	return moAbcUtils.queryToString(lsQuery);
    }

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

    String getDate(String msWeek, String msYear, String msPeriod, String msDay, int days)
    {
        String lsQuery;

        String date;

	lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
	          "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
		  "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
		  "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
		  "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";

        date = moAbcUtils.queryToString(lsQuery);

        lsQuery = "SELECT date '"+date+"' - integer '"+days+"'";

	return moAbcUtils.queryToString(lsQuery);
    }


%>
