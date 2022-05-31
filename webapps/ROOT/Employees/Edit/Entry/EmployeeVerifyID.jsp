<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%-- 
    Document   : EmployeeVerifyID
    Created on : 20/12/2012, 01:01:02 PM
    Author     : emejia
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>

<%@ include file="../Proc/EmployeeLib.jsp" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%! 
    AbcUtils moAbcUtils = new AbcUtils();
    String emplID = "";
    String noempl = "";
    String retVal = "";
%>

<%
    try{
        emplID = request.getParameter("txtID");
        noempl = request.getParameter("txtRFC");
        if( emplID.length() > 0 ){
            retVal = searchEmplID_FMSFile( emplID, noempl );
        }
    }catch(Exception e){
    }
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <% if( retVal.equals("") ) { %>
            <jsp:forward page="EmployeePasswd.jsp"/>
        <% } else { %>
        <script type="text/javascript">
            alert('La clave <%=emplID%> esta siendo ocupada por <%=retVal%>');
            history.back();
        </script>
        <% } %>
    </body>
</html>
