<%--
##########################################################################################################
# Nombre Archivo  : RemoteMethodYum.jsp
# Compa�a        : Yum Brands Intl
# Autor           : JAVM
# Objetivo        : Implementar m�odos usados por RemoteScripting JS
# Fecha Creacion  : 16/Mar/2016
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@page import="generals.*" %>
<%@ page language="java" extends="generals.servlets.RemoteScripting" %>

<%!
    static AbcUtils loAbcUtils = new AbcUtils();
    
    public void log(String msg){
		//DEBUG
      	//System.out.println("RemoteScripting:"+msg);
    }
    
    public static String validateCredentials(String psEmpl, String psPass){
	try{
	  String lsQry = "SELECT COUNT(emp_num) FROM pp_employees WHERE emp_num='"
			  + psEmpl.split(" ")[0] + "' AND sus_pass='" + psPass + "'";
	  String loResult = loAbcUtils.queryToString(lsQry,"","");
	  
	  if (Integer.parseInt(loResult) > 0){
	    return "TRUE";
	  }else{
	    return "FALSE";
	  }
	}catch(Exception e){
	  return "ERROR";
	}
    }
%>