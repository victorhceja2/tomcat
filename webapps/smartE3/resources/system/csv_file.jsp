<%
           response.setContentType("text/csv");
	   response.setHeader("Content-Disposition", "attachment;filename=eYumReport.csv");
           String msDataToExcel = request.getParameter("psExcelData");
           out.write(msDataToExcel);
%>
