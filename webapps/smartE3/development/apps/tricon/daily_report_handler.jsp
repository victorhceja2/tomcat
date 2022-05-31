<%-- 
    Document   : daily_report_handler
    Created on : 9/09/2014, 04:09:43 PM
    Author     : DAB1379
--%>
<%
String msPath = request.getParameter("psPath");
String msReport = request.getParameter("psReport");
String msType = request.getParameter("psType");
String msDate = request.getParameter("psDate");
//System.out.println(msPath+"|"+msReport+"|"+msType+"|"+msDate);
%>
<!--
To change this template, choose Tools | Templates
and open the template in the editor.
-->
<!DOCTYPE html>
<html>
    <head>
        <title></title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <script src="../../../resources/js/tricon/report_handler.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.min.js"></script>
    </head>
    <body>
        <div id="divMain"></div>
        <script>
            if("<%=msReport%>" == "ml")
                document.getElementById("divMain").innerHTML = printML("<%=msDate%>");
            else if("<%=msReport%>" == "pronens")
                document.getElementById("divMain").innerHTML = printPron("<%=msDate%>");
            else if("<%=msReport%>" == "hispedi")
                document.getElementById("divMain").innerHTML = printHP("<%=msDate%>");
            else
                document.getElementById("divMain").innerHTML = print_daily_html("<%=msPath%>","<%=msReport%>", "<%=msType%>","<%=msDate%>" );
            document.frmMaster.submit();
          
        </script>
    </body>
</html>
