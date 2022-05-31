<%!
/*
 * Tablas postgres:
 * pp_empl_personal
 * pp_empl_labourdata
 * pp_empl_drvinfo
 */
private void writeMenu( javax.servlet.jsp.JspWriter out, ArrayList<String> dataForComb  ){
    try{
        if( dataForComb.size() > 0){
            for ( int i=0; i < dataForComb.size(); i++){
                out.println("<option value=\""+ dataForComb.get(i) +"\">"+ dataForComb.get(i) +"</option>");
            }
        }
    }catch(java.io.IOException e1){
        System.out.println(e1);
    }
}


private String getUserValid(String psUser, String psPassword){
    String lsReportId = moAbcUtils.queryToString("SELECT emp_num from pp_employees where emp_num = '" + psUser + "' and sus_pass = '" + psPassword + "'");
    return lsReportId;
}


private String[] fillEmplData( String noEmpl ){
    int EMPLDATA = 22;
    int EMPLSIZE = 23;
    String[] emplInfo = new String[EMPLSIZE];
    int i;
    for(i = 0; i < EMPLSIZE; i++){
        emplInfo[i] = "";
    }
    String tmpFile="/tmp/fillEmpl.asc";
    try{
        FileWriter tmpF = new FileWriter( tmpFile, false );
        PrintWriter pw = new PrintWriter(tmpF);
        pw.println( noEmpl );
        Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -F " + noEmpl.trim() );
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        String Text = "";
        while(( Text = stdInput.readLine()) != null ){
            ArrayList<String> fmsdata = tokenizeData( Text, "|" );
            pw.println( Text );
            
            if( fmsdata.size() >= EMPLDATA - 2 ){
                if( Text.charAt(0) == '|' ){
                    emplInfo[0] = " ";
                    for(i = 1; i < EMPLDATA - 1 ; i++){
                        emplInfo[i] = fmsdata.get(i-1).trim();
                    }
                }else{
                    for(i = 0; i < EMPLDATA - 1 ; i++){
                        emplInfo[i] = fmsdata.get(i).trim();
                    }
                }
                
                emplInfo[10] = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date ( Long.parseLong(emplInfo[10]) *1000));
                emplInfo[13] = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date ( Long.parseLong(emplInfo[13]) *1000));
                emplInfo[19] = emplInfo[19].trim();
                if( emplInfo[19].length() > 6 ){
                    emplInfo[19] = new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date ( Long.parseLong(emplInfo[19]) *1000));
                }else{
                    emplInfo[19] = "";
                }
                if( emplInfo[20].indexOf("\\") >= 0 ){
                    emplInfo[21] = emplInfo[20].substring( emplInfo[20].indexOf("\\") + 1);
                    
                }else{
                    emplInfo[21] = "0";
                }

		if( emplInfo[20].indexOf("\\") < 4 || !emplInfo[21].contains("003") ){
                    emplInfo[22] = "";
                }else{
                    emplInfo[22] = emplInfo[20].substring(2,4);
                }

                if( emplInfo[20].indexOf("\\") == 0 ){
                    emplInfo[20] = "";
                }else{
                    emplInfo[20] = emplInfo[20].substring(0,2);
                }
                
                for(i = 0; i < EMPLSIZE; i++){
                    pw.println( i +": \"" +emplInfo[i] + "\"" );
                }
            }
        }
        stdInput.close();
        tmpF.close(); //TODO: Quitar
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    
    return emplInfo;
}

