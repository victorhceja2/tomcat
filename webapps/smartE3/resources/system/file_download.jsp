<%@page import="java.io.IOException"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%
    
           String msFileName = request.getParameter("psFileName");
           
           String msPath =  request.getParameter("psPath");
           System.out.println(msPath);
           String[] loPath = msPath.split("\\\\");
           msFileName = loPath[loPath.length-1];
           
           String msSession = request.getSession().getId();
           if(msFileName.toLowerCase().endsWith(".csv")){
                response.setContentType("text/csv");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           }
           else if(msFileName.toLowerCase().endsWith(".xls") || msFileName.toLowerCase().endsWith(".xlt") || msFileName.toLowerCase().endsWith(".xla")){ 
                response.setContentType("application/vnd.ms-excel");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           } else if(msFileName.toLowerCase().endsWith(".doc")){ 
                response.setContentType("application/application/msword");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           }
           else if(msFileName.toLowerCase().endsWith(".xlsm")){ 
                response.setContentType("application/vnd.ms-excel.sheet.macroEnabled.12");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           }
           else if(msFileName.toLowerCase().endsWith(".docm")){
               response.setContentType("application/vnd.ms-word.document.macroEnabled.12");
               response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           }
           else if(msFileName.toLowerCase().endsWith(".xlsx")){ 
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           } else if(msFileName.toLowerCase().endsWith(".docx")){ 
                response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           } else if(msFileName.toLowerCase().endsWith(".pdf")){ 
                response.setContentType("application/pdf");
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           }
            else{ 
                response.setHeader("Content-Disposition", "attachment;filename="+msFileName);
           }
            //System.out.println(getServletContext().getRealPath("/")+"resources\\templates\\"+msFileName);
            File loFile = new File(msPath);
            FileInputStream loFileIn = new FileInputStream(loFile);
            ServletOutputStream loOut = response.getOutputStream();
             
            
            byte[] buf = new byte[1024];
            int len;
            while ((len = loFileIn.read(buf)) > 0) {
                loOut.write(buf, 0, len);
            }
            loFileIn.close();
            loOut.close();
            /*
            byte[] outputByte = new byte[4096];
            //copy binary contect to output stream
            while(loFileIn.read(outputByte, 0, 4096) != -1)
            {
                    loOut.write(outputByte, 0, 4096);
            }
            loFileIn.close();
            loOut.flush();
            loOut.close();
    */

%>
