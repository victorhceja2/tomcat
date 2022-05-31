<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransferLimitsYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sandra Castro
# Objetivo        : Cargar limites de recepciones.
# Fecha Creacion  : 31/ago/06
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>

<%!
	AbcUtils moAbcUtils;
    String lsPrv;
%>

<%
    try
    {
        lsPrv = request.getParameter("providerId");
    }
    catch(Exception e)
    {
        lsPrv = "none";
    }

     moAbcUtils = new AbcUtils();
%>

<html>
    <head>
        <script language="javascript">
            var gaDataset = <%= getDataset(lsPrv) %>;

            function getLimitReception(psProductId)
            {
                var lfLimit = 0;
                if(gaDataset.length > 0)
                {
                    for(liRowId=0; liRowId<gaDataset.length; liRowId++)
                    {
                        var lsProduct = gaDataset[liRowId][0];
                        var lsLimit   = gaDataset[liRowId][1];
                        if(rtrim(ltrim(psProductId)) == rtrim(ltrim(lsProduct)))
                        {
                            lfLimit = parseFloat(lsLimit);
                            break;
                        }
                    }
                }

                return lfLimit;    
            }

            function getDataset()
            {
                return gaDataset;
            }

	function ltrim(str) 
	{ 
		return str.replace(/^[ ]+/, ''); 
	} 
	
	function rtrim(str) 
	{ 
		return str.replace(/[ ]+$/, ''); 
	} 
	
	function trim(str) 
	{ 
		return ltrim(rtrim(str)); 
	} 
        </script>
    </head>
    <body bgcolor="white">
    </body>
</html>

<%!
    String getDataset(String lsPrv)
    {
        String lsQry;

        lsQry = "SELECT trim(provider_product_code), trim(CAST(limit_quantity AS CHAR(8))) FROM op_grl_reception_limits "; 
	//+ "WHERE provider_id='"+lsPrv+"'";
        return moAbcUtils.getJSResultSet( lsQry );
    }
%>
