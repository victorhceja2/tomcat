<%!

    String calculateStartDate(int numDays)
    {
        String lsQuery;

        lsQuery = "SELECT to_char(current_date - interval '"+numDays+" days', 'YYYY-MM-DD')";

        return moAbcUtils.queryToString(lsQuery);
    }

	String calculateSelectedDate(String psYear, String psPeriod, String psWeek, String psDay)
	{

        String lsQuery;
		
		lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+psYear+" AND period_no="+psPeriod+" AND "+
                  "week_no="+psWeek+" AND EXTRACT(day FROM date_id) = " + psDay; 
                    
        return moAbcUtils.queryToString(lsQuery);
	}

    boolean generateReport(String start, String end)
    {
        try
        {
            String laCommand[] = {"/usr/bin/ph/databases/tendencies/bin/gen_tx_report.s", start, end};
            Process process = Runtime.getRuntime().exec(laCommand); 
            process.waitFor();

            return true;
        }
        catch(Exception e)
        {
            System.out.println("Error: " + e.toString());
            return false;
        }
    }

    String getDataset()
    {
        String dataset = "var gaDataset = new Array(); \n";
        try
        {
            String line = ""; 
            String data = ""; 
            String file   = "/usr/bin/ph/databases/tendencies/dat/report.txt";

            BufferedReader reader = new BufferedReader(new FileReader(file));

            while((line = reader.readLine()) != null)
            {
                line = line.replaceAll(",", "</pre>','<pre>");
                data = "new Array('<pre>" + line + "</pre>');";

                data = "gaDataset[gaDataset.length] = " + data + "\n"; 
                dataset += data;
            }

            reader.close();                
        }
        catch(Exception e)
        {
            System.out.println("Exception e: " + e);
        }

        return dataset;
    }

    void resetReport()
    {
        try
        {
            File file = new File("/usr/bin/ph/databases/tendencies/dat/report.txt");
            if(file.exists())
            {
                file.delete();
                file.createNewFile(); 
            }
        }
        catch(Exception e)
        {
            System.out.println("Exception e: " + e.toString());
        }
    }

%>
