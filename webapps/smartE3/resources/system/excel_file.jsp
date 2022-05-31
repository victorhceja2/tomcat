<%
	   response.setContentType("application/vnd.ms-excel");
	   response.setHeader("Content-Disposition", "attachment;filename=eYumReport.xls");
           
           String msDataToExcel = request.getParameter("psExcelData");
           //out.println("Bytes: " + msDataToExcel.length() + "<br><br>");
%>

<html>
    <head>
        <title>Data to excel</title>
    </head>
    <body>
        <%=msDataToExcel %>
    </body>
</html>
