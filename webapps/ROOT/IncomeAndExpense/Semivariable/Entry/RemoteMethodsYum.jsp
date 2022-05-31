<%--
##########################################################################################################
# Nombre Archivo  : RemoteMethodYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Implementar métodos usados por RemoteScripting JS
# Fecha Creacion  : 02/Junio/2005
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@page import="generals.*" %>
<%@ page language="java" extends="generals.servlets.RemoteScripting" %>

<%!
    
    public void log(String msg){
		//DEBUG
      	//System.out.println("RemoteScripting:"+msg);
    }

    static public String noteExists(String psNoteId, String psSuppId){
        AbcUtils loAbcUtils = new AbcUtils();
        String lsNoteId = "NA";
        
        try{
            //lsNoteId = loAbcUtils.queryToString("SELECT note_id FROM op_gsv_note WHERE note_id='"+psNoteId.trim()+"' AND date_part('year',cap_date)=current_year() AND supp_id='"+psSuppId+"'", "", "");
	    //Para poder repetir el num de factura 
	    //antes no se podia repetir el numero de factura a lo largo de un anio
	    // Decian que esto ocasionaba soportes
	    // 01 Sep 09
	    // Sergio Cuellar
            lsNoteId = loAbcUtils.queryToString("SELECT note_id FROM op_gsv_note WHERE note_id='"+psNoteId.trim()+"' AND cap_date=current_date AND supp_id='"+psSuppId+"'", "", "");
            if(lsNoteId.length() > 0)
                return "TRUE";
            else
                return "FALSE";    

        }catch(Exception e){
            return "ERROR";
        }
        
    }
%>
