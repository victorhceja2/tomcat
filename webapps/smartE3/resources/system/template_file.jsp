<%@page import="java.io.IOException"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%
    
           String msFileName = request.getParameter("psFileName");
           String msSession = request.getSession().getId();
           if(msFileName.toLowerCase().endsWith(".csv")){
                response.setContentType("text/csv");
                response.setHeader("Content-Disposition", "attachment;filename="+msSession+"_"+msFileName);
           }
           else if(msFileName.toLowerCase().endsWith(".xls") || msFileName.toLowerCase().endsWith(".xlt") || msFileName.toLowerCase().endsWith(".xla")){ 
                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment;filename="+msSession+"_"+msFileName);
           }
           else if(msFileName.toLowerCase().endsWith(".xlsx")){ 
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment;filename="+msSession+"_"+msFileName);
           }
            //System.out.println(getServletContext().getRealPath("/")+"resources\\templates\\"+msFileName);
            File loFile = new File(getServletContext().getRealPath("/")+"resources\\templates\\"+msFileName);
            FileInputStream loFileIn = new FileInputStream(loFile);
            ServletOutputStream loOut = response.getOutputStream();

             byte[] buf = new byte[1024];
            int len;
            while ((len = loFileIn.read(buf)) > 0) {
                loOut.write(buf, 0, len);
            }
            loFileIn.close();
            loOut.close();
    

%>
