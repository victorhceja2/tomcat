<%--
##########################################################################################################
# Nombre Archivo  : SegmentsMainScriptYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Página principal del e-Yum
# Fecha Creacion  : 21/Abril/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
# 
##########################################################################################################
--%>

<%@page contentType="text/html"%>

<%
    String msSegmentId = request.getParameter("psSectionId");
    int moSectionIndex = Integer.parseInt(msSegmentId);
    String msClassColor="";
    String msRptSegment = "";

    switch(moSectionIndex){
        case 30 :   msClassColor="FrameColor"; break;
        case 40 :   msClassColor="PlecasColor2"; break;
        case 50 :   msClassColor="FrameColor"; break;
        case 60 :   msClassColor="PlecasColor2"; break;
    }
%>

<html>
    <body class="<%=msClassColor%>">
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
        <script>
            function setFocus(){
                document.frmMainContainer.txt_buscar.focus();
                loadFirstFab();
            }
        </script>
        <script src="/Scripts/WellcomeContentYum.js"></script>
        <script src="/Scripts/WellcomeArrayYum.js"></script>
        <table name ="tblContent" id="tblContent" cellpadding='1' cellspacing='0' border='0' width='100%' bgcolor = 'gainsboro'>
            <tr class="<%=msClassColor%>">
                <td>
                    <font class="TextBodySmallDesc">
                        <script>
                            <%="displayContent" + msSegmentId + "();" %>
                        </script>
                    </font>
                </td>
            </tr>
        </table>
    </body>
<html>
