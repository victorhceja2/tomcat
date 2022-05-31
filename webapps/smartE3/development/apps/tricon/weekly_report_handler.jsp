<%-- 
    Document   : weekly_report_handler
    Created on : 9/09/2014, 04:09:43 PM
    Author     : DAB1379
--%>
<%
String msPath = request.getParameter("psPath");
String msReport = request.getParameter("psReport");
String msType = request.getParameter("psType");
String msDate = request.getParameter("psDate");
System.out.println(msPath+"|"+msReport+"|"+msType+"|"+msDate);
String msYear =msDate.split("\\.")[0];
String msPeriod =msDate.split("\\.")[2];
String msWeek =msDate.split("\\.")[3];
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
    </head>
    <body>
        <div id="divMain"></div>
        <script>
            if("<%=msReport%>" == "hiswpedi")
                document.getElementById("divMain").innerHTML = printWHP("<%=msYear%>","<%=msPeriod%>","<%=msWeek%>");
            else    
                document.getElementById("divMain").innerHTML = print_weekly_html("<%=msPath%>","<%=msReport%>", "<%=msType%>","<%=msYear%>","<%=msPeriod%>","<%=msWeek%>" );
            document.frmMaster.submit();
        </script>
    </body>
</html>