private void addToEmplBD( ArrayList<String[]> empleados ){

    String psqlQuery;
    String[] empl;

    ArrayList<String> jobs = getDataFMS(0);
    psqlQuery = "DELETE FROM pp_empl_status";
    moAbcUtils.executeSQLCommand(psqlQuery);

    for(int x=0; x<empleados.size();x++) {
      empl = new String[empleados.get(x).length]; 
      empl = empleados.get(x);

      empl[5] = new java.text.SimpleDateFormat("yyyy/MM/dd").format(new java.util.Date ( Long.parseLong(empl[5]) *1000)); 

      for(int i=0; i<jobs.size();i++) {
	String[] parts = jobs.get(i).split(" ", 2);
	if ( empl[6].equals(parts[0]) ){
		empl[6] = parts[1];
	}
      }

      empl[7] = empl[7].substring(empl[7].indexOf("\\") + 1); // NIVSEG

      if ( !empl[7].equals("010") ) {
	psqlQuery = "INSERT into pp_empl_status(emp_num,rfc,nombre,ap_pat,ap_mat,fecha_efe,puesto,nivseg,emp_activo) values(?,?,?,?,?,?,?,?,'0')";
    	moAbcUtils.executeSQLCommand(psqlQuery,empl);

	psqlQuery = "UPDATE pp_empl_status set emp_activo='1' from ( select employee_id from ss_cat_emp_sorpi UNION select employee_id from ss_cat_emp_sarpi ) x where x.employee_id = pp_empl_status.emp_num";
    	moAbcUtils.executeSQLCommand(psqlQuery);

	psqlQuery = "UPDATE pp_empl_status x set ultimo_chk = xx.date_id from (select emp_num,max(date_id) as date_id from pp_emp_check group by emp_num) as xx where xx.emp_num= cast(x.emp_num as text)";
	moAbcUtils.executeSQLCommand(psqlQuery);
      }
    } 
}

