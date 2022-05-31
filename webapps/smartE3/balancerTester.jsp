<%--
##########################################################################################################
# Nombre Archivo  : balancerTester.jsp
# Compañia        : Premium Restaurant Brands
# Autor           : JPG
# Objetivo        : Tester del balanceador de cargas para el eYum V3
# Fecha Creacion  : 30/Ago/2012
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="javax.naming.*"%>
<%@page import="java.util.*" %>
<%@page import="yum.e3.server.generals.*" %>

<%
        Context loContext = new InitialContext();
        String msURLtext = (String)loContext.lookup("java:comp/env/balancerRedirectURL");
        String msStorePorts = (String)loContext.lookup("java:comp/env/balancerStorePorts");
        String msOfficePorts = (String)loContext.lookup("java:comp/env/balancerOfficePorts");
        String msClientIp=request.getRemoteAddr();

        out.println("Balance to URL: " + msURLtext + "<br>");
        out.println("Store Ports: " + msStorePorts + "<br>");
        out.println("Office Ports: " + msOfficePorts + "<br>");
        out.println("Client IP: " + msClientIp + "<br>");
%>