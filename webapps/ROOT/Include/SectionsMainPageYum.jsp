<%--
##########################################################################################################
# Nombre Archivo  : SectionsMainPage.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : JSP para generar las secciones de Wellcome Page
# Fecha Creacion  : 23/Abril/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%
    String msSectionId = request.getParameter("psSectionId");
    int miSectionId = Integer.parseInt(msSectionId);
    String msSectionTitle = "";
%>
  
<%
    switch(miSectionId) {
        case 10: msSectionTitle = "Frase de la semana"; break;
        case 20: msSectionTitle = "Varios"; break;
        case 70: msSectionTitle = "Ligas utiles"; break;
        case 100: msSectionTitle = "¿Sabias que?"; break;
    }
%>
    <table cellpadding='0' cellspacing='1' border='0' width='100%' bgcolor = 'gainsboro'>
        <tr class="PlecasColor">
            <td>
                <font class="TextTitlePlecas"><b>&nbsp; <%=msSectionTitle %> </b></font></td>
            </td>
        </tr>
        <script>
            <%="displayContent" + msSectionId + "();" %>
        </script>
    </table>



