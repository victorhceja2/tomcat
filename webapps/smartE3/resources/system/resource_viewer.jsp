<%-- 
    Document   : resource_viewer
    Created on : 10/08/2017, 06:48:14 PM
    Author     : DAB1379
--%>
<%@page import="yum.e3.client.generals.utils.DataUtils"%>
<%
  String psUIID = DataUtils.getValidValue(request.getParameter("psUUID"), "");
  String psType = DataUtils.getValidValue(request.getParameter("psAppType"), "");
%>
    
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Resource Viewer</title>
    </head>
    <body>
        <embed id="embDoc" src="/smartE3/resources/pdf/<%=psUIID%>" width="100%" height="100%" type='<%=psType%>'>
    </body>
    <script>
        document.getElementById("embDoc").height=window.innerHeight*0.95;
    </script>
</html>
