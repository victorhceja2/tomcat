<%--
##########################################################################################################
# Nombre Archivo  : RemoteMethodYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Implementacion de métodos usados por RemoteScripting JS
# Fecha Creacion  : 19/Ene/2005
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@ page import="generals.*" %>
<%@ page language="java" extends="generals.servlets.RemoteScripting" %>

<%!
    
    public void log(String msg){
		//DEBUG
      	//System.out.println("RemoteScripting:"+msg);
    }

    static public String getPeriods(String psYear)
    {
        String qry = "SELECT distinct(period_no) as id, lpad(period_no,2,'0') as name ";
              qry += "FROM ss_cat_time where year_no="+psYear;

        AbcUtils loAbcUtils = new AbcUtils();

        return loAbcUtils.getJSResultSet(qry);
    }

    static public String getWeeks(String psYear, String psPeriod)
    {
        String qry = "SELECT DISTINCT(week_no) FROM ss_cat_time ";
              qry += "WHERE period_no="+psPeriod+ " AND year_no=" + psYear;

        AbcUtils loAbcUtils = new AbcUtils();

        return loAbcUtils.getJSResultSet(qry);
    }
%>
