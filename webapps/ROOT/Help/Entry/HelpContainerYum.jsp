<%--
##########################################################################################################
# Nombre Archivo  : HelpMainPageYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Pagina padre del sistema de ayuda
# Fecha Creacion  : 15/Julio/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%
    String msHelpTopic = request.getParameter("psHelpTopic");
    String msHelpPage = request.getParameter("psHelpPage");
    msHelpTopic = (msHelpTopic!=null)?"(" + msHelpTopic + ")":"";
    msHelpPage = (msHelpPage!=null)?msHelpPage:"";
%>

<html>
    <head>
        <title>Ayuda de e-Yum</title>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
    </head>
    <script src='/Scripts/ReportUtilsYum.js'></script>
    <body onLoad = 'adjustHelpContainer()' onResize = 'adjustHelpContainer()'>
        <style type='text/css'>
            #divHelpBar{position:absolute; visibility:visible; left:1px; top:1px; width:100px; z-index:1}
        </style>

        <div id='divHelpBar' bgcolor = 'navy' style = 'width:3000px; height:10px;'>
            <table bgcolor = 'navy' width = '100%' height = '100%' border = '0'>
                <tr bgcolor = 'navy'>
                    <td class = 'options' width = '98%'>
                        Ayuda <%=msHelpTopic%>
                    </td>
                    <td class = 'littleOptions' align = 'right'>
                        <a class = 'TinyIconMenuLink' href = 'javascript:openHelpWindowAux("<%=msHelpPage %>","VIEWPORT");'><img src = '/Images/Menu/maximize_button.gif' border = '0'></a>
                    </td>
                    <td class = 'littleOptions' align = 'right'>
                        <a class = 'TinyIconMenuLink' href = 'javascript:top.showHideHelpWS("hidden");'><img src = '/Images/Menu/close_button.gif' border = '0'></a>
                    </td>
                </tr>
            </table>
        </div>
        <br>
        <% if (!msHelpPage.equals("")) { %>
            <iframe name = 'ifrCustomHelp' id = 'ifrCustomHelp' src = '<%=msHelpPage %>' style = 'position:absolute; top:23px;' width = '600' height = '120' scrolling = 'auto' frameborder = '0'></iframe>
        <% } else { %>
            <center>
                <br><br>
                <p class = 'mainSubTitle'>No existe ayuda para este contexto.</p>
            </center>
        <% } %>
    </body>
</html>
