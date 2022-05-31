<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<link rel="stylesheet" href="resources/css/showsai.css">
<!DOCTYPE html>
<%
    String msFileName = request.getParameter("psFileName");
    String msHeight = request.getParameter("psHeight");
%>
<html>
    <head>
        <title>Visor PDF</title>
        <style>
            body{
                height: 100%;
            }           
        </style>
    </head>
    <body>
        <embed id="embPDF" class="embPDF" name="embPDF" width="100%" height="100%" src='../../../resources/pdf/<%=msFileName%>' type='application/pdf' />
        <script>
            //document.getElementById("embPDF").style.height=<%=msHeight%>-10+"px";            
        </script>
    </body>
</html>