private ArrayList<String> readEmplFMS( ){
    int EMPLSIZE = 2;
    ArrayList<String> emplInfo = new ArrayList<String>();
    
    try{
        Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -F");
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        String Text = "";
        while(( Text = stdInput.readLine()) != null ){
            ArrayList<String> fmsdata = tokenizeData( Text, "|" );
            if( fmsdata.size() > EMPLSIZE ){
                String tmpstr = fmsdata.get(0) + " " + fmsdata.get(1) + " " + fmsdata.get(2);
                emplInfo.add(tmpstr);
            }
        }
        stdInput.close();
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    return emplInfo;
}

private ArrayList<String[]> readAllEmplFMS( ){
    ArrayList<String[]> emplInfo = new ArrayList<String[]>();
    String [] fmsdata;
    String Text = "";

    try{
        Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -A");
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        while(( Text = stdInput.readLine()) != null ){
            ArrayList<String> data = tokenizeData( Text, "|" );
	    fmsdata = new String[data.size()];
	    fmsdata = data.toArray(fmsdata);
	    
            emplInfo.add(fmsdata);
        }
        stdInput.close();
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    return emplInfo;
}

/* Obtain several options */
private ArrayList<String> getDataFMS( int comboN ){
    String Text = "";
    boolean opt_start = false;
    ArrayList<String> options = new ArrayList<String>();
    int i = 0;
    String section = "";
    switch( comboN ){
               case 0:
                   section = "JOB";
                   break;
               case 1:
                   section = "SECURITY";
                   break;
               case 2:
                   section = "LDCODE";
                   break;
               case 3:
                   section = "DEPT";
                   break;
               default:
                   break;
    }
    
    try{
        FileReader Arch  = new FileReader("/usr/fms/data/choices.txt");
        BufferedReader br = new BufferedReader(Arch);
        while(( Text = br.readLine())!=null){
            if( Text.charAt(0) == '*' ){
                if( !opt_start ){
                    if( Text.substring(1).contains( section ) ){
                        opt_start = true;
                    }
                }else{
                    return options;
                }
            }else{
                if( opt_start ){
                    options.add(Text);
                }
            }
        }
        br.close();
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    return options;
}

private ArrayList<String> tokenizeData( String args, String delimitador ){
    ArrayList<String> Tokens = new ArrayList<String>();
    String s =  args.trim();
    StringTokenizer st = new StringTokenizer( s, delimitador );
    while( st.hasMoreTokens() ){
        Tokens.add( st.nextToken().trim() );
    }
    return Tokens;
}

private String[] searchEmplStoreCode( String noempl ){
    String psqlQuery = "";
    String[] data = new String[2];
    psqlQuery = "SELECT store_id from pp_employees where emp_num = '"+noempl+"'";
    data[0] = moAbcUtils.queryToString(psqlQuery);
    psqlQuery = "SELECT emp_code from pp_employees where emp_num = '"+noempl+"'";
    data[1] = moAbcUtils.queryToString(psqlQuery);
    return data;
}

private int searchEmplID_PSQL( String idempl ){
    String psqlQuery = "";
    String lsData;
    psqlQuery = "SELECT count(*) from pp_empl_personal where emp_id = '"+idempl+"'";
    lsData = moAbcUtils.queryToString(psqlQuery);
    if( Integer.parseInt(lsData) > 0 ){
        return -1;
    }
    return 0;
}

private String searchEmplID_FMSFile( String idempl, String noempl ){
    try{
        Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -I " + idempl.trim() );
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        String Text = "";
        while(( Text = stdInput.readLine()) != null ){
            ArrayList<String> fmsdata = tokenizeData( Text, "," );
            String noemplF = (fmsdata.get(0)).trim();
            if( (fmsdata.get(1).substring(0, 2)).equalsIgnoreCase(idempl) ) {
                if( ! noemplF.equalsIgnoreCase( noempl.trim() ) ){
                    stdInput.close();
                    return noemplF;
                }
            }
        }
        stdInput.close();
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    return "";
}

private boolean saveTmpDel( String empleados ){

	boolean val = true;	
	String emplds = empleados.replace('|',',');	
	java.util.Date currentDate = new Date();
	String date = new java.text.SimpleDateFormat("yyyy-MM-dd").format(currentDate);
	
	try{
	      String psqlQuery = "UPDATE pp_empl_status SET fecha_baja = '" + date + "',nivseg='010' WHERE emp_num IN (" + emplds + ")";
              moAbcUtils.executeSQLCommand(psqlQuery);
	
	}catch(Exception e ){
              e.printStackTrace();
	      val = false;
	}
		
        return val;
}

private boolean saveTmpFMS( HttpServletRequest poRequest ){
    boolean valret = true;
    String tmpFile="/tmp/newempldata.asc";
    String tmpFile3="/usr/bin/ph/emplalt/dat/newempldata";
    String psqlQuery = "";
    psqlQuery = "DELETE FROM tmp_empl_fms";
    moAbcUtils.executeSQLCommand(psqlQuery);
    
    String txtRFC = poRequest.getParameter("txtRFC").trim();
    String txtNoEmpl = poRequest.getParameter("txtNoEmpl").trim();
    String txtApPat = poRequest.getParameter("txtApPat").trim();
    String txtApMat = poRequest.getParameter("txtApMat").trim();
    String txtNombre = poRequest.getParameter("txtNombre").trim();
    String txtFechNac = poRequest.getParameter("txtFechNac").trim();
    String cmbSexo = (poRequest.getParameter("cmbSexo")!=null)?poRequest.getParameter("cmbSexo").trim():"";
    String txtCalle = (poRequest.getParameter("txtCalle")!=null)?poRequest.getParameter("txtCalle").trim():"";
    String txtNo = (poRequest.getParameter("txtNo")!=null)?poRequest.getParameter("txtNo").trim():"";
    String txtCP = (poRequest.getParameter("txtCP")!=null)?poRequest.getParameter("txtCP").trim():"";
    String txtTel = (poRequest.getParameter("txtTel")!=null)?poRequest.getParameter("txtTel").trim():"";
    String cmbTipEmpl = poRequest.getParameter("cmbTipEmpl").trim();
    String txtACC = (poRequest.getParameter("txtACC")!=null)?poRequest.getParameter("txtACC").trim():"";
    String txtID = (poRequest.getParameter("txtID")!=null)?poRequest.getParameter("txtID").trim():"";
    String txtCLAVE = (poRequest.getParameter("txtCLAVE")!=null)?poRequest.getParameter("txtCLAVE").trim():"";
    String txtDRV = (poRequest.getParameter("txtDRV")!=null)?poRequest.getParameter("txtDRV").trim():"";
    String txtFechEfec = poRequest.getParameter("txtFechEfec").trim();
    String cmbNivSeg = (poRequest.getParameter("cmbNivSeg")!=null)?poRequest.getParameter("cmbNivSeg").trim():"1 ";
    String cmbPuesto = poRequest.getParameter("cmbPuesto").trim();
    String txtNoLic = (poRequest.getParameter("txtNoLic")!=null)?poRequest.getParameter("txtNoLic").trim():"";
    String txtVencLic = (poRequest.getParameter("txtVencLic")!=null)?poRequest.getParameter("txtVencLic").trim():"";
    
    String epochNac = "504921600";
    String epochFEf = "1262304000";
    String epochLic = "0";
    
    try{
        epochNac = ""+(long)((new java.text.SimpleDateFormat ("dd/MM/yyyy HH:mm:ss").parse(txtFechNac.trim()+" 01:00:00 GMT")).getTime() / 1000);
        epochFEf = ""+(long)((new java.text.SimpleDateFormat ("dd/MM/yyyy HH:mm:ss").parse(txtFechEfec.trim()+" 01:00:00 GMT")).getTime() / 1000);   
        if( txtVencLic != null && txtVencLic != "" && txtVencLic != " " )
            epochLic = ""+(long)((new java.text.SimpleDateFormat ("dd/MM/yyyy HH:mm:ss").parse(txtVencLic.trim()+" 01:00:00 GMT")).getTime() / 1000);
        else
            epochLic = "0";
        String emplData = txtRFC + "," + txtACC + "," + txtDRV + "," + txtNo + "," + txtCalle + "," + txtCP + 
                "," + txtTel + "," + cmbSexo + "," + cmbTipEmpl.substring( 0, cmbTipEmpl.indexOf(" ")) + 
                "," + cmbTipEmpl.substring( cmbTipEmpl.indexOf(" ") + 1 ) + "," + txtNoLic + "," + epochLic + 
                "," + cmbPuesto.substring( 0, cmbPuesto.indexOf(" ")) + "," + "\\00"+cmbNivSeg.substring( 0, cmbNivSeg.indexOf(" ")) + 
                "," + txtNoEmpl + "," + txtID + "," + txtCLAVE;
        
        FileWriter tmpF = new FileWriter( tmpFile, false );
        PrintWriter pw = new PrintWriter(tmpF);
        pw.println( emplData );
        tmpF.close();
        
        emplData = txtRFC.trim() + "|" + txtNombre + "|" + txtApPat + "|" + txtApMat + "|" + epochNac + 
                "|" + txtNoEmpl + "|" + epochFEf + "|" + epochFEf + "|092|" + cmbPuesto.substring( 0, cmbPuesto.indexOf(" "))+
                "|" + cmbTipEmpl;

        tmpF = new FileWriter( tmpFile3, false );
        pw = new PrintWriter(tmpF);
        pw.println( emplData );
        tmpF.close();
        
        
        if( txtFechNac.length() == 10 )
            txtFechNac = txtFechNac.substring(6) + "-" + txtFechNac.substring(3,5) + "-" + txtFechNac.substring(0,2);

        if( txtFechEfec.length() == 10 )
            txtFechEfec = txtFechEfec.substring(6) + "-" + txtFechEfec.substring(3,5) + "-" + txtFechEfec.substring(0,2);

        if( txtVencLic.length() == 10 )
            txtVencLic = txtVencLic.substring(6) + "-" + txtVencLic.substring(3,5) + "-" + txtVencLic.substring(0,2) ;
        else
            txtVencLic = "1900-01-01";

        psqlQuery = "INSERT INTO tmp_empl_fms VALUES ( '" + txtNoEmpl + "', '" + txtRFC + "','"
                + txtNombre + "', '" +txtApPat + "','" + txtApMat + "','"+txtFechNac  + "','" + cmbSexo + "','" 
                + txtCalle + "','" + txtNo + "','" + txtCP + "', '" + txtTel + "','" 
                + txtFechEfec + "','"  + txtACC + "','" + txtID + "','" + txtDRV + "',"  
                + cmbTipEmpl.substring( 0, cmbTipEmpl.indexOf(" ")) + ",'" + cmbTipEmpl.substring( cmbTipEmpl.indexOf(" ") + 1 ) + "'," 
                + cmbNivSeg.substring( 0, cmbNivSeg.indexOf(" ")) + ", " + cmbPuesto.substring( 0, cmbPuesto.indexOf(" ")) + ",'" 
                + txtNoLic + "','" + txtVencLic  + "')";
        
        String tmpFile2="/tmp/sqlq_tmp_0.asc";
        FileWriter tmpF2 = new FileWriter( tmpFile2, false );
        PrintWriter pw2 = new PrintWriter(tmpF2);
        pw2.println( psqlQuery );
        tmpF2.close();
        
        moAbcUtils.executeSQLCommand(psqlQuery);
        
    }catch(Exception e ){
        e.printStackTrace();
        valret = false;
    }finally{
        return valret;
    }
}

private boolean saveChangesFromDB( String no_empl, String type ){
    boolean valret = true;
    String psqlQuery = "";
    String[] empStoreCode = searchEmplStoreCode(no_empl);
    psqlQuery = "SELECT emp_rfc FROM tmp_empl_fms WHERE emp_num = '"+no_empl+"'";
    String tmpstr = moAbcUtils.queryToString(psqlQuery);
    
    if( empStoreCode[0] == null || empStoreCode[1] == null )
        return false;
    
    if( type.equals("FMS") ){
        psqlQuery = "DELETE FROM pp_empl_personal WHERE store_id="+ empStoreCode[0] + " AND emp_code=" + empStoreCode[1];
        moAbcUtils.executeSQLCommand(psqlQuery);
        psqlQuery = "INSERT INTO pp_empl_personal SELECT e.store_id, e.emp_code, e.emp_num, t.emp_rfc, emp_id, emp_fechnac, "
                + "emp_sex, emp_drv, emp_phone, emp_street, emp_no_add, emp_zipcode from pp_employees e "
                + "join tmp_empl_fms t on (e.emp_num = t.emp_num)";
        moAbcUtils.executeSQLCommand(psqlQuery);

        psqlQuery = "DELETE FROM pp_empl_labourdata WHERE emp_rfc='"+ tmpstr + "'";
        moAbcUtils.executeSQLCommand(psqlQuery);
        psqlQuery = "INSERT INTO pp_empl_labourdata SELECT p.emp_rfc, t.emp_type_no, emp_type_desc, "
                + "emp_seclev, emp_pos, emp_effdate from pp_empl_personal p join tmp_empl_fms t "
                + "on (p.emp_rfc = t.emp_rfc)";
        moAbcUtils.executeSQLCommand(psqlQuery);

        psqlQuery = "SELECT emp_pos FROM tmp_empl_fms WHERE emp_num = '"+no_empl+"'";
        tmpstr = moAbcUtils.queryToString(psqlQuery);

        if ( tmpstr != null ){
            tmpstr = tmpstr.trim();
            if ( tmpstr.compareTo("57") == 0 ){
                psqlQuery = "INSERT INTO pp_empl_drvinfo SELECT p.emp_rfc, "
                        + "t.emp_nolicen, emp_licexp from pp_empl_personal p "
                        + "join tmp_empl_fms t on (p.emp_rfc = t.emp_rfc)";
                moAbcUtils.executeSQLCommand(psqlQuery);
            }
        }

        try{
            Process p = Runtime.getRuntime().exec("/usr/bin/ph/emplalt/bin/emplreg.s -u");
        }catch( IOException e ){
            e.printStackTrace();
            valret = false;
        }finally{
            return valret;
        }
    }
    if( type.equals("SUS") ){
        psqlQuery = "DELETE FROM pp_empl_sus WHERE store_id="+ empStoreCode[0] + " AND emp_code=" + empStoreCode[1];
        moAbcUtils.executeSQLCommand(psqlQuery);
        psqlQuery = "INSERT INTO pp_empl_sus SELECT e.store_id, e.emp_code, e.emp_num, t.emp_id, emp_perm_ped, "
                + "emp_perm_cob, emp_validcve, emp_seclev from pp_employees e "
                + "join tmp_empl_sus t on (e.emp_num = t.emp_num)";
        moAbcUtils.executeSQLCommand(psqlQuery);
        
        try{
            Process p = Runtime.getRuntime().exec("/usr/bin/ph/emplalt/bin/emplreg.s -s");
        }catch( IOException e ){
            e.printStackTrace();
            valret = false;
        }finally{
            return valret;
        }
    }
    return valret;
}

private boolean saveChangesFromDB( String empl_id ){

    String tmpFile="/tmp/dropempldata.asc";
    String delFile="/tmp/delEmplSUS.txt";
    String results[][];
    String emplData="";
    String emplds_sus="";

    String psqlQuery = "";
    psqlQuery = "SELECT emp_num,extract(epoch from fecha_baja),nivseg FROM pp_empl_status WHERE emp_activo=false and nivseg='010'";
    results = moAbcUtils.queryToMatrix(psqlQuery);

    for( int i=0; i<results.length; i++ ){
	for( int j=0; j<results[i].length; j++ ){
	    emplData += results[i][j] + "|";
	}
	emplData += "TV17\n"; //CODIGO random DE DESEMPLEO 
	if ( i < results.length-1 )
	    emplds_sus += results[i][0] + "|";
	else
	    emplds_sus += results[i][0];
    }
    System.out.println(emplData);

    try{
        FileWriter tmpF = new FileWriter( tmpFile, false );
        FileWriter tmpS = new FileWriter( delFile, false );
        PrintWriter pwF = new PrintWriter(tmpF);
        PrintWriter pwS = new PrintWriter(tmpS);
    	pwF.println( emplData );
    	pwS.println( emplds_sus );
    	tmpF.close(); 
    	tmpS.close(); 
    }catch( IOException e ){
	e.printStackTrace();
	return false;
    }

    try{
    	Process p = Runtime.getRuntime().exec("/usr/bin/ph/emplalt/bin/emplreg.s -d");
    	Process pS = Runtime.getRuntime().exec("/usr/bin/ph/emplalt/bin/emplreg.s -e");
	System.out.println( "SUS : " + emplds_sus );
	System.out.println( "Autorizo : " + empl_id );
    }catch( IOException e ){
        e.printStackTrace();
        return false;
    }

    psqlQuery = "INSERT INTO pp_empl_deleted " + 
			"SELECT emp_num,ap_pat,ap_mat,nombre,ultimo_chk,fecha_baja, '" + empl_id + "' as autorizado_por " +
			"FROM pp_empl_status " +
			"WHERE emp_activo=false AND nivseg='010'";
    moAbcUtils.executeSQLCommand(psqlQuery);

    psqlQuery = "UPDATE pp_employees SET security_level='10' " + 
			"WHERE emp_num IN (SELECT cast(emp_num AS text) " +
			"FROM pp_empl_status WHERE emp_activo=false AND nivseg='010')";
    moAbcUtils.executeSQLCommand(psqlQuery);

    return true;	
}

/*=======================================================================================*/

private String isInSUS( String no_empl ){
    String retval = "N";
    try{
        String cmd = "/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -S ";
        
        
        String tmpFile="/tmp/isinsus.asc";
        FileWriter tmpF = new FileWriter( tmpFile, false );
        PrintWriter pw = new PrintWriter(tmpF);
        
        pw.println( "cmd0: " + cmd );
        cmd = cmd + no_empl;
        pw.println( "noempl: "+ no_empl+"\ncmd1: "+cmd );
        
        
        Process p = Runtime.getRuntime().exec( cmd );
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
                
        String Text = "";
        while(( Text = stdInput.readLine()) != null ){
            pw.println( Text );
            retval = "Y";
        }
        
        pw.println( retval );
        tmpF.close();
        
        stdInput.close();
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }finally{
        return retval;
    }
}

private ArrayList<String> getDataSUS( int comboN ){
    ArrayList<String> emplInfo = new ArrayList<String>();
    String psqlQuery = "";
    
    try{
        Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -C");
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        String Text = "";
        while(( Text = stdInput.readLine()) != null ){
            ArrayList<String> susdata = tokenizeData( Text, "|" );
            emplInfo.add( susdata.get(0).substring(4,6) + " " + susdata.get(1) );
        }
        stdInput.close();
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    
    return emplInfo;
}

private String[] fillEmplDataSUS( String rfc ){
    int EMPLSIZE = 9;
    String[] emplInfo = new String[EMPLSIZE];
    int i;
    for(i = 0; i < EMPLSIZE; i++){
        emplInfo[i] = "";
    }
    String tmpFile="/tmp/fillEmplSUS.asc";
    try{
        FileWriter tmpF = new FileWriter( tmpFile, false );
        PrintWriter pw = new PrintWriter(tmpF);
        pw.println( rfc );
        Process p = Runtime.getRuntime().exec("/usr/local/tomcat/webapps/ROOT/Employees/Edit/Scripts/readEmplFields.s -S " + rfc.trim() );
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        String Text = "";
        while(( Text = stdInput.readLine()) != null ){
            ArrayList<String> fmsdata = tokenizeData( Text, "|" );
            pw.println( Text );
            
            if( fmsdata.size() >= EMPLSIZE - 2 ){
                for(i = 0; i < EMPLSIZE - 1; i++){
                    emplInfo[i] = fmsdata.get(i).trim();
                }
                emplInfo[EMPLSIZE - 1] = ""+emplInfo[4].charAt(2);
                emplInfo[4] = ""+emplInfo[4].charAt(0);
            }else{
                for(i = 0; i < EMPLSIZE; i++){
                    emplInfo[i] = "";
                }
            }
        }
        
        for(i = 0; i < EMPLSIZE; i++){
            pw.println( i +": \"" +emplInfo[i] + "\"" );
        }
        pw.println(emplInfo[4].indexOf("Y"));
        pw.println(emplInfo[8].indexOf("Y"));
        
        stdInput.close();
        tmpF.close(); //TODO: Quitar
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    
    return emplInfo;
}

private boolean saveTmpSUS( HttpServletRequest poRequest ){
    boolean valret = false;
    String tmpFile="/tmp/newempldataSUS.asc";
    
    String psqlQuery = "";
    psqlQuery = "DELETE FROM tmp_empl_sus";
    moAbcUtils.executeSQLCommand(psqlQuery);
    
    String txtNoEmpl = poRequest.getParameter("txtNoEmpl").trim();
    String txtID = "EMPL" + poRequest.getParameter("txtID").trim();
    String txtPwd = poRequest.getParameter("txtPwd1").trim();
    String txtNombreCompleto = poRequest.getParameter("txtNombreCompleto").trim();
    String cmbPermP = poRequest.getParameter("cmbPedidos").trim();
    String cmbPermC = poRequest.getParameter("cmbCobrar").trim();
    String cmbPerms =  cmbPermP + " " + cmbPermC;
    String txtTiempo = poRequest.getParameter("txtTiempo").trim();
    String cmbNivSeg = poRequest.getParameter("cmbSecLev").trim();
    
    try{
        String emplData = "A|    |" + String.format( "%-16s|%-12s", txtID, txtPwd) 
                + "|            |          |                    |" 
                + String.format( "%-25s|%-25s|%-8s|%-2s", txtNombreCompleto, txtNoEmpl, cmbPerms,txtTiempo)
                + "|10 |Y|Y|      |"+cmbNivSeg.substring(0, 2) + "|";
        
        FileWriter tmpF = new FileWriter( tmpFile, false );
        PrintWriter pw = new PrintWriter(tmpF);
        pw.println( emplData );
        tmpF.close();
        
        psqlQuery = "INSERT INTO tmp_empl_sus VALUES ( '" + txtNoEmpl + "', '" + txtID.substring(4) + "','"
                + txtNombreCompleto + "', '" +txtPwd + "','" + cmbPermP+ "','"+cmbPermC+ "'," + txtTiempo + "," 
                + Integer.parseInt( cmbNivSeg.substring( 0, cmbNivSeg.indexOf(" ") ) ) +")";
                
        
        /*String tmpFile2="/tmp/sqlq_tmp_0.asc";
        FileWriter tmpF2 = new FileWriter( tmpFile2, false );
        PrintWriter pw2 = new PrintWriter(tmpF2);
        pw2.println( psqlQuery );
        tmpF2.close();
        */
        moAbcUtils.executeSQLCommand(psqlQuery);
    }catch( IOException e ){
        e.printStackTrace();
        valret = false;
    }finally{
        return valret;
    }
}

private int addEmployeetoDB( String no_empl ){
	String tmpFile="/tmp/newempldata.asc";
	String fileName="newempldata"; 
	String no_empl_file=null;
	String line=null;
	ArrayList<String> employees=null;
	int del=0,begin=0,end=0,i;
	try{
		FileReader file = new FileReader(tmpFile);
        BufferedReader br = new BufferedReader(file);
        line=br.readLine();
        br.close();
        for(i=0;i<line.length()&&end==0;i++){
        	if(line.charAt(i)==',')
        		del++;
        	if(del==13)
        		begin=i+2;
        	else if(del==15)
        		end=i;
        }
        no_empl_file=line.substring(begin,end);
        if( !no_empl.equals(no_empl_file) )
        	return -1;
        
        employees=readEmplFMS();
        for(i=0;i<employees.size();i++){
        	if(employees.get(i).split(" ")[0].equals(no_empl)){
        		return 1;
        	}
        }
      
		Process p2 = Runtime.getRuntime().exec("/usr/bin/ph/emplalt/bin/emplalt.s " + fileName); 
	}catch( IOException e ){
		e.printStackTrace();
		return -1;
	}
	return 0;
}

private boolean franquicia(){
    try{
        Process p = Runtime.getRuntime().exec("/usr/bin/ph/unit.s");
        BufferedReader stdInput = new BufferedReader(new InputStreamReader( p.getInputStream()));
        int centroContribucion=Integer.parseInt(stdInput.readLine());
        if( centroContribucion >=1000 && centroContribucion <2000)
            return true;
    }catch( java.io.IOException ioe ){
        ioe.printStackTrace();
    }
    return false;
}
%>
