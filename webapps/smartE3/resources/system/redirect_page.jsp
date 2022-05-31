<%@page contentType="text/html"%>
<%@page import="java.util.*" %>

<%
            //String msURL = "http://www.yummexico.net:" + msPort + "/eYum.jsp" + getURLParams(request);
            //String msURL = "http://www.yummexico.net/eYum.jsp";
            String msURL = "/ValidateLogonYum.jsp?txtUser=jxp7294&txtPassword=eyum";
            //String msURL = "http://192.168.101.120/eYum.jsp";
            response.sendRedirect(msURL);
%>

<%!
    
    String getURLParams(HttpServletRequest poRequest) {
            Enumeration  loParams = poRequest.getParameterNames();
            String lsURLParams = "";
            int liCounter = 0;
            while (loParams.hasMoreElements()) {
                String lsParamName = (String)loParams.nextElement();
                lsURLParams+=(liCounter==0)?"?":"&";
                lsURLParams+=lsParamName + "=" + poRequest.getParameter(lsParamName);
                liCounter++;
            }
            
            return lsURLParams;
    }

%>