<%!
static String executeCommand (String command) {
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

static ArrayList<String> executeCommand (String command, int x) {
    ArrayList<String> s = new ArrayList<String>();
    String line = null;

    try {
        Process p = Runtime.getRuntime().exec(command);

    	BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));

    	BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));

	while ((line = stdInput.readLine()) != null)
		s.add(line);
    	p.destroy();

    } catch (IOException e) {
        System.out.println("Error al ejecutar el comando: ");
	e.printStackTrace();
    }
    return s;
}

String getMiXdest(String mixDate, String dest){
    String lsQuery;
    String mix;
    lsQuery = "SELECT mix_percentage FROM op_mdw_trx_mix_frozen_data "
		+ "WHERE date_id='" + mixDate  + "' AND destination_id='" + dest + "'";
    mix = moAbcUtils.queryToString(lsQuery);
    return mix;
}

void setMiXdest(String mixDate, String mixHomeG, String mixAutoG, String mixDine, String mixCarry, String mixHomeS, String mixAutoS){
    String lsQuery;
    lsQuery = "select * from op_mdw_fn_insert_trx_forecast_mix('"+ mixDate +"',"+ mixHomeG +","+ mixAutoG +","+ mixDine
		+", "+ mixCarry +","+ mixHomeS +","+ mixAutoS +")";
    System.out.println("QUERY: "+ lsQuery);
    moAbcUtils.executeSQLCommand(lsQuery);
}

static void saveFile(StringBuffer sB, String fileName) {
    try {
        FileWriter fstream = new FileWriter(fileName);
        BufferedWriter out = new BufferedWriter(fstream);
        out.write(sB.toString());
        out.close();
    } catch (Exception e) {
        System.err.println("Error: " + e.getMessage());
    }
}
void updatePzTrxDB(String psPieces,String psDate){
    if(psPieces == null)psPieces="0.00";
    String lsQuery="";
    lsQuery+="UPDATE op_gt_real_sist_mng SET ppt_mng = "+psPieces+" WHERE CAST(date_id AS DATE) = '"+psDate+"'; ";
    System.out.println("QUERY: "+ lsQuery);
    moAbcUtils.executeSQLCommand(lsQuery);
}
void insertPzTrxDB(String psDate,String psPpt_real,String psPpt_sis,String psId_fcst_gte,String psCbzs_real,String psCbzs_sis,String piCbzs_gte){
    if(psPpt_real == null)psPpt_real="0.00"; 
    if(psPpt_sis == null)psPpt_sis="0.00"; 
    if(psId_fcst_gte == null)psId_fcst_gte="0.00"; 
    if(psCbzs_real == null)psCbzs_real="0.00"; 
    if(psCbzs_sis == null)psCbzs_sis="0.00"; 
    if(piCbzs_gte == null)piCbzs_gte="0.00"; 
    String lsQuery="";
    updatePzTrxDB(psId_fcst_gte,psDate);
    lsQuery+="INSERT INTO op_gt_real_sist_mng(date_id,ppt_real,ppt_sist,ppt_mng,trans_real,trans_sist,trans_mng) ";
    lsQuery+="SELECT '"+psDate+"',"+psPpt_real+","+psPpt_sis+","+psId_fcst_gte+","+psCbzs_real+","+psCbzs_sis+","+piCbzs_gte+" WHERE NOT EXISTS(SELECT * FROM op_gt_real_sist_mng WHERE CAST(date_id AS DATE) = '"+psDate+"');";
    System.out.println("QUERY: "+ lsQuery);
    moAbcUtils.executeSQLCommand(lsQuery);
}

static void log(String date, String pptGte_old, String pptGte_new) {
    String fileName="/usr/local/tomcat/webapps/ROOT/Utilities/PiecesAndTransactions/pzXtxr.log";
	
    Date fecha_actual=new Date(); 
    java.text.SimpleDateFormat hourdateFormat = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    if( !(pptGte_new.equals(pptGte_old)) ){
       try {
           FileWriter fstream = new FileWriter(fileName,true);
           BufferedWriter out = new BufferedWriter(fstream);
           out.write("" + date + "|" + pptGte_old + "|" + pptGte_new + "|" + hourdateFormat.format(fecha_actual)  +  "\n");
           out.close();
       } catch (Exception e) {
           System.err.println("Error: " + e.getMessage());
       }
    }
}

static void append2File(String S, String fileName) {
    try {
    	FileWriter fstream = new FileWriter(fileName, true);
	BufferedWriter bw= new BufferedWriter(fstream);
	bw.write(S);
	bw.newLine();
	bw.flush();
	bw.close();
    } catch (Exception e) {
    	System.err.println("Error: " + e.getMessage());
    }
}

static String getDateTime() {
    java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd");
    Date date = new Date();
    return dateFormat.format(date);
}

static double round(double val, int lugares) {
    long factor = (long) Math.pow(10, lugares);

    // Mover el decimal x no. de lugares a la derecha 
    val = val * factor;

    // Redondear al entero cercano
    long tmp = Math.round(val);

    return (double)tmp / factor;
}

static float round(float val, int lugares) {
    return (float)round((double)val, lugares);
}
   
    
%>
