
<%!
    String getCCMovils()
    {
        String query;

        query = "SELECT SUBSTRING(trans_desc,7,9) FROM (SELECT * FROM gc_trans_codes WHERE trans_desc LIKE '%Uber-Eats%' OR trans_desc LIKE '%Rappi%' OR trans_desc LIKE '%Sin-Delan%' OR trans_desc LIKE '%DiDi%' OR trans_desc LIKE '%Bringg%' ) a WHERE a.trans_type = 'PAGO'";
        //query = "SELECT SUBSTRING(trans_desc,16,4) FROM (SELECT * FROM gc_trans_codes WHERE trans_desc LIKE '%Uber%' OR trans_desc LIKE '%Rappi%' OR trans_desc LIKE '%DiDi%' OR trans_desc LIKE '%Bringg%' ) a WHERE a.trans_type = 'GASTO' and trans_desc like '%Deposito%'";

        return query;
    }

    void checkFailedStatus()
    {
        String lsSqlQuery = "";
        String lsResult   = "";
        String storeid    = "";

        lsSqlQuery = "SELECT store_id FROM ss_cat_store";
        storeid    = moAbcUtils.queryToString(lsSqlQuery);
        storeid    = storeid.trim();

        lsSqlQuery = "SELECT count(*) FROM tmp_mov_sales WHERE termFailed = 1";
        lsResult = moAbcUtils.queryToString(lsSqlQuery);
        lsResult = lsResult.trim();

        if(!lsResult.equals("0")) {
            try {
                Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Scripts/send_failed_movil_mail.s "+storeid);
            } catch (IOException e) {
            }
        }
    }

    void sendMail(float dif, String bdate, String sus_id, String storeid)
    {
        try {
            Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Scripts/send_movil_mail.s "+dif+" "+bdate+" "+sus_id+" "+storeid);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    String getBusinessDate()
    {
        String s = "";
        String output = "";

        try {
            Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Scripts/phpqdate.s");
            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

            while ((s = stdInput.readLine()) != null) {
                output = output + s;
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
        //output = "190530";
        return output;
    }

    String getMovilSalesTotalSUS()
    {
        String s = "";
        String output = "";

        try {
            Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Scripts/MovilSales_p014.s 2>/dev/null");

            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
            BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

            while ((s = stdInput.readLine()) != null) {
                output = output + s;
            }

        } catch (IOException e){
            e.printStackTrace();
        }

        System.out.println("getMovilSalesTotalSUS:"+output);
        return output;
    }

    String getMovilSalesTotalSUSDetail(String psConcep)
    {
        String s = "";
        String output = "";

        try {
            Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Scripts/MovilSales_p014.s "+psConcep+" 2>/dev/null");

            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
            BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

            while ((s = stdInput.readLine()) != null) {
                output = output + s;
            }

        } catch (IOException e){
            e.printStackTrace();
        }

        return output;
    }

    String getUserValid(String psUser, String psPassword)
    {
        String lsReportId = moAbcUtils.queryToString("SELECT emp_num from pp_employees where emp_num = '" + psUser + "' and sus_pass = '" + psPassword + "'");
        return lsReportId;
    }

    void resetTempTable() {
        String lsSqlQuery = "";
        String lsResult   = "";

        lsSqlQuery += "SELECT count(*) FROM pg_class WHERE relname = 'tmp_mov_sales'";
        lsResult = moAbcUtils.queryToString(lsSqlQuery);

        if(lsResult.equals("1")) {
            lsSqlQuery = "";
            lsSqlQuery += "DROP TABLE tmp_mov_sales";
            moAbcUtils.executeSQLCommand(lsSqlQuery);
            lsSqlQuery = "";
            lsSqlQuery += "DELETE FROM pg_class WHERE relname = 'tmp_mov_sales'";
            moAbcUtils.executeSQLCommand(lsSqlQuery);
        }
    }

    void createTempTable() {
        String lsSqlQuery = "";
        String lsResult   = "";

        resetTempTable();

        lsSqlQuery += "SELECT count(*) FROM pg_class WHERE relname = 'tmp_mov_sales'";

        lsResult = moAbcUtils.queryToString(lsSqlQuery);

        if(lsResult.equals("0")) {
            lsSqlQuery = "";

            lsSqlQuery += "CREATE TABLE tmp_mov_sales ( ";
            lsSqlQuery += "terminal_id integer PRIMARY KEY, ";
            lsSqlQuery += "monto character(10), ";
            lsSqlQuery += "fecha character(10), ";
            lsSqlQuery += "hora  character(10), ";
            lsSqlQuery += "trans character(10), ";
            lsSqlQuery += "fechanegocio character(10), ";
            lsSqlQuery += "totalSUS character(10), ";
            lsSqlQuery += "totalCC character(10), ";
            lsSqlQuery += "cancel character(10), ";
            lsSqlQuery += "termFailed integer)";

            moAbcUtils.executeSQLCommand(lsSqlQuery);

            //System.out.println("**Se crea la tabla temporal tmp_mov_sales**");
        }
    }

    String getCodeConcept(String psDesc)
    {
        String lsDesc = psDesc.substring(0,4);
        System.out.println("lsDesc:"+lsDesc);
        String lsQry = "SELECT trans_code FROM gc_trans_codes WHERE trans_type = 'GASTO' AND trans_code > 200 AND trans_desc LIKE '%"+lsDesc+"%'";
        return moAbcUtils.queryToString(lsQry);
    }

    String getDescConcept(String psCode)
    {
        String lsQry = "SELECT SUBSTRING(trans_desc,16,8) FROM gc_trans_codes WHERE trans_code = "+psCode+"";
        return moAbcUtils.queryToString(lsQry);
    }

    void SaveAsciiFile(String user_id) {
        String totalSUS = ""; 
        String totalCC  = ""; 
        String lsSqlQuery = "";
        String bdate = "";
        String bdate_ = "";
        String storeid = "";
        String movil_id = "";
        String movil_date ="";
        String movil_hour="";
        String movil_trans="";
        String movil_money="";
        String movil_date_format="";
        String movil_failed="";
        String sus_id = "";
        String movil_real = "";
        String laResult[][];
        String lsCancCaptured = "";

        lsSqlQuery = "SELECT to_char(timestamp 'now','YYYY-MM-DD HH24:MI:SS')";
        String date_timestamp = moAbcUtils.queryToString(lsSqlQuery);
System.out.println("date_timestamp["+date_timestamp+"]");
        //Calendar now = Calendar.getInstance();
        //String date_timestamp = now.get(Calendar.DATE)+"-"+ (now.get(Calendar.MONTH) + 1)+ "-"+ now.get(Calendar.YEAR)+ " "+ now.get(Calendar.HOUR_OF_DAY) + ":"+ now.get(Calendar.MINUTE)+ ":"+ now.get(Calendar.SECOND);

        lsSqlQuery = "SELECT COUNT(*) FROM (SELECT * FROM gc_trans_codes WHERE trans_desc LIKE '%Uber-Eats%' OR trans_desc LIKE '%Rappi%' OR trans_desc LIKE '%Sin-Delan%' OR trans_desc LIKE '%DiDi%' OR trans_desc LIKE '%Bringg%' ) a WHERE a.trans_type = 'PAGO'";
        String num_movils = moAbcUtils.queryToString(lsSqlQuery);

        lsSqlQuery = "SELECT store_id FROM ss_cat_store";
        storeid    = moAbcUtils.queryToString(lsSqlQuery);
        //System.out.println("SA - storeid: "+storeid);
        
        lsSqlQuery = "SELECT sus_id FROM pp_employees WHERE emp_num='"+user_id+"'";
        sus_id     = moAbcUtils.queryToString(lsSqlQuery).trim();

        bdate = getBusinessDate();
        bdate_= bdate.substring(0,2)+"-"+bdate.substring(2,4)+"-"+bdate.substring(4,6);
        //bdate_= bdate.substring(4,6)+"-"+bdate.substring(2,4)+"-"+bdate.substring(0,2);
        //System.out.println("SA - bdate_: "+bdate_);

        lsSqlQuery = "SELECT totalCC FROM tmp_mov_sales LIMIT 1";
         totalCC    = moAbcUtils.queryToString(lsSqlQuery).substring(1);        
        //totalCC    = totalCC.substring(1);

        float ftotalCC  = 0.0f;
        ftotalCC  = Float.valueOf(totalCC).floatValue();
        //System.out.println("SA - totalCC: "+totalCC);

        lsSqlQuery = "SELECT totalSUS FROM tmp_mov_sales LIMIT 1";
         totalSUS   = moAbcUtils.queryToString(lsSqlQuery);        
        totalSUS   = totalSUS.substring(1);

        float ftotalSUS  = 0.0f;
        ftotalSUS  = Float.valueOf(totalSUS).floatValue();
        //System.out.println("SA - totalSUS: "+totalSUS);

        float difmontos = 0.0f;
        difmontos = ftotalSUS - ftotalCC;
        difmontos = Math.round(difmontos*100.0f) / 100.0f; 

        if(Math.abs(difmontos) >= 0.5f) {
            sendMail(difmontos, bdate_, sus_id, storeid);
        }

        String filename = "/usr/fms/op/rpts/movilsales/"+bdate_+".txt";

        try {
            FileWriter fstream = new FileWriter(filename);
            BufferedWriter out = new BufferedWriter(fstream);
            laResult = moAbcUtils.queryToMatrix("SELECT terminal_id,fecha,hora,monto,trans,termfailed,cancel FROM tmp_mov_sales");
            for (int rowId = 0; rowId < laResult.length; rowId++) {
                movil_id     = laResult[rowId][0].trim();
                movil_date   = laResult[rowId][1].trim();
                String tmp[] = movil_date.split("/"); 
                movil_date_format = tmp[2].substring(2,4)+"-"+tmp[1]+"-"+tmp[0]; 
                movil_hour   = laResult[rowId][2].trim();
                movil_money  = laResult[rowId][3].trim();
                movil_trans  = laResult[rowId][4].trim();
                movil_failed = laResult[rowId][5].trim();
                movil_real   = getMovilSalesTotalSUSDetail(movil_id);
                lsCancCaptured=laResult[rowId][6].trim();
                out.write(storeid.trim()+"|"+movil_id.trim()+"|"+bdate_.trim()+"|"+movil_date_format+"|"+movil_hour.trim()+"|"+movil_money.trim()+"|"+ftotalSUS+"|"+ftotalCC+"|"+difmontos+"|"+movil_trans.trim()+"|"+sus_id+"|"+date_timestamp.trim()+"|"+movil_failed+"|"+movil_real+"|"+lsCancCaptured);
                out.write("\n");
            }
            out.close();

         
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }
        //System.out.println("difmontos: "+difmontos);

/*        String filename = "/usr/fms/op/rpts/movilsales/"+bdate_+".txt";
        try {
            FileWriter fstream = new FileWriter(filename);
            BufferedWriter out = new BufferedWriter(fstream);
            for(int i=0; i < Integer.parseInt(num_terminals.trim()); i++) {
                terminal_id = Integer.toString(i+1);
                terminal_date = moAbcUtils.queryToString("SELECT fecha FROM tmp_mov_sales WHERE terminal_id='"+terminal_id+"'");
                terminal_date.trim();
                String tmp[] = terminal_date.split("/"); 
                terminal_date_format = tmp[2].substring(2,4)+"-"+tmp[1]+"-"+tmp[0]; 
                terminal_hour = moAbcUtils.queryToString("SELECT hora  FROM tmp_mov_sales WHERE terminal_id='"+terminal_id+"'");
                terminal_money= moAbcUtils.queryToString("SELECT monto FROM tmp_mov_sales WHERE terminal_id='"+terminal_id+"'");
                terminal_trans= moAbcUtils.queryToString("SELECT trans FROM tmp_mov_sales WHERE terminal_id='"+terminal_id+"'");
                terminal_failed = moAbcUtils.queryToString("SELECT termFailed FROM tmp_mov_sales WHERE terminal_id='"+terminal_id+"'");
                out.write(storeid.trim()+"|"+terminal_id.trim()+"|"+bdate_.trim()+"|"+terminal_date_format+"|"+terminal_hour.trim()+"|"+terminal_money.trim()+"|"+ftotalSUS+"|"+ftotalCC+"|"+difmontos+"|"+terminal_trans.trim()+"|"+sus_id+"|"+date_timestamp.trim()+"|"+terminal_failed);
                out.write("\n");
            }
            out.close();

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
        }

        try {
            String command = "/usr/bin/ph/chkccard_kill_cron.s";
            Runtime rt     = Runtime.getRuntime();
            Process proc   = rt.exec(command);
        }
        catch(Exception e) {
            e.printStackTrace();
        }*/
    }         

    int countNumberLines(String datafile) {
        int count = 0;
        try {
            File file = new File(datafile);
            FileReader fr = new FileReader(file);
            LineNumberReader ln = new LineNumberReader(fr);
           
            while (ln.readLine() != null) {
                count++;
            }
            ln.close();
           
        } catch(IOException e) {
            e.printStackTrace();
        }

        return count;
    }

    String[][] readCCFile(String bdate_) {

        String strLine;
            
        String CC         = "";
        String terminal   = "";
        String bdate      = "";
        String input_date = "";
        String input_hour = "";
        String input_trans= "";
        String input_money= "";
        String total_SUS  = "";
        String total_CCard= "";
        String diff       = "";
        String user       = "";
        String timestamp  = "";
        String terminal_failed = "";
        String difference      = "";
        String lsCancCaptured  = "";
        int number_lines = countNumberLines("/usr/fms/op/rpts/movilsales/"+bdate_+".txt");

        String[][] resultset;
        resultset = new String[number_lines][7];

        int i = 0;
        
        try {
        FileInputStream fstream = new FileInputStream("/usr/fms/op/rpts/movilsales/"+bdate_+".txt");
        File            file    = new File("/usr/fms/op/rpts/movilsales/"+bdate_+".txt");
        DataInputStream in      = new DataInputStream(fstream);
        BufferedReader  br      = new BufferedReader(new InputStreamReader(in));

        if (file.exists()) {
            while ((strLine = br.readLine()) != null) {

                StringTokenizer tokenizer = new StringTokenizer(strLine, "|");

                CC         = tokenizer.nextToken();
                terminal   = tokenizer.nextToken();
                bdate      = tokenizer.nextToken();
                input_date = tokenizer.nextToken();
                input_hour = tokenizer.nextToken();
                input_money= tokenizer.nextToken();
                total_SUS  = tokenizer.nextToken();
                total_CCard= tokenizer.nextToken();
                diff       = tokenizer.nextToken();
                input_trans= tokenizer.nextToken();
                user       = tokenizer.nextToken();
                timestamp  = tokenizer.nextToken();
                terminal_failed = tokenizer.nextToken();
                difference      = tokenizer.nextToken();
                lsCancCaptured  = tokenizer.nextToken();

                //System.out.println("Terminal: " + terminal+ " Monto: " + input_money + " Fecha: "+input_date+" Hora: "+input_hour);

                resultset[i][0] = getDescConcept(terminal);
                resultset[i][1] = input_money;
                resultset[i][2] = input_date;
                resultset[i][3] = input_hour;
                resultset[i][4] = input_trans;
                resultset[i][5] = lsCancCaptured;
                resultset[i][6] = terminal_failed;

                i++;
            }
            //System.out.println("Total CCard: "+total_CCard+" Total SUS: "+total_SUS);
        }
        in.close();

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
        return resultset;

    }


%>
