<%--
##########################################################################################################
# Nombre Archivo  : RemoteMethodYum.jsp
# Compa�a        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Implementar m�odos usados por RemoteScripting JS
# Fecha Creacion  : 19/Ene/2005
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@page import="generals.*" %>
<%@ page language="java" extends="generals.servlets.RemoteScripting" %>

<%!
    
    public void log(String msg){
		//DEBUG
      	//System.out.println("RemoteScripting:"+msg);
    }
    
    static public String validateCredentialsAndDocument(String psDocNum, String psStepRecep, String psEmpl, String psPass){
	AbcUtils loAbcUtils = new AbcUtils();
        String lsDocNum = "NA";
        String lsCredentials = "";
        String result = "ERROR";
        
        try{
        
	    String lsQryEmpl="SELECT COUNT(emp_num) FROM pp_employees WHERE emp_num='"
			    + psEmpl.split(" ")[0] + "' AND sus_pass='" + psPass + "'";
			    
	    lsCredentials = loAbcUtils.queryToString(lsQryEmpl,"","");
	    
	    if(Integer.parseInt(lsCredentials) > 0){
		lsCredentials = "TRUE";
	    }else{
		lsCredentials = "FALSE";
	    }
	    
	    String lsQry = "SELECT document_num FROM op_grl_reception WHERE " +
			    "document_num='"+psDocNum.trim()+"' AND " +
			    "provider_id IN(SELECT DISTINCT(provider_id) FROM op_grl_step_reception " +
			    "WHERE reception_id = " +psStepRecep.trim() + ") LIMIT 1";

            lsDocNum = loAbcUtils.queryToString(lsQry, "", "");

            if(lsDocNum.length() > 0)
                lsDocNum = "TRUE";
            else
                lsDocNum = "FALSE";    

            
            
            if (lsCredentials.equals("FALSE")){
		return "ErrCred";
            }
            
            if (lsDocNum.equals("TRUE")){
		return "DocExists";
            }
            
            return "TRUE";
        }catch(Exception e){
            return "ERROR";
        }
    }

    static public String documentExists(String psDocNum, String psStepRecep){
        AbcUtils loAbcUtils = new AbcUtils();
        String lsDocNum = "NA";
        
        //DEBUG
        //System.out.println("NUM=" + psDocNum);

        try{
			String lsQry = "SELECT document_num FROM op_grl_reception WHERE " +
						   "document_num='"+psDocNum.trim()+"' AND " +
						   "provider_id IN(SELECT DISTINCT(provider_id) FROM op_grl_step_reception " +
						   "WHERE reception_id = " +psStepRecep.trim() + ") LIMIT 1";

            lsDocNum = loAbcUtils.queryToString(lsQry, "", "");

            if(lsDocNum.length() > 0)
                return "TRUE";
            else
                return "FALSE";    

        }catch(Exception e){
            return "ERROR";
        }
        
    }

	//static public String getLastNumDoc(String psDocNum, String psStepRecep){
	static public String getLastNumDoc(){
		AbcUtils loAbcUtils = new AbcUtils();
        	String lsDocNum = "NA";
		try{
			String lsQry = "select document_num from op_grl_reception where provider_id='PFS' order by reception_id desc limit 1";
			lsDocNum = loAbcUtils.queryToString(lsQry, "", "");
			if(lsDocNum.length() > 0){
				return lsDocNum;
			}else{
				return "NEW";
			}
		}catch(Exception e){
			return "ERROR";
		}
	}
%>
