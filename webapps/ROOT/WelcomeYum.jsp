<%--
##########################################################################################################
# Nombre Archivo  : WellcomeYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Página principal del e-Yum
# Fecha Creacion  : 21/Abril/2004
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>

<%
    //if (request.getHeader("user-agent").toLowerCase().indexOf("netscape")!=-1) response.sendRedirect("http://192.168.101.20/Operations/Logon_yum.asp");
%>

<html>
    <head>
        <title>e-Premium Welcome page</title>
        <link rel='stylesheet' href='/CSS/TabStandardsYum.css' type='text/css'>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/WellcomeContentYum.js"></script>
        <script src="/Scripts/WellcomeArrayYum.js"></script>
        <style type='text/css'>
            #divLogin{
                        position:absolute;
                        visibility:hidden;
                        width:300px;
                        height:auto;
                        background-color:#1E0D92;
                        border:4px #ffffff solid;
                        text-align:center;
                        color:white;
                        font-family:Arial;
                        font-size:12pt;
                        filter:alpha(opacity=90);
                        filter:progid:DXImageTransform.Microsoft.Alpha(opacity=90);
                        -moz-opacity:1;
                        z-index:1000;
                    }


           #divMiniHelp {
                        overflow:auto;
                        position:absolute;
                        visibility:hidden;
                        width:500px;
                        height:150px;
                        background-color:#1E0D92;
                        border:1px #ffffff solid;
                        text-align:center;
                        color:white;
                        font-family:Arial;
                        font-size:12pt;
                        filter:alpha(opacity=90);
                        filter:progid:DXImageTransform.Microsoft.Alpha(opacity=90);
                        -moz-opacity:1;
                        z-index:1000;
                    }
        </style>

        <script>

            function setFocus(){
                //document.frmMainContainer.txtSearch.focus();
            }

            function adjustMainContainer() {
                adjustDivSizes();
            }

            function adjustDivSizes() {
                document.getElementById('divLogin').style.left = (Math.round(getWindowWidth()/2) - 135) + 'px';
                document.getElementById('divLogin').style.top = (Math.round(getWindowHeight()/2) - 80) + 'px';
            }

            function adjustDivMiniHelpSize() {
                document.getElementById('divMiniHelp').style.left = getControlXpos('txtSearch') + 'px';
                document.getElementById('divMiniHelp').style.top = getControlYpos('txtSearch') + 40 + 'px';
            }


        </script>
    </head>

    <div id = 'divLogin' name = 'divLogin'>
        <center>
            <form name='frmLogon' method='post' action='/ValidateLogonYum.jsp'>
                      <input type='hidden' name='hidLoginSession'>
                      <input type='hidden' name='hidLoginOptions'>
                <table id = 'tblLogon' border = '0' cellspacing='5'>
                    <tr>
                        <td class='entryOptions'>
                            Usuario:
                        </td>
                        <td>
                            <input type='text' name='txtUser' size='20'>
                        </td>
                    </tr>
                    <tr>
                        <td class = 'entryOptions'>
                            Contraseña:
                        </td>
                        <td>
                            <input type='password' name='txtPassword' size='20'>
                        </td>
                    </tr>
                    <tr>
                        <td align = 'center' colspan = '2'>
                            <input type='submit' value='Accesar' name='cmdAccess'>
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <input type='button' value='Cerrar' name='cmdClose' onclick=hideLoginWindow();>
                        </td>
                    </tr>
                </table>
            </form>
        </center>
    </div>

    <script> adjustMainContainer(); </script>

    <body class='BodyColor' onload='setFocus();' onresize = 'adjustMainContainer()'>
        <center>
            <table id='tblMain'  border = '0' width = '800' cellpadding='1' cellspacing='1' class="TableMainInnerColor">
                <tr valign='top'>
                    <td valign='top'> <!--Carga Principal -->
                        <table id = 'tblMainContainer' border = '0' cellpadding='0' cellspacing='0' width = '800' class="TableMainInnerColor">
                            <tr>
                                <td valign = 'top' colspan='3'>
                                    <jsp:include page = '/Include/SearchMainPageYum.jsp'/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </center>
    </body>
</html>

