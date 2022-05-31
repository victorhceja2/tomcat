<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : HouseholdDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Mostrar el house hold por AGEB. Se puede editar este valor.
# Fecha Creacion  : 16/Enero/2006
# Inc/requires    : ../Proc/HouseholdLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria HouseholdLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>

<%! 
    AbcUtils moAbcUtils;
%>

<% 
    moAbcUtils = new AbcUtils();
%>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/HouseholdLibYum.jsp" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("House Hold", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
    
        <!-- JavaScript Functions only for detail transfers -->
        <script src="../Scripts/HouseholdDetailYum.js"></script>

        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');
        var gaDataset = <%= getDataset() %>; 
        var lfOrigInventoryQty  = 0;
        var lfOrigProviderQty   = 0;
        var loLastObject = null;


        function submitUpdate()
        {
            for(var liRowId=0; liRowId<giNumRows; liRowId++)
            {
                var lsTarget    = "target|"+liRowId;
                var lsHousehold = "household|"+liRowId;
                var lsAgebId    = "ageb|"+liRowId;

                var liHousehold = document.getElementById(lsHousehold).value;
                var liTarget    = document.getElementById(lsTarget).value;
                var lsAgeb      = document.getElementById(lsAgebId).value;

                if(isEmpty(liHousehold))
                {
                    document.getElementById(lsHousehold).value = 0;
                }
                else
                {
                  if (isNaN(Number(liHousehold)) || liHousehold.indexOf(".")!=-1 || parseInt(liHousehold)<0) 
                  {
                     alert ('Ingresar un valor numerico positivo y sin decimales \n para el HouseHold del ageb '+lsAgeb);
                     focusElement(lsHousehold);
                     return(false);
                  }
                }

                if(isEmpty(liTarget))
                {
                    document.getElementById(lsTarget).value = 1;
                }
                else
                {
                    if (isNaN(Number(liTarget)) || liTarget.indexOf(".")!=-1 || parseInt(liTarget)<1) 
                    {
                        alert ('Ingresar un valor mayor de 1 y sin decimales \n para el objetivo del AGEB '+lsAgeb);
                        focusElement(lsTarget);
                        return false;
                    }
                }
            }

            addHidden(document.frmGrid,'numRows',giNumRows);

            document.frmGrid.submit();
        }



        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid('input');">

        <form name="frmGrid" id="frmGrid" method="post" action="SaveChangesYum.jsp">

        <table align="left" width="90%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                <input type="button" value="Guardar cambios" onClick="submitUpdate()">
            </td>
        </tr>
        <tr>
            <td>
                <div id="goDataGrid"></div>
            </td>
        </tr>
        </table>
        </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!
    String getDataset()
    {
        return moAbcUtils.getJSResultSet(getHouseholdEntryQuery());
    }

%>
