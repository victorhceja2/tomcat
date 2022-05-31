<%@page import="java.util.LinkedHashMap"%>
<%@page import="yum.e3.server.generals.utils.RESTWSClient"%>
<%@page import="yum.e3.server.generals.AppServerHandler"%>
<%@page import="yum.e3.server.generals.utils.DataUtils"%>
<%@page import="yum.e3.server.generals.DBAccess"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%
    String msHTML = DataUtils.getValidValue(request.getParameter("psExcelData"),"");
    String msQuery = DataUtils.getValidValue(request.getParameter("psQuery"),"");
    String msConn = DataUtils.getValidValue(request.getParameter("psConn"),"jdbc/EYUMV2");
    AppServerHandler moAppServerHandler = AppServerHandler.getInstance();
    //moAppServerHandler.initAppHandler();
    String msIsStore = moAppServerHandler.getIsStore();
    if(!msQuery.equals("")){
        if(msQuery.toUpperCase().contains("DELETE") || msQuery.toUpperCase().contains("UPDATE") || msQuery.toUpperCase().contains("TRUNCATE")){
            msHTML="<html><body><h1>La consulta contiene sentencias inválidas</h1></body></html>";
        }
         if(msIsStore.equals("true")){
            RESTWSClient loRWSC = new RESTWSClient();
            LinkedHashMap<String,String> loParams = new  LinkedHashMap<String,String>();
            loParams.put("psService","executeRemoteQuery");
            loParams.put("psConnectionPool",msConn);
            String lsQry = msQuery;
            loParams.put("psQuery",lsQry);
            String lsUrl = DataUtils.getValidValue(AppServerHandler.getInstance().getConfigData().getConfiguration("appParam_remoteIntranetQueryService"),"");
            msHTML = loRWSC.sendHttpRequest("POST",lsUrl,loParams,"").trim();
        } else {
            DBAccess loDBAccess = new DBAccess(msConn);
            msHTML = DataUtils.getValidValue(loDBAccess.queryToString(msQuery),""); 
        }
    }
    
    String lsFileName = "";
    msHTML = msHTML.replaceAll("'", "''");
    if(msIsStore.equals("true")){
        RESTWSClient loRWSC = new RESTWSClient();
        LinkedHashMap<String,String> loParams = new  LinkedHashMap<String,String>();
        loParams.put("psService","executeRemoteQuery");
        loParams.put("psConnectionPool","jdbc/EYUMV2");
        String lsQry = "EXEC [ss_grl_gen_pdf_file] '"+msHTML+"'";
        loParams.put("psQuery",lsQry);
        String lsUrl = DataUtils.getValidValue(AppServerHandler.getInstance().getConfigData().getConfiguration("appParam_remoteIntranetQueryService"),"");
        lsFileName = loRWSC.sendHttpRequest("POST",lsUrl,loParams,"").trim();
    } else {
        DBAccess loDBAccess = new DBAccess("jdbc/EYUMV2");
        lsFileName = DataUtils.getValidValue(loDBAccess.queryToString("EXEC [ss_grl_gen_pdf_file] '"+msHTML+"'"),""); 
    }
    
    System.out.println("File Name: " + lsFileName);
    
    try{
         response.setContentType("application/pdf");
         response.setHeader("Content-Disposition", "attachment;filename=pdf_detail.pdf");
          File loFile = new File(lsFileName);
          FileInputStream loFileIn = new FileInputStream(loFile);
          ServletOutputStream loOut = response.getOutputStream();

          byte[] outputByte = new byte[4096];
          //copy binary contect to output stream
          while(loFileIn.read(outputByte, 0, 4096) != -1)
          {
                  loOut.write(outputByte, 0, 4096);
          }
          loFileIn.close();
          loOut.flush();
          loOut.close();
     }catch(Exception poEx){
         System.out.println("Ocurrió un error en la generación del PDF: " + poEx.getMessage());
         poEx.printStackTrace();
     }

%>